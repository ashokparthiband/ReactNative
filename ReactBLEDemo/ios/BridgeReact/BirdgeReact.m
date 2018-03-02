//
//  BirdgeReact.m
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 25/02/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "BirdgeReact.h"
#import <React/RCTLog.h>
#import "Scanner.h"
#import "ScannedResult.h"

@interface BirdgeReact ()
{
  Scanner * scanObj;
  BOOL toggle;
}

@property (nonatomic,copy) RCTResponseSenderBlock scanHandler;

@end

@implementation BirdgeReact

- (instancetype)init
{
  if (self = [super init]) {
    scanObj = [[Scanner alloc] init];
  }
  return self;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
//  __weak typeof (self) weakSelf = self;
  
  
}

- (NSDictionary *)constantsToExport {
  return @{@"SayHai":@"Hi EveryOne"};
}

RCT_EXPORT_METHOD(scanForDevices:(RCTResponseSenderBlock)callback)
{
  _scanHandler = callback;
  toggle = !toggle;
  if (toggle) {
    [self startDeviceScan];
  }else {
    [scanObj stopScan];
  }
}

- (void) startDeviceScan {
  [scanObj startScanWithHandler:^(ScannedResult *scannedResult) {
    NSDictionary * dictResult = @{@"deviceName":scannedResult.deviceName,
                                  @"RSSI":@(scannedResult.RSSI),
                                  @"AdvData":scannedResult.advertisementData
                                  };
    _scanHandler(@[[NSNull null], dictResult]);
  }];
}

@end
