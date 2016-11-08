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
    UIView * view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    view1.backgroundColor=[UIColor blackColor];
    view1.translatesAutoresizingMaskIntoConstraints=NO;
    UIView * view2=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    view2.backgroundColor=[UIColor whiteColor];
    view2.translatesAutoresizingMaskIntoConstraints=NO;
    UIView * view3=[[UIView alloc] init];
    view3.backgroundColor=[UIColor greenColor];
    view3.translatesAutoresizingMaskIntoConstraints=NO;
    
    [cell addView:view1 forDirection:SideDirectionRight];
    [cell addView:view2 forDirection:SideDirectionRight];
    [cell addView:view3 forDirection:SideDirectionRight];
    
    UIView * view4=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    view4.backgroundColor=[UIColor greenColor];
    view4.translatesAutoresizingMaskIntoConstraints=NO;
    UIView * view5=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    view5.backgroundColor=[UIColor blackColor];
    view5.translatesAutoresizingMaskIntoConstraints=NO;
    
    [cell addView:view4 forDirection:SideDirectionLeft];
    [cell addView:view5 forDirection:SideDirectionLeft];
    return cell;
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
