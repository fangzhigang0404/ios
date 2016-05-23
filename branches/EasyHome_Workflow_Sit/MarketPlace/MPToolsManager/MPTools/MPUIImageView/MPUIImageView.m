/**
 * @file    MPUIImageView.m
 * @brief   the Custom View of HeadImage.
 * @author  Jiao
 * @version 1.0
 * @date    2015-12-30
 *
 */

#import "MPUIImageView.h"

@interface MPUIImageView()

/// the contentLayer of view.
@property (strong , nonatomic) CALayer *contentLayer;

/// the maskLayer of view.
@property (strong , nonatomic)  CAShapeLayer *maskLayer;

/// the borderLayer of view.
@property (strong , nonatomic) CAShapeLayer *borderLayer;

@end

@implementation MPUIImageView
{
    CGFloat _radius;                //!< _radius the radius of view.
    CGFloat _borderWidth;           //!< _borderWidth the border width of view.
    UIColor *_color;                //!< _color the color of view border.
}

- (instancetype)initWithRadius:(CGFloat)radius withBoderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color {
    self = [super init];
    if (self) {
        _radius = radius;
        _borderWidth = borderWidth;
        if (color == nil) {
            _color = [UIColor clearColor];
        }else {
            CGColorRef cgColor = color.CGColor;
            _color = [[UIColor alloc]initWithCGColor:cgColor];
        }

        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.contentLayer.shouldRasterize = YES;
        self.contentLayer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withRadius:(CGFloat)radius withBoderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        _radius = radius;
        _borderWidth = borderWidth;
        if (color == nil) {
            _color = [UIColor clearColor];
        }else {
            CGColorRef cgColor = color.CGColor;
            _color = [[UIColor alloc]initWithCGColor:cgColor];
        }
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.contentLayer.shouldRasterize = YES;
        self.contentLayer.rasterizationScale = [UIScreen mainScreen].scale;
//        [self setup];
    }
    return self;
}

#pragma mark - Lazy Loading
- (CALayer *)contentLayer {
    if (_contentLayer == nil) {
        _contentLayer = [CALayer layer];
    }
    return _contentLayer;
}

- (CAShapeLayer *)maskLayer {
    if (_maskLayer == nil) {
        _maskLayer = [CAShapeLayer layer];
    }
    return _maskLayer;
}

- (CAShapeLayer *)borderLayer {
    if (_borderLayer == nil) {
        _borderLayer = [CAShapeLayer layer];
    }
    return _borderLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setup];
}

#pragma mark - Custom Method
- (void)setup {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat rate = CGRectGetWidth(self.bounds)/100;
    
    CGPathMoveToPoint(path, NULL, (50-25*sqrt(3)/2)*rate,rate*25/2);
    CGPathAddArcToPoint(path, NULL, (50 - 25*sqrt(3))*rate, 25*rate ,  (50 - 25* sqrt(3))*rate, 75*rate,_radius);
    CGPathAddArcToPoint(path, NULL,(50 - 25* sqrt(3))*rate, 75*rate, 50*rate,100*rate, _radius);
    CGPathAddArcToPoint(path, NULL,  50*rate,100*rate,    (50 + 25* sqrt(3))*rate,75*rate, _radius);
    CGPathAddArcToPoint(path, NULL,(50 + 25* sqrt(3))*rate, 75*rate,  (50 + 25*sqrt(3))*rate, 25*rate , _radius);
    CGPathAddArcToPoint(path, NULL, (50 + 25*sqrt(3))*rate, 25*rate,   50*rate,0, _radius);
    CGPathAddArcToPoint(path, NULL, 50*rate,0,(50 - 25*sqrt(3))*rate, 25*rate , _radius);
    CGPathAddLineToPoint(path, NULL, (50-25*sqrt(3)/2)*rate,rate*25/2);

    [self.maskLayer setPath:path];
    
    self.contentLayer.mask = self.maskLayer;
    self.contentLayer.frame = self.bounds;
    
    if (_borderWidth >0) {
        self.borderLayer.path = path;
        self.borderLayer.fillColor = [UIColor clearColor].CGColor;
        self.borderLayer.strokeColor = _color.CGColor;
        self.borderLayer.lineWidth = _borderWidth;
        self.borderLayer.frame = self.bounds;
    }
    
    [self.layer addSublayer:self.contentLayer];
    [self.layer addSublayer:self.borderLayer];

    CGPathCloseSubpath(path);
    CFRelease(path);
}

#pragma mark - Override
- (void)setImage:(UIImage *)image {
    self.contentLayer.contents = (id)image.CGImage;
}
@end
