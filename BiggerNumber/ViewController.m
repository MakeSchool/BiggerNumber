//
//  ViewController.m
//  BiggerNumber
//
//  Created by Benjamin Encz on 09/03/14.
//  Copyright (c) 2014 Benjamin Encz. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong) NSTimer *timer;
@property (assign) int timeLeft;
@property (assign) int leftNumber;
@property (assign) int rightNumber;
@property (assign) int points;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self restartGame];
}

-(void)restartGame {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(tick) userInfo:nil repeats:TRUE];
    self.timeLeft = 30;
    self.points = 0;
    [self nextRound];
    
    self.pointLabel.text = [NSString stringWithFormat:@"%d", self.points];
    self.timeLabel.text = [NSString stringWithFormat:@"%d", self.timeLeft];
}

- (void)tick {
    if (self.timeLeft > 0) {
        self.timeLeft--;
        self.timeLabel.text = [NSString stringWithFormat:@"%d", self.timeLeft];
    } else {
        [self gameOver];
    }
}

- (void)gameOver {
    NSString *gameOverString = [NSString stringWithFormat:@"You scored %d points!", self.points];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:gameOverString delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:nil];
    [alert show];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self restartGame];
}

- (void)nextRound {
    self.pointLabel.text = [NSString stringWithFormat:@"%d", self.points];
    
    NSArray *randomNumbers = [self generate:2 randomUniqueNumbersBetween:1 upperLimit:500];
    self.leftNumber = [randomNumbers[0] intValue];
    self.rightNumber = [randomNumbers[1] intValue];
    
    NSString *leftNumberText = [NSString stringWithFormat:@"%d", self.leftNumber];
    NSString *rightNumberText = [NSString stringWithFormat:@"%d", self.rightNumber];

    [self.leftButton setTitle:leftNumberText forState:UIControlStateNormal];
    [self.rightButton setTitle:rightNumberText forState:UIControlStateNormal];
}

- (NSArray *)generate:(int)n randomUniqueNumbersBetween:(int)lowerLimit upperLimit:(int)upperLimit
{
    NSMutableArray *randomNumberArray = [NSMutableArray arrayWithCapacity:upperLimit-lowerLimit];
    
    // add all numbers to array
    for (int i = lowerLimit; i < upperLimit; i++)
    {
        [randomNumberArray addObject:@(i)];
    }
    
    // shuffle array
    for (int i = 0; i < [randomNumberArray count]; i++)
    {
        int j = arc4random() % [randomNumberArray count];
        [randomNumberArray replaceObjectAtIndex:i withObject:randomNumberArray[j]];
    }
    
    return [randomNumberArray subarrayWithRange:NSMakeRange(0,n)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftButtonTouched:(id)sender {
    if (self.leftNumber > self.rightNumber) {
        self.points++;
    } else {
        self.points--;
    }
    
    [self nextRound];
}

- (IBAction)rightButtonTouched:(id)sender {
    if (self.rightNumber > self.leftNumber) {
        self.points++;
    } else {
        self.points--;
    }
    
    [self nextRound];
}


@end
