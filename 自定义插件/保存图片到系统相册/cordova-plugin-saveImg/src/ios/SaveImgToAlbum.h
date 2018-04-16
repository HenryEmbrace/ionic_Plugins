//
//  SaveImgToAlbum.h
//  saveImgDemo
//
//  Created by Embrace on 2017/7/3.
//
//

#import <Cordova/CDVPlugin.h>

@interface SaveImgToAlbum : CDVPlugin
-(void)saveImgMothed:(CDVInvokedUrlCommand *)command;
@property (nonatomic, strong)CDVInvokedUrlCommand *latestCommand;
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end
