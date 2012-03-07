//
//  git.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Git.h"

@implementation Git
@synthesize repositoryPath;
@synthesize thread;
@synthesize syncDelegate;
@synthesize progressDelegate;

- (void) dealloc{

    [repositoryPath release];
    [super dealloc];
}

- (id) initWithRepositoryPath:(NSString*)repositoryPath_{

    self = [super init];
    if ( self ){
        self.repositoryPath = repositoryPath_;
		self.thread = [[[NSThread alloc] initWithTarget:self selector:@selector(threadMain) object:nil] autorelease];
		[self.thread start];
    }

    return self;
}

-(void) threadMain
{
	[[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
	CFRunLoopRun();
}

-(void) systemCommand:(NSDictionary*)params
{
	NSString* command = [params objectForKey:@"command"];
	NSString* curDir = [params objectForKey:@"curDir"];
	NSArray* args = [params objectForKey:@"args"];

	NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:command];
    [task setCurrentDirectoryPath:curDir];	
	
    [task setArguments: args];
	
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
	
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
	
    [task launch];
	
    NSData *data;
    data = [file readDataToEndOfFile];
	
    NSString *string;
    string = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    NSLog (@"returned:\n%@", string);
	
	[self performSelectorOnMainThread:@selector(sysCommandComplete:) withObject:string waitUntilDone:YES];
	
    [task release];
}

-(void) sysCommandComplete: (NSString*)string
{
	NSLog(@"Success! %@", string);
}

- (NSString*) gitWithArgs:(NSString*)arg1,...{
    va_list args;
    va_start(args, arg1);

    NSMutableArray* argArr = [NSMutableArray arrayWithObject:arg1];

    int watchdog = 0;
    NSString* arg = nil;
    while( (arg = va_arg( args, NSString * )) ){
        [argArr addObject:arg];

        if ( watchdog++ > 50 ){
            @throw @"you probably forgot to nil terminate";
        }
    }

	[self gitWithArray:argArr];
//	[self performSelector:@selector(gitWithArray:) onThread:thread withObject:argArr waitUntilDone:NO];
	return nil;

//    return [self gitWithArray:argArr];
}

-(NSString*) gitExe
{
	return @"/usr/bin/git";
}

- (void) gitWithArray:(NSArray*) args{
	NSDictionary* dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
							[self gitExe], @"command",
							repositoryPath, @"curDir",
							args, @"args",
						 nil] autorelease];
	
	[self performSelector:@selector(systemCommand:) onThread:thread withObject:dict waitUntilDone:NO];
//	return [self systemCommand:@"/usr/bin/git" curDir:repositoryPath args:args];
}

//- (NSString*) gitWithArg:(NSString*)arg{
//    return [self gitWithArgs:arg, nil];
//}

-(void) commit:(NSString*)message{
    [self gitWithArgs:@"add",@"--all",nil];
    [self gitWithArgs:@"commit",@"-m",message,nil];
}
-(NSString*) pull{
    return [self gitWithArgs:@"pull",nil];
}
-(NSString*) push{
    return [self gitWithArgs:@"push",nil];
}

-(NSArray*) getChanges{
    NSMutableArray* changes = [[[NSMutableArray alloc] init] autorelease];
    NSString* response = [self gitWithArgs:@"status", @"--porcelain", nil];
    NSArray* files = [response componentsSeparatedByString:@"\n"];
	
    for(NSString* str in files){
        if([str length] == 0)
            continue;
		
        NSString* filename = [str substringFromIndex:3];
        [changes addObject:filename];
        NSLog(@"Filename: %@\n", filename);
    }
	
    return changes;
}

-(NSArray*) conflictedFileNames{
    NSString* output = [self gitWithArgs:@"ls-files",@"-u",nil];
    NSMutableSet* filenames = [NSMutableSet set];
	
    for ( NSString* line in [output componentsSeparatedByString:@"\n"]){
        if ( [line length] > 0 ){
            NSString* filename = [[line componentsSeparatedByString:@"\t"] objectAtIndex:1];
            NSLog(@"filename: \"%@\"",filename);
            [filenames addObject:filename];
        }
    }
	
//	[filenames addObject:@"Conflict1"];
//	[filenames addObject:@"Conflict2"];
//	[filenames addObject:@"Conflict3"];
	
    return [filenames allObjects];
}

-(void)asyncSync:(NSString*)commitMsg
{
	NSArray* conflictedFiles = [self conflictedFileNames];
    if ( [conflictedFiles count] > 0){
		[syncDelegate performSelectorOnMainThread:@selector(syncConflicts:) withObject:conflictedFiles waitUntilDone:YES];		
    }else{
		
        [self getChanges];
        
        [self commit:commitMsg];
        [self pull];
        conflictedFiles = [self conflictedFileNames];
        if ( [conflictedFiles count] > 0){
			[syncDelegate performSelectorOnMainThread:@selector(syncConflicts:) withObject:conflictedFiles waitUntilDone:YES];
        }else{
            [self push];        
			[syncDelegate performSelectorOnMainThread:@selector(syncComplete) withObject:nil waitUntilDone:YES];
        }
    }
	
	// Shouldn't be able to get here, but just in case:
	[syncDelegate performSelectorOnMainThread:@selector(syncError) withObject:nil waitUntilDone:YES];
}

-(void)sync:(NSString*)commitMsg
{
	[self performSelector:@selector(asyncSync:) onThread:thread withObject:commitMsg waitUntilDone:NO];
}

-(BOOL) chooseMine:(NSString*)filename
{
	[self gitWithArgs:@"checkout", @"--ours", filename, nil];
	return YES;
}

-(BOOL) chooseTheirs:(NSString*)filename
{
	[self gitWithArgs:@"checkout", @"--theirs", filename, nil];
	return YES;
}

-(void) mergeTool:(NSString*)filename
{
    [self gitWithArgs:@"mergetool",@"-y", filename, nil];
}

@end
