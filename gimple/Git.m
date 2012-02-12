//
//  git.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Git.h"

@implementation Git

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
	return [self systemCommand:@"/usr/bin/git" curDir:@"/Users/adrian/workspace/gimple-test/" args:args];
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
    return [filenames allObjects];
}


@end
