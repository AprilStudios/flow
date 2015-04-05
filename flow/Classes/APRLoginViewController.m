
#import "APRLoginViewController.h"

#import "flow-Swift.h"


@interface APRLoginViewController ()
{
    BOOL stopSpin;
    BOOL returningUser;
}

//IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *flowCircle;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

//private helpers
- (void)saveToken:(FBSDKAccessToken *)token;
- (void)showNicknameSelection;
- (void)rotateFlowCircle;

//navigation
- (void)showMainTabBarController;

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
    
    //setup
    stopSpin = NO;
    [self rotateFlowCircle];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if ( [FBSDKAccessToken currentAccessToken] )
    {
        self.loginButton.hidden = YES;
        self.startButton.hidden = NO;
        self.errorLabel.hidden = NO;
        self.nameField.hidden = NO;
    }
}

/**
 * @method viewWillAppear
 *
 * Called when the view is about to appear.
 * @note called every time view is going to appear.
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/**
 * @mthod viewDidAppear:
 *
 * Called when the view has appeared on the screen.
 * Check for an AccessToken and switch accordingly.
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}


#pragma mark - IBAction/Event Callback
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
            //Do nothing for cancel
        }
        else
        {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"])
            {
                [self saveToken:result.token];
                [self checkUserID:result.token.userID];
            }
        }
    }];
}

/**
 * @method start
 *
 * Called when "Start" button is pressed
 */
- (IBAction)start:(id)sender
{
    [self.nameField resignFirstResponder];
    [self checkNickname:self.nameField.text];
}

/**
 * @method textFieldShouldBeginEditing
 *
 * Called when user starts editing nameField.
 * Reset the error label.
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.errorLabel.text = @"";
    return YES;
}

/**
 * @method textFieldShouldReturn
 *
 * Called when user presses "Go" on keyboard.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameField resignFirstResponder];
    [self checkNickname:self.nameField.text];
    
    return YES;
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
 * @method showNicknameSelection
 *
 * Hides the FB login button, and shows GUI for nickname.
 */
- (void)showNicknameSelection
{
    self.loginButton.hidden = YES;
    self.startButton.hidden = NO;
    self.errorLabel.hidden = NO;
    self.nameField.hidden = NO;
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
    [FBSDKAccessToken setCurrentAccessToken:token];

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
 * @method checkNickname
 *
 * Checks validity of given nickname.
 * First it needs to be not empty,
 * then is checked for whether its already on ParseCloud.
 * If so, errorLabel is shown as existing nickname.
 * Otherwise, it's taken and screen is pushed to MainTabBarController.
 */
- (void)checkNickname:(NSString *)nickname
{
    if ( nickname.length == 0 )
        self.errorLabel.text = @"Enter a nickname!";
    else
    {
        APRParseManager *manager = [APRParseManager sharedManager];
        [manager userIDForNicknameExists:nickname
        completion:^(NSString *userID, BOOL found)
        {
            if (found)
                self.errorLabel.text = @"Sorry, that nickname already exists!";
            else
            {
                [self showMainTabBarController];
                [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
                [manager addUser:[[APRUser alloc] initWithNickname:nickname userID:[FBSDKAccessToken currentAccessToken].userID]];
            }
        }];
    }
}

/**
 * @method checkUserID
 *
 * Checks whether or not the given userID
 * exists on ParseCloud already.
 * If it does not, show the Nickname selection GUI.
 * Otherwise, move on to MainTabBarController as returning user.
 */
- (void)checkUserID:(NSString *)userID
{
    [[APRParseManager sharedManager] nicknameForUserIDExists:userID
     completion:^(NSString *nickname, BOOL found)
     {
         if (!found)
             [self showNicknameSelection];
         else
         {
             [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
             [self showMainTabBarController];
         }
     }];
}


#pragma mark - Navigation
/**
 * @method showMainTabBarController
 *
 * Shows the main TabBarController.
 * @note temporarily shows MainVC
 */
- (void)showMainTabBarController
{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainVC = [mainSB instantiateViewControllerWithIdentifier:@"MainVC"];
    [self presentViewController:mainVC animated:YES completion:NULL];
}

@end









