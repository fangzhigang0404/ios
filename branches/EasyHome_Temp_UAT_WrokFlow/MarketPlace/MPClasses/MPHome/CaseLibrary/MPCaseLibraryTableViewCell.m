/**
 * @file    MPCaseLibraryTableViewCell.m
 * @brief   the frame of MPCaseLibraryViewController.
 * @author  Xue
 * @version 1.0
 * @date    2016-2-19
 */

#import "MPCaseLibraryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MPCaseModel.h"
#import "MPCaseTool.h"

@interface MPCaseLibraryTableViewCell()

@property (weak, nonatomic)IBOutlet UIImageView *caseImageview;  
@property (assign, nonatomic)NSInteger index;

@end
@implementation MPCaseLibraryTableViewCell

-(void) updateCellForIndex:(NSUInteger) index
{
    if ([self.delegate respondsToSelector:@selector(getCaseLibraryModelForIndex:)])
    {
        self.index = index;
        MPCaseModel *model = [self.delegate getCaseLibraryModelForIndex:self.index];
        
        [MPCaseTool showCaseImage:_caseImageview
                        caseArray:model.images];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
