//
//  ViewController.m
//  3DTest
//
//  Created by Augus on 2021/11/24.
//

#import "ViewController.h"
#import "YXBoxFloatAnimationVC.h"
#import "YXBoxOpenAnimationVC.h"
#import "YXPlayerVC.h"
#import "YXBallAnimationVC.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataSourceArr = [[NSMutableArray alloc] initWithObjects:@"盒子合并及悬浮动画", @"卡片弹出动画", @"视频播放", @"文字球", nil];
    
    self.navigationController.title = @"主页";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 100) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellID = @"123yd";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _dataSourceArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        YXBoxFloatAnimationVC *vc = [[YXBoxFloatAnimationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        YXBoxOpenAnimationVC *vc = [[YXBoxOpenAnimationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2) {
        YXPlayerVC *vc = [[YXPlayerVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3) {
        YXBallAnimationVC *vc = [[YXBallAnimationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
