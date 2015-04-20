
#import "APRLoginWidget.h"
#import "UIView+Border.h"



@interface APRLoginWidget()
{
    BOOL initialSetup;
    BOOL loginSelected;
    UIColor *faintWhite;
    UIColor *solidWhite;
}

/* UI */
@property (nonatomic, strong) IBOutlet UIView *view;

@property (nonatomic, strong) IBOutlet UIView *toolbar;
@property (nonatomic, strong) IBOutlet UIView *loginTabContainer;
@property (nonatomic, strong) IBOutlet UIButton *loginTab;
@property (nonatomic, strong) IBOutlet UIView *signupTabContainer;
@property (nonatomic, strong) IBOutlet UIButton *signupTab;
@property (nonatomic, strong) UIView *underline;

@property (nonatomic, strong) IBOutlet UIView *loginBox;
@property (nonatomic, strong) IBOutlet APRTextField *loginUsernameField;
@property (nonatomic, strong) IBOutlet APRTextField *loginPasswordField;

@property (nonatomic, strong) IBOutlet UIView *signupBox;
@property (nonatomic, strong) IBOutlet APRTextField *signupEmailField;
@property (nonatomic, strong) IBOutlet APRTextField *signupPasswordField;
@property (nonatomic, strong) IBOutlet APRTextField *signupUsernameField;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *loginBoxOffset;


/* Methods */
- (IBAction)loginTabPressed:(id)sender;
- (IBAction)signupTabPressed:(id)sender;

@end
#pragma mark -



@implementation APRLoginWidget
#pragma mark Setup
/**
 * @method initWithCoder
 *
 * Called by storyboard to create an instance
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [[NSBundle mainBundle] loadNibNamed:@"APRLoginWidget" owner:self options:nil];
        [self addSubview:self.view];
        
        //vars
        initialSetup = YES;
        loginSelected = YES;
        faintWhite = [UIColor colorWithWhite:1.0 alpha:0.3];
        solidWhite = [UIColor whiteColor];
        
        //clear test colors
        UIColor *clear = [UIColor clearColor];
        self.view.backgroundColor = clear;
        self.toolbar.backgroundColor = clear;
        self.loginBox.backgroundColor = clear;
        self.signupBox.backgroundColor = clear;
        
        //moving underline
        self.underline = [[UIView alloc] init];
        self.underline.backgroundColor = solidWhite;
        [self.toolbar addSubview:self.underline];
        
        //delegate
        self.loginUsernameField.delegate = self;
        self.loginPasswordField.delegate = self;
        self.signupUsernameField.delegate = self;
        self.signupPasswordField.delegate = self;
        self.signupEmailField.delegate = self;
    }
    return self;
}

/**
 * @method layoutSubviews
 *
 * Called to layoutSubviews
 */
- (void)layoutSubviews
{
    [super layoutSubviews];

    if (initialSetup)
    {
        initialSetup = NO;
        
        CGFloat width = 0.8;
        CGRect toolbarFrame = self.toolbar.frame;
        CGRect loginTabFrame = self.loginTab.frame;
        self.underline.frame = (CGRect){loginTabFrame.origin.x, toolbarFrame.size.height - width,
                                        loginTabFrame.size.width, width};
    }
}

/**
 * @method resetTextFieldBorders
 *
 * Resets all textField's bottom border color to faintWhite.
 */
- (void)resetTextFieldBorderColor
{
    self.loginUsernameField.bottomBorderColor = faintWhite;
    self.loginPasswordField.bottomBorderColor = faintWhite;
    self.signupUsernameField.bottomBorderColor = faintWhite;
    self.signupPasswordField.bottomBorderColor = faintWhite;
    self.signupEmailField.bottomBorderColor = faintWhite;
}



#pragma mark - IBAction
/**
 * @method loginTabPressed
 *
 * Called when user presses "Log in" tab.
 * Switches to "Log in" tab if not already.
 */
- (IBAction)loginTabPressed:(id)sender
{
    if (loginSelected)
        return;
    
    //var swap
    loginSelected = !loginSelected;
    [self.loginTab setTitleColor:solidWhite forState:UIControlStateNormal];
    [self.signupTab setTitleColor:faintWhite forState:UIControlStateNormal];
    
    //switch
    self.loginBoxOffset.constant = 0;
    [UIView animateWithDuration:0.2
     animations:^
     {
         CGRect frame = self.underline.frame;
         frame.origin.x = CGRectGetMinX(self.loginTab.frame);
         self.underline.frame = frame;
     
         [self.view layoutIfNeeded];
     }
     completion:^(BOOL finished)
     {
         [self.loginUsernameField becomeFirstResponder];
     }];
}

/**
 * @method signupTabPressed
 *
 * Called when user presses "Sign up" tab.
 * Switches to "Sign up" tab if not already.
 */
- (IBAction)signupTabPressed:(id)sender
{
    if (!loginSelected)
        return;
    
    //color change
    loginSelected = !loginSelected;
    [self.loginTab setTitleColor:faintWhite forState:UIControlStateNormal];
    [self.signupTab setTitleColor:solidWhite forState:UIControlStateNormal];
    
    //switch
    self.loginBoxOffset.constant = -self.frame.size.width;
    [UIView animateWithDuration:0.2
     animations:^
     {
         CGRect frame = self.underline.frame;
         frame.origin.x = CGRectGetWidth(self.loginTabContainer.frame);
         frame.origin.x += CGRectGetMidX(self.signupTab.frame) - CGRectGetWidth(frame)/2;
         self.underline.frame = frame;
     
         [self.view layoutIfNeeded];
     
     }
     completion:^(BOOL finished)
     {
         [self.signupEmailField becomeFirstResponder];
     }];
}



#pragma mark - UITextField Delegate
/**
 * @method textFieldShouldBeginEditing:
 *
 * Called when textField is about come into focus.
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self resetTextFieldBorderColor];
    APRTextField *field = (APRTextField *)textField;
    field.bottomBorderColor = solidWhite;

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [self resetTextFieldBorderColor];
}

/**
 * @method textFieldShouldReturn:
 *
 * Called when user pressed the set Return button
 * on the keyboard after editing a textField.
 * Either hand over focus (first responder) to another field,
 * or callback to delegate with appropirate parameters
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.loginUsernameField)
    {
        [self.loginPasswordField becomeFirstResponder];
    }
    else if (textField == self.loginPasswordField)
    {
        [textField resignFirstResponder];
        //callback to delegate
    }
    else if (textField == self.signupEmailField)
    {
        [self.signupPasswordField becomeFirstResponder];
    }
    else if (textField == self.signupPasswordField)
    {
        [self.signupUsernameField becomeFirstResponder];
    }
    else if (textField == self.signupUsernameField)
    {
        [textField resignFirstResponder];
        //FIXME: check for password confirm match
        //callback to delegate
    }
    return YES;
}



#pragma mark - Private Helpers



@end













