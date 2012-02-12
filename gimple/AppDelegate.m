//
//  AppDelegate.m
//  gimple
//
//  Created by Adrian Smith on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Git.h"
#import "ConflictViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}





-(IBAction) sync:(id)sender
{
    Git* g = [[[Git alloc] init] autorelease];
	
	[g getChanges];
	
    [g commit:@"message"];
    [g pull];
    NSArray* conflictedFiles = [g conflictedFileNames];
    if ( [conflictedFiles count] == 0){
        
        [g push];        
    }else{
		ConflictViewController* vc = [[[ConflictViewController alloc] initWithConflicts:conflictedFiles] autorelease];
		[vc retain];
		[self.window.contentView addSubview:vc.view];
        NSLog(@"conflicted:%@", [g conflictedFileNames]);
    }
}

@end
