//
//  MPDeliveryDetailCell.m
//  MarketPlace
//
//  Created by Jiao on 16/3/24.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryDetailCell.h"
#import <UIImageView+WebCache.h>
#import "MPDeliveryDownload.h"

@implementation MPDeliveryDetailCell
{
    __weak IBOutlet UIButton *_selectBtn;
    __weak IBOutlet UIImageView *_deImageView;
    __weak IBOutlet UILabel *_deTitleLabel;
    NSInteger _index;
    __weak IBOutlet UILabel *_percentLabel;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
    [_deImageView addGestureRecognizer:tgr];
}

- (void)updateCellForIndex:(NSInteger)index withcType:(NSInteger)cType {
    _index = index;
    _selectBtn.hidden = ([AppController AppGlobal_GetIsDesignerMode] && (cType == 1 || cType == 2))? NO : YES;
    if ([self.delegate respondsToSelector:@selector(getDataFromIndex:withBlock:)]) {
        [self.delegate getDataFromIndex:index withBlock:^(MPDeliveryDetailType type, id model, BOOL isSelected) {
            NSString *titleStr;
            NSString *imgSel;
            NSString *imgUnSel;
            
            NSString *imgURL;
            if (type == DeTypeForMy3D) {
                MP3DPlanModel *tempModel = model;
                imgUnSel = @"Nosele";
                imgSel = @"Sele";
                titleStr = [self judgeNULL:tempModel.design_name];
                imgURL =tempModel.link;
            }else {
                MP3DPlanDetailModel *tempModel = model;
                imgUnSel = @"seleted_no";
                imgSel = @"seleted_yes";
                titleStr = [self judgeNULL:tempModel.name];
                imgURL =tempModel.link;
            }
            [MPDeliveryDownload downloadFilesWithLink:imgURL withProgress:^(NSString *percent) {
                _percentLabel.text = percent;
            } withSuccess:^(NSURL *filePath) {
                _percentLabel.hidden = YES;
                NSLog(@"filePath: %@",[filePath absoluteString]);
                _deImageView.userInteractionEnabled = YES;
                if ([[self judgeFile:imgURL] isEqualToString:@""]) {
                    [_deImageView setImage:[UIImage imageWithContentsOfFile:filePath.path]];
                }else {
                    [_deImageView setImage:[UIImage imageNamed:[self judgeFile:imgURL]]];
                }
 
            } andFailure:^(NSError *error) {
                NSLog(@"下载3D方案图片失败");
            }];
            
            [_selectBtn setImage:[UIImage imageNamed:imgUnSel] forState:UIControlStateNormal];
            [_selectBtn setImage:[UIImage imageNamed:imgSel] forState:UIControlStateSelected];
            _selectBtn.selected = isSelected;
            _deTitleLabel.text = titleStr;
            
        }];
    }
}

- (NSString *)judgeNULL:(NSString *)str {
    if ([str isEqualToString:@""] || [str isKindOfClass:[NSNull class]] || str == nil || [str rangeOfString:@"null"].location != NSNotFound ) {
        str = @"未命名";
    }
    return str;
}

- (NSString *)judgeFile:(NSString *)link {
    if ([link hasSuffix:@".doc"] || [link hasSuffix:@".docx"]) {
        return @"delivery_word";
    }
    if ([link hasSuffix:@".xls"] || [link hasSuffix:@".xlsx"]) {
        return @"delivery_excel";
    }
    if ([link hasSuffix:@".pdf"]) {
        return @"delivery_pdf";
    }
    return @"";
}

- (IBAction)selectBtnClick:(id)sender {
    _selectBtn.selected = !_selectBtn.selected;
    [self.delegate selectItemIndex:_index withSelected:_selectBtn.selected];
}

- (void)tapImageView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(tapDeliveryImgViewForIndex:)]) {
        [self.delegate tapDeliveryImgViewForIndex:_index];
    }
}


@end
