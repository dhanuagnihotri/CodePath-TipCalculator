//
//  TipViewController.m
//  TipCalculator
//
//  Created by Dhanu Agnihotri on 12/14/14.
//  Copyright (c) 2014 ___SocietyTech___. All rights reserved.

#import "TipViewController.h"
#import "AppDelegate.h"
#import "DefaultsManager.h"

#define TIME_INTERVAL_TO_REMEMBER 10*60 //Seconds

@interface TipViewController ()
@property (strong, nonatomic) IBOutlet UITextField *billTextField;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipPercentLabel;
@property (strong, nonatomic) IBOutlet UISlider *tipPercentSlider;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)billTextFieldValueChanged:(id)sender;
- (IBAction)onTap:(id)sender;

@property BOOL roundOffTotal;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tipPercentSlider.minimumValue = 0;
    self.tipPercentSlider.maximumValue = 100;
    
}

- (void)viewWillAppear:(BOOL)animated {
    //Load the default values
    self.tipPercentSlider.value = [[DefaultsManager sharedManager] tipPercent];
    self.tipPercentLabel.text = [NSString stringWithFormat:@"%ld%%",lround(self.tipPercentSlider.value) ];

    self.roundOffTotal = [[DefaultsManager sharedManager] roundOffTotal];
    NSDate* lastDate = [[DefaultsManager sharedManager] lastLaunchDate];
    if (lastDate)
    {
        NSTimeInterval secs = [[NSDate date] timeIntervalSinceDate:lastDate];
        NSLog(@"time interval %f", secs);
        if(secs < TIME_INTERVAL_TO_REMEMBER) //It's been under 10 minutes since the last app launch
        {
            self.billTextField.text = [NSString stringWithFormat:@"%1.2f",[[DefaultsManager sharedManager] lastBillAmount]];
            [self updateValues];
        }
    }

    if([[[DefaultsManager sharedManager] colorScheme] isEqualToString:@"Dark"])
        self.view.backgroundColor = [UIColor colorWithRed:0.071 green:0.208 blue:0.51 alpha:1]; /* Dark Blue #123582*/
    else
        self.view.backgroundColor = [UIColor colorWithRed:0.816 green:0.957 blue:0.996 alpha:1]; /*Light Blue #d0f4fe*/

    [self updateValues];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

-(void)updateValues
{
    float billAmount = [self.billTextField.text floatValue];
    
    float tipValue = billAmount * lround(self.tipPercentSlider.value)/100;
    
    float finalAmount = billAmount + tipValue;
    
    finalAmount = self.roundOffTotal ? lround(finalAmount):finalAmount;
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *currencyCode = [locale objectForKey:NSLocaleCountryCode];
    NSLog( @"currencyCode is %@", currencyCode );
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];

    self.tipLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:tipValue]];
    self.totalLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:finalAmount]];
    self.totalTextLabel.text = self.roundOffTotal ? @"Total(Round off) :" : @"Total :";
    
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
    self.tipPercentLabel.text = [NSString stringWithFormat:@"%ld%%",val];
    [self updateValues];
    
    //We don't update user defaults here, since the default setting is controlled by the settings page

}

- (IBAction)billTextFieldValueChanged:(id)sender {
    
    [[DefaultsManager sharedManager] updateLastBillAmount:[self.billTextField.text floatValue]];
    [self updateValues];
}

@end
