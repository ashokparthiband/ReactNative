//
//  Scanner.h
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 01/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScannedResult;

typedef void(^OnScanningHandler)(ScannedResult * scannedResult);


@interface Scanner : NSObject

- (void) startScanWithHandler : (OnScanningHandler) handler;

- (void) stopScan;

@end
