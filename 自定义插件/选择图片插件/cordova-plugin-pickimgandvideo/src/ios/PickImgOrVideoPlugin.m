//
//  PickImgOrVideoPlugin.m
//  ImgPickerDemo
//
//  Created by Embrace on 2017/6/15.
//
//

#import "PickImgOrVideoPlugin.h"

@implementation PickImgOrVideoPlugin

-(NSMutableArray *)ImgArr {
    if (!_ImgArr) {
        _ImgArr = [[NSMutableArray alloc] init];
    }
    return _ImgArr;
}

-(void)pickImgOrVideoMethod:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:9 delegate:nil];
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        
        NSString *path = [MediaUtils getTempPath];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
       
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        [self array:self.ImgArr string:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}

-(void)compressVideo:(PHAsset*)asset{
    [MediaUtils writePHVedio:asset toPath:nil block:^(NSURL *url) {
        if (!url) {
            //            NSLog(@"写入失败");
            
        }else{
            
            
            //            NSLog(@"写入完毕 %@", url);
            NSString *pathStr = url.absoluteString;
            [self array:nil string:pathStr];
            
            self.hasPendingOperation = NO;
            
            [MediaUtils convertVideoQuailtyWithInputURL:url outputURL:nil completeHandler:^(AVAssetExportSession *exportSession, NSURL* compressedOutputURL) {
                
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    //                    NSLog(@"压缩成功");
                    
                    [MediaUtils deleteFileByPath:url.path];
                    
                    if ([MediaUtils getFileSize:compressedOutputURL.path] > 1024 * 1024 * 5) {
                        //                        NSLog(@"压缩后还是大于5M");
                    }
                    
                    
                }else{
                    //                    NSLog(@"压缩失败");
                }
                
            }];
        }
    }];
}



-(void)dismissController {
    __weak PickImgOrVideoPlugin *weakSelf = self;
    
    [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark --- callBackToWebForPassUrl
-(void)array:(NSMutableArray *)Arr string:(NSString *)Str {
    NSDictionary *upLoadDic;
    
    if (Arr.count > 0 && Str.length == 0) {
        upLoadDic = [NSDictionary dictionaryWithObjectsAndKeys:Arr,@"picture", nil];
    } else if (Arr.count == 0 && Str.length != 0) {
        
        upLoadDic = [NSDictionary dictionaryWithObjectsAndKeys:Str,@"video", nil];
    }
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:upLoadDic];
    [self.commandDelegate sendPluginResult:result callbackId:self.latestCommand.callbackId];
    
    [_ImgArr removeAllObjects];
}

@end
