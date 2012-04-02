//
//  ConflictViewController.m
//  gimple
//
//  Created by Mike on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConflictViewController.h"
#import "Git.h"

typedef enum
{
	kMerged = -1,
	kMine,
	kTheirs,
} ConflictChoice;

@implementation ConflictViewController

@synthesize git;
@synthesize conflicts;

-(id) initWithGit:(Git*)_git
{
	if((self = [super init]))
	{
        self.git = _git;
        [self refresh];
		return self;
	}
	
	return nil;
}

- (void) refresh{
    NSArray* _conflicts = [self.git conflictedFileNames];
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    for(NSString* filename in _conflicts)
    {
        NSMutableDictionary* dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      filename, @"filename",
                                      [NSNumber numberWithInt:kMine], @"choice",
                                      nil] autorelease];
        
        [array addObject:dict];
    }

    self.conflicts = array;
    [conflictView reloadData];
}

-(void) dealloc
{
	self.conflicts = nil;
}

+(id) createWithGit:(Git*)_git
{
	return [[ConflictViewController alloc] initWithGit:_git];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [conflicts count];
}

-(BOOL)conflictFromDict:(NSDictionary*)dict filename:(NSString**)filename choice:(ConflictChoice*)choice
{
	*filename = [dict objectForKey:@"filename"];
	*choice = [[dict objectForKey:@"choice"] intValue];
	
	return YES;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)rowIndex
{
	NSString* filename;
	ConflictChoice choice;
	[self conflictFromDict:[conflicts objectAtIndex:rowIndex] filename:&filename choice:&choice];

	if([tableColumn.identifier isEqualToString:@"MineTheirs"])
	{
		return [NSNumber numberWithInt:choice];
	}
	else if([tableColumn.identifier isEqualToString:@"Filename"])
	{
        return filename;
	}

    return nil;
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:anObject
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{
	NSMutableDictionary* dict = [self.conflicts objectAtIndex:rowIndex];
	if([[aTableColumn identifier] isEqualToString:@"MineTheirs"])
	{
		[dict setValue:anObject forKey:@"choice"];
	}
	else if([[aTableColumn identifier] isEqualToString:@"Merge"])
	{
        [git mergeTool:[dict valueForKey:@"filename"]];
        [self refresh];
	}
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
				[git chooseMine:filename];
				break;
			case kTheirs:
				[git chooseTheirs:filename];
				break;
			case kMerged:
				// Do nothing - already handled.
				break;
		}
	}
    [git commit:@"merge with conflicts"];
	
	[self.view removeFromSuperview];
    [git sync];
	[self release];
}

@end
