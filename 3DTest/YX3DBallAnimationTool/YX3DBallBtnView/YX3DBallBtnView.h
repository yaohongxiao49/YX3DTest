//
//  YX3DBallBtnView.h
//  YXCollectionViewAroundTest
//
//  Created by Augus on 2022/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YX3DBallBtnView : UIView

/**
 *  Sets the cloud's tag views.
 *
 *    @remarks Any @c UIView subview can be passed in the array.
 *
 *  @param array The array of tag views.
 */
- (void)setCloudTags:(NSArray *)array;

/**
 *  Starts the cloud autorotation animation.
 */
- (void)timerStart;

/**
 *  Stops the cloud autorotation animation.
 */
- (void)timerStop;

@end

NS_ASSUME_NONNULL_END
