//
//  SFViewController.h
//  SalesforceAuth
//
//  Created by Raja Rao DV on 3/31/14.
//  Copyright (c) 2014 Salesforce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFViewController : UIViewController

- (IBAction)loginToSalesforceBtn:(id)sender;
- (IBAction)logoutFromSalesforceBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginToSalesforceBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *logoutFromSalesforceBtnOutlet;
@property (strong, nonatomic) IBOutlet UILabel *username;

@end
