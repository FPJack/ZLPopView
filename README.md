# ZLPopView

[![CI Status](https://img.shields.io/travis/fanpeng/ZLPopView.svg?style=flat)](https://travis-ci.org/fanpeng/ZLPopView)
[![Version](https://img.shields.io/cocoapods/v/ZLPopView.svg?style=flat)](https://cocoapods.org/pods/ZLPopView)
[![License](https://img.shields.io/cocoapods/l/ZLPopView.svg?style=flat)](https://cocoapods.org/pods/ZLPopView)
[![Platform](https://img.shields.io/cocoapods/p/ZLPopView.svg?style=flat)](https://cocoapods.org/pods/ZLPopView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

<img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4774.GIF" width="40%" height="40%"><img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4775.GIF" width="40%" height="40%">
<img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4776.GIF" width="40%" height="40%"><img src="https://github.com/FPJack/ZLPopView/blob/master/IMG_4777.GIF" width="40%" height="40%">




ZLPopView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZLPopView'
```

UIStackView 布局 更多请参考  ZLStackViewBuilder.h 文件
```objc
    ZLStackViewBuilder
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

## Author

fanpeng, 2551412939@qq.com

## License

ZLPopView is available under the MIT license. See the LICENSE file for more info.
