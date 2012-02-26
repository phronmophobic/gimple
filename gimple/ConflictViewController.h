//
//  ConflictViewController.h
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Git;

@interface ConflictViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
{
	Git* git;
	NSArray* conflicts;
	IBOutlet NSTableView* conflictView;
}

@property (nonatomic, retain) Git* git;
@property (nonatomic, retain) NSArray* conflicts;

+(id) createWithConflicts:(NSArray*)_conflicts andGit:(Git*)_git;

@end
