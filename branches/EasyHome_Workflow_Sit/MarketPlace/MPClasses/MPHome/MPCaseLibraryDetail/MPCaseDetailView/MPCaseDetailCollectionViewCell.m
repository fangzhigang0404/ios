/**
 * @file    MPCaseDetailCollectionViewCell.m
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-22
 */

#import "MPCaseDetailCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MPCaseModel.h"

@interface MPCaseDetailCollectionViewCell ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UIScrollView *imageviewScrollView;   //<! the scrollview for show background view.
    UIImageView *case_ImageView;         //<! the imageview for show image.
}
@property (weak,nonatomic)IBOutlet UIImageView *caseImageView;
@end

@implementation MPCaseDetailCollectionViewCell

-(void) updateCellForIndex:(NSUInteger) index {
    
    if ([self.delegate respondsToSelector:@selector(getCaseLibraryDetailModelForIndex:)]) {
        
        MPCaseImageModel *model = [self.delegate getCaseLibraryDetailModelForIndex:index];
        
        self.caseImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.caseImageView.userInteractionEnabled = YES;
        [self.caseImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@HD.jpg",model.file_url]] placeholderImage:[UIImage imageNamed:HOUSE_DEFAULT_IMAGE]];
        
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
        
        [self.caseImageView addGestureRecognizer:tap];
        
        
    }
}



-(void)magnifyImage

{
    
    NSLog(@"局部放大");
    
    [self showImage:self.caseImageView];//调用方法
    
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



- (void)awakeFromNib {
    // Initialization code
}

@end
