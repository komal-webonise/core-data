
//
//  AddOrUpdateViewController.m
//  CoreDataAssignment
//
//  Created by komal lunkad on 23/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//

#import "AddOrUpdateViewController.h"
#import "Products.h"
#import "AppDelegate.h"
#include "CONSTANTS.h"

@implementation AddOrUpdateViewController
@synthesize textFieldProductName,textFieldProductPrice,textFieldProductCategory,textFieldProductDateOfCreation;

- (void)viewDidLoad {
    [super viewDidLoad];
    //    Do any additional setup after loading the view, typically from a nib.
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** Checks for extreme whitespaces and trims it
 * \param name The input whose extreme whitespaces are to be checked
 * \returns Returns yes if whitespaces are  present else it returns no
 */
-(BOOL)isWhitespace:(NSString*)name{
    NSString *trimmedName=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(trimmedName.length==0){
        return NO;
    }
    return YES;
}

/** Checks for alphabets and other characters in the string
 * \param input The input whose content character set is to be checked
 * \returns Returns yes if alphabets are only present else it returns no
 */
-(BOOL)isAlphaOnly:(NSString *)input
{
    NSString *regExp = @"[a-zA-Z]+";
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [regexTest evaluateWithObject:input];
}

/** Checks for numbers, decimal point and number of digits
 * \param input The input whose content number set is to be checked
 * \returns Returns yes if numbers, decimal point and number of digits within limit are only present else it returns no
 */
-(BOOL)isNumericOnly:(NSString *)input
{
    NSString *regExp = @"[0-9]{2,5}[.]{0,1}[0-9]{0,2}";
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
    return [regexTest evaluateWithObject:input];
}
/** Clears all text fields
 */
-(void)clearTextField{
    textFieldProductName.text=@"";
    textFieldProductPrice.text=@"";
    textFieldProductCategory.text=@"";
}
/** Saves product to the array
 */
-(void)saveProduct{
//    Products *product=[[Products alloc]init];
//    product.productName=textFieldProductName.text;
//    product.productPrice=[textFieldProductPrice.text floatValue];
//    product.productCategory=textFieldProductCategory.text;
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd-MM-yyyy"];
//    product.dateOfCreation = [dateFormat dateFromString:textFieldProductDateOfCreation.text];
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [appDelegate.arrayProducts addObject:product];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newProduct = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_PRODUCTS
                                                                   inManagedObjectContext:context];
    // Setting values to the created managed object.
    [newProduct setValue:self.textFieldProductName.text forKey:ATTRIBUTE_PRODUCT_NAME];
//    [newProduct setValue:[textFieldProductPrice.text floatValue] forKey:ATTRIBUTE_PRODUCT_PRICE];
   [newProduct setValue:self.textFieldProductCategory.text forKey:ATTRIBUTE_PRODUCT_CATEGORY];
//    [newProduct setValue:textFieldProductDateOfCreation.text forKey:ATTRIBUTE_DATE_OF_CREATION];
//    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}
/** Pops previous view controller
 */
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
/** Validates textfields and saves that to array on click of button save
 * \param sender The id of save button
 * \returns Returns action on click of button
 */
- (IBAction)buttonSaveTapped:(id)sender {
    NSString *productName=textFieldProductName.text;
    NSString *productCategory=textFieldProductCategory.text;
    if([self isAlphaOnly:productName]==NO || [self isAlphaOnly:productCategory]== NO){
        NSLog(@"Only character set allowed.");
    }
    if([self isNumericOnly:textFieldProductPrice.text]==NO ){
        NSLog(@"Number ranging from 10 to 99999 and after decimal point only two numbers.");
    }
    if([self isWhitespace:productName]== NO){
        [textFieldProductName becomeFirstResponder];
    }
    else if([self isWhitespace:textFieldProductPrice.text]== NO){
        [textFieldProductPrice becomeFirstResponder];
    }
    else if([self isWhitespace:productCategory]== NO){
        [textFieldProductCategory becomeFirstResponder];
    }
    else{
        [self saveProduct];
        [self popViewController];
    }
}
/**
 *  Get managedObjectContext from the AppDelegate.
 *
 *  @return NSManagedObjectContext object
 */
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

/**
 *  To save entered data and go back to the list.
 *
 *  @param sender Button object.
 */
//- (IBAction)saveTeamMemberInfo:(UIButton *)sender {
//    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    
//    // Create a new managed object
//    NSManagedObject *newTeamMember = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_PRODUCTS
//                                                                   inManagedObjectContext:context];
//    // Setting values to the created managed object.
//    [newTeamMember setValue:self.textFieldName.text forKey:ATTRIBUTE_NAME];
//    [newTeamMember setValue:self.textFieldTechnology.text forKey:ATTRIBUTE_TECHNOLOGY];
//    [newTeamMember setValue:self.textFieldEmail.text forKey:ATTRIBUTE_EMAIL];
//    
//    NSError *error = nil;
//    // Save the object to persistent store
//    if (![context save:&error]) {
//        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//    }
//    
//    // Pop view controller to get back to the list screen
//    [[self navigationController] popViewControllerAnimated:true];
//}


@end
