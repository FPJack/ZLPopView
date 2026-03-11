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

#define ZL_LAZY_OBJ_GETTER(ReturnType, container, methodName)  \
- (ReturnType *)methodName {                                   \
    NSString *key = NSStringFromSelector(_cmd);                \
    ReturnType *obj = container[key];                           \
    if (!obj) {                                                 \
        obj = ReturnType.alloc;                                   \
        container[key] = obj;                                   \
    }                                                           \
    return obj;                                                 \
}


@interface TableView()
@property (nonatomic,readonly)ZLPopBottomFloatView *popView;
@property (nonatomic,assign)BOOL lock;
@end
@implementation TableView
ZL_LAZY_OBJ_GETTER(UIView, NSMutableDictionary.dictionary, tapActionObj)

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
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
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
//        NSLog(@"++%f",scrollView.contentOffset.y);
//    CGFloat offsetY = scrollView.contentOffset.y;
//    CGFloat y = self.superview.bounds.origin.y;
//    if (y >= 200) {
//        return;
//    }
//    self.superview.bounds = CGRectMake(0, self.superview.bounds.origin.y + offsetY, self.superview.bounds.size.width, self.superview.bounds.size.height );
//    scrollView.contentOffset = CGPointMake(0, 0);
}
- (void)dealloc
{
    NSLog(@"table dealloc");
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.lock) return;
    //获取新旧值
    NSValue *newValue = change[NSKeyValueChangeNewKey];
    NSValue *oldValue = change[NSKeyValueChangeOldKey];
    CGPoint newPoint = [newValue CGPointValue];
    CGPoint oldPoint = [oldValue CGPointValue];
    //判断往上还是往下滚动
    if (newPoint.y > oldPoint.y) {
        NSLog(@"正在往上滚动");
            CGFloat y = self.superview.bounds.origin.y;
            if (y >= 200) {
                return;
            }
            self.superview.bounds = CGRectMake(0, self.superview.bounds.origin.y + newPoint.y, self.superview.bounds.size.width, self.superview.bounds.size.height );
        self.lock = YES;
        self.contentOffset = CGPointMake(0, 0);
        self.lock = NO;
    } else if (newPoint.y < oldPoint.y) {
        if (newPoint.y < 0) {
                CGFloat y = self.superview.bounds.origin.y;
            self.superview.bounds = CGRectMake(0, self.superview.bounds.origin.y + newPoint.y, self.superview.bounds.size.width, self.superview.bounds.size.height );
            self.lock = YES;
            self.contentOffset = CGPointMake(0, 0);
            self.lock = NO;
        }
        NSLog(@"正在往下滚动 %f",newPoint.y);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"结束滚动");
}
@end

