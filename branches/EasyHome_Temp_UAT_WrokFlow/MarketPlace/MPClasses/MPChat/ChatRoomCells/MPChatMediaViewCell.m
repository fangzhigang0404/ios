//
//  CustomTableViewCell.m
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatViewCell.h"
#import "MPChatMediaViewCell.h"
#import "MPChatMessage.h"
#import "MPDateUtility.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageOperation.h"
#import "MPChatHttpManager.h"

#define TriangleWidth       20
#define TriangleHeight      15
#define TopGap              10
#define SideGap             10
#define LandScapeGap        20
#define CornerRadius        10
#define TimeSideGap         5


@interface MPChatMediaViewCell () <CustomImageViewDelegate>
{
    __weak IBOutlet CustomImageView*            _imageView;
    __weak IBOutlet UILabel*                    _unreadMessageCount;
    __weak IBOutlet UIActivityIndicatorView*    _indicatorView;

    __strong id <SDWebImageOperation>   _imageDownloadOperation;

    __weak IBOutlet NSLayoutConstraint*         _unreadMessageCountLeftConstraint;
    __weak IBOutlet NSLayoutConstraint*         _unreadMessageCountRightConstraint;
}

@end


@interface CustomImageView ()
{
    __strong UIImage*       _image;
    __strong NSString*      _time;
    NSUInteger              _unreadMessageCount;
}

@property (nonatomic) BOOL                  isLeft;
@property (nonatomic) NSUInteger            unreadMessageCount;
@property (nonatomic, strong) NSString*     time;
@property (nonatomic, strong) UIImage*      image;

@end


@implementation CustomImageView
{
    UIButton*   _imageBtn;
}

- (void)awakeFromNib
{
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imageBtn addTarget:self action:@selector(imaegButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_imageBtn];
}

- (void)imaegButtonAction
{

    if ([self.delegate respondsToSelector:@selector(didClickImage)] ) {
        [self.delegate didClickImage];
    }
}


- (void) setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}


- (UIImage *) image
{
    return _image;
}


- (void) setTime:(NSString *)time
{
    _time = time;
    [self setNeedsDisplay];
}


- (NSString *) time
{
    return _time;
}


- (void) setUnreadMessageCount:(NSUInteger)unreadMessageCount
{
    _unreadMessageCount = unreadMessageCount;
    [self setNeedsDisplay];
}


- (NSUInteger) unreadMessageCount
{
    return _unreadMessageCount;
}


- (void) drawRect:(CGRect)rect
{
    CGRect outerRect = CGRectZero;
    outerRect = CGRectMake(SideGap, TopGap, rect.size.width - 2 * SideGap, rect.size.height - TopGap);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_image)
    {
        outerRect = [CustomImageView getRectForImage:_image inRect:outerRect inLeft:self.isLeft];
        [self drawTriangleInContext:context imageRect:outerRect];
    }
    [self drawUnreadMessageCountInContext:context imageRect:outerRect];
    [self drawTimeInContext:context imageRect:outerRect];
}


- (CGSize) drawTimeInContext:(CGContextRef)context  imageRect:(CGRect)imageRect
{
    if (_time.length > 0)
    {
        UIFont* font = [UIFont systemFontOfSize:17];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{ NSFontAttributeName: font,
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSParagraphStyleAttributeName: paragraphStyle };
        const CGSize textSize = [_time sizeWithAttributes: attributes];
        CGFloat width = textSize.width + 10;
        
        CGRect circleRect = CGRectMake(imageRect.origin.x + imageRect.size.width - width - TimeSideGap, imageRect.origin.y + imageRect.size.height - textSize.height - TimeSideGap, width, textSize.height + 2);
        if (self.isLeft)
            circleRect = CGRectMake(imageRect.origin.x + TimeSideGap, imageRect.origin.y + imageRect.size.height - textSize.height - TimeSideGap, width, textSize.height + 2);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [_time drawInRect:circleRect withAttributes:attributes];
        CGContextRestoreGState(context);
        return textSize;
    }
    
    return CGSizeZero;
}



- (CGSize) drawUnreadMessageCountInContext:(CGContextRef)context  imageRect:(CGRect)imageRect
{
    if (_unreadMessageCount > 0)
    {
        NSString* unreadMessageCountText = [NSString stringWithFormat:@"%ld%@", _unreadMessageCount > 99 ? 99 : (long)_unreadMessageCount,  _unreadMessageCount > 99 ? @"+" : @""];

        UIFont* font = [UIFont systemFontOfSize:17];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{ NSFontAttributeName: font,
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSParagraphStyleAttributeName: paragraphStyle };
        const CGSize textSize = [unreadMessageCountText sizeWithAttributes: attributes];
        CGFloat width = ((textSize.width > textSize.height) ? textSize.width : textSize.height);
        
        CGRect circleRect = CGRectMake(imageRect.origin.x + imageRect.size.width - width + SideGap, imageRect.origin.y - SideGap, width, width);
        if (self.isLeft)
            circleRect = CGRectMake(imageRect.origin.x - SideGap, imageRect.origin.y - SideGap, width, width);

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0].CGColor);
        CGContextFillEllipseInRect(context, circleRect);
        [unreadMessageCountText drawInRect:circleRect withAttributes:attributes];
        CGContextRestoreGState(context);
        return textSize;
    }
    
    return CGSizeZero;
}


- (void) drawTriangleInContext:(CGContextRef)context imageRect:(CGRect)imageRect
{
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0.33 blue:1.0 alpha:1.0].CGColor);
    CGContextBeginPath (context);
    
    if (self.isLeft)
    {
        CGPoint pt = CGPointMake(imageRect.origin.x + imageRect.size.width, imageRect.origin.y);
        CGContextMoveToPoint(context, pt.x, pt.y);
        
        pt = CGPointMake(imageRect.origin.x + imageRect.size.width - TriangleWidth, imageRect.origin.y + TriangleHeight);
        CGContextAddLineToPoint(context, pt.x, pt.y);

        pt = CGPointMake(imageRect.origin.x + imageRect.size.width - TriangleWidth, imageRect.origin.y + imageRect.size.height);
        CGContextAddArcToPoint(context, pt.x, pt.y, pt.x - CornerRadius, pt.y, CornerRadius);

        pt = CGPointMake(imageRect.origin.x, imageRect.origin.y + imageRect.size.height);
        CGContextAddArcToPoint(context, pt.x, pt.y, pt.x, pt.y - CornerRadius, CornerRadius);
        
        pt = CGPointMake(imageRect.origin.x, imageRect.origin.y);
        CGContextAddArcToPoint(context, pt.x, pt.y, pt.x + CornerRadius, pt.y, CornerRadius);
    }
    else
    {
        CGPoint pt = CGPointMake(imageRect.origin.x, imageRect.origin.y);
        CGContextMoveToPoint(context, pt.x, pt.y);
        
        pt = CGPointMake(imageRect.origin.x + TriangleWidth, imageRect.origin.y + TriangleHeight);
        CGContextAddLineToPoint(context, pt.x, pt.y);
        
        pt = CGPointMake(imageRect.origin.x + TriangleWidth, imageRect.origin.y + imageRect.size.height);
        CGContextAddArcToPoint(context, pt.x, pt.y, pt.x + CornerRadius, pt.y, CornerRadius);
        
        pt = CGPointMake(imageRect.origin.x + imageRect.size.width, imageRect.origin.y + imageRect.size.height);
        CGContextAddArcToPoint(context, pt.x, pt.y, pt.x, pt.y - CornerRadius, CornerRadius);
        
        pt = CGPointMake(imageRect.origin.x + imageRect.size.width, imageRect.origin.y);
        CGContextAddArcToPoint(context, pt.x, pt.y, pt.x - CornerRadius, pt.y, CornerRadius);
    }
    
    CGContextClosePath (context);
    CGContextClip (context);
    
    [self.image drawInRect:imageRect];
    
    CGContextRestoreGState(context);
    
    _imageBtn.frame = imageRect;
}


+ (CGRect) getRectForImage:(UIImage*)image inRect:(CGRect)rect inLeft:(BOOL)isLeft
{
    CGSize imageSize = image.size;
    if (imageSize.width > imageSize.height)
    {
        rect.origin.x += (isLeft) ? LandScapeGap : 0;
        rect.size.width = rect.size.width - LandScapeGap;
    }
    
    CGRect outerRect = rect;
    outerRect.size.width = imageSize.width * (outerRect.size.height / imageSize.height);
    if (outerRect.size.width > rect.size.width)
    {
        outerRect = rect;
        outerRect.size.height = imageSize.height * (outerRect.size.width / imageSize.width);
    }
    
    if (isLeft)
        outerRect.origin.x = rect.origin.x + rect.size.width - outerRect.size.width;

    return outerRect;
}


@end


@implementation MPChatMediaViewCell


- (void)awakeFromNib
{
    _unreadMessageCount.hidden = YES;
    
//    [self addTapOnImage];
}


- (void) didClickImage
{
    [self.delegate onCellChildUIActionForIndex:_index];
}

- (void) addTapOnImage
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [_imageView addGestureRecognizer:tap];
}

- (void) imageTapped:(UITapGestureRecognizer*)tapG
{
    [self.delegate onCellChildUIActionForIndex:_index];
}


- (void) loadUnreadMessageCount
{
    
    MPChatMessage* msg = [self.delegate getCellModelForIndex:_index];
    
    [[MPChatHttpManager sharedInstance] retrieveFileUnreadMessageCount:[msg.media_file_id stringValue] forMember:[self.delegate getLoggedInMemberId] success:^(NSInteger count, NSString*fileId)
    {
//        MPChatMessage* msg = [self.delegate getCellModelForIndex:_index];
        if ([fileId isEqualToString:[msg.media_file_id stringValue]])
        {
            if (count > 0)
            {
                _imageView.unreadMessageCount = count;
            }
            else
            {
                _imageView.unreadMessageCount = 0;
            }
        }
        
        
      
    } failure:^(NSError *error)
    {
       
        
        
        
    }];
    
   
}


- (void)applyRoundCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = _imageView.bounds;
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
}


- (void) updateCellForIndex:(NSUInteger) index
{
    [super updateCellForIndex:index];
    
    _imageView.delegate  = self;
    
     [self loadUnreadMessageCount];
    
    _imageView.isLeft = ![self.delegate isCellIsNotForCurrentLoggedInUser:_index];

    _imageView.image = nil;
    _imageView.hidden = YES;
    _imageView.unreadMessageCount = 0;

    MPChatMessage* msg = [self.delegate getCellModelForIndex:index];
    
    NSDate* sendDate = [MPChatHttpManager acsDateToNSDate:msg.sent_time];
    NSString* timeString = [MPDateUtility formattedTimeFromDateForMessageCell:sendDate];
    _imageView.time = timeString;

    NSString* imageURLString = [NSString stringWithFormat:@"%@Medium.jpg", msg.body];
    
    if (_imageDownloadOperation)
        [_imageDownloadOperation cancel];

    _indicatorView.hidden = NO;
    [_indicatorView startAnimating];
   
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    _imageDownloadOperation = [manager downloadImageWithURL:[NSURL URLWithString:imageURLString]
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
//         NSLog(@"the Rect of Media Cell::%@", NSStringFromCGRect(self.frame));
         MPChatMessage* msg = [self.delegate getCellModelForIndex:_index];
         NSString* urlString = [NSString stringWithFormat:@"%@Medium.jpg", msg.body];
         if ([[imageURL absoluteString] isEqualToString:urlString])
         {
             _imageView.hidden = NO;
             _imageView.image = image;
             _imageDownloadOperation = nil;

             _indicatorView.hidden = YES;
             [_indicatorView stopAnimating];
             
             CGRect outerRect = [CustomImageView getRectForImage:image inRect:_imageView.bounds inLeft:_imageView.isLeft];

             if ([self.delegate isCellIsNotForCurrentLoggedInUser:_index])
                 _unreadMessageCountRightConstraint.constant = 11 - (_imageView.frame.size.width - outerRect.size.width);
                          
             [self updateConstraintsIfNeeded];

         }
     }];
}

@end
