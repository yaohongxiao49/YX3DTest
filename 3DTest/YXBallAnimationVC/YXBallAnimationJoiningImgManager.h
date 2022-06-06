//
//  YXBallAnimationJoiningImgManager.h
//  3DTest
//
//  Created by Augus on 2022/5/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 拼接方向 */
typedef NS_ENUM(NSUInteger, YXBallAnimationJIMDirectionType) {
    /** 水平 */
    YXBallAnimationJIMDirectionHorizontalType,
    /** 垂直 */
    YXBallAnimationJIMDirectionVerticalType,
};

@interface YXBallAnimationJoiningImgManager : NSObject

/**
 * 拼接图片
 * @param arr 需要拼接的图片数组
 * @param contextSize 画布整体宽高
 * @param sonWidth 单个图片宽（默认为平均分）
 * @param sonHeight 单个图片高
 * @param spacing 间距（默认为0）
 * @param direction 拼接方向
 * @param endImgBlock 拼接回调
 */
+ (void)joiningImgByArr:(NSMutableArray *)arr
            contextSize:(CGSize)contextSize
               sonWidth:(CGFloat)sonWidth
              sonHeight:(CGFloat)sonHeight
                spacing:(CGFloat)spacing
              direction:(YXBallAnimationJIMDirectionType)direction
            endImgBlock:(void(^)(UIImage *endImg))endImgBlock;

@end

NS_ASSUME_NONNULL_END
