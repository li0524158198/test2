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
@synthesize smiley,smileyView;
@synthesize segmentedControl;

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

- (void) applicationDidEnterBackground
{
    NSLog(@"MY:%@", NSStringFromSelector(_cmd));
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier taskId;
    taskId = [app beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background task ran out of time and was terminated");
        [app endBackgroundTask:taskId];
    }];
    
    if (taskId == UIBackgroundTaskInvalid)
    {
        NSLog(@"Failed to start background task@");
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Starting background task with %f seconds remaining", app.backgroundTimeRemaining);
        self.smiley = nil;
        self.smileyView = nil;
        
        NSInteger selectedIndex = self.segmentedControl.selectedSegmentIndex;
        [[NSUserDefaults standardUserDefaults] setInteger:selectedIndex forKey:@"selectedIndex"];
        
        //simulate a lengthy (25 seconds) produce
        [NSThread sleepForTimeInterval:25];
        
        NSLog(@"Finishing background task with %f seconds remaining", app.backgroundTimeRemaining);
        [app endBackgroundTask:taskId];
        
    });
}

- (void) applicationWillEnterForeground
{
//    NSLog(@"MY:%@", NSStringFromSelector(_cmd));
//    NSString *smileyPath = [[NSBundle mainBundle] pathForResource:@"smiley" ofType:@"png"];
//    
//    self.smiley = [UIImage imageWithContentsOfFile:smileyPath];
//    self.smileyView.image = self.smiley;
}

- (void) rotateLabelUp
{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
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
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
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
    self.smiley = nil;
    self.smileyView = nil;
    self.segmentedControl = nil;
    [super viewDidUnload];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
    
    CGRect bounds = self.view.bounds;
    CGRect labelFrame = CGRectMake(bounds.origin.x, CGRectGetMidY(bounds) - 50, bounds.size.width, 100);
    self.label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont fontWithName:@"Helvetica" size:70];
    label.text = @"Bazinga";
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    // smiley.png 8s 84 * 84
    CGRect smileyFrame = CGRectMake(CGRectGetMidX(bounds) - 42, CGRectGetMidY(bounds)/2 - 42, 84, 84);
    self.smileyView = [[UIImageView alloc] initWithFrame:smileyFrame];
    self.smileyView.contentMode = UIViewContentModeCenter;
    NSString *smileyPath = [[NSBundle mainBundle] pathForResource:@"smiley" ofType:@"png"];
    self.smiley = [UIImage imageWithContentsOfFile:smileyPath];
    self.smileyView.image = self.smiley;
    [self.view addSubview:smileyView];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"one", @"two", @"there", @"four", nil]];
    self.segmentedControl.frame = CGRectMake(bounds.origin.x + 20, CGRectGetMidY(bounds) - 50, bounds.size.width - 40, 30);
    [self.view addSubview:segmentedControl];
    
    [self.view addSubview:label];
    
    NSNumber *indexNumber;
    if ( indexNumber = [[NSUserDefaults standardUserDefaults]
                        objectForKey:@"selectedIndex"])
    {
        NSInteger selectedIndex = [indexNumber intValue];
        self.segmentedControl.selectedSegmentIndex = selectedIndex;
    }
    
    //    [self rotateLabelDown];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
