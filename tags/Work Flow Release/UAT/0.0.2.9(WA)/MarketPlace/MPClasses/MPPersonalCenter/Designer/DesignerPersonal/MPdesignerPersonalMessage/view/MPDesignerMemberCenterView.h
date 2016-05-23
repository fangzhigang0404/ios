/**
 * @file    MPDesignerMemberCenterView.h
 * @brief   the view of designer Message Center view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */
#import <Foundation/Foundation.h>

@class MPMemberModel;
@protocol DesignerMemberCenterViewDelegate <NSObject>

@required
/**
 * @brief headIconBtnClick:(UIButton *)btn cerficationBtnClick:(UIButton *)btnClick withSection:(NSInteger)section withRow:(NSInteger)row.
 *
 * @param  btn button.
 *
 * @param  btnClick button click.
 *
 * @param  section tableView section.
 *
 * @return void.
 */
-(void) headIconBtnClick:(UIButton *)btn cerficationBtnClick:(UIButton *)btnClick withSection:(NSInteger)section withRow:(NSInteger)row;
@end
@interface MPDesignerMemberCenterView : UIView
/// designer member center delegate.
@property (strong,nonatomic)id<DesignerMemberCenterViewDelegate>delegate;
/// updata model.
- (void)reloadData:(MPMemberModel *)model;
/// certification methods.
- (void)certification:(NSString *)cerfication;
/// load information.
- (void)loadInformation;

@end
