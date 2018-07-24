//
//  DeviceIPAddress.h
//  TestProject
//
//  Created by fb on 2018/6/28.
//  Copyright © 2018 fb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceIPAddress : NSObject
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
