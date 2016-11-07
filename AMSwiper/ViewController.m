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
