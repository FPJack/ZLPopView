//
//  ZLAppDelegate.m
//  ZLPopView
//
//  Created by fanpeng on 11/25/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLAppDelegate.h"
#import "ZLPopViewController.h"
#import "ZLLayoutViewController.h"
#import "ZLConvenienceViewController.h"
#import "ZLNavigationController.h"
#import "ZLPopOverViewController.h"
#import "ZLPopOverViewController.h"

@implementation ZLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
        // 创建 TabBarController
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    if (@available(iOS 13.0, *)) {
        UITabBarItemAppearance *inlineLayoutAppearance = [[UITabBarItemAppearance  alloc] init];
        // fix https://github.com/ChenYilong/CYLTabBarController/issues/456

        // set the text Attributes
        // 设置文字属性
        [inlineLayoutAppearance.normal setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],
                                                                NSForegroundColorAttributeName:[UIColor blackColor]}];
        [inlineLayoutAppearance.selected setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],
                                                                  NSForegroundColorAttributeName:[UIColor redColor]}];

        UITabBarAppearance *standardAppearance = [[UITabBarAppearance alloc] init];
        standardAppearance.stackedLayoutAppearance = inlineLayoutAppearance;
        standardAppearance.backgroundColor = [UIColor whiteColor];
        //shadowColor和shadowImage均可以自定义颜色, shadowColor默认高度为1, shadowImage可以自定义高度.
        standardAppearance.shadowColor = [UIColor greenColor];
        // standardAppearance.shadowImage = [[self class] imageWithColor:[UIColor cyl_systemGreenColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)];
    } else {
        // Override point for customization after application launch.
        // set the text Attributes
        // 设置文字属性
//        UITabBarItem *tabBar = [UITabBarItem appearance];
//        [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
//        [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//        
//        // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
//        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//        [[UITabBar appearance] setShadowImage:[[self class] imageWithColor:[UIColor cyl_systemGreenColor] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
    }
  
    
//    UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
//    [appearance configureWithOpaqueBackground];
//
//    // 背景色（整个 TabBar）
//    appearance.backgroundColor = UIColor.whiteColor;
//    // 选中 item
//    UITabBarItemAppearance *selected = appearance.stackedLayoutAppearance.selected;
//
//    [selected configureWithDefaultForStyle:UITabBarItemAppearanceStyleStacked];

    // 图标颜色（iOS 13+）

        // 创建 4 个控制器
    ZLLayoutViewController *homeVC = [[ZLLayoutViewController alloc] init];
    ZLConvenienceViewController *discoverVC = [[ZLConvenienceViewController alloc] init];
    ZLPopViewController *messageVC = [[ZLPopViewController alloc] init];
    ZLPopOverViewController *popOverVC = [[ZLPopOverViewController alloc] init];
    
    UIViewController *centerVC = [[ZLPopViewController alloc] init];


        // 设置标题
        homeVC.title = @"常用布局";
        discoverVC.title = @"便捷方法";
        messageVC.title = @"通用弹窗";
        popOverVC.title = @"Popover弹窗";

    // 设置 TabBarItem（图标可以换成你项目的图片）
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                      image:[[UIImage imageNamed:@"infor_popshare_sina_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"infor_popshare_sina_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    discoverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现"
                                                          image:[UIImage systemImageNamed:@"safari"]
                                                  selectedImage:[UIImage systemImageNamed:@"safari.fill"]];
    centerVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@""
                                                        image:[[UIImage imageNamed:@"post_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                selectedImage:[[UIImage imageNamed:@"post_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    

    messageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息"
                                                         image:[UIImage systemImageNamed:@"message"]
                                                 selectedImage:[UIImage systemImageNamed:@"message.fill"]];

    popOverVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"弹窗"
                                                         image:[UIImage systemImageNamed:@"square.stack"]
                                                 selectedImage:[UIImage systemImageNamed:@"square.stack.fill"]];

        // 每个 VC 放入导航控制器（可选）
        UINavigationController *nav1 = [[ZLNavigationController alloc] initWithRootViewController:homeVC];
        UINavigationController *nav2 = [[ZLNavigationController alloc] initWithRootViewController:discoverVC];
        UINavigationController *nav3 = [[ZLNavigationController alloc] initWithRootViewController:messageVC];
        UINavigationController *nav4 = [[ZLNavigationController alloc] initWithRootViewController:popOverVC];
        UINavigationController *centerNav = [[ZLNavigationController alloc] initWithRootViewController:centerVC];


    
        // 添加到 TabBarController
    tabBarController.viewControllers = @[nav1, nav2, centerNav,nav3,nav4];

        self.window.rootViewController = tabBarController;
        [self.window makeKeyAndVisible];

        return YES;
}


@end
