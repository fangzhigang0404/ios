/**
 * @file    MPCaseDescriptionTableViewCell.m
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-01-16
 */

#import "MPCaseDescriptionTableViewCell.h"
#import "MPCaseModel.h"
#import "UIImageView+WebCache.h"
#import "MPDesignerDetailViewController.h"
#import "MPCaseTool.h"
#import "MPChatRoomViewController.h"
#import "MPDecorationNeedModel.h"

@interface MPCaseDescriptionTableViewCell ()<UIScrollViewDelegate>
{
    float lastScale;
    UIScrollView *imageviewScrollView;
    UIImageView *case_ImageView;
    UIView *titleBackView;
}
@property (nonatomic, strong) UILabel *labelInfo;
@property (nonatomic, strong) IBOutlet UIImageView *mainImageview;
@property (nonatomic, strong) IBOutlet UIImageView *avatarImageview;
@property (nonatomic, strong) IBOutlet UIImageView *vImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *styleLabel;
@property (nonatomic, strong) IBOutlet UIButton *chatButton;
@property (nonatomic, strong) IBOutlet UIButton *avatarButton;
@property (nonatomic, strong) MPCaseModel *caseModel;

@end

@implementation MPCaseDescriptionTableViewCell

- (void)awakeFromNib {

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView bringSubviewToFront:self.vImageView];
}

- (void)updateCellWithString:(MPCaseModel *)model {

    self.caseModel = model;
    [self.avatarImageview sd_setImageWithURL:[NSURL URLWithString:model.designer_info.avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
    self.avatarImageview.layer.masksToBounds = YES;
    self.avatarImageview.layer.cornerRadius = 20;
    self.nameLabel.text = (model.designer_info.nick_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.designer_info.nick_name;
    
    self.styleLabel.text = [NSString stringWithFormat:@"%@ %@ %@㎡",(model.room_type == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.room_type,(model.project_style == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.project_style,(model.room_area == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.room_area];
    
    if ([model.designer_info.real_name.audit_status integerValue]!=2) {
        self.vImageView.hidden = YES;
    }else{
        self.vImageView.hidden = NO;
    }
    
    [MPCaseTool showCaseImage:_mainImageview
                    caseArray:model.images];
    
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        self.chatButton.hidden = YES;
    }else{
        self.chatButton.hidden = NO;
    }
    self.mainImageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    
    [self.mainImageview addGestureRecognizer:tap];

}

- (IBAction)avatarClick:(id)sender {
    NSString *hs_uid = [self.delegate getHs_uid];
    MPDesignerInfoModel *model = self.caseModel.designer_info;
    model.member_id = self.caseModel.designer_id;
    model.hs_uid = hs_uid;
    MPDecorationNeedModel *needModel = [self.delegate getNeedModel];
    NSInteger bidderIndex= [self.delegate getBidderIndex];
    
    MPDesignerDetailViewController *detail;
    
    if (needModel) {
        NSString *thread_id = [self.delegate getThreadID];
        detail = [[MPDesignerDetailViewController alloc]
                  initWithIsDesignerCenter:NO
                  designerInfoModel:model
                  isConsumerNeeds:YES
                  needInfo:needModel
                  needInfoIndex:bidderIndex];
        detail.thread_id = thread_id;
        WS(weakSelf);
        detail.success = ^(){
            if ([weakSelf.delegate respondsToSelector:@selector(measureSuccess)]) {
                [weakSelf.delegate measureSuccess];
            }
        };
    } else {
    
        detail = [[MPDesignerDetailViewController alloc]
                  initWithIsDesignerCenter:NO
                  designerInfoModel:model
                  isConsumerNeeds:NO
                  needInfo:nil
                  needInfoIndex:0];
    }
    
    [[self viewController].navigationController pushViewController:detail animated:YES];
}

-(IBAction)chatClick:(id)sender {
    if ([AppController AppGlobal_GetLoginStatus]) {
        
        NSString *thread_id = [self.delegate getThreadID];
        MPDecorationNeedModel *needModel = [self.delegate getNeedModel];

        if (thread_id) {
            if (thread_id.length == 0) {
                [MPAlertView showAlertForParameterError];
                return;
            }
            
            MPChatRoomViewController *vc = [[MPChatRoomViewController alloc]
                                            initWithThread:thread_id
                                            withReceiverId:[self.caseModel.designer_id description]
                                            withReceiverName:self.caseModel.designer_info.nick_name
                                            withAssetId:[needModel.needs_id stringValue]
                                            loggedInUserId:[MPMember shareMember].acs_member_id];
            WS(weakSelf);
            vc.success = ^(){
                if ([weakSelf.delegate respondsToSelector:@selector(measureSuccess)]) {
                    [weakSelf.delegate measureSuccess];
                }
            };
            [[self viewController].navigationController pushViewController:vc animated:YES];
            
        } else {
            [AppController chatWithVC:[self viewController]
                           ReceiverID:[self.caseModel.designer_id description]
                  ReceiverHomeStyleID:self.caseModel.hs_designer_uid
                         receiverName:self.caseModel.designer_info.nick_name
                              assetID:nil
                             isQRScan:NO];
        }

    } else {
        [AppController AppGlobal_ProccessLogin];
    }

}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        
    }
    
    return nil;
}

-(void)magnifyImage

{
    
    NSLog(@"局部放大");
    
    [self showImage:self.mainImageview];//调用方法
    
}

-(void)showImage:(UIImageView *)avatarImageView{
    if ([self.delegate respondsToSelector:@selector(getControllerView)]) {
        UIView *view = [self.delegate getControllerView];
        UIImage *image=avatarImageView.image;
        
        //        UIWindow *view=[UIApplication sharedApplication].keyWindow;
        
        UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        CGRect oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:view];
        
        backgroundView.backgroundColor=[UIColor
                                        blackColor];
        
        backgroundView.alpha=0;
        
        case_ImageView=[[UIImageView alloc] initWithFrame:oldframe];
        case_ImageView.userInteractionEnabled = YES;
        
        case_ImageView.tag=1;
        
        
        imageviewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        imageviewScrollView.userInteractionEnabled = YES;
        imageviewScrollView.delegate = self;
        
        
        imageviewScrollView.showsVerticalScrollIndicator = FALSE;
        
        imageviewScrollView.showsHorizontalScrollIndicator = FALSE;
        
        imageviewScrollView.contentSize = CGSizeMake(oldframe.size.width, oldframe.size.height);
        [imageviewScrollView addSubview:case_ImageView];
        
        [backgroundView addSubview:imageviewScrollView];
        
        [view addSubview:backgroundView];
        
        CGFloat origin_x = fabs(imageviewScrollView.frame.size.width - image.size.width)/2.0;
        
        CGFloat origin_y = fabs(imageviewScrollView.frame.size.height - image.size.height)/2.0;
        
        case_ImageView.frame = CGRectMake(origin_x, origin_y, case_ImageView.frame.size.width, case_ImageView.frame.size.width*image.size.height/image.size.width);
        
        //[self.iv setImage:image];
        case_ImageView.image=image;
        
        
        CGSize maxSize = imageviewScrollView.frame.size;
        
        CGFloat widthRatio = maxSize.width/image.size.width;
        
        CGFloat heightRatio = maxSize.height/image.size.height;
        
        CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
        
        /*
         
         ** 设置UIScrollView的最大和最小放大级别（注意如果MinimumZoomScale == MaximumZoomScale，
         
         ** 那么UIScrllView就缩放不了了
         
         */
        
        [imageviewScrollView setMinimumZoomScale:initialZoom];
        
        [imageviewScrollView setMaximumZoomScale:5];
        
        // 设置UIScrollView初始化缩放级别
        
        [imageviewScrollView setZoomScale:initialZoom];
        
        
        UITapGestureRecognizer
        *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        
        [backgroundView
         addGestureRecognizer: tap];
        
        
        
        [UIView
         animateWithDuration:0.3
         
         animations:^{
             
             case_ImageView.frame=CGRectMake(0,([UIScreen
                                                 mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2,
                                             [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
             
             backgroundView.alpha=1;
             
         }
         completion:^(BOOL finished) {
             
             
             
         }];
        
    }
    
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self];
    
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView
    *backgroundView=tap.view;
    
    
    //    UIImageView
    //    *imageView=(UIImageView*)[tap.view viewWithTag:1];
    
    
    [UIView
     animateWithDuration:0.3
     
     animations:^{
         
         
         //  imageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
         
         
         backgroundView.alpha=0;
         
     }
     completion:^(BOOL finished) {
         
         [backgroundView
          removeFromSuperview];
         
     }];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer

shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    
    return case_ImageView;
    
}

// 让UIImageView在UIScrollView缩放后居中显示

- (void)scrollViewDidZoom:(UIScrollView *)scrollView

{
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    case_ImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        
                                        scrollView.contentSize.height * 0.5 + offsetY);
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
