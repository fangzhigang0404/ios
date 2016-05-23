//
//  ChatListCell.m
//  tests
//
//  Created by Avinash Mishra on 06/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatListCell.h"
#import "MPChatThread.h"
#import "MPChatUser.h"

@interface MPChatListCell ()
{
    __weak IBOutlet UILabel*            _warning;

    __weak IBOutlet NSLayoutConstraint* _showWarningDeactivateConstraints;
    __weak IBOutlet NSLayoutConstraint* _showWarningActivateConstraint;

    __weak IBOutlet NSLayoutConstraint* _showWarningDeactivateConstraintsForStepName;
    __weak IBOutlet NSLayoutConstraint* _showWarningActivateConstraintForStepName;
}

@end


@implementation MPChatListCell

- (void)awakeFromNib {
    // Initialization code
}


- (void) updateConstraints
{
    [super updateConstraints];
    _showWarningActivateConstraint.active = NO;
    _showWarningDeactivateConstraints.active = YES;
    _showWarningActivateConstraintForStepName.active = NO;
    _showWarningDeactivateConstraintsForStepName.active = YES;
    [super updateConstraints];
}

- (void) updateUIWithIndex:(NSUInteger) index
{
    [super updateUIWithIndex:index];
   
    _chatImage.layer.cornerRadius = (_chatImage.frame.size.width / 2);
    
    _warning.hidden = YES;
    _showWarningActivateConstraint.active = NO;
    _showWarningDeactivateConstraints.active = YES;

}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

@end
