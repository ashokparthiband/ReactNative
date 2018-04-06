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
  __block NSMutableArray * arrScannedObjects;
}

@property (nonatomic,copy) RCTResponseSenderBlock scanHandler;

@end

@implementation BirdgeReact

- (instancetype)init
{
  if (self = [super init]) {
    scanObj = [[Scanner alloc] init];
    emitter = [BridgeReactEmitter allocWithZone: nil];
    arrScannedObjects = [[NSMutableArray alloc] init];
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
  [scanObj startScanWithHandler:^(ScannedResult *scannedResult,NSError * error)
  {
    if(error)
    {
      NSDictionary * dictResult = @{@"errorMessage":@"Bluetooth Busy!"};
      dispatch_async(dispatch_get_main_queue(), ^{
        if(dictResult)[emitter fireResult:dictResult];
      });
    }
    else if(scannedResult)
    {
      NSPredicate * predicate = [NSPredicate predicateWithFormat:@"peripheral.name = %@",scannedResult.peripheral.name];
      NSArray * result = [arrScannedObjects filteredArrayUsingPredicate:predicate];
      
      ScannedResult * resultFromArray = [result firstObject];
      
      if (!resultFromArray) {
        resultFromArray = scannedResult;
        NSData * advertisementData = [scannedResult.advertisementData objectForKeyedSubscript:CBAdvertisementDataManufacturerDataKey];
        NSString * adverString = [weakSelf hexadecimalStringFromNSData:advertisementData];
        NSNumber * isConnectable = [scannedResult.advertisementData objectForKeyedSubscript:CBAdvertisementDataIsConnectable];
        
        NSDictionary * dictResult = @{@"deviceName":scannedResult.deviceName,
                                      @"RSSI":@(scannedResult.RSSI),
                                      @"AdvData":adverString,
                                      @"isConnectableMode":isConnectable,
                                      @"receivedAt":[weakSelf currentDateInString],
                                      };
        RCTLog(@"\n=================== \n Scann Result : \n %@ \n ===================",dictResult);
        
        if(scannedResult)[arrScannedObjects addObject:scannedResult];
        dispatch_async(dispatch_get_main_queue(), ^{
          if(dictResult)[emitter fireResult:dictResult];
        });
      }
    }
    //    if (scannedResult.RSSI > -40 && scannedResult.RSSI < 0) {
    //
    //    }
  }];
}

//- (dispatch_queue_t)methodQueue
//{
//  return dispatch_get_main_queue();
//}

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
