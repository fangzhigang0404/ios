
/**
 * @file    MPToolChatView.h
 * @brief   tool chat view .
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <UIKit/UIKit.h>

@protocol MPToolChatViewDelegate <NSObject>

- (void) textViewDidSendText:(NSString*) message;
/**
 *  @brief start recording.
 *
 *  @return void nil.
 */
- (void) startRecording;
/**
 *  @brief stop recording.
 *
 *  @return void nil.
 */
- (void) stopRecording;
/**
 *  @brief cancel recording.
 *
 *  @return void nil.
 */
- (void) cancelRecording;

@optional
/**
 *  @brief tool view plus button clicked.
 *
 *  @return void nil.
 */
- (void) toolViewPlusButtonClicked;
/**
 *  @brief open camera button clicked.
 *
 *  @return void nil.
 */
- (void) openCameraButtonClicked;
/**
 *  @brief select image button clicked.
 *
 *  @return void nil.
 */
- (void) selectImageButtonClicked;
/**
 *  @brief custom action button clicked.
 *
 *  @return void nil.
 */
- (void) customActionButtonClicked;

@end


@interface MPToolChatView : UIView

/// delegate The delegate object observe MPToolChatViewDelegate protocol.
@property (nonatomic, weak) id <MPToolChatViewDelegate>   delegate;

/// isToolViewNeeded The isToolViewNeeded is tool view needed or not.
@property (nonatomic) BOOL isToolViewNeeded;
/// isToolViewHidden The isToolViewHidden tool view status.
@property (nonatomic, readonly) BOOL isToolViewHidden;

/**
 *  @brief cancel recording.
 *
 *  @return void nil.
 */
- (void) cancelRecording;
/**
 *  @brief hide Keyboard from toolChatView.
 *
 *  @return void nil.
 */
- (void) hideKeyboardFromToolChatView;
/**
 *  @brief hide tool view .
 *
 *  @param hideToolView The hideToolView is decided to hide tool view or not.
 *
 *  @return void nil.
 */
- (void) hideToolView:(BOOL)hideToolView;
/**
 *  @brief change custom button icon with image.
 *
 *  @param image The image show on custom button.
 *
 *  @return void nil.
 */
- (void) changeCustomButtonIconWithImage:(NSString*)image;

@end
