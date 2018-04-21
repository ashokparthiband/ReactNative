//
//  BLEUtil.h
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 14/04/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBService;
@class CBCharacteristic;
@class ScannedResult;

@interface BLEUtil : NSObject

+ (NSArray *) getAllServices;
+ (NSArray *) getAllCharacteristicsForService:(CBService *) service;
+ (NSArray <CBCharacteristic *>*) getCharacteristicforService:(CBService *) service inDevice : (ScannedResult *) device;
+ (void) updateDevice : (ScannedResult *) device forCharacteristic : (CBCharacteristic *) characteristic;

@end
