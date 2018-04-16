//
//  QRCodeScan.h
//  HelloCordova
//
//  Created by Embrace on 2017/6/20.
//
//

#import <Cordova/CDVPlugin.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SGQRCodeScanningVC.h"
@interface QRCodeScan : CDVPlugin
-(void)ScanMethod:(CDVInvokedUrlCommand*)command;
@property (nonatomic, strong)CDVInvokedUrlCommand*latestCommand;
@property (nonatomic, strong) SGQRCodeScanningVC *scanVC;
@property (nonatomic, strong) UINavigationController *nv;
-(void) dismissViewController;
@end
