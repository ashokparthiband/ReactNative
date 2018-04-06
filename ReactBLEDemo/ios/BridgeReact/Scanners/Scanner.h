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

typedef void(^OnScanningHandler)(ScannedResult * scannedResult,NSError * error);
typedef void (^OnConnectComplete) (BOOL connectStatus,NSError * error);

@interface Scanner : NSObject

- (void) startScanWithHandler : (OnScanningHandler) handler;

- (void) stopScan;

- (void) connectDevice : (ScannedResult *) peripheral withHandler: (OnConnectComplete) handler;

- (void) disconnectDevice : (ScannedResult *) peripheral withHandler: (OnConnectComplete) handler;


@end
