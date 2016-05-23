//
//  MPProjectMaterialListViewController.m
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/24/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPProjectMaterialListViewController.h"
#import "MPModel.h"
#import "MPProjectMaterials.h"
#import "MPProjectMaterial.h"

@interface MPProjectMaterialListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* _materials;
    NSString* _assetId;
    
    __weak IBOutlet UITableView *_materialTableView;
    __weak IBOutlet UIActivityIndicatorView *_busyWheel;
}

@end

@implementation MPProjectMaterialListViewController


- (id) initWithAssetId:(NSString *)assetId
{
    self = [super initWithNibName:@"MPProjectMaterialListViewController"
                           bundle:nil];
    
    if (self)
    {
        _assetId = assetId;
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"Project_Material_Title", @"Project Information");
    _materialTableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
//    _materialTableView.delegate = self;
//    _materialTableView.dataSource = self;
//    [self.view addSubview:_materialTableView];
    [_busyWheel startAnimating];
    
    //get data from Cloud
    //Currently commented this condition
    if (_assetId)
    {
        [MPAPI getProjectMaterialsForNeedId:_assetId
                                     header:[MPModel getHeaderAuthorization]
                                    success:^(MPProjectMaterials *records) {
                                                          
                                        [_busyWheel stopAnimating];
                                        _materials = [NSArray arrayWithArray:records.materials];
                                        [_materialTableView reloadData];
                                                          
                                    }
                                    failure:^(NSError *error) {
                                                          
                                        [_busyWheel stopAnimating];
                                        NSLog(@"Failed with error = %@", error.localizedDescription);
                                    }];
    }
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_materials count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProjectMaterialIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }

    cell.layoutMargins = UIEdgeInsetsZero;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    MPProjectMaterial *material = [_materials objectAtIndex:indexPath.row];

    if (material)
    {
        //TODO : check types and mapping from APP server
        // Title: will it come from APP server ?? if NO, Add title strings in stringtable
        
        NSInteger typeId = [material.type integerValue];
        
        switch (typeId)
        {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"3D.png"];
                cell.textLabel.text = NSLocalizedString(@"Project_type_3DDesign", @"3D Design");
                break;
                
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"LF.png"];
                cell.textLabel.text = NSLocalizedString(@"Project_type_Design", @"Design");
                break;

            case 2:
                cell.imageView.image = [UIImage imageNamed:@"SJ.png"];
                cell.textLabel.text = NSLocalizedString(@"Project_type_DesignDrawings", @"Design Drawings");
                break;

                
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"CL.png"];
                cell.textLabel.text = NSLocalizedString(@"Project_type_BOM", @"Bill of Materials");
                break;
                
            default:
                break;
        }

    }

    return cell;
}


#pragma mark - UITableviewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPProjectMaterial *material = [_materials objectAtIndex:indexPath.row];
    
    if (material)
    {
        //Use this material object in repective controller
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    
    if (section == 0)
        height = 40;

    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0;
    
    if (section == 0 && [_materials count])
        height = 164;
    
    return height;

}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (section == 0 && [_materials count])
    {
        view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, 200, 20)];
        titleLabel.text = @"<<<..TITLE..CHANGE IT>>>"; //TODO Change SECTION NAME
        [view addSubview:titleLabel];
    }

    return view;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = nil;
    
    if (section == 0 && [_materials count])
    {
        view = [[UIView alloc] init];
        
        //create the button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5.0f;
        
        //the button should be as big as a table view cell
        CGRect buttonFrame = CGRectZero;
        buttonFrame.size.width = tableView.bounds.size.width - 32;
        buttonFrame.size.height = 44;
        buttonFrame.origin.x = 16;
        buttonFrame.origin.y = 60;
        [button setFrame:buttonFrame];
        
        //set title, font size and font color
        [button setBackgroundColor:[UIColor grayColor]];
        [button setTitle:NSLocalizedString(@"Save_Submit", @"Submit")
                forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(tapOnSubmitButton:)
         forControlEvents:UIControlEventTouchUpInside];
        //add the button to the view
        [view addSubview:button];
    }
    
    return view;

}


#pragma mark - navigationbar methods

- (void) tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - footer button hookups

-(void) tapOnSubmitButton:(id)sender
{
    
}

@end