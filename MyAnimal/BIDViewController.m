//
//  BIDViewController.m
//  MyAnimal
//
//  Created by liweihua on 14-4-4.
//  Copyright (c) 2014年 lwh. All rights reserved.
//

#import "BIDViewController.h"

@interface BIDViewController ()

@property (assign, nonatomic) BOOL animate;
- (void) rotateLabelUp;
- (void) rotateLabelDown;

@end

@implementation BIDViewController

@synthesize label;
@synthesize animate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) applicationWillResignActive
{
    NSLog(@"MY:%@", NSStringFromSelector(_cmd));
    animate = NO;
}

- (void) applicationDidBecomeActive
{
    NSLog(@"MY:%@", NSStringFromSelector(_cmd));
    animate = YES;
    [self rotateLabelDown];
}

- (void) rotateLabelUp
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         label.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:^(BOOL finished) {
                         if (animate)
                         {
                             [self rotateLabelDown];
                         }
                     }];
}

- (void) rotateLabelDown
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         label.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion:^(BOOL finished){
                         [self rotateLabelUp];
                     }];
}

- (void) rotateLabelCircle
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         label.transform = CGAffineTransformMakeRotation(M_PI * 0.75);
                     }
                     completion:^(BOOL finished) {
                         [self rotateLabelDown];
                     }];
}

- (void) viewDidUnload
{
    self.label = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:[UIApplication sharedApplication]];
    
    CGRect bounds = self.view.bounds;
    CGRect labelFrame = CGRectMake(bounds.origin.x, CGRectGetMidY(bounds) - 50, bounds.size.width, 100);
    self.label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont fontWithName:@"Helvetica" size:70];
    label.text = @"Bazinga";
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    //    [self rotateLabelDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
