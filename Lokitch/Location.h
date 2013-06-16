//
//  Location.h
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (strong, readonly) NSString *identifier;
@property (strong, readonly) NSString *name;

- (id)initWithIdentifier:(NSString *)identifier Name:(NSString *)name;

@end
