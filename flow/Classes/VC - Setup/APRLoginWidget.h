
#import <UIKit/UIKit.h>
#import "APRTextField.h"

@protocol APRLoginWidgetDelegate

@optional
- (void)loginAttemptWithUsername:(NSString *)username password:(NSString *)password;

@end

/**
 * @class APRLoginWidget
 * @brief APRLoginWidget
 *
 * Reusable subclass of UIView with Log in/Sign up tabs.
 */
@interface APRLoginWidget : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<APRLoginWidgetDelegate> delegate;

@end
