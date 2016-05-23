 //
//  MPLoginPageViewController.m
//  MarketPlace
//
//  Created by Franco Liu on 16/2/20.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPLoginPageViewController.h"
#import "MPLoginTool.h"

#define MPGETNEWSYSTEMTHREADID @"MPGetnewthreadid"
#define SSO_LOGIN_FOUR_URL_PART @"access_type=design&reutnr_url="

@interface MPLoginPageViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *Bt_Back;
@property (weak, nonatomic) IBOutlet UIWebView *SingleSignOnView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation MPLoginPageViewController

- (IBAction)closeLoginVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [AppController clearCookie];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.closeButton.hidden  = YES;
    
    [self.SingleSignOnView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self PreLoadSignOn];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.SingleSignOnView.delegate = nil;
}

- (IBAction)ClickBack:(id)sender {
    
    NSString *str = [self.SingleSignOnView.request.URL absoluteString];
    
    if ([str rangeOfString:SSO_LOGIN_FOUR_URL_PART].length == 0) {
        self.closeButton.hidden = NO;
        if (self.SingleSignOnView.canGoBack)
            [self.SingleSignOnView goBack];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [AppController clearCookie];
        }];
    }
}

- (void)PreLoadSignOn{
    NSURL* url = [NSURL URLWithString:LOGIN_PATH];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [self.SingleSignOnView loadRequest:request];
    self.SingleSignOnView.backgroundColor = [UIColor grayColor];
    self.SingleSignOnView.delegate = self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSLog(@"%@",[request.URL absoluteString]);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * str = [webView stringByEvaluatingJavaScriptFromString:@"getToken()"];
    NSDictionary *dict = [MPLoginTool getSSOInfoWithString:str];
    
    if (dict.allKeys.count > 1) {
        
        [AppController AppGlobal_registerForPushNotification];
        [AppController AppGlobal_SetLoginStatus:YES];
        
        MPMember* memberInfo=[[MPMember alloc]init];
        
        [memberInfo SetWithDict:dict];
                
        [MPLoginTool requestForSystemThreadIDWithAcsMemberID:memberInfo.acs_member_id];
                
        [MPLoginTool saveNickName:memberInfo.nick_name];
        
        [MPLoginTool requestForDesignerLohoInfo:memberInfo.acs_member_id];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [MPLoginTool postNotificationForLogin];
        }];
    }
}

@end
