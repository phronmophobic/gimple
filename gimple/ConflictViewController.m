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

-(void) dealloc
{
	self.conflicts = nil;
	[tableView release];
}

+(id) createWithConflicts:(NSArray*)_conflicts
{
	return [[ConflictViewController alloc] initWithConflicts:_conflicts];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [conflicts count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSCell* cell = [[[NSCell alloc] initTextCell:[conflicts objectAtIndex:row]] autorelease];
	return cell;
}

-(IBAction)pressedSegment:(id)sender
{
	NSSegmentedCell* cell = [sender selectedCell];
	NSInteger clickedSegment = [cell selectedSegment];
	
	NSInteger row = [sender selectedRow];
	NSLog(@"Mine: %@\n", [conflicts objectAtIndex:row]);
}

-(IBAction)pressedMerge:(id)sender
{
	NSInteger row = [sender selectedRow];
	NSLog(@"Merge: %@\n", [conflicts objectAtIndex:row]);
}

-(IBAction)pressedContinue:(id)sender
{
	[self.view removeFromSuperview];
	[self release];
}

@end
