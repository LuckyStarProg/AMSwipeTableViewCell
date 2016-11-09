//
//  ViewController.m
//  AMSwiper
//
//  Created by Амин on 07.11.16.
//  Copyright © 2016 singl. All rights reserved.
//

#import "ViewController.h"
#import "AMSwipeTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMSwipeTableViewCell * cell=[[AMSwipeTableViewCell alloc] init];
    cell.textLabel.text=[NSString stringWithFormat:@"Test %li",indexPath.row+1];
    UIButton * button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.backgroundColor=[UIColor redColor];
    [button setTitle:@"Delete" forState:UIControlStateNormal];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    button.titleLabel.font=[UIFont systemFontOfSize:15.0];
    button.titleLabel.textColor=[UIColor whiteColor];
    [button addTarget:self action:@selector(buttonDidTap) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"view1" owner:self options:nil];
    UIView * temp=[nib objectAtIndex:0];
    [cell addView:temp forDirection:SideDirectionRight widthAction:nil];
    [cell addView:button forDirection:SideDirectionLeft widthAction:nil];
    
    return cell;
}

-(void)buttonDidTap
{
    AMSwipeTableViewCell * cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell close];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
