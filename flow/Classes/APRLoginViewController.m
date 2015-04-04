
#import "APRLoginViewController.h"


@interface APRLoginViewController ()
{
    BOOL stopSpin;
}

//IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *flowCircle;
@property (nonatomic, weak) IBOutlet FBSDKLoginButton *facebookButton;
@property (nonatomic, weak) IBOutlet UIButton *toMainButton;

//private helpers


@end
#pragma mark -


@implementation APRLoginViewController

/**
 * @method viewDidLoad
 *
 * Called when this Login view is loaded
 * @note called once during lifetime of app launch
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.facebookButton.delegate = self;

    //init any variables
    stopSpin = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}


/**
 * @method viewWillLoad
 *
 * Called when this view is about to appear
 * @note called every time this view is going to appear
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self rotateFlowCircle];
}

- (IBAction)toMain:(id)sender
{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainVC"];
    [self presentViewController:mainVC animated:YES completion:NULL];
}



#pragma mark - FB Login Button
/**
 * @method loginButton:didCompleteWithResult:error
 *
 * @param loginButton
 * @param result
 * @param error
 */
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error
{
    if (error)
        return;

    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    NSDictionary *tokenData = [[NSMutableDictionary alloc] init];
    [tokenData setValue:token.appID forKey:@"appID"];
    [tokenData setValue:token.userID forKey:@"userID"];
    [tokenData setValue:token.refreshDate forKey:@"refreshDate"];
    [tokenData setValue:token.tokenString forKey:@"tokenString"];
    [tokenData setValue:token.expirationDate forKey:@"expirationDate"];
    [tokenData setValue:token.permissions.allObjects forKey:@"permissions"];
    [tokenData setValue:token.declinedPermissions.allObjects forKey:@"declinedPermissions"];
    [[NSUserDefaults standardUserDefaults] setObject:tokenData forKey:@"currentAccessToken"];

}

/**
 * @method loginButtonDidLogout
 *
 *
 *
 * @method loginButton
 */
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"currentAccessToken"];
}


#pragma mark - UI Customization
/**
 * @method preferredStatusBarStytle
 *
 * Returns the preferred style for status bar.
 */
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Private Heleprs
/**
 * @method rotateFlowCircle
 *
 * Rotates the flow circle after a slight delay
 * as long as stop animation flag is not false.
 */
- (void)rotateFlowCircle
{
    if (stopSpin)
        return;
    
    [UIView animateWithDuration:1.0 delay:0.5
    options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut
    animations:^
    {
        self.flowCircle.transform = CGAffineTransformRotate(self.flowCircle.transform, -M_PI_2);
    }
    completion:^(BOOL finished)
    {
        [self rotateFlowCircle];
    }];
}

@end









