//
//  AppDelegate.h
//  gimple
//
//  Created by Adrian Smith on 2/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    IBOutlet NSTextField* reposPathTextField;
	IBOutlet NSTextField* workingOnTextField;
}

@property (assign) IBOutlet NSWindow *window;

@end
