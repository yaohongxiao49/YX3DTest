//
//  YX3DCollectionViewCell.m
//  3DTest
//
//  Created by Augus on 2022/5/16.
//

#import "YX3DCollectionViewCell.h"

@interface YX3DCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgV;

@end

@implementation YX3DCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initView];
    }
    return self;
}

- (void)reloadValueByArr:(NSMutableArray *)arr indexPath:(NSIndexPath *)indexPath {
    
    self.imgV.hidden = NO;
}

- (void)initView {
    
    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
}

#pragma mark - 懒加载
- (UIImageView *)imgV {
    
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.contentView.bounds.size.width - 10, self.contentView.bounds.size.height - 10)];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.clipsToBounds = YES;
        [_imgV setImage:[UIImage imageNamed:@"111.jpeg"]];
        [self.contentView addSubview:_imgV];
    }
    return _imgV;
}

@end
