//
//  MPCaseTool.m
//  MarketPlace
//
//  Created by WP on 16/4/1.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPCaseTool.h"
#import "MPCaseModel.h"
#import "UIImageView+WebCache.h"

@implementation MPCaseTool

+ (void)showCaseImage:(UIImageView *)imaegView
            caseArray:(NSArray *)array {
    
    BOOL has_primary = NO;
    NSString *imageOneUrl;
    if (array.count > 0) {
        
        for (NSInteger i = 0; i < array.count; i++) {
            MPCaseImageModel *modelImage = array[i];
            if (i == 0)
                imageOneUrl = modelImage.file_url;
            
            if (modelImage.is_primary) {
                has_primary = YES;
                [imaegView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@HD.jpg",modelImage.file_url]] placeholderImage:[UIImage imageNamed:HOUSE_DEFAULT_IMAGE]];
            }
        }
        if (!has_primary)
            [imaegView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@HD.jpg",imageOneUrl]] placeholderImage:[UIImage imageNamed:HOUSE_DEFAULT_IMAGE]];
    } else {
        imaegView.image = [UIImage imageNamed:HOUSE_DEFAULT_IMAGE];
    }

}

@end
