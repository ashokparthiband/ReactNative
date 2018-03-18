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
  __strong Scanner * scanObj;
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

RCT_EXPORT_METHOD(scanForDevices)
{

  [self startDeviceScan];
}

RCT_EXPORT_METHOD(stopScan){
  [scanObj stopScan];
}

- (void) startDeviceScan {
  __weak typeof(self) weakSelf = self;
  [scanObj startScanWithHandler:^(ScannedResult *scannedResult) {
    
    NSData * advertisementData = [scannedResult.advertisementData objectForKeyedSubscript:CBAdvertisementDataManufacturerDataKey];
    NSString * adverString = [weakSelf hexadecimalStringFromNSData:advertisementData];
    NSNumber * isConnectable = [scannedResult.advertisementData objectForKeyedSubscript:CBAdvertisementDataIsConnectable];
    
    NSDictionary * dictResult = @{@"deviceName":scannedResult.deviceName,
                                  @"RSSI":@(scannedResult.RSSI),
                                  @"AdvData":adverString,
                                  @"isConnectableMode":isConnectable,
                                  @"receivedAt":[weakSelf currentDateInString],
                                  };
    NSLog(@"\n=================== \n Scann Result : \n %@ \n ===================",dictResult);
    dispatch_async(dispatch_get_main_queue(), ^{
      [emitter fireResult:dictResult];
    });
    
  }];
}

- (NSString *) currentDateInString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
  return [dateFormatter stringFromDate:[NSDate date]];
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



@end
