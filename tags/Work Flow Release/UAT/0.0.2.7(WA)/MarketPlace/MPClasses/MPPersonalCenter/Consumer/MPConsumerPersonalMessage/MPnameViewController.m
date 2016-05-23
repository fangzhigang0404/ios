/**
 * @file    MPnameViewController.h
 * @brief   the view of MPnameViewController
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPnameViewController.h"
@interface MPnameViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *contentTextField;
    UIView *speView;
    BOOL isHasRadixPoint;
}
@end

@implementation MPnameViewController

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     NSLog(@"MPnameViewController lounch");
    
    self.view.backgroundColor = [UIColor orangeColor];
    //self.tabBarController.tabBar.hidden = YES;
    self.titleLabel.text = self.titleString;

    [self.rightButton setImage:nil
                                forState:UIControlStateNormal];
    self.rightButton.hidden = NO;
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([self.titleString isEqualToString:NSLocalizedString(@"gender_key", @"")]) {
        self.rightButton.hidden = YES;
    }else {
        [self.rightButton setTitle:NSLocalizedString(@"save_key", nil) forState:UIControlStateNormal];
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    _tableView.tableHeaderView = myView;
   
    [self.view addSubview:_tableView];
}
-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) return YES;
    }
    return NO;
}
- (void)tapOnRightButton:(id)sender
{
    
    if ([self.titleString isEqualToString:NSLocalizedString(@"Amount of room cost_key_", nil)]) {
        
      BOOL is_chinese = [self IsChinese:contentTextField.text];
        
        if (is_chinese || ![self checkAmount:contentTextField.text]) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"Input contains Chinese characters_key", nil) sureKey:nil];
        }else {
            
            [self.trendDelegate passTrendValues:contentTextField.text andtitle:self.titleLabel.text];
            [self.navigationController popViewControllerAnimated:YES];

        }
    }else {
        
        if ([self.titleString isEqualToString:NSLocalizedString(@"nickname_key", nil)]) {
            NSString *nick_name = contentTextField.text;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[A-Za-z0-9\u4e00-\u9fa5]+$"];
            BOOL isMatchName = [predicate evaluateWithObject:nick_name];
            if (nick_name.length < 2 || nick_name.length > 10 || !isMatchName) {
                [MPAlertView showAlertWithMessage:@"昵称格式不正确" sureKey:nil];
                return;
            }
        }
        [self.trendDelegate passTrendValues:contentTextField.text andtitle:self.titleLabel.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)checkAmount:(NSString *)amount {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d+(\\.\\d+)?$"];
    BOOL isMatch = [predicate evaluateWithObject:amount];
    NSArray *array = [amount componentsSeparatedByString:@"."];
    NSString *str1 = array[0];
    NSString *str2;
    if (array.count >= 2)
        str2 = array[1];
    
    if (!isMatch || str1.length > 4 || str2.length >2) {
        return NO;
    }
    return YES;
}

-(void)messagePassTrendValues:(NSString *)values {
    NSLog(@"values is %@",values);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.titleString isEqualToString:NSLocalizedString(@"gender_key", @"")]) {
        return 3;
    }else {
        return 1;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.isSex) {
            [self.trendDelegate passTrendValues:NSLocalizedString(@"menKey", nil) andtitle:self.titleLabel.text];
        }
    }else if (indexPath.row == 1) {
        [self.trendDelegate passTrendValues:NSLocalizedString(@"wemenKey", nil) andtitle:self.titleLabel.text];
    }else if (indexPath.row == 2) {
        [self.trendDelegate passTrendValues:NSLocalizedString(@"A secret_key", nil) andtitle:self.titleLabel.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"nameCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    speView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    speView.backgroundColor = [UIColor colorWithRed:(247.0/255.0) green:(247.0/255.0) blue:(247.0/255.0) alpha:1];
    contentTextField = [[UITextField alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 14, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 40)];
    UIImageView *imageg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -16-19/1.3,(44-15/1.3)/2, 19/1.3,15/1.3)];
    imageg.image = [UIImage imageNamed:@"dui"];
    if (indexPath.section == 0 && indexPath.row == 0) {

        if ([self.titleString isEqualToString:NSLocalizedString(@"gender_key", @"")]) {
            label.text = NSLocalizedString(@"menKey", nil);
            [cell.contentView addSubview:label];
            NSLog(@"%@",self.titleString);
            
        }else {
            contentTextField.text = self.nameString;
            contentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:contentTextField];
            if ([self.titleString isEqualToString:NSLocalizedString(@"Amount of room cost_key", nil)]) {
                contentTextField.delegate = self;
                contentTextField.keyboardType = UIKeyboardTypeDecimalPad;
            }

        }
        if ([self.nameString isEqualToString:NSLocalizedString(@"menKey", nil)] && self.isSex) {
            [cell.contentView addSubview:imageg];
        }
    }else if (indexPath.section == 0&& indexPath.row == 1) {
        label.text = NSLocalizedString(@"wemenKey", nil);
        [cell.contentView addSubview:label];
        if ([self.nameString isEqualToString:NSLocalizedString(@"wemenKey", nil)]) {
            [cell.contentView addSubview:imageg];
        }

    }else if (indexPath.section == 0&& indexPath.row == 2) {
        label.text = NSLocalizedString(@"A secret_key", nil);
        [cell.contentView addSubview:label];
        if ([self.nameString isEqualToString:NSLocalizedString(@"A secret_key", nil)]) {
            [cell.contentView addSubview:imageg];
        }
    }

    [cell.contentView addSubview:speView];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


/// touch it is handling (those touches it received in touchesBegan:withEvent:).
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [contentTextField resignFirstResponder];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    isHasRadixPoint = YES;
    NSString *existText = textField.text;
    if ([existText rangeOfString:@"."].location == NSNotFound) {
        isHasRadixPoint = NO;
    }
    if (string.length > 0) {
        unichar newChar = [string characterAtIndex:0];
        if ((newChar >= '0' && newChar <= '9') || newChar == '.' ) {
            if (newChar == '.') {
                if (isHasRadixPoint)
                    return NO;
                else
                    return YES;
            }else {
                if (isHasRadixPoint) {
                    NSRange ran = [existText rangeOfString:@"."];
                    NSInteger radixPointCount = range.location - ran.location;
                    if (radixPointCount <= 2) return YES;
                    else
                        return NO;
                } else
                    return YES;
            }
            
        }else {
            if ( newChar == '\n') return YES;       
            return NO;
        }
        
    }else {
        return YES;
    }
}
@end
