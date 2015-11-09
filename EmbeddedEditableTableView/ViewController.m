//
//  ViewController.m
//  EmbeddedEditableTableView
//
//  Created by Gonzalo Castro on 11/3/15.
//  Copyright © 2015 Gonzalo Castro. All rights reserved.
//

#import "ViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

const static NSInteger itemsInSection0 = 3;
const static NSInteger itemsInSection1 = 2;

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *section0Data;
@property (nonatomic, strong) NSMutableArray *section1Data;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction)addItemToSection0:(id)sender;
- (IBAction)addItemToSection1:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.section0Data = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSInteger i=1; i <= itemsInSection0; i++)
    {
        [self.section0Data addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
 
    self.section1Data = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSInteger i=1; i <= itemsInSection1; i++)
    {
        [self.section1Data addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }

    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)addItemToSection0:(id)sender
{
    [self.tableView beginUpdates];
    [self increaseCount:self.section0Data];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.section0Data.count - 1)
                                                                inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (IBAction)addItemToSection1:(id)sender
{
    [self.tableView beginUpdates];
    [self increaseCount:self.section1Data];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.section1Data.count - 1)
                                                                inSection:1]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)increaseCount:(NSMutableArray *)list
{
    NSString *currentItem = [list lastObject];
    NSInteger n = [currentItem integerValue] + 1;
    [list addObject:[NSString stringWithFormat:@"%ld", (long)n]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    if (section == 0)
    {
        numRows = self.section0Data.count;
    }
    else if (section == 1)
    {
        numRows = self.section1Data.count;
    }
    
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGSwipeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellIdentifier"];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [self.section0Data objectAtIndex:indexPath.row];
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Check" icon:nil backgroundColor:[UIColor greenColor]],
                             [MGSwipeButton buttonWithTitle:@"Fav" icon:nil backgroundColor:[UIColor blueColor]]];
        cell.leftSwipeSettings.transition = MGSwipeStateSwippingLeftToRight;
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"More" icon:nil backgroundColor:[UIColor grayColor]],
                             [MGSwipeButton buttonWithTitle:@"Tap" icon:nil backgroundColor:[UIColor redColor]]];
        cell.rightSwipeSettings.transition = MGSwipeStateSwippingRightToLeft;
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [self.section1Data objectAtIndex:indexPath.row];
        cell.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section %ld", (long)section];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        
        if (indexPath.section == 0)
        {
            [self.section0Data removeObjectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 1)
        {
            [self.section1Data removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewRowAction *howdyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                               title:@"Howdy"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                                 NSLog(@"Howdy");
                                                                                 [self.tableView setEditing:NO];
                                                                             }];
        
        howdyAction.backgroundColor = [UIColor blueColor];
        
        UITableViewRowAction *dangerAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                                title:@"Danger"
                                                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                                  NSLog(@"Danger");
                                                                                  [self.tableView setEditing:NO];
                                                                              }];
        
            UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                    title:@"More"
                                                                                  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                                      NSLog(@"No Action");
                                                                                      [self.tableView setEditing:NO];
                                                                                  }];
            moreAction.backgroundColor = [UIColor lightGrayColor];
        
        return @[moreAction, howdyAction, dangerAction];
    }
    else
    {
        return nil;
    }
}

@end
