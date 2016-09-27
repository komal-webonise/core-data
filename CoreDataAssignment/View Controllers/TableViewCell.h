//
//  TableViewCell.h
//  CoreDataAssignment
//
//  Created by komal lunkad on 23/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDateOfCreation;
@end
