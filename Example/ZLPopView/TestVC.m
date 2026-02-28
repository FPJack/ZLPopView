//
//  TestVC.m
//  ZLPopView_Example
//
//  Created by admin on 2026/2/28.
//  Copyright © 2026 fanpeng. All rights reserved.
//

#import "TestVC.h"
#import <ZLPopView/ZLPopView.h>
@interface TestVC ()

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@",self.parentViewController);
    UIView *view = UIView.new.kfc.height(200).blackBgColor.view;
    [self.view addSubview:view];
    view.kfc.edgeTo(self.view, 0, 0, 0, 0);
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}
- (void)dealloc
{
    NSLog(@"dealloc");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
