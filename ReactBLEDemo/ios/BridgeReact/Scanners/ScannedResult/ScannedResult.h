//
//  ScannedResult.h
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 01/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;

@interface ScannedResult : NSObject

@property (nonatomic) NSString * deviceName;
@property (nonatomic) int RSSI;
@property (nonatomic) NSDictionary * advertisementData;
@property (nonatomic) CBPeripheral * peripheral;
@property (nonatomic) NSString * uuid;
@property (nonatomic) NSString * hardwareVersion;
@property (nonatomic) NSString * softwareVersion;
@property (nonatomic) NSString * firmwareVersion;
@property (nonatomic) NSString * manufatureName;
@property (nonatomic) NSString * sensorLocation;
@property (nonatomic) NSString * heartPoint;
@property (nonatomic) NSString * hearRateMesurement;


@end
