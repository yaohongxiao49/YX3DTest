//
//  YXBallAnimationVC.m
//  3DTest
//
//  Created by Augus on 2022/5/16.
//

#import "YXBallAnimationVC.h"
#import "YX3DBallCollectionViewLayout.h"
#import "YX3DBallBtnView.h"
#import "YX3DCollectionViewCell.h"
#import <SceneKit/SceneKit.h>
#import "YXBallAnimationJoiningImgManager.h"

/** 角度转弧度 */
#define kDegreesToRadias(angle) ((angle) / 180.0 * M_PI)

@interface YXBallAnimationVC () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, YX3DBallCollectionViewLayoutDataSource>

@property (nonatomic, retain) YX3DBallBtnView *sphereView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer; //时间控制器
@property (nonatomic, strong) NSMutableArray *collectionDataSourceArr;
@property (nonatomic, assign) CGFloat currentOffsetX;
@property (nonatomic, assign) CGFloat currentOffsetY;

@end

@implementation YXBallAnimationVC

- (void)dealloc {
    
    [self stopTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self closeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self initNormalCollectionView];
    [self initSCNView];
//    [self ballCollectionAnimation];
//    [self ballBtnAnimation];
//    [self joiningImg];
    
}
#pragma mark - 移除Timer
- (void)stopTimer {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark - 关闭Timer
- (void)closeTimer {
    
    [self.timer setFireDate:[NSDate distantFuture]];
}
#pragma mark - 开启Timer
- (void)openTimer {
    
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}

#pragma mark - timer
- (void)processAnimation:(NSTimer *)timer {
    
    _currentOffsetX -= 1;
    [self.collectionView setContentOffset:CGPointMake(_currentOffsetX, 0) animated:NO];
}

#pragma mark - progress
- (void)progressBtn:(UIButton *)btn {
    
    [self.sphereView timerStop];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            
            [weakSelf.sphereView timerStart];
        }];
    }];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _collectionDataSourceArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YX3DCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YX3DCollectionViewCell class]) forIndexPath:indexPath];
    [cell reloadValueByArr:_collectionDataSourceArr indexPath:indexPath];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
#pragma mark - <YX3DBallCollectionViewLayoutDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(YX3DBallCollectionViewLayout *)collectionViewLayout sizeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(80, 50);
}
- (YX3DBallCollectionViewLayoutType)collectionView:(UICollectionView *)collectionView layout:(YX3DBallCollectionViewLayout *)collectionViewLayout typeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YX3DBallCollectionViewLayoutTypeDiy;
}
 
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //实现循环滚动
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetX < scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(offsetX + (_collectionDataSourceArr.count * scrollView.bounds.size.width), offsetY);
    }
    else if (offsetX > (_collectionDataSourceArr.count + 1) * scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(offsetX - (_collectionDataSourceArr.count * scrollView.bounds.size.width), offsetY);
    }
    if (offsetY < scrollView.bounds.size.height) {
        scrollView.contentOffset = CGPointMake(offsetX, offsetY + (_collectionDataSourceArr.count * scrollView.bounds.size.height));
    }
    else if (offsetY > (_collectionDataSourceArr.count + 1) * scrollView.bounds.size.height) {
        scrollView.contentOffset = CGPointMake(offsetX, offsetY - (_collectionDataSourceArr.count * scrollView.bounds.size.height));
    }
    
    _currentOffsetX = offsetX;
    _currentOffsetY = offsetY;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self closeTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self openTimer];
}

// 判断图片是否翻转
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
#pragma mark - 初始化正常collectionView
- (void)initNormalCollectionView {
    
    _collectionDataSourceArr = [[NSMutableArray alloc] initWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6", @"1", @"2", @"3", @"4", @"5", @"6"]];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(100, 100, 200, 100) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[YX3DCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YX3DCollectionViewCell class])];
    [self.view addSubview:_collectionView];
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
//    animation.duration = 10.0;
//    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
//    animation.repeatCount = FLT_MAX;
//    [_collectionView.layer addAnimation:animation forKey:@"earth rotation around sun"];
}

#pragma mark - SCNView
- (void)initSCNView {
    
    SCNView *scnView = [[SCNView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    scnView.center = self.view.center;
    //创建一个场景,系统默认是没有的
    scnView.scene = [SCNScene scene];
    //先设置一个颜色看看游戏引擎有没有加载
    scnView.backgroundColor = [UIColor redColor];
    //手势交互
    scnView.allowsCameraControl = YES;
    scnView.defaultCameraController.interactionMode = SCNInteractionModeOrbitTurntable;
    scnView.defaultCameraController.inertiaEnabled = YES;
    scnView.defaultCameraController.maximumVerticalAngle = -50;
    scnView.defaultCameraController.minimumVerticalAngle = 49.5;
    //阴影光照
    scnView.autoenablesDefaultLighting = YES;
    //抗锯齿
    scnView.antialiasingMode = SCNAntialiasingModeMultisampling4X;
    //添加到scnView中去
    [self.view addSubview:scnView];

    //创建圆柱体
    SCNCylinder *cylinder = [SCNCylinder cylinderWithRadius:100 height:40];
    //中间
    SCNMaterial *centerMaterial = [[SCNMaterial alloc] init];
    centerMaterial.multiply.wrapS = centerMaterial.diffuse.wrapS = centerMaterial.multiply.wrapT = centerMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    centerMaterial.lightingModelName = SCNLightingModelConstant;
    centerMaterial.shininess = 0.1; //光泽
    centerMaterial.specular.intensity = 0.5; //反射多少光出去
    centerMaterial.specular.contents = [UIColor grayColor]; //反射出去的光是什么光
    centerMaterial.specular.contents = [UIColor blueColor]; //当我们此处换为红色的时候地球反光区域所反射出来的光也就是红色
    //顶部
    UIImage *sourceImage = [UIImage imageNamed:@"111.jpeg"];
    UIImage *flippedImage = [UIImage imageWithCGImage:sourceImage.CGImage scale:sourceImage.scale orientation:UIImageOrientationUpMirrored];
    SCNMaterial *topMaterial = [[SCNMaterial alloc] init];
    topMaterial.multiply.contents = flippedImage;
    topMaterial.diffuse.contents = flippedImage;
    topMaterial.multiply.wrapS = topMaterial.diffuse.wrapS = topMaterial.multiply.wrapT = topMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    //底部
    SCNMaterial *bottomMaterial = [[SCNMaterial alloc] init];
    bottomMaterial.multiply.contents = [UIImage imageNamed:@"111.jpeg"];
    bottomMaterial.diffuse.contents = [UIImage imageNamed:@"111.jpeg"];
    bottomMaterial.multiply.wrapS = bottomMaterial.diffuse.wrapS = bottomMaterial.multiply.wrapT = bottomMaterial.diffuse.wrapT = SCNWrapModeRepeat;
    
    cylinder.materials = @[centerMaterial, topMaterial, bottomMaterial];
    
    //设置实体类
    SCNNode *node = [SCNNode nodeWithGeometry:cylinder];
    node.position = SCNVector3Make(0, 0, -0.5);
//    node.transform = SCNMatrix4Rotate(SCNMatrix4Identity, kDegreesToRadias(8), 0.1, 0, 0);
//    node.pivot = SCNMatrix4Rotate(node.transform, kDegreesToRadias(8), -0.1, 0, 0);
    [scnView.scene.rootNode addChildNode:node];
    
    //旋转节点
    SCNAction *customAction = [SCNAction rotateByX:0 y:-1 z:0 duration:10];
    SCNAction *repeatCustomAction = [SCNAction repeatActionForever:customAction];
    SCNAction *otherAction = [SCNAction moveBy:SCNVector3Make(0, -50, 0) duration:0.1];
    SCNAction *otherCustomAction = [SCNAction repeatAction:otherAction count:1];
    //组动画
    SCNAction *groupAction = [SCNAction group:@[repeatCustomAction, otherCustomAction]];
    [node runAction:groupAction];
    
    NSMutableArray *imgsArr = [[NSMutableArray alloc] initWithArray:@[@"111.jpeg", @"111.jpeg", @"111.jpeg", @"111.jpeg", @"111.jpeg", @"111.jpeg", @"111.jpeg", @"111.jpeg", @"111.jpeg"]];
    [YXBallAnimationJoiningImgManager joiningImgByArr:imgsArr contextSize:CGSizeMake((80 + 10) * imgsArr.count, 60) sonWidth:80 sonHeight:60 spacing:10 direction:YXBallAnimationJIMDirectionHorizontalType endImgBlock:^(UIImage * _Nonnull endImg) {
      
        centerMaterial.multiply.contents = endImg;
        centerMaterial.diffuse.contents = endImg;
    }];
}

#pragma mark - ballCollection
- (void)ballCollectionAnimation {
    
    _collectionDataSourceArr = [[NSMutableArray alloc] initWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
    
    YX3DBallCollectionViewLayout *layout = [[YX3DBallCollectionViewLayout alloc] init];
    layout.delegate = self;
    layout.xValue = 0.0;
    layout.yValue = 1;
    layout.zValue = 0;
    layout.radius = 2;
    layout.amplitude = 1.0 / -1000.0;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 300) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YX3DCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YX3DCollectionViewCell class])];
    [self.view addSubview:_collectionView];
    _collectionView.center = self.view.center;

    _collectionView.contentOffset = CGPointMake(CGRectGetWidth(_collectionView.frame), CGRectGetHeight(_collectionView.frame));

    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = 1.0 / -500.0;
    transform3D = CATransform3DRotate(transform3D, (8) / 180.0 * M_PI, -0.1, 0, 0);
    self.collectionView.layer.sublayerTransform = transform3D;

    UIImageView *bottomImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 100)];
    bottomImgV.center = CGPointMake(_collectionView.center.x, _collectionView.center.y + 60);
    [bottomImgV setImage:[UIImage imageNamed:@"YXBottomImg"]];
    [self.view addSubview:bottomImgV];
    
    UIImageView *topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 100, 100)];
    [topImgV setImage:[UIImage imageNamed:@"YXTopImg"]];
    topImgV.center = CGPointMake(_collectionView.center.x, _collectionView.center.y - 40);
    [self.view addSubview:topImgV];

    [self openTimer];
}

#pragma mark - ballBtnAnimation
- (void)ballBtnAnimation {
    
    self.sphereView = [[YX3DBallBtnView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 50; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[NSString stringWithFormat:@"P%ld", i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:24];
        btn.frame = CGRectMake(0, 0, 60, 20);
        [btn addTarget:self action:@selector(progressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [self.sphereView addSubview:btn];
    }
    [self.sphereView setCloudTags:array];
    self.sphereView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.sphereView];
}

#pragma mark - 拼接图片
- (void)joiningImg {
    
    NSMutableArray *imgsArr = [[NSMutableArray alloc] initWithArray:@[@"111.jpeg", @"111.jpeg"]];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 200)];
    [YXBallAnimationJoiningImgManager joiningImgByArr:imgsArr contextSize:imgV.frame.size sonWidth:100 sonHeight:100 spacing:10 direction:YXBallAnimationJIMDirectionHorizontalType endImgBlock:^(UIImage * _Nonnull endImg) {
      
        [imgV setImage:endImg];
    }];
    [self.view addSubview:imgV];
}

#pragma mark - 懒加载
- (NSTimer *)timer {
    
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(processAnimation:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
    return _timer;
}

@end
