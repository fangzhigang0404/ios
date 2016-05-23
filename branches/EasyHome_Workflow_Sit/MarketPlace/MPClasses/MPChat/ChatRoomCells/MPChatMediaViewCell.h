//
//  CustomTableViewCell.h
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPChatViewCell;

@protocol CustomImageViewDelegate <NSObject>
/**
 *  @brief did click image.
 *
 *  @return void nil.
 */
- (void)didClickImage;

@end

@interface CustomImageView : UIView

@property (nonatomic, assign) id<CustomImageViewDelegate>delegate;


@end



@interface MPChatMediaViewCell : MPChatViewCell

@end
