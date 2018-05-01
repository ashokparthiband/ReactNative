//
//  Scanner.m
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 01/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Scanner.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <React/RCTLog.h>
#import "ScannedResult.h"

typedef enum{
  
  WiSeBleStopSanningMode,
  WiSeBleSanningMode,
  WiSeBleSanningPauseMode,
  
}WiSeBleOperateMode;

@interface Scanner () <CBCentralManagerDelegate,CBPeripheralDelegate> {
  NSTimer * timer;
}

@property (strong, nonatomic) CBCentralManager     * objCentralManager;
@property (nonatomic,strong ) dispatch_queue_t     centralManagerQueue;
@property (nonatomic,assign ) WiSeBleOperateMode   operateMode;
@property (nonatomic,copy) OnScanningHandler handler;
@property (nonatomic,copy) OnConnectComplete connectHandler;
@property (nonatomic,copy) OnReadServiceComplete readServiceHandler;
@property (nonatomic,copy) OnDiscoverCharacteristicComplete discoverCharacteristicHandler;
@property (nonatomic,copy) OnReadCharacteristicValueComplete readCharacteristicValueHandler;

@end

@implementation Scanner

- (void) initCentralManager {
  self.centralManagerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  self.objCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:self.centralManagerQueue];
  [self centralManagerDidUpdateState:self.objCentralManager];
}

- (void) startScanWithHandler : (OnScanningHandler) handler
{
  _handler = handler;
  if (!self.objCentralManager) {
    _operateMode = WiSeBleSanningPauseMode;
    [self initCentralManager];
  }
  if (_objCentralManager.state == CBCentralManagerStatePoweredOn) {
    _operateMode = WiSeBleSanningMode;
    [self wakeUpScanner];
  }else {
    NSError * error = [[NSError alloc] init];
    _handler(nil,error);
  }
  
}

- (void) stopScan {
  _operateMode = WiSeBleStopSanningMode;
  [self.objCentralManager stopScan];
  _handler = nil;
  timer = nil;
}

- (void) wakeUpScanner {
  if (WiSeBleSanningMode == _operateMode) {
    [self.objCentralManager stopScan];
    [self.objCentralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self performSelector:@selector(haltScanner) withObject:nil afterDelay:5];
    });
  }
}

- (void) haltScanner {
  if (WiSeBleSanningMode == _operateMode) {
    [self.objCentralManager stopScan];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self performSelector:@selector(wakeUpScanner) withObject:nil afterDelay:.5];
    });
  }
}

#pragma mark --- CBCentralManagerDelegate ---

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  switch (central.state) {
    case CBManagerStatePoweredOn:
      NSLog(@"Bluetooth Powered On");
      break;
    case CBManagerStatePoweredOff:
      NSLog(@"Bluetooth Powered Off");
      break;
    case CBManagerStateUnsupported:
      NSLog(@"Bluetooth Powered Unsupported");
      break;
    case CBManagerStateUnauthorized:
      NSLog(@"Bluetooth Powered Unauthorized");
      break;
    case CBManagerStateUnknown:
      NSLog(@"Bluetooth Powered Unknown");
      break;
    case CBManagerStateResetting:
      NSLog(@"Bluetooth Powered Resetting");
      break;
    default:
      break;
  }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    RCTLog(@"============================= \n Device Details \n Name : %@ \n RSSI %d \n Data : %@",peripheral.name,[RSSI intValue],advertisementData);
  
  if (_handler) {
    ScannedResult * result = [[ScannedResult alloc] init];
    result.deviceName = peripheral.name?peripheral.name:@"";
    result.RSSI = [RSSI intValue];
    result.advertisementData = advertisementData?advertisementData:@{};
    result.peripheral = peripheral;
    _handler(result,nil);
  }
}

#pragma mark - Connect Device

- (void) connectDevice : (ScannedResult *) peripheral withHandler: (OnConnectComplete) handler {
  _connectHandler = handler;
  [self stopScan];
  [_objCentralManager connectPeripheral:peripheral.peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
  RCTLog(@"/n Connected to %@",peripheral);
  if (_connectHandler) {
    _connectHandler(YES,nil);
    _connectHandler = nil;
  }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  RCTLog(@"/n Failed Connected to %@",peripheral);
  if (_connectHandler) {
    _connectHandler(NO,nil);
    _connectHandler = nil;
  }
}

#pragma mark - Dis Connect Device

- (void) disconnectDevice : (ScannedResult *) peripheral withHandler: (OnConnectComplete) handler {
  _connectHandler = handler;
  [self stopScan];
  [_objCentralManager cancelPeripheralConnection:peripheral.peripheral];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  RCTLog(@"\n Disconnected from %@ Error : %@",peripheral,error);
  if (_connectHandler) {
    if (error) {
      _connectHandler(NO,error);
    }else {
      _connectHandler(YES,nil);
    }
    _connectHandler = nil;
  }
}

#pragma mark - Read Services and Charectersitics

- (void) readServicesFromDevice : (ScannedResult *) peripheral services:(NSArray *) services withHandler : (OnReadServiceComplete) handler{
  _readServiceHandler = handler;
  [self stopScan];
  peripheral.peripheral.delegate = self;
  [peripheral.peripheral discoverServices:services];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  RCTLog(@"\n Discovered Services");
  if (_readServiceHandler) {
    _readServiceHandler(peripheral,error);
    _readServiceHandler = nil;
  }
}

- (void) discoverCharacteristics : (NSArray *) characteristics forDevice : (ScannedResult *) peripheral forService:(CBService *) service withHandler : (OnDiscoverCharacteristicComplete) handler
{
  RCTLog(@"\n Start Discover Chars");
  _discoverCharacteristicHandler = handler;
  [self stopScan];
  [peripheral.peripheral discoverCharacteristics:characteristics forService:service];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  RCTLog(@"\n Discovered Chars");
  if (_discoverCharacteristicHandler) {
    _discoverCharacteristicHandler(peripheral,service,error);
//    _discoverCharacteristicHandler = nil;
  }else {
    RCTLog(@"\n _discoverCharacteristicHandler is nil");
  }
}


- (void) readValueForCharacteristics : (CBCharacteristic *) characteristic forDevice : (ScannedResult *) peripheral withHandler : (OnReadCharacteristicValueComplete) handler {
  RCTLog(@"\n Read Value For Char : %@",characteristic.UUID);
  [self stopScan];
  _readCharacteristicValueHandler = handler;
  [peripheral.peripheral readValueForCharacteristic:characteristic];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
  RCTLog(@"\n Value : %@ for Char : %@",characteristic.value,characteristic);
  if (_readCharacteristicValueHandler) {
    _readCharacteristicValueHandler(peripheral,characteristic,characteristic.value,error);
//    _readCharacteristicValueHandler = nil;
  }else {
    RCTLog(@"\n _readCharacteristicValueHandler is nil");
  }
  
}


@end
