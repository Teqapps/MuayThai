//
//  ViewController.h
//  2
//
//  Created by Teqwin on 24/2/2015.
//  Copyright (c) 2015年 Teqwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TattooMasterCell.h"
#import "Tattoo_Detail_ViewController.h"
#import <Parse/Parse.h>

@interface Comment : PFQueryTableViewController

@property (nonatomic, strong) TattooMasterCell *tattoomasterCell;
@end

