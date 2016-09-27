
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
@interface AddOrUpdateViewController()

@end
@implementation AddOrUpdateViewController
@synthesize textFieldProductName,textFieldProductPrice,textFieldProductCategory,textFieldProductDateOfCreation,nsManagedObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isUpdate){
        [self.buttonSaveOrUpdate setTitle:UPDATE_TEXT forState:UIControlStateNormal];
        [self displayProductDetails];
    }
}

/** Displays product details in textfields
 */
-(void)displayProductDetails{
    [textFieldProductName setText:[self.nsManagedObject valueForKey:ATTRIBUTE_PRODUCT_NAME]];
    [textFieldProductPrice setText:[NSString stringWithFormat:@"%@", [self.nsManagedObject valueForKey: ATTRIBUTE_PRODUCT_PRICE]]];
    [textFieldProductCategory setText:[self.nsManagedObject valueForKey:ATTRIBUTE_PRODUCT_CATEGORY]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    [textFieldProductDateOfCreation setText:[dateFormat stringFromDate:[self.nsManagedObject valueForKey:ATTRIBUTE_DATE_OF_CREATION]]];
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
    NSString *trimmedName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(trimmedName.length == 0){
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
    textFieldProductName.text = @"";
    textFieldProductPrice.text = @"";
    textFieldProductCategory.text = @"";
}

/** Updates or inserts new object in database
 */
-(void)saveProduct{
    NSManagedObjectContext *context = [self managedObjectContext];
    if(self.nsManagedObject){
        [self.nsManagedObject setValue:self.textFieldProductName.text forKey:ATTRIBUTE_PRODUCT_NAME];
        [self.nsManagedObject setValue:[NSNumber numberWithFloat:[textFieldProductPrice.text floatValue]]  forKey:ATTRIBUTE_PRODUCT_PRICE];
        [self.nsManagedObject setValue:self.textFieldProductCategory.text forKey:ATTRIBUTE_PRODUCT_CATEGORY];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        [self.nsManagedObject setValue:[dateFormat dateFromString:textFieldProductDateOfCreation.text] forKey:ATTRIBUTE_DATE_OF_CREATION];
    }
    else{
        NSManagedObject *newProduct = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_PRODUCTS
                                                                   inManagedObjectContext:context];
        [newProduct setValue:self.textFieldProductName.text forKey:ATTRIBUTE_PRODUCT_NAME];
        [newProduct setValue:[NSNumber numberWithFloat:[textFieldProductPrice.text floatValue]]  forKey:ATTRIBUTE_PRODUCT_PRICE];
        [newProduct setValue:self.textFieldProductCategory.text forKey:ATTRIBUTE_PRODUCT_CATEGORY];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        [newProduct setValue:[dateFormat dateFromString:textFieldProductDateOfCreation.text] forKey:ATTRIBUTE_DATE_OF_CREATION];
    }
    NSError *error = nil;
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
    NSString *productName = textFieldProductName.text;
    NSString *productCategory = textFieldProductCategory.text;
    if(![self isWhitespace:productName]){
        [textFieldProductName becomeFirstResponder];
    }
    else if(![self isWhitespace:textFieldProductPrice.text]){
        [textFieldProductPrice becomeFirstResponder];
    }
    else if(![self isWhitespace:productCategory]){
        [textFieldProductCategory becomeFirstResponder];
    }
    else if(![self isAlphaOnly:productName]){
        NSLog(@"Only character set allowed in product name.");
        textFieldProductName.text = @"";
        [textFieldProductName becomeFirstResponder];
    }
    else if(![self isNumericOnly:textFieldProductPrice.text]){
        NSLog(@"Number ranging from 10 to 99999 and after decimal point only two numbers.");
        textFieldProductPrice.text = @"";
        [textFieldProductPrice becomeFirstResponder];
    }
    else if(![self isAlphaOnly:productCategory]){
        NSLog(@"Only character set allowed in product name.");
        textFieldProductCategory.text = @"";
        [textFieldProductCategory becomeFirstResponder];
    }
    else{
        [self saveProduct];
        [self popViewController];
    }}

/**
 *  Get managedObjectContext from the AppDelegate.
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

@end
