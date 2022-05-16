//
//  YX3DCollectionViewCell.h
//  3DTest
//
//  Created by Augus on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YX3DCollectionViewCell : UICollectionViewCell

- (void)reloadValueByArr:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
