//
//  YX3DBallCollectionViewLayout.h
//  YXCollectionViewAroundTest
//
//  Created by Augus on 2022/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YX3DBallCollectionViewLayoutType) {
    /** 自定义 */
    YX3DBallCollectionViewLayoutTypeDiy,
    /** 全包围（上、左、下、右） */
    YX3DBallCollectionViewLayoutTypeALL,
    /** 上 */
    YX3DBallCollectionViewLayoutTypeTop,
    /** 左 */
    YX3DBallCollectionViewLayoutTypeLeft,
    /** 下 */
    YX3DBallCollectionViewLayoutTypeBottom,
    /** 右 */
    YX3DBallCollectionViewLayoutTypeRight,
};

@class YX3DBallCollectionViewLayout;
@protocol YX3DBallCollectionViewLayoutDataSource <NSObject>

/** cellSize */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(YX3DBallCollectionViewLayout *)collectionViewLayout
   sizeForRowAtIndexPath:(NSIndexPath *)indexPath;

/** 显示类型 */
- (YX3DBallCollectionViewLayoutType)collectionView:(UICollectionView *)collectionView
                                            layout:(YX3DBallCollectionViewLayout *)collectionViewLayout
                             typeForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YX3DBallCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<YX3DBallCollectionViewLayoutDataSource>delegate;
@property (nonatomic, assign) CGFloat xValue;
@property (nonatomic, assign) CGFloat yValue;
@property (nonatomic, assign) CGFloat zValue;
/** 半径（radius == 2时，刚好形成无缝衔接，radius > 2时，值越大则半径越大） */
@property (nonatomic, assign) CGFloat radius;
/** 3D幅度 */
@property (nonatomic, assign) CGFloat amplitude;

@end

NS_ASSUME_NONNULL_END
