//
//  ZLPopOverViewController.m
//  ZLPopView_Example
//
//  Created by admin on 2025/5/23.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLPopOverViewController.h"
#import <ZLPopView/ZLPopView.h>
@interface ZLPopOverViewController ()<ZLPopViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *testview;

@end

@implementation ZLPopOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view from its nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"菜单" forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColor.grayColor];
    [btn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popover:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}
- (UIView *)addItem {
    return ZLStackViewBuilder.row.addViewBK(^UIView * _Nonnull{
        return [UIButton buttonWithType:UIButtonTypeContactAdd];
    }).addViewBK(^UIView * _Nonnull{
        return UILabel.new.kfc.text([self text]).view;
    }).space(20).buildStackView;
}

- (void)popover:(UIButton *)button {
    [self show:ZLPopOverDirectionUp sender:button];
}
- (IBAction)tapaction:(id)sender {
    int randomValue = arc4random_uniform(4) + 1; // 结果为0、1、2、3中的一个
    [self show:randomValue sender:sender];
}
- (BOOL)popViewShouldRemoveFromSuperView:(ZLPopBaseView *)popView {
    return NO;
}
- (void)popViewWillHidden:(ZLPopBaseView *)popView {
    [UIView animateWithDuration:0.25 animations:^{
        popView.alpha = 0;
    } completion:^(BOOL finished) {
        [popView removeFromSuperview];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    int randomValue = arc4random_uniform(4) + 1;
    [touches enumerateObjectsUsingBlock:^(UITouch * _Nonnull obj, BOOL * _Nonnull stop) {
        CGPoint point =  [touches.anyObject locationInView:self.view];
        NSLog(@"-----%@",NSStringFromCGPoint(point));
    }];
    CGPoint point =  [touches.anyObject locationInView:self.view];
    ZLPopViewBuilder *builder = ZLPopViewBuilder.column;
    for (int i = 0 ; i < randomValue; i ++) {
        builder.addView([self addItem]);
    }
    ZLPopOverView *popView =
    builder
        .touchPenetrate
        .cornerRadius(10)
        .backgroundColor(UIColor.orangeColor)
        .shadowColor(UIColor.blackColor)
        .shadowOpacity(0.2)
        .inset(10, 10, 10, 10)
        .corners(UIRectCornerAllCorners)
        .popSuperView(self.view)
        .buildPopOverView;
    popView.setPoint(point)
        .setSafeAreaMarge(UIEdgeInsetsZero)
        .setDirection(ZLPopOverDirectionAuto)
        .setSpaceToPoint(10)
        .showPopView();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popView dismiss];
    });

}
- (IBAction)leftBottom:(id)sender {
    [self show:ZLPopOverDirectionDown sender:sender];
}
- (IBAction)rightButton:(id)sender {
    [self show:ZLPopOverDirectionDown sender:sender];
}
- (IBAction)centerleft:(id)sender {
    [self show:ZLPopOverDirectionLeft sender:sender];

}
- (IBAction)centerRight:(id)sender {
    [self show:ZLPopOverDirectionRight sender:sender];

}

- (void)show:(ZLPopOverDirection)d sender:(UIButton *)sender {
    int randomValue = arc4random_uniform(5) + 4;
    ZLPopViewBuilder *builder = ZLPopViewBuilder.column;
    for (int i = 0 ; i < randomValue; i ++) {
        builder.addView([self addItem]);
    }
        builder
        .animateOut(0)
        .tapMaskDismiss
        .cornerRadius(10)
        .shadowColor(UIColor.blackColor)
        .shadowOpacity(0.2)
        .inset(10, 10, 10, 10)
//        .setInset(UIEdgeInsetsZero)
        .maskColor([UIColor.blackColor colorWithAlphaComponent:0.3])
        .corners(UIRectCornerAllCorners)
        .buildPopOverView
        .setFromView(sender)
        .setDirection(d)
        .delegate(self)

//        .setPopParentView(self.view)

        .showPopView();
}
- (NSString *)text {
    NSUInteger length = arc4random_uniform(20) + 1; // 1~1000
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (NSUInteger i = 0; i < length; i++) {
        u_int32_t index = arc4random_uniform((u_int32_t)[letters length]);
        unichar c = [letters characterAtIndex:index];
        [randomString appendFormat:@"%C", c];
    }
    return randomString;
}
@end
