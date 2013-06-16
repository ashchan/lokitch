//
//  LocationManager.m
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import "LocationManager.h"
#import "Location.h"

@interface LocationManager ()
@end

@interface ScselectDataProvider : NSObject<LocationDataProvider>
@end

@implementation LocationManager

+ (LocationManager *)sharedManager {
    static LocationManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[LocationManager alloc] init];
    });
    return sharedManager;
}

- (NSArray *)locations {
    [self useDefaultDataProvider];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSArray *identifierAndName in [self.dataProvider identifiersAndNames]) {
        [results addObject:[[Location alloc] initWithIdentifier:identifierAndName[0] Name:identifierAndName[1]]];
    }
    return results;
}

- (Location *)currentLocation {
    [self useDefaultDataProvider];
    for (Location *location in [self locations]) {
        if ([location.identifier isEqualToString:[self currentLocationIdentifier]]) {
            return location;
        }
    }
    return nil;
}

- (void)selectLocation:(Location *)location {
    [self useDefaultDataProvider];
    [self.dataProvider setActive:location.identifier];
}

#pragma mark - Priviate Methods

- (void)useDefaultDataProvider {
    if (!self.dataProvider) {
        self.dataProvider = [[ScselectDataProvider alloc] init];
    }
}

- (NSString *)currentLocationIdentifier {
    return [self.dataProvider activeIdentifier];
}

@end

#pragma mark - Default Data Provider

@implementation ScselectDataProvider {
    NSMutableArray  *_identifiersAndNames;
    NSString        *_activeIdentifier;
}

- (NSArray *)identifiersAndNames {
    if (!_identifiersAndNames) {
        _identifiersAndNames = [[NSMutableArray alloc] init];

        NSString *data = [self runCommandWithArgement:nil];
        NSArray *lines = [data componentsSeparatedByString:@"\n"];
        NSRange range;
        range.location = 1;
        range.length = lines.count - 2;

        for (NSString *line in [lines subarrayWithRange:range]) {
            NSArray *scselectLine = [self parseScselectLine:line];
            [_identifiersAndNames addObject:@[scselectLine[0], scselectLine[1]]];
        }
    }
    return _identifiersAndNames;
}

- (NSString *)activeIdentifier {
    return _activeIdentifier;
}

- (void)setActive:(NSString *)identifier {
    [self runCommandWithArgement:identifier];
}

- (NSArray *)parseScselectLine:(NSString *)line {
    //   6EE0F81F-BB06-4A68-A316-C5EBDD48F200	(Automatic)
    // * 6EE0F81F-BB06-4A68-A316-C5EBDD48F200	(Automatic)
    NSArray *tokens         = [line componentsSeparatedByString:@"\t"];
    NSString *identifier    = [[tokens[0] componentsSeparatedByString:@" "] lastObject];
    NSString *name          = [tokens[1] substringWithRange:NSMakeRange(1, [tokens[1] length] - 2)];
    BOOL isActive           = [tokens[0] rangeOfString:@"*"].location != NSNotFound;
    return @[identifier, name, @(isActive)];
}

- (NSString *)runCommandWithArgement:(NSString *)argument {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/sbin/scselect"];
    if (argument) {
        [task setArguments:@[argument]];
    }

    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];

    NSFileHandle *fileHandle = [pipe fileHandleForReading];

    [task launch];

    NSData *data = [fileHandle readDataToEndOfFile];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
