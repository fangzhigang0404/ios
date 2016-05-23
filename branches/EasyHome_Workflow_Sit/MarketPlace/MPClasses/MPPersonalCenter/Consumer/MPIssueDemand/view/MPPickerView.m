/**
 * @file    MPPickerView.m
 * @brief   the cell of table.
 * @author  niu
 * @version 1.0
 * @date    2015-01-20
 */
#import "MPPickerView.h"
#import "MPRegionManager.h"
#import "MPRegionModel.h"

#define MPPickerToobarHeight 40

@interface MPPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

/// the block for choose over.
@property (nonatomic, copy) void (^finish)(NSString *componet1, NSString *componet2, NSString *componet3, BOOL isCancel, NSString *nian);

@end

@implementation MPPickerView
{
    UIPickerView    *_picker;           //!< _picker the pickerView.
    NSInteger        _component;        //!< _component the component of picker.
    NSArray         *_arrayDS;          //!< _arrayDS the datasource of picker.
    NSMutableArray  *_selectedArray;    //!< _selectedArray the array of picker seleted component.
    NSMutableArray  *_arr1;             //!< _arr1 the array of picker first component.
    NSArray         *_arr2;             //!< _arr2 the array of picker sceond component.
    NSMutableArray  *_arr3;             //!< _arr3 the array of picker third component.
    NSString        *_type;             //!< _type the string of picker picker type.
    NSArray         *_nianArray;        //!< _nianArray the array of picker nian.
    NSInteger       _year;
}

- (instancetype)initWithFrame:(CGRect)frame
                    plistName:(NSString *)plistName
                 compontCount:(NSInteger)compont
                      linkage:(BOOL)isLinkage
                       finish:(void(^) (NSString *componet1,
                                        NSString *componet2,
                                        NSString *componet3,
                                        BOOL isCancel,
                                        NSString *nian))finish {

    self = [super initWithFrame:frame];
    if (self) {
        self.finish = finish;
        _component = compont;
        [self initDataWithType:plistName linkage:isLinkage];
        [self initUI];
    }
    return self;
}

- (void)initDataWithType:(NSString *)type linkage:(BOOL)isLinkage {
    _type = type;
    _selectedArray = [NSMutableArray array];
    _arr1 = [NSMutableArray array];
    _arr3 = [NSMutableArray array];
    
    _arrayDS = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:type ofType:@"plist"]];
    
    /// The data type determines the complexity of below
    if (_component == 1){
        [_arr1 addObjectsFromArray:_arrayDS];
    }
    if (_component == 2){
        [_arr1 addObjectsFromArray:_arrayDS];
        _arr2 = _arrayDS[1];
    }
    else if (_component == 3 && !isLinkage) {
        [_arr1 addObjectsFromArray:_arrayDS[0]];
        _arr2 = _arrayDS[1];
        [_arr3 addObjectsFromArray:_arrayDS[2]];
    }
    else if (_component == 3 && isLinkage) {
        
        _arr1 = (id)[[MPRegionManager sharedInstance] getRegionWithType:MPRegionForProvince withParentCode:@"1"];
        MPRegionModel *modelP = _arr1[0];
        _arr2 = [[MPRegionManager sharedInstance] getRegionWithType:MPRegionForCity withParentCode:modelP.code];
        MPRegionModel *modelC = _arr2[0];
        _arr3 = (id)[[MPRegionManager sharedInstance] getRegionWithType:MPRegionForDistrict withParentCode:modelC.code];

    }
    else if (_component == 4) {
        NSInteger curYear = [self getNian];
        _nianArray = @[@(curYear),@(curYear + 1), @(curYear + 2)];
        
        for (NSDictionary *momth in _arrayDS[0]) {
            for (NSString *stringPrince in [momth allKeys]) {
                [_arr1 addObject:stringPrince];
            }
        }
        [_selectedArray addObjectsFromArray:[_arrayDS[0][0] objectForKey:_arr1[0]]];
        if (_selectedArray.count > 0) {
            _arr2 = [NSArray arrayWithArray:_selectedArray];
        }
        [_arr3 addObjectsFromArray:_arrayDS[1]];
    }
}

- (void)initUI {
    [self initPicker];
    
    [self createToolar];
}

- (void)initPicker {
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, MPPickerToobarHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _picker.backgroundColor = [UIColor whiteColor];
    /// set delegate
    _picker.delegate = self;
    _picker.dataSource = self;
    [self addSubview:_picker];
}

- (void)createToolar {
    
    UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), MPPickerToobarHeight)];
    
    UIBarButtonItem *lefttem=[[UIBarButtonItem alloc]
                              initWithTitle:NSLocalizedString(@"cancel_Key", nil)
                              style:UIBarButtonItemStylePlain
                              target:self
                              action:@selector(cancelBarButtonAction)];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:self
                                  action:nil];
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]
                            initWithTitle:NSLocalizedString(@"OK_Key", nil)
                            style:UIBarButtonItemStylePlain
                            target:self
                            action:@selector(finishBarButtonAction)];
    
    toolbar.items=@[lefttem,centerSpace,right];
    
    [self addSubview:toolbar];
}

/// click cancel.
- (void)cancelBarButtonAction {
    if (self.finish) {
        self.finish(nil,nil,nil,YES,nil);
    }
}

/// click finish.
- (void)finishBarButtonAction {
    NSString *str1 = nil;
    NSString *str2 = nil;
    NSString *str3 = nil;
    NSString *strYear = nil;
    if (_component == 1) {
        str1 = [NSString stringWithFormat:@"%@",_arr1[[_picker selectedRowInComponent:0]]];
    } else if (_component == 4) {
        strYear = [NSString stringWithFormat:@"%@",_nianArray[[_picker selectedRowInComponent:0]]];
        str1 = [NSString stringWithFormat:@"%@",_arr1[[_picker selectedRowInComponent:1]]];
        str2 = [NSString stringWithFormat:@"%@",_arr2[[_picker selectedRowInComponent:2]]];
        str3 = [NSString stringWithFormat:@"%@",_arr3[[_picker selectedRowInComponent:3]]];
    }
    else {
        
        if ([_type isEqualToString:@"Property"]) {
            MPRegionModel *modelP = _arr1[[_picker selectedRowInComponent:0]];
            str1 = modelP.code;
            
            MPRegionModel *modelC = _arr2[[_picker selectedRowInComponent:1]];
            str2 = modelC.code;
            
            if (_arr3.count > 0) {
                MPRegionModel *modelD = _arr3[[_picker selectedRowInComponent:2]];
                str3 = modelD.code;
            }
            
        } else {
            str1 = [NSString stringWithFormat:@"%@",_arr1[[_picker selectedRowInComponent:0]]];
            str2 = [NSString stringWithFormat:@"%@",_arr2[[_picker selectedRowInComponent:1]]];
            str3 = [NSString stringWithFormat:@"%@",_arr3[[_picker selectedRowInComponent:2]]];
        }
    }
    if (self.finish) {
        self.finish(str1,str2,str3,NO,strYear);
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _component;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_component == 4) {
        if (component == 0) {
            return _nianArray.count;
        }else if (component == 1) {
            return _arr1.count;
        }else if (component == 2) {
            return _arr2.count;
        } else {
            return _arr3.count;
        }
    }
    
    if (component == 0) {
        return _arr1.count;
    }else if (component == 1) {
        return _arr2.count;
    } else {
        return _arr3.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([_type isEqualToString:@"Property"]) {
        MPRegionModel *model;
        if (component == 0) {
            model = _arr1[row];
        } else if (component == 1) {
            model = _arr2[row];
        } else {
            model = _arr3[row];
        }
        return model.region_name;
        
    } else if (_component == 4) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%@%@",_nianArray[row],NSLocalizedString(@"nian", nil)];
        } else if (component == 1) {
            return _arr1[row];
        } else if (component == 2) {
            return _arr2[row];
        } else {
            return _arr3[row];
        }
        
    } else {
        if (component == 0) {
            return _arr1[row];
        } else if (component == 1) {
            return _arr2[row];
        } else {
            return _arr3[row];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (_component == 4) {
        return width / 4;

    }else {
        return width/3;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([_type isEqualToString:@"Property"]) {
        if (component == 0) {
            MPRegionModel *modelP = _arr1[row];
            _arr2 = [[MPRegionManager sharedInstance]getRegionWithType:MPRegionForCity withParentCode:modelP.code];
            MPRegionModel *modelC = _arr2[0];
            _arr3 = (id)[[MPRegionManager sharedInstance]getRegionWithType:MPRegionForDistrict withParentCode:modelC.code];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        
        if (component == 1) {
            MPRegionModel *modelC = _arr2[row];
            _arr3 = (id)[[MPRegionManager sharedInstance]getRegionWithType:MPRegionForDistrict withParentCode:modelC.code];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];

    } else if ([_type isEqualToString:@"MeasureTime"]) {
        if (component == 0) {
            _year = [_nianArray[row] integerValue];
            [self changeTimeData:[_picker selectedRowInComponent:1]];
        }
        if (component == 1) {
            [self changeTimeData:row];
        }
        [pickerView selectedRowInComponent:0];
        [pickerView reloadAllComponents];
    }
}

- (void)changeTimeData:(NSInteger)row {
    [_selectedArray removeAllObjects];
    [_selectedArray addObjectsFromArray:_arrayDS[0][row][_arr1[row]]];
    
    if (![self isRunNian:_year]) {
        if (row == 1) {
            [_selectedArray removeLastObject];
        }
    }
    
    if (_selectedArray.count > 0)
        _arr2 = _selectedArray;
    else
        _arr2 = nil;

}

/// Get the current time.
- (NSInteger)getNian {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    return [[formatter stringFromDate:[NSDate date]] integerValue];
}

- (BOOL)isRunNian:(NSInteger)nian {
    if ((nian % 4 == 0 && nian % 100 != 0) || nian % 400 == 0) {
        return YES;
    }
    return NO;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark- Public interface methods
- (void)removePickerView {
    [self removeFromSuperview];
}

@end
