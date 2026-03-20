//
//  ZLGeoFenceViewController.m
//  ZLPopView_Example
//
//  Created by admin on 2025/11/26.
//

#import "ZLGeoFenceViewController.h"

@interface ZLGeoFenceViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *mapContainerView;
@property (nonatomic, strong) UIView *mapOverlayView;
@property (nonatomic, strong) UIView *centerDotView;
@property (nonatomic, strong) UIButton *locateButton;
@property (nonatomic, strong) UIView *infoBarView;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) NSArray<CAShapeLayer *> *circleLayers;

@end

@implementation ZLGeoFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增围栏";
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupViews];
    [self setupConstraints];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateCircleLayers];
}

#pragma mark - Setup

- (void)setupViews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];

    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];

    self.mapContainerView = [[UIView alloc] init];
    self.mapContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapContainerView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.contentView addSubview:self.mapContainerView];

    UIImageView *mapImageView = [[UIImageView alloc] init];
    mapImageView.translatesAutoresizingMaskIntoConstraints = NO;
    mapImageView.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1.0];
    mapImageView.contentMode = UIViewContentModeScaleAspectFill;
    mapImageView.clipsToBounds = YES;
    [self.mapContainerView addSubview:mapImageView];

    self.mapOverlayView = [[UIView alloc] init];
    self.mapOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapOverlayView.backgroundColor = UIColor.clearColor;
    [self.mapContainerView addSubview:self.mapOverlayView];

    self.centerDotView = [[UIView alloc] init];
    self.centerDotView.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerDotView.backgroundColor = [UIColor colorWithRed:0.96 green:0.20 blue:0.20 alpha:1.0];
    self.centerDotView.layer.cornerRadius = 6;
    self.centerDotView.layer.borderColor = UIColor.whiteColor.CGColor;
    self.centerDotView.layer.borderWidth = 2.0;
    [self.mapContainerView addSubview:self.centerDotView];

    self.locateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.locateButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.locateButton.backgroundColor = [UIColor colorWithRed:0.96 green:0.20 blue:0.20 alpha:1.0];
    self.locateButton.layer.cornerRadius = 22;
    [self.locateButton setTitle:@"定位" forState:UIControlStateNormal];
    [self.locateButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.locateButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    [self.mapContainerView addSubview:self.locateButton];

    self.infoBarView = [[UIView alloc] init];
    self.infoBarView.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoBarView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    self.infoBarView.layer.cornerRadius = 16;
    [self.contentView addSubview:self.infoBarView];

    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoLabel.textColor = UIColor.whiteColor;
    self.infoLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.infoLabel.text = @"中心位置: 广东省深圳市南山区科兴科学园";
    [self.infoBarView addSubview:self.infoLabel];

    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor = UIColor.whiteColor;
    self.cardView.layer.cornerRadius = 16;
    self.cardView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.12].CGColor;
    self.cardView.layer.shadowOpacity = 1.0;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 6);
    self.cardView.layer.shadowRadius = 12;
    [self.contentView addSubview:self.cardView];

    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 14;
    [self.cardView addSubview:stackView];

    UILabel *tipLabel = [self sectionTipLabel:@"可拖拽中心设置位置"];
    [stackView addArrangedSubview:tipLabel];

    UILabel *nameTitle = [self sectionTitleLabel:@"围栏名称"]; 
    [stackView addArrangedSubview:nameTitle];

    UITextField *nameField = [[UITextField alloc] init];
    nameField.translatesAutoresizingMaskIntoConstraints = NO;
    nameField.placeholder = @"购物的围栏";
    nameField.borderStyle = UITextBorderStyleRoundedRect;
    [stackView addArrangedSubview:nameField];

    UILabel *radiusTitle = [self sectionTitleLabel:@"围栏半径 (m)"];
    [stackView addArrangedSubview:radiusTitle];
    [stackView addArrangedSubview:[self sliderRowWithMin:@"50" mid:@"100" max:@"200" tintColor:[UIColor colorWithRed:0.12 green:0.74 blue:0.42 alpha:1.0] minValue:50 maxValue:200 currentValue:100]];

    UILabel *warningTitle = [self sectionTitleLabel:@"预警距离 (m)"];
    [stackView addArrangedSubview:warningTitle];
    [stackView addArrangedSubview:[self sliderRowWithMin:@"0" mid:@"5" max:@"10" tintColor:[UIColor colorWithRed:0.98 green:0.55 blue:0.10 alpha:1.0] minValue:0 maxValue:10 currentValue:5]];

    UILabel *outTitle = [self sectionTitleLabel:@"越界距离 (m)"];
    [stackView addArrangedSubview:outTitle];
    [stackView addArrangedSubview:[self sliderRowWithMin:@"0" mid:@"10" max:@"20" tintColor:[UIColor colorWithRed:0.93 green:0.25 blue:0.33 alpha:1.0] minValue:0 maxValue:20 currentValue:0]];

    self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.doneButton.backgroundColor = [UIColor colorWithRed:0.93 green:0.25 blue:0.33 alpha:1.0];
    self.doneButton.layer.cornerRadius = 12;
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [stackView addArrangedSubview:self.doneButton];

    [NSLayoutConstraint activateConstraints:@[
        [mapImageView.topAnchor constraintEqualToAnchor:self.mapContainerView.topAnchor],
        [mapImageView.leadingAnchor constraintEqualToAnchor:self.mapContainerView.leadingAnchor],
        [mapImageView.trailingAnchor constraintEqualToAnchor:self.mapContainerView.trailingAnchor],
        [mapImageView.bottomAnchor constraintEqualToAnchor:self.mapContainerView.bottomAnchor],

        [self.mapOverlayView.topAnchor constraintEqualToAnchor:self.mapContainerView.topAnchor],
        [self.mapOverlayView.leadingAnchor constraintEqualToAnchor:self.mapContainerView.leadingAnchor],
        [self.mapOverlayView.trailingAnchor constraintEqualToAnchor:self.mapContainerView.trailingAnchor],
        [self.mapOverlayView.bottomAnchor constraintEqualToAnchor:self.mapContainerView.bottomAnchor],

        [self.centerDotView.centerXAnchor constraintEqualToAnchor:self.mapContainerView.centerXAnchor],
        [self.centerDotView.centerYAnchor constraintEqualToAnchor:self.mapContainerView.centerYAnchor],
        [self.centerDotView.widthAnchor constraintEqualToConstant:12],
        [self.centerDotView.heightAnchor constraintEqualToConstant:12],

        [self.locateButton.widthAnchor constraintEqualToConstant:44],
        [self.locateButton.heightAnchor constraintEqualToConstant:44],
        [self.locateButton.trailingAnchor constraintEqualToAnchor:self.mapContainerView.trailingAnchor constant:-16],
        [self.locateButton.bottomAnchor constraintEqualToAnchor:self.mapContainerView.bottomAnchor constant:-16],

        [self.infoLabel.leadingAnchor constraintEqualToAnchor:self.infoBarView.leadingAnchor constant:12],
        [self.infoLabel.trailingAnchor constraintEqualToAnchor:self.infoBarView.trailingAnchor constant:-12],
        [self.infoLabel.topAnchor constraintEqualToAnchor:self.infoBarView.topAnchor constant:8],
        [self.infoLabel.bottomAnchor constraintEqualToAnchor:self.infoBarView.bottomAnchor constant:-8],

        [stackView.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:16],
        [stackView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [stackView.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],
        [stackView.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-16],

        [self.doneButton.heightAnchor constraintEqualToConstant:48],
    ]];
}

- (void)setupConstraints {
    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor],

        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],

        [self.mapContainerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.mapContainerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.mapContainerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.mapContainerView.heightAnchor constraintEqualToConstant:300],

        [self.infoBarView.topAnchor constraintEqualToAnchor:self.mapContainerView.bottomAnchor constant:-20],
        [self.infoBarView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.infoBarView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],

        [self.cardView.topAnchor constraintEqualToAnchor:self.infoBarView.bottomAnchor constant:16],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20],
    ]];
}

#pragma mark - Helpers

- (UILabel *)sectionTipLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    label.text = text;
    return label;
}

- (UILabel *)sectionTitleLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    label.text = text;
    return label;
}

- (UIView *)sliderRowWithMin:(NSString *)min mid:(NSString *)mid max:(NSString *)max tintColor:(UIColor *)tintColor minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue currentValue:(CGFloat)currentValue {
    UIStackView *container = [[UIStackView alloc] init];
    container.axis = UILayoutConstraintAxisVertical;
    container.spacing = 6;

    UISlider *slider = [[UISlider alloc] init];
    slider.minimumValue = minValue;
    slider.maximumValue = maxValue;
    slider.value = currentValue;
    slider.minimumTrackTintColor = tintColor;
    slider.maximumTrackTintColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    slider.thumbTintColor = tintColor;
    [container addArrangedSubview:slider];

    UIStackView *labels = [[UIStackView alloc] init];
    labels.axis = UILayoutConstraintAxisHorizontal;
    labels.distribution = UIStackViewDistributionEqualSpacing;

    UILabel *minLabel = [self sliderValueLabel:min];
    UILabel *midLabel = [self sliderValueLabel:mid];
    UILabel *maxLabel = [self sliderValueLabel:max];
    [labels addArrangedSubview:minLabel];
    [labels addArrangedSubview:midLabel];
    [labels addArrangedSubview:maxLabel];

    [container addArrangedSubview:labels];
    return container;
}

- (UILabel *)sliderValueLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    return label;
}

- (void)updateCircleLayers {
    if (CGRectIsEmpty(self.mapOverlayView.bounds)) {
        return;
    }

    if (self.circleLayers.count == 0) {
        CAShapeLayer *greenLayer = [self circleLayerWithColor:[UIColor colorWithRed:0.12 green:0.74 blue:0.42 alpha:1.0]];
        CAShapeLayer *orangeLayer = [self circleLayerWithColor:[UIColor colorWithRed:0.98 green:0.55 blue:0.10 alpha:1.0]];
        CAShapeLayer *blueLayer = [self circleLayerWithColor:[UIColor colorWithRed:0.25 green:0.57 blue:0.95 alpha:1.0]];
        CAShapeLayer *redLayer = [self circleLayerWithColor:[UIColor colorWithRed:0.93 green:0.25 blue:0.33 alpha:1.0]];
        self.circleLayers = @[greenLayer, orangeLayer, blueLayer, redLayer];
        for (CAShapeLayer *layer in self.circleLayers) {
            [self.mapOverlayView.layer addSublayer:layer];
        }
    }

    CGFloat minSide = MIN(self.mapOverlayView.bounds.size.width, self.mapOverlayView.bounds.size.height);
    CGFloat baseRadius = minSide * 0.18;
    CGFloat gap = minSide * 0.08;
    CGPoint center = CGPointMake(CGRectGetMidX(self.mapOverlayView.bounds), CGRectGetMidY(self.mapOverlayView.bounds));

    for (NSInteger index = 0; index < self.circleLayers.count; index++) {
        CGFloat radius = baseRadius + gap * index;
        CGRect rect = CGRectMake(center.x - radius, center.y - radius, radius * 2.0, radius * 2.0);
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        self.circleLayers[index].path = path.CGPath;
    }
}

- (CAShapeLayer *)circleLayerWithColor:(UIColor *)color {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = color.CGColor;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.lineWidth = 2.0;
    return layer;
}

@end
