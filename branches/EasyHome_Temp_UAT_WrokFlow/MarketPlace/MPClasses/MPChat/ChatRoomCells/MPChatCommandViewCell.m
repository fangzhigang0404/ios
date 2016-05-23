//
//  CommandViewCell.m
//  tests
//
//  Created by Avinash Mishra on 02/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatViewCell.h"
#import "MPChatCommandViewCell.h"
#import "MPChatMessage.h"
#import "MPChatCommandInfo.h"

@implementation MPChatCommand

@end


@interface MPChatCommandViewCell ()
{
    __weak IBOutlet UILabel*        _commandTitle;
    __weak IBOutlet UILabel*        _commandMessage;
    __weak IBOutlet UIView*         _commandParentView;
    __weak IBOutlet UIButton*       _command;
}

@end


@implementation MPChatCommandViewCell

- (void)awakeFromNib
{

}

- (void) updateSenderImage
{
        _senderImageView.image = [UIImage imageNamed:@"admin"];
}


- (void) updateCellForIndex:(NSUInteger) index
{
    [super updateCellForIndex:index];

    MPChatMessage* msg = [self.delegate getCellModelForIndex:index];
    MPChatCommandInfo* commandInfo = [MPChatMessage getCommandInfoFromMessage:msg];
    _commandMessage.text = commandInfo.for_consumer;
    if ([self.delegate isLoggedInUserIsDesigner])
        _commandMessage.text = commandInfo.for_designer;

    _commandParentView.hidden = NO;
    _command.layer.cornerRadius = 5;
    switch ([commandInfo.sub_node_id integerValue])
    {
        case 13:
            [_command setTitle:NSLocalizedString(@"Pay", @"Pay") forState:UIControlStateNormal]; // 量房费用
            break;
            
        case 11:
        case 12:
        case 14:
            [_command setTitle:NSLocalizedString(@"Measure", @"Measure") forState:UIControlStateNormal];
            break;
            
        case 21:
        case 22:
        case 31:
            [_command setTitle:NSLocalizedString(@"Contract", @"Contract") forState:UIControlStateNormal]; // 设计合同
            break;
            
        case 33:
            [_command setTitle:NSLocalizedString(@"Deliver", @"Deliver") forState:UIControlStateNormal]; // 量房交付
            break;
            
        case 41:
        case 42:
            [_command setTitle:NSLocalizedString(@"FinalPay", @"FinalPay") forState:UIControlStateNormal]; // 设计尾款
            break;
            
        case 51:
        case 52:
        case 61:
        case 62: {
            if ([AppController AppGlobal_GetIsDesignerMode]) {
                [_command setTitle:NSLocalizedString(@"UploadDeliver", @"UploadDeliver") forState:UIControlStateNormal]; // 上传交付物
            }else {
                [_command setTitle:NSLocalizedString(@"DownloadDeliver", @"DownloadDeliver") forState:UIControlStateNormal]; // 接收交付物
            }
            
            
            break;
        
        }
            
            
        default:
            break;
    }
}


- (IBAction)commandPressed:(id)sender
{
    [self.delegate onCellChildUIActionForIndex:_index];
}


@end