//
//  LocationManager.h
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;

@protocol LocationDataProvider <NSObject>
- (NSArray *)identifiersAndNames;
- (NSString *)activeIdentifier;
- (void)setActive:(NSString *)identifier;
@end

@interface LocationManager : NSObject

@property (strong) id<LocationDataProvider> dataProvider;

+ (LocationManager *)sharedManager;

- (NSArray *)locations;
- (Location *)currentLocation;
- (void)selectLocation:(Location *)location;

@end
