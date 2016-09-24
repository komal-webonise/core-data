//
//  Products.m
//  CoreDataAssignment
//
//  Created by komal lunkad on 23/09/16.
//  Copyright © 2016 komal lunkad. All rights reserved.
//
#import "Products.h"
@interface Products()
@end
@implementation Products
@synthesize productName,productPrice,productCategory,dateOfCreation;
- (id)init {
    self = [super init];
    productName = @"";
    productPrice = 0.0;
    productCategory = @"";
    return self;
}
@end

