//
//  AppDelegate.h
//  gimple
//
//  Created by Adrian Smith on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Git.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, GitSyncDelegate,NSTextFieldDelegate>{
    IBOutlet NSTextField* reposPathTextField;
	IBOutlet NSTextField* workingOnTextField;
	IBOutlet NSProgressIndicator* progressBar;
	IBOutlet NSTextField* progressStatus;
	
	Git* git;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) Git* git;

@end
