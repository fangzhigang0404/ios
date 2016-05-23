 //
//  MPLoginPageViewController.m
//  MarketPlace
//
//  Created by Franco Liu on 16/2/20.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPLoginPageViewController.h"
#import "MPMemberModel.h"
#import "MPCenterTool.h"

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSLog(@"%@",[request.URL absoluteString]);
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    NSLog(@"%@",error);
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"%@",[webView.request.URL absoluteString]);

    NSString * str = [webView stringByEvaluatingJavaScriptFromString:@"clickEven()"];
    NSLog(@"%@",str);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * str = [webView stringByEvaluatingJavaScriptFromString:@"getToken()"];
    if (str!=nil)
    {
        NSRange range=[str rangeOfString: @"Token=" ];
        if (range.length!=0)
        {
            NSString* jString=@"";
            jString=[str substringFromIndex:range.length];
            jString=[jString stringByRemovingPercentEncoding];
            NSData *data = [jString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",dict);
            
            MPMember* memberInfo=[[MPMember alloc]init];
            
            [memberInfo SetWithDict:dict];
            
            [MPCenterTool saveNickName:memberInfo.nick_name];
            
            [MPMemberModel getSystemThread:memberInfo.acs_member_id withSuccess:^(NSDictionary *dic) {
                [self saveSysTemCookieWithDic:dic];
                [[NSNotificationCenter defaultCenter] postNotificationName:MPGETNEWSYSTEMTHREADID
                                                                    object:nil];
            } failure:nil];

                [AppController AppGlobal_registerForPushNotification];
                [AppController AppGlobal_SetLoginStatus:YES];
                [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"creat" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:MPNotiForLoginIn object:nil];
            }];
        }
    }
}

- (void)saveSysTemCookieWithDic:(NSDictionary *)dic {
    
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    
    NSString * system_thread_id = dic[@"inner_sit_msg_thread_id"];
    NSString * system_im_thread_id = dic[@"im_msg_thread_id"];
    
    [member System_thread_id:system_thread_id];
    [member System_im_thread_id:system_im_thread_id];
    
}

@end
