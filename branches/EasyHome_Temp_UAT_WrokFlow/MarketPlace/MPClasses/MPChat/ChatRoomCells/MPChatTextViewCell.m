//
//  CustomTableViewCell.m
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatViewCell.h"
#import "MPChatTextViewCell.h"
#import "MPChatMessage.h"


# pragma mark ----ChatViewCell----
@interface MPChatTextViewCell ()
{
    __weak IBOutlet UILabel*    _chatTitle;
    __weak IBOutlet UILabel*    _chatMessage;
    __weak IBOutlet UIView *    _parentView;
}

@end


@implementation MPChatTextViewCell

- (void)awakeFromNib
{
    [self addTapOnText];
}


- (void) addTapOnText
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TextTapped:)];
    [_parentView addGestureRecognizer:tap];
}

- (void) TextTapped:(UITapGestureRecognizer*)tapG
{
    [self.delegate onCellChildUIActionForIndex:_index];
}



- (void) updateCellForIndex:(NSUInteger) index
{
    [super updateCellForIndex:index];
    MPChatMessage* msg = [self.delegate getCellModelForIndex:index];
    _chatMessage.text = msg.body;
    
    _parentView.layer.cornerRadius = 20;
}

@end
