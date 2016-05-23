/**
 * @file    MPPopupView.m
 * @brief   the view for bidder designer.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPPopupDesignerView.h"

#define SCALE (SCREEN_WIDTH/375.0)

@interface MPPopupDesignerView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation MPPopupDesignerView

+ (MPPopupDesignerView *)shareManager {
    
    return [[self alloc] init];
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static MPPopupDesignerView *manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [super allocWithZone:zone];
    });
    
    return manager;
}

- (UIView *)createBackgroundView:(UIView *)view {
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(removeBackgroundView)]];
    [view addSubview:self.bgView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self.bgView addSubview:bgView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(bgView.center.x - 163 * SCALE, bgView.center.y - 145 * SCALE, 325 * SCALE, 300.0f)];
    [self.bgView addSubview:whiteView];
    return whiteView;
}

+ (void)showBidderDesignerInfoAddTo:(UIView *)view
                              model:(MPDecorationBidderModel *)model
                          needModel:(MPDecorationNeedModel *)needModel
                              index:(NSInteger)index
                           delegate:(id)delegate
                           animated:(BOOL)animated {
    
    UIView *whiteView = [[self shareManager] createBackgroundView:view];
    
    MPBidderDesignerInfoView *designerInfoView = [[[NSBundle mainBundle]
                                                   loadNibNamed:@"MPBidderDesignerInfoView"
                                                   owner:self
                                                   options:nil] lastObject];
    
    designerInfoView.frame = CGRectMake(0, 0, CGRectGetWidth(whiteView.frame), CGRectGetHeight(whiteView.frame));
    designerInfoView.delegate = delegate;
    [designerInfoView updateViewWithModel:model
                                    index:index
                                needModel:needModel];
    [whiteView addSubview:designerInfoView];
}

+ (void)hideAllViewAnimated:(BOOL)animated {
    [[self shareManager] removeBackgroundView];
}

- (void)removeBackgroundView {
    [self.bgView removeFromSuperview];
}


@end
