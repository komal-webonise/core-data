//
//  AddOrUpdateViewController.h
//  CoreDataAssignment
//
//  Created by komal lunkad on 23/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOrUpdateViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textFieldProductName;

@property (strong, nonatomic) IBOutlet UITextField *textFieldProductPrice;

@property (strong, nonatomic) IBOutlet UITextField *textFieldProductCategory;

@property (strong, nonatomic) IBOutlet UITextField *textFieldProductDateOfCreation;

@end
