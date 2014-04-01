//
//  SFViewController.m
//  SalesforceAuth
//
//  Created by Raja Rao DV on 3/31/14.
//  Copyright (c) 2014 Salesforce. All rights reserved.
//

#import "SFViewController.h"
#import "SFAuthenticationManager.h"
#import "SFAccountManager.h"
#import "SFIdentityData.h"

static NSString * const RemoteAccessConsumerKey = @"3MVG9A2kN3Bn17huxQ_nFw2X9Umavifq5f6sjQt_XT4g2rFwM_4AbkWwyIXEnH.hSsSd9.I._5Nam3LVtvCkJ";

//static NSString * const OAuthRedirectURI        = @"testsfdc:///mobilesdk/detect/oauth/done";

static NSString * const OAuthRedirectURI        = @"http://localhost:3000/oauth/_callback";

@interface SFViewController ()
/**
 * Success block to call when authentication completes.
 */
@property (nonatomic, copy) SFOAuthFlowSuccessCallbackBlock initialLoginSuccessBlock;

/**
 * Failure block to calls if authentication fails.
 */
@property (nonatomic, copy) SFOAuthFlowFailureCallbackBlock initialLoginFailureBlock;

@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    // These SFAccountManager settings are the minimum required to identify the Connected App.
    [SFAccountManager setClientId:RemoteAccessConsumerKey];
    [SFAccountManager setRedirectUri:OAuthRedirectURI];
    [SFAccountManager setScopes:[NSSet setWithObjects:@"api", nil]];
    
//    // Logout and login host change handlers.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutInitiated:) name:kSFUserLogoutNotification object:[SFAuthenticationManager sharedManager]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginHostChanged:) name:kSFLoginHostChangedNotification object:[SFAuthenticationManager sharedManager]];
    
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

- (void) showOrHideButtons {
    SFIdentityData *idData = [[SFAccountManager sharedInstance] idData];
    if(idData == (id)[NSNull null] || idData == nil) {
        [self.loginToSalesforceBtnOutlet setHidden:NO];
        [self.logoutFromSalesforceBtnOutlet setHidden:YES];
        [self.username setHidden:YES];
        
    } else {
        [self.loginToSalesforceBtnOutlet setHidden:YES];
        [self.logoutFromSalesforceBtnOutlet setHidden:NO];
        [self.username setHidden:NO];
        [self.username setText:idData.username];
    }
}


- (void)logoutInitiated:(NSNotification *)notification
{

    [self showOrHideButtons];
    
}

- (void)loginHostChanged:(NSNotification *)notification
{

    [[SFAuthenticationManager sharedManager] loginWithCompletion:self.initialLoginSuccessBlock failure:self.initialLoginFailureBlock];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginToSalesforceBtn:(id)sender {
      [[SFAuthenticationManager sharedManager] loginWithCompletion:self.initialLoginSuccessBlock failure:self.initialLoginFailureBlock];

}

- (IBAction)logoutFromSalesforceBtn:(id)sender {
    [[SFAuthenticationManager sharedManager] logout];
   
}
@end
