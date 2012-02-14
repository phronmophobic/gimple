//
//  ConflictViewController.h
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConflictViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
{
	IBOutlet NSTableView* tableView;
	NSArray* conflicts;
}

@property (nonatomic, retain) NSArray* conflicts;

+(id) createWithConflicts:(NSArray*)_conflicts;

@end
