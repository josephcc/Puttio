//
//  ModalZoomViewController.m
//  Puttio
//
//  Created by orta therox on 01/04/2012.
//  Copyright (c) 2012 ortatherox.com. All rights reserved.
//

#import "ModalZoomView.h"

static ModalZoomView *sharedInstance;

@interface ModalZoomView ()
@property (strong) UIView *backgroundView;
@property (strong) UIViewController <ModalZoomViewControllerProtocol> *viewController;
@property (assign) CGRect originalFrame;
- (BOOL)validated;
@end

@implementation ModalZoomView
@synthesize backgroundView, viewController, originalFrame;

+ (id)sharedInstance; {
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


+ (void)showFromRect:(CGRect)initialFrame withViewControllerIdentifier:(NSString *)viewControllerID andItem:(id)item {
    ModalZoomView *this = [self sharedInstance];
    if (this) {
        UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
        this.viewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:viewControllerID];
        if ([this validated]) {
            this.originalFrame = initialFrame;
            this.backgroundView = [[UIView alloc] initWithFrame:rootView.bounds];
            this.backgroundView.contentMode = UIViewContentModeScaleToFill;
            this.backgroundView.autoresizingMask = ( UIViewAutoresizingFlexibleLeftMargin |
                                               UIViewAutoresizingFlexibleWidth |
                                               UIViewAutoresizingFlexibleRightMargin |
                                               UIViewAutoresizingFlexibleTopMargin |
                                               UIViewAutoresizingFlexibleHeight |
                                               UIViewAutoresizingFlexibleBottomMargin);
            this.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:this action:@selector(backgroundViewTapped:)];
            [this.backgroundView addGestureRecognizer:tapGesture];
            
            [rootView addSubview:this.backgroundView];
            
            UIView *theView = this.viewController.view;
            CGRect finalFrame = theView.bounds;
            
            BOOL isLandscape = UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
            if (isLandscape) {                
                finalFrame.origin.x = rootView.frame.size.height / 2 - theView.frame.size.height / 2;
                finalFrame.origin.y = rootView.frame.size.width / 2 - theView.frame.size.width / 2;                
            }else{
                finalFrame.origin.x = rootView.frame.size.width / 2 - theView.frame.size.width / 2;
                finalFrame.origin.y = rootView.frame.size.height / 2 - theView.frame.size.height / 2;                
            }
            
            this.viewController.view.frame = initialFrame;
            this.viewController.item = item;
            
            [rootView addSubview:this.viewController.view];

            [UIView animateWithDuration:0.5 animations:^{
                this.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                theView.frame = finalFrame;
            }];            
        }
    }
}

+ (void)fadeOutViewAnimated:(BOOL)animated {
    CGFloat duration = animated? 0.3 : 0;
    
    ModalZoomView *this = [self sharedInstance];
    [UIView animateWithDuration:duration animations:^{
        this.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        this.viewController.view.frame = this.originalFrame;
        
    } completion:^(BOOL finished) {
        [this.backgroundView removeFromSuperview];
        [this.viewController viewWillDisappear:NO];
        [this.viewController viewWillUnload];
        [this.viewController.view removeFromSuperview];
        [this.viewController viewDidDisappear:NO];
        [this.viewController viewDidUnload];
        this.viewController = nil;
    }];
}

- (void)backgroundViewTapped:(UITapGestureRecognizer *)gesture {
    [self.class fadeOutViewAnimated:YES];
}

- (BOOL)validated {
    if (!self.viewController) {
        [NSException raise:@"No View Controller Found in Storyboard" format:@"No View Controller Found in Storyboard"];
    }
    if (![self.viewController conformsToProtocol:@protocol(ModalZoomViewControllerProtocol)]) {
        [NSException raise:@"View Controller doesn't conform to ModalZoomViewControllerProtocol" format:@"View Controller doesn't conform to ModalZoomViewControllerProtocol"];            
    }
    return YES;
}

@end
