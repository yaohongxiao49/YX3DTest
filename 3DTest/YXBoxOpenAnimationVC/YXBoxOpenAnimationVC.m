//
//  YXBoxOpenAnimationVC.m
//  3DTest
//
//  Created by Augus on 2021/11/25.
//

#import "YXBoxOpenAnimationVC.h"

/** 弧度转角度 */
#define kRadiasToDegrees(radias) ((radias) * (180.0 / M_PI))
/** 角度转弧度 */
#define kDegreesToRadias(angle) ((angle) / 180.0 * M_PI)

@interface YXBoxOpenAnimationVC ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CATransform3D transform;

@property (nonatomic, strong) NSMutableArray *imgVArr;
@property (nonatomic, strong) NSMutableArray *titleLabArr;

@end

@implementation YXBoxOpenAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _width = 140;
    _height = 200;
    [self initView];
    
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
        [self moveAndUpAnimationByArr:self.imgVArr];
    }
    else {
//        [self boxSpreadAnimation];
    }
}

#pragma mark - 上移放大
- (void)moveAndUpAnimationByArr:(NSMutableArray *)arr {
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat speed = 1;
    __block NSInteger index = 0;
    __block CGFloat timing = 0;
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        UIImageView *imgV = arr[index];
        if (timing == 0.1) {
            [UIView animateWithDuration:speed animations:^{

                imgV.layer.transform = CATransform3DScale(imgV.layer.transform, 60, 60, 1);
                imgV.layer.transform = CATransform3DTranslate(imgV.layer.transform, 0, -weakSelf.height, 0);
            } completion:^(BOOL finished) {
                
                [weakSelf downAndSendAnimationByImgV:imgV arr:arr];
            }];
            if (index == arr.count - 1) {
                [timer setFireDate:[NSDate distantFuture]];
            }
            index++;
        }
        else if (timing > speed / 3) {
            timing = 0;
        }
        timing += 0.1;
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 下移下发
- (void)downAndSendAnimationByArr:(NSMutableArray *)arr {
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat speed = 0.5;
    __block NSInteger index = 0;
    __block CGFloat i = 0;
    __block CGFloat j = 0;
    __block CGFloat timing = 0;
    CGFloat value = ([[UIScreen mainScreen] bounds].size.width - _width / 2) / arr.count;
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        UIImageView *imgV = arr[index];
        switch (imgV.tag) {
            case 0:
                i = -1.5;
                j = 1;
                break;
            case 1:
                i = 0;
                j = 1;
                break;
            case 2:
                i = 1.5;
                j = 1;
                break;
            case 3:
                i = -1.5;
                j = 2;
                break;
            case 4:
                i = 0;
                j = 2;
                break;
            case 5:
                i = 1.5;
                j = 2;
                break;
            default:
                break;
        }
        
        if (timing == 0.1) {
            [UIView animateWithDuration:speed animations:^{
                
                imgV.layer.transform = CATransform3DTranslate(imgV.layer.transform, value * i, weakSelf.height * j, 100);
            }];
            if (index == arr.count - 1) {
                [timer setFireDate:[NSDate distantFuture]];
            }
            index++;
        }
        else if (timing > speed / 2) {
            timing = 0;
        }
        timing += 0.1;
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)downAndSendAnimationByImgV:(UIImageView *)imgV arr:(NSMutableArray *)arr {
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat speed = 0.5;
    __block CGFloat i = 0;
    __block CGFloat j = 0;
    CGFloat value = ([[UIScreen mainScreen] bounds].size.width - _width) / arr.count;
    switch (imgV.tag) {
        case 0:
            i = -3;
            j = 1;
            break;
        case 1:
            i = 0;
            j = 1;
            break;
        case 2:
            i = 3;
            j = 1;
            break;
        case 3:
            i = -3;
            j = 2;
            break;
        case 4:
            i = 0;
            j = 2;
            break;
        case 5:
            i = 3;
            j = 2;
            break;
        default:
            break;
    }
    [UIView animateWithDuration:speed animations:^{
        
        imgV.layer.transform = CATransform3DTranslate(imgV.layer.transform, value * i, weakSelf.height * j, 100);
    }];
}

- (void)initTitleLab {
    
    _titleLabArr = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"first", @"second", @"third", @"four", @"five", @"six"];
    NSInteger i = 0;
    for (UIImageView *imgV in _imgVArr) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titleArr[i];
        label.alpha = 0;
        [imgV addSubview:label];
        [_titleLabArr addObject:label];
        i++;
    }
}

#pragma mark - progress
- (void)progressImg:(UITapGestureRecognizer *)gesture {
    
    UILabel *lab = _titleLabArr[gesture.view.tag];
    [UIView transitionWithView:gesture.view duration:2 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        lab.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 初始化视图
- (void)initView {
    
    _imgVArr = [[NSMutableArray alloc] init];
    
    NSArray *colorArr = @[[UIColor blueColor], [UIColor blackColor], [UIColor yellowColor], [UIColor purpleColor], [UIColor orangeColor], [UIColor greenColor]];
    for (NSInteger i = 0; i < 6; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
        imageView.center = self.view.center;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [colorArr[i] colorWithAlphaComponent:1];
        imageView.layer.transform = CATransform3DScale(imageView.layer.transform, 0.01, 0.01, 1);
        [self.view addSubview:imageView];
        [_imgVArr addObject:imageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressImg:)];
        [imageView addGestureRecognizer:gesture];
    }
}

@end
