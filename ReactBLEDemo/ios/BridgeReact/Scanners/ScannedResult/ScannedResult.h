//
//  ScannedResult.h
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 01/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScannedResult : NSObject

@property (nonatomic) NSString * deviceName;
@property (nonatomic) int RSSI;
@property (nonatomic) NSDictionary * advertisementData;

@end
