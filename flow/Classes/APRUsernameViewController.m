
#import "APRUsernameViewController.h"



@interface APRUsernameViewController ()

@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;

@end
#pragma mark -



@implementation APRUsernameViewController
/**
 * @method viewDidLoad
 *
 * Called when this view is loaded.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
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


#pragma mark - IBAction/Event Callbacks
/**
 * @method start:
 *
 * Called when user presses "Start!" button.
 * Gets the text in usernameField,
 * and if not empty, calls checkUsername.
 */
- (IBAction)start:(id)sender
{
    [self.usernameField resignFirstResponder];
    [self checkUsername:self.usernameField.text];
}

/**
 * @method textFieldShouldReturn:
 *
 * Called when user presses "Go" on usernameField.
 * Checks if
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.usernameField resignFirstResponder];
    [self checkUsername:self.usernameField.text];
    
    return YES;
}


#pragma mark - Private Helpers
/**
 * @method checkUsername:
 *
 * Checks with ParseManager whether the given username
 * is already a existing username.
 * If not, pushes to the screen to home.
 */
- (void)checkUsername:(NSString *)username
{
    if ( username.length == 0 )
        self.errorLabel.text = @"Enter a nickname!";
    else
    {
        
    }
}

@end
