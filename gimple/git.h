//
//  git.h
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface git : NSObject{

}

-(NSString*) push;
-(NSString*) pull;
-(NSString*) commit:(NSString*)message;
- (NSString*) gitWithArg:(NSString*)arg;
- (NSString*) gitWithArray:(NSArray*) arr;
- (NSString*) gitWithArgs:(NSString*)arg1,...;
-(void) getLatest;
-(void) pushChanges;
-(void) cloneRepo;

@end
