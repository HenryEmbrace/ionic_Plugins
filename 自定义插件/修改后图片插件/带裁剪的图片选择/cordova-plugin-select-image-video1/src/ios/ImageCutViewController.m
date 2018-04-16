//
//  ImageCutViewController.m
//  BoyueApp
//
//  Created by Embrace on 2017/8/25.
//
//

#import "ImageCutViewController.h"
#import "ShowGetImgArrCell.h"
@interface ImageCutViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

/**
 待裁剪的图片背景view
 */
@property (nonatomic, weak) UIScrollView * scrollView;


/**
 待裁剪的图片view
 */
@property (nonatomic, weak) UIImageView * imageView;

/**
 底部展示的待裁剪图片数组
 */
@property (nonatomic,strong) NSArray *imgArr;


/**
 待裁剪的图片数组
 */
@property (nonatomic, strong) NSMutableArray *imgGetArr;

/**
 确定裁剪的点击次数
 */
@property (nonatomic, assign) NSInteger num;

/**
 裁剪后的图片数组
 */
@property (nonatomic, strong) NSMutableArray *imgLatestArr;

/**
 图片资源
 */
@property (nonatomic, strong) UIImage * imageSource;


/**
 结果回调
 */
@property (nonatomic, copy) JKImageCutterCompletionHandler completionHandler;


/**
 缩放后的图片大小，并按此size重绘图片
 */
@property (nonatomic, assign) CGSize imageSize;


@property (nonatomic, assign, readonly) CGFloat scrollViewWH;
//@property (nonatomic, assign, readonly) CGFloat ImgWidth;
//@property (nonatomic, assign, readonly) CGFloat ImgHeight;

@end

@implementation ImageCutViewController

static inline CGSize JKMainScreenSize() {
    return [UIScreen mainScreen].bounds.size;
}


- (CGFloat)scrollViewWH {
    return MIN(JKMainScreenSize().width, JKMainScreenSize().height);
}

//- (CGFloat)ImgWidth {
//    return JKMainScreenSize().width;
//}
//
//- (CGFloat)ImgHeight {
//    return 240;
//}


//回掉方法
- (void)cutImage:(NSArray  *)imageSource completionHandler:(JKImageCutterCompletionHandler)completionHandler {
    
    self.imgGetArr = [imageSource copy];
    self.imageSource =[self.imgGetArr objectAtIndex:0] ;
    self.imgArr = imageSource;
    self.completionHandler = completionHandler;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
    
    //self.imgGetArr = [[NSMutableArray alloc] init];
    self.num = 0;
    
    if (self.imageSource == nil) {
        self.completionHandler = nil;
        [self cancelOrDropOut];
        return;
    }
    self.imgLatestArr = [[NSMutableArray alloc] init];
    
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 1.0;
    self.scrollView = scrollView;
    
    
    
    UIImageView * imageView = [[UIImageView alloc] init];
    //    imageView.backgroundColor = [UIColor redColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    scrollView.clipsToBounds = NO;
    self.view.clipsToBounds = YES;
    
    
    /// 计算布局
    CGFloat imageHeight = self.ImgHeight * (self.imageSource.size.height / self.imageSource.size.width);
    CGFloat imageWidth = self.ImgWidth;
    
    self.imageSize = CGSizeMake(imageWidth, imageHeight);
    
    
    scrollView.frame = CGRectMake((JKMainScreenSize().width - self.ImgWidth) / 2.0, (JKMainScreenSize().height - self.ImgHeight) / 2.0, self.ImgWidth, self.ImgHeight);
    NSLog(@"scrollView.frame : %@",NSStringFromCGRect(scrollView.frame));
    
    imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
    scrollView.contentSize = CGSizeMake(self.imageSize.width + 0.25, self.imageSize.height + 0.25);
    scrollView.contentOffset = CGPointMake(0.5 * (self.imageSize.width - self.ImgWidth), 0.5 * (self.imageSize.height - self.ImgHeight));
    
    
    
    imageView.image = self.imageSource = [self resizeImageAppropriately];
    //    = [self resizeImageAppropriately];
    
    
    /// 双击缩放手势
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
    
    
    
    /// 遮罩层
    [self addMaskLayer];
    
    /// 顶部按钮
    [self addBottomButtons];
    
    [self creatCollectView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---

- (void)addMaskLayer {
    UIView * maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    maskView.userInteractionEnabled = NO;
    [self.view addSubview:maskView];
    
    
    
    CGFloat lineWidth = 2.8f;
    //    CGFloat ovalFrameY = JKMainScreenSize().width > JKMainScreenSize().height ? lineWidth : (JKMainScreenSize().height - JKMainScreenSize().width) / 2.0 + lineWidth;
    //    CGFloat ovalFrameY =  (JKMainScreenSize().height - _width)/2;
    //    CGRect ovalFrame = CGRectMake((JKMainScreenSize().width - self.scrollViewWH) / 2.0 + lineWidth, ovalFrameY, _width, _height);
    
    CGFloat ovalFrameY = JKMainScreenSize().width > JKMainScreenSize().height ? lineWidth : (JKMainScreenSize().height - _ImgHeight) / 2.0 + lineWidth;
    CGRect ovalFrame = CGRectMake((JKMainScreenSize().width - self.scrollViewWH) / 2.0 + lineWidth,  ovalFrameY, self.scrollViewWH - lineWidth * 2, self.ImgHeight - lineWidth * 2);
    
    
    
    
    
    
    
    
    
    UIBezierPath * subPath = nil;
    if (self.type == JKImageCutterTypeRounded) {
        subPath = [UIBezierPath bezierPathWithRoundedRect:ovalFrame cornerRadius:self.scrollViewWH * 0.5];
    } else {
        subPath = [UIBezierPath bezierPathWithRoundedRect:ovalFrame cornerRadius:0];
    }
    [subPath closePath];
    
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [bezierPath appendPath:subPath.bezierPathByReversingPath];
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = bezierPath.CGPath;
    maskView.layer.mask = maskLayer;
    
    CAShapeLayer * borderLayer = [CAShapeLayer layer];
    UIBezierPath * borderPath = [UIBezierPath bezierPathWithCGPath:subPath.CGPath];
    borderLayer.path = borderPath.CGPath;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.lineWidth = lineWidth;
    [maskView.layer addSublayer:borderLayer];
    
}

- (void)addBottomButtons {
    CGFloat buttonWidth = 30;
    CGFloat margin = 50;
    
    //    UIImage * cancelImage = [self redrawButtonBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JKImageCutter_Cancel.png" ofType:nil]]];
    
    UIImage * cancelImage = [UIImage imageNamed:@"JKImageCutter_Cancel.png"];
    
    UIButton * cancelButton = [self buttonWithImage:cancelImage frame:CGRectMake(margin, margin, buttonWidth, buttonWidth) target:self action:@selector(cancelOrDropOut)];
    [self.view addSubview:cancelButton];
    
    //    UIImage * selectedImage = [self redrawButtonBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JKImageCutter_Selected.png" ofType:nil]]];
    UIImage *selectedImage = [UIImage imageNamed:@"JKImageCutter_Selected.png"];
    UIButton * doneButton = [self buttonWithImage:selectedImage frame:CGRectMake(JKMainScreenSize().width - margin - buttonWidth, cancelButton.frame.origin.y, buttonWidth, buttonWidth) target:self action:@selector(clipImage)];
    [self.view addSubview:doneButton];
}


-(void)creatCollectView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(60, 60);
    layout.minimumLineSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, JKMainScreenSize().height - 80, [UIScreen mainScreen].bounds.size.width, 62) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor darkGrayColor];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [self.view addSubview:collectionView];
    [collectionView registerClass:[ShowGetImgArrCell class] forCellWithReuseIdentifier:@"ImgCell"];
    
}

#pragma mark - collectionViewdDataSource

//设置集合视图分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//返回每个分区 item 的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return _imgArr.count;
}
//针对于每个 item 返回 UICollectionViewCell 对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShowGetImgArrCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCell" forIndexPath:indexPath];
    cell.imgView.image = _imgArr[indexPath.item];
    //    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (UIButton *)buttonWithImage:(UIImage *)image frame:(CGRect)frame target:(id)target action:(SEL)action {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = frame;
    return button;
}


- (UIImage *)resizeImageAppropriately {
    UIGraphicsBeginImageContextWithOptions(self.imageSize, NO, [UIScreen mainScreen].scale);
    [self.imageSource drawInRect:CGRectMake(0, 0, self.imageSize.width, self.imageSize.height)];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale == 1.0) {
        scrollView.contentSize = CGSizeMake(self.imageSize.width + 0.25, self.imageSize.height + 0.25);
    }
}


#pragma mark - 点击事件


/**
 双击定点放大
 
 @param tapGesture 双击
 */
- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (self.scrollView.zoomScale > 1.0) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint location = [tapGesture locationInView:self.scrollView];
        CGRect zoomRect = CGRectZero;
        zoomRect.size.height = tapGesture.view.frame.size.height / 3.0;
        zoomRect.size.width  = tapGesture.view.frame.size.width  / 3.0;
        zoomRect.origin.x = location.x - (zoomRect.size.width  / 2.0);
        zoomRect.origin.y = location.y - (zoomRect.size.height / 2.0) + self.scrollView.contentInset.top;
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}



/**
 根据画框裁剪图片
 */
- (void)clipImage {
    CGRect clipRange = CGRectMake(- self.scrollView.contentOffset.x,
                                  - self.scrollView.contentOffset.y,
                                  self.imageView.frame.size.width,
                                  self.imageView.frame.size.height);
    
    CGRect maskRange = CGRectMake(0, 0, self.scrollView.frame.size.width,
                                  self.scrollView.frame.size.height);
    
    UIBezierPath * bezierPath = nil;
    if (self.type == JKImageCutterTypeSquare) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:maskRange cornerRadius:0];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:maskRange cornerRadius:maskRange.size.width * 0.5];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.scrollView.frame.size, NO, [UIScreen mainScreen].scale);
    [bezierPath addClip];
    [self.imageSource drawInRect:clipRange];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.imgLatestArr addObject:image];
    
    
    NSLog(@"imgarr.count+++ :%ld",self.imgLatestArr.count);
    if (    self.imgGetArr.count == 1) {
        [self cancelOrDropOut];
    } else {
        [self imgArrNew];
        
    }
    
    
    
    //[self cancelOrDropOut];
}


// 自动前往后一张待裁剪的图片
-(void)imgArrNew {
    NSLog(@"line:%d self.imgGetArr %ld", __LINE__, self.imgGetArr.count);
    NSLog(@"line:%d num:%ld", __LINE__, self.num);
    self.num += 1;
    NSLog(@"line:%d num:%ld", __LINE__, self.num);
    
    
    if (self.imgGetArr.count > 0 && self.num < self.imgGetArr.count) {
        //        [self.imgGetArr removeObjectAtIndex:0];
        self.imageSource = [self.imgGetArr objectAtIndex:self.num];
        //        self.imageView.image = self.imageSource = [self resizeImageAppropriately];
        
        
        CGFloat imageHeight = self.scrollViewWH * (self.imageSource.size.height / self.imageSource.size.width);
        CGFloat imageWidth = self.scrollViewWH;
        if (imageHeight < self.scrollViewWH) {
            imageWidth = self.scrollViewWH * (imageWidth / imageHeight);
            imageHeight = self.scrollViewWH;
        }
        self.imageSize = CGSizeMake(imageWidth, imageHeight);
        _scrollView.frame = CGRectMake((JKMainScreenSize().width - self.scrollViewWH) / 2.0, (JKMainScreenSize().height - self.scrollViewWH) / 2.0, self.scrollViewWH, self.scrollViewWH);
        _imageView.frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);
        _scrollView.contentSize = CGSizeMake(self.imageSize.width + 0.25, self.imageSize.height + 0.25);
        _scrollView.contentOffset = CGPointMake(0.5 * (self.imageSize.width - self.scrollViewWH), 0.5 * (self.imageSize.height - self.scrollViewWH));
        self.imageView.image = self.imageSource;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
    } else {
        [self cancelOrDropOut];
    }
    
}

- (void)dealloc {
    NSLog(@"aaaaa");
}

/**
 退出
 */
- (void)cancelOrDropOut {
    
 [self dismissViewControllerAnimated:YES completion:nil];
    if (self.completionHandler) {
        self.completionHandler(self.imgLatestArr);
        self.completionHandler = nil;
    }
}



@end


@implementation UINavigationController (JKImageCutter)

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

@end

