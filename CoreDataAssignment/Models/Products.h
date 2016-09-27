//
//  Products.h
//  CoreDataAssignment
//
//  Created by komal lunkad on 23/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Products : NSObject
@property (readwrite) NSString *productName;
@property (readwrite) float productPrice;
@property (readwrite) NSString *productCategory;
@property (readwrite) NSDate *dateOfCreation;
@end

