//
//  ApplicationController.m
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import "ApplicationController.h"
#import "WLANManager.h"

@implementation ApplicationController

- (id)init {
    if (self = [super init]) {
        [self switchLocation];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ssidDidChanged:) name:WLMSSIDDidChangeNotification object:nil];
    }
    return self;
}

- (void)ssidDidChanged:(NSNotification *)aNotification {
    [self switchLocation];
}

- (void)switchLocation {
    NSString *ssid = [[WLANManager sharedManager] ssid];
    if (ssid) {
        //TODO
    }
}

@end
