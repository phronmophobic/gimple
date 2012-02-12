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
}



-(NSString*) push;
-(NSString*) pull;
-(void) commit:(NSString*)message;
-(NSArray*) conflictedFileNames;
- (NSString*) gitWithArg:(NSString*)arg;
- (NSString*) gitWithArray:(NSArray*) arr;
- (NSString*) gitWithArgs:(NSString*)arg1,... NS_REQUIRES_NIL_TERMINATION;

-(NSArray*) getChanges; // Returns NSArray of Modifications of all files changed locally.
-(void) commitChanges:(NSString*)message; // Commits changes to local repository with <message>.
-(NSArray*) getLatest; // git pulls and returns list of Modifications.
-(void) cloneRepo;

@property (nonatomic, retain) NSString* repositoryPath;
@end
