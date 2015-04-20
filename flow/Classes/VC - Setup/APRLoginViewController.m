
#import "APRLoginViewController.h"

#import "APRLoginWidget.h"
#import "APRTextField.h"
#import "flow-Swift.h"

#define OFFSET_FACTOR 3/5

@interface APRLoginViewController()
{
    BOOL stopSpin;
    
    BOOL keyboardShown;
    BOOL keyboardScrolling;
    CGFloat keyboardHeight;
    
    CGFloat delta;
    CGFloat previousOffset;
    CGFloat bottomSpacing;
}

/* IBOutlets */
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

//flow circle
@property (nonatomic, strong) IBOutlet UILabel *flowLabel;
@property (nonatomic, strong) IBOutlet UIImageView *flowCircle;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *flowCircleWidth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *flowCircleTop;

//login fields
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *loginWidgetTopOffset;
@property (nonatomic, strong) IBOutlet APRLoginWidget *loginWidget;

/* Methods */
- (void)rotateFlowCircle;
- (void)showMainTabBarController;

@end
#pragma mark -



@implementation APRLoginViewController
#pragma mark Setup
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
    
    //vars
    keyboardShown = NO;
    keyboardScrolling = NO;
    keyboardHeight = 0;
    
    //layout
    [self.view layoutIfNeeded];
    [self setupLoginWidget];
    [self registerKeyboardNotifications];
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
    
    stopSpin = NO;
    [self rotateFlowCircle];
}

/**
 * @method setupLoginWidget
 *
 * Setups up APRLoginWidget by setting appropriate values.
 */
- (void)setupLoginWidget
{
    //scroll
    self.scrollView.delegate = self;

    //clear background
    self.loginWidget.backgroundColor = [UIColor clearColor];
    
    //position
    [self adjustInsetWithHeight:0 duration:0 options:UIViewAnimationOptionTransitionNone];
}

/**
 * @method setupKeyboardNotifications
 *
 * Registers appropriate methods to be called when keyboard shows/hides.
 */
- (void)registerKeyboardNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(keyboardDidHide:)  name:UIKeyboardDidHideNotification  object:nil];
}

/**
 * @method deregisterkeyboardNotifications
 *
 * Deregisters this class as responder to keyboard events
 */
- (void)deregisterKeyboardNotifications
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark - Keyboard Events
/**
 * @method keyboardWillShow:
 *
 * Called by NSNotificationCenter when keyboard is about to be shown.
 */
- (void)keyboardWillShow:(NSNotification *)notification
{
    // change keyboard height when keyboard changes
    NSDictionary *info = notification.userInfo;
    keyboardHeight = [info[@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    if (!keyboardShown)
    {
        NSTimeInterval duration = [info[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
        UIViewAnimationOptions option = [info[@"UIKeyboardAnimationCurveUserInfoKey"] integerValue];
    
        [self adjustInsetWithHeight:keyboardHeight duration:duration options:option];
    }
}

/**
 * @method keyboardDidShow:
 *
 * Called by NSNotificationCenter after keyboard has been shown.
 */
- (void)keyboardDidShow:(NSNotification *)notification
{
    keyboardShown = YES;
}

/**
 * @method keyboardWillHide:
 *
 * Called by NSNotificationCenter when keyboard is hidden.
 */
- (void)keyboardWillHide:(NSNotification *)notification
{

}

/**
 * @method keyboardDidHide:
 *
 * Called by NSNotificationCenter after keyboard has hidden.
 */
- (void)keyboardDidHide:(NSNotification *)notification
{
    keyboardShown = NO;
    keyboardHeight = 0;
}



#pragma mark - UIScrollView Delegate
/**
 * @method scrollViewWillBeginDragging:
 *
 * Called when scrollView is about to start dragging
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!keyboardShown)
        return;
    
    delta = 0;
    previousOffset = -scrollView.contentOffset.y;
}

/**
 * @method scrollViewDidScroll:
 *
 * Called when scrollView is scrolling
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!keyboardShown)
        return;

    CGFloat currentOffset = -scrollView.contentOffset.y;
    delta = currentOffset - previousOffset;
    previousOffset = currentOffset;
    
    CGFloat touch = [scrollView.panGestureRecognizer locationInView:self.view].y;
    CGFloat kbEdge = [UIScreen mainScreen].bounds.size.height - keyboardHeight;
    keyboardScrolling = (kbEdge < touch);
}

/**
 * @method scrollViewDidEndDragging:willDecelerate:
 *
 * Called when user lifts finger from dragging.
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ( !(keyboardShown && keyboardScrolling) )
        return;
    
    [UIView animateWithDuration:0.25
    animations:^
    {
        UIEdgeInsets inset = scrollView.contentInset;
        inset.top = -scrollView.contentOffset.y;
        scrollView.contentInset = inset;
    }
    completion:^(BOOL finished)
    {
        CGFloat kbHeight = (delta > 0) ? 0 : keyboardHeight;
        [self adjustInsetWithHeight:kbHeight duration:0.25 options:7];
    }];
}



#pragma mark - UI & Layout
/**
 * @method preferredStatusBarStytle
 *
 * Returns the preferred style for status bar.
 */
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

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
    
    [UIView animateWithDuration:1.2 delay:0.8
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
 * @method adjustInsetWithHeight:duration:options:
 *
 * Adjusts the inset of the scrollView
 */
- (void)adjustInsetWithHeight:(CGFloat)kbHeight duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options
{
    CGFloat viewHeight = CGRectGetHeight(self.scrollView.frame);
    CGFloat widgetHeight = CGRectGetHeight(self.loginWidget.frame);
    CGFloat offset = (viewHeight * 3/5) - (widgetHeight / 2) - (kbHeight * 2/5);
    
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.top = floor(offset);
    
    [UIView animateWithDuration:duration delay:0 options:options | UIViewAnimationOptionBeginFromCurrentState
     animations:^{
         self.scrollView.contentInset = inset;
     }
     completion:^(BOOL finished){
         previousOffset = inset.top;
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
    UIViewController *mainVC = [mainSB instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    [self presentViewController:mainVC animated:YES completion:NULL];
}

@end









