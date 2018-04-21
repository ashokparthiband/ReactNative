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
#import <React/RCTLog.h>

@implementation BLEUtil

+ (NSArray *) getAllServices {
  NSArray * arrServices = @[[CBUUID UUIDWithString:DeviceBasicInfoService],
                            [CBUUID UUIDWithString:HeartRateInfoService]];
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

+ (void) updateDevice : (ScannedResult *) device forCharacteristic : (CBCharacteristic *) characteristic
{
  NSString * strUUID = [characteristic.UUID UUIDString];
  if ([strUUID isEqualToString:DeviceBasicCharHardWareVersion])
  {
    device.hardwareVersion = [self getVersionStringForData:characteristic.value];
  }
  if ([strUUID isEqualToString:DeviceBasicCharSoftWareVersion])
  {
    device.hardwareVersion = [self getVersionStringForData:characteristic.value];
  }
  if ([strUUID isEqualToString:DeviceBasicCharFirmWareVersion])
  {
    device.hardwareVersion = [self getVersionStringForData:characteristic.value];
  }
  if ([strUUID isEqualToString:DeviceBasicCharManufacturerName])
  {
    device.manufatureName = [self getNameStringForData:characteristic.value];
  }
  if ([strUUID isEqualToString:HeartRateInfoCharBodySensorLocation])
  {
    device.sensorLocation = [self getNameStringForData:characteristic.value];
  }
  if ([strUUID isEqualToString:HeartRateInfoCharBodyHeartRateMeasurement])
  {
    device.hearRateMesurement = [self getNameStringForData:characteristic.value];
  }
}

+ (NSString *) getVersionStringForData : (NSData *) data{
  NSString * version ;
  if (data && data.length == 3) {
    const uint8_t * array = [data bytes];
    version = [NSString stringWithFormat:@"%X.%X.%X",array[0],array[1],array[2]];
  }
  RCTLog(@"\n Value : %@",version);
  return version;
}

+ (NSString *) getNameStringForData : (NSData *) data
{
  NSString * name;
  if (data) name = [[NSString alloc] initWithData:data encoding:1];
  RCTLog(@"\n Value : %@",name);
  return name;
}

@end
