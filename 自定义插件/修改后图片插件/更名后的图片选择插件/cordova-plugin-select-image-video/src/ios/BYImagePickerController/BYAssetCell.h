//
//  BYAssetCell.h
//  BoYue
//
//  Created by Embrace on 2017/10/27.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    BYAssetCellTypePhoto = 0,
    BYAssetCellTypeLivePhoto,
    BYAssetCellTypePhotoGif,
    BYAssetCellTypeVideo,
    BYAssetCellTypeAudio,
} BYAssetCellType;

@class BYAssetModel;
@interface BYAssetCell : UICollectionViewCell
    @property (weak, nonatomic) UIButton *selectPhotoButton;
    @property (nonatomic, strong) BYAssetModel *model;
    @property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
    @property (nonatomic, assign) BYAssetCellType type;
    @property (nonatomic, assign) BOOL allowPickingGif;
    @property (nonatomic, assign) BOOL allowPickingMultipleVideo;
    @property (nonatomic, copy) NSString *representedAssetIdentifier;
    @property (nonatomic, assign) int32_t imageRequestID;
    
    @property (nonatomic, copy) NSString *photoSelImageName;
    @property (nonatomic, copy) NSString *photoDefImageName;
    
    @property (nonatomic, assign) BOOL showSelectBtn;
    @property (assign, nonatomic) BOOL allowPreview;
    
    @end


@class BYAlbumModel;

@interface BYAlbumCell : UITableViewCell
    
    @property (nonatomic, strong) BYAlbumModel *model;
    @property (weak, nonatomic) UIButton *selectedCountButton;
    
    @end


@interface BYAssetCameraCell : UICollectionViewCell
    
    @property (nonatomic, strong) UIImageView *imageView;
@end
