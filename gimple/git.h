//
//  git.h
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface git : NSObject

-(void) getLatest;
-(void) pushChanges;
-(void) cloneRepo;

@end
