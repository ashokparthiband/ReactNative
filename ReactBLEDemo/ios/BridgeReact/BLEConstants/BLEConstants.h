//
//  BLEConstants.h
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 29/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DeviceBasicInfoService @"DDDD"
#define DeviceBasicCharHardWareVersion @"DD01"
#define DeviceBasicCharSoftWareVersion @"DD02"
#define DeviceBasicCharFirmWareVersion @"DD03"
#define DeviceBasicCharManufacturerName @"DD04"

#define HeartRateInfoService @"ADAD"
#define HeartRateInfoCharHeartRatePoint @"AD01"
#define HeartRateInfoCharBodySensorLocation @"AD02"
#define HeartRateInfoCharBodyHeartRateMeasurement @"AD03"




@interface BLEConstants : NSObject

@end
