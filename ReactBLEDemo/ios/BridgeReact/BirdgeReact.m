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
#import "BridgeReactEmitter.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BirdgeReact ()
{
  Scanner * scanObj;
  BOOL toggle;
  __block BridgeReactEmitter * emitter;
}

@property (nonatomic,copy) RCTResponseSenderBlock scanHandler;

@end

@implementation BirdgeReact

- (instancetype)init
{
  if (self = [super init]) {
    scanObj = [[Scanner alloc] init];
    emitter = [BridgeReactEmitter allocWithZone: nil];
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



//RCT_EXPORT_METHOD(scanForDevices:(RCTResponseSenderBlock)callback)
//{
//  _scanHandler = callback;
//  toggle = !toggle;
//  if (toggle) {
//    [self startDeviceScan];
//  }else {
//    [scanObj stopScan];
//  }
//}

RCT_EXPORT_METHOD(scanForDevices)
{
//  toggle = !toggle;
//  if (toggle) {
//
//  }else {
//    [scanObj stopScan];
//  }
  [self startDeviceScan];
}

- (void) startDeviceScan {
  [scanObj startScanWithHandler:^(ScannedResult *scannedResult) {
    
    NSData * advertisementData = [scannedResult.advertisementData objectForKeyedSubscript:CBAdvertisementDataManufacturerDataKey];
    NSString * adverString = [self hexadecimalStringFromNSData:advertisementData];
    
    NSDictionary * dictResult = @{@"deviceName":scannedResult.deviceName,
                                  @"RSSI":@(scannedResult.RSSI),
                                  @"AdvData":adverString,
                                  @"isConnectableMode":@(0),
                                  };
    [emitter fireResult:dictResult];
  }];
}

- (NSString *)hexadecimalStringFromNSData : (NSData*) data {
  /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
  
  const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
  
  if (!dataBuffer)
    return [NSString string];
  
  NSUInteger          dataLength  = [data length];
  NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
  
  for (int i = 0; i < dataLength; ++i)
    [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
  
  return [NSString stringWithString:hexString];
}

RCT_EXPORT_METHOD(stopScan){
  [scanObj stopScan];
}

@end
