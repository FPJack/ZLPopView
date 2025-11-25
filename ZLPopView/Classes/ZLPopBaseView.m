//
//  ZLPopBaseView.m
//  GMPopView
//
//  Created by admin on 2025/4/17.
//

#import "ZLPopBaseView.h"
#import <objc/runtime.h>
#import "ZLBaseConfigure.h"
#import "UIView+kfc.h"

#define kSHeight UIScreen.mainScreen.bounds.size.height
#define kSWidth UIScreen.mainScreen.bounds.size.width
#define kBL @"BL"
#define kBR @"BR"
#define kBT @"BT"
#define kBB @"BB"
static NSHashTable<ZLPopBaseView *> *keyboardViews;
@implementation _ZLView
- (UIView *)contentView {
    if (!_contentView){
        _contentView = UIView.new;
        _contentView.backgroundColor = UIColor.whiteColor;
        [self addSubview:_contentView];
        [_contentView.kfc edgeToView:self edge:UIEdgeInsetsZero];
    };
    return _contentView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    // 默认设置
    self.layer.masksToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 更新圆角路径
    [self updateCornerPath];
    // 更新阴影路径
    [self updateShadowPath];
    // 更新边框
    [self updateBorder];
}

#pragma mark - 更新方法

- (void)updateCornerPath {
    if (_cornerRadius <= 0) {
        self.contentView.layer.mask = nil;
        return;
    }
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = self.bezierPath.CGPath;
    self.contentView.layer.mask = maskLayer;
}
- (UIBezierPath *)bezierPath {
    return [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds
                                                   byRoundingCorners:self.corners
                                                        cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
}
- (void)updateShadowPath {
    if (_cornerRadius <= 0) {
        self.layer.shadowPath = nil;
        return;
    }
    self.layer.shadowPath =  self.bezierPath.CGPath;
}

- (void)updateBorder {
    if (_borderWidth <= 0) {
        self.contentView.layer.borderWidth = 0;
        return;
    }
}
#pragma mark - 属性设置方法
- (void)setCorners:(UIRectCorner)corners {
    _corners = corners;
    [self setNeedsLayout];
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsLayout];
}
- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.layer.shadowColor = shadowColor.CGColor;
}
- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    self.layer.shadowOffset = shadowOffset;
}
- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    _shadowOpacity = shadowOpacity;
    self.layer.shadowOpacity = shadowOpacity;
}
- (void)setShadowRadius:(CGFloat)shadowRadius {
    _shadowRadius = shadowRadius;
    self.layer.shadowRadius = shadowRadius;
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setNeedsLayout];
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsLayout];
}
@end



@implementation UIView(draw)
- (void)addTrianglePopWithShadowColor:(UIColor *)shadowColor
                         shadowOffset:(CGSize)shadowOffset
                         shadowRadius:(CGFloat)shadowRadius
                        shadowOpacity:(float)shadowOpacity
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                            fillColor:(UIColor *)fillColor
                        triangleWidth:(CGFloat)triangleWidth
                       triangleHeight:(CGFloat)triangleHeight
                        triangleColor:(UIColor *)triangleColor
                            direction:(ZLPopOverDirection)direction
                       triangleOffset:(CGFloat)triangleOffset
                         cornerRadius:(CGFloat)cornerRadius
                       roundedCorners:(UIRectCorner)roundedCorners
{
    // 移除旧的shapeLayer
    NSArray *oldLayers = [self.layer.sublayers copy];
    for (CALayer *layer in oldLayers) {
        if ([layer.name isEqualToString:@"TrianglePopShapeLayer"]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat tw = triangleWidth;
    CGFloat th = triangleHeight;
    CGFloat offset = triangleOffset;
    CGFloat cr = cornerRadius;
    
    // 限制三角形偏移量不超出边界
    if (direction == ZLPopOverDirectionUp || direction == ZLPopOverDirectionDown) {
        offset = MAX((roundedCorners & UIRectCornerTopLeft ? cr : 0),
                     MIN(offset, w - (roundedCorners & UIRectCornerTopRight ? cr : 0) - tw));
    } else {
        offset = MAX((roundedCorners & UIRectCornerTopLeft ? cr : 0),
                     MIN(offset, h - (roundedCorners & UIRectCornerBottomLeft ? cr : 0) - tw));
    }
    
    // 主体路径
    UIBezierPath *mainPath = [UIBezierPath bezierPath];
    // 圆角辅助
    CGFloat topLeft = (roundedCorners & UIRectCornerTopLeft) ? cr : 0;
    CGFloat topRight = (roundedCorners & UIRectCornerTopRight) ? cr : 0;
    CGFloat bottomLeft = (roundedCorners & UIRectCornerBottomLeft) ? cr : 0;
    CGFloat bottomRight = (roundedCorners & UIRectCornerBottomRight) ? cr : 0;
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    switch (direction) {
        case ZLPopOverDirectionUp: {
            // 主体
            [mainPath moveToPoint:CGPointMake(topLeft, th)];
            [mainPath addLineToPoint:CGPointMake(offset, th)];
            [mainPath addLineToPoint:CGPointMake(offset + tw/2, 0)];
            [mainPath addLineToPoint:CGPointMake(offset + tw, th)];
            [mainPath addLineToPoint:CGPointMake(w - topRight, th)];
            if (topRight > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(w, th + topRight) controlPoint:CGPointMake(w, th)];
            }
            [mainPath addLineToPoint:CGPointMake(w, h - bottomRight)];
            if (bottomRight > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(w - bottomRight, h) controlPoint:CGPointMake(w, h)];
            }
            [mainPath addLineToPoint:CGPointMake(bottomLeft, h)];
            if (bottomLeft > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(0, h - bottomLeft) controlPoint:CGPointMake(0, h)];
            }
            [mainPath addLineToPoint:CGPointMake(0, th + topLeft)];
            if (topLeft > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(topLeft, th) controlPoint:CGPointMake(0, th)];
            }
            [mainPath closePath];
            // 三角
            [trianglePath moveToPoint:CGPointMake(offset, th)];
            [trianglePath addLineToPoint:CGPointMake(offset + tw/2, 0)];
            [trianglePath addLineToPoint:CGPointMake(offset + tw, th)];
            [trianglePath closePath];
            break;
        }
        case ZLPopOverDirectionDown: {
            [mainPath moveToPoint:CGPointMake(topLeft, 0)];
            [mainPath addLineToPoint:CGPointMake(w - topRight, 0)];
            if (topRight > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(w, topRight) controlPoint:CGPointMake(w, 0)];
            }
            [mainPath addLineToPoint:CGPointMake(w, h - th - bottomRight)];
            if (bottomRight > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(w - bottomRight, h - th) controlPoint:CGPointMake(w, h - th)];
            }
            [mainPath addLineToPoint:CGPointMake(offset + tw, h - th)];
            [mainPath addLineToPoint:CGPointMake(offset + tw/2, h)];
            [mainPath addLineToPoint:CGPointMake(offset, h - th)];
            [mainPath addLineToPoint:CGPointMake(bottomLeft, h - th)];
            if (bottomLeft > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(0, h - th - bottomLeft) controlPoint:CGPointMake(0, h - th)];
            }
            [mainPath addLineToPoint:CGPointMake(0, topLeft)];
            if (topLeft > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(topLeft, 0) controlPoint:CGPointMake(0, 0)];
            }
            [mainPath closePath];
            [trianglePath moveToPoint:CGPointMake(offset, h - th)];
            [trianglePath addLineToPoint:CGPointMake(offset + tw/2, h)];
            [trianglePath addLineToPoint:CGPointMake(offset + tw, h - th)];
            [trianglePath closePath];
            break;
        }
        case ZLPopOverDirectionLeft: {
            [mainPath moveToPoint:CGPointMake(th, topLeft)];
            [mainPath addLineToPoint:CGPointMake(th, offset)];
            [mainPath addLineToPoint:CGPointMake(0, offset + tw/2)];
            [mainPath addLineToPoint:CGPointMake(th, offset + tw)];
            [mainPath addLineToPoint:CGPointMake(th, h - bottomLeft)];
            if (bottomLeft > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(th + bottomLeft, h) controlPoint:CGPointMake(th, h)];
            }
            [mainPath addLineToPoint:CGPointMake(w - bottomRight, h)];
            if (bottomRight > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(w, h - bottomRight) controlPoint:CGPointMake(w, h)];
            }
            [mainPath addLineToPoint:CGPointMake(w, topRight)];
            if (topRight > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(w - topRight, 0) controlPoint:CGPointMake(w, 0)];
            }
            [mainPath addLineToPoint:CGPointMake(th + topLeft, 0)];
            if (topLeft > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(th, topLeft) controlPoint:CGPointMake(th, 0)];
            }
            [mainPath closePath];
            [trianglePath moveToPoint:CGPointMake(th, offset)];
            [trianglePath addLineToPoint:CGPointMake(0, offset + tw/2)];
            [trianglePath addLineToPoint:CGPointMake(th, offset + tw)];
            [trianglePath closePath];
            break;
        }
        case ZLPopOverDirectionRight: {
            [mainPath moveToPoint:CGPointMake(0, topLeft)];
            if (topLeft > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(topLeft, 0) controlPoint:CGPointMake(0, 0)];
            }
            [mainPath addLineToPoint:CGPointMake(w - th - topRight, 0)];
            if (topRight > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(w - th, topRight) controlPoint:CGPointMake(w - th, 0)];
            }
            [mainPath addLineToPoint:CGPointMake(w - th, offset)];
            [mainPath addLineToPoint:CGPointMake(w, offset + tw/2)];
            [mainPath addLineToPoint:CGPointMake(w - th, offset + tw)];
            [mainPath addLineToPoint:CGPointMake(w - th, h - bottomRight)];
            if (bottomRight > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(w - th - bottomRight, h) controlPoint:CGPointMake(w - th, h)];
            }
            [mainPath addLineToPoint:CGPointMake(topLeft, h)];
            if (bottomLeft > 0) {
                [mainPath addQuadCurveToPoint:CGPointMake(0, h - bottomLeft) controlPoint:CGPointMake(0, h)];
            }
            [mainPath addLineToPoint:CGPointMake(0, topLeft)];
            [mainPath closePath];
            [trianglePath moveToPoint:CGPointMake(w - th, offset)];
            [trianglePath addLineToPoint:CGPointMake(w, offset + tw/2)];
            [trianglePath addLineToPoint:CGPointMake(w - th, offset + tw)];
            [trianglePath closePath];
            break;
        }
    }
    
    // 主体ShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = mainPath.CGPath;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.strokeColor = borderColor.CGColor;
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.shadowColor = shadowColor.CGColor;
    shapeLayer.shadowOffset = shadowOffset;
    shapeLayer.shadowRadius = shadowRadius;
    shapeLayer.shadowOpacity = shadowOpacity;
    shapeLayer.name = @"TrianglePopShapeLayer";
    [self.layer insertSublayer:shapeLayer atIndex:0];
    
    // 三角形ShapeLayer
    CAShapeLayer *triangleLayer = [CAShapeLayer layer];
    triangleLayer.path = trianglePath.CGPath;
    triangleLayer.fillColor = triangleColor.CGColor;
    triangleLayer.strokeColor = [UIColor clearColor].CGColor;
    triangleLayer.name = @"TrianglePopShapeLayer";
    [self.layer insertSublayer:triangleLayer above:shapeLayer];
}
@end


@implementation ZLBuildConfigObj
- (instancetype)init
{
    self = [super init];
    _corners = UIRectCornerAllCorners;
    _cornerRadius = 5;
    _shadowOffset = CGSizeMake(0, 2);
    _shadowRadius = 3;
    _animationIn = 0.25;
    _animationOut = 0.25;
    _popViewMarge = UIEdgeInsetsZero;
    return self;
}
- (void)setEnableDragDismiss:(BOOL)enableDragDismiss {
    _enableDragDismiss = enableDragDismiss;
    self.addDragGestureRecognizer = enableDragDismiss;
}
- (void)setInset:(UIEdgeInsets)inset {
    _inset = UIEdgeInsetsMake(inset.top, inset.left, -inset.bottom, -inset.right);
}
- (void)setMarge:(UIEdgeInsets)marge {
    _marge = UIEdgeInsetsMake(marge.top, marge.left, -marge.bottom, -marge.right);
}
@end
@implementation ZLLayoutConstraintObj



@end

@interface ZLPopBaseView()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic,strong,readwrite)_ZLView *containerView;
@property (nonatomic,strong)UIView *buildView;
@property (nonatomic,weak,readonly)UIView *parentView;
///////////////////////////////////////////////////
@property (nonatomic,strong,readwrite)ZLBuildConfigObj *configObj;

@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong)UIPanGestureRecognizer *panGesture;

@property (nonatomic,weak)UIScrollView *otherScrollView;
@property (nonatomic,assign)BOOL isDismissing;
/// 内容实际高度
@property (nonatomic,assign,readonly)CGFloat containerHeight;
@property (nonatomic,strong)NSLayoutConstraint *viewBottomCons;
@property (nonatomic,strong)NSLayoutConstraint *viewTopCons;
@property (nonatomic,strong)NSLayoutConstraint *viewCenterYCons;
@property (nonatomic,strong)NSLayoutConstraint *viewCenterXCons;
@property (nonatomic,strong)NSLayoutConstraint *viewRightCons;
@property (nonatomic,strong)NSLayoutConstraint *viewLeftCons;

@property (nonatomic,assign,readonly)BOOL keyboardIsShowing;

@property (nonatomic,assign,readonly)BOOL isFloat;
@property (nonatomic,assign)BOOL isFullFloat;

/// scrollview 手指刚开始滑动的时候初始便宜量
@property (nonatomic,assign)CGFloat otherScrollViewBeganOffsetY;

@property (nonatomic,assign,readwrite)ZLPopViewPageState pageState;

@property (nonatomic,assign)ZLPanGestureActionType panActionType;

@property (nonatomic,strong,readwrite)ZLLayoutConstraintObj *constraintObj;
@property (nonatomic,copy)PopViewCallbackBK didShowBlock;
@property (nonatomic,copy)PopViewCallbackBK didHiddenBlock;
@property (nonatomic,copy)PopViewCallbackBK deallocBlock;
@property (nonatomic,copy)PopViewCallbackBK initStateBlock;
@property (nonatomic,weak,readwrite)id<ZLPopViewDelegate> delegateObj;


- (void)gm_pan:(UIPanGestureRecognizer *)gesture;
- (void)popViewWillShow:(ZLPopBaseView *)popView;
- (void)popViewDidShow:(ZLPopBaseView *)popView;
- (void)popViewWillHidden:(ZLPopBaseView *)popView;
- (void)popViewDidHidden:(ZLPopBaseView *)popView;
- (void)popViewDealloc:(ZLPopBaseView *)popView;
- (void)showKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration;
- (void)hiddenKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration;
@end
@implementation ZLPopBaseView
- (void)setViewTopCons:(NSLayoutConstraint *)viewTopCons {
    _viewTopCons = viewTopCons;
    self.constraintObj.margeTopCons = viewTopCons;
}
- (void)setViewBottomCons:(NSLayoutConstraint *)viewBottomCons  {
    _viewBottomCons  = viewBottomCons;
    self.constraintObj.margeBottomCons = viewBottomCons;
}
- (void)setViewLeftCons:(NSLayoutConstraint *)viewLeftCons {
    _viewLeftCons =  viewLeftCons;
    self.constraintObj.margeLeadingCons = viewLeftCons;
}
- (void)setViewRightCons:(NSLayoutConstraint *)viewRightCons {
    _viewRightCons = viewRightCons;
    self.constraintObj.margeTrailingCons = viewRightCons;
}
- (void)setViewCenterXCons:(NSLayoutConstraint *)viewCenterXCons {
    _viewCenterXCons = viewCenterXCons;
    self.constraintObj.centerXCons = viewCenterXCons;
}
- (void)setViewCenterYCons:(NSLayoutConstraint *)viewCenterYCons {
    _viewCenterYCons = viewCenterYCons;
    self.constraintObj.centerYCons = viewCenterYCons;
}
- (BOOL)keyboardIsShowing {
    return ZLKeyboardEvent.share.keyboardIsShowing;
}
- (void)popViewWillShow:(ZLPopBaseView *)popView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate popViewWillShow:self];
    }
    self.pageState = ZLPopViewPageStateShowing;
}
- (void)popViewDidShow:(ZLPopBaseView *)popView {
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate popViewDidShow:self];
    }
    if (self.keyboardIsShowing && self.configObj.avoidKeyboardType != ZLAvoidKeyboardTypeNone) {
        [self showKeyboardEvent:ZLKeyboardEvent.share.keyboardHeight duration:0];
    }
    self.pageState = ZLPopViewPageStateDidShow;
    if (self.configObj.orientationChangeBk) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        BOOL isLandscape = UIInterfaceOrientationIsLandscape(interfaceOrientation);
        if (isLandscape) {
            self.configObj.orientationChangeBk(self.constraintObj,self.configObj,isLandscape);
        }
    }
    if (self.didShowBlock) self.didShowBlock(self);
}
- (ZLPopBaseView * _Nonnull (^)(PopViewCallbackBK _Nonnull))initStateBK {
    return ^ZLPopBaseView *(PopViewCallbackBK callback) {
        self.initStateBlock = callback;
        return self;
    };
}
- (ZLPopBaseView * _Nonnull (^)(PopViewCallbackBK _Nonnull))didShowBK {
    return ^ZLPopBaseView *(PopViewCallbackBK callback) {
        self.didShowBlock = callback;
        return self;
    };
}
-(void)letViewBecomeFirstResponderIfNotNull {
    UIView *firstResponderView = [self findSubviewInView:self matching:^BOOL(UIView *subview) {
        return subview.kfcCreated && subview.kfc.isFirstResponder;
    }];
    if (firstResponderView) [firstResponderView becomeFirstResponder];
}
- (void)popViewWillHidden:(ZLPopBaseView *)popView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate popViewWillHidden:self];
    }
    self.pageState = ZLPopViewPageStateDismissing;
}
- (void)popViewDidHidden:(ZLPopBaseView *)popView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate popViewDidHidden:self];
    }
    self.pageState = ZLPopViewPageStateDidDismissed;
    if (self.didHiddenBlock) self.didHiddenBlock(self);
}
- (ZLPopBaseView * _Nonnull (^)(PopViewCallbackBK _Nonnull))didHiddenBK {
    return ^ZLPopBaseView *(PopViewCallbackBK callback) {
        self.didHiddenBlock = callback;
        return self;
    };
}
- (void)popViewDealloc:(ZLPopBaseView *)popView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate popViewDidHidden:self];
    }
}
- (void)removeFromSuperview {
    [self popViewDidHidden:self];
    [super removeFromSuperview];
}
- (void)removeSelfFromSuperview {
    if ([self popViewShouldRemoveFromSuperView:self]) {
        [self removeFromSuperview];
    }
}
- (BOOL)popViewShouldRemoveFromSuperView:(ZLPopBaseView *)popView {
    if ([self.delegate respondsToSelector:_cmd]) {
        return  [self.delegate popViewShouldRemoveFromSuperView:self];
    }
    return  YES;
}
- (void)popViewShowExpand:(ZLPopBaseView *)popView {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate popViewShowExpand:self];
    }
}
- (void)popViewShowTight:(ZLPopBaseView *)popView{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate popViewShowTight:self];
    }
}

- (UIView *)findSubviewInView:(UIView *)view matching:(BOOL (^)(UIView *subview))predicate {
    for (UIView *subview in view.subviews) {
        if (predicate(subview)) {
            return subview;
        }
        UIView *result = [self findSubviewInView:subview matching:predicate];
        if (result) {
            return result;
        }
    }
    return nil;
}

- (CGFloat)containerHeight {
    return self.containerView.frame.size.height;
}
- (UIView *)parentView {
    return [self.configObj.superView isKindOfClass:UIView.class] ? self.configObj.superView : [self getKeyWindow];
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gm_tap)];
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}
- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gm_pan:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}
- (void)gm_tap {
    [self dismiss];
}

- (void)gm_pan:(UIPanGestureRecognizer *)gesture {
    CGPoint velocity = [gesture velocityInView:self.superview];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (fabs(velocity.x) > fabs(velocity.y)) self.panActionType = ZLPanGestureActionTypeHor;
        if (fabs(velocity.x) < fabs(velocity.y)) self.panActionType = ZLPanGestureActionTypeVer;
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.panActionType = ZLPanGestureActionTypeNone;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        return YES;
    }
    //优先子视图相应手势
    CGPoint touchPoint = [touch locationInView:self];
    UIView *touchedView = [self hitTest:touchPoint withEvent:nil];
    return [touchedView isEqual:self] ? YES : NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] && [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        if ([otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
            self.otherScrollView = (UIScrollView*)otherGestureRecognizer.view;
        }
    }
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.pageState = ZLPopViewPageStateNone;
        self.clipsToBounds = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                    selector:@selector(deviceOrientationWillChange:)
                                                        name:UIApplicationWillChangeStatusBarOrientationNotification
                                                      object:nil];
    }
    return self;
}
- (ZLLayoutConstraintObj *)constraintObj   {
    if (!_constraintObj) _constraintObj = ZLLayoutConstraintObj.new;
    return _constraintObj;
}
- (void)deviceOrientationWillChange:(NSNotification *)notification {
    UIInterfaceOrientation newOrientation = [notification.userInfo[UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    if (self.configObj.orientationChangeBk) {
        self.configObj.orientationChangeBk(self.constraintObj,self.configObj,!UIInterfaceOrientationIsPortrait(newOrientation));
    }
}
- (void)setConfigObj:(ZLBuildConfigObj *)configObj {
    _configObj = configObj;
    self.containerView.borderColor = configObj.borderColor;
    self.containerView.borderWidth = configObj.borderWidth;
    self.containerView.cornerRadius = configObj.cornerRadius;
    self.containerView.corners = configObj.corners;
    self.containerView.shadowColor = configObj.shadowColor;
    self.containerView.shadowOffset = configObj.shadowOffset;
    self.containerView.shadowRadius = configObj.shadowRadius;
    self.containerView.shadowOpacity = configObj.shadowOpacity;
}
- (void)showKeyboard:(NSNotification *)notification {
    if (self.bounds.origin.y > 0 || self.superview.bounds.origin.y > 0) return;

    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self showKeyboardEvent:keyboardHeight duration:animationDuration ? animationDuration : 0.1];
}
- (void)showKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {}
- (void)hiddenKeyboard:(NSNotification *)notification {
    if (self.bounds.origin.y > 0 || self.superview.bounds.origin.y > 0) return;
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self hiddenKeyboardEvent:keyboardHeight duration:animationDuration];
}
- (void)hiddenKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {}
-(_ZLView *)containerView{
    if(!_containerView){
        _containerView = [_ZLView new];
    }
    return _containerView;
}


- (void)dismiss {
    self.isDismissing = NO;
    [UIView animateWithDuration: _configObj.animationOut animations:^{
        self.backgroundColor = UIColor.clearColor;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!finished)return;
        [self removeSelfFromSuperview];
    }];
}
- (void)addPopViewMargeCons {
    UIEdgeInsets m = self.configObj.popViewMarge;
    NSArray<NSLayoutConstraint *> *constraints = [self.kfc edgeToView:self.superview edge:UIEdgeInsetsMake(m.top, m.left, -m.bottom, -m.right)];
    ZLLayoutConstraintObj *obj = self.constraintObj;
    obj.popViewMargeTopCons = constraints[0];
    obj.popViewMargeLeadingCons = constraints[1];
    obj.popViewMargeBottomCons = constraints[2];
    obj.popViewMargeTrailingCons = constraints[3];
}
- (void)addHorizontalLayoutConstraints {
    UIView *view = self.containerView;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.configObj.horizontalLayout == ZLHorizontalLayoutConstraintFill) {
        self.viewLeftCons = [[view.leadingAnchor constraintEqualToAnchor:view.superview.leadingAnchor constant:self.configObj.marge.left] gm_enableActive];
        self.viewRightCons = [[view.trailingAnchor constraintEqualToAnchor:view.superview.trailingAnchor constant:self.configObj.marge.right] gm_enableActive];
    }else if (self.configObj.horizontalLayout == ZLHorizontalLayoutConstraintLeading) {
        self.viewLeftCons = [[view.leadingAnchor constraintEqualToAnchor:view.superview.leadingAnchor constant:self.configObj.marge.left] gm_enableActive];
    }else if (self.configObj.horizontalLayout == ZLHorizontalLayoutConstraintCenter) {
       self.viewCenterXCons = [[view.centerXAnchor constraintEqualToAnchor:view.superview.centerXAnchor] gm_enableActive];
    }else if (self.configObj.horizontalLayout == ZLHorizontalLayoutConstraintTrailing) {
        self.viewRightCons = [[view.trailingAnchor constraintEqualToAnchor:view.superview.trailingAnchor constant:self.configObj.marge.right] gm_enableActive];
    }
}
- (void)show {
    [self removeConstraints:self.constraints];
    [self.layer removeAllAnimations];
    ZLBuildConfigObj *j = self.configObj;
    if (j.avoidKeyboardType != ZLAvoidKeyboardTypeNone) {
        [keyboardViews addObject:self];
    }
    [self.containerView.contentView addSubview:self.buildView];
    [self addSubview:self.containerView];
    UIView *parentView = self.parentView ? self.parentView : [self getKeyWindow];
    [parentView addSubview:self];
    if (self.initStateBlock) {
        self.initStateBlock(self);
        self.initStateBK = nil;
    }
    [self popViewWillShow:self];

    [self addHorizontalLayoutConstraints];
    
    if (j.tapMaskDismiss && !j.touchPenetrate) [self addGestureRecognizer:self.tapGesture];
    self.constraintObj.insetLeadingCons =  [self.buildView.kfc  leadingToView:self.buildView.superview offset:j.inset.left];
    self.constraintObj.insetLeadingCons.identifier = kBL;
    
    self.constraintObj.insetTrailingCons =
    [self.buildView.kfc  trailingToView:self.buildView.superview offset:j.inset.right];
    self.constraintObj.insetTrailingCons.identifier = kBR;
    
    self.constraintObj.insetTopCons = [self.buildView.kfc topToView:self.buildView.superview offset:j.inset.top ];
    self.constraintObj.insetTopCons.identifier = kBT;
    self.constraintObj.insetBottomCons =
    [self.buildView.kfc bottomToView:self.buildView.superview offset:j.inset.bottom];
    self.constraintObj.insetBottomCons.identifier = kBB;

    UIView *v = self.containerView;
    if (j.backgroundColor) {
        self.containerView.contentView.backgroundColor = j.backgroundColor;
    }
    self.backgroundColor = j.maskColor;
    if (j.horizontalLayout != ZLHorizontalLayoutConstraintFill) {
        v.translatesAutoresizingMaskIntoConstraints = NO;
        if (j.width > 0) {
           self.constraintObj.widthCons = [[v.widthAnchor constraintEqualToConstant:j.width] gm_enableActive];
        }else if (j.maxWidth > 0) {
            self.constraintObj.maxWidthCons = [[v.widthAnchor constraintLessThanOrEqualToConstant:j.maxWidth] gm_enableActive];
        }else if (j.widthMultiplier > 0) {
            self.constraintObj.widthMultiplierCons = [[v.widthAnchor constraintEqualToAnchor:v.superview.widthAnchor multiplier:j.widthMultiplier] gm_enableActive];
        }else if (j.maxWidthMultiplier > 0) {
            self.constraintObj.maxWidthMultiplierCons = [[v.widthAnchor constraintLessThanOrEqualToAnchor:v.superview.widthAnchor multiplier:j.maxWidthMultiplier]  gm_enableActive];
        }
        if ([self.buildView isKindOfClass:UIScrollView.class] && j.axis == UILayoutConstraintAxisHorizontal) {
            UIView *view = [self.buildView viewWithTag:kZLUIStackViewTag];
            [[[view.widthAnchor constraintEqualToAnchor:self.buildView.widthAnchor] gm_setPriority:UILayoutPriorityDefaultLow] gm_enableActive];
        }
    }
    if (j.height > 0) {
        self.constraintObj.heightCons = [[[v.heightAnchor constraintEqualToConstant:j.height]  gm_setPriority:UILayoutPriorityRequired] gm_enableActive];
    }else if (j.maxHeight > 0) {
        self.constraintObj.maxHeightCons = [[[v.heightAnchor constraintLessThanOrEqualToConstant:j.maxHeight] gm_setPriority:UILayoutPriorityRequired] gm_enableActive];
    }else if (j.heightMultiplier > 0) {
        self.constraintObj.heightMultiplierCons =  [[v.heightAnchor constraintEqualToAnchor:v.superview.heightAnchor multiplier:j.heightMultiplier] gm_enableActive];
    }else if (j.maxHeightMultiplier > 0) {
        self.constraintObj.maxHeightMultiplierCons =  [[v.heightAnchor constraintLessThanOrEqualToAnchor:v.superview.heightAnchor multiplier:j.maxHeightMultiplier] gm_enableActive];
    }
    if (j.axis == UILayoutConstraintAxisVertical && [self.buildView isKindOfClass:UIScrollView.class]) {
        UIView *view = [self.buildView viewWithTag:kZLUIStackViewTag];
        [[[view.heightAnchor constraintEqualToAnchor:self.buildView.heightAnchor] gm_setPriority:UILayoutPriorityDefaultLow] gm_enableActive];
    }
}

- (void (^)(void))showPopView {
    return ^ (){
        [self show];
    };
}
- (void (^)(void))dismissPopView {
    return ^ (){
        [self dismiss];
    };
}
- (ZLPopBaseView * _Nonnull (^)(id<ZLPopViewDelegate> _Nonnull))delegate {
    return ^ZLPopBaseView* (id<ZLPopViewDelegate> obj){
        self.delegateObj = obj;
        return self;
    };
}

- (UIWindow *)getKeyWindow {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindow *window in UIApplication.sharedApplication.windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
                break;
            }
        }
    } else {
        keyWindow = UIApplication.sharedApplication.keyWindow;
    }
    return keyWindow;
}
- (BOOL)resignFirstResponder {
    UIView *firstResponderView = [self findFirstResponderInView:self];
    if (firstResponderView) {
        return [firstResponderView resignFirstResponder];
    }
    return [super resignFirstResponder];
}
- (UIView *)findFirstResponderInView:(UIView *)view {
    if ([view isFirstResponder]) {return view;}
    for (UIView *subview in view.subviews) {
        UIView *firstResponder = [self findFirstResponderInView:subview];
        if (firstResponder) {return firstResponder;}
    }
    return nil;
}
- (CGFloat)firstResponderMaxYToWindow {
    UIView *view = [self findFirstResponderInView:self];
    CGFloat y = 0;
    if ([self.buildView isKindOfClass:UIScrollView.class]) {
        UIScrollView *scrollView = (UIScrollView*)self.buildView;
        if (scrollView.scrollEnabled && CGRectGetMaxY(view.frame) - scrollView.contentOffset.y > self.containerHeight) {
            y = CGRectGetMaxY(view.frame) - self.containerHeight;
            [scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(view.frame) - self.containerHeight) animated:YES];
        }
    }
    CGRect viewFrameInWindow = [view convertRect:view.bounds toView:[self getKeyWindow]];
    CGFloat maxY = CGRectGetMaxY(viewFrameInWindow) - y;
    return maxY;
}
- (CGFloat)popViewMaxYToWindow {
    CGRect viewFrameInWindow = [self.containerView convertRect:self.containerView.bounds toView:[self getKeyWindow]];
    CGFloat maxY = CGRectGetMaxY(viewFrameInWindow);
    return maxY;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.deallocBlock) self.deallocBlock(self);
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self);
#else
#endif
}

- (ZLPopBaseView * _Nonnull (^)(PopViewCallbackBK _Nonnull))deallocBK {
    return ^ZLPopBaseView *(PopViewCallbackBK callback) {
        self.deallocBlock = callback;
        return self;
    };
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hitTestBK) {
        BOOL stop = NO;
        UIView *hitView = self.hitTestBK(self, point, event,&stop);
        if (stop) return hitView;
    }
    
    if (self.userInteractionEnabled == NO ||
        self.hidden == YES ||
        self.alpha <= 0.01) {
        return nil;
    }
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
        CGPoint convertedPoint = [subview convertPoint:point fromView:self];
        UIView *hitView = [subview hitTest:convertedPoint withEvent:event];
        if (hitView) {
            return hitView;
        }
    }
    return self.configObj.touchPenetrate ? nil : self;
}
@end


@implementation ZLPopTopView
- (void)show{
    if (self.pageState == ZLPopViewPageStateShowing || self.pageState == ZLPopViewPageStateDidShow) return;
    [super show];
    [self addPopViewMargeCons];
    [self.containerView layoutIfNeeded];
    CGFloat height = self.containerHeight + self.configObj.marge.top;
    self.viewTopCons =  [self.containerView.kfc topToView:self offset:-height];
    [self layoutIfNeeded];
    self.viewTopCons.constant = self.configObj.marge.top;
    if (self.configObj.animationIn > 0) {
        self.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:self.configObj.animationIn animations:^{
            self.backgroundColor = self.configObj.maskColor;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
    [self letViewBecomeFirstResponderIfNotNull];
    [self popViewDidShow:self];
    //支持拖拽dismiss
    if (self.configObj.addDragGestureRecognizer) {
        [self.buildView addGestureRecognizer:self.panGesture];
    }
}
- (void)dismiss {
    if (self.pageState == ZLPopViewPageStateDismissing || self.pageState == ZLPopViewPageStateDidDismissed) return;
    [self popViewWillHidden:self];
    if (self.configObj.animationOut <= 0) {
        [self.delegate popViewDidHidden:self];
        [self removeSelfFromSuperview];
        return;
    }
    CGFloat offsetY = self.containerHeight;
    self.viewTopCons.constant = -offsetY;
    [super dismiss];
}
- (void)gm_pan:(UIPanGestureRecognizer *)gesture {
    [super gm_pan:gesture];
    if (self.keyboardIsShowing) {return;}
    if (self.panActionType == ZLPanGestureActionTypeHor)return;
    CGPoint translation = [gesture translationInView:self.superview];
    if (translation.y > 0) return;
    self.viewTopCons.constant = self.configObj.marge.top + translation.y;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGFloat space = self.configObj.dragDismissDistance > 0 ? -self.configObj.dragDismissDistance : -self.containerHeight / 4;
        if (translation.y < space && self.configObj.enableDragDismiss) {
            [self dismiss];
        } else {
            // 回弹
            self.viewTopCons.constant = self.configObj.marge.top;
            [UIView animateWithDuration:self.configObj.animationIn animations:^{
                [self layoutIfNeeded];
            }];
        }
    }
}
- (void)showKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {
    CGFloat bottomToWindowSpace = UIScreen.mainScreen.bounds.size.height - self.containerHeight - self.configObj.marge.top;
    if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeFirstResponder) {
        bottomToWindowSpace = UIScreen.mainScreen.bounds.size.height - ([self firstResponderMaxYToWindow] + self.configObj.marge.top - self.viewTopCons.constant);
    }
    CGFloat offsetY = self.configObj.bottomOffsetToKeyboard + keyboardHeight - bottomToWindowSpace;
    if (offsetY <= 0 ) {
        self.viewTopCons.constant = self.configObj.marge.top;
    }else {
        self.viewTopCons.constant = -(offsetY - self.configObj.marge.top);
    }
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}
- (void)hiddenKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {
    self.viewTopCons.constant = self.configObj.marge.top;
    if (self.isDismissing) {
        [self dismiss];
    }
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}
@end


@implementation ZLPopCenterView

- (void)show{
    if (self.pageState == ZLPopViewPageStateShowing || self.pageState == ZLPopViewPageStateDidShow) return;
    self.alpha = 1;
    [super show];
    [self addPopViewMargeCons];
    [self.containerView layoutIfNeeded];
    self.viewCenterYCons = [self.containerView.kfc centerYToView:self offset:0] ;
    [self layoutIfNeeded];
    if (self.keyboardIsShowing) {
        if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypePopViewBottom) {
            CGFloat space = kSHeight - [self popViewMaxYToWindow] - self.configObj.bottomOffsetToKeyboard - ZLKeyboardEvent.share.keyboardHeight;
            if (space < 0) self.viewCenterYCons.constant = space;
        }else if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeFirstResponder) {
            CGFloat space = kSHeight - [self firstResponderMaxYToWindow] - self.configObj.bottomOffsetToKeyboard - ZLKeyboardEvent.share.keyboardHeight;
            if (space < 0) self.viewCenterYCons.constant = space;
        }else if (self.configObj.avoidKeyboardType  == ZLAvoidKeyboardTypeAlwaysCenter) {
            self.viewCenterYCons.constant = -ZLKeyboardEvent.share.keyboardHeight / 2;
        }
    }
    if (self.configObj.animationIn > 0) {
        UIView *aView = self.containerView;
        aView.transform = CGAffineTransformMakeScale(0, 0);
        self.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:self.configObj.animationIn animations:^{
            self.backgroundColor = self.configObj.maskColor;
            aView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
        }];
    }
   
    [self letViewBecomeFirstResponderIfNotNull];
    [self popViewDidShow:self];
}
- (void)dismiss {
    if (self.pageState == ZLPopViewPageStateDismissing || self.pageState == ZLPopViewPageStateDidDismissed) return;
    [self popViewWillHidden:self];
    if (self.configObj.animationOut <= 0) {
        [self removeSelfFromSuperview];
        return;
    }
    [UIView animateWithDuration:self.configObj.animationOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (!finished)return;
        [self removeSelfFromSuperview];
    }];
}
- (void)showKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {
    CGFloat offsetY;
    if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeAlwaysCenter) {
        offsetY = -keyboardHeight / 2;
    }else {
        offsetY = -keyboardHeight + (kSHeight - self.containerHeight) / 2 - self.configObj.bottomOffsetToKeyboard;
        CGFloat bottomToWindowSpace = kSHeight - ([self firstResponderMaxYToWindow] - self.viewCenterYCons.constant);
        if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeFirstResponder) {
            if (bottomToWindowSpace >= keyboardHeight) {
                offsetY = 0;
            }else {
                offsetY = -(keyboardHeight - bottomToWindowSpace + self.configObj.bottomOffsetToKeyboard);
            }
        }else if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypePopViewBottom) {
            CGFloat space = kSHeight - ([self popViewMaxYToWindow] - self.viewCenterYCons.constant) - self.configObj.bottomOffsetToKeyboard ;
            if (space > keyboardHeight) {
                return;
            }
        }
    }
    self.viewCenterYCons.constant = offsetY;
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}
- (void)hiddenKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {
    self.viewCenterYCons.constant = 0;
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}
@end


@implementation ZLPopBottomView
- (void)show{
    if (self.pageState == ZLPopViewPageStateShowing || self.pageState == ZLPopViewPageStateDidShow) return;
    [super show];
    [self addPopViewMargeCons];
    [self.containerView layoutIfNeeded];
    CGFloat height = self.containerHeight - self.configObj.marge.bottom;
    self.viewBottomCons = [self.containerView.kfc bottomToView:self offset:height];
    [self layoutIfNeeded];
    self.viewBottomCons.constant = self.configObj.marge.bottom;
    if (self.configObj.animationIn > 0) {
        self.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:self.configObj.animationIn animations:^{
            self.backgroundColor = self.configObj.maskColor;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
    [self letViewBecomeFirstResponderIfNotNull];
    [self popViewDidShow:self];
    //支持拖拽dismiss
    if (self.configObj.addDragGestureRecognizer) {
        [self.buildView addGestureRecognizer:self.panGesture];
    }
}
- (void)dismiss {
    if (self.pageState == ZLPopViewPageStateDismissing || self.pageState == ZLPopViewPageStateDidDismissed) return;
    if (self.keyboardIsShowing && [self findFirstResponderInView:self]) {
        self.isDismissing = YES;
        [self resignFirstResponder];
        return;
    }
    [self popViewWillHidden:self];
    if (self.configObj.animationOut <= 0) {
        [self.delegate popViewDidHidden:self];
        [self removeSelfFromSuperview];
        return;
    }
    self.viewBottomCons.constant = self.containerHeight;
    [super dismiss];
}

- (void)gm_pan:(UIPanGestureRecognizer *)gesture {
    [super gm_pan:gesture];
    if (self.panActionType == ZLPanGestureActionTypeHor)return;
    if (self.keyboardIsShowing) {return;}
    CGPoint translation = [gesture translationInView:self.superview];
    CGPoint velocity = [gesture velocityInView:self.containerView];
    CGFloat offsetY = self.otherScrollView.contentOffset.y;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.otherScrollViewBeganOffsetY = self.otherScrollView.contentOffset.y;
    }
    if (velocity.y > 0) {//向下
        if (offsetY <= 0) {
            self.otherScrollView.scrollEnabled = NO;
        }else {
            self.otherScrollView.scrollEnabled = YES;
            return;
        }
    }else {
        CGFloat maxOffsetY = self.otherScrollView.contentSize.height - self.otherScrollView.bounds.size.height;
        if (offsetY > maxOffsetY ) {
            return;
        } else {
            if (self.viewBottomCons.constant > self.configObj.marge.bottom) {
            }else {
                self.otherScrollView.scrollEnabled = YES;
                return;
            }
        }
    }
    if (translation.y < 0) {
        self.otherScrollView.scrollEnabled = YES;
        self.viewBottomCons.constant = self.configObj.marge.bottom;
        return;
    };
    self.viewBottomCons.constant = self.configObj.marge.bottom + translation.y - self.otherScrollViewBeganOffsetY;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGFloat space = self.configObj.dragDismissDistance > 0 ? self.configObj.dragDismissDistance : self.containerHeight / 4;
        
        if (translation.y > space && self.configObj.enableDragDismiss) {
            [self dismiss];
        } else {
            // 回弹
            self.viewBottomCons.constant = self.configObj.marge.bottom;
            [UIView animateWithDuration:self.configObj.animationIn animations:^{
                self.otherScrollView.scrollEnabled = YES;
                [self layoutIfNeeded];
            }];
        }
    }
}
- (void)showKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {
    CGFloat offsetY;
    if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeAlwaysCenter) {
        offsetY = (keyboardHeight - self.configObj.marge.bottom);
    }else {
        offsetY = keyboardHeight + self.configObj.bottomOffsetToKeyboard;
        if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeFirstResponder) {
            CGFloat bottomToWindowSpace = UIScreen.mainScreen.bounds.size.height - ([self firstResponderMaxYToWindow] + (self.configObj.marge.bottom - self.viewBottomCons.constant));
            if (bottomToWindowSpace >= offsetY) {
                offsetY = -self.configObj.marge.bottom;
            }else {
                offsetY -= bottomToWindowSpace;
                offsetY -= self.configObj.marge.bottom;
            }
        }
    }
    
    self.viewBottomCons.constant = -offsetY;
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}
- (void)hiddenKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {
    self.viewBottomCons.constant = self.configObj.marge.bottom;
    if (self.isDismissing) {
        [self dismiss];
    }
    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
    }];
}
@end
@interface ZLPopHorizontalView()
@property (nonatomic,assign)CGFloat centerYOffsetValue;
@property (nonatomic,assign)BOOL isHorizontalPan;
- (CGFloat)horizontalMarge ;
- (NSLayoutConstraint *)horizontalCons;
- (CGFloat *)showCons;
- (CGFloat)dismissCons;
- (BOOL)panShouldDismiss:(CGFloat)translationX;
- (CGFloat)panCons:(CGFloat)translationX;
@end
@implementation ZLPopHorizontalView
- (ZLPopHorizontalView* (^)(CGFloat ))setCenterYOffset{
    return  ^ZLPopHorizontalView*(CGFloat offset){
        self.centerYOffsetValue = offset;
        return self;
    };
}
- (CGFloat)
horizontalMarge {return 0;}
- (NSLayoutConstraint *)horizontalCons {return  nil;}
- (CGFloat *)showCons {return 0;}
- (CGFloat)dismissCons {return 0;}
- (BOOL)panShouldDismiss:(CGFloat)translationX {return NO;}
- (CGFloat)panCons:(CGFloat)translationX {return 0;}
- (void)show{
    if (self.pageState == ZLPopViewPageStateShowing || self.pageState == ZLPopViewPageStateDidShow) return;
    self.alpha = 1;
    [super show];
    [self addPopViewMargeCons];
    [self.containerView layoutIfNeeded];
    self.viewCenterYCons = [self.containerView.kfc centerYToView:self offset:self.centerYOffsetValue];
    [self layoutIfNeeded];
    if (self.keyboardIsShowing) {
        if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypePopViewBottom) {
            CGFloat space = kSHeight - [self popViewMaxYToWindow] - self.configObj.bottomOffsetToKeyboard - ZLKeyboardEvent.share.keyboardHeight;
            if (space < 0) self.viewCenterYCons.constant = space;
        }else if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeFirstResponder) {
            CGFloat space = kSHeight - [self firstResponderMaxYToWindow] - self.configObj.bottomOffsetToKeyboard - ZLKeyboardEvent.share.keyboardHeight;
            if (space < 0) self.viewCenterYCons.constant = space;
        }else if (self.configObj.avoidKeyboardType  == ZLAvoidKeyboardTypeAlwaysCenter) {
            self.viewCenterYCons.constant = -ZLKeyboardEvent.share.keyboardHeight / 2;
        }
    }
    
    self.horizontalCons.constant =  [self dismissCons];
    [self layoutIfNeeded];
    self.horizontalCons.constant = self.horizontalMarge;
    if (self.configObj.animationIn > 0) {
        self.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:self.configObj.animationIn animations:^{
            self.backgroundColor = self.configObj.maskColor;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
   
    [self letViewBecomeFirstResponderIfNotNull];
    [self popViewDidShow:self];
    //支持拖拽dismiss
    if (self.configObj.addDragGestureRecognizer) {
        [self.buildView addGestureRecognizer:self.panGesture];
    }
}
- (void)gm_pan:(UIPanGestureRecognizer *)gesture {
    [super gm_pan:gesture];
    CGPoint velocity = [gesture velocityInView:self.superview];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (fabs(velocity.x) > fabs(velocity.y)) self.isHorizontalPan = YES;
        if ([self.otherScrollView isKindOfClass:UIScrollView.class]) {
            self.otherScrollViewBeganOffsetY = self.otherScrollView.contentOffset.y;
        }
    }
    if (self.isHorizontalPan && [self.otherScrollView isKindOfClass:UIScrollView.class]) {
        self.otherScrollView.contentOffset = CGPointMake(0, self.otherScrollViewBeganOffsetY);
    }
    if (!self.isHorizontalPan) return;
    if (self.keyboardIsShowing) return;
    CGPoint translation = [gesture translationInView:self.parentView];
    self.horizontalCons.constant =  [self panCons:translation.x];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.isHorizontalPan = NO;
        if ([self panShouldDismiss:translation.x] && self.configObj.enableDragDismiss) {
            [self dismiss];
        } else {
            // 回弹
            self.horizontalCons.constant = self.horizontalMarge;
            [UIView animateWithDuration:self.configObj.animationIn animations:^{
                [self layoutIfNeeded];
            }];
        }
    }
}
- (void)dismiss {
    if (self.pageState == ZLPopViewPageStateDismissing || self.pageState == ZLPopViewPageStateDidDismissed) return;
    [self popViewWillHidden:self];
    if (self.configObj.animationOut <= 0) {
        [self removeSelfFromSuperview];
        return;
    }
    self.horizontalCons.constant =  [self dismissCons];
    [UIView animateWithDuration:self.configObj.animationOut animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!finished)return;
        [self removeSelfFromSuperview];
    }];
}
- (void)showKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {
    CGFloat offsetY;
    if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeAlwaysCenter) {
        offsetY = -keyboardHeight / 2;
    }else {
        offsetY = -keyboardHeight + (kSHeight - self.containerHeight) / 2 - self.configObj.bottomOffsetToKeyboard;
        CGFloat bottomToWindowSpace = kSHeight - [self firstResponderMaxYToWindow] ;
        if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypeFirstResponder) {
            if (bottomToWindowSpace >= keyboardHeight + self.configObj.bottomOffsetToKeyboard) {
                return;
            }else {
                CGFloat s = keyboardHeight - bottomToWindowSpace + self.configObj.bottomOffsetToKeyboard;
                offsetY = self.centerYOffsetValue  - s;
            }
        }else if (self.configObj.avoidKeyboardType == ZLAvoidKeyboardTypePopViewBottom) {
            CGFloat bottomToWindowSpace = kSHeight - [self popViewMaxYToWindow] ;
            if (bottomToWindowSpace > keyboardHeight + self.configObj.bottomOffsetToKeyboard) {
                return;
            }else {
                CGFloat s = keyboardHeight - bottomToWindowSpace + self.configObj.bottomOffsetToKeyboard;
                offsetY = self.centerYOffsetValue  - s;
            }
        }
    }
    self.viewCenterYCons.constant = offsetY;
    [UIView animateWithDuration:duration animations:^{
        [self.superview layoutIfNeeded];
    }];
}
- (void)hiddenKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {
    self.viewCenterYCons.constant = 0;
    [UIView animateWithDuration:duration animations:^{
        [self.superview layoutIfNeeded];
    }];
}
@end
@implementation ZLPopRightView
- (NSLayoutConstraint *)horizontalCons {
    return self.viewRightCons;
}
- (CGFloat)horizontalMarge {
    return self.configObj.marge.right;
}
- (CGFloat)dismissCons {
    UIView *view = self.containerView;
    return  CGRectGetWidth(view.frame) - self.horizontalMarge;
}
- (BOOL)panShouldDismiss:(CGFloat)translationX {
    CGFloat space = self.configObj.dragDismissDistance > 0 ? fabs(self.configObj.dragDismissDistance) : self.containerView.frame.size.width / 4;
    return translationX > space;
}
- (CGFloat)panCons:(CGFloat)translationX {
    return MAX(self.horizontalMarge + translationX, self.horizontalMarge) ;
}
@end
@implementation ZLPopLeftView

- (NSLayoutConstraint *)horizontalCons {
    return self.viewLeftCons;
}
- (CGFloat)horizontalMarge {
    return self.configObj.marge.left;
}
- (CGFloat)dismissCons {
    UIView *view = self.containerView;
    return -CGRectGetWidth(view.frame) - self.horizontalMarge;
}
- (BOOL)panShouldDismiss:(CGFloat)translationX {
    CGFloat space = self.configObj.dragDismissDistance > 0 ? fabs(self.configObj.dragDismissDistance) : self.containerView.frame.size.width / 4;
    return fabs(translationX) > space;
}
- (CGFloat)panCons:(CGFloat)translationX {
    return MIN(self.horizontalMarge + translationX, self.horizontalMarge) ;
}
@end

@interface ZLPopFloatView()
@property (nonatomic,assign)BOOL expand;
@property (nonatomic,assign)CGFloat floatHeight;
@property (nonatomic,assign)CGFloat originFloatOffsetY;
@end
@implementation ZLPopFloatView
- (void)show {
    if (self.pageState == ZLPopViewPageStateShowing || self.pageState == ZLPopViewPageStateDidShow) return;
    [super show];
}
- (ZLPopFloatView* (^)(CGFloat))setFloatHeight{
    return  ^ZLPopFloatView*(CGFloat floatHeight){
        self.floatHeight = floatHeight;
        return self;
    };
}
- (CGFloat)floatHeight {
    if (_floatHeight <= 0) {
        _floatHeight = self.containerHeight / 2;
    }
    return _floatHeight;
}
- (void)showExpand {
    if (!self.superview) {
        self.expand = YES;
        [self show];
        return;
    }
    self.viewBottomCons.constant = self.configObj.marge.bottom;
    [UIView animateWithDuration:self.configObj.animationIn animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self popViewShowExpand:self];
    }];
}
- (void)showTight {
    if (!self.superview) {
        self.expand = NO;
        [self show];
        return;
    }
    
    self.viewBottomCons.constant = self.containerHeight - self.floatHeight;
    [UIView animateWithDuration:self.configObj.animationIn animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self popViewShowTight:self];
    }];
}
@end
@implementation ZLPopBottomFloatView
- (void)show{
    if (self.pageState == ZLPopViewPageStateShowing || self.pageState == ZLPopViewPageStateDidShow) return;
    [super show];
    [self addPopViewMargeCons];
    [self.containerView layoutIfNeeded];
    CGFloat containerViewHeight = self.containerHeight;
    self.viewBottomCons = [self.containerView.kfc bottomToView:self offset:containerViewHeight - self.configObj.marge.bottom];
    [self layoutIfNeeded];
    if (self.configObj.animationIn > 0) {
        self.viewBottomCons.constant = self.expand ? self.configObj.marge.bottom : containerViewHeight - self.floatHeight;
        self.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:self.configObj.animationIn animations:^{
            self.backgroundColor = self.configObj.maskColor;
            [self layoutIfNeeded];
        }];
    }
    [self letViewBecomeFirstResponderIfNotNull];
    [self popViewDidShow:self];
    //支持拖拽dismiss
    if (self.configObj.addDragGestureRecognizer) {
        [self.buildView addGestureRecognizer:self.panGesture];
    }
    
}
- (void)dismiss {
    if (self.pageState == ZLPopViewPageStateDismissing || self.pageState == ZLPopViewPageStateDidDismissed) return;
    [self popViewWillHidden:self];
    if (self.configObj.animationOut <= 0) {
        [self.delegate popViewDidHidden:self];
        [self removeSelfFromSuperview];
        return;
    }
    self.viewBottomCons.constant = self.containerHeight;
    [super dismiss];
}

- (void)gm_pan:(UIPanGestureRecognizer *)gesture {
    [super gm_pan:gesture];
    if (self.keyboardIsShowing) {return;}
    CGPoint translation = [gesture translationInView:self.superview];
    CGPoint velocity = [gesture velocityInView:self.containerView];
    CGFloat offsetY = self.otherScrollView.contentOffset.y;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.originFloatOffsetY = self.viewBottomCons.constant;
        self.otherScrollViewBeganOffsetY = offsetY;
    }
    if (velocity.y > 0) {//向下
        if (offsetY <= 0) {
            self.otherScrollView.scrollEnabled = NO;
        }else {
            self.otherScrollView.scrollEnabled = YES;
            return;
        }
    }else {
        if (self.originFloatOffsetY == self.containerHeight - self.floatHeight) {
            self.otherScrollView.scrollEnabled = NO;
        }
        CGFloat maxOffsetY = self.otherScrollView.contentSize.height - self.otherScrollView.bounds.size.height;
        if (offsetY > maxOffsetY ) {
            return;
        } else {
            if (self.viewBottomCons.constant > self.configObj.marge.bottom) {
            }else {
                self.otherScrollView.scrollEnabled = YES;
                return;
            }
        }
    }
    self.viewBottomCons.constant =  MAX(self.originFloatOffsetY + translation.y - self.otherScrollViewBeganOffsetY, self.configObj.marge.bottom);
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.originFloatOffsetY == self.containerHeight - self.floatHeight &&
            translation.y > self.configObj.dragDismissDistance ) {
            self.configObj.enableDragDismiss ? [self dismiss] : [self showTight];
            return;
        }
        if (translation.y < -self.configObj.dragDismissDistance) {
            [self showExpand];
            self.otherScrollView.scrollEnabled = YES;
        }else if (translation.y > self.configObj.dragDismissDistance) {
            [self showTight];
        }else {
            if (self.originFloatOffsetY == self.containerHeight - self.floatHeight) {
                [self showTight];
            }else {
                [self showExpand];
            }
        }
    }
}
- (void)showKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {}
- (void)hiddenKeyboardEvent:(CGFloat)keyboardHeight duration:(CGFloat)duration {}
@end

@implementation ZLKeyboardEvent
+ (instancetype)share {
    static ZLKeyboardEvent *event;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        event = ZLKeyboardEvent.new;
        keyboardViews = [NSHashTable weakObjectsHashTable];
    });
    return event;
}
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSNotificationCenter.defaultCenter addObserver:[self share] selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:[self share] selector:@selector(hiddenKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    });
}
- (void)showKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyboardIsShowing = YES;
    self.keyboardHeight = keyboardHeight;
    self.animateDuration = animationDuration ;
    for (ZLPopBaseView *view in keyboardViews) {
        [view showKeyboard:notification];
    }
}
- (void)hiddenKeyboard:(NSNotification *)notification {
    self.keyboardIsShowing = NO;
    self.keyboardHeight = 0;
    self.animateDuration = 0;
    for (ZLPopBaseView *view in keyboardViews) {
        [view hiddenKeyboard:notification];
    }
}
@end

@interface ZLPopOverView()
@property (nonatomic,assign)ZLPopOverDirection d;
@property (nonatomic,assign)CGPoint p;
@property (nonatomic,assign)CGFloat aH;
@property (nonatomic,assign)CGFloat aW;
@property (nonatomic,weak)UIView *fV;
@property (nonatomic,assign)CGFloat s;
@property (nonatomic,assign)UIEdgeInsets safeAreaMarge;
@property (nonatomic,assign)CGPoint ap;

@end
@implementation ZLPopOverView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _aW = 8;
        _aH = 6;
        _safeAreaMarge = UIEdgeInsetsMake(50, 10, 20, 10);
        _s = 5;
    }
    return self;
}
- (void)setConfigObj:(ZLBuildConfigObj *)configObj {
    [super setConfigObj: configObj];
    self.containerView.shadowColor = UIColor.clearColor;
}
- (ZLPopOverView* (^)(CGPoint))setPoint {
    return  ^ZLPopOverView*(CGPoint p){
        self.p = p;
        return self;
    };
}
- (ZLPopOverView* (^)(ZLPopOverDirection))setDirection{
    return  ^ZLPopOverView*(ZLPopOverDirection d){
        self.d = d;
        return self;
    };
}
- (ZLPopOverView* (^)(CGFloat))setArrowWidth{
    return  ^ZLPopOverView*(CGFloat w){
        self.aW = w;
        return self;
    };
}
- (ZLPopOverView* (^)(CGFloat))setArrowHeight {
    return  ^ZLPopOverView*(CGFloat h){
        self.aH = h;
        return self;
    };
}
- (ZLPopOverView* (^)(UIView *))setFromView {
    return  ^ZLPopOverView*(UIView* v){
        self.fV = v;
        return self;
    };
}
- (ZLPopOverView* (^)(UIEdgeInsets ))setSafeAreaMarge {
    return  ^ZLPopOverView*(UIEdgeInsets m){
        self.safeAreaMarge = m;
        return self;
    };
}
- (ZLPopOverView* (^)(CGFloat ))setSpaceToPoint {
    return  ^ZLPopOverView*(CGFloat s){
        self.s = s;
        return self;
    };
}


- (void)show{
    if (self.pageState == ZLPopViewPageStateShowing || self.pageState == ZLPopViewPageStateDidShow) return;
    [super show];
    ZLBuildConfigObj *j = self.configObj;
    UIView *view = self.containerView;
    //如果分开写约束top 约束一定要写到bottom约束的前面，不然布局有问题
    [self addPopViewMargeCons];
    [self layoutIfNeeded];
    if (self.d == ZLPopOverDirectionAuto) self.d = [self directionWithAuto];
    CGFloat arrowOffset = 0;
    CGPoint center = [self centerPoint:&arrowOffset];
    [view.kfc centerInView:view.superview centerOffset:center];
    self.ap = [self layerAnchorPoint:arrowOffset];
    [view.superview layoutIfNeeded];
    [view addTrianglePopWithShadowColor:j.shadowColor
                           shadowOffset:j.shadowOffset
                           shadowRadius:j.shadowRadius
                          shadowOpacity:j.shadowOpacity
                            borderWidth:j.borderWidth
                            borderColor:j.borderColor
                              fillColor:j.backgroundColor ?: UIColor.whiteColor
                                        triangleWidth:self.aW
                                       triangleHeight:self.aH
                                        triangleColor:j.backgroundColor ?: UIColor.whiteColor
                                            direction:self.d
                                       triangleOffset:arrowOffset
                           cornerRadius:j.cornerRadius > 0 ? j.cornerRadius : 10
                         roundedCorners:j.corners];
    [view.layer setAnchorPointWithoutMoving:self.ap];
    if (j.animationIn > 0) {
        view.transform = CGAffineTransformMakeScale(0, 0);
        self.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:self.configObj.animationIn animations:^{
            view.transform = CGAffineTransformIdentity;
            self.backgroundColor = self.configObj.maskColor;
        } completion:^(BOOL finished) {
            [view.layer setAnchorPointWithoutMoving:CGPointMake(0.5, 0.5)];
        }];
    }
    self.containerView.contentView.backgroundColor = UIColor.clearColor;
    [self popViewDidShow:self];
    self.backgroundColor = self.configObj.maskColor;
    self.buildView.kfc.cornerRadius(j.cornerRadius);
}
- (void)dismiss {
    if (self.pageState == ZLPopViewPageStateDismissing || self.pageState == ZLPopViewPageStateDidDismissed) return;
    [self popViewWillHidden:self];
    if (self.configObj.animationOut <= 0) {
        [self removeSelfFromSuperview];
        return;
    }
    UIView *v = self.containerView;
    ZLBuildConfigObj *j = self.configObj;
    [v.layer setAnchorPointWithoutMoving:self.ap];
    [UIView animateWithDuration: j.animationOut animations:^{
        v.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.backgroundColor = UIColor.clearColor;
    } completion:^(BOOL finished) {
        [v.layer setAnchorPointWithoutMoving:CGPointMake(0.5, 0.5)];
        if (!finished)return;
        self.transform = CGAffineTransformIdentity;
        [self removeSelfFromSuperview];
    }];
}
- (CGPoint)layerAnchorPoint:(CGFloat)arrowOffset {
    CGPoint p =  CGPointZero;
    CGFloat w = CGRectGetWidth(self.containerView.frame);
    CGFloat h = self.containerHeight;
    NSString *c;
    CGFloat offset = _aH;
    arrowOffset += _aH/2;
    if (self.d == ZLPopOverDirectionUp) {
        c = kBT;
        p = CGPointMake(arrowOffset/w,0);
    }else if (self.d == ZLPopOverDirectionDown) {
        c = kBB;
        offset = -offset;
        p = CGPointMake(arrowOffset/w,1);
    }else if (self.d == ZLPopOverDirectionLeft) {
        c = kBL;
        p = CGPointMake(0,arrowOffset/h);
    }else if (self.d == ZLPopOverDirectionRight) {
        c = kBR;
        offset = -offset;
        p = CGPointMake(1,arrowOffset/h);
    }
    [self.buildView.superview.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:c]) {
            obj.constant += offset;
        }
    }];
    return p;
}
- (ZLPopOverDirection)directionWithAuto {
    UIView *view = self.containerView;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat rW = CGRectGetWidth(view.frame);
    CGFloat rH = CGRectGetHeight(view.frame);
    CGPoint p = self.p;
    ZLPopOverDirection d;
    CGRect outRect = view.superview.frame;
    outRect = CGRectMake(self.safeAreaMarge.left, self.safeAreaMarge.top, outRect.size.width - self.safeAreaMarge.left - self.safeAreaMarge.right, outRect.size.height - self.safeAreaMarge.top - self.safeAreaMarge.bottom);
    {
        d = ZLPopOverDirectionDown;
        x = p.x - rW / 2;
        y = p.y - (rH+_aH) - _s - self.safeAreaMarge.bottom;
        CGRect inRect = CGRectMake(x, y, rW, rH + _aH);
        if (CGRectContainsRect(outRect, inRect)) {
            return d;
        }
    }
    
    {
        d = ZLPopOverDirectionUp;
        x = p.x - rW / 2;
        y = p.y + rH + _aH + _s + self.safeAreaMarge.top;
        CGRect inRect = CGRectMake(x, y, rW, rH + _aH);
        if (CGRectContainsRect(outRect, inRect)) {
            return d;
        }
    }
    {
        d = ZLPopOverDirectionLeft;
        x = p.x + _s + self.safeAreaMarge.left;
        y = p.y - rH/2;
        CGRect inRect = CGRectMake(x, y, rW + _aH, rH);

        if (CGRectContainsRect(outRect, inRect)) {
            return d;
        }
    }
    {
        d = ZLPopOverDirectionRight;
        x = p.x - rW - _aH - _s - self.safeAreaMarge.right;
        y = p.y - rH/2;
        CGRect inRect = CGRectMake(x, y, rW + _aH, rH);

        if (CGRectContainsRect(outRect, inRect)) {
            return d;
        }
    }
    
    if (p.y - (rH + _aH)> CGRectGetHeight(outRect) / 2) {
        return ZLPopOverDirectionDown;
    }else {
        return ZLPopOverDirectionUp;
    }
}
- (CGPoint)p {
    if (self.fV) {
        UIView *fv = self.fV;
        CGFloat fW = fv.frame.size.width;
        CGFloat fH = fv.frame.size.height;
        ZLPopOverDirection d = self.d;
        CGPoint p = CGPointZero;
        if (d == ZLPopOverDirectionUp) {
            p = CGPointMake(fW/2, fH);
        }else if (d == ZLPopOverDirectionDown) {
            p = CGPointMake(fW/2, 0);
        }else if (d == ZLPopOverDirectionLeft) {
            p = CGPointMake(fW, fH/2);
        }else if (d == ZLPopOverDirectionRight) {
            p = CGPointMake(0, fH/2);
        }
        return [fv convertPoint:p toView:self.superview];
    }
    return _p;
}
- (CGPoint)centerPoint:(CGFloat *)arrowOffset {
    UIView *view = self.containerView;
    ZLPopOverDirection d = self.d;
    CGPoint p = self.p;
    CGFloat x = p.x;
    CGFloat y = p.y;
    CGFloat oX = 0;
    CGFloat oY = 0;
    CGFloat rW = view.frame.size.width;
    CGFloat rH = view.frame.size.height;
    CGFloat w = view.superview.frame.size.width ;
    CGFloat h = view.superview.frame.size.height ;
    CGFloat offset = 0;
    oX = x - w/2;
    oY = y - h/2;
    if (d == ZLPopOverDirectionUp || d == ZLPopOverDirectionDown) {
        if (x < rW/2 + _safeAreaMarge.left) {
            offset = x;
        }else if (x > w - rW/2 - _safeAreaMarge.right){
            offset = rW - w + x;
        }else{
            offset = rW / 2;
        }
        offset -= self.aW/2;
        oY = d == ZLPopOverDirectionUp ? oY + (rH + _aH)/2 : oY - (rH+_aH)/2;
    }else if (d == ZLPopOverDirectionLeft || d == ZLPopOverDirectionRight){
        if (y < rH/2 + _safeAreaMarge.top) {
            offset = y;
        }else if (y > h - rH/2 - _safeAreaMarge.bottom){
            offset = rH - h + y;
        }else{
            offset = rH / 2;
        }
        offset -= self.aH/2;
        oX = d == ZLPopOverDirectionLeft ? oX + (rW+_aH)/2 : oX - (rW+_aH)/2;
    }
    CGFloat s = _s;
    CGFloat marge = 0;
    if (d == ZLPopOverDirectionUp || d == ZLPopOverDirectionDown) {
        if (w - x < rW/2 + _safeAreaMarge.right) {
            marge = self.safeAreaMarge.right;
            *arrowOffset = offset + marge;
        }else if (x < rW / 2 + _safeAreaMarge.left) {
            marge = self.safeAreaMarge.left;
            *arrowOffset = offset  - marge;
        }else {
            *arrowOffset = offset;
        }
    }
    if (d == ZLPopOverDirectionLeft || d == ZLPopOverDirectionRight) {
        if (h - y < rH/2 + _safeAreaMarge.bottom) {
            marge = self.safeAreaMarge.bottom;
            *arrowOffset = offset + marge;
        }else if (y < rH / 2 + _safeAreaMarge.top) {
            marge = self.safeAreaMarge.top;
            *arrowOffset = offset  - marge;
        }else {
            marge = d == ZLPopOverDirectionLeft ? self.safeAreaMarge.right : self.safeAreaMarge.left;
            *arrowOffset = offset;
        }
    }
    if (d == ZLPopOverDirectionUp) {
        oY += s;
        oX = MAX((rW-w)/2 + marge, MIN(oX, (w-rW)/2 - marge));
        oY = MAX((rH+_aH-h)/2 + marge, MIN(oY, (h-rH+_aH)/2 - marge));
    }else if (d == ZLPopOverDirectionDown) {
        oY -= s;
        oX = MAX((rW-w)/2 + marge, MIN(oX, (w-rW)/2 - marge));
        oY = MAX((rH+_aH-h)/2 + marge, MIN(oY, (h-rH+_aH)/2 - marge));
    }else if (d == ZLPopOverDirectionLeft) {
        oX += s;
        oX = MAX((rW+_aH-w)/2 + marge, MIN(oX, (w-rW+_aH)/2 - marge));
        oY = MAX((rH-h)/2 + marge, MIN(oY, (h-rH)/2 - marge));
    }else if (d == ZLPopOverDirectionRight) {
        oX -= s;
        oX = MAX((rW+_aH-w)/2 + marge, MIN(oX, (w-rW+_aH)/2 - marge));
        oY = MAX((rH-h)/2 + marge, MIN(oY, (h-rH)/2 - marge));
    }
    return CGPointMake(oX ,oY);
}
@end


