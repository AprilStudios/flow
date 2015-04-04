
#import "APRNicknameViewController.h"



@interface APRNicknameViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nicknameField;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;

@end
#pragma mark -



@implementation APRNicknameViewController
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
 * Gets the text in nicknameField,
 * and if not empty, calls checkUsername.
 */
- (IBAction)start:(id)sender
{
    [self.nicknameField resignFirstResponder];
    [self checkNickname:self.nicknameField.text];
}

/**
 * @method textFieldShouldReturn:
 *
 * Called when user presses "Go" on nicknameField.
 * Checks if
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nicknameField resignFirstResponder];
    [self checkNickname:self.nicknameField.text];
    
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
- (void)checkNickname:(NSString *)username
{
    if ( username.length == 0 )
        self.errorLabel.text = @"Enter a nickname!";
    else
    {
        
    }
}

@end
