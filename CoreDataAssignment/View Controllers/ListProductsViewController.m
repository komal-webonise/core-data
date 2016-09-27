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
}
/** Fetches records from database , stores them in array and reloads tableview
 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

/**
 *  Navigates the user to another view controller where user can add one more product.
 */
-(void)addProducts{
    AddOrUpdateViewController *addOrUpdateViewController = [self.storyboard instantiateViewControllerWithIdentifier:ADD_OR_UPDATE_VIEW_CONTROLLER];
    [self.navigationController pushViewController:addOrUpdateViewController animated:YES];
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
    return 100;
}

/**
 *  Initializes every cell of table with product details
 *  \param tableView Tableview on which opeartions are to be performed
 *  \param indexPath Indexpath of tableview
 *  @return UITableViewCell object
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *customCellIdentifier = TABLE_VIEW_CELL ;
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:customCellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0] ;
    }
    NSManagedObject *productDetail = [self.arrayProducts objectAtIndex:indexPath.row];
    [cell.labelProductName setText:[productDetail valueForKey:ATTRIBUTE_PRODUCT_NAME]];
    [cell.labelProductPrice setText:[NSString stringWithFormat:@"%@", [productDetail valueForKey: ATTRIBUTE_PRODUCT_PRICE]]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    [cell.labelProductDateOfCreation setText:[dateFormat stringFromDate:[productDetail valueForKey:ATTRIBUTE_DATE_OF_CREATION]]];
    return cell;
}

/**
 *  Deletes object from tableview,database and array of products
 *  \param tableView Tableview on which opeartions are to be performed
 *  \param editingStyle Tells which type of editing is to be performed
 *  \param indexPath Indexpath of tableview
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.arrayProducts objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        [self.arrayProducts removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


/**
 *  On clicking of table cell the current product object is passed and next view controller is called
 *  \param tableView Tableview on which opeartions are to be performed
 *  \param indexPath Indexpath of tableview
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *productDetail = [self.arrayProducts objectAtIndex:indexPath.row];
    AddOrUpdateViewController *addOrUpdateViewController =[self.storyboard instantiateViewControllerWithIdentifier:ADD_OR_UPDATE_VIEW_CONTROLLER];
    addOrUpdateViewController.nsManagedObject = productDetail;
    addOrUpdateViewController.isUpdate = YES;
    [self.navigationController pushViewController:addOrUpdateViewController animated:YES];
}

@end
