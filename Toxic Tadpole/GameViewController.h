//
//  GameViewController.h
//  Boing!
//

//  Copyright (c) 2015 Jacob Selmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameKitHelper.h"
#import <iAd/iAd.h>

@interface GameViewController : UIViewController <ADBannerViewDelegate>
{
    BOOL adsOnTop;
    BOOL adsVisible;
    ADBannerView *bannerView;
}

@end
