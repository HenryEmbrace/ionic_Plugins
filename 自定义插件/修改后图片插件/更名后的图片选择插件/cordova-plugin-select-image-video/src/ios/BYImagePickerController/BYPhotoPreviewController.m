//
//  BYPhotoPreviewController.m
//  BoYue
//
//  Created by Embrace on 2017/10/28.
//  Copyright © 2017年 __CompanyName__.com. All rights reserved.
//

#import "BYPhotoPreviewController.h"
#import "BYPhotoPreviewController.h"
#import "BYPhotoPreviewCell.h"
#import "BYAssetModel.h"
#import "UIView+BYLayout.h"
#import "BYImagePickerController.h"
#import "BYImageManager.h"
#import "BYImageCropManager.h"
#import "ImageCutViewController.h"
@interface BYPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate> {
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLabel;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLabel;
    
    CGFloat _offsetItemCount;
}
    @property (nonatomic, assign) BOOL isHideNaviBar;
    @property (nonatomic, strong) UIView *cropBgView;
    @property (nonatomic, strong) UIView *cropView;
    
    @property (nonatomic, assign) double progress;
    @property (strong, nonatomic) id alertView;
    
    @property (nonatomic, strong)  ImageCutViewController*cutVC;
    @property (nonatomic, strong) NSArray *finishImgArr;
    
    
    @end

@implementation BYPhotoPreviewController
    
    
    static inline CGSize JKMainScreenSize() {
        return [UIScreen mainScreen].bounds.size;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    [BYImageManager manager].shouldFixOrientation = YES;
    __weak typeof(self) weakSelf = self;
    BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)weakSelf.navigationController;
    if (!self.models.count) {
        self.models = [NSMutableArray arrayWithArray:_BYImagePickerVc.selectedModels];
        _assetsTemp = [NSMutableArray arrayWithArray:_BYImagePickerVc.selectedAssets];
        self.isSelectOriginalPhoto = _BYImagePickerVc.isSelectOriginalPhoto;
    }
    [self configCollectionView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
    self.view.clipsToBounds = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
    
- (void)setPhotos:(NSMutableArray *)photos {
    _photos = photos;
    _photosTemp = [NSArray arrayWithArray:photos];
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (!BY_isGlobalHideStatusBar) {
        if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
    }
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.BY_width + 20) * _currentIndex, 0) animated:NO];
    [self refreshNaviBarAndBottomBarState];
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (!BY_isGlobalHideStatusBar) {
        if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = NO;
    }
    [BYImageManager manager].shouldFixOrientation = NO;
}
    
- (BOOL)prefersStatusBarHidden {
    return YES;
}
    
- (void)configCustomNaviBar {
    BYImagePickerController *BYImagePickerVc = (BYImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectZero];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_backButton setImage:[UIImage imageNamedFromMyBundle:@"navi_back"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _selectButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_selectButton setImage:[UIImage imageNamedFromMyBundle:BYImagePickerVc.photoDefImageName] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamedFromMyBundle:BYImagePickerVc.photoSelImageName] forState:UIControlStateSelected];
    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    _selectButton.hidden = !BYImagePickerVc.showSelectBtn;
    
    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}
    
- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    static CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];
    
    BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)self.navigationController;
    if (_BYImagePickerVc.allowPickingOriginalPhoto) {
        _originalPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _originalPhotoButton.backgroundColor = [UIColor clearColor];
        [_originalPhotoButton addTarget:self action:@selector(originalPhotoButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _originalPhotoButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_originalPhotoButton setTitle:_BYImagePickerVc.fullImageBtnTitleStr forState:UIControlStateNormal];
        [_originalPhotoButton setTitle:_BYImagePickerVc.fullImageBtnTitleStr forState:UIControlStateSelected];
        [_originalPhotoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_originalPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:_BYImagePickerVc.photoPreviewOriginDefImageName] forState:UIControlStateNormal];
        [_originalPhotoButton setImage:[UIImage imageNamedFromMyBundle:_BYImagePickerVc.photoOriginSelImageName] forState:UIControlStateSelected];
        
        _originalPhotoLabel = [[UILabel alloc] init];
        _originalPhotoLabel.textAlignment = NSTextAlignmentLeft;
        _originalPhotoLabel.font = [UIFont systemFontOfSize:13];
        _originalPhotoLabel.textColor = [UIColor whiteColor];
        _originalPhotoLabel.backgroundColor = [UIColor clearColor];
        if (_isSelectOriginalPhoto) [self showPhotoBytes];
    }
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_doneButton setTitle:_BYImagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
    [_doneButton setTitleColor:_BYImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
    
    _numberImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamedFromMyBundle:_BYImagePickerVc.photoNumberIconImageName]];
    _numberImageView.backgroundColor = [UIColor clearColor];
    _numberImageView.hidden = _BYImagePickerVc.selectedModels.count <= 0;
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.font = [UIFont systemFontOfSize:15];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_BYImagePickerVc.selectedModels.count];
    _numberLabel.hidden = _BYImagePickerVc.selectedModels.count <= 0;
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    [_originalPhotoButton addSubview:_originalPhotoLabel];
    [_toolBar addSubview:_doneButton];
    [_toolBar addSubview:_originalPhotoButton];
    [_toolBar addSubview:_numberImageView];
    [_toolBar addSubview:_numberLabel];
    [self.view addSubview:_toolBar];
}
    
- (void)configCollectionView {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.models.count * (self.view.BY_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[BYPhotoPreviewCell class] forCellWithReuseIdentifier:@"BYPhotoPreviewCell"];
    [_collectionView registerClass:[BYVideoPreviewCell class] forCellWithReuseIdentifier:@"BYVideoPreviewCell"];
    [_collectionView registerClass:[BYGifPreviewCell class] forCellWithReuseIdentifier:@"BYGifPreviewCell"];
}
    
- (void)configCropView {
    BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)self.navigationController;
    if (!_BYImagePickerVc.showSelectBtn && _BYImagePickerVc.allowCrop) {
        [_cropView removeFromSuperview];
        [_cropBgView removeFromSuperview];
        
        _cropBgView = [UIView new];
        _cropBgView.userInteractionEnabled = NO;
        _cropBgView.frame = self.view.bounds;
        _cropBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_cropBgView];
        [BYImageCropManager overlayClippingWithView:_cropBgView cropRect:_BYImagePickerVc.cropRect containerView:self.view needCircleCrop:_BYImagePickerVc.needCircleCrop];
        
        _cropView = [UIView new];
        _cropView.userInteractionEnabled = NO;
        _cropView.frame = _BYImagePickerVc.cropRect;
        _cropView.backgroundColor = [UIColor clearColor];
        _cropView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropView.layer.borderWidth = 1.0;
        if (_BYImagePickerVc.needCircleCrop) {
            _cropView.layer.cornerRadius = _BYImagePickerVc.cropRect.size.width / 2;
            _cropView.clipsToBounds = YES;
        }
        [self.view addSubview:_cropView];
        if (_BYImagePickerVc.cropViewSettingBlock) {
            _BYImagePickerVc.cropViewSettingBlock(_cropView);
        }
    }
}
    
#pragma mark - Layout
    
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)self.navigationController;
    
    _naviBar.frame = CGRectMake(0, 0, self.view.BY_width, 64);
    _backButton.frame = CGRectMake(10, 10, 44, 44);
    _selectButton.frame = CGRectMake(self.view.BY_width - 54, 10, 42, 42);
    
    _layout.itemSize = CGSizeMake(self.view.BY_width + 20, self.view.BY_height);
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _collectionView.frame = CGRectMake(-10, 0, self.view.BY_width + 20, self.view.BY_height);
    [_collectionView setCollectionViewLayout:_layout];
    if (_offsetItemCount > 0) {
        CGFloat offsetX = _offsetItemCount * _layout.itemSize.width;
        [_collectionView setContentOffset:CGPointMake(offsetX, 0)];
    }
    if (_BYImagePickerVc.allowCrop) {
        [_collectionView reloadData];
    }
    
    _toolBar.frame = CGRectMake(0, self.view.BY_height - 44, self.view.BY_width, 44);
    if (_BYImagePickerVc.allowPickingOriginalPhoto) {
        CGFloat fullImageWidth = [_BYImagePickerVc.fullImageBtnTitleStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
        _originalPhotoButton.frame = CGRectMake(0, 0, fullImageWidth + 56, 44);
        _originalPhotoLabel.frame = CGRectMake(fullImageWidth + 42, 0, 80, 44);
    }
    _doneButton.frame = CGRectMake(self.view.BY_width - 44 - 12, 0, 44, 44);
    _numberImageView.frame = CGRectMake(self.view.BY_width - 56 - 28, 7, 30, 30);
    _numberLabel.frame = _numberImageView.frame;
    
    [self configCropView];
}
    
#pragma mark - Notification
    
- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti {
    _offsetItemCount = _collectionView.contentOffset.x / _layout.itemSize.width;
}
    
#pragma mark - Click Event
    
- (void)select:(UIButton *)selectButton {
    BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)self.navigationController;
    BYAssetModel *model = _models[_currentIndex];
    if (!selectButton.isSelected) {
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_BYImagePickerVc.selectedModels.count >= _BYImagePickerVc.maxImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle BY_localizedStringForKey:@"Select a maximum of %zd photos"], _BYImagePickerVc.maxImagesCount];
            [_BYImagePickerVc showAlertWithTitle:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_BYImagePickerVc.selectedModels addObject:model];
            if (self.photos) {
                [_BYImagePickerVc.selectedAssets addObject:_assetsTemp[_currentIndex]];
                [self.photos addObject:_photosTemp[_currentIndex]];
            }
            if (model.type == BYAssetModelMediaTypeVideo && !_BYImagePickerVc.allowPickingMultipleVideo) {
                [_BYImagePickerVc showAlertWithTitle:[NSBundle BY_localizedStringForKey:@"Select the video when in multi state, we will handle the video as a photo"]];
            }
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_BYImagePickerVc.selectedModels];
        for (BYAssetModel *model_item in selectedModels) {
            if ([[[BYImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[BYImageManager manager] getAssetIdentifier:model_item.asset]]) {
                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_BYImagePickerVc.selectedModels];
                for (NSInteger i = 0; i < selectedModelsTmp.count; i++) {
                    BYAssetModel *model = selectedModelsTmp[i];
                    if ([model isEqual:model_item]) {
                        [_BYImagePickerVc.selectedModels removeObjectAtIndex:i];
                        break;
                    }
                }
                // [_BYImagePickerVc.selectedModels removeObject:model_item];
                if (self.photos) {
                    // 1.6.7版本更新:防止有多个一样的asset,一次性被移除了
                    NSArray *selectedAssetsTmp = [NSArray arrayWithArray:_BYImagePickerVc.selectedAssets];
                    for (NSInteger i = 0; i < selectedAssetsTmp.count; i++) {
                        id asset = selectedAssetsTmp[i];
                        if ([asset isEqual:_assetsTemp[_currentIndex]]) {
                            [_BYImagePickerVc.selectedAssets removeObjectAtIndex:i];
                            break;
                        }
                    }
                    // [_BYImagePickerVc.selectedAssets removeObject:_assetsTemp[_currentIndex]];
                    [self.photos removeObject:_photosTemp[_currentIndex]];
                }
                break;
            }
        }
    }
    model.isSelected = !selectButton.isSelected;
    [self refreshNaviBarAndBottomBarState];
    if (model.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:BYOscillatoryAnimationToBigger];
    }
    [UIView showOscillatoryAnimationWithLayer:_numberImageView.layer type:BYOscillatoryAnimationToSmaller];
}
    
- (void)backButtonClick {
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.backButtonClickBlock) {
        self.backButtonClickBlock(_isSelectOriginalPhoto);
    }
}
    
- (void)doneButtonClick {
    BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)self.navigationController;
    // 如果图片正在从iCloud同步中,提醒用户
    if (_progress > 0 && _progress < 1 && (_selectButton.isSelected || !_BYImagePickerVc.selectedModels.count )) {
        _alertView = [_BYImagePickerVc showAlertWithTitle:[NSBundle BY_localizedStringForKey:@"Synchronizing photos from iCloud"]];
        return;
    }
    
    // 如果没有选中过照片 点击确定时选中当前预览的照片
    if (_BYImagePickerVc.selectedModels.count == 0 && _BYImagePickerVc.minImagesCount <= 0) {
        BYAssetModel *model = _models[_currentIndex];
        [_BYImagePickerVc.selectedModels addObject:model];
    }
    if (_BYImagePickerVc.allowCrop) { // 裁剪状态
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
        BYPhotoPreviewCell *cell = (BYPhotoPreviewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        UIImage *cropedImage = [BYImageCropManager cropImageView:cell.previewView.imageView toRect:_BYImagePickerVc.cropRect zoomScale:cell.previewView.scrollView.zoomScale containerView:self.view];
        if (_BYImagePickerVc.needCircleCrop) {
            cropedImage = [BYImageCropManager circularClipImage:cropedImage];
        }
        if (self.doneButtonClickBlockCropMode) {
            BYAssetModel *model = _models[_currentIndex];
            self.doneButtonClickBlockCropMode(cropedImage,model.asset);
        }
    } else if (self.doneButtonClickBlock) { // 非裁剪状态
        self.doneButtonClickBlock(_isSelectOriginalPhoto);
    }
    if (self.doneButtonClickBlockWithPreviewType) {
        
        
        
        
        
        self.doneButtonClickBlockWithPreviewType(self.photos,_BYImagePickerVc.selectedAssets,self.isSelectOriginalPhoto);
    }
}
    
- (void)originalPhotoButtonClick {
    _originalPhotoButton.selected = !_originalPhotoButton.isSelected;
    _isSelectOriginalPhoto = _originalPhotoButton.isSelected;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) {
        [self showPhotoBytes];
        if (!_selectButton.isSelected) {
            // 如果当前已选择照片张数 < 最大可选张数 && 最大可选张数大于1，就选中该张图
            BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)self.navigationController;
            if (_BYImagePickerVc.selectedModels.count < _BYImagePickerVc.maxImagesCount && _BYImagePickerVc.showSelectBtn) {
                [self select:_selectButton];
            }
        }
    }
}
    
- (void)didTapPreviewCell {
    self.isHideNaviBar = !self.isHideNaviBar;
    _naviBar.hidden = self.isHideNaviBar;
    _toolBar.hidden = self.isHideNaviBar;
}
    
#pragma mark - UIScrollViewDelegate
    
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.BY_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.BY_width + 20);
    
    if (currentIndex < _models.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        [self refreshNaviBarAndBottomBarState];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoPreviewCollectionViewDidScroll" object:nil];
}
    
#pragma mark - UICollectionViewDataSource && Delegate
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)self.navigationController;
    BYAssetModel *model = _models[indexPath.row];
    
    BYAssetPreviewCell *cell;
    __weak typeof(self) weakSelf = self;
    if (_BYImagePickerVc.allowPickingMultipleVideo && model.type == BYAssetModelMediaTypeVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BYVideoPreviewCell" forIndexPath:indexPath];
    } else if (_BYImagePickerVc.allowPickingMultipleVideo && model.type == BYAssetModelMediaTypePhotoGif && _BYImagePickerVc.allowPickingGif) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BYGifPreviewCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BYPhotoPreviewCell" forIndexPath:indexPath];
        BYPhotoPreviewCell *photoPreviewCell = (BYPhotoPreviewCell *)cell;
        photoPreviewCell.cropRect = _BYImagePickerVc.cropRect;
        photoPreviewCell.allowCrop = _BYImagePickerVc.allowCrop;
        __weak typeof(_BYImagePickerVc) weakBYImagePickerVc = _BYImagePickerVc;
        __weak typeof(_collectionView) weakCollectionView = _collectionView;
        __weak typeof(photoPreviewCell) weakCell = photoPreviewCell;
        [photoPreviewCell setImageProgressUpdateBlock:^(double progress) {
            weakSelf.progress = progress;
            if (progress >= 1) {
                if (weakSelf.isSelectOriginalPhoto) [weakSelf showPhotoBytes];
                if (weakSelf.alertView && [weakCollectionView.visibleCells containsObject:weakCell]) {
                    [weakBYImagePickerVc hideAlertView:weakSelf.alertView];
                    weakSelf.alertView = nil;
                    [weakSelf doneButtonClick];
                }
            }
        }];
    }
    
    cell.model = model;
    [cell setSingleTapGestureBlock:^{
        [weakSelf didTapPreviewCell];
    }];
    return cell;
}
    
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BYPhotoPreviewCell class]]) {
        [(BYPhotoPreviewCell *)cell recoverSubviews];
    }
}
    
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BYPhotoPreviewCell class]]) {
        [(BYPhotoPreviewCell *)cell recoverSubviews];
    } else if ([cell isKindOfClass:[BYVideoPreviewCell class]]) {
        [(BYVideoPreviewCell *)cell pausePlayerAndShowNaviBar];
    }
}
    
#pragma mark - Private Method
    
- (void)dealloc {
    // NSLog(@"%@ dealloc",NSStringFromClass(self.class));
}
    
- (void)refreshNaviBarAndBottomBarState {
    BYImagePickerController *_BYImagePickerVc = (BYImagePickerController *)self.navigationController;
    BYAssetModel *model = _models[_currentIndex];
    _selectButton.selected = model.isSelected;
    _numberLabel.text = [NSString stringWithFormat:@"%zd",_BYImagePickerVc.selectedModels.count];
    _numberImageView.hidden = (_BYImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || _isCropImage);
    _numberLabel.hidden = (_BYImagePickerVc.selectedModels.count <= 0 || _isHideNaviBar || _isCropImage);
    
    _originalPhotoButton.selected = _isSelectOriginalPhoto;
    _originalPhotoLabel.hidden = !_originalPhotoButton.isSelected;
    if (_isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (!_isHideNaviBar) {
        if (model.type == BYAssetModelMediaTypeVideo) {
            _originalPhotoButton.hidden = YES;
            _originalPhotoLabel.hidden = YES;
        } else {
            _originalPhotoButton.hidden = NO;
            if (_isSelectOriginalPhoto)  _originalPhotoLabel.hidden = NO;
        }
    }
    
    _doneButton.hidden = NO;
    _selectButton.hidden = !_BYImagePickerVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    if (![[BYImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
        _numberLabel.hidden = YES;
        _numberImageView.hidden = YES;
        _selectButton.hidden = YES;
        _originalPhotoButton.hidden = YES;
        _originalPhotoLabel.hidden = YES;
        _doneButton.hidden = YES;
    }
}
    
- (void)showPhotoBytes {
    [[BYImageManager manager] getPhotosBytesWithArray:@[_models[_currentIndex]] completion:^(NSString *totalBytes) {
        _originalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}
    
    @end
