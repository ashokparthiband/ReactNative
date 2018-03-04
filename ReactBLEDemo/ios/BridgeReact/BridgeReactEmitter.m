//
//  BridgeReactEmitter.m
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 03/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "BridgeReactEmitter.h"

@implementation BridgeReactEmitter

+ (id)allocWithZone:(NSZone *)zone {
  static BridgeReactEmitter *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"ScannedResult"];
}

- (void) fireResult:(NSDictionary *) result {
  [self sendEventWithName:@"ScannedResult" body:result];
}

@end
