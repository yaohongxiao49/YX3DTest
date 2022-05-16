//
//  YXBlindBoxLiftAnimationManager.m
//  MuchProj
//
//  Created by Augus on 2021/11/29.
//

#import "YXBlindBoxLiftAnimationManager.h"

#define kAppWindow [[UIApplication sharedApplication] windows].firstObject

@interface YXBlindBoxLiftAnimationManager ()

@property (nonatomic, strong) NSMutableArray *layerArr;
@property (nonatomic, weak) UIView *shoppingCartView; //购物车view

@end

@implementation YXBlindBoxLiftAnimationManager

static YXBlindBoxLiftAnimationManager *_tool = nil;

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _tool = [[YXBlindBoxLiftAnimationManager alloc] init];
    });
    return _tool;
}

- (void)startAnimationandFromView:(UIView *)fromView toView:(UIView *)toView showBgView:(UIView *)showBgView imgView:(UIImageView *)imgView {
    
    _shoppingCartView = toView;
        
    self.layer = imgView.layer;
    self.layer.contents = (__bridge id)imgView.image.CGImage;
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.bounds = CGRectMake(CGRectGetMinX(fromView.frame), CGRectGetMinY(fromView.frame), imgView.bounds.size.width, imgView.bounds.size.height);
    [showBgView.layer addSublayer:self.layer];
    
    //获取fromView在self.view上的位置
    CGRect fromViewRect = [fromView convertRect:fromView.bounds toView:kAppWindow.rootViewController.view];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //初始点fromView的中心
    [path moveToPoint:CGPointMake(fromViewRect.origin.x + fromViewRect.size.width / 2, fromViewRect.origin.y + fromViewRect.size.height / 2)];
    
    //获取toView在self.view上的位置
    CGRect toViewRect = [toView convertRect:toView.bounds toView:kAppWindow.rootViewController.view];
    
    //增加一条曲线（终点是toView的）
    [path addCurveToPoint:CGPointMake(toViewRect.origin.x + toViewRect.size.width / 2, toViewRect.origin.y + toViewRect.size.height / 2) controlPoint1:CGPointMake(CGRectGetMinX(fromView.frame) + 5, [[UIScreen mainScreen] bounds].size.height - CGRectGetHeight(fromView.frame) - 100) controlPoint2:CGPointMake(CGRectGetMinX(fromView.frame) - 5, [[UIScreen mainScreen] bounds].size.height - CGRectGetHeight(fromView.frame) - 100)];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.path = path.CGPath;
    
    //缩小动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    
    //动画组
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation, scaleAnimation];
    groups.duration = 2.f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeRemoved;
    groups.delegate = self;
    groups.repeatCount = MAXFLOAT;
    [self.layer addAnimation:groups forKey:@"group"];
        
    [self.layerArr addObject:self.layer];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    
    if (animation == [self.layer animationForKey:@"group"]) {
        if (self.yxBlindBoxLiftAnimationManagerBlock) {
            self.yxBlindBoxLiftAnimationManagerBlock(self.layerArr.count);
        }
        //执行完成remove掉layer
        [self.layerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj removeFromSuperlayer];
            obj = nil;
        }];
        [self.layerArr removeAllObjects];
        
        //购物车按钮跳动动画
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [_shoppingCartView.layer addAnimation:shakeAnimation forKey:nil];
        _shoppingCartView = nil;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)layerArr {
    
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    return _layerArr;
}

@end
