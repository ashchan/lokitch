//
//  WLANManager.h
//  Lokitch
//
//  Created by James Chen on 6/16/13.
//  Copyright (c) 2013 ashchan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const WLMSSIDDidChangeNotification;

@interface WLANManager : NSObject

+ (WLANManager *)sharedManager;

- (NSString *)ssid;

@end
