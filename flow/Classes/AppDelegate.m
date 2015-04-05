
#import "AppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "flow-Bridging-Header.h"
#import "flow-Swift.h"


@interface AppDelegate ()

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //temp: clear all user defaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    /* Parse */
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"Buvc8IDSHi03HzlX3yvsfKcRivHGUE6Ii29yXdjb"
                  clientKey:@"Y2D55Q2nA3CgUWQGS61IlHy3K5r9iop8wM3fAkQF"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    /* Facebook */
    FBSDKAccessToken *token = [self loadAccessToken];
    [FBSDKAccessToken setCurrentAccessToken:token];
    
    /* Set RootVC */
    NSString *sbName = @"Setup";
    NSString *vcName = @"LoginVC";
    [[NSUserDefaults standardUserDefaults] setObject:@"test" forKey:@"nickname"];
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"] )
    {
       sbName = @"Main";
       vcName = @"MainVC";
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = (UIViewController *)[sb instantiateViewControllerWithIdentifier:vcName];
    [self.window setRootViewController:vc];
    
    //Show window
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

/**
 * @method applciationWillResignActive
 *
 *
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 * @method applicaitonDidEnterBackground
 *
 *
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

/**
 * @method applicationWillEnterForeground
 *
 *
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    //here you can undo many of the changes made on entering the background.
}

/**
 * @method applicationDidBecomeActive:
 *
 *
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

/**
 * @method applicationWillTerminate
 *
 *
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


#pragma mark - Facebook Setup
/**
 * @method application:openURL:sourceApplication:annotation
 *
 *
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance]
            application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}


/**
 * @method loadAccessToken
 *
 * Loads a FB AccessToken from UserDefaults.
 * If it doesnt exist, returns nil.
 */
- (FBSDKAccessToken *)loadAccessToken
{
    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentAccessToken"];
    FBSDKAccessToken *token = (!tokenData) ? nil : [[FBSDKAccessToken alloc]
                                                    initWithTokenString:tokenData[@"tokenString"]
                                                    permissions:tokenData[@"permissions"]
                                                    declinedPermissions:tokenData[@"declinedPermissions"]
                                                    appID:tokenData[@"appID"]
                                                    userID:tokenData[@"userID"]
                                                    expirationDate:tokenData[@"expirationDate"]
                                                    refreshDate:tokenData[@"refreshDate"]];
    
    return token;
}

@end





