//
//  git.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "git.h"

@implementation git


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
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/git"];
    [task setCurrentDirectoryPath:@"/Users/adrian/workspace/gimple-test/"];


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

- (NSString*) gitWithArg:(NSString*)arg{
    return [self gitWithArray:[NSArray arrayWithObject:arg]];
}

-(NSString*) commit:(NSString*)message{
    return [self gitWithArgs:@"commit",@"-am",message,nil];
}
-(NSString*) pull{
    return [self gitWithArgs:@"pull",nil];
}
-(NSString*) push{
    return [self gitWithArgs:@"push",nil];
}


@end
