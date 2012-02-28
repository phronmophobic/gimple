//
//  git.h
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	kNew,
	kDeleted,
	kChanged,
	kMoved,
} ModType;

@interface Modification : NSObject
{
	NSString* filename;
	ModType type;
}

@end

@interface Git : NSObject
{

    NSString* repositoryPath;
	NSThread* thread;
}

- (id) initWithRepositoryPath:(NSString*)repositoryPath_;
-(NSString*) push;
-(NSString*) pull;
-(void) commit:(NSString*)message;
-(NSArray*) conflictedFileNames;
- (NSString*) gitWithArg:(NSString*)arg;
- (NSString*) gitWithArray:(NSArray*) arr;
- (NSString*) gitWithArgs:(NSString*)arg1,... NS_REQUIRES_NIL_TERMINATION;

-(NSArray*) getChanges; // Returns NSArray of Modifications of all files changed locally.

-(BOOL) chooseMine:(NSString*)filename;
-(BOOL) chooseTheirs:(NSString*)filename;
-(void) mergeTool:(NSString*)filename;

@property (nonatomic, retain) NSString* repositoryPath;
@property (nonatomic, retain) NSThread* thread;

@end
