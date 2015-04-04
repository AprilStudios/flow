
#import "APRLoginViewController.h"



@interface APRLoginViewController ()
{
    BOOL stopSpin;
}

//IBOutlets
@property (nonatomic, weak) IBOutlet UIImageView *flowCircle;
@property (nonatomic, weak) IBOutlet UIButton *facebookButton;
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
    // Get the storyboard named secondStoryBoard from the main bundle:
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainVC"];
    
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









