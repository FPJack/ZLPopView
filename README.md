# ZLPopView


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

<img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4774.GIF" width="40%" height="40%">   <img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4775.GIF" width="40%" height="40%">
<img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4776.GIF" width="40%" height="40%">   <img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4777.GIF" width="40%" height="40%">




ZLPopView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZLPopView'
```

UIStackView 布局 更多请参考  ZLStackViewBuilder.h 文件和demo
```objc
UIView *view  = ZLStackViewBuilder
            //水平布局
             //.row
            //垂直布局 
            .column
            //设置间距
            .space(10)
            //设置分布方式
            .distribution(ZLMainAxisAlignmentStart)
            //设置对齐方式
            .alignment(UIStackViewAlignmentTop)
            //设置内边距
            .padding(10, 10, 10, 10)
            //设置分割线颜色
            .separatorColor(UIColor.lightGrayColor)
            //设置分割线粗细
            .separatorThickness(0.5)
            //添加子视图View
            .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
            //视图View之间插入间距,可以覆盖全局space设置
            .customSpace(20)
            .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
            //添加弹性空间View
            .addFlexSpaceView()
            //Block添加子视图View
            .addViewBK(^ViewKFCType  _Nonnull{
                return UILabel.kfc.text(@"UIStackView布局方式 添加Label");
            })
            .addViewBK(^ViewKFCType  _Nonnull{
                return UILabel.kfc.text(@"UIStackView布局方式 添加Label");
            })
            //生成UIScrollView,超出固定高度时可以滚动显示
            .buildScrollView
            //生成UIStackView
            .buildStackView;
```

ZLPopViewBuilder继承自ZLStackViewBuilder,更多请参考  ZLPopViewBuilder.h 文件和demo
```objc
    ZLPopBaseView *popView = ZLPopViewBuilder
                    //水平布局
                     //.row
                    //垂直布局
                    .column
                    //设置间距
                    .space(10)
                    //设置整个容器的四边距，包括背景弹出视图与屏幕边缘的距离
                    .popViewMarge(10, 10, 10, 10)
                    //设置内容视图的内边距
                    .inset(10, 10, 10, 10)
                    //设置内容视图与弹出容器的边距
                    .marge(10, 10, 10, 10)
                    //包裹UIScrollView
                    .wrapScrollView
                    //生成UIScrollView,超出固定高度时可以滚动显示
                    .enableScrollWhenOutBounds
                    //设置固定宽高
                    .width(300)
                    //设置固定高度
                    .height(400)
                    //设置最大宽高
                    .maxWidth(350)
                    //设置最大高度
                    .maxHeight(500)
                    //设置最大宽度比例
                    .maxWidthMultiplier(0.9)
                    //设置最大高度比例
                    .maxHeightMultiplier(0.8)
                    //设置宽度比例
                    .widthMultiplier(0.8)
                    //设置高度比例
                    .heightMultiplier(0.5)
                    //事件穿透，不阻挡底部触摸事件
                    .touchPenetrate
                    //启用拖拽关闭
                    .enableDragDismiss
                    //添加拖拽手势
                    .addDragGesture
                    //拖拽超过指定距离关闭
                    .dragDismissIfGreaterThanDistance(50)
                    //点击遮罩关闭
                    .tapMaskDismiss
                    //弹出动画时间
                    .animateIn(0.25)
                    //关闭动画时间
                    .animateOut(0.25)
                    //设置圆角
                    .corners(UIRectCornerAllCorners)
                    //设置圆角半径
                    .cornerRadius(10)
                    //设置阴影
                    .shadowColor(UIColor.blackColor)
                    //设置阴影半径
                    .shadowRadius(5)
                    //设置阴影偏移量
                    .shadowOffset(CGSizeMake(0, 0))
                    //设置阴影透明度
                    .shadowOpacity(0.2)
                    //设置遮罩颜色
                    .maskColor([UIColor.blackColor colorWithAlphaComponent:0.3])
                    //设置背景颜色
                    .backgroundColor(UIColor.whiteColor)
                    //避免键盘遮挡类型
                    .avoidKeyboardType(ZLAvoidKeyboardTypeFirstResponder)
                    //键盘弹出时底部距离键盘顶部的间距
                    .bottomOffsetToKeyboardTop(10)
                    //弹出视图添加到指定视图上
                    //.popSuperView(viewcontroller.view)
                    //设置分布方式
                    .distribution(ZLMainAxisAlignmentStart)
                    //设置对齐方式
                    .alignment(UIStackViewAlignmentTop)
                    //设置内边距
                    .padding(10, 10, 10, 10)
                    //设置分割线颜色
                    .separatorColor(UIColor.lightGrayColor)
                    //设置分割线粗细
                    .separatorThickness(0.5)
                    //添加子视图View
                    .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
                    //视图View之间插入间距,可以覆盖全局space设置
                    .customSpace(20)
                    .addView(UILabel.kfc.text(@"UIStackView布局方式 添加Label"))
                    //添加弹性空间View
                    .addFlexSpaceView()
                    //Block添加子视图View
                    .addViewBK(^ViewKFCType  _Nonnull{
                        return UILabel.kfc.text(@"UIStackView布局方式 添加Label");
                    })
                    .addViewBK(^ViewKFCType  _Nonnull{
                        return UILabel.kfc.text(@"UIStackView布局方式 添加Label");
                    })
                    //屏幕右侧弹出
                    .buildRightPopView
                    //屏幕左侧弹出
                    //.buildLeftPopView
                    //屏幕中间弹出
                    //.buildCenterPopView
                    //屏幕底部弹出
                    //.buildBottomPopView
                    //屏幕顶部弹出
                    //.buildTopPopView;
    //设置代理（监听页面生命周期）并显示
    popView.delegate(self).showPopView();

```
    

## Author

fanpeng, 2551412939@qq.com

## License

ZLPopView is available under the MIT license. See the LICENSE file for more info.
