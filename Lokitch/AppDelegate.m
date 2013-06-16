//
//  AppDelegate.m
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import "AppDelegate.h"
#import "ApplicationController.h"

@implementation AppDelegate {
    ApplicationController *_appController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _appController = [[ApplicationController alloc] init];
}

@end
