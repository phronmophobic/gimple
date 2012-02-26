//
//  ConflictViewController.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConflictViewController.h"

static int segment = 0;

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

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)rowIndex
{
    id theRecord, theValue;
    

	if([tableColumn.identifier isEqualToString:@"MineTheirs"])
		return nil;
	else if([tableColumn.identifier isEqualToString:@"Merge"]){
		return [NSNumber numberWithInt:segment];

    
	}else if([tableColumn.identifier isEqualToString:@"Filename"])
	{
        return @"filename";
        
	}
    return theValue;
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{

    segment = [anObject intValue];
    return;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    return YES;
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    
    return;
}
-(IBAction)pressedContinue:(id)sender
{
	[self.view removeFromSuperview];
	[self release];
}

@end
