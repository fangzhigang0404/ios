//
//  MPMeaInfoHeader.m
//  MarketPlace
//
//  Created by WP on 16/3/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMeaInfoHeader.h"

@interface MPMeaInfoHeader ()

/// name label.
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// status image.
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end

@implementation MPMeaInfoHeader
{
    NSInteger _index;   //!< _index the index for model in datasource.
}

- (void)awakeFromNib {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seletedAndShowNeedInfo)]];
}

- (void)seletedAndShowNeedInfo {
    if ([self.delegate respondsToSelector:@selector(seletedAndShowNeedAtIndex:)]) {
        [self.delegate seletedAndShowNeedAtIndex:_index];
    }
}

- (void)updateMeaInfoHeaderViewAtIndex:(NSInteger)index seleted:(NSInteger)seleted {
    if ([self.delegate respondsToSelector:@selector(getNeedNameStrAtIndex:)]) {
        _index = index;
        self.nameLabel.text = [self.delegate getNeedNameStrAtIndex:index];
        if (index == seleted)
            self.statusImage.image = [UIImage imageNamed:SELETED_YES];
        else
            self.statusImage.image = [UIImage imageNamed:SELETED_NO];
    }
}

@end
