//
//  MPChatRoomView.m
//  tests
//
//  Created by Avinash Mishra on 05/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//


#import "MPChatRoomView.h"

#import "MPChatViewCell.h"
#import "MPChatTextViewCell.h"
#import "MPChatImageViewCell.h"
#import "MPChatCommandViewCell.h"
#import "MPChatMessage.h"
#import "MPToolChatView.h"
#import "MPLoadMoreHeaderView.h"

#import "MPAlertView.h"

#define BottamViewToolHeight 60



@interface MPChatRoomView () <UITableViewDataSource, UITableViewDelegate, CommandDelegate, MPLoadMoreHeaderViewDelegate>
{
    BOOL                                        _isChatEnable;
    BOOL                                        _isToolBarNeeded;
    __weak id <MPToolChatViewDelegate>          _toolChatdelegate;
    
    __weak IBOutlet UITableView*                _tableView;
    __weak IBOutlet MPToolChatView*             _bottomView;
    __weak IBOutlet NSLayoutConstraint*         _bottomViewBottomConstraints;

    CGFloat                                     _activeKeyboardHeight;
    
    __strong IBOutlet MPLoadMoreHeaderView*     _tableViewHeaderView;
    __strong IBOutlet RecordingActiveView*      _recordingActiveView;
    __strong IBOutlet UIButton*                 _closedThread;

    UITapGestureRecognizer*                     _keyboardHideGestureRecogniser;
}


@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlay;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;


@end


@implementation MPChatRoomView

@dynamic isChatEnable;
@dynamic isToolBarNeeded;


- (void) awakeFromNib
{
    [self intializeChatView];
}


- (void) intializeChatView
{
    [self registerCells];
    [self registerForKeyboardNotifications];


    self.isChatEnable = YES;
    _tableViewHeaderView.delegate = self;
    _bottomView.delegate = _toolChatdelegate;
    _bottomView.isToolViewNeeded = _isToolBarNeeded;
}


- (void)updateTableContentInset
{
    NSInteger numRows = [self tableView:_tableView numberOfRowsInSection:0];
    CGFloat contentInsetTop = _tableView.bounds.size.height;
    for (NSInteger i = 0; i < numRows; i++) {
        contentInsetTop -= [self tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (contentInsetTop <= 0) {
            contentInsetTop = 0;
            break;
        }
    }
    _tableView.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0);
}



- (void) initializeRecordingViewConstraint
{
    _recordingActiveView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_recordingActiveView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_recordingActiveView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_recordingActiveView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_recordingActiveView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self  attribute:NSLayoutAttributeCenterY multiplier:1 constant:-BottamViewToolHeight]];
}


- (void) registerCells
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
    {
        _tableView.estimatedRowHeight = 1000;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatTextViewCell_left" bundle:nil] forCellReuseIdentifier:@"MPChatTextViewCell_left"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatImageViewCell_left" bundle:nil] forCellReuseIdentifier:@"MPChatImageViewCell_left"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatMediaViewCell_left" bundle:nil] forCellReuseIdentifier:@"MPChatMediaViewCell_left"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatAudioViewCell_left" bundle:nil] forCellReuseIdentifier:@"MPChatAudioViewCell_left"];

    [_tableView registerNib:[UINib nibWithNibName:@"MPChatTextViewCell_right" bundle:nil] forCellReuseIdentifier:@"MPChatTextViewCell_right"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatImageViewCell_right" bundle:nil] forCellReuseIdentifier:@"MPChatImageViewCell_right"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatMediaViewCell_right" bundle:nil] forCellReuseIdentifier:@"MPChatMediaViewCell_right"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatAudioViewCell_right" bundle:nil] forCellReuseIdentifier:@"MPChatAudioViewCell_right"];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatCommandViewCell" bundle:nil] forCellReuseIdentifier:@"MPChatCommandViewCell"];

    _keyboardHideGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    _keyboardHideGestureRecogniser.numberOfTapsRequired = 1;
    [self registerForKeyboardNotifications];
}


- (id <MPToolChatViewDelegate>) toolChatdelegate
{
    return _toolChatdelegate;
}


- (void) setToolChatdelegate:(id <MPToolChatViewDelegate>) delegate
{
    _toolChatdelegate = delegate;
    _bottomView.delegate = delegate;
}


- (id <RecordingActiveViewDelegate>) recordingActiveViewDelegate
{
    return _recordingActiveView.delegate;
}


- (void) setRecordingActiveViewDelegate:(id <RecordingActiveViewDelegate>) delegate
{
    _recordingActiveView.delegate = delegate;
}



- (BOOL) isToolBarNeeded
{
    return _isToolBarNeeded;
}

#pragma mark - 隐藏toolbutton
- (void) setIsToolBarNeeded:(BOOL)isToolBarNeeded
{
    _isToolBarNeeded = isToolBarNeeded;
    _bottomView.isToolViewNeeded = isToolBarNeeded;
}

- (BOOL) isChatEnable
{
    return _isChatEnable;
}


- (void) setIsChatEnable:(BOOL)isChatEnable
{
    _isChatEnable = isChatEnable;
    if (!isChatEnable)
    {
        _bottomViewBottomConstraints.constant = _activeKeyboardHeight - 2 * BottamViewToolHeight;
        _bottomView.hidden = YES;
    }
    else
    {
        _bottomViewBottomConstraints.constant = _activeKeyboardHeight - 1 * BottamViewToolHeight;
        _bottomView.hidden = NO;
    }
}


- (IBAction)hideKeyBoard:(id)sender
{
    [self endEditing:YES];
    [self hideToolView];
    [_bottomView hideKeyboardFromToolChatView];
}


- (IBAction) goToRecentButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(openChatRoomWithActiveThread)])
        [self.delegate openChatRoomWithActiveThread];
    NSLog(@"Go to recent Thread button Clicked");
}


- (void) showChatClosedButton:(BOOL) isShow
{
    _closedThread.hidden = !isShow;
    _bottomView.hidden = isShow;
    if (isShow)
    {
        [self hideKeyBoard:nil];
        _bottomViewBottomConstraints.constant = -BottamViewToolHeight;
    }
    _closedThread.layer.cornerRadius = 10.0;
    [_closedThread setTitle:NSLocalizedString(@"Go_To_Recent_chat", @"Go to the recent chat") forState:UIControlStateNormal];
    [self bringSubviewToFront:_closedThread];
}



#pragma mark -----UIUpdate methods Methods------

- (void) changeCustomButtonIconWithImage:(NSString*)image
{
    [_bottomView changeCustomButtonIconWithImage:image];
}

- (void) hideToolView;
{
    if (self.isChatEnable && self.isToolBarNeeded)
        [_bottomView hideToolView:YES];
}


- (void) intitializeRecordingView
{
    if (!_recordingActiveView.superview)
    {
        [self addSubview:_recordingActiveView];
        [self initializeRecordingViewConstraint];
        [_recordingActiveView initializeView];
    }
    _recordingActiveView.hidden = NO;
    [self bringSubviewToFront:_recordingActiveView];
}


- (void) recordingStarted
{
    _recordingActiveView.hidden = NO;
    _recordingActiveView.center = self.superview.center;
    [self intitializeRecordingView];
}


- (void) recordingEnded
{
    [self intitializeRecordingView];
    [_recordingActiveView recordingCompleted];
}

- (void) cancelRecordView
{
    [_bottomView cancelRecording];
    [self mediaMessageSendingSuccess];
}


- (void) mediaMessageSendingFail
{
    _recordingActiveView.hidden = YES;
    [_recordingActiveView recordingFailedToSend];
}


- (void) mediaMessageSendingSuccess
{
    _recordingActiveView.hidden = YES;
    _recordingActiveView.center = self.center;
    [_recordingActiveView removeFromSuperview];
   
    [self scrollToEnd];
}


#pragma mark -----TableViewUpdate methods Methods------


- (void) clearMessagesAndReloadTable
{
    [_tableView reloadData];
    [self scrollToEndInternal];
}


- (void) insertMessagesInStartWithIndexPaths:(NSArray*) indexPaths
{
    [_tableViewHeaderView stopIndicator];
    _tableView.tableHeaderView = nil;
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPaths.count - 1  inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


- (void) appendMessagesAtEndWithIndexPaths:(NSArray*) indexPaths
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^
     {
         [self scrollToEnd];
     }];

    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    
    [CATransaction commit];
}


- (void) updateMessageCellWithIndexPaths:(NSArray*) indexPaths
{
    for (NSIndexPath* indexPath in indexPaths)
    {
        MPChatViewCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
        if (cell)
            [cell updateCellForIndex:cell.index];
    }
}


- (void) scrollToEnd
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
       if ([self.delegate numberOfMessages] > 0)
           [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.delegate numberOfMessages] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   });
}


- (void) scrollToEndInternal
{
    if ([self.delegate numberOfMessages] > 0)
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.delegate numberOfMessages] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark -----TableViewDelegate Methods------


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
    {
        return UITableViewAutomaticDimension;
    }

    return [self.delegate heightForCellForIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate numberOfMessages];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPChatViewCell* cell = [self.delegate getCellFromTable:tableView withIndex:indexPath.row];
    cell.delegate = self.chatViewCellDelegate;
    [cell updateCellForIndex:indexPath.row];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndex:)])
        [self.delegate didSelectRowAtIndex:indexPath.row];
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfMessage = [self.delegate numberOfMessages];
    NSInteger totalNumberOfMessage = [self.delegate totalNumberOfmessages];
    if (totalNumberOfMessage && (totalNumberOfMessage > numberOfMessage) && indexPath.row == 0)
    {
        _tableViewHeaderView.frame = CGRectMake(0, 0, tableView.frame.size.width, 60);
        _tableViewHeaderView.delegate = self;
        _tableView.tableHeaderView = _tableViewHeaderView;
    }
}


- (void) loadMoreData
{
    if ([self.delegate totalNumberOfmessages] != [self.delegate numberOfMessages])
    {
        [_tableViewHeaderView startIndicator];
        [self.delegate retrieveNextPageOfThreadMessages];
    }
}


#pragma mark --- Cell Delegate Methods


- (void) commandIssuedAtIndex:(NSUInteger) integer
{
    
}


#pragma mark --- Keyboard notifications

/// This is required to be called when the frame of the table view is affected by constraints
- (void) reloadTable
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [_tableView reloadData];
                       [self scrollToEndInternal];
                   });

}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification*)aNotification
{
    [_tableView addGestureRecognizer:_keyboardHideGestureRecogniser];
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    _activeKeyboardHeight = kbSize.height;
    _bottomViewBottomConstraints.constant = _activeKeyboardHeight - BottamViewToolHeight;
    
    
    [self reloadTable];
    [self setNeedsUpdateConstraints];
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_tableView removeGestureRecognizer:_keyboardHideGestureRecogniser];
    _activeKeyboardHeight = 0;
    _bottomViewBottomConstraints.constant = _activeKeyboardHeight - BottamViewToolHeight;
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [_tableView reloadData];
                       [self scrollToEndInternal];
                   });
}


-(void)dealloc
{
//    NSLog(@"MPChatRoomView Dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation RecordingActiveView


- (void) awakeFromNib
{
    [self initializeView];
}

- (void) initializeView
{
    self.activityIndicatorImageView.animationImages = nil;
    self.activityIndicatorImageView.hidden = YES;
    self.audioRecordImage.hidden = NO;
    self.recordingLabel.text = @"";///NSLocalizedString(@"Recording_Active", @"Recording Active");
    
   
}


- (void) recordingCompleted
{
    self.activityIndicatorImageView.hidden = YES;
    self.audioRecordImage.hidden = YES;
    
//    [self.activityIndicator startAnimating];
//    [self animateImageView];
    self.recordingLabel.text = NSLocalizedString(@"Sending_Audio", @"Sending Audio");
}



- (void) recordingFailedToSend
{
    WS(weakSelf);
    [MPAlertView showAlertWithMessage:NSLocalizedString(@"Retry_send_Audio", @"Retry send Audio") sureKey:^{
        [weakSelf retrySendingAudio:nil];
    } cancelKey:^{
        [weakSelf cancelAudio:nil];
    }];
    self.activityIndicatorImageView.animationImages = nil;
    self.activityIndicatorImageView.hidden = YES;
    self.audioRecordImage.hidden = NO;
    self.recordingLabel.text = @"";
}


- (IBAction)cancelAudio:(id)sender
{
    [self.delegate cancelButtonClicked];
}


- (IBAction)retrySendingAudio:(id)sender
{
    [self.delegate retryButtonClicked];
}



- (void) animateImageView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityIndicatorImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"LOADING-1"], [UIImage imageNamed:@"LOADING-2"], [UIImage imageNamed:@"LOADING-3"], [UIImage imageNamed:@"LOADING-4"], nil];
        self.activityIndicatorImageView.animationDuration = 1;
        self.activityIndicatorImageView.animationRepeatCount = INFINITY;
        [self.activityIndicatorImageView startAnimating];
    });
}


@end
