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

@interface Scanner () <CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager     * objCentralManager;
@property (nonatomic,strong ) dispatch_queue_t     centralManagerQueue;
@property (nonatomic,assign ) WiSeBleOperateMode   operateMode;
@property (nonatomic,copy) OnScanningHandler handler;
@property (nonatomic,copy) OnConnectComplete connectHandler;

@end

@implementation Scanner

- (void) initCentralManager {
  self.centralManagerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
  self.objCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:self.centralManagerQueue];
  [self centralManagerDidUpdateState:self.objCentralManager];
}

- (void) startScanWithHandler : (OnScanningHandler) handler
{
  _handler = handler;
  if (!self.objCentralManager) {
    _operateMode = WiSeBleStopSanningMode;
    [self initCentralManager];
  }
  if (_objCentralManager.state == CBCentralManagerStatePoweredOn) {
    [self wakeUpScanner];
  }else {
    NSError * error = [[NSError alloc] init];
    _handler(nil,error);
  }
  
}

- (void) stopScan {
  [self.objCentralManager stopScan];
  _handler = nil;
}

- (void) wakeUpScanner {
  [self.objCentralManager stopScan];
  _operateMode = WiSeBleSanningMode;
  [self.objCentralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
  [self performSelector:@selector(haltScanner) withObject:nil afterDelay:10];
}

- (void) haltScanner {
  [self.objCentralManager stopScan];
  _operateMode = WiSeBleStopSanningMode;
  [self performSelector:@selector(wakeUpScanner) withObject:nil afterDelay:.5];
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
  if (_connectHandler) {
    _connectHandler(YES,nil);
  }
}

#pragma mark - Dis Connect Device

- (void) disconnectDevice : (ScannedResult *) peripheral withHandler: (OnConnectComplete) handler {
  _connectHandler = handler;
  [self stopScan];
  [_objCentralManager cancelPeripheralConnection:peripheral.peripheral];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
  if (_connectHandler) {
    if (error) {
      _connectHandler(NO,error);
    }else {
      _connectHandler(YES,nil);
    }
    
  }
}

@end
