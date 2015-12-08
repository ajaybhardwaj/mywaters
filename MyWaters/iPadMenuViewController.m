//
//  iPadMenuViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 8/12/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "iPadMenuViewController.h"

@interface iPadMenuViewController ()

@end

@implementation iPadMenuViewController


//*************** Custom Cell Method For Side Menu Options

- (UITableViewCell *) customizeTableCell:(UITableViewCell *)cell{
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [iconImg setTag:900];
    //    [iconImg setBackgroundColor:RGB(210, 255, 77)];
    [iconImg setBackgroundColor:RGB(232, 233, 232)];
    [iconImg setContentMode:UIViewContentModeCenter];
    [iconImg setUserInteractionEnabled:YES];
    [cell.contentView addSubview:iconImg];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width-40, 44)];
    [lbl setTag:901];
    [lbl setBackgroundColor:[UIColor clearColor]];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont fontWithName:SIDE_MENU_CELL_FONT size:10.0f];
    //    [lbl setShadowColor:[UIColor darkGrayColor]];
    //    [lbl setShadowOffset:CGSizeMake(0, 1)];
    [lbl setNumberOfLines:1];
    [cell.contentView addSubview:lbl];
    
    return cell;
}


# pragma mark - View Lifeycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedMenuIndex = 0;
    
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.homeView = (iPadHomeViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [_optionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[[_optionsArray objectAtIndex:section] objectForKey:TABLE__SECTION_ARRAY] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"options-%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = nil;
        cell.backgroundColor = RGB(232, 233, 232);
        
        cell = [self customizeTableCell:cell];
        
    }
    
    NSString *lblTxt = [[[[_optionsArray objectAtIndex:indexPath.section] objectForKey:TABLE__SECTION_ARRAY] objectAtIndex:indexPath.row] objectForKey:CELL__MAIN_TXT];
    NSString *imagTxt = [[[[_optionsArray objectAtIndex:indexPath.section] objectForKey:TABLE__SECTION_ARRAY] objectAtIndex:indexPath.row] objectForKey:CELL__IMG];
    
    // Configure the cell...
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    [cell.textLabel setNumberOfLines:0];
    
    
    UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:901];
    [lbl setText:lblTxt];
    
    [lbl setFont:[UIFont fontWithName:ROBOTO_MEDIUM size:14.5]];
    [lbl setTextColor:RGB(83, 83, 83)];
    
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:900];
    [img setImage:[UIImage imageNamed:imagTxt]];
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.6, cell.bounds.size.width, 0.4)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    if (indexPath.row==selectedMenuIndex) {
        lbl.backgroundColor = [UIColor lightGrayColor];
        img.backgroundColor = [UIColor lightGrayColor];
        
    }
    else {
        lbl.backgroundColor = [UIColor clearColor];
        img.backgroundColor = [UIColor clearColor];
        
    }
    
    return cell;
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedMenuIndex = indexPath.row;

    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
