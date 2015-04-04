
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
    
    /* Parse */
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"Buvc8IDSHi03HzlX3yvsfKcRivHGUE6Ii29yXdjb"
                  clientKey:@"Y2D55Q2nA3CgUWQGS61IlHy3K5r9iop8wM3fAkQF"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    /*PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
     testObject[@"foo"] = @"bar";
     [testObject saveInBackground];*/
    
    APRParseManager *parseManager = [[APRParseManager alloc]init];
    /*[parseManager test];
    [parseManager nicknameForUserID:@"abcde" completion:^(NSString *nickname){
        NSLog(@"async nickname: %@", nickname);
    }];
    [parseManager userIDForNickname:@"LOLDENNIS" completion:^(NSString *userID){
        NSLog(@"async id: %@", userID);
    }];*/
    //APRUser u = APRUser(@"SWAGSWAGLIKECAILLOU", @"NO");
    APRUser *u = [[APRUser alloc] initWithN:@"SWAGSWAG" u:@"NO"];
    [parseManager addUser:u];
    
    
    /* Facebook */
    [FBSDKLoginButton class];
    
    //AccessToken
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSDictionary *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentAccessToken"];
    FBSDKAccessToken *token = (!tokenData) ? nil : [[FBSDKAccessToken alloc]
                                                    initWithTokenString:tokenData[@"tokenString"]
                                                    permissions:tokenData[@"permissions"]
                                                    declinedPermissions:tokenData[@"declinedPermissions"]
                                                    appID:tokenData[@"appID"]
                                                    userID:tokenData[@"userID"]
                                                    expirationDate:tokenData[@"expirationDate"]
                                                    refreshDate:tokenData[@"refreshDate"]];
    
    //Determine which VC to show
    NSString *sbName = @"Login";
    NSString *vcName = @"LoginVC";
    if (token && token.expirationDate.timeIntervalSinceNow > 0)
    {
        [FBSDKAccessToken setCurrentAccessToken:token];
        
        sbName = @"Main";
        vcName = @"MainVC";
        if (username)
        {
            sbName = @"Login";
            vcName = @"UsernameVC";
        }
    }
    
    //Set appropriate VC
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc = (UIViewController *)[sb instantiateViewControllerWithIdentifier:vcName];
    [self.window setRootViewController:vc];
    
    //Show window
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}



#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.aprilstudios.flow" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"flow" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"flow.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
