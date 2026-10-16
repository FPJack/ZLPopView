//
//  ZLSceneDelegate.m
//  ZLPopView
//
//  Created by fanpeng on 11/25/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLSceneDelegate.h"
#import "ZLAppDelegate.h"

@implementation ZLSceneDelegate

- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions
{
    if (![scene isKindOfClass:UIWindowScene.class]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;

    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    window.backgroundColor = UIColor.orangeColor;
    window.rootViewController = [ZLAppDelegate makeRootViewController];
    [window makeKeyAndVisible];
    self.window = window;
}

- (void)sceneDidDisconnect:(UIScene *)scene {}
- (void)sceneDidBecomeActive:(UIScene *)scene {}
- (void)sceneWillResignActive:(UIScene *)scene {}
- (void)sceneWillEnterForeground:(UIScene *)scene {}
- (void)sceneDidEnterBackground:(UIScene *)scene {}

@end
