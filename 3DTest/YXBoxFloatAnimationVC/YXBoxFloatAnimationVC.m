//
//  YXBoxFloatAnimationVC.m
//  3DTest
//
//  Created by Augus on 2021/11/25.
//

#import "YXBoxFloatAnimationVC.h"

/** 弧度转角度 */
#define kRadiasToDegrees(radias) ((radias) * (180.0 / M_PI))
/** 角度转弧度 */
#define kDegreesToRadias(angle) ((angle) / 180.0 * M_PI)

@interface YXBoxFloatAnimationVC ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
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

@implementation YXBoxFloatAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _width = 200;
    _height = 100;
    _angle = kDegreesToRadias(20);
    [self initView];
    _transform = CATransform3DIdentity;
    _transform.m34 = 1.0 / -500;
    _transform = CATransform3DRotate(_transform, _angle, -0.1, -0.1, 0);
    self.containerView.layer.sublayerTransform = _transform;
    
    [self initOutView:0.5];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"动画" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 30);
    [btn addTarget:self action:@selector(progressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self initTitleLab];
}

#pragma mark - progress
- (void)progressBtn:(UIButton *)sender {
    
    sender.selected =! sender.selected;
    
    if (sender.isSelected) {
        [self boxMergeAndFloatAnimation];
    }
    else {
        [self boxSpreadAnimation];
    }
}

#pragma mark - 合并动画
- (void)boxMergeAndFloatAnimation {
    
    CGFloat mergeAngle = kDegreesToRadias(1);
    CGFloat speed = 5;
    __block CGFloat timing = 0;
    __weak typeof(self) weakSelf = self;
    
    NSTimer *transformTimer = [NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {

        weakSelf.transform = CATransform3DRotate(weakSelf.transform, mergeAngle, 1, 1, 0.5);
        weakSelf.containerView.layer.sublayerTransform = weakSelf.transform;
    }];
    [[NSRunLoop currentRunLoop] addTimer:transformTimer forMode:NSRunLoopCommonModes];
    
    __block BOOL boolEnd = NO;
    __block CGFloat floatValue = 0;
    CGFloat zValue = _height / 0.5;
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {

        if (timing == 0.1) {
            if (!boolEnd) {
                [UIView animateWithDuration:speed animations:^{
                    
                    weakSelf.frontImgV.layer.transform = CATransform3DTranslate(weakSelf.frontImgV.layer.transform, 0, 0, -zValue);
                    weakSelf.backImgV.layer.transform = CATransform3DTranslate(weakSelf.backImgV.layer.transform, 0, 0, zValue);
                    weakSelf.leftImgV.layer.transform = CATransform3DTranslate(weakSelf.leftImgV.layer.transform, 0, 0, zValue);
                    weakSelf.rightImgV.layer.transform = CATransform3DTranslate(weakSelf.rightImgV.layer.transform, 0, 0, -zValue);
                    weakSelf.topImgV.layer.transform = CATransform3DTranslate(weakSelf.topImgV.layer.transform, 0, 0, -zValue);
                    weakSelf.bottomImgV.layer.transform = CATransform3DTranslate(weakSelf.bottomImgV.layer.transform, 0, 0, -zValue);
                } completion:^(BOOL finished) {
                    
                    boolEnd = YES;
                }];
            }
        }
        else if (timing == speed) {
            timing = 0;
        }
        
        if (floatValue >= speed * 1.4) {
            [timer setFireDate:[NSDate distantFuture]];
            [transformTimer setFireDate:[NSDate distantFuture]];
            [weakSelf boxFloatAnimation];
        }
        
        timing += 0.1;
        floatValue += 0.1;
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 散开动画
- (void)boxSpreadAnimation {
    
    CGFloat mergeAngle = -kDegreesToRadias(1);
    CGFloat speed = 5;
    __block CGFloat timing = 0;
    __weak typeof(self) weakSelf = self;
    
    NSTimer *transformTimer = [NSTimer timerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {

        weakSelf.transform = CATransform3DRotate(weakSelf.transform, mergeAngle, 1, 1, 0.5);
        weakSelf.containerView.layer.sublayerTransform = weakSelf.transform;
    }];
    [[NSRunLoop currentRunLoop] addTimer:transformTimer forMode:NSRunLoopCommonModes];
    
    CGFloat zValue = _height / 0.5;
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {

        if (timing == 0.1) {
            [UIView animateWithDuration:speed animations:^{
                
                weakSelf.frontImgV.layer.transform = CATransform3DTranslate(weakSelf.frontImgV.layer.transform, 0, 0, zValue);
                weakSelf.backImgV.layer.transform = CATransform3DTranslate(weakSelf.backImgV.layer.transform, 0, 0, -zValue);
                weakSelf.leftImgV.layer.transform = CATransform3DTranslate(weakSelf.leftImgV.layer.transform, 0, 0, -zValue);
                weakSelf.rightImgV.layer.transform = CATransform3DTranslate(weakSelf.rightImgV.layer.transform, 0, 0, zValue);
                weakSelf.topImgV.layer.transform = CATransform3DTranslate(weakSelf.topImgV.layer.transform, 0, 0, zValue);
                weakSelf.bottomImgV.layer.transform = CATransform3DTranslate(weakSelf.bottomImgV.layer.transform, 0, 0, zValue);
            } completion:^(BOOL finished) {
                
                [timer setFireDate:[NSDate distantFuture]];
                [transformTimer setFireDate:[NSDate distantFuture]];
            }];
        }
        else if (timing >= speed) {
            timing = 0;
        }
        timing += 0.1;
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

#pragma mark - 初始化外围放大视图
- (void)initOutView:(CGFloat)value {
    
    _frontImgV.layer.transform = CATransform3DTranslate(_frontImgV.layer.transform, 0, 0, (_height / value));
    _backImgV.layer.transform = CATransform3DTranslate(_backImgV.layer.transform, 0, 0, -(_height / value));
    _leftImgV.layer.transform = CATransform3DTranslate(_leftImgV.layer.transform, 0, 0, -(_height / value));
    _rightImgV.layer.transform = CATransform3DTranslate(_rightImgV.layer.transform, 0, 0, (_width - _height) / value);
    _topImgV.layer.transform = CATransform3DTranslate(_topImgV.layer.transform, 0, 0, (_height / value));
    _bottomImgV.layer.transform = CATransform3DTranslate(_bottomImgV.layer.transform, 0, 0, (_height / value));
}

#pragma mark - 收缩动画
- (void)inViewAnimation:(CGFloat)value removeValue:(CGFloat)removeValue {
    
    _frontImgV.layer.transform = CATransform3DTranslate(_frontImgV.layer.transform, 0, 0, -(value + removeValue));
    _backImgV.layer.transform = CATransform3DTranslate(_backImgV.layer.transform, 0, 0, (value + removeValue));
    _leftImgV.layer.transform = CATransform3DTranslate(_leftImgV.layer.transform, 0, 0, (value + removeValue));
    _rightImgV.layer.transform = CATransform3DTranslate(_rightImgV.layer.transform, 0, 0, -value - removeValue);
    _topImgV.layer.transform = CATransform3DTranslate(_topImgV.layer.transform, 0, 0, -(value + removeValue));
    _bottomImgV.layer.transform = CATransform3DTranslate(_bottomImgV.layer.transform, 0, 0, -(value + removeValue));
}

#pragma mark - 放大动画
- (void)outViewAnimation:(CGFloat)value addValue:(CGFloat)addValue {
    
    _frontImgV.layer.transform = CATransform3DTranslate(_frontImgV.layer.transform, 0, 0, (value + addValue));
    _backImgV.layer.transform = CATransform3DTranslate(_backImgV.layer.transform, 0, 0, -(value + addValue));
    _leftImgV.layer.transform = CATransform3DTranslate(_leftImgV.layer.transform, 0, 0, -(value + addValue));
    _rightImgV.layer.transform = CATransform3DTranslate(_rightImgV.layer.transform, 0, 0, value + addValue);
    _topImgV.layer.transform = CATransform3DTranslate(_topImgV.layer.transform, 0, 0, value + addValue);
    _bottomImgV.layer.transform = CATransform3DTranslate(_bottomImgV.layer.transform, 0, 0, value + addValue);
}

- (void)initTitleLab {
    
    UILabel *frontLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    frontLab.center = self.frontImgV.center;
    frontLab.font = [UIFont systemFontOfSize:14];
    frontLab.textColor = [UIColor redColor];
    frontLab.textAlignment = NSTextAlignmentCenter;
    frontLab.text = @"front";
    [self.frontImgV addSubview:frontLab];
    
    UILabel *backLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    backLab.center = self.backImgV.center;
    backLab.font = [UIFont systemFontOfSize:14];
    backLab.textColor = [UIColor redColor];
    backLab.textAlignment = NSTextAlignmentCenter;
    backLab.text = @"back";
    [self.backImgV addSubview:backLab];
    
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    leftLab.center = self.leftImgV.center;
    leftLab.font = [UIFont systemFontOfSize:14];
    leftLab.textColor = [UIColor redColor];
    leftLab.textAlignment = NSTextAlignmentCenter;
    leftLab.text = @"left";
    [self.leftImgV addSubview:leftLab];
    
    UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    rightLab.center = self.rightImgV.center;
    rightLab.font = [UIFont systemFontOfSize:14];
    rightLab.textColor = [UIColor redColor];
    rightLab.textAlignment = NSTextAlignmentCenter;
    rightLab.text = @"right";
    [self.rightImgV addSubview:rightLab];
    
    UILabel *topLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    topLab.center = self.topImgV.center;
    topLab.font = [UIFont systemFontOfSize:14];
    topLab.textColor = [UIColor redColor];
    topLab.textAlignment = NSTextAlignmentCenter;
    topLab.text = @"top";
    [self.topImgV addSubview:topLab];
    
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    bottomLab.center = self.bottomImgV.center;
    bottomLab.font = [UIFont systemFontOfSize:14];
    bottomLab.textColor = [UIColor redColor];
    bottomLab.textAlignment = NSTextAlignmentCenter;
    bottomLab.text = @"bottom";
    [self.bottomImgV addSubview:bottomLab];
}

#pragma mark - 初始化视图
- (void)initView {
    
    //前
    _frontImgV = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    _frontImgV.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:1];
    _frontImgV.layer.transform = CATransform3DTranslate(_frontImgV.layer.transform, 0, 0, (_height / 2));
    [self.containerView addSubview:_frontImgV];
    
    //后
    _backImgV = [[UIImageView alloc] initWithFrame:self.containerView.bounds];
    _backImgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    _backImgV.layer.transform = CATransform3DTranslate(_backImgV.layer.transform, 0, 0, -(_height / 2));
    [self.containerView addSubview:_backImgV];
    
    //左
    _leftImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _height, _height)];
    _leftImgV.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:1];
    _leftImgV.layer.transform = CATransform3DTranslate(_leftImgV.layer.transform, -(_height / 2), 0, 0);
    _leftImgV.layer.transform = CATransform3DRotate(_leftImgV.layer.transform, M_PI_2, 0, 1, 0);
    [self.containerView addSubview:_leftImgV];
    
    //右
    _rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _height, _height)];
    _rightImgV.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
    _rightImgV.layer.transform = CATransform3DTranslate(_rightImgV.layer.transform, (_width * 2 - _height) / 2, 0, 0);
    _rightImgV.layer.transform = CATransform3DRotate(_rightImgV.layer.transform, M_PI_2, 0, 1, 0);
    [self.containerView addSubview:_rightImgV];
    
    //上
    _topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
    _topImgV.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:1];
    _topImgV.layer.transform = CATransform3DTranslate(_topImgV.layer.transform, 0, -(_height / 2), 0);
    _topImgV.layer.transform = CATransform3DRotate(_topImgV.layer.transform, M_PI_2, 1, 0, 0);
    [self.containerView addSubview:_topImgV];
    
    //下
    _bottomImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
    _bottomImgV.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:1];
    _bottomImgV.layer.transform = CATransform3DTranslate(_bottomImgV.layer.transform, 0, (_height / 2), 0);
    _bottomImgV.layer.transform = CATransform3DRotate(_bottomImgV.layer.transform, M_PI_2, -1, 0, 0);
    [self.containerView addSubview:_bottomImgV];
}

#pragma mark - 懒加载
- (UIView *)containerView {
    
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
        _containerView.center = self.view.center;
        [self.view addSubview:_containerView];
    }
    return _containerView;
}


#pragma mark - 其它
- (void)squareMethod {
    
    CGFloat width = 100;
    CGFloat valueWidth = width;
    CGRect targetBounds = (CGRect){CGPointZero,CGSizeMake(width, width)};
    UIView *animateCube = [[UIView alloc] initWithFrame:targetBounds];
    animateCube.center = self.view.center;
    [self.view addSubview:animateCube];
    
    UIView *test = [[UIView alloc] initWithFrame:targetBounds]; //front
    test.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:1];
    test.layer.transform = CATransform3DTranslate(test.layer.transform, 0, 0, valueWidth);
    
    UIView *test1 = [[UIView alloc] initWithFrame:targetBounds]; //back
    test1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    test1.layer.transform = CATransform3DTranslate(test1.layer.transform, 0, 0, -valueWidth);
    
    UIView *test2 = [[UIView alloc] initWithFrame:targetBounds]; //left
    test2.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:1];
    test2.layer.transform = CATransform3DTranslate(test2.layer.transform, -valueWidth, 0, 0);
    test2.layer.transform = CATransform3DRotate(test2.layer.transform, M_PI_2, 0, 1, 0);
    
    UIView *test3 = [[UIView alloc] initWithFrame:targetBounds]; //right
    test3.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
    test3.layer.transform = CATransform3DTranslate(test3.layer.transform, valueWidth, 0, 0);
    test3.layer.transform = CATransform3DRotate(test3.layer.transform, M_PI_2, 0, 1, 0);
    
    UIView *test4 = [[UIView alloc] initWithFrame:targetBounds]; //head
    test4.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:1];
    test4.layer.transform = CATransform3DTranslate(test4.layer.transform, 0, valueWidth, 0);
    test4.layer.transform = CATransform3DRotate(test4.layer.transform, M_PI_2, 1, 0, 0);
    
    UIView *test5 = [[UIView alloc] initWithFrame:targetBounds]; //foot
    test5.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:1];
    test5.layer.transform = CATransform3DTranslate(test5.layer.transform, 0, -valueWidth, 0);
    test5.layer.transform = CATransform3DRotate(test5.layer.transform, M_PI_2, -1, 0, 0);

    [animateCube addSubview:test];
    [animateCube addSubview:test1];
    [animateCube addSubview:test2];
    [animateCube addSubview:test3];
    [animateCube addSubview:test4];
    [animateCube addSubview:test5];
    
    animateCube.transform = CGAffineTransformMakeScale(1, 1);
    
    __block CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    
    float angle = M_PI / 360;
    animateCube.layer.sublayerTransform = transform;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 / 60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        transform = CATransform3DRotate(transform, angle, 1, 1, 0.5);
        animateCube.layer.sublayerTransform = transform;
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

}

@end
