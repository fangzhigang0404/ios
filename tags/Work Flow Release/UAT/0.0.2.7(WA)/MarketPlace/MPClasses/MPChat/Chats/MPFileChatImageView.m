//
//  MPFileChatImageView.m
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/10/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPFileChatImageView.h"
#import "MPUIUtility.h"

#define LOCATION_MARK_SIZE 42

@interface MPFileChatImageView()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, assign) id<MPFileChatImageViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *locationPoints;
@property (nonatomic, strong) UIImage *currentDisplayImage;

@end

@implementation MPFileChatImageView

@synthesize locationPoints = _locationPoints;

-(id)locationPoints
{
    if (!_locationPoints)
        _locationPoints = [NSMutableArray array];
    
    return _locationPoints;
}

-(id) initWithFrame:(CGRect)frame
          withImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGRect scrollViewFrame = frame;
        scrollViewFrame.origin = CGPointZero;
        
        [self setupScrollView:scrollViewFrame
              shouldAllowZoom:YES];
        [self loadMainImage:image];
    }
    
    return self;
}


-(id) initWithFrame:(CGRect)frame
          withImage:(UIImage *)image
           delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGRect scrollViewFrame = frame;
        scrollViewFrame.origin = CGPointZero;
        [self setupScrollView:scrollViewFrame
              shouldAllowZoom:YES];
        [self loadMainImage:image];
        self.delegate = delegate;
    }
    
    return self;
}


-(void) showLocationAtPoint:(CGPoint)pt
                  withIndex:(NSUInteger)index
        unreadMessagesCount:(NSUInteger)count
                   zoomToPt:(BOOL)bZoom
{
    [self addLocationPoint:pt
            viewIdentifier:index
       unreadMessagesCount:count];

    if (bZoom)
    {
        // calculate minimum scale to perfectly fit image width, and begin at that scale
        float minimumScale = [_mainScrollView frame].size.width  / [_mainImageView frame].size.width;
        [_mainScrollView setZoomScale:minimumScale];
        
        CGPoint tmpPt = [self getImageViewAbsolutePoint:pt];
        //No need of this margin now
        //tmpPt.y -= 12;
        CGRect zoomRect = [self zoomRectForPoint:tmpPt];
        [_mainScrollView zoomToRect:zoomRect animated:YES];
        _mainScrollView.userInteractionEnabled = NO;
    }
}


-(void) clearLocationPoints
{
    [self.locationPoints removeAllObjects];
    [[self.mainImageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


-(CGRect) getImageViewFrame
{
    CGRect frame = CGRectZero;
    
    if (_mainImageView)
        return _mainImageView.frame;
    
    return frame;
}
#pragma mark - Scrollview related private methods

-(void) setupScrollView:(CGRect) frame
        shouldAllowZoom:(BOOL) bZoom
{
    // 1. Create Scrollview
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self addSubview:self.mainScrollView];
    
    // 2. Setup its delegate and zooming parameters
    if (bZoom)
    {
        self.mainScrollView.minimumZoomScale = 1;
        self.mainScrollView.maximumZoomScale = 5.0;
        self.mainScrollView.alwaysBounceVertical = NO;
        self.mainScrollView.alwaysBounceVertical = NO;
        self.mainScrollView.delegate = self;
    }
}


#pragma mark - mainimage view related private methods

-(void) loadMainImage:(UIImage *)image
{
    if (image)
    {
        self.currentDisplayImage = image;
        
        self.mainImageView = [[UIImageView alloc] init];
        [self.mainImageView setImage:image];
        
        //setup its frame and push it in main view
        CGSize size = [self getImageViewRect:image];
        
        CGRect frame = CGRectZero;
        frame.size = size;
        frame.origin.x = lround((self.mainScrollView.bounds.size.width - size.width) / 2);
        frame.origin.y = lround((self.mainScrollView.bounds.size.height - size.height) / 2);
        [self.mainImageView setFrame:frame];
        [self.mainScrollView addSubview:self.mainImageView];
        
        // enable tapping on it
        [self addTapEventWithTarget:self.mainImageView
                             action:@selector(imageTapped:)];
    }
}


//this is image point
-(void) addLocationPoint:(CGPoint)pt
          viewIdentifier:(NSInteger)index
     unreadMessagesCount:(NSUInteger)count
{
    //converts this point with respect to imageview frame
    // image with ==> width
    // x  ==>
    
    CGPoint tmpPt = [self getImageViewAbsolutePoint:pt];
    
    //tmpPt = [self getMainViewPoint:tmpPt];

    UIView *view = [self getLocationImage:tmpPt];
    
    if (count > 0) // adding badge view
    {
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:10];
        UIView *badgeView = [MPUIUtility getBadgeViewWithBaddesCount:count
                                             userFont:font];
        
        UIImage *image = [MPUIUtility imageByRenderingView:badgeView];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect frame = imageView.bounds;
        frame.origin.x = view.bounds.size.width - frame.size.width;
        imageView.frame = frame;
        [view addSubview:imageView];
    }
    
    view.tag = (index + 1); //do not want to mess up with defaults one
    [self.mainImageView addSubview:view];
    [self.locationPoints addObject:[NSValue valueWithCGPoint:pt]];
}


#pragma mark - event handlers

- (void)imageTapped:(UITapGestureRecognizer*)recognizer
{
    if ([self.delegate respondsToSelector:@selector(shouldInsertNewLocation)])
    {
        BOOL bShouldInsert = [self.delegate shouldInsertNewLocation];
        
        if (bShouldInsert)
        {
            NSInteger viewIdentifier = [self.locationPoints count] + 1;
            CGPoint pt = [recognizer locationInView:self.mainImageView];
            CGPoint imagePt = [self getImagePoint:pt];
            
            UIView *view = [self getLocationImage:pt];
            view.tag = viewIdentifier;
            [self.mainImageView addSubview:view];
            
            [self.locationPoints addObject:[NSValue valueWithCGPoint:imagePt]];
            
            NSLog(@"image displacemnt x = %0.2f", imagePt.x);
            NSLog(@"image displacemnt y = %0.2f", imagePt.y);

            if ([self.delegate respondsToSelector:@selector(didFinishwithAddingLocation:onImage:forIndex:)])
                [self.delegate didFinishwithAddingLocation:imagePt
                                               onImage:self.mainImageView.image
                                                  forIndex:viewIdentifier];
        }
    }
}


- (void)locationImageTapped:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"location image tapped");
    
    if ([self.delegate respondsToSelector:@selector(tapOnImage:atLocation:forIndex:)])
    {
        NSInteger viewIdentifier = recognizer.view.tag - 1;

        CGPoint imagePt;
        
        if (viewIdentifier < [self.locationPoints count])
        {
            NSValue *pointVal = [self.locationPoints objectAtIndex:viewIdentifier];
            imagePt = [pointVal CGPointValue];
        }
        else //this case ideally should not hit //just added safeguard
        {
            CGPoint pt = recognizer.view.frame.origin;
            pt.x += lround((recognizer.view.bounds.size.width)/2);
            pt.y += recognizer.view.bounds.size.height;
            imagePt = [self getImagePoint:pt];
        }

        [self.delegate tapOnImage:self.mainImageView.image
                       atLocation:imagePt
                         forIndex:viewIdentifier];
    }
}


#pragma mark helpers

//point given in terms of image view
// return in terms of image
-(CGPoint) getImagePoint:(CGPoint)pt
{
    CGPoint imagePt = CGPointZero;
    
    imagePt.x = lround(pt.x * self.currentDisplayImage.size.width / _mainImageView.frame.size.width  * self.mainScrollView.zoomScale);
    imagePt.y = lround(pt.y * self.currentDisplayImage.size.height / _mainImageView.frame.size.height  * self.mainScrollView.zoomScale);
    
    return imagePt;
}


//point given in terms of image
// returns point in terms of image view
-(CGPoint) getImageViewAbsolutePoint:(CGPoint)pt
{
    CGPoint tmpPt = pt;
    
    tmpPt.x = lround(pt.x * self.mainImageView.bounds.size.width / self.currentDisplayImage.size.width);
    tmpPt.y = lround(pt.y * self.mainImageView.bounds.size.height / self.currentDisplayImage.size.height);
    
    return tmpPt;
}


-(CGSize) getImageViewRect:(UIImage *)image
{
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    
    CGFloat finalImageW = imageW;
    CGFloat finalImageH = imageH;
    
    CGFloat aspectRatio = imageW / imageH;
    
    // 1. First check image is in portraint or landscape
    if (self.bounds.size.width > self.bounds.size.height) //landscape
    {
        if (imageW > imageH) //landscape image
        {
            //if (imageW > self.bounds.size.width)
            {
                finalImageW = self.bounds.size.width;
                finalImageH = finalImageW / aspectRatio;
                
                if (finalImageH > self.bounds.size.height)
                {
                    finalImageH = self.bounds.size.height;
                    finalImageW = aspectRatio * finalImageH;
                }
            }
        }
        else //portrait image
        {
            //if (imageH > self.bounds.size.height)
            {
                finalImageH = self.bounds.size.height;
                finalImageW = finalImageH * aspectRatio;
            }
        }
    }
    else
    {
        if (imageW > imageH) //landscape image
        {
            //if (imageW > self.bounds.size.width)
            {
                finalImageW = self.bounds.size.width;
                finalImageH = finalImageW / aspectRatio;
            }
        }
        else //portrait image
        {
            //if (imageH > self.bounds.size.height)
            {
                finalImageH = self.bounds.size.height;
                finalImageW = finalImageH * aspectRatio;
                
                if (finalImageW > self.bounds.size.width)
                {
                    finalImageW = self.bounds.size.width;
                    finalImageH = finalImageW / aspectRatio;
                }
            }
        }
        
    }
    
    return CGSizeMake(finalImageW, finalImageH);
}


-(void) addTapEventWithTarget:(UIView *)view
                       action:(nullable SEL)action
{
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:action];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:singleTapRecognizer];
}


- (CGRect)zoomRectForPoint:(CGPoint)pt
{
    CGFloat newScale = [_mainScrollView zoomScale] * 1.5; //1.5 value is taken as step guide from Apple sample
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = lround([_mainScrollView frame].size.height / newScale);
    zoomRect.size.width  = lround([_mainScrollView frame].size.width  / newScale);
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = pt.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = pt.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


-(UIView *) getLocationImage:(CGPoint)location
{
    CGRect frame = [self getViewFrameAtLocationPoint:location];
    
    UIImage *locationImage = [UIImage imageNamed:@"hotspot"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:locationImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = frame;
    
    //add tapping on that location view
    [self addTapEventWithTarget:imageView action:@selector(locationImageTapped:)];
    return imageView;
}


-(CGRect) getViewFrameAtLocationPoint:(CGPoint)pt
{
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(lround(LOCATION_MARK_SIZE / _mainScrollView.zoomScale), lround(LOCATION_MARK_SIZE / _mainScrollView.zoomScale));
    frame.origin.x = lround(pt.x - (frame.size.width / 2.0));
    frame.origin.y = lround(pt.y - frame.size.height);
    
    return  frame;
}


-(void) updateLocationMarks
{
    [self.locationPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSValue *pointVal = [self.locationPoints objectAtIndex:idx];
        CGPoint imagePt = [pointVal CGPointValue];
        
        CGPoint location = [self getImageViewAbsolutePoint:imagePt];
        
        UIView *view = [_mainImageView viewWithTag:(idx + 1)];
        
        if (view)
        {
            view.frame = [self getViewFrameAtLocationPoint:location];
            
            if ([view.subviews count])
            {
                UIImageView *badgeView = [view.subviews objectAtIndex:0];
                CGRect frame = CGRectZero;
                frame.size = CGSizeMake(lround(badgeView.image.size.width / _mainScrollView.zoomScale), lround(badgeView.image.size.height / _mainScrollView.zoomScale));
                frame.origin.x = view.bounds.size.width - frame.size.width;
                badgeView.frame = frame;
            }
        }
    }];
}


#pragma mark - UIScrollviewdelegate Delegate methods

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Return the view that we want to zoom
    return self.mainImageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0);
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
    
    [self updateLocationMarks];
}

@end