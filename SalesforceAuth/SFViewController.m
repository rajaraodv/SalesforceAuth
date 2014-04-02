//
//  SFViewController.m
//  SalesforceAuth
//
//  Created by Raja Rao DV on 3/31/14.
//  Copyright (c) 2014 Salesforce. All rights reserved.
//

#import "SFViewController.h"
#import "SFAccountManager.h"
#import "SFAuthenticationManager.h"
#import "SFIdentityData.h"

static NSString * const RemoteAccessConsumerKey = @"3MVG9A2kN3Bn17huxQ_nFw2X9Umavifq5f6sjQt_XT4g2rFwM_4AbkWwyIXEnH.hSsSd9.I._5Nam3LVtvCkJ";


static NSString * const OAuthRedirectURI = @"http://localhost:3000/oauth/_callback";


@interface SFViewController ()

@property (nonatomic, copy) SFOAuthFlowSuccessCallbackBlock initialLoginSuccessBlock;
@property (nonatomic, copy) SFOAuthFlowFailureCallbackBlock initialLoginFailureBlock;

@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.logoutFromSalesforceBtnOutlet setHidden:YES];
    [self.username setHidden:YES];
    
    // These SFAccountManager settings are the minimum required to identify the Connected App.
    [SFAccountManager setClientId:RemoteAccessConsumerKey];
    [SFAccountManager setRedirectUri:OAuthRedirectURI];
    [SFAccountManager setScopes:[NSSet setWithObjects:@"api", nil]];
    
    __block SFViewController *vc = self;
    self.initialLoginSuccessBlock = ^(SFOAuthInfo *info) {
        //success
        NSLog(@"Success .. now add code to navigate to some place");
        [vc showOrHideButtons];
    };
    self.initialLoginFailureBlock = ^(SFOAuthInfo *info, NSError *error) {
        NSLog(@"Failed w/ Error:\n\n %@ ", error);
        [[SFAuthenticationManager sharedManager] logout];
    };

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showOrHideButtons];
}


- (IBAction)loginToSalesforceBtn:(id)sender {
    [[SFAuthenticationManager sharedManager] loginWithCompletion:self.initialLoginSuccessBlock failure:self.initialLoginFailureBlock];
    
    
}

- (IBAction)logoutFromSalesforceBtn:(id)sender {
    [[SFAuthenticationManager sharedManager] logout];
    [self showOrHideButtons];
}



- (void)logoutInitiated:(NSNotification *)notification
{
    
}

- (void)loginHostChanged:(NSNotification *)notification
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) showOrHideButtons {
    SFIdentityData *idData = [[SFAccountManager sharedInstance] idData];
    NSLog(@"idData = \n%@", idData);
    
    if(idData == (id)[NSNull null] || idData == nil) {
        [self.loginToSalesforceBtnOutlet setHidden:NO];
        [self.logoutFromSalesforceBtnOutlet setHidden:YES];
        [self.username setHidden:YES];
        
    } else {
        [self.loginToSalesforceBtnOutlet setHidden:YES];
        [self.logoutFromSalesforceBtnOutlet setHidden:NO];
        [self.username setHidden:NO];
        
        //set username from salesforce's identity
        [self.username setText:idData.username];
    }
}
@end
