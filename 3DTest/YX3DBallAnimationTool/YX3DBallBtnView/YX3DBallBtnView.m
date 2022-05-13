//
//  YX3DBallBtnView.m
//  YXCollectionViewAroundTest
//
//  Created by Augus on 2022/5/13.
//

#import "YX3DBallBtnView.h"
#import "YX3DBallBtnMatrix.h"

@interface YX3DBallBtnView ()
{
    
    YX3DBallBtnPoint _normalDirection;
    CGPoint _last;
}
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *coordinate;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, strong) CADisplayLink *inertia;

@end

@implementation YX3DBallBtnView

- (void)setup {
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:gesture];
    
    _inertia = [CADisplayLink displayLinkWithTarget:self selector:@selector(inertiaStep)];
    [_inertia addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoTurnRotation)];
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - setting
- (void)setCloudTags:(NSArray *)array {
    
    _tags = [NSMutableArray arrayWithArray:array];
    _coordinate = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger i = 0; i < _tags.count; i ++) {
        UIView *view = [_tags objectAtIndex:i];
        view.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    }
    
    CGFloat p1 = M_PI * (3 - sqrt(5));
    CGFloat p2 = 2. / _tags.count;
    
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < _tags.count; i ++) {
        CGFloat y = i * p2 - 1 + (p2 / 2);
        CGFloat r = sqrt(1 - y * y);
        CGFloat p3 = i * p1;
        CGFloat x = cos(p3) * r;
        CGFloat z = sin(p3) * r;

        YX3DBallBtnPoint point = YX3DBallBtnPointMake(x, y, z);
        NSValue *value = [NSValue value:&point withObjCType:@encode(YX3DBallBtnPoint)];
        [_coordinate addObject:value];
        
        CGFloat time = (arc4random() % 10 + 10.) / 20.;
        [UIView animateWithDuration:time delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [weakSelf setTagOfPoint:point andIndex:i];
        } completion:^(BOOL finished) {
            
        }];
    }
    
    NSInteger a =  arc4random() % 10 - 5;
    NSInteger b =  arc4random() % 10 - 5;
    _normalDirection = YX3DBallBtnPointMake(a, b, 0);
    
    [self timerStart];
}

#pragma mark - set frame of point
- (void)updateFrameOfPoint:(NSInteger)index direction:(YX3DBallBtnPoint)direction andAngle:(CGFloat)angle {

    NSValue *value = [_coordinate objectAtIndex:index];
    YX3DBallBtnPoint point;
    [value getValue:&point];
    
    YX3DBallBtnPoint rPoint = YX3DBallBtnPointMakeRotation(point, direction, angle);
    value = [NSValue value:&rPoint withObjCType:@encode(YX3DBallBtnPoint)];
    _coordinate[index] = value;
    
    [self setTagOfPoint:rPoint andIndex:index];
}

- (void)setTagOfPoint:(YX3DBallBtnPoint)point andIndex:(NSInteger)index {
    
    UIView *view = [_tags objectAtIndex:index];
    view.center = CGPointMake((point.x + 1) * (self.frame.size.width / 2.), (point.y + 1) * self.frame.size.width / 2.);
    
    CGFloat transform = (point.z + 2) / 3;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, transform, transform);
    view.layer.zPosition = transform;
    view.alpha = transform;
    if (point.z < 0) {
        view.userInteractionEnabled = NO;
    }
    else {
        view.userInteractionEnabled = YES;
    }
}

#pragma mark - autoTurnRotation
- (void)timerStart {
    
    _timer.paused = NO;
}
- (void)timerStop {
    
    _timer.paused = YES;
}
- (void)autoTurnRotation {
    
    for (NSInteger i = 0; i < _tags.count; i ++) {
        [self updateFrameOfPoint:i direction:_normalDirection andAngle:0.002];
    }
}

#pragma mark - inertia
- (void)inertiaStart {
    
    [self timerStop];
    _inertia.paused = NO;
}

- (void)inertiaStop {
    
    [self timerStart];
    _inertia.paused = YES;
}

- (void)inertiaStep {
    
    if (_velocity <= 0) {
        [self inertiaStop];
    }
    else {
        _velocity -= 70.;
        CGFloat angle = _velocity / self.frame.size.width * 2. * _inertia.duration;
        for (NSInteger i = 0; i < _tags.count; i ++) {
            [self updateFrameOfPoint:i direction:_normalDirection andAngle:angle];
        }
    }
    
}

#pragma mark - gesture selector
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _last = [gesture locationInView:self];
        [self timerStop];
        [self inertiaStop];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [gesture locationInView:self];
        YX3DBallBtnPoint direction = YX3DBallBtnPointMake(_last.y - current.y, current.x - _last.x, 0);
        
        CGFloat distance = sqrt(direction.x * direction.x + direction.y * direction.y);
        CGFloat angle = distance / (self.frame.size.width / 2.);
        
        for (NSInteger i = 0; i < _tags.count; i ++) {
            [self updateFrameOfPoint:i direction:direction andAngle:angle];
        }
        _normalDirection = direction;
        _last = current;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocityP = [gesture velocityInView:self];
        _velocity = sqrt(velocityP.x * velocityP.x + velocityP.y * velocityP.y);
        [self inertiaStart];
    }
}

@end
