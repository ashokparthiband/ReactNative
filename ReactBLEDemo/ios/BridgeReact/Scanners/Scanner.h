//
//  Scanner.h
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 01/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ScannedResult;
@class CBPeripheral;
@class CBService;
@class CBCharacteristic;

typedef void(^OnScanningHandler)(ScannedResult * scannedResult,NSError * error);
typedef void (^OnConnectComplete) (BOOL connectStatus,NSError * error);
typedef void (^OnReadServiceComplete) (CBPeripheral * scannedResult,NSError * error);
typedef void (^OnDiscoverCharacteristicComplete) (CBPeripheral * scannedResult,CBService * service,NSError * error);
typedef void (^OnReadCharacteristicValueComplete) (CBPeripheral * scannedResult,CBCharacteristic * service,NSData * value,NSError * error);

@interface Scanner : NSObject

- (void) startScanWithHandler : (OnScanningHandler) handler;

- (void) stopScan;

- (void) connectDevice : (ScannedResult *) peripheral withHandler: (OnConnectComplete) handler;

- (void) disconnectDevice : (ScannedResult *) peripheral withHandler: (OnConnectComplete) handler;

- (void) readServicesFromDevice : (ScannedResult *) peripheral services:(NSArray *) services withHandler : (OnReadServiceComplete) handler;

- (void) discoverCharacteristics : (NSArray *) characteristics forDevice : (ScannedResult *) peripheral forService:(CBService *) service withHandler : (OnDiscoverCharacteristicComplete) handler;

- (void) readValueForCharacteristics : (CBCharacteristic *) characteristic forDevice : (ScannedResult *) peripheral withHandler : (OnReadCharacteristicValueComplete) handler;

@end
