/**
 * @file    MPcerficationView.m
 * @brief   the view of cerfication View  view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPcerficationView.h"
#import "MPcerficationTableViewCell.h"
@interface MPcerficationView ()<UITableViewDataSource, UITableViewDelegate,MPCerficationDelegate>
{
    UITableView *_tableView;
    NSArray *array;
    NSArray *Img;
}
@end

@implementation MPcerficationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
    }
    return self;
}

- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   [_tableView registerNib:[UINib nibWithNibName:@"MPcerficationTableViewCell" bundle:nil] forCellReuseIdentifier:@"CerficationCell"];
    [self addSubview:_tableView];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MPcerficationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CerficationCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 720;
    
}
- (void)Cerfication:(MPcerficationModel *)model withBtn:(UIButton *)btnClick {
    
    [self.delegate CerficationView:model withBtn:btnClick];
    
}
@end
