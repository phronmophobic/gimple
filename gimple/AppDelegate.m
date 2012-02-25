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
    NSString* path = [[NSUserDefaults standardUserDefaults] valueForKey:@"repositoryPath"];
    if ( !path ){
        path = @"/Users/adrian/workspace/gimple-test";
    }
    // Insert code here to initialize your application
    [reposPathTextField setTitleWithMnemonic:path];

}

- (IBAction)updateRepositoryPath:(id)sender{
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseFiles:NO];
    [panel setMessage:@"Choose the git repository path"];
    
    // Display the panel attached to the document's window.
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL* url = [[panel URLs] objectAtIndex:0];
            [reposPathTextField setTitleWithMnemonic:[url path]];
            [[NSUserDefaults standardUserDefaults] setValue:[url path] forKey:@"repositoryPath"];
        }
        
    }];
}

-(NSString*) commitMessage
{
	// This could pop up a message box if the Working on field isn't set.
	return ([workingOnTextField.stringValue length] == 0) ? @"Working on message not set." : workingOnTextField.stringValue;
}

-(IBAction) sync:(id)sender
{
    Git* g = [[[Git alloc] initWithRepositoryPath:[reposPathTextField stringValue]] autorelease];
	
	[g getChanges];
	
    [g commit:[self commitMessage]];
    [g pull];
    NSArray* conflictedFiles = [g conflictedFileNames];
    if ( [conflictedFiles count] == 0){
        
        [g push];        
    }else{
		ConflictViewController* vc = [ConflictViewController createWithConflicts:conflictedFiles];
		[self.window.contentView addSubview:vc.view];
        NSLog(@"conflicted:%@", [g conflictedFileNames]);
    }
}

@end
