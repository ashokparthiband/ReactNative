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
#import "BLEConstants.h"
#import "BLEUtil.h"

@interface BirdgeReact ()
{
  __strong Scanner * scanObj;
  BOOL toggle;
  __block BridgeReactEmitter * emitter;
  __block NSMutableArray * arrScannedObjects;
  __block NSMutableArray <CBService *>* services;
  __block NSMutableArray <CBCharacteristic*>* chars;
  __block CBService * currentService;
  __block CBCharacteristic * currentCharacteristic;
}

@property (nonatomic,copy) RCTResponseSenderBlock connectHandler;

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

//RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(NSDate *)date)
//{
//  // Date is ready to use!
//}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(clearScanList) {
  [arrScannedObjects removeAllObjects];
}

RCT_EXPORT_METHOD(scanForDevices)
{
  [self startDeviceScan];
}

RCT_EXPORT_METHOD(stopScan){
  [scanObj stopScan];
}

RCT_EXPORT_METHOD(connectDevice:(NSDictionary *) device onComplete:(RCTResponseSenderBlock)callback)
{
  _connectHandler = callback;
  NSString * strUUID = [device objectForKey:@"deviceUUID"];
  [self connectBLEDevice:[self getScanResultForUUID:strUUID]];
}

- (void) connectBLEDevice : (ScannedResult *) device {
  __weak typeof (self) weakSelf = self;
  [scanObj connectDevice:device withHandler:^(BOOL connectStatus, NSError *error) {
    if (connectStatus) {
      NSDictionary * dict = @{@"connectOperation":@(YES)};
      _connectHandler(@[[NSNull null], dict]);
      [weakSelf discoverServiceInDevice:device];
      
    }else {
      NSDictionary * dict = @{@"errorMessage":error.localizedDescription};
      _connectHandler(@[dict,[NSNull null]]);
    }
    _connectHandler = nil;
  }];
}

- (ScannedResult *) getScanResultForUUID : (NSString * ) deviceUUID {
  NSPredicate * predicate = [NSPredicate predicateWithFormat:@"uuid = %@",deviceUUID];
  NSArray * array = [arrScannedObjects filteredArrayUsingPredicate:predicate];
  ScannedResult * scanResult = array.firstObject;
  return scanResult;
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
        NSString * localName = [scannedResult.advertisementData objectForKeyedSubscript:CBAdvertisementDataLocalNameKey];
        NSString * uuid = [[NSUUID UUID] UUIDString];
        scannedResult.uuid = uuid;
        
        NSDictionary * dictResult = @{@"deviceName":localName?localName:scannedResult.deviceName,
                                      @"RSSI":@(scannedResult.RSSI),
                                      @"AdvData":adverString,
                                      @"isConnectableMode":isConnectable,
                                      @"receivedAt":[weakSelf currentDateInString],
                                      @"deviceUUID":scannedResult.uuid
                                      };
        RCTLog(@"\n=================== \n Scann Result : \n %@ \n ===================",dictResult);
        
        if(scannedResult)[arrScannedObjects addObject:scannedResult];
        dispatch_async(dispatch_get_main_queue(), ^{
          if(dictResult)[emitter fireResult:dictResult];
        });
      }
    }
  }];
}


- (void) discoverServiceInDevice : (ScannedResult *) device {
  NSArray * arrServices = [BLEUtil getAllServices];
  [scanObj readServicesFromDevice:device services:arrServices withHandler:^(CBPeripheral *scannedResult, NSError *error) {
    if (error) {
      
    }else{
      services = [[device.peripheral valueForKey:@"services"] mutableCopy];
      [self discoverCharacteristicsForService:device];
      
    }
    RCTLog(@"\n=================== \n Services \n %@ \n ===================",scannedResult.services);
  }];
}

- (void) discoverCharacteristicsForService : (ScannedResult *) device
{
  if (services.count) {
    CBService * service = [services firstObject];
    NSArray * arrayChars = [BLEUtil getAllCharacteristicsForService:service];
    [self discoverCharacteristics:arrayChars forService:service forDevice:device];
  }else {
    services = [device.peripheral.services mutableCopy];
    if (services.count) {
      [self readCharacteristicValueFromDevice:device];
    }
  }
}

- (void) discoverCharacteristics : (NSArray *) chars forService : (CBService *) service forDevice : (ScannedResult *) device {
  __weak typeof (self) weakSelf = self;
  [scanObj discoverCharacteristics:chars forDevice:device forService:service withHandler:^(CBPeripheral *scannedResult, CBService *_service, NSError *error) {
    if (error) {
      RCTLog(@"\n Discover Char Failed for Service %@",_service);
    }else {
      [services removeObject:service];
      [weakSelf discoverCharacteristicsForService:device];
    }
  }];
}

- (void) readCharacteristicValueFromDevice : (ScannedResult *) device {
  
  CBService * tempService = nil;
  if (services.count) {
    currentService = services.firstObject;
    chars = [[BLEUtil getCharacteristicforService:services.firstObject inDevice:device] mutableCopy];
    if (chars.count) {
      [self continueReadingCharsForDevice:device];
    }else {
      [services removeObject:currentService];
      [self readCharacteristicValueFromDevice:device];
    }
  }
}

- (void) continueReadingCharsForDevice : (ScannedResult *) device {
  if (chars.count) {
    [self startReadingCharValueFrom:chars.firstObject fromDevice:device];
  }else {
    [services removeObject:currentService];
    [self readCharacteristicValueFromDevice:device];
  }
}

- (void) startReadingCharValueFrom : (CBCharacteristic *) chars1 fromDevice : (ScannedResult *) device {
  [scanObj readValueForCharacteristics:chars1 forDevice:device withHandler:^(CBPeripheral *scannedResult, CBCharacteristic *characteristic, NSData *value, NSError *error) {
    if (error) {
      RCTLog(@"Read Char Failed : %@",error);
    }else {
      RCTLog(@"Read Char Success : %@",value);
    }
    [chars removeObject:chars1];
    [self continueReadingCharsForDevice:device];
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
