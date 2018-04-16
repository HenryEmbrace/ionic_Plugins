//
//  BYAssetModel.h
//  BoYue
//
//  Created by Embrace on 2017/10/27.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BYAssetModelMediaTypePhoto = 0,
    BYAssetModelMediaTypeLivePhoto,
    BYAssetModelMediaTypePhotoGif,
    BYAssetModelMediaTypeVideo,
    BYAssetModelMediaTypeAudio
} BYAssetModelMediaType;

@class PHAsset;
@interface BYAssetModel : NSObject
    
@property (nonatomic, strong) id asset;             ///< PHAsset or ALAsset
@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No
@property (nonatomic, assign) BYAssetModelMediaType type;
@property (nonatomic, copy) NSString *timeLength;

    /// Init a photo dataModel With a asset
    /// 用一个PHAsset/ALAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(id)asset type:(BYAssetModelMediaType)type;
+ (instancetype)modelWithAsset:(id)asset type:(BYAssetModelMediaType)type timeLength:(NSString *)timeLength;
@end


@class PHFetchResult;
@interface BYAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) id result;             ///< PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;

@property (nonatomic, assign) BOOL isCameraRoll;
@end
