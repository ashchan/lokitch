//
//  WLANManager.m
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import "WLANManager.h"
#import <CoreWLAN/CoreWLAN.h>

NSString *const WLMSSIDDidChangeNotification = @"WLMSSIDDidChangeNotification";

@interface WLANManager ()
@property (retain) CWInterface *interface;
@end

@implementation WLANManager

+ (WLANManager *)sharedManager {
    static WLANManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WLANManager alloc] init];
    });
    return manager;
}

- (id)init {
    if (self = [super init]) {
        self.interface = [CWInterface interface]; // FIXME: ensure getting the proper WLAN interface
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ssidDidChanged:) name:CWBSSIDDidChangeNotification object:nil];
    }
    return self;
}

- (NSString *)ssid {
    return [CWInterface interface].ssid;
}

- (void)ssidDidChanged:(NSNotification *)aNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:WLMSSIDDidChangeNotification object:nil];
}

@end
