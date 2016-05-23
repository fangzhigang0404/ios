/**
 * @file    MPPickerView.h
 * @brief   the cell of table.
 * @author  niu
 * @version 1.0
 * @date    2015-01-20
 */

#import <UIKit/UIKit.h>

@interface MPPickerView : UIView

/**
 *  @brief Initialize the selector and return the selected data.
 *
 *  @param frame the frame for pickerView.
 *
 *  @param type the type for pickerView.
 *
 *  @param finish the block for return result for selected data.
 *
 *  @param componet1 the data of pickerView in componet one.
 *
 *  @param componet2 the data of pickerView in componet two.
 *
 *  @param componet3 the data of pickerView in componet three.
 *
 *  @param isCancel Cancel return or not.
 *
 *  @return instancetype return pickerView.
 */
- (instancetype)initWithFrame:(CGRect)frame
                    plistName:(NSString *)plistName
                 compontCount:(NSInteger)compont
                      linkage:(BOOL)isLinkage
                       finish:(void(^) (NSString *componet1,
                                        NSString *componet2,
                                        NSString *componet3,
                                        BOOL isCancel,
                                        NSString *nian))finish;

/**
 *  @brief Initialize the selector and return the selected data.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)removePickerView;

@end
