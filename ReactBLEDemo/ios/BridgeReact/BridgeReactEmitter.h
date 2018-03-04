//
//  BridgeReactEmitter.h
//  ReactBLEDemo
//
//  Created by Ashok Parthiban D on 03/03/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface BridgeReactEmitter : RCTEventEmitter <RCTBridgeModule>

- (void) fireResult:(NSDictionary *) result;

@end
