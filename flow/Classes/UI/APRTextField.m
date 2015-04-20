
#import "APRTextField.h"
#import "UIView+Border.h"

@interface APRTextField()

@end
#pragma mark -



@implementation APRTextField
#pragma mark Init
/**
 * @method initWithCoder
 *
 * Init method used by storyboard to create objects
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        
    }
    return self;
}



#pragma mark - Accessors
/**
 * @method setPlaceholderColor
 *
 * Sets the placeholder color as the given one
 * using attributed placeholder regardless of current type.
 */
- (void)setPlaceholderColor:(UIColor *)color
{
    _placeholderColor = color;
    
    NSString *text = self.placeholder;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text
                                                                 attributes:@{NSForegroundColorAttributeName : _placeholderColor}];
}



#pragma mark - Public Mehthos


@end
