//
//  BLEUtil.m
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 14/04/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "BLEUtil.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEConstants.h"
#import "ScannedResult.h"

@implementation BLEUtil

+ (NSArray *) getAllServices {
  NSArray * arrServices = @[[CBUUID UUIDWithString:HeartRateInfoService]]; //[CBUUID UUIDWithString:DeviceBasicInfoService],
  return arrServices;
}

+ (NSArray *) getAllCharacteristicsForService:(CBService *) service {
  NSArray * chars = nil;
  NSString * strUUID = [service.UUID UUIDString];
  if ([strUUID isEqualToString:DeviceBasicInfoService])
  {
    chars = @[
              [CBUUID UUIDWithString:DeviceBasicCharHardWareVersion],
              [CBUUID UUIDWithString:DeviceBasicCharSoftWareVersion],
              [CBUUID UUIDWithString:DeviceBasicCharFirmWareVersion],
              [CBUUID UUIDWithString:DeviceBasicCharManufacturerName]
            ];
  }
  else if ([strUUID isEqualToString:HeartRateInfoService])
  {
    chars = @[
              [CBUUID UUIDWithString:HeartRateInfoCharHeartRatePoint],
              [CBUUID UUIDWithString:HeartRateInfoCharBodySensorLocation],
              [CBUUID UUIDWithString:HeartRateInfoCharBodyHeartRateMeasurement]
              ];
  }
  return chars;
}

+ (NSArray <CBCharacteristic *>*) getCharacteristicforService:(CBService *) service inDevice : (ScannedResult *) device {
  NSArray * chars = nil;
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"UUID = %@",service.UUID];
  NSArray * result = [device.peripheral.services filteredArrayUsingPredicate:predicate];
  CBService * service1 = result.firstObject;
  chars = service1.characteristics;
  return chars;
}

@end
