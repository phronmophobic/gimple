//
//  ConflictViewController.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConflictViewController.h"

@interface ConflictMergeButton : NSButton
{
@private
}
@end

@implementation ConflictMergeButton

-(IBAction)pressed:(id)sender
{
	int a = 0;
	a++;
}

@end

@interface ConflictMineTheirsControl : NSSegmentedControl
{
@private
    
}

@end

@implementation ConflictMineTheirsControl

-(IBAction)pressed:(id)sender
{
	int a = 0;
	a++;
}

@end

@implementation ConflictViewController

@synthesize conflicts;

-(id) initWithConflicts:(NSArray *)_conflicts
{
	if((self = [super init]))
	{
		self.conflicts = _conflicts;
		return self;
	}
	
	return nil;
}

-(void) dealloc
{
	self.conflicts = nil;
}

+(id) createWithConflicts:(NSArray*)_conflicts
{
	return [[ConflictViewController alloc] initWithConflicts:_conflicts];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [conflicts count];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    // get an existing cell with the MyView identifier if it exists
	NSView* result = nil;
	if([tableColumn.identifier isEqualToString:@"MineTheirs"])
		result = [tableView makeViewWithIdentifier:@"MineTheirsCell" owner:self];
	else if([tableColumn.identifier isEqualToString:@"Merge"])
		result = [tableView makeViewWithIdentifier:@"MergeCell" owner:self];
	else if([tableColumn.identifier isEqualToString:@"Filename"])
	{
		result = [tableView makeViewWithIdentifier:@"FilenameCell" owner:self];
		NSTextField* textField = [result.subviews objectAtIndex:0];		
		textField.stringValue = [conflicts objectAtIndex:row];
	}

	// return the result.
	return result;
}

-(IBAction)pressedContinue:(id)sender
{
	[self.view removeFromSuperview];
	[self release];
}

@end
