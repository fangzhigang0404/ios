//
//  MPCaseScreenTableViewCell.m
//  MarketPlace
//
//  Created by xuezy on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPCaseScreenTableViewCell.h"
#define Start_X 20.0f           // 第一个按钮的X坐标
#define Start_Y 10.0f           // 第一个按钮的Y坐标
#define Width_Space 30.0f        // 2个按钮之间的横间距
#define Height_Space 20.0f      // 竖间距
#define Button_Height 30.0f    // 高
#define Button_Width ([UIScreen mainScreen].bounds.size.width - 100)/3      // 宽
@interface MPCaseScreenTableViewCell ()
{
    UIButton *selectedButton;
}

@property (nonatomic,copy)NSString *typeTitle;
@end

@implementation MPCaseScreenTableViewCell

-(void) updateCellForIndex:(NSArray *) array withTitle:(NSString *)title andSelectIndes:(NSInteger)selectIndex {
    
    self.typeTitle = title;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
        
    for (NSInteger i = 0; i<array.count; i++) {
        NSInteger index = i%3;
        NSInteger page = i/3;
        
        // 圆角按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [button setTitleColor:ColorFromRGA(0x0084ff, 1) forState:UIControlStateSelected];
        button.tag = 100*i;
        if (i == selectIndex) {
            button.selected = YES;
            button.layer.borderColor = ColorFromRGA(0x0084ff, 1).CGColor;
            selectedButton = button;

        }else{
            
            button.layer.borderColor = ColorFromRGA(0xD7D7D7, 1).CGColor;
            

        }
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5;
        button.layer.borderWidth = 1;
        [self.contentView addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)button {
    
    
  if (selectedButton == button){
        selectedButton.selected = YES;
        selectedButton.layer.borderColor = ColorFromRGA(0x0084ff, 1).CGColor;
        [selectedButton setTitleColor:ColorFromRGA(0x0084ff, 1) forState:UIControlStateNormal];
    }
    else {
        selectedButton.selected = NO;
        selectedButton.layer.borderColor = ColorFromRGA(0xD7D7D7, 1).CGColor;
        [selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        selectedButton = button;
        selectedButton.selected = YES;
        selectedButton.layer.borderColor = ColorFromRGA(0x0084ff, 1).CGColor;
        [selectedButton setTitleColor:ColorFromRGA(0x0084ff, 1) forState:UIControlStateNormal];
    }
    
   
    if ([self.delegate respondsToSelector:@selector(cellWithSelectedIndex:andCellSection:)]) {
        [self.delegate cellWithSelectedIndex:button.tag/100 andCellSection:self.cellSection];
        
        if ([self.delegate respondsToSelector:@selector(selectType:type:)]) {
            [self.delegate selectType:selectedButton.titleLabel.text type:self.typeTitle];
        }
    }
    
   

    
}
- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
