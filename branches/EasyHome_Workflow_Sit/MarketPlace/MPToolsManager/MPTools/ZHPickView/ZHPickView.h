/**
 * @file    ZHPickView.h
 * @brief   time selector view
 * @author  Xue
 * @version 1.0
 * @date    2015-12-01
 */

#import <UIKit/UIKit.h>
@class ZHPickView;

/// the protocol of ZHPickView.
@protocol ZHPickViewDelegate <NSObject>

@optional

/**
 *  @brief After the choice must be implemented after the proxy method.
 *
 *  @param pickView According to the pickview.
 *
 *  @param resultString selected result.
 *
 *  @param isCertain Is to determine or cancelled.
 *
 *  @return void nil.
 */

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString isCertain:(BOOL)isCertain;

@end

/// the view of Time PickView.
@interface ZHPickView : UIView

/// the delegate ZHPickView.
@property(nonatomic,weak) id<ZHPickViewDelegate> delegate;

/**
 *  @brief Add a pickView through plistName.
 *
 *  @param plistName The name of the file.

 *  @param isHaveNavControler Whether within NavControler.
 *
 *  @return Pickview with the toolbar.
 */
-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler;

/**
 *  brief Add a pickView through plistName.
 *
 *  @param array Need to display the array.
 *  @param isHaveNavControler Whether within NavControler.
 *
 *  @return Pickview with the toolbar.
 */
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler;

/**
 *  brief Through the time to create a DatePicker.
 *
 *  @param date Selected by default time.
 *
 *  @param isHaveNavControler Whether within NavControler.
 *
 *  @return Pickview with the toolbar.
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler;

/// Remove the control.
-(void)remove;

/// Show the control.
-(void)show;

///  set PickView background color.
-(void)setPickViewColer:(UIColor *)color;

/// set toobar title color.
-(void)setTintColor:(UIColor *)color;

/// set toobar background color.
-(void)setToolbarTintColor:(UIColor *)color;

@end


