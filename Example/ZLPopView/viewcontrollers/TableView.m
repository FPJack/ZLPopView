//
//  TableView.m
//  GMPopView_Example
//
//  Created by admin on 2025/4/21.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "TableView.h"
#import <MJRefresh/MJRefresh.h>
#import <ZLPopView/ZLPopView.h>
@interface TableView()
@property (nonatomic,weak)ZLPopBottomFloatView *popView;
@end
@implementation TableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mj_footer endRefreshing];
            });
        }];
    }
    return self;
}
- (NSInteger)numberOfSections {
    return 1;
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZLPopBottomFloatView *view = self.kfc.popView;
    if (![view isKindOfClass:ZLPopBottomFloatView.class]) {
        return;
    }
    if (indexPath.row == 0) {
        [view showExpand];
    }else if (indexPath.row == 1) {
        [view showTight];
    }else if (indexPath.row == 2) {
        [view dismiss];

    }
   
}
- (void)showText:(NSString *)text {
    
    kPopViewColumnBuilder.addViewBK(^UIView * _Nonnull{
        return UILabel.new.kfc
            .text(text)
            .font([UIFont systemFontOfSize:12])
            .textColor(UIColor.whiteColor)
            .textAlignment(NSTextAlignmentCenter)
            .numberOfLines(0)
            .tapAction(^(UIView * _Nonnull view) {
                [view.kfc.popView dismiss];
            }).view;
    })
        .avoidKeyboardType(ZLAvoidKeyboardTypeAlwaysCenter)
        .maxWidthMultiplier(0.7)
        .inset(10, 10, -10, -10)
        .backgroundColor(UIColor.blackColor)
        .alignment(UIStackViewAlignmentFill)
        .cornerRadius(5)
        .corners(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight)
        .buildCenterPopView.showPopView();
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"++%f",scrollView.contentOffset.y);
}
- (void)dealloc
{
    NSLog(@"table dealloc");
}
@end

