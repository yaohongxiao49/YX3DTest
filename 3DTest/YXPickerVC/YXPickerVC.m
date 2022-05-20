//
//  YXPickerVC.m
//  3DTest
//
//  Created by Augus on 2022/5/19.
//

#import "YXPickerVC.h"

@interface YXPickerVC () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView; //只有UIPickerView
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation YXPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataSourceArr = [[NSMutableArray alloc] initWithArray:@[@"1", @"2", @"3", @"4", @"5", @"6", @"1", @"2", @"3", @"4", @"5", @"6"]];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(100, 100, 200, 300)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self.view addSubview:_pickerView];
    
    _pickerView.transform = CGAffineTransformMakeRotation(M_PI / 2);
}

#pragma mark - <UIPickerViewDelegate, UIPickerViewDataSource>
#pragma mark - 该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 1;
}
#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _dataSourceArr.count;
}
#pragma mark - 该方法的返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return _dataSourceArr[row];
}
#pragma mark - 显示自定义视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    backView.backgroundColor = [UIColor redColor];
    
    ((UIView *)[pickerView.subviews objectAtIndex:1]).backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];

    return backView;

}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    
}

#pragma mark - 当选择某一列中的某一行的时候，会调用该方法（每滚动到一个地方就会调用一次）
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
}
#pragma mark - 设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 100;
}
#pragma mark - 设置组件中每一行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 100;
}

@end
