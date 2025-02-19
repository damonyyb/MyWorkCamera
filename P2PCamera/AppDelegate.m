//
//  AppDelegate.m
//  P2PCamera
//
//  Created by Lu on 16/2/22.
//  Copyright © 2016年 Lu. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ActionViewController.h"
#import "AddCameraViewController.h"
#import "InfomationViewController.h"
#import "ZHLTViewController.h"
#import "TutkP2PClient.h"
#import "P2PCamera-Swift.h"

@interface AppDelegate ()

@property (nonatomic,strong) ZHLTViewController           *zhltVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [Myself initTutkManager:^{} failed:^{}];
    [self loadTabBar];
    self.window.backgroundColor = [UIColor whiteColor];
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];//注册本地推送
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loadTabBar
{
    NSArray *VCnames = @[@"MainViewController",
                         @"CamActionViewController",
                         @"AddCameraViewController",
                         @"InfomationViewController"];
    NSMutableArray *VCtitles = @[NSLocalizedString(@"barT_camera", @""),NSLocalizedString(@"barT_events", @""),NSLocalizedString(@"barT_new", @""),NSLocalizedString(@"barT_info", @"")];
    NSArray *VCimages = @[@"icon_home",@"icon_mine",@"icon_special",@"icon_search"];
    NSArray *VCimagesAct = @[@"icon_home_select",@"icon_mine_select",@"icon_special_select",@"icon_search_select"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc]init];
    for (NSInteger i=0; i<4; i++) {
        if (i != 1) {
        UIViewController *view = [[NSClassFromString(VCnames[i]) alloc]init];
        view.tabBarItem.title = VCtitles[i];
        view.tabBarItem.image = [UIImage imageNamed:VCimages[i]];
        view.tabBarItem.selectedImage = [UIImage imageNamed:VCimagesAct[i]];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
        [viewControllers addObject:nav];
        } else {
            UIViewController *view = [[CamActionViewController alloc]init];
            view.tabBarItem.title = VCtitles[i];
            view.tabBarItem.image = [UIImage imageNamed:VCimages[i]];
            view.tabBarItem.selectedImage = [UIImage imageNamed:VCimagesAct[i]];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
            [viewControllers addObject:nav];
        }
    }
    self.zhltVC.viewControllers = viewControllers;
    self.window.rootViewController = self.zhltVC;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSString *str = notification.alertBody;
    NSString *title = [notification.userInfo objectForKey:@"actionCamera"];
    NSString *main = [NSString stringWithFormat:@"%@: %@",str,title];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"A_camWarm", @"") message:main delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
}

- (ZHLTViewController *)zhltVC
{
    if (!_zhltVC) {
        _zhltVC = [[ZHLTViewController alloc]init];
        _zhltVC.tabBar.tintColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
    }
    return _zhltVC;
}
@end
