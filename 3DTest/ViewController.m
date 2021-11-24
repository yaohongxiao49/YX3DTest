//
//  ViewController.m
//  3DTest
//
//  Created by Augus on 2021/11/24.
//

#import "ViewController.h"

/** 弧度转角度 */
#define kRadiasToDegrees(radias) ((radias) * (180.0 / M_PI))
/** 角度转弧度 */
#define kDegreesToRadias(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CATransform3D transform;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *frontImgV;
@property (nonatomic, strong) UIImageView *backImgV;
@property (nonatomic, strong) UIImageView *leftImgV;
@property (nonatomic, strong) UIImageView *rightImgV;
@property (nonatomic, strong) UIImageView *topImgV;
@property (nonatomic, strong) UIImageView *bottomImgV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _angle = kDegreesToRadias(20);
    
    [self initView];
    
    _transform = CATransform3DIdentity;
    _transform.m34 = 1.0 / -500;
    _transform = CATransform3DRotate(_transform, _angle, -0.1, -0.1, 0);
    _containerView.layer.sublayerTransform = _transform;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self boxFloatAnimation];
}

#pragma MARK - 合并动画
- (void)boxMergeAnimation {
    
    float mergeAngle = kDegreesToRadias(0.1);
    __weak typeof(self) weakSelf = self;
    __block CGFloat transformValue = 5.0;
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {

        transformValue -= 0.01;
        transformValue = transformValue < 1 ? 1 : transformValue;
        weakSelf.transform = CATransform3DRotate(weakSelf.transform, mergeAngle, 1, 1, 0.5);
        weakSelf.containerView.layer.sublayerTransform = weakSelf.transform;
        
        weakSelf.backImgV.layer.transform = CATransform3DTranslate(weakSelf.backImgV.layer.transform, 0, 0, -(weakSelf.backImgV.bounds.size.width / 3));
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 浮动动画
- (void)boxFloatAnimation {
    
    __weak typeof(self) weakSelf = self;
    __block CGFloat translateValue = 0.0;
    __block BOOL boolTranslateValue = NO;
    
    __block CGFloat rotateValue = 0.0;
    __block BOOL boolRotateValue = NO;
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {

        //上下浮动
        [self upAndDownAnimationByRranslateValue:translateValue boolTranslateValue:boolTranslateValue finished:^(CGFloat value, BOOL boolTranslate) {
            translateValue = value;
            boolTranslateValue = boolTranslate;
            
            self.transform = CATransform3DTranslate(self.transform, 0, boolTranslateValue ? -0.1 : 0.1, 0);
        }];
        
        //左右浮动
        [self leftAndRightAniamtionByRotateValue:rotateValue boolRotateValue:boolRotateValue finished:^(CGFloat value, BOOL boolRotate) {
            
            rotateValue = value;
            boolRotateValue = boolRotate;
            weakSelf.transform = CATransform3DRotate(weakSelf.transform, boolRotateValue ? kDegreesToRadias(0.15) : -kDegreesToRadias(0.15), 1, 1, 0.1);
        }];
        
        weakSelf.containerView.layer.sublayerTransform = weakSelf.transform;
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 上下浮动
- (void)upAndDownAnimationByRranslateValue:(CGFloat)translateValue boolTranslateValue:(BOOL)boolTranslateValue finished:(void(^)(CGFloat value, BOOL boolTranslate))finished {
    
    if (translateValue <= -1) {
        boolTranslateValue = NO;
    }
    else if (translateValue >= 1) {
        boolTranslateValue = YES;
    }
    if (boolTranslateValue) {
        translateValue -= 0.02;
    }
    else {
        translateValue += 0.02;
    }
    finished(translateValue, boolTranslateValue);
}

#pragma mark - 左右浮动
- (void)leftAndRightAniamtionByRotateValue:(CGFloat)rotateValue boolRotateValue:(BOOL)boolRotateValue finished:(void(^)(CGFloat value, BOOL boolRotate))finished {
    
    if (rotateValue <= -1) {
        boolRotateValue = NO;
    }
    else if (rotateValue >= 1) {
        boolRotateValue = YES;
    }
    if (boolRotateValue) {
        rotateValue -= 0.01;
    }
    else {
        rotateValue += 0.01;
    }
    finished(rotateValue, boolRotateValue);
}

#pragma mark - 初始化视图
- (void)initView {
    
    //前
    _frontImgV = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    _frontImgV.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:1];
    _frontImgV.layer.transform = CATransform3DTranslate(_frontImgV.layer.transform, 0, 0, _frontImgV.bounds.size.width / 3);
    [self.containerView addSubview:_frontImgV];
    
    //后
    _backImgV = [[UIImageView alloc] initWithFrame:_frontImgV.bounds];
    _backImgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    _backImgV.layer.transform = CATransform3DTranslate(_backImgV.layer.transform, 0, 0, -(_backImgV.bounds.size.width / 3));
    [self.containerView addSubview:_backImgV];
    
    //左
    _leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.containerView.bounds.size.width / 3 * 2, self.containerView.bounds.size.height)];
    _leftImgV.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:1];
    _leftImgV.layer.transform = CATransform3DTranslate(_leftImgV.layer.transform, -_leftImgV.bounds.size.width / 2, 0, 0);
    _leftImgV.layer.transform = CATransform3DRotate(_leftImgV.layer.transform, M_PI_2, 0, 1, 0);
    [self.containerView addSubview:_leftImgV];
    
    //右
    _rightImgV = [[UIImageView alloc] initWithFrame:_leftImgV.bounds];
    _rightImgV.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
    _rightImgV.layer.transform = CATransform3DTranslate(_rightImgV.layer.transform, _rightImgV.bounds.size.width, 0, 0);
    _rightImgV.layer.transform = CATransform3DRotate(_rightImgV.layer.transform, M_PI_2, 0, 1, 0);
    [self.containerView addSubview:_rightImgV];
    
    //上
    _topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _frontImgV.bounds.size.width, self.containerView.bounds.size.width / 3 * 2)];
    _topImgV.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:1];
    _topImgV.layer.transform = CATransform3DTranslate(_topImgV.layer.transform, 0, -_topImgV.bounds.size.height / 2, 0);
    _topImgV.layer.transform = CATransform3DRotate(_topImgV.layer.transform, M_PI_2, 1, 0, 0);
    [self.containerView addSubview:_topImgV];
    
    //下
    _bottomImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _backImgV.bounds.size.width, _topImgV.bounds.size.height)];
    _bottomImgV.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:1];
    _bottomImgV.layer.transform = CATransform3DTranslate(_bottomImgV.layer.transform, 0, _bottomImgV.bounds.size.height / 4, 0);
    _bottomImgV.layer.transform = CATransform3DRotate(_bottomImgV.layer.transform, M_PI_2, -1, 0, 0);
    [self.containerView addSubview:_bottomImgV];
}

#pragma mark - 懒加载
- (UIView *)containerView {
    
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _containerView.center = self.view.center;
        [self.view addSubview:_containerView];
    }
    return _containerView;
}


#pragma mark - 其它
- (void)squareMethod {
    
    
    CGRect targetBounds = (CGRect){CGPointZero,CGSizeMake(200, 200)};
    UIView *animateCube = [[UIView alloc] initWithFrame:targetBounds];
    animateCube.center = self.view.center;
    [self.view addSubview:animateCube];
    
    
    UIView *test = [[UIView alloc] initWithFrame:targetBounds];// front
    test.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
    test.layer.transform = CATransform3DTranslate(test.layer.transform, 0, 0, 100);
    
    UIView *test1 = [[UIView alloc] initWithFrame:targetBounds];// back
    test1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    test1.layer.transform = CATransform3DTranslate(test1.layer.transform, 0, 0, -100);
    
    UIView *test2 = [[UIView alloc] initWithFrame:targetBounds];// left
    test2.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    test2.layer.transform = CATransform3DTranslate(test2.layer.transform, -100, 0, 0);
    test2.layer.transform = CATransform3DRotate(test2.layer.transform, M_PI_2, 0, 1, 0);
    
    UIView *test3 = [[UIView alloc] initWithFrame:targetBounds];// right
    test3.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    test3.layer.transform = CATransform3DTranslate(test3.layer.transform, 100, 0, 0);
    test3.layer.transform = CATransform3DRotate(test3.layer.transform, M_PI_2, 0, 1, 0);
    
    UIView *test4 = [[UIView alloc] initWithFrame:targetBounds];// head
    test4.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
    test4.layer.transform = CATransform3DTranslate(test4.layer.transform, 0, 100, 0);
    test4.layer.transform = CATransform3DRotate(test4.layer.transform, M_PI_2, 1, 0, 0);
    
    UIView *test5 = [[UIView alloc] initWithFrame:targetBounds];// foot
    test5.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    test5.layer.transform = CATransform3DTranslate(test5.layer.transform, 0, -100, 0);
    test5.layer.transform = CATransform3DRotate(test5.layer.transform, M_PI_2, -1, 0, 0);

    [animateCube addSubview:test];
    [animateCube addSubview:test1];
    [animateCube addSubview:test2];
    [animateCube addSubview:test3];
    [animateCube addSubview:test4];
    [animateCube addSubview:test5];
    
    animateCube.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    __block CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0/-500;
    
    float angle = M_PI / 360;
    animateCube.layer.sublayerTransform = transform;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0/60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        transform = CATransform3DRotate(transform, angle, 1, 1, 0.5);
        animateCube.layer.sublayerTransform = transform;
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

}

@end
