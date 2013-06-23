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
#import "Location.h"

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
        if (location && ![location isEqual:[[LocationManager sharedManager] currentLocation]]) {
            [[LocationManager sharedManager] selectLocation:location];
            NSLog(@"Switched to location: %@ for SSID: %@", [location name], ssid);
        }
    }
}

- (NSString *)fetchLocationIdentifierForSsid:(NSString *)ssid {
    NSArray *configuration = [self ssidConfiguration];
    for (NSDictionary *item in configuration) {
        if ([ssid isEqualToString:item[@"ssid"]]) {
            return item[@"location"];
        }
    }

    return nil;
}

- (void)setLocationIdentifier:(NSString *)identifier forSsid:(NSString *)ssid {
    NSArray *configuration = [self ssidConfiguration];
    NSMutableArray *writer = [configuration mutableCopy];
    if (!writer) {
        writer = [[NSMutableArray alloc] init];
    }

    NSMutableDictionary *item   = [[NSMutableDictionary alloc] init];
    item[@"ssid"]               = ssid;
    item[@"location"]           = identifier;

    NSUInteger exisitingItemIndex = [configuration indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [ssid isEqualToString:obj[@"ssid"]];
    }];
    if (exisitingItemIndex != NSNotFound) {
        writer[exisitingItemIndex] = item;
    } else {
        [writer addObject:item];
    }

    [[NSUserDefaults standardUserDefaults] setObject:writer forKey:ConfigKeySSIDs];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)ssidConfiguration {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:ConfigKeySSIDs];
}

@end
