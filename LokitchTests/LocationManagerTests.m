//
//  LocationManagerTests.m
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocationManager.h"
#import "Location.h"

@interface LocationManagerTests : XCTestCase

@end

@interface DoubleDataProvider : NSObject<LocationDataProvider>

@end

@implementation LocationManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)useDoubleDataProvider {
    [LocationManager sharedManager].dataProvider = [[DoubleDataProvider alloc] init];
}

- (void)testLocations {
    [self useDoubleDataProvider];

    NSArray *locations = [[LocationManager sharedManager] locations];
    XCTAssertTrue(locations.count == 3);
    XCTAssertEqualObjects([[Location alloc] initWithIdentifier:@"ID-Default" Name:@"Automatic"], locations[0]);
    XCTAssertEqualObjects([[Location alloc] initWithIdentifier:@"ID-Tatooine" Name:@"Tatooine"], locations[1]);
    XCTAssertEqualObjects([[Location alloc] initWithIdentifier:@"ID-Tython" Name:@"Tython"], locations[2]);
}

- (void)testCurrentLocation {
    [self useDoubleDataProvider];

    LocationManager *locationManager = [LocationManager sharedManager];
    XCTAssertEqualObjects([[Location alloc] initWithIdentifier:@"ID-Default" Name:@"Automatic"], [locationManager currentLocation]);
}

- (void)testSelectLocation {
    [self useDoubleDataProvider];

    LocationManager *locationManager = [LocationManager sharedManager];
    Location *locationTatooine = [[Location alloc] initWithIdentifier:@"ID-Tatooine" Name:@"Tatooine"];
    [locationManager selectLocation:locationTatooine];
    XCTAssertEqualObjects(locationTatooine, [locationManager currentLocation]);
}

@end

#pragma mark - Location Data Provider Double

@interface DoubleDataProvider () {
    NSString *_current;
}
@end

@implementation DoubleDataProvider

- (NSArray *)identifiersAndNames {
    return @[
        @[@"ID-Default",    @"Automatic"],
        @[@"ID-Tatooine",   @"Tatooine"],
        @[@"ID-Tython",     @"Tython"]
    ];
}

- (NSString *)activeIdentifier {
    if (!_current) {
        _current = @"ID-Default";
    }
    return _current;
}

- (void)setActive:(NSString *)identifier {
    for (NSArray *identifierAndName in [self identifiersAndNames]) {
        if ([identifierAndName[0] isEqualToString:identifier]) {
            _current = identifier;
        }
    }
}

@end
