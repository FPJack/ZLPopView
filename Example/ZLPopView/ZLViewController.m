//
//  ZLViewController.m
//  ZLPopView
//
//  Created by fanpeng on 11/25/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLViewController.h"
#import <ZLPopView/ZLPopView.h>
#import <ZLPagerViewController.h>
#import <ZLParallaxPageTabBarViewController.h>
#import <ZLTabBarExtension.h>
#import <ZLPermission.h>
#import "TableView.h"

//#import <ZLPermissionBluetooth.h>
@interface ZLViewController ()
@property (nonatomic,strong)UITableView *tableView;
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
    
    UISwitch *sw = UISwitch.new;
    [self.view addSubview:sw];
    sw.kfc.top(100).centerX(0);

    TableView *tableView = [[TableView alloc] initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, self.view.bounds.size.height - 400)];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
}
@end
