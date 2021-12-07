//
//  YXPlayerVC.m
//  3DTest
//
//  Created by Believer Just on 2021/12/7.
//

#import "YXPlayerVC.h"
#import "ZFPlayer.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

@interface YXPlayerVC ()

@property(nonatomic, strong) UIView *forPlayView;
@property(nonatomic, strong) ZFPlayerController *player;
@property(nonatomic, strong) ZFAVPlayerManager *playerManager;
@property(nonatomic, strong) ZFPlayerControlView *controlView;
@property(nonatomic, strong) UIButton *closeBtn;

@end

@implementation YXPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.forPlayView];
    [self.view addSubview:self.closeBtn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSString *videoUrl = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    
    [self.player.currentPlayerManager setAssetURL:[NSURL URLWithString:videoUrl]];
    self.forPlayView.hidden = NO;
    self.closeBtn.hidden = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.forPlayView.frame = CGRectMake(0, 0, 100, 100);
    self.closeBtn.frame = self.view.bounds;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self playerDealloc];
}

- (UIView *)forPlayView {
    
    if(_forPlayView == nil) {
        _forPlayView = [[UIView alloc] init];
        _forPlayView.hidden = YES;
    }
    return _forPlayView;
}

- (UIButton *)closeBtn {
    
    if(_closeBtn == nil) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

#pragma mark - 网络视频模块
- (ZFAVPlayerManager *)playerManager {
    
    if(_playerManager == nil) {
        _playerManager = [[ZFAVPlayerManager alloc] init];
    }
    return _playerManager;
}

- (ZFPlayerController *)player {
    
    if(_player == nil) {
        _player = [[ZFPlayerController alloc] initWithPlayerManager:self.playerManager containerView:self.forPlayView];
        _player.controlView = self.controlView;
        _player.playerDisapperaPercent = 1.0f;
        //__weak typeof(self) weakSelf = self;
        _player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback> asset) { //结束播放
            
        };
        [_player setPlayerPlayStateChanged:^(id<ZFPlayerMediaPlayback> asset, ZFPlayerPlaybackState playState) {
            
            if(playState == ZFPlayerPlayStatePlayStopped) {
                NSLog(@"播放暂停");
            }
        }];
        [_player setPlayerPlayTimeChanged:^(id<ZFPlayerMediaPlayback> asset, NSTimeInterval currentTime, NSTimeInterval duration) {
            NSLog(@"播放改变currentTime - %f duration - %f", currentTime, duration);
        }];
    }
    return _player;
}

- (ZFPlayerControlView *)controlView {
    
    if (_controlView == nil) {
        _controlView = [[ZFPlayerControlView alloc] init];
        _controlView.backgroundColor = [UIColor redColor];
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}

- (void)playerDealloc {
    
    //网络视频
    if(_playerManager) {
        _playerManager = nil;
    }
    if(_player) {
        _player.viewControllerDisappear = YES;
        [_player stop];
        _player = nil;
    }
}

- (void)closeBtnClick {
    
    self.closeBtn.hidden = YES;
    self.forPlayView.hidden = YES;
    //[self playerDealloc];
}
@end
