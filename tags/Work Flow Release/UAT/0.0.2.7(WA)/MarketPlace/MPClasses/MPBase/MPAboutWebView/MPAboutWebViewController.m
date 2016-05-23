/**
 * @file    MPAboutWebViewController.m
 * @brief   the controller of about webview.
 * @author  niu
 * @version 1.0
 * @date    2016-03-29
 */

#import "MPAboutWebViewController.h"

@interface MPAboutWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *aboutWebView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) NSString* titleString;
@property (nonatomic, strong) NSString* fileName;

@end

@implementation MPAboutWebViewController

@synthesize title;
@synthesize fileName;


- (instancetype)initWithParm:(NSString *)titleStr
                     withFile:(NSString *)fileNameStr
{
    self = [self init];
    if (self)
    {
        self.titleString=titleStr;
        self.fileName = fileNameStr;
        
    }
    return self;
}


- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self initNavigationBar];
    
    [self initData];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = self.aboutWebView.scrollView;
    scrollView.bounces = NO;
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.aboutWebView.frame), 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
}

- (void)initNavigationBar {

    self.titleLabel.text = self.titleString;

    self.rightButton.hidden = YES;
}

- (void)initData {
    self.versionLabel.text = [AppController AppGlobal_GetAppMainVersion];
    
    [self viewLoadHtml];
}

- (void)viewLoadHtml {
    
    NSString *strHtml = [self LoadContractString];
    [_aboutWebView loadHTMLString:strHtml baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] resourcePath] isDirectory: YES]];
}
- (NSString*)LoadContractString{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.fileName  ofType:@"txt"];
    NSString *strHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return strHtml;
}

@end
