//
//  YXBlindBoxLiftAnimationManager.h
//  MuchProj
//
//  Created by Augus on 2021/11/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 动画结束回调 */
typedef void(^YXBlindBoxLiftAnimationManagerBlock)(NSInteger amount);

@interface YXBlindBoxLiftAnimationManager : NSObject <CAAnimationDelegate>

@property (nonatomic, strong, nullable) CALayer *layer;
@property (nonatomic, copy) YXBlindBoxLiftAnimationManagerBlock yxBlindBoxLiftAnimationManagerBlock;

+ (instancetype)shareManager;

/**
 * 开始动画
 * @param fromView 开始view（加入购物车按钮）
 * @param toView 结束view（购物车view）
 * @param showBgView 显示的基础视图
 * @param imgView 商品图片view
 */
- (void)startAnimationandFromView:(UIView *)fromView
                           toView:(UIView *)toView
                       showBgView:(UIView *)showBgView
                          imgView:(UIImageView *)imgView;

@end

NS_ASSUME_NONNULL_END
