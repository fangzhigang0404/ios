//
//  ToolChatView.m
//  tests
//
//  Created by Avinash Mishra on 05/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPToolChatView.h"
#import "MPAlertView.h"

#define TextViewParentHeight 60
#define ToolViewParentHeight 60

#define TextViewTopBottamMargin 25

#define FourLineHeight 84    //!< OneLineHeight the height of one line which belongs to TextView.

#define MaxCharactersAllowed 1000

@interface MPToolChatView () <UITextViewDelegate>
{
    BOOL    _isRecording;
    BOOL    _toolViewNeeded;
    CGFloat _viewOriginalYPosition;
    
    __weak IBOutlet UITextView*     _textView;
    __weak IBOutlet UIButton*       _toolButton;
    __weak IBOutlet UIButton*       _audiobutton;
    __weak IBOutlet UILabel*        _AudioRecordLabel;

    __weak IBOutlet UIButton*       _galleryButton;
    __weak IBOutlet UIButton*       _cameraButton;
    __weak IBOutlet UIButton*       _customButton;

    __weak IBOutlet UIView*         _chatView;
    __weak IBOutlet UIView*         _toolView;

    __weak IBOutlet NSLayoutConstraint*     _chatViewHeightConstraints;
    __weak IBOutlet NSLayoutConstraint*     _parentViewBottomMargin;

    __weak IBOutlet NSLayoutConstraint*     _camerabuttonCenterConstraint;
    __weak IBOutlet NSLayoutConstraint*     _cameraButtonTrailingConstraint;
    
    UITapGestureRecognizer*                 _toolViewHideGestureRecogniser;
}


@property (nonatomic, readwrite) BOOL isToolViewHidden;

@end



@implementation MPToolChatView


@synthesize isToolViewHidden;


- (void) awakeFromNib
{
    CGFloat borderWidth = 1.0f;
    self.isToolViewNeeded = NO;
    self.isToolViewHidden = YES;
    _toolView.hidden = self.isToolViewHidden;
    
//    _textView.layer.cornerRadius = 5;
    _textView.layer.borderColor = [UIColor colorWithRed:0.77 green:0.78 blue:0.78 alpha:1.0].CGColor;
    _textView.layer.borderWidth = borderWidth;

//    _AudioRecordLabel.layer.cornerRadius = 5;
    _AudioRecordLabel.layer.borderColor = [UIColor colorWithRed:0.77 green:0.78 blue:0.78 alpha:1.0].CGColor;
    _AudioRecordLabel.layer.borderWidth = borderWidth;
    
    _chatView.layer.borderWidth = 1.0;
    _chatView.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0].CGColor;

    _toolView.layer.borderWidth = 1.0;
    _toolView.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0].CGColor;
    _toolViewHideGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideToolViewOntapOutside:)];
    _toolViewHideGestureRecogniser.numberOfTapsRequired = 1;
}


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


- (void) dealloc
{
//    NSLog(@"MPToolChatView Dealloc");
}


#pragma mark --------Public/Private method-------------

- (void) changeCustomButtonIconWithImage:(NSString*)image
{
    if (image)
    {
        _customButton.hidden = NO;
        [NSLayoutConstraint deactivateConstraints:@[_cameraButtonTrailingConstraint]];
        [NSLayoutConstraint activateConstraints:@[_camerabuttonCenterConstraint]];
        [_customButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    else
    {
        _customButton.hidden = YES;
        [NSLayoutConstraint activateConstraints:@[_cameraButtonTrailingConstraint]];
        [NSLayoutConstraint deactivateConstraints:@[_camerabuttonCenterConstraint]];
    }
}


- (void) hideKeyboardFromToolChatView
{
    [_textView resignFirstResponder];
}


- (void) setIsToolViewNeeded:(BOOL)toolViewNeeded
{
    _toolViewNeeded = toolViewNeeded;
    _toolButton.hidden = !toolViewNeeded;
    if (!_toolViewNeeded)
        [self hideToolView:YES];
}


- (void) hideToolButton:(BOOL)hideToolButton {
    _toolButton.hidden = hideToolButton;
}

- (BOOL) isToolViewNeeded
{
    return _toolViewNeeded;
}


- (void) hideToolView:(BOOL) hideToolView
{
    [self.superview removeGestureRecognizer:_toolViewHideGestureRecogniser];
    if (!self.isToolViewNeeded)
        hideToolView = YES;
    
    self.isToolViewHidden = hideToolView;
    [self.superview layoutIfNeeded];
    _parentViewBottomMargin.constant = self.isToolViewHidden ? -ToolViewParentHeight : 0;
    _toolView.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        _toolView.hidden = self.isToolViewHidden;
    }];
}

- (void) resetAudioButton
{
    if (_isRecording)
    {
        _isRecording = NO;
        _textView.hidden = NO;
        _AudioRecordLabel.hidden = YES;
        [_audiobutton setImage:[UIImage imageNamed:@"audioButton"] forState:UIControlStateNormal];
    }
    else
    {
        _isRecording = YES;
        _textView.hidden = YES;
        _AudioRecordLabel.hidden = NO;
        _AudioRecordLabel.text = NSLocalizedString(@"Audio_Record_Message", @"Press and hold to talk") ;
        [_audiobutton setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
    }
    
}


- (void) cancelRecording
{
    //    [self resetAudioButton];
}


- (void) showMaxcharacterLimitReachAlert
{
    [MPAlertView showAlertWithMessage:NSLocalizedString(@"Max_Char_Limit_Reach", @"Max Char Limit Reach") sureKey:^
     {
         
     }];
    
}


#pragma mark --------EventHandler-------------

- (IBAction) hideToolViewOntapOutside:(id)sender
{
    [self hideToolView:YES];
}


- (IBAction)audioButtonPressed:(id)sender
{
    [self resetAudioButton];
    [_textView resignFirstResponder];
}

- (IBAction)toolButtonaPressed:(id)sender
{
    if (!self.isToolViewNeeded)
    {
        _toolView.hidden = YES;
        _parentViewBottomMargin.constant = -ToolViewParentHeight;
        if ([self.delegate respondsToSelector:@selector(toolViewPlusButtonClicked)])
        {
            [self.delegate toolViewPlusButtonClicked];
        }
    }
    else
    {
        [self hideToolView:!self.isToolViewHidden];
        [self.superview addGestureRecognizer:_toolViewHideGestureRecogniser];
    }

    _textView.hidden = NO;
    _AudioRecordLabel.hidden = YES;
    [_audiobutton setImage:[UIImage imageNamed:@"audioButton"] forState:UIControlStateNormal];
    [_textView resignFirstResponder];
}


- (IBAction)galleryButtonPresssed:(id)sender
{
    _textView.hidden = NO;
    _AudioRecordLabel.hidden = YES;
    [_textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(selectImageButtonClicked)])
    {
        [self.delegate selectImageButtonClicked];
    }
}

- (IBAction)cameraButtonPressed:(id)sender
{
    _textView.hidden = NO;
    _AudioRecordLabel.hidden = YES;
    [_textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(openCameraButtonClicked)])
    {
        [self.delegate openCameraButtonClicked];
    }
}


- (IBAction)customButtonPressed:(id)sender
{
    _textView.hidden = NO;
    _AudioRecordLabel.hidden = YES;
    [_textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(customActionButtonClicked)])
    {
        [self.delegate customActionButtonClicked];
    }
}


#pragma mark ----------- TextViewDelegate Methods ---------------
///Send my messages.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    ///To determine whether the input of the word is "enter".
    if ([text isEqualToString:@"\n"])
    {
        // Cannot send message with empty text field
        if (textView.text.length == 0)
            return NO;
        
        if ([self.delegate respondsToSelector:@selector(textViewDidSendText:)])
        {
            [self.delegate textViewDidSendText:_textView.text];
        }

        textView.text = @"";
        if (_chatViewHeightConstraints.constant > TextViewParentHeight)
        {
            _chatViewHeightConstraints.constant = TextViewParentHeight;
            [self setNeedsUpdateConstraints];
            [self layoutIfNeeded];
        }
        return NO;
    }
    else
    {
        // Don't allow editing after the user enters Max Characters Allowed
        if ((textView.text.length - range.length + text.length) > MaxCharactersAllowed)
        {
            [self showMaxcharacterLimitReachAlert];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    ///Change the frame of textView and bottomView when line number more than four lines
    CGRect textRect = self.frame;
    if (textView.contentSize.height != textRect.size.height)
    {
        if (textView.contentSize.height > FourLineHeight)
            return;
        
        if ((textView.contentSize.height + TextViewTopBottamMargin) <= TextViewParentHeight) return;
        
        _chatViewHeightConstraints.constant = textView.contentSize.height + TextViewTopBottamMargin;
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
    }
}


#pragma mark ----------- Touch methods Methods ---------------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (!_isRecording)
    {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:_textView];
    if (pt.x > 0 && pt.x < _textView.frame.size.width && pt.y > 0 && pt.y < _textView.frame.size.height)
    {
        if ([self.delegate respondsToSelector:@selector(startRecording)])
            [self.delegate startRecording];

        _AudioRecordLabel.text = NSLocalizedString(@"Audio_Record_Cancel_message",  @"Cacel to move outside");
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (!_isRecording)
    {
        [super touchesBegan:touches withEvent:event];
        return;
    }

    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:_textView];
    if (pt.x > 0 && pt.x < _textView.frame.size.width && pt.y > 0 && pt.y < _textView.frame.size.height)
        NSLog(@"");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (!_isRecording)
    {
        [super touchesBegan:touches withEvent:event];
        return;
    }

//    [self resetAudioButton];
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:_textView];

    if (pt.x > 0 && pt.x < _textView.frame.size.width && pt.y > 0 && pt.y < _textView.frame.size.height)
    {
        if ([self.delegate respondsToSelector:@selector(stopRecording)])
            [self.delegate stopRecording];

    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(cancelRecording)])
            [self.delegate cancelRecording];
    }

    _AudioRecordLabel.text = NSLocalizedString(@"Audio_Record_Message", @"Press and hold to talk") ;
    NSLog(@" touchesEnded ");
}


- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (!_isRecording)
    {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
//    [self resetAudioButton];
    if ([self.delegate respondsToSelector:@selector(cancelRecording)])
        [self.delegate cancelRecording];

    _AudioRecordLabel.text = NSLocalizedString(@"Audio_Record_Message", @"Press and hold to talk") ;
    NSLog(@" touchesCancelled ");
}


@end
