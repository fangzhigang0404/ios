//
//  MPDeliveryForDesignCell.m
//  MarketPlace
//
//  Created by Jiao on 16/3/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryForDesignCell.h"

@implementation MPDeliveryForDesignCell
{
    __weak IBOutlet UIView *_de_3DBackView;
    __weak IBOutlet UIImageView *_de_3DImgView;
    __weak IBOutlet UIView *_de_renderBackView;
    __weak IBOutlet UIImageView *_de_renderImgView;
    __weak IBOutlet UIView *_de_designBackView;
    __weak IBOutlet UIImageView *_de_designImgView;
    __weak IBOutlet UIView *_de_materialBackView;
    __weak IBOutlet UIImageView *_de_materialImgView;

}
- (void)awakeFromNib {
    UITapGestureRecognizer *tgr1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deliveryDetailClick:)];
    [_de_3DBackView addGestureRecognizer:tgr1];
    UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deliveryDetailClick:)];
    [_de_renderBackView addGestureRecognizer:tgr2];
    UITapGestureRecognizer *tgr3= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deliveryDetailClick:)];
    [_de_designBackView addGestureRecognizer:tgr3];
    UITapGestureRecognizer *tgr4= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deliveryDetailClick:)];
    [_de_materialBackView addGestureRecognizer:tgr4];
    
}

- (void)updateCellForIndex:(NSInteger)index {
    [super updateCellForIndex:index];
    if ([self.delegate respondsToSelector:@selector(updateUI)] && [self.delegate updateUI]) {
        NSDictionary *dict = [self.delegate updateUI];
        _sendBtn.hidden = ![dict[@"isDesigner"] boolValue];
        

        [_de_3DImgView setImage:[UIImage imageNamed:[dict[@"arr_3D"] boolValue]? @"Delivery_3D_2" : @"Delivery_3D_1"]];
        _de_3DBackView.userInteractionEnabled = [dict[@"arr_3D"] boolValue] ? YES : NO;

        [_de_renderImgView setImage:[UIImage imageNamed:[dict[@"arr_render"] boolValue] ? @"Delivery_render_2" : @"Delivery_render_1"]];
        _de_renderBackView.userInteractionEnabled = [dict[@"arr_render"] boolValue] ? YES : NO;

        [_de_designImgView setImage:[UIImage imageNamed:[dict[@"arr_design"] boolValue] ? @"Delivery_design_2" : @"Delivery_design_1"]];
        _de_designBackView.userInteractionEnabled = [dict[@"arr_design"] boolValue] ? YES : NO;

        [_de_materialImgView setImage:[UIImage imageNamed:[dict[@"arr_material"] boolValue] ? @"Delivery_material_2" : @"Delivery_material_1"]];
        _de_materialBackView.userInteractionEnabled = [dict[@"arr_material"] boolValue] ? YES : NO;
    }
}


@end
