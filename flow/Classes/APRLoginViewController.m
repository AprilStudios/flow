
#import "APRLoginViewController.h"



@interface APRLoginViewController ()

@property (nonatomic, weak) IBOutlet UIButton *toMainButton;

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

    //init any variables
    [self setNeedsStatusBarAppearanceUpdate];
    //self.view.backgroundColor = [UIColor blackColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"tweed_@2x"]];
}


- (IBAction)toMain:(id)sender
{
    // Get the storyboard named secondStoryBoard from the main bundle:
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"test" bundle:nil];
    UIViewController *mainVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"testVC"];
    
    // Then push the new view controller in the usual way:
    [self presentViewController:mainVC animated:YES completion:NULL];
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


@end
