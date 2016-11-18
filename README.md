# AMSwipeTableViewCell
AMSwiper -  framework that provide smart swipe TableViewCell to left or right direction with custom animation and algorithm that saved proportionality between objects. Also you can add your own custom UIView in not limited count. 
<h1>How it works</h1>
<p>Lets start work with AMSwiper</p>
<p>To start work with it, you must create AMSwipeTableViewCell like this:</p>   
    AMSwipeTableViewCell *  cell=[[AMSwipeTableViewCell alloc] init];
<p>or dequeue cell from register nib...</p>
    AMSwipeTableViewCell *  cell=(AMSwipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"customCell"];
<p>To add button/view you have 2 methods:</p>
    [cell addView:(UIView *) forDirection:(SideDirection) withAction:^(void)action#]
<p>and...</p>
    [cell addButtonWithLabel:(UILabel *) andBackgroundColor:(UIColor *) forDirection:(SideDirection) withAction:^(void)action]

<h1>Exampels</h1>
<p>In viewDidLoad method you must register nib in table view:</p>
    UINib *cellNib = [UINib nibWithNibName:@"customCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"customCell"];
<p>And than you can do something like this:</p>
    -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    AMSwipeTableViewCell *  cell=(AMSwipeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"customCell"];
    if(cell.rightButtons.count==0)
    {
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
        [cell addButtonWithLabel:label andBackgroundColor:[UIColor redColor] forDirection:SideDirectionRight withAction:^
         {
             [weakCell close];
         }];
    }
    return cell;
    }
<p>Or like this:</p>  
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
        [cell addButtonWithLabel:label andBackgroundColor:[UIColor redColor] forDirection:SideDirectionRight withAction:^
         {
             [weakCell close];
         }];
        return cell;
    }
<p>etc...</p>
