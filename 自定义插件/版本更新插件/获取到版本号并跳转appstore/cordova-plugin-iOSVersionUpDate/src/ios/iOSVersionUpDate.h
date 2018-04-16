//
//  iOSVersionUpDate.h
//  test6
//
//  Created by Embrace on 2017/10/23.
//

#import <Cordova/CDV.h>
#import "HSUpdateApp.h"
@interface iOSVersionUpDate : CDVPlugin
    
-(void)checkUpVersion:(CDVInvokedUrlCommand*)command;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;
@property (nonatomic, copy) NSString *StoreCurrentVersion;
    
@end

