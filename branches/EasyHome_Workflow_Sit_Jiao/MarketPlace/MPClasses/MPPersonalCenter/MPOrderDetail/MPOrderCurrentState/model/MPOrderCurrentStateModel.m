/**
 * @file    MPOrderCurrentStateModel.m
 * @brief   the model of current asset status.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-27
 *
 */

#import "MPOrderCurrentStateModel.h"
#import "MPStatusModel.h"

@implementation MPOrderCurrentStateModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (NSArray *)getScheduleData {
    NSString *fileName;
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        fileName = @"MPOrderStateDesigner";
    }else {
        fileName = @"MPOrderStateConsumer";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        MPOrderCurrentStateModel *model = [[MPOrderCurrentStateModel alloc] initWithDictionary:dic];
        [arr addObject:model];
    }
    return arr;
}

+ (void)flashWithStatus:(MPStatusModel *)statusModel
             andSuccess:(void(^)(NSInteger, NSInteger))success {
    NSString *fileName;
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        fileName = @"MPOrderFlashDesigner";
    }else {
        fileName = @"MPOrderFlashConsumer";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSDictionary *dic in array) {
        if ([dic[@"wk_cur_sub_node_id"] isEqualToString:statusModel.workFlowModel.wk_cur_sub_node_id]) {
            if (success) {
                success([dic[@"node_id"] integerValue], [dic[@"flash_id"] integerValue]);
            }
        }
    }

}
@end
