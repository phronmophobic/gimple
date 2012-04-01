//
//  git.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Git.h"

@interface Git(Private)
- (NSString*) gitWithArray:(NSArray*) args;

@end

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

-(NSString*) systemCommand:(NSString*)command
                    curDir:(NSString*)curDir
                      args:(NSArray*)args
{

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

    [task release];
    
    return string;
	
//	[self performSelectorOnMainThread:@selector(sysCommandComplete:) withObject:string waitUntilDone:YES];
	

}

//-(void) sysCommandComplete: (NSString*)string
//{
//	NSLog(@"Success! %@", string);
//}

- (NSString*) gitWithArray:(NSArray*) args{
    //	NSDictionary* dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
    //							[self gitExe], @"command",
    //							repositoryPath, @"curDir",
    //							args, @"args",
    //						 nil] autorelease];
	
    //	[self performSelector:@selector(systemCommand:) onThread:thread withObject:dict waitUntilDone:NO];
	return [self systemCommand:@"/usr/bin/git" curDir:repositoryPath args:args];
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

	return [self gitWithArray:argArr];
//	[self performSelector:@selector(gitWithArray:) onThread:thread withObject:argArr waitUntilDone:NO];
//	return nil;

//    return [self gitWithArray:argArr];
}

-(NSString*) gitExe
{
	return @"/usr/bin/git";
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
-(bool) push{
    
    NSString* output =  [self gitWithArgs:@"push",@"origin",@"HEAD",nil];
    for ( NSString* line in [output componentsSeparatedByString:@"\n"]){
        if ( [line hasPrefix:@"!"]){
            return false;
        }
    }
    return true;
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

-(BOOL) hasConflicts{
    return [[self conflictedFileNames] count] > 0;
}

-(BOOL) hasChanges{
    return [[self getChanges] count] > 0;
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

-(void)setProgress:(double)progress andStatus:(NSString*)status
{
	[progressDelegate performSelectorOnMainThread:@selector(setStatus:) withObject:status waitUntilDone:NO];
	[progressDelegate performSelectorOnMainThread:@selector(setProgress:) withObject:[NSNumber numberWithDouble:progress] waitUntilDone:NO];
}

-(void)asyncSync
{
    //     NSArray* conflictedFiles = [self conflictedFileNames];
    // if ( [conflictedFiles count] > 0){
    //     	[syncDelegate performSelectorOnMainThread:@selector(syncConflicts:) withObject:conflictedFiles waitUntilDone:NO];		
    // }else{
		
    //     [self getChanges];
        
    //     [self commit:commitMsg];
    //     [self pull];
    //     conflictedFiles = [self conflictedFileNames];
    //     if ( [conflictedFiles count] > 0){
    //     		[syncDelegate performSelectorOnMainThread:@selector(syncConflicts:) withObject:conflictedFiles waitUntilDone:YES];
    //     }else{
    //         [self push];        
    //     		[syncDelegate performSelectorOnMainThread:@selector(syncComplete) withObject:nil waitUntilDone:YES];
    //     }
    // }
	
//	[syncDelegate performSelectorOnMainThread:@selector(syncError) withObject:nil waitUntilDone:YES];
    
    if ( [self hasConflicts]){
        NSLog(@"== Need to resolve Conflicts ==");
		[self setProgress:0.0 andStatus:@"Need to resolve conflicts."];
        [syncDelegate performSelectorOnMainThread:@selector(syncConflicts) withObject:nil waitUntilDone:NO];
    }else if ( [self hasChanges] ){
        NSLog(@"== Need to make a commit ==");
		[self setProgress:25.0 andStatus:@"Committing changes."];
        [syncDelegate performSelectorOnMainThread:@selector(makeCommit) withObject:nil waitUntilDone:YES];
    }else{// no changes
        NSLog(@"== Pulling... ==");
		[self setProgress:50.0 andStatus:@"Pulling changes."];

        [self pull];
        if ( [self hasConflicts] ){
            NSLog(@"== Pull and there are conflicts. Need to resolve conflicts ==");
			[self setProgress:75.0 andStatus:@"Need to resolve conflicts."];
            [syncDelegate performSelectorOnMainThread:@selector(syncConflicts) withObject:nil waitUntilDone:NO];
        }else{
            NSLog(@"== Push ==");
			[self setProgress:75.0 andStatus:@"Pushing changes."];
            bool success = [self push];
            NSLog(@"push success: %d", success);
			[self setProgress:100.0 andStatus:@"Sync complete!"];
        }
    }
    
}

-(void)sync
{
	[self performSelector:@selector(asyncSync) onThread:thread withObject:nil waitUntilDone:NO];
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
