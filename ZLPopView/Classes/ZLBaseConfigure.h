//
//  GMConfigProxy.h
//  GMPopView
//
//  Created by admin on 2025/9/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kLeadingSeparatorTag  19991
#define kTrailingSeparatorTag 19992
#define kTopSeparatorTag      19993
#define kBottomSeparatorTag   19994
#define kZLUIStackViewTag     19995
#define kRefreshConfigBKNotification @"kGMRefreshConfigBKNotification"

static inline UILabel * _Nullable kIS_UILabel(id obj) {
    return [obj isKindOfClass:[UILabel class]] ? (UILabel *)obj : nil;
}
static inline UIButton * _Nullable kIS_UIButton(id obj) {
    return [obj isKindOfClass:[UIButton class]] ? (UIButton *)obj : nil;
}
static inline UIImageView * _Nullable kIS_UIImageView(id obj) {
    return [obj isKindOfClass:[UIImageView class]] ? (UIImageView *)obj : nil;
}
static inline UITextView * _Nullable kIS_UITextView(id obj) {
    return [obj isKindOfClass:[UITextView class]] ? (UITextView *)obj : nil;
}
static inline UITextField * _Nullable kIS_UITextField(id obj) {
    return [obj isKindOfClass:[UITextField class]] ? (UITextField *)obj : nil;
}
static inline UISwitch * _Nullable kIS_UISwitch(id obj) {
    return [obj isKindOfClass:[UISwitch class]] ? (UISwitch *)obj : nil;
}
@class ZLUIViewConfigure,ZLUILabelConfigure,ZLUITextFieldConfigure,ZLUITextViewConfigure,ZLUIButtonConfigure,ZLUIImageViewConfigure,ZLUISwitchConfigure,ZLUISliderConfigure,ZLUIStackViewConfigure,ZLUIScrollView,ZLPopBaseView;
@class ZLBuilderContext;

typedef NS_ENUM(NSInteger, ZLCrossAxisAlignment) {
    ZLCrossAxisAlignmentAuto = 0,//跟随UIStackView纵轴对齐方式
    ZLCrossAxisAlignmentCenter,
    ZLCrossAxisAlignmentStart,
    ZLCrossAxisAlignmentEnd
};

@interface GMUIContainerView<__covariant ObjectType: UIView *> : UIView
@property (nonatomic,assign)UIEdgeInsets inset;
@property (nonatomic,weak,readonly)ObjectType childView;
+ (instancetype)initView:(ObjectType)view inset:(UIEdgeInsets)inset;
@end

@interface NSLayoutConstraint(GMPopView)
- (NSLayoutConstraint*)gm_enableActive;
- (NSLayoutConstraint*)gm_setPriority:(UILayoutPriority)priority;
@end
@interface CALayer (AnchorPointAdjust)
/// 设置 anchorPoint 并保持图层视觉位置不变
/// @param anchorPoint 新的 anchorPoint (范围 0-1)
- (void)setAnchorPointWithoutMoving:(CGPoint)anchorPoint;
@end
@class ZLUIStackView;
@interface ZLBuilderContext : NSObject
/// 通过stackview可以动态往popview里面添加删除view
@property (nonatomic,weak)ZLUIStackView *stackView;
///只有当设置了宽或高的参数的时候为scrollview对象才有值
@property (nonatomic,weak)ZLUIScrollView *scrollView;
///所有view
@property (nonatomic, strong,readonly) NSHashTable<UIView *> *allViews;
///根据tag获取view
@property (nonatomic,readonly)UIView * _Nullable (^viewTag)(NSInteger tag);
@property (nonatomic,readonly)UILabel * _Nullable (^labelTag)(NSInteger tag);
@property (nonatomic,readonly)UISwitch * _Nullable (^switchTag)(NSInteger tag);
@property (nonatomic,readonly)UIButton * _Nullable (^buttonTag)(NSInteger tag);
@property (nonatomic,readonly)UITextField * _Nullable (^textFieldTag)(NSInteger tag);
@property (nonatomic,readonly)UITextView * _Nullable (^textViewTag)(NSInteger tag);
@property (nonatomic,readonly)UIImageView * _Nullable (^imgViewTag)(NSInteger tag);

- (UIView *)viewWithTag:(NSInteger )tag;
///刷新所有view配置的didUpdateViewModelBK
- (void)updateViewModel;
///根据tag属性指定view配置的didUpdateViewModelBK
- (void)updateViewModelWithViewTag:(NSInteger)tag;

- (void)addView:(UIView *)view;
@end

@interface ZLPopViewBuilderContext : ZLBuilderContext
@property (nonatomic,readonly)ZLPopBaseView *popView;
/// 弹出popView
- (void)show;
/// 消失popView
- (void)dismiss;
@end

@interface ZLSeparatorView<__covariant ObjectType> : UIView
@property (nonatomic,class)UIColor *defaultColor;
@property (nonatomic,class)CGFloat defaultThickness;
@property (nonatomic,assign)NSInteger colorThicknessPriority;
@property (nonatomic,strong,readonly)NSLayoutConstraint *heightCons;
@property (nonatomic,strong,readonly)NSLayoutConstraint *widthCons;
@property (nonatomic,assign)BOOL isHorizontal;
/// 父视图
@property (nonatomic,weak,readonly)ObjectType view;
///对应的方向为宽高，其他方向为边距
- (ZLSeparatorView*  (^)(UIEdgeInsets inset))layoutInset;
- (ZLSeparatorView*  (^)(id color))color;
- (ZLSeparatorView*  (^)(UIEdgeInsets inset,id color))config;
///设置宽或高
- (ZLSeparatorView*  (^)(CGFloat thickness))thickness;
@end

@protocol ZLViewProtocol <NSObject>
///不能这样写，如果主类也有这个属性，分类协议会覆盖主类的属性，但是不会生成get set方法会导致报错
//@optional
//@property (nonatomic,readonly)UIView *view;
@end
typedef id<ZLViewProtocol> ViewKFCType;
@interface UIView()<ZLViewProtocol>
@end


@interface ZLBaseConfigure<__covariant ObjectType,__covariant ObjectView: UIView*> : NSObject<ZLViewProtocol>
/// 被配置的view
@property (nonatomic,weak,readonly)ObjectView view;
///返回view或者view的父视图(设置了marge参数的时候)
@property (nonatomic,weak,readonly)UIView *margeView;
@property (nonatomic,assign,readonly)BOOL shoulddismissPopViewWhenTap;
@property (nonatomic,assign,readonly)BOOL isFirstResponder;
@property (nonatomic,assign,readonly)CGFloat alignmentMarge;
@property (nonatomic,assign,readonly)ZLCrossAxisAlignment alignment;
@property (nonatomic,weak,readonly)ZLBuilderContext *context;
/// 如果是view被添加到popView里面获取当前的popView
@property (nonatomic,readonly)ZLPopBaseView *popView;
///关闭弹窗等同于 [kfc.popView dismiss];
@property (nonatomic,readonly)void (^dismissPopView)(void);

+ (instancetype)alloc NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)configureWithView:(UIView *)view;
/// 添加单击事件，多次传入block只会调用最新的一次
@property (nonatomic,readonly)ObjectType (^tapAction)(void(^)(__kindof UIView* view));
/// 添加单击事件并返回view，多次传入block会调用多次
@property (nonatomic,readonly)ObjectType (^addTapAction)(void(^)(__kindof UIView* view));


@property (nonatomic,strong)id _Nullable viewModel;
///如果设置了viewmodel的类型可以确保didUpdateViewModelBK传入的viewmodel是这个类型或者子类，viewmodel 如果为空也会调用这个block刷新view
@property (nonatomic,readonly)ObjectType (^viewModelClass)(Class cls);
- (ObjectType)viewModelIsStringClass;
///设置viewmodel NSString类型

///viewmodel 更新的时候block刷新view,设置viewmodeBK会立即回调这个block,isUpdate为NO
@property (nonatomic,readonly)ObjectType (^updateViewModelBK)(void(^)(__kindof UIView* view,id _Nullable viewModel,BOOL isUpdate));
///手动调用view以及子view的updateViewModelBK刷新view,isUpdate为YES
- (void)updateViewModel;
- (void)updateViewModel:(id _Nullable)viewModel;
- (void)updateViewModelWithSuperViewTag:(NSInteger)tag;
- (void)updateViewModelWithChildViewTag:(NSInteger)tag;


///view userInteractionEnabled = YES 可接收点击的时候调用在这个block里面进行相关属性配置
@property (nonatomic,readonly)ObjectType (^enableConfigBK)(void(^)(__kindof UIView* view,id viewModel));
///view userInteractionEnabled = NO 不可接收点击的时候调用在这个block里面进行相关属性配置
@property (nonatomic,readonly)ObjectType (^disableConfigBK)(void(^)(__kindof UIView* view,id viewModel));
///设置view的userInteractionEnabled属性
@property (nonatomic,readonly)ObjectType (^userInteractionEnabled)(BOOL isUserInteractionEnabled);




/// 根据tag获取子视图
@property (nonatomic,readonly)UIView* (^viewTag)(NSInteger tag);

@property (nonatomic,readonly)ObjectType (^hidden)(BOOL hidden);
@property (nonatomic,readonly)ObjectType (^alpha)(CGFloat alpha);






///设置view四边的marge，实际上是添加一个ContainerView包裹住view，最后需要返回margeView生效
@property (nonatomic,readonly) ObjectType (^marge)(UIEdgeInsets);
@property (nonatomic,readonly) ObjectType (^margeAll)(CGFloat);
@property (nonatomic,readonly) ObjectType (^margeTop)(CGFloat);
@property (nonatomic,readonly) ObjectType (^margeBottom)(CGFloat);
@property (nonatomic,readonly) ObjectType (^margeLeading)(CGFloat);
@property (nonatomic,readonly) ObjectType (^margeTrailing)(CGFloat);
@property (nonatomic,readonly) ObjectType (^margeHorizontal)(CGFloat);
@property (nonatomic,readonly) ObjectType (^margeHorLT)(CGFloat,CGFloat);
@property (nonatomic,readonly) ObjectType (^margeVertical)(CGFloat);
@property (nonatomic,readonly) ObjectType (^margeVerTB)(CGFloat,CGFloat);





///设置各个方向圆角
@property (nonatomic,readonly) ObjectType (^topLeftCorner)(CGFloat);
@property (nonatomic,readonly) ObjectType (^topRightCorner)(CGFloat);
@property (nonatomic,readonly) ObjectType (^bottomLeftCorner)(CGFloat);
@property (nonatomic,readonly) ObjectType (^bottomRightCorner)(CGFloat);
@property (nonatomic,readonly) ObjectType (^topCorners)(CGFloat);
@property (nonatomic,readonly) ObjectType (^bottomCorners)(CGFloat);
- (ObjectType)roundCorner;

///设置宽高
@property (nonatomic,readonly) ObjectType (^height)(CGFloat);
@property (nonatomic,readonly) ObjectType (^width)(CGFloat);
@property (nonatomic,readonly) ObjectType (^minHeight)(CGFloat);
@property (nonatomic,readonly) ObjectType (^minWidth)(CGFloat);
@property (nonatomic,readonly) ObjectType (^maxHeight)(CGFloat);
@property (nonatomic,readonly) ObjectType (^maxWidth)(CGFloat);
@property (nonatomic,readonly) ObjectType (^size)(CGFloat wh);
@property (nonatomic,readonly) ObjectType (^sizeWH)(CGFloat w,CGFloat h);
@property (nonatomic,readonly) ObjectType (^tag)(NSInteger);

@property (nonatomic,readonly) ObjectType (^verCompressionPriority)(UILayoutPriority priority);
@property (nonatomic,readonly) ObjectType (^verHuggingPriority)(UILayoutPriority priority);
@property (nonatomic,readonly) ObjectType (^horCompressionPriority)(UILayoutPriority priority);
@property (nonatomic,readonly) ObjectType (^horHuggingPriority)(UILayoutPriority priority);

///UIColor or #333333
@property (nonatomic,readonly) ObjectType (^backgroundColor)(id);
@property (nonatomic,readonly) ObjectType (^cornerRadius)(CGFloat);

///消除编译器警告
@property (nonatomic,readonly) void (^Void)(void);

- (ObjectType)whiteBgColor;
- (ObjectType)blackBgColor;
- (ObjectType)clearBgColor;


///UIColor or #333333
@property (nonatomic,readonly) ObjectType (^borderColor)(id);
@property (nonatomic,readonly) ObjectType (^borderWidth)(CGFloat);

- (NSLayoutConstraint *)topToView:(UIView *)view offset:(CGFloat)offset;
- (NSLayoutConstraint *)bottomToView:(UIView *)view offset:(CGFloat)offset;
- (NSLayoutConstraint *)leadingToView:(UIView *)view offset:(CGFloat)offset;
- (NSLayoutConstraint *)trailingToView:(UIView *)view offset:(CGFloat)offset;
- (NSLayoutConstraint *)setViewWidth:(CGFloat)width;
- (NSLayoutConstraint *)setViewHeight:(CGFloat)height;
- (NSLayoutConstraint *)setViewHeightEqualToView:(UIView *)view;
- (NSLayoutConstraint *)setViewWidthEqualToView:(UIView *)view;
- (NSArray<NSLayoutConstraint *> *)centerInView:(UIView *)view;
- (NSLayoutConstraint *)centerXToView:(UIView *)view offset:(CGFloat)offset;
- (NSLayoutConstraint *)centerYToView:(UIView *)view offset:(CGFloat)offset;
- (NSArray<NSLayoutConstraint *> *)centerInView:(UIView *)view centerOffset:(CGPoint)centerOffset;
- (NSArray<NSLayoutConstraint *> *)edgeToView:(UIView *)view edge:(UIEdgeInsets)edge;

/// 添加四边分割线

/// @return 分割线view，可拿到分割线view进行颜色，宽高，边距等设置
- (ZLSeparatorView<ObjectView> *)topSeparator;
/// 添加默认颜色宽高配置分割线
- (instancetype)addTopSeparator;
- (ZLSeparatorView<ObjectView> *)bottomSeparator;
- (instancetype)addBottomSeparator;
- (ZLSeparatorView<ObjectView> *)leadingSeparator;
- (instancetype)addLeadingSeparator;
- (ZLSeparatorView<ObjectView> *)trailingSeparator;
- (instancetype)addTrailingSeparator;


///设置在UIStackView里面的布局属性
/// 让view成为第一响应者
- (instancetype )becomeFirstResponderWhenPopViewAppear;
/// 如果是view被添加到popView,设置点击view自动关闭popView
- (instancetype)dismissPopViewWhenTap;
/// 设置view后面的间距 (///优先级  kfc.frontSpace >  customSpace > kfc.space  > space)
@property (nonatomic,readonly) ObjectType (^spacing)(CGFloat);
///设置view前面的间距 覆盖前面view设置的spacing
@property (nonatomic,readonly) ObjectType (^frontSpacing)(CGFloat);

- (instancetype )startAlignment;
- (instancetype )endAlignment;
- (instancetype )centerAlignment;

@property (nonatomic,readonly) ObjectType (^startAlign)(CGFloat marge);
@property (nonatomic,readonly) ObjectType (^endAlign)(CGFloat marge);
@property (nonatomic,readonly) ObjectType (^centerAlign)(CGFloat offsetY);
@property (nonatomic,readonly) ObjectType (^align)(ZLCrossAxisAlignment);

@end

@class ZLPopBaseView;

@interface ZLUIViewConfigure : ZLBaseConfigure<ZLUIViewConfigure *,UIView *>
@end


@interface ZLUILabelConfigure : ZLBaseConfigure<ZLUILabelConfigure *,UILabel*>

@property (nonatomic,readonly)ZLUILabelConfigure* (^updateViewModelBK)(void(^)(__kindof UILabel* label,id viewModel,BOOL isUpdate));
@property (nonatomic,readonly)ZLUILabelConfigure* (^enableConfigBK)(void(^)(__kindof UILabel* label,id viewModel));
@property (nonatomic,readonly)ZLUILabelConfigure* (^disableConfigBK)(void(^)(__kindof UILabel* label,id viewModel));


@property (nonatomic,readonly)ZLUILabelConfigure* (^font)(UIFont *);
@property (nonatomic,readonly)ZLUILabelConfigure* (^systemFontSize)(CGFloat);
@property (nonatomic,readonly)ZLUILabelConfigure* (^systemFontSizeMedium)(CGFloat);
//UIColor or #333333
@property (nonatomic,readonly)ZLUILabelConfigure* (^textColor)(id);
@property (nonatomic,readonly)ZLUILabelConfigure* (^text)(NSString *);
@property (nonatomic,readonly)ZLUILabelConfigure* (^textAlignment)(NSTextAlignment);
- (instancetype)textAlignmentCenter;
- (instancetype)textAlignmentLeft;
- (instancetype)textAlignmentRight;
@property (nonatomic,readonly)ZLUILabelConfigure* (^attributedText)(NSAttributedString *);
@property (nonatomic,readonly)ZLUILabelConfigure* (^numberOfLines)(NSInteger);
- (instancetype)multipleLines;
- (instancetype)singleLine;
- (instancetype)twoLines;
- (instancetype)blackTextColor;
- (instancetype)redTextColor;
- (instancetype)whiteTextColor;
@end


@interface ZLUITextFieldConfigure : ZLBaseConfigure<ZLUITextFieldConfigure *,UITextField *>
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^updateViewModelBK)(void(^)(__kindof UITextField* textField,id viewModel,BOOL isUpdate));
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^enableConfigBK)(void(^)(__kindof UITextField* textField,id viewModel));
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^disableConfigBK)(void(^)(__kindof UITextField* textField,id viewModel));


@property (nonatomic,readonly)ZLUITextFieldConfigure* (^font)(UIFont *);
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^systemFontSize)(CGFloat);
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^systemFontSizeMedium)(CGFloat);
//UIColor or #333333
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^textColor)(id);
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^text)(NSString *);
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^textAlignment)(NSTextAlignment);
- (instancetype)textAlignmentCenter;
- (instancetype)textAlignmentLeft;
- (instancetype)textAlignmentRight;
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^placeholder)(NSString *);
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^clearButtonMode)(UITextFieldViewMode);
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^keyboardType)(UIKeyboardType);
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^returnKeyType)(UIReturnKeyType);
@property (nonatomic,readonly)ZLUITextFieldConfigure* (^leftPadding)(CGFloat);


@end

@interface ZLUITextViewConfigure : ZLBaseConfigure<ZLUITextViewConfigure *,UITextView *>

@property (nonatomic,readonly)ZLUITextViewConfigure* (^updateViewModelBK)(void(^)(__kindof UITextView* textView,id viewModel,BOOL isUpdate));
@property (nonatomic,readonly)ZLUITextViewConfigure* (^enableConfigBK)(void(^)(__kindof UITextView* textView,id viewModel));
@property (nonatomic,readonly)ZLUITextViewConfigure* (^disableConfigBK)(void(^)(__kindof UITextView* textView,id viewModel));
@end


@interface ZLUIButtonConfigure : ZLBaseConfigure<ZLUIButtonConfigure *,UIButton *>

@property (nonatomic,readonly)ZLUIButtonConfigure* (^updateViewModelBK)(void(^)(__kindof UIButton* UIButton,id viewModel,BOOL isUpdate));
///view userInteractionEnabled = YES 可接收点击的时候调用在这个block里面进行相关属性配置
@property (nonatomic,readonly)ZLUIButtonConfigure* (^enableConfigBK)(void(^)(__kindof UIButton* button,id viewModel));
///view userInteractionEnabled = NO 不可接收点击的时候调用在这个block里面进行相关属性配置
@property (nonatomic,readonly)ZLUIButtonConfigure* (^disableConfigBK)(void(^)(__kindof UIButton* button,id viewModel));


/// 添加按钮点击事件，多次传入block只调用最后一次
@property (nonatomic,readonly)ZLUIButtonConfigure* (^touchUpAction)(void(^)(UIButton *button));
///多次传入block会回调多次
@property (nonatomic,readonly)ZLUIButtonConfigure* (^addTouchUpAction)(void(^)(UIButton *button));

@property (nonatomic,readonly)ZLUIButtonConfigure* (^titleFont)(UIFont *);
@property (nonatomic,readonly)ZLUIButtonConfigure* (^titleSystemFontSize)(CGFloat);
@property (nonatomic,readonly)ZLUIButtonConfigure* (^titleSystemFontSizeMedium)(CGFloat);
//UIColor or #333333
@property (nonatomic,readonly)ZLUIButtonConfigure* (^titleColor)(id);
///UIColor or #333333
@property (nonatomic,readonly)ZLUIButtonConfigure* (^titleColorForState)(id,UIControlState);
@property (nonatomic,readonly)ZLUIButtonConfigure* (^selected)(BOOL);
@property (nonatomic,readonly)ZLUIButtonConfigure* (^title)(NSString *);
@property (nonatomic,readonly)ZLUIButtonConfigure* (^titleForState)(NSString *,UIControlState);
@property (nonatomic,readonly)ZLUIButtonConfigure* (^titleAlignment)(NSTextAlignment);
- (instancetype)titleAlignmentCenter;
- (instancetype)titleAlignmentLeft;
- (instancetype)titleAlignmentRight;
@property (nonatomic,readonly)ZLUIButtonConfigure* (^highlightBgColor)(id);
- (instancetype)defaultHighlightBgColor;
///UIImage or #imageName
@property (nonatomic,readonly)ZLUIButtonConfigure* (^imageForState)(id,UIControlState);
///设置normal状态下图片
@property (nonatomic,readonly)ZLUIButtonConfigure* (^image)(id);
@property (nonatomic,readonly)ZLUIButtonConfigure* (^imageForSelected)(id);
- (instancetype)blackTitleColor;
- (instancetype)whiteTitleColor;
@end

@interface ZLUIImageViewConfigure : ZLBaseConfigure<ZLUIImageViewConfigure *,UIImageView *>
///UIImage or #imageName or UIColor or #333333
@property (nonatomic,readonly)ZLUIImageViewConfigure* (^image)(id);
@end

@interface ZLUISwitchConfigure : ZLBaseConfigure<ZLUISwitchConfigure *,UISwitch *>
@property (nonatomic,readonly)ZLUISwitchConfigure* (^on)(BOOL);
@end


@interface ZLUISliderConfigure : ZLBaseConfigure<ZLUISliderConfigure *,UISlider *>

@end

@interface ZLUIStackViewConfigure : ZLBaseConfigure<ZLUIStackViewConfigure *,UIStackView *>

@end

NS_ASSUME_NONNULL_END
