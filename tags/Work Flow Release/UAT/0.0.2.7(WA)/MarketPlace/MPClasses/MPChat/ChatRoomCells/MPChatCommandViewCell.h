//
//  CommandViewCell.h
//  tests
//
//  Created by Avinash Mishra on 02/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPChatViewCell;

@protocol CommandDelegate <NSObject>

- (void) commandIssuedAtIndex:(NSUInteger) integer;

@end

@interface MPChatCommand : NSObject
///commandDelegate The commandDelegate is delegate of CommandDelegate protocol.
@property (nonatomic) id<CommandDelegate> commandDelegate;
///noOfCommandButton.
@property (nonatomic) NSUInteger noOfCommandButton;
///commandButtonTexts The commandButtonTexts is command button texts array.
@property (nonatomic, retain) NSArray* commandButtonTexts;

@end

@interface MPChatCommandViewCell : MPChatViewCell


@end
