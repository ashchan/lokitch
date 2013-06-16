//
//  LocationTests.m
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Location.h"

@interface LocationTests : XCTestCase

@end

@implementation LocationTests

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

- (void)testEqual {
    XCTAssertEqualObjects([[Location alloc] initWithIdentifier:@"ID-1" Name:@"Name1"],
                          [[Location alloc] initWithIdentifier:@"ID-1" Name:@"Name1"]);
    XCTAssertEqualObjects([[Location alloc] initWithIdentifier:@"ID-1" Name:@"Name1"],
                          [[Location alloc] initWithIdentifier:@"ID-1" Name:@"Name2"],
                          @"Only identifier is checked for equality.");
    XCTAssertFalse([[[Location alloc] initWithIdentifier:@"ID-1" Name:@"Name1"] isEqual:[[Location alloc] initWithIdentifier:@"ID-2" Name:@"Name1"]]);
}

@end
