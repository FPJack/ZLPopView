//
//  ZLLayoutViewController.m
//  ZLPopView_Example
//
//  Created by admin on 2025/11/26.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLLayoutViewController.h"
#import <ZLPopView/ZLPopView.h>
@interface ZLLayoutViewController ()

@end

@implementation ZLLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIStackView布局";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.stackViewBuilder.buildScrollViewToSuperView(self.view);
}
- (ZLStackViewBuilder *)stackViewBuilder {
                    
        
        
    
                    
      
    
    
    ZLStackViewBuilder *builder = ZLStackViewBuilder
        .column
        .space(10)
        .distributionStart
        .alignmentFill;
    builder
    .addView(UILabel.kfc.text(@"起点开始布局"))
    .addViewBK(^UIView * _Nonnull{
        return self.generateBuilder
            .distributionStart
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"末端开始布局"))
    .addViewBK(^UIView * _Nonnull{
        return self.generateBuilder
            .distributionEnd
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"水平居中布局"))
    .addViewBK(^UIView * _Nonnull{
        return self.generateBuilder
            .distributionCenter
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"边缘间距二分之一布局"))
    .addViewBK(^UIView * _Nonnull{
        return self.generateBuilder
            .distributionSpaceAround
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"间距相等布局"))
    .addViewBK(^UIView * _Nonnull{
        return self.generateBuilder
            .distributionSpaceEvenly
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"间距相等两边不留间距布局"))
    .addViewBK(^ViewKFCType _Nonnull{
        return self.generateBuilder
            .distributionEqualSpacing
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"view宽度相等布局"))
    .addViewBK(^ViewKFCType _Nonnull{
        return self.generateBuilder
            .distributionFillEqually
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"view中心点间距相等布局"))
    .addViewBK(^ViewKFCType _Nonnull{
        return kStackViewRowBuilder
            .distributionEqualCentering
            .addView(self.randomColorView.kfc.width(70))
            .addView(self.randomColorView)
            .addView(self.randomColorView.kfc.width(40))
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"弹性可拉伸布局"))
    .addViewBK(^ViewKFCType _Nonnull{
        return kStackViewRowBuilder
            .addView(self.randomColorView)
            .addView(self.randomColorView)
            .addFlexSpaceView()
            .addView(self.randomColorView)
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"Row里面单独设置子view纵向对齐方式和间距"))
    .addViewBK(^ViewKFCType _Nonnull{
        return kStackViewRowBuilder
            .alignmentStart
            .distributionSpaceEvenly
            .addView(self.randomColorView)
            .addView(self.randomColorView.kfc.startAlignment)
            .addView(self.randomColorView.kfc.endAlignment)
            .addView(self.randomColorView.kfc.centerAlignment)
            .addView(self.randomColorView.kfc.startAlign(10))
            .addView(self.randomColorView.kfc.endAlign(10))
            .buildStackView.kfc
            .height(70)
            .backgroundColor(UIColor.orangeColor);
    })
    .addView(UILabel.kfc.text(@"Column里面单独设置子view纵向对齐方式和间距"))
    .addViewBK(^ViewKFCType _Nonnull{
        return kStackViewColumnBuilder
            .addView(self.randomColorView.kfc.startAlignment)
            .addView(self.randomColorView.kfc.endAlignment)
            .addView(self.randomColorView.kfc.centerAlignment)
            .addView(self.randomColorView.kfc.startAlign(20))
            .addView(self.randomColorView.kfc.endAlign(40))
            .buildStackView.kfc
            .backgroundColor(UIColor.redColor);
    })
    .addView(UILabel.kfc.text(@"设置view的前后间距"))
    .addViewBK(^ViewKFCType _Nonnull{
        return kStackViewRowBuilder
            .alignmentStart
            .space(10)
            .addView(self.randomColorView)
            .addView(self.randomColorView.kfc.frontSpacing(20).spacing(40))
            .addView(self.randomColorView)
            .customSpace(60)
            .addView(self.randomColorView)
            .addView(self.randomColorView)
            .addView(self.randomColorView)
            .addFlexSpaceView()
            .buildStackView;
    })
    .addView(UILabel.kfc.text(@"给view4个方向添加线条"))
    .addViewBK(^ViewKFCType _Nonnull{
        return kStackViewRowBuilder
            .separatorColor(UIColor.redColor)
            .separatorThickness(2)
            .alignmentFill
            .space(10)
            .distributionFillEqually
            .addView(self.randomColorView.kfc.addTopSeparator)
            .addView(self.randomColorView.kfc.addBottomSeparator)
            .addView(self.randomColorView.kfc.addLeadingSeparator)
            .addView(self.randomColorView.kfc.addTrailingSeparator)
            .addFlexSpaceView()
            .buildStackView.kfc.height(100);
    });
    return builder;
}
- (UIView *)randomColorView {
    UIView *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
    return view;
}
- (ZLStackViewBuilder *)generateBuilder {
    return kStackViewRowBuilder
        .addView(self.randomColorView)
        .addView(self.randomColorView)
        .addView(self.randomColorView);
}
@end
