//
//  YXBallAnimationJoiningImgManager.m
//  3DTest
//
//  Created by Augus on 2022/5/26.
//

#import "YXBallAnimationJoiningImgManager.h"

@implementation YXBallAnimationJoiningImgManager

+ (void)joiningImgByArr:(NSMutableArray *)arr contextSize:(CGSize)contextSize sonWidth:(CGFloat)sonWidth sonHeight:(CGFloat)sonHeight spacing:(CGFloat)spacing direction:(YXBallAnimationJIMDirectionType)direction endImgBlock:(void(^)(UIImage *endImg))endImgBlock {
    
    NSMutableArray *downsImgArr = [[NSMutableArray alloc] init];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (NSString *imgName in arr) {
        dispatch_group_async(group, queue, ^{
            
            if ([imgName containsString:@"http"]) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgName]];
                [downsImgArr addObject:[UIImage imageWithData:data]];
            }
            else {
                [downsImgArr addObject:[UIImage imageNamed:imgName]];
            }
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{

        UIImage *endImg;
        if (direction == YXBallAnimationJIMDirectionHorizontalType) {
            CGFloat width = sonWidth == 0 ? (contextSize.width - ((downsImgArr.count - 1) * spacing)) / downsImgArr.count : sonWidth;
            CGFloat height = sonHeight == 0 ? contextSize.height : sonHeight;
            
            //开启图形上下文
            UIGraphicsBeginImageContext(contextSize);
            
            NSInteger i = 0;
            for (UIImage *img in downsImgArr) {
                [img drawInRect:CGRectMake((width + spacing) * i, 0, width, height)];
                i++;
            }
            
            endImg = UIGraphicsGetImageFromCurrentImageContext();
            //关闭上下文
            UIGraphicsEndImageContext();
        }
        else {
            CGFloat width = sonWidth == 0 ? contextSize.width : sonWidth;
            CGFloat height = sonHeight == 0 ? (contextSize.height - ((downsImgArr.count - 1) * spacing)) / downsImgArr.count : sonHeight;
            
            //开启图形上下文
            UIGraphicsBeginImageContext(contextSize);
            
            NSInteger i = 0;
            for (UIImage *img in downsImgArr) {
                [img drawInRect:CGRectMake(0, (height + spacing) * i, width, height)];
                i++;
            }
            
            endImg = UIGraphicsGetImageFromCurrentImageContext();
            //关闭上下文
            UIGraphicsEndImageContext();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            endImgBlock(endImg);
        });
    });
}

@end
