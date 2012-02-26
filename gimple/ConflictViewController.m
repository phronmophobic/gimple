//
//  ConflictViewController.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConflictViewController.h"

typedef enum
{
	kMine,
	kTheirs,
	kMerged,
} ConflictChoice;

@implementation ConflictViewController

@synthesize git;
@synthesize conflicts;

-(id) initWithConflicts:(NSArray *)_conflicts andGit:(Git*)_git
{
	if((self = [super init]))
	{
		NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
		for(NSString* filename in _conflicts)
		{
			NSDictionary* dict = [[[NSDictionary alloc] initWithObjectsAndKeys:
										  @"filename", filename, 
										  @"choice", [NSNumber numberWithInt:kMine],
										  nil] autorelease];

			[array addObject:dict];
		}
		self.git = _git;
		self.conflicts = array;
		return self;
	}
	
	return nil;
}

-(void) dealloc
{
	self.conflicts = nil;
}

+(id) createWithConflicts:(NSArray*)_conflicts andGit:(Git*)_git
{
	return [[ConflictViewController alloc] initWithConflicts:_conflicts andGit:_git];
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
	for(NSDictionary* dict in self.conflicts)
	{
		NSString* filename = [dict valueForKey:@"filename"];
		ConflictChoice choice = [[dict valueForKey:@"choice"] intValue];
		
		switch(choice)
		{
			case kMine:
				// git checkout --ours <filename>
				break;
			case kTheirs:
				// git checkout --theirs <filename>
				break;
			case kMerged:
				// Do nothing - already handled.
				break;
		}
	}

	[self.view removeFromSuperview];
	[self release];
}

@end
