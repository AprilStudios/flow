# upto
iOS and AppleWatch app for setting and sharing what you're up to.

You will need to learn how to format Markdown Readme files in this manner.
- Refer to https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

### HeaderDocs Comments
This sections outlines the minimum commenting required for this project.
- http://www.raywenderlich.com/66395/documenting-in-xcode-with-headerdoc-tutorial
- https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/intro/intro.html
- https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/tags/tags.html

Classes:
```Objective-C
/**
 * @class <className>
 * @brief <className>
 *
 * Detailed description of what this class does,
 * and what kind of functions it provides.
 */
@interface className
```

Methods:
```Objective-C
/**
 * @method <methodName>
 *
 * Returns whether ...
 * @note important notes
 *
 * @param <name1> - description of
 * @param <name2> - description of
 * ...
 * @return returnType 
 */
- (returnType)methodNameParam1:(paramType)param1 param2:(paramType)param2
{
    ...
}
```


### Style Guide
This section outlines some coding practices.

**Code Formatting**
- Indenting is 4 spaces, not tabs.
- Curly brackets for scopes must line up
- Pointer asterisk `*` must be attached to the pointer name (`NSString *str`), not type (`NSString* str`)
- Condition parantheses for `if/else` and `for/while` loops must have a space before
- Inline-blocks must be lined up to the front of its containing statement.

_Good Example_
```Objective-C
//2-3 spaces after previous #pragma mark -

#pragma mark Public Methods
/**
 * headerdocs...
 */
- (void)method
{
    NSString *str = [[NSString alloc] init];
    if (condition)
    {
        ...
    }
    
    dispatch_async(dispatch_get_main_queue(), 
    ^{
        ...
    });
}
#pragma mark -
```

_Bad Example_
```Objective-C
//DONT DO
-(void)method{
    NSString* str = [[NSString alloc]init];
    if(condition == true){
        ...
    }
    
    dispatch_async(dispatch_get_main_queue(), 
                    ^{
                        ...
                    });
}
```

**File Formatting**
- All file names must start with an uppercase.
- Sections of code must start with `#pragma mark Label` and end with `#pragma mark -`
- Sections of code must be separated with 2-3 spaces of padding

```Objective-c
//Start of TestClass.cpp
#import "TestClass.h"

#import "Util.h"
#import "DataManager.h"


//about 2-3 lines of padding
@interface TestClass()
{
    //instance variables are one indentation in
    bool someBool;
}

//properties are not indented
@property (nonatomic, strong) NSString *username;

@end
#pragma mark -


//another 2-3 lines of padding
@implementation
#pragma mark Init Methods
/**
 * @method init
 *
 * ...
 */
- (instancetype)init
{
    ...
}
#pragma mark -


//another 2-3 lines of padding
#pragma mark Custom Accessors
/** 
 * @method getUsername
 * 
 * ...
 */
- (NSString *)getUsername
{
    ...
}
#pragma mark -
@end
```
