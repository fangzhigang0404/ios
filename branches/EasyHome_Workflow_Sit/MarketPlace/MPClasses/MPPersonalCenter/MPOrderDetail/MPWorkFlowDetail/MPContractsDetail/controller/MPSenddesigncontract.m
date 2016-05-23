//
//  MPSenddesigncontract.m
//  MarketPlace
//
//  Created by zzz on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPSenddesigncontract.h"

#import "MPPayMentViewController.h"

@interface MPSenddesigncontract ()
{

    UIWebView * webview;
    __weak IBOutlet UIWebView *mainView;
    __weak IBOutlet NSLayoutConstraint *_mainViewContraint;
    __weak IBOutlet UIButton *_redioBtn;
    __weak IBOutlet UILabel *_readLabel;
    
    __weak IBOutlet UIButton *_payButton;
}
@end

@implementation MPSenddesigncontract

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([[AppController AppGlobal_GetMemberInfoObj].memberType isEqualToString:@"designer"]) {
        _mainViewContraint.constant = 0;
        _redioBtn.hidden = YES;
        _readLabel.hidden = YES;
    }else {
        _redioBtn.hidden = !self.selectShow;
        _readLabel.hidden = !self.selectShow;
        _mainViewContraint.constant = self.selectShow ? _mainViewContraint.constant : 0;
        
    }
    [self viewLoadHtml];
    self.rightButton.hidden = YES;
    [mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

- (void)viewLoadHtml {
    
    NSString *strHtml = [self LoadContractString];
    [mainView loadHTMLString:strHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] resourcePath] isDirectory: YES]];
}
- (NSString*)LoadContractString{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Contract" ofType:@"txt"];
    NSString *strHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

    
    strHtml= [strHtml stringByReplacingOccurrencesOfString:@"<wf-designPay>" withString:[NSString stringWithFormat:@"%@",self.TotalCost]];
    strHtml= [strHtml stringByReplacingOccurrencesOfString:@"<wf-designFirstFee> " withString:[NSString stringWithFormat:@"%@",self.FristCost]];
    strHtml= [strHtml stringByReplacingOccurrencesOfString:@"<wf-designBalanceFee>" withString:[NSString stringWithFormat:@"%@",self.EndCost]];
    //<wf-designFirstFee>  <wf-designBalanceFee>
    strHtml= [strHtml stringByReplacingOccurrencesOfString:@"<wf-design_sketch>" withString:[NSString stringWithFormat:@"%@",self.design_sketch]];
    strHtml= [strHtml stringByReplacingOccurrencesOfString:@"<wf-render_map>" withString:[NSString stringWithFormat:@"%@",self.render_map]];
    strHtml= [strHtml stringByReplacingOccurrencesOfString:@"<wf-design_sketch_plus>" withString:[NSString stringWithFormat:@"%@",self.design_sketch_plus]];
    
    return strHtml;
}

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)PayBtn:(UIButton *)sender {
    
    MPPayMentViewController *vc = [[MPPayMentViewController alloc]initWithPayType:MPPayForContractFirst];
    vc.statusModel = self.statusModel;
    vc.fromVC = self.fromVC;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)COntractBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    BOOL flag = sender.selected;
    _payButton.enabled = flag;
    _payButton.backgroundColor = flag ? COLOR(0, 132, 255, 1) : COLOR(153, 153, 153, 1);
}

- (IBAction)cancelBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
