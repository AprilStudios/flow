
#import "UIView+Border.h"
#import <objc/runtime.h>


@implementation UIView (Border)
#pragma mark All Borders
/**
 * @method borderWidth
 *
 * Returns the border width for this view.
 * @note this value will be 0 if any individual borders widths are set.
 */
- (CGFloat)borderWidth
{
    if(!objc_getAssociatedObject(self, @selector(borderWidth)))
        objc_setAssociatedObject(self, @selector(borderWidth), [NSNumber numberWithFloat:0.0], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}

/**
 * @method setBorderWidth
 *
 * Sets the given width as border width
 */
- (void)setBorderWidth:(CGFloat)width
{
    objc_setAssociatedObject(self, @selector(borderWidth), [NSNumber numberWithFloat:width], OBJC_ASSOCIATION_COPY_NONATOMIC);

    //
    self.bottomBorderWidth = width;
}

/**
 * @method borderColor
 *
 * Returns the border color for view.
 * @note color will be clear if any individual border colors are set
 */
- (UIColor *)borderColor
{
    if(!objc_getAssociatedObject(self, @selector(borderColor)))
        objc_setAssociatedObject(self, @selector(borderColor), [UIColor clearColor], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, @selector(borderColor));
}

/**
 * @mtethod setBorderColor
 *
 * Sets the given color as border colors for all sides
 */
- (void)setBorderColor:(UIColor *)color
{
    objc_setAssociatedObject(self, @selector(borderColor), color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    //
    self.bottomBorderColor = color;
}



#pragma mark - Right Border
/**
 * @method rightBorder
 *
 * Returns the bottom border UIView for this view.
 * Initialized to
 */
- (UIView *)rightBorder
{
    if(!objc_getAssociatedObject(self, @selector(rightBorder)))
    {
        CGSize size = self.frame.size;
        UIView *border = [[UIView alloc] init];
        border.frame = (CGRect){size.width - self.borderWidth, 0, self.borderWidth, size.height};
        border.backgroundColor = self.borderColor;
        
        objc_setAssociatedObject(self, @selector(rightBorder), border, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.rightBorderWidth = self.borderWidth;
        self.rightBorderColor = self.borderColor;
        
        [self addSubview:border];
    }
    
    return objc_getAssociatedObject(self, @selector(rightBorder));
}

/**
 * @method rightBorderWidth
 *
 * Returns the width(thickness) of the bottom border for this view,
 * Which should be the border frame's height
 */
- (CGFloat)rightBorderWidth
{
    return self.rightBorder.frame.size.width;
}

/**
 * @method setrightBorderWidth
 *
 * Sets the given width as the bottom border's new width.
 * If already set with borderWidth, nothing is changed.
 * Otherwise, bottom border's frames are adjusted and
 * borderWidth for all four sides are reset.
 */
- (void)setRightBorderWidth:(CGFloat)width
{
    /// NOTE: note that this method of comparing floats is in no way safe for most cases,
    ///       but for the simplicitiy of the situation, I opted to just use ==
    if (self.borderWidth == width)
        return;
    
    UIView *border = self.rightBorder;
    CGSize size = self.frame.size;
    CGRect frame = border.frame;
    frame.origin.x = size.width - width;
    frame.size.width = width;
    border.frame = frame;
    
    self.borderWidth = 0;
}

/**
 * @method rightBorderColor
 *
 * Returns the color of the bottom border for this view,
 * which is also the UIView's background color.
 */
- (UIColor *)rightBorderColor
{
    return self.rightBorder.backgroundColor;
}

/**
 * @Method setrightBorderColor
 *
 * Sets the given color as bottom border's color
 */
- (void)setRightBorderColor:(UIColor *)color
{
    if ([self.borderColor isEqual:color])
        return;
    
    self.rightBorder.backgroundColor = color;
    self.borderColor = [UIColor clearColor];
}

/**
 * @method setRightBorderWidth:color:
 *
 * Sets the width and color of bototm border
 */
- (void)setRightBorderWidth:(CGFloat)width color:(UIColor *)color
{
    self.rightBorderWidth = width;
    self.rightBorderColor = color;
}



#pragma mark - Bottom Border
/**
 * @method bottomBorder
 *
 * Returns the bottom border UIView for this view.
 * Initialized to
 */
- (UIView *)bottomBorder
{
    if(!objc_getAssociatedObject(self, @selector(bottomBorder)))
    {
        CGSize size = self.frame.size;
        UIView *border = [[UIView alloc] init];
        border.frame = (CGRect){0, size.height - self.borderWidth, size.width, self.borderWidth};
        border.backgroundColor = self.borderColor;
        
        objc_setAssociatedObject(self, @selector(bottomBorder), border, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.bottomBorderWidth = self.borderWidth;
        self.bottomBorderColor = self.borderColor;
        
        [self addSubview:border];
    }
    
    return objc_getAssociatedObject(self, @selector(bottomBorder));
}

/**
 * @method bottomBorderWidth
 *
 * Returns the width(thickness) of the bottom border for this view,
 * Which should be the border frame's height
 */
- (CGFloat)bottomBorderWidth
{
    return self.bottomBorder.frame.size.height;
}

/**
 * @method setBottomBorderWidth
 *
 * Sets the given width as the bottom border's new width.
 * If already set with borderWidth, nothing is changed.
 * Otherwise, bottom border's frames are adjusted and 
 * borderWidth for all four sides are reset.
 */
- (void)setBottomBorderWidth:(CGFloat)width
{
    /// NOTE: note that this method of comparing floats is in no way safe for most cases,
    ///       but for the simplicitiy of the situation, I opted to just use ==
    if (self.borderWidth == width)
        return;
    
    UIView *border = self.bottomBorder;
    CGSize size = self.frame.size;
    CGRect frame = border.frame;
    frame.origin.y = size.height - width;
    frame.size.height = width;
    border.frame = frame;
    
    self.borderWidth = 0;
}

/**
 * @method bottomBorderColor
 *
 * Returns the color of the bottom border for this view,
 * which is also the UIView's background color.
 */
- (UIColor *)bottomBorderColor
{
    return self.bottomBorder.backgroundColor;
}

/**
 * @Method setBottomBorderColor
 *
 * Sets the given color as bottom border's color
 */
- (void)setBottomBorderColor:(UIColor *)color
{
    if ([self.borderColor isEqual:color])
        return;
    
    self.bottomBorder.backgroundColor = color;
    self.borderColor = [UIColor clearColor];
}

/**
 * @method setBottomBorderWidth:color:
 *
 * Sets the width and color of bototm border
 */
- (void)setBottomBorderWidth:(CGFloat)width color:(UIColor *)color
{
    self.bottomBorderWidth = width;
    self.bottomBorderColor = color;
}

@end














