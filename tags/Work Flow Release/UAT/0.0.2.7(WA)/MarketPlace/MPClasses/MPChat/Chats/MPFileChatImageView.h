/**
 * @file    MPFileChatImageView.h
 * @brief   image view of file.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-01-16
 *
 */

#import <UIKit/UIKit.h>


@protocol MPFileChatImageViewDelegate <NSObject>
/**
 *  @brief tap on image.
 *
 *  @param image The image which is tapped.
 *  @param pt The pt is the point which is tapped.
 *  @param index The index is the number of the cell which is tapped.
 *
 *  @return void nil.
 */
-(void) tapOnImage:(UIImage *)image
        atLocation:(CGPoint)pt
          forIndex:(NSUInteger)index;
/**
 *  @brief tshould insert new location.
 *
 *  @return BOOL.
 */
-(BOOL) shouldInsertNewLocation;
/**
 *  @brief did finish with adding location.
 *
 *  @param image The image which is added points on.
 *  @param pt The pt is the point which is added.
 *  @param index The index is the number of the cell which is tapped.
 *
 *  @return void nil.
 */
-(void) didFinishwithAddingLocation:(CGPoint)pt
                            onImage:(UIImage *)image
                           forIndex:(NSInteger)index; //this is just for controller managing model

@end

@interface MPFileChatImageView : UIView
/**
 *  @brief init file chat image view.
 *
 *  @param image The image which is needed to add point on.
 *  @param frame The frame is the frame of the image.
 *  @param delegate The delegate object observe the protocol.
 *
 *  @return id.
 */
-(id) initWithFrame:(CGRect)frame
           withImage:(UIImage *)image
           delegate:(id)delegate;
/**
 *  @brief init file chat image view.
 *
 *  @param image The image which is needed to add point on.
 *  @param frame The frame is the frame of the image.
 *
 *  @return id.
 */
-(id) initWithFrame:(CGRect)frame
          withImage:(UIImage *)image;

// this will add new location point
// index is just for identification
// respective controller needs to handle index logic
// tapping on that location image will return the same index
-(void) showLocationAtPoint:(CGPoint)pt
                  withIndex:(NSUInteger)index
        unreadMessagesCount:(NSUInteger)count
                   zoomToPt:(BOOL)bZoom;
/**
 *  @brief clear location points.
 *
 *  @return void nil.
 */
-(void) clearLocationPoints;

//added just for onboarding feature

/**
 *  @brief added just for onboarding feature.
 *
 *  @return CGRect frame.
 */
-(CGRect) getImageViewFrame;

@end
