//
//  AppDelegate.m
//  gimple
//
//  Created by Adrian Smith on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "git.h"

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





-(IBAction) pushedTheOne:(id)sender
{
    [[[git alloc] init] gitWithArgs:@"status",nil];
        
}

@end
