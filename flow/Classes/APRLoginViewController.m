
#import "APRLoginViewController.h"


@interface APRLoginViewController ()
{
    BOOL stopSpin;
}

//IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *flowCircle;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

//private helpers
- (void)saveToken:(FBSDKAccessToken *)token;

@end
#pragma mark -


@implementation APRLoginViewController

/**
 * @method viewDidLoad
 *
 * Called when this Login view is loaded.
 * Mainly sets FB LoginButton's delegate as self.
 *
 * @note called once during lifetime of app launch
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

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


#pragma mark - LoginButton Callback
/**
 * @method login
 *
 * Called when user presses the login button.
 */
- (IBAction)login:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"]
    handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
        if (error)
        {
            // Process error
        }
        else if (result.isCancelled)
        {
            // Handle cancellations
        }
        else
        {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"])
            {
                [FBSDKAccessToken setCurrentAccessToken:result.token];
                [self saveToken:result.token];
                
                stopSpin = YES;
                [self performSegueWithIdentifier:@"UsernameSegue" sender:self];
            }
        }
    }];
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

/**
 * @method saveToken:
 *
 * Gets the current access token and saves it to NSUserDefaults.
 *
 * @param token - FB AccessToken to save
 */
- (void)saveToken:(FBSDKAccessToken *)token
{
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


#pragma mark - Navigation
/**
 * @method toMain
 *
 * Switches to Main Storyboard
 */
- (void)toMain
{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainVC"];
    [self presentViewController:mainVC animated:YES completion:NULL];
}

@end









