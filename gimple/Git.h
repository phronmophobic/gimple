//
//  git.h
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GitProgressDelegate <NSObject>

-(void) setProgress:(NSNumber*)progress;
-(void) setStatus:(NSString*)status;

@end
typedef NSObject<GitProgressDelegate> GitProgressDelegate;

@protocol GitSyncDelegate <NSObject>

-(void) syncError;
-(void) syncComplete;
-(void) syncConflicts:(NSArray*)conflicts;

@end
typedef NSObject<GitSyncDelegate> GitSyncDelegate;

@interface Git : NSObject
{
    NSString* repositoryPath;
	NSThread* thread;
	GitSyncDelegate* syncDelegate;
	GitProgressDelegate* progressDelegate;
}

@property (nonatomic, retain) NSString* repositoryPath;
@property (nonatomic, retain) NSThread* thread;
@property (nonatomic, retain) GitSyncDelegate* syncDelegate;
@property (nonatomic, retain) GitProgressDelegate* progressDelegate;

-(id) initWithRepositoryPath:(NSString*)repositoryPath_;

-(void) sync:(NSString*)commitMsg;

-(BOOL) chooseMine:(NSString*)filename;
-(BOOL) chooseTheirs:(NSString*)filename;
-(void) mergeTool:(NSString*)filename;

@end
