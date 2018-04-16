//
//  PickImgOrVideoPlugin.h
//  ImgPickerDemo
//
//  Created by Embrace on 2017/6/15.
//
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "XMNPhotoPickerFramework.h"
#import "MediaUtils.h"


@interface PickImgOrVideoPlugin : CDVPlugin
-(void)pickImgOrVideoMethod:(CDVInvokedUrlCommand *)command;
-(void)dismissController ;
@property (nonatomic,strong) NSMutableArray *ImgArr;
@property (nonatomic, strong) NSMutableArray<XMNAssetModel*>* models;
@property (strong, nonatomic) CDVInvokedUrlCommand* latestCommand;
@property (readwrite, assign) BOOL hasPendingOperation;
@property (nonatomic, strong) XMNPhotoPickerController* picker;
@property (nonatomic, strong) UINavigationController *nav;
-(void) array:(NSMutableArray *)Arr string:(NSString *)Str;
@end
