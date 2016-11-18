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
@property (nonatomic)NSUInteger count;
@end

@implementation ViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMSwipeTableViewCell *  cell=[[AMSwipeTableViewCell alloc] init];
        cell.textLabel.text=[NSString stringWithFormat:@"Test %li",indexPath.row+1];
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text=@"Delete";
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor whiteColor];

        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"view1" owner:self options:nil];
        UIView * temp=[nib objectAtIndex:0];
        
        __weak typeof(cell) weakCell = cell;
        [cell addView:temp forDirection:SideDirectionRight withAction:^
         {
             [weakCell close];
         }];
        [cell addButtonWithLabel:label andBackgroundColor:[UIColor redColor] forDirection:SideDirectionLeft withAction:^
         {
             [weakCell close];
             self.count-=1;
             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
             [self.tableView reloadData];
         }];
    return cell;
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
    self.count=100;
    //UINib *cellNib = [UINib nibWithNibName:@"customCell" bundle:[NSBundle mainBundle]];
    //[self.tableView registerNib:cellNib forCellReuseIdentifier:@"customCell"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
