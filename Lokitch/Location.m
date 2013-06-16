//
//  Location.m
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import "Location.h"

@implementation Location

- (id)initWithIdentifier:(NSString *)identifier Name:(NSString *)name {
    if (self = [super init]) {
        _identifier = identifier;
        _name = name;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (!object) {
        return NO;
    }
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    // name could chang but identifier not
    return [self.identifier isEqualTo:[object identifier]];
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

@end
