//
//  Scanner.m
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 01/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Scanner.h"
#import <CoreBluetooth/CoreBluetooth.h>

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

@end

@implementation Scanner

- (void) initCentralManager {
  self.centralManagerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
  self.objCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:self.centralManagerQueue];
}

- (void) startScan {
//  if (!self.objCentralManager) {
//    [self initCentralManager];
//  }
//  [self.objCentralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

- (void) startScanWithHandler : (OnScanningHandler) handler
{
  _handler = handler;
  if (!self.objCentralManager) {
    [self initCentralManager];
  }
  [self wakeUpScanner];
}

- (void) stopScan {
  [self.objCentralManager stopScan];
  _handler = nil;
}

- (void) wakeUpScanner {
  [self.objCentralManager stopScan];
  [self.objCentralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
  [self performSelector:@selector(haltScanner) withObject:nil afterDelay:10];
}

- (void) haltScanner {
  [self.objCentralManager stopScan];
  [self performSelector:@selector(wakeUpScanner) withObject:nil afterDelay:.5];
}

#pragma mark --- CBCentralManagerDelegate ---

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  switch (central.state) {
    case CBManagerStatePoweredOn:
      NSLog(@"Bluetooth Powered On");
      [self startScan];
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
    NSLog(@"============================= \n Device Details \n Name : %@ \n RSSI %d \n Data : %@",peripheral.name,[RSSI intValue],advertisementData);
  
  if (_handler) {
    ScannedResult * result = [[ScannedResult alloc] init];
    result.deviceName = peripheral.name?peripheral.name:@"";
    result.RSSI = [RSSI intValue];
    result.advertisementData = advertisementData?advertisementData:@{};
    _handler(result);
  }
}

@end
