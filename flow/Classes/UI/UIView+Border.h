
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BorderType)
{
    BorderTop,
    BorderLeft,
    BorderRight,
    BorderBottom
};

/**
 * @category UIView+Border
 * @brief    UIView+Border
 *
 * Border category for UIView allows control of borders
 * using CALayers and associated objects
 */
IB_DESIGNABLE
@interface UIView(Border)

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@property (nonatomic, strong, readonly) UIView *rightBorder;
@property (nonatomic) IBInspectable CGFloat rightBorderWidth;
@property (nonatomic) IBInspectable UIColor *rightBorderColor;
- (void)setRightBorderWidth:(CGFloat)width color:(UIColor *)color;

@property (nonatomic, strong, readonly) UIView *bottomBorder;
@property (nonatomic) IBInspectable CGFloat bottomBorderWidth;
@property (nonatomic) IBInspectable UIColor *bottomBorderColor;
- (void)setBottomBorderWidth:(CGFloat)width color:(UIColor *)color;

@end
