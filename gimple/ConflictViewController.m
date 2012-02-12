//
//  ConflictViewController.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConflictViewController.h"

@implementation ConflictViewController

@synthesize conflicts;

-(id) initWithConflicts:(NSArray *)_conflicts
{
	if((self = [super init]))
	{
		self.conflicts = _conflicts;
		[tableView setDataSource:self];
		[tableView reloadData];
		return self;
	}
	
	return nil;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [conflicts count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [[NSCell alloc] initTextCell:@"Test"];
}

@end
