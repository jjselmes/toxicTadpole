//
//  GameViewController.m
//  Boing!
//
//  Created by Jacob Selmes on 19/03/2015.
//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameEnd.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    
    [[GameKitHelper sharedGameKitHelper]authenticateLocalPlayer];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
   // skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    //skView.showsPhysics = YES;
    //skView.showsDrawCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
    SKScene * scene = [GameEnd sceneWithSize:skView.bounds.size andScore:0];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

-(void)viewDidAppear:(BOOL)animated {
    bannerView.delegate = self;
    CGFloat usableHeight = 0.0f;
    if (self.view.frame.size.width == 568.0f) {
        usableHeight = 32.0f;
    } else {
        usableHeight = 66.0f;
    }
    bannerView = [[ADBannerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - usableHeight, self.view.frame.size.width,usableHeight)];
    [self.view addSubview:bannerView];
}



- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"Banner has loaded");
    if (!adsVisible) {
        if (bannerView.superview == nil) {
            [self.view addSubview:bannerView];
        }
        adsVisible = YES;
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
    }
    
}

-(void)showAuthenticationViewController {
    GameKitHelper *gkh = [GameKitHelper sharedGameKitHelper];
    [self presentViewController:gkh.authenticationViewController animated:YES completion:nil];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES; // your app implements this method
    
    if (!willLeave && shouldExecuteAction){
        // insert code here to suspend any services that might conflict with the advertisement, for example, you might pause the game with an NSNotification like this...
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PauseScene" object:nil]; //optional
    }
    return shouldExecuteAction;
}

-(void) bannerViewActionDidFinish:(ADBannerView *)banner {
    NSLog(@"banner is done being fullscreen");
    //Unpause the game if you paused it previously.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnPauseScene" object:nil]; //optional
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (adsVisible == YES) {
        
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        adsVisible = NO;
        
        NSLog(@"banner unavailable");
    }
}

-(void) removeAds{
    if (adsVisible == YES)  {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        bannerView.frame = CGRectOffset(bannerView.frame, 0, bannerView.frame.size.height);
        [UIView commitAnimations];
        adsVisible = NO;
        NSLog(@"hiding banner");
        [bannerView cancelBannerViewAction];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
