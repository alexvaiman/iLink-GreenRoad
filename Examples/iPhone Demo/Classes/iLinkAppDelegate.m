//
//  iLinkAppDelegate.m
//  iLink
//
//  Created by Idan S on 11/01/2014.
//  Copyright 2014 Idan S
//

#import "iLinkAppDelegate.h"
#import "iLink.h"


@implementation iLinkAppDelegate

#pragma mark -
#pragma mark Application lifecycle

+ (void)initialize
{
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    [iLink sharedInstance].applicationBundleID = @"com.clickgamer.AngryBirds"; // For test purposes //
	[iLink sharedInstance].onlyPromptIfLatestVersion = NO;
    
    [iLink sharedInstance].applicationVersion = @"1.0"; // For test purposes //
    
    [iLink sharedInstance].localNotificationWhenUpdate = YES; // This is optional if you want library to send local notification when an update is avilable //
    
    //[iLink sharedInstance].aggressiveUpdatePrompt = YES; // Would initiate update prompt always, blocking the screen //
    
    //[iLink sharedInstance].globalPromptForUpdate = NO; // Set it to "NO" if you don't want to use update prompt when new version is avilable //
    // enable preview mode //  if YES would show prompt always //
    [iLink sharedInstance].previewMode = YES;
}

- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions
{    
    [self.window makeKeyAndVisible];
 
#if TARGET_OS_IPHONE
    // Needed for background fetch (check if an update is available on background) //
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

#if DEBUG
    // Below is just to show prompt on testing, no need on production //
    if ([iLink sharedInstance].globalPromptForUpdate) {
        [[iLink sharedInstance] promptForUpdate];
    }
#endif
    
#endif
    
    return YES;
}

- (void)iLinkDidFindiTunesInfo{
    NSLog(@"App local URL: %@", [iLink sharedInstance].iLinkGetAppURLforLocal );
    NSLog(@"App sharing URL: %@", [iLink sharedInstance].iLinkGetAppURLforSharing );
    NSLog(@"App rating URL: %@", [iLink sharedInstance].iLinkGetRatingURL );
    NSLog(@"App Developer URL: %@", [iLink sharedInstance].iLinkGetDeveloperURLforSharing);
    
    //[[iLink sharedInstance] iLinkOpenDeveloperPage]; // Would open developer page on the App Store
    //[[iLink sharedInstance] iLinkOpenAppPageInAppStoreWithAppleID:553834731]; // Would open a different app then the current, For example the paid version. Just put the Apple ID of that app.
    
    //[[iLink sharedInstance] iLinkOpenRatingsPageInAppStore]; // Would open rating page on the App Store depend on OS version //
}

#pragma mark Local Notifications (needed for checking store version on background and show update prompt when user click on the notification)

#if TARGET_OS_IPHONE
-(void) application:(__unused UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    
    if ([[iLink sharedInstance] isUpdateLocalNotification:notification] ) {
        [[iLink sharedInstance] promptForUpdate];
    }
    
    NSLog(@" notification recived %@",[notification description] ); 
    
}


-(void) application:(__unused UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"application performFetchWithCompletionHandler");
    [[iLink sharedInstance] checkForUpdateOnBackground]; // JUST for debug ///
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        completionHandler(UIBackgroundFetchResultNewData);
    });
}
#endif
@end
