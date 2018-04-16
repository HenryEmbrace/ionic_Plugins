//
//  SelectImageVideo.m
//  BoyueApp
//
//  Created by Embrace on 2017/6/19.
//
//

#import "SelectImageVideo.h"
#import "MBProgressHUD.h"

@implementation SelectImageVideo
    
-(NSMutableArray *)ImgArr {
    if (!_ImgArr) {
        _ImgArr = [[NSMutableArray alloc] init];
    }
    return _ImgArr;
}
    
-(NSMutableArray *)VideoArr {
    if (!_VideoArr) {
        _VideoArr = [[NSMutableArray alloc] init];
        
    }
    return _VideoArr;
}


-(void)selectVideoByCrop:(CDVInvokedUrlCommand *)command {
        __weak typeof(self) weakSelf = self;
    NSDictionary *options = [command.arguments objectAtIndex:0];
    weakSelf.width = [[options objectForKey:@"aspect_ratio_x"] integerValue];
    weakSelf.height = [[options objectForKey:@"aspect_ratio_y"] integerValue];
    weakSelf.photoCount = [[options objectForKey:@"selectNum"] integerValue];
    
    
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:weakSelf.photoCount delegate:nil];
    weakSelf.picker.width = weakSelf.width;
    weakSelf.picker.height = weakSelf.height;
    
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = [NSString stringWithFormat:@"file:"];
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            //            NSURL* url = [NSURL fileURLWithPath:PathString];
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:PathString]) {
            //                [[NSFileManager defaultManager] removeItemAtPath:PathString error:nil];
            //            }
            //
            //            PathString = url.absoluteString;
            
            [self.ImgArr addObject:PathString];
            
        }
        
        [self imgArr:self.ImgArr videoArr:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        //        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
    

}



//    图片视频都可以选择
-(void)selectAll:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    NSString * Num= [NSString stringWithFormat:@"%@",[command.arguments lastObject]];
    NSUInteger canSelectNum = [Num integerValue];
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:canSelectNum delegate:nil];    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = [NSString stringWithFormat:@"file:"];
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            //            NSURL* url = [NSURL fileURLWithPath:PathString];
            //            if ([[NSFileManager defaultManager] fileExistsAtPath:PathString]) {
            //                [[NSFileManager defaultManager] removeItemAtPath:PathString error:nil];
            //            }
            //
            //            PathString = url.absoluteString;
            
            [self.ImgArr addObject:PathString];
            
        }
        
        [self imgArr:self.ImgArr videoArr:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        //        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}
    
    /// 只选图片
-(void)selectImage:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    NSString * Num= [NSString stringWithFormat:@"%@",[command.arguments lastObject]];
    NSUInteger canSelectNum = [Num integerValue];
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:canSelectNum delegate:nil];
    
    // weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    weakSelf.picker.pickingVideoEnable = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        //        [self array:self.ImgArr string:nil];
        [self imgArr:self.ImgArr videoArr:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        //        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}
    
    
    /// 只选择视频
-(void)selectVideo:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    //    weakSelf.picker.pickingVideoEnable = NO;
    //    weakSelf.picker.autoPushToPhotoCollection = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        //        [self array:self.ImgArr string:nil];
        [self imgArr:self.ImgArr videoArr:nil];
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
    
    /// 选择一个视频或者1张图片
-(void)selectAllSingle:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    //    weakSelf.picker.pickingVideoEnable = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        //        [self array:self.ImgArr string:nil];
        [self imgArr:self.ImgArr videoArr:nil];
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
    
    ///选择一张图片
-(void)selectImageSingle:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:1 delegate:nil];
    weakSelf.picker.pickingVideoEnable = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        //        [self array:self.ImgArr string:nil];
        [self imgArr:self.ImgArr videoArr:nil];
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
    
    ///选择一个视频
-(void)selectVideoSingle:(CDVInvokedUrlCommand *)command {
    
    __weak typeof(self) weakSelf = self;
    self.hasPendingOperation = YES;
    self.latestCommand = command;
    
    weakSelf.picker= [[XMNPhotoPickerController alloc] initWithMaxCount:0 delegate:nil];
    weakSelf.picker.pickingVideoEnable = NO;
    //    选择照片后回调
    [weakSelf.picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        [weakSelf.models addObjectsFromArray:assets];
        //        NSString *s = @"file://";
        NSString *path = [NSString stringWithFormat:@"%@",[MediaUtils getTempPath]];
        
        NSString * PathString;
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        [formater setDateFormat:@"yyyyMMddHHmmss"];
        
        for (int i = 0; i < images.count; i++) {
            UIImage *img = [images objectAtIndex:i];
            
            PathString = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.jpg",[formater stringFromDate:[NSDate date]],i]];
            [UIImageJPEGRepresentation(img,1) writeToFile:PathString atomically:YES];
            
            
            
            [self.ImgArr addObject:PathString];
            
        }
        //        [self array:self.ImgArr string:nil];
        [self imgArr:self.ImgArr videoArr:nil];
        [self dismissController];
    }];
    
    //    选择视频后回调
    [weakSelf.picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        //        [self dismissController];
        
    }];
    
    //    点击取消
    [weakSelf.picker setDidCancelPickingBlock:^{
        [self dismissController];
    }];
    
    [self.viewController presentViewController:weakSelf.picker animated:YES completion:nil];
}
    
    
    
    ///视频回调
-(void)compressVideo:(PHAsset*)asset{
    
    [MediaUtils writePHVedio:asset toPath:nil block:^(NSURL *url) {
        if (!url) {
            //            NSLog(@"写入失败");
            
        }else{
            
            _exportMP4Path = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"video_tmp.mp4"]];
            [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
            _exportStatus = RCExportMP4StatusNormal;
            [self rc_exportMP4FromMOVURL:url withCompletion:^(RCExportMP4Status status) {
                
                
                if(RCExportMP4StatusComplete == status)
                {
                    //                    info = @{RCMediaVideoInfo : _exportMP4Path};
                    //                    NSLog(@"_exportMP4Path : %@",_exportMP4Path);
                    
                    NSString *pathStr = _exportMP4Path.absoluteString;
                    
                    [ self.VideoArr addObject:pathStr];
                    
                    [self imgArr:nil videoArr:self.VideoArr];
                    //            [self imgArr:nil videoUrl:url];
                    self.hasPendingOperation = NO;
                    [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
                    [self dismissController];
                    
                }
                else
                {// original mov path
                    
                }
            }];
            
            
        }
    }];
}
    
    
- (void)rc_exportMP4FromMOVURL:(NSURL *)url withCompletion:(void (^)(RCExportMP4Status status))complete
    {
        if(!url)
        {
            _exportStatus = RCExportMP4StatusFail;
            //goto RC_EXPORTSTATUS_END;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(complete)
                {
                    complete(RCExportMP4StatusFail);
                }
            });
            
            return;
        }
        
        AVURLAsset *asset = [AVURLAsset assetWithURL:url];
        NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
        NSString *preset = AVAssetExportPresetMediumQuality;
        if([presets containsObject:AVAssetExportPreset640x480])
        {
            preset = AVAssetExportPreset640x480;
        }
        else if(![presets containsObject:AVAssetExportPresetMediumQuality])
        {
            _exportStatus = RCExportMP4StatusFail;
            asset = nil;
            presets = nil;
            preset = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(complete)
                {
                    complete(RCExportMP4StatusFail);
                }
            });
            return;
        }
        AVAssetExportSession *export = [AVAssetExportSession exportSessionWithAsset:asset presetName:preset];
        export.outputURL = _exportMP4Path;
        export.shouldOptimizeForNetworkUse = YES;
        NSArray *fileTypes = [export supportedFileTypes];
        if(![fileTypes containsObject:AVFileTypeMPEG4])
        {
            _exportStatus = RCExportMP4StatusFail;
            export = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(complete)
                {
                    complete(RCExportMP4StatusFail);
                }
            });
            return;
        }
        if([[NSFileManager defaultManager] fileExistsAtPath:_exportMP4Path.path])
        {
            BOOL deleted = [[NSFileManager defaultManager] removeItemAtURL:_exportMP4Path error:nil];
            //   NSLog(@"\nDelete Existed MP4 File %@.", deleted ? @"Success" : @"Fail");
        }
        export.outputFileType = AVFileTypeMPEG4;
        _exportStatus = RCExportMP4StatusProcessing;
        // NSLog(@"\nprivate begin export.");
        [export exportAsynchronouslyWithCompletionHandler:^{
            
            switch(export.status)
            {
                case AVAssetExportSessionStatusCompleted:_exportStatus = RCExportMP4StatusComplete;break;
                case AVAssetExportSessionStatusExporting:_exportStatus = RCExportMP4StatusProcessing;break;
                default:_exportStatus = RCExportMP4StatusFail;break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(complete)
                {
                    complete(_exportStatus);
                }
            });
            
            //  NSLog(@"\nprivate end export.");
            
        }];
    }
    
    
    
    /// 模态页面消失
-(void)dismissController {
    __weak SelectImageVideo *weakSelf = self;
    
    [weakSelf.picker dismissViewControllerAnimated:YES completion:nil];
    
    [_ImgArr removeAllObjects];
    [_VideoArr removeAllObjects];
}
    
    
#pragma mark --- callBackToWebForPassUrl

-(void) imgArr:(NSMutableArray *)imgArr videoArr:(NSMutableArray *)videoArr{
    NSDictionary *upLoadDic;
    
    if (imgArr.count > 0 && videoArr.count == 0) {
        upLoadDic = [NSDictionary dictionaryWithObjectsAndKeys:imgArr,@"picture", nil];
    } else if (videoArr.count > 0 && imgArr.count == 0 ) {
        
        upLoadDic = [NSDictionary dictionaryWithObjectsAndKeys:videoArr,@"video", nil];
    }
    
    
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:upLoadDic];
    [self.commandDelegate sendPluginResult:result callbackId:self.latestCommand.callbackId];
    
}
    
    
@end
