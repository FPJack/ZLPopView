//
//  ZLViewController.m
//  ZLPopView
//
//  Created by fanpeng on 11/25/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLViewController.h"




@interface ZLViewController ()

@end

@implementation ZLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"demo";
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.orangeColor;// 设置背景色
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.blackColor}; // 标题颜色
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        self.navigationController.navigationBar.barTintColor = UIColor.orangeColor;
        self.navigationController.navigationBar.backgroundColor = UIColor.orangeColor;
    }
}
@end
