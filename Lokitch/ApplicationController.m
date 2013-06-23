//
//  ApplicationController.m
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import "ApplicationController.h"
#import "WLANManager.h"
#import "LocationManager.h"

NSString *const ConfigKeySSIDs = @"ConfigKeySSIDs";

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
        NSString *locationIdentifier = [self fetchLocationIdentifierForSsid:ssid];
        Location *location = [[LocationManager sharedManager] findLocationByIdentifier:locationIdentifier];
        if (location && location != [[LocationManager sharedManager] currentLocation]) {
            [[LocationManager sharedManager] selectLocation:location];
        }
    }
}

- (NSString *)fetchLocationIdentifierForSsid:(NSString *)ssid {
    NSDictionary *configuration = [self ssidConfiguration];
    if (ConfigKeySSIDs) {
        return configuration[ssid];
    } else {
        return nil;
    }
}

- (void)setLocationIdentifierForSsid:(NSString *)ssid identifier:(NSString *)identifier {
    NSDictionary *configuration = [self ssidConfiguration];
    NSMutableDictionary *writer = [configuration mutableCopy];
    if (!writer) {
        writer = [[NSMutableDictionary alloc] init];
    }
    writer[ssid] = identifier;
    [[NSUserDefaults standardUserDefaults] setObject:writer forKey:ConfigKeySSIDs];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)ssidConfiguration {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:ConfigKeySSIDs];
}

@end
