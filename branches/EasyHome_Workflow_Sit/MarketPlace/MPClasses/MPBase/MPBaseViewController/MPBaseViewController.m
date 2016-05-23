//
//  MPBaseViewController.m
//  MarketPlace
//
//  Created by xuezy on 15/12/16.
//  Copyright © 2015年 xuezy. All rights reserved.
//

#import "MPBaseViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface MPBaseViewController () <UIGestureRecognizerDelegate,UINavigationControllerDelegate>
{
    UILabel*    _countBubble;
}

@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlay;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;

@end

@implementation MPBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}

- (void)viewDidLoad {
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    self.navigationController.navigationBar.hidden = YES;
    self.navgationImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    //self.navgationImageview.backgroundColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1];
    
    self.navgationImageview.backgroundColor = [UIColor colorWithRed:0.976
                                                              green:0.976
                                                               blue:0.976
                                                              alpha:1];
    self.navgationImageview.userInteractionEnabled = YES;
    [self.view addSubview:self.navgationImageview];
    [self.view bringSubviewToFront:self.navgationImageview];

    self.menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, SCREEN_WIDTH-100, 24)];
    self.menuLabel.textColor = [UIColor blueColor];
    self.menuLabel.font = [UIFont systemFontOfSize:14.0];
    [self.navgationImageview addSubview:self.menuLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 25,SCREEN_WIDTH-200 , 34)];
    //self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = ColorFromRGA(0x333333, 1);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navgationImageview addSubview:self.titleLabel];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0,20,60, 44);
    self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
    [self.leftButton setImage:[UIImage imageNamed:BUTTON_BACK]
                               forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(tapOnLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationImageview addSubview:self.leftButton];
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 50, 44);
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.rightButton setImage:[UIImage imageNamed:@"newsearch"] forState:UIControlStateNormal];
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(2, 1, 1, 1);
    [self.rightButton addTarget:self action:@selector(tapOnRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton setTitleColor:ColorFromRGA(0x0084ff, 1)
                            forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithRed:0.395 green:0.395 blue:0.395 alpha:1]
                            forState:UIControlStateDisabled];
    
    [self.navgationImageview addSubview:self.rightButton];
    
    self.supplementaryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.supplementaryButton.frame = CGRectMake(SCREEN_WIDTH - 105, 20, 50, 44);
    [self.supplementaryButton setImage:[UIImage imageNamed:@"projectmaterial"]
                      forState:UIControlStateNormal];
    [self.supplementaryButton addTarget:self action:@selector(tapOnSupplementaryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationImageview addSubview:self.supplementaryButton];
    self.supplementaryButton.hidden = YES;
    
    UIView *borderView = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT -1,SCREEN_WIDTH, 1)];
    borderView.backgroundColor = [UIColor colorWithRed:0.843
                                                 green:0.843
                                                  blue:0.843
                                                 alpha:1];
    borderView.tag = 159;
    [self.navgationImageview addSubview:borderView];
}


/// According to the side view.
- (void)tapOnLeftButton:(id)sender
{
    [self.frostedViewController presentMenuViewController];
}


- (void)tapOnRightButton:(id)sender
{
    NSLog(@"search click");
}


- (void)tapOnSupplementaryButton:(id)sender
{
    NSLog(@"supplementary click");
}


- (void) updateBubbleWithUnreadCount:(NSUInteger)count
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17];
    if (!_countBubble)
    {
        _countBubble = [[UILabel alloc] initWithFrame:CGRectMake(self.rightButton.frame.size.width - 21, 0, 21, 21)];
        _countBubble.textColor = [UIColor whiteColor];
        _countBubble.backgroundColor = [UIColor redColor];
        _countBubble.clipsToBounds = YES;
        _countBubble.textAlignment = NSTextAlignmentCenter;
        _countBubble.font = font;
        [self.rightButton addSubview:_countBubble];
    }
    
    _countBubble.hidden = YES;

    NSString* text = [NSString stringWithFormat:@"%lu%@", (unsigned long)((count > 99) ? 99 : count), (count > 99) ? @"+" : @""];

    NSDictionary *userAttributes = @{NSFontAttributeName: font};
    const CGSize textSize = [text sizeWithAttributes: userAttributes];
    
    CGFloat width = (textSize.width > textSize.height) ? textSize.width : textSize.height;
    width = (count > 99) ? width + 10 : width;
    CGFloat height = (count > 99) ? textSize.height: width;
    
    _countBubble.frame = CGRectMake(self.rightButton.frame.size.width - width - 2, 0, width, height);
    
    _countBubble.text = text;
    _countBubble.layer.cornerRadius = _countBubble.frame.size.height / 2;

    if (count > 0)
        _countBubble.hidden = NO;
}


- (void)followScrollView:(UIView*)scrollableView {
    self.scrollableView = scrollableView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    
    [self.panGesture setDelegate:self];
    [self.scrollableView addGestureRecognizer:self.panGesture];
    
    /// The navbar fadeout is achieved using an overlay view with the same barTintColor.
    /// this might be improved by adjusting the alpha component of every navbar child.
    CGRect frame = self.navgationImageview.frame;
    frame.origin = CGPointZero;
    self.overlay = [[UIView alloc] initWithFrame:frame];
    if (!self.navgationImageview.backgroundColor) {
        NSLog(@"[%s]: %@", __func__, @"Warning: no bar tint color set");
    }
    [self.overlay setBackgroundColor:self.navgationImageview.backgroundColor];
    [self.overlay setUserInteractionEnabled:NO];
    [self.navgationImageview addSubview:self.overlay];
    [self.overlay setAlpha:0];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    
    CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    
    float delta = self.lastContentOffset - translation.y;
    self.lastContentOffset = translation.y;
    
    CGRect frame;
    
    if (delta > 0) {
        if (self.isCollapsed) {
            return;
        }
        
        frame = self.navgationImageview.frame;
        
        if (frame.origin.y - delta < -NAVBAR_HEIGHT) {
            delta = frame.origin.y + NAVBAR_HEIGHT;
        }
        
        frame.origin.y = MAX(-NAVBAR_HEIGHT, frame.origin.y - delta);
        self.navgationImageview.frame = frame;
        
        if (frame.origin.y == -NAVBAR_HEIGHT) {
            self.isCollapsed = YES;
            self.isExpanded = NO;
        }
        
        [self updateSizingWithDelta:delta];
        
        /// Keeps the view's scroll position steady until the navbar is gone.
        if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.scrollableView setContentOffset:CGPointMake(((UIScrollView*)self.scrollableView).contentOffset.x, ((UIScrollView*)self.scrollableView).contentOffset.y - delta)];
        }
    }
    
    if (delta < 0) {
        
        if (self.isExpanded) {
            
            return;
        }
        
        frame = self.navgationImageview.frame;
        
        if (frame.origin.y - delta > 0) {
            delta = frame.origin.y ;
        }
        frame.origin.y = MIN(0, frame.origin.y - delta);
        self.navgationImageview.frame = frame;
        
        if (frame.origin.y == 0) {
            self.isExpanded = YES;
            self.isCollapsed = NO;
        }
        
        [self updateSizingWithDelta:delta];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        
        /// Reset the nav bar if the scroll is partial.
        self.lastContentOffset = 0;
        [self checkForPartialScroll];
    }
}

- (void)checkForPartialScroll {
    
    CGFloat pos = self.navgationImageview.frame.origin.y;
    
    
    if (pos >= -20) { // Get back down
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame;
            frame = self.navgationImageview.frame;
            CGFloat delta = frame.origin.y -0;
            frame.origin.y = MIN(0, frame.origin.y - delta);
            self.navgationImageview.frame = frame;
            
            self.isExpanded = YES;
            self.isCollapsed = NO;
            
            [self updateSizingWithDelta:delta];
            
            /// This line needs tweaking.
            // [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - delta) animated:YES];
        }];
    } else {
        
        [UIView animateWithDuration:0.2 animations:^{ // And back up
            CGRect frame;
            frame = self.navgationImageview.frame;
            CGFloat delta = frame.origin.y + NAVBAR_HEIGHT;
            frame.origin.y = MAX(-NAVBAR_HEIGHT, frame.origin.y - delta);
            self.navgationImageview.frame = frame;
            
            self.isExpanded = NO;
            self.isCollapsed = YES;
            
            [self updateSizingWithDelta:delta];
        }];
    }
}

- (void)updateSizingWithDelta:(CGFloat)delta {
    
    CGRect frame = self.navgationImageview.frame;
    
    float alpha = (frame.origin.y + NAVBAR_HEIGHT) / frame.size.height;
    [self.overlay setAlpha:1 - alpha];
    self.navgationImageview.backgroundColor = [self.navgationImageview.backgroundColor colorWithAlphaComponent:alpha];
    
//    frame = self.scrollableView.superview.frame;
//    frame.origin.y = self.navgationImageview.frame.origin.y;
//    frame.size.height = frame.size.height + delta;
//    self.scrollableView.superview.frame = frame;
//    
//    /// Changing the layer's frame avoids UIWebView's glitchiness.
//    frame = self.scrollableView.layer.frame;
//    frame.size.height += delta;
//    self.scrollableView.layer.frame = frame;
}

- (void)endRefreshView:(BOOL)isLoadMore {
    if (!isLoadMore) {
        if (self.refreshForLoadNew)
            self.refreshForLoadNew();
    } else {
        if (self.refreshForLoadMore)
            self.refreshForLoadMore();
    }
}

- (void)customPushViewController:(UIViewController *)controller animated:(BOOL)animated {
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:animated];
}

- (NSString *)stringTypeChineseToEnglishWithString:(NSString *)string {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MPSearchEnglish" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *stringEnglish = [NSString stringWithFormat:@"%@",dictionary[string]];
    return stringEnglish;
    
}
@end
