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

- (void) dealloc{

    [repositoryPath release];
    [super dealloc];
}

- (id) initWithRepositoryPath:(NSString*)repositoryPath_{

    self = [super init];
    if ( self ){
        self.repositoryPath = repositoryPath_;
    }

    return self;
}


-(NSString*) systemCommand:(NSString*)command curDir:(NSString*)curDir args:(NSArray*)args
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
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"returned:\n%@", string);
	
    [task release];
    return [string autorelease];
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
}

- (NSString*) gitWithArray:(NSArray*) args{
	return [self systemCommand:@"/usr/bin/git" curDir:repositoryPath args:args];
}

- (NSString*) gitWithArg:(NSString*)arg{
    return [self gitWithArray:[NSArray arrayWithObject:arg]];
}

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
	[filenames addObject:@"Testies!"];
    return [filenames allObjects];
}


@end
