//
//  ListProductsViewController.m
//  CoreDataAssignment
//
//  Created by komal lunkad on 23/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//

#import "ListProductsViewController.h"
#import "AddOrUpdateViewController.h"
#import "AppDelegate.h"
#include "TableViewCell.h"
#include "Products.h"
#import "CONSTANTS.h"
@interface ListProductsViewController()
@end


@implementation ListProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProducts)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = barButtonItemAdd;
 
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Fetch all the team members from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ENTITY_PRODUCTS];
    self.arrayProducts = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

/**
 *  Get managedObjectContext from the AppDelegate.
 *
 *  @return NSManagedObjectContext object
 */
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
-(void)addProducts{
    AddOrUpdateViewController *addOrUpdateViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"AddOrUpdateViewController"];
    [self.navigationController pushViewController:addOrUpdateViewController animated:YES];
    
}
-(void) viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayProducts count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellIdentifier = @"TableViewCell" ;
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:customCellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0] ;
    }
    NSManagedObject *productDetail = [self.arrayProducts objectAtIndex:indexPath.row];
    [cell.labelProductName setText:[productDetail valueForKey:ATTRIBUTE_PRODUCT_NAME]];
    //[cell.labelProductPrice setText:[productDetail valueForKey:ATTRIBUTE_PRODUCT_PRICE]];
    //[cell.labelProductDateOfCreation setText:[productDetail valueForKey:ATTRIBUTE_DATE_OF_CREATION]];
    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    cell.labelProductName.text = [appDelegate.arrayProducts[indexPath.row] productName];
//    cell.labelProductPrice.text = [NSString stringWithFormat:@"%0.2f", [appDelegate.arrayProducts[indexPath.row] productPrice]];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd-MM-yyyy"];
//    cell.labelProductDateOfCreation.text = [dateFormat stringFromDate:[appDelegate.arrayProducts[indexPath.row] dateOfCreation]];
    return cell;
    
}

@end
