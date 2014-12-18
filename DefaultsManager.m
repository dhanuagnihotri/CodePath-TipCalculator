//
//  Defaults.m
//  TipCalculator
//
//  Created by Dhanu Agnihotri on 12/17/14.
//  Copyright (c) 2014 ___SocietyTech___. All rights reserved.

#import "DefaultsManager.h"

#define TIP_PERCENT_DEFAULT 15
#define ROUND_OFF_TOTAL_DEFAULT NO
#define COLOR_SCHEME_DEFAULT @"Light"

@interface DefaultsManager()

@property (strong,nonatomic) NSUserDefaults *defaults;

@end


@implementation DefaultsManager

NSString * const tipPercentKey= @"tip_percent";
NSString * const roundOffTotalKey= @"round_off_total";
NSString * const colorSchemeKey= @"color_scheme";
NSString * const lastBillAmountKey= @"last_bill_amount";
NSString * const lastActiveDateKey= @"last_active_date";


#pragma mark - Singleton Stuff

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

- (id)init {
    if (self = [super init])
    {
        //Load the default values
        _defaults = [NSUserDefaults standardUserDefaults];
        
        self.tipPercent = [_defaults integerForKey:tipPercentKey];
        if(!self.tipPercent)
            self.tipPercent = TIP_PERCENT_DEFAULT;
        
        self.roundOffTotal = [_defaults boolForKey:roundOffTotalKey];
        if(!self.roundOffTotal)
            self.roundOffTotal = ROUND_OFF_TOTAL_DEFAULT;
        
        self.colorScheme = [_defaults stringForKey:colorSchemeKey];
        if(!self.colorScheme)
            self.colorScheme = COLOR_SCHEME_DEFAULT;
        
        self.lastBillAmount = [_defaults integerForKey:lastBillAmountKey];

        self.lastLaunchDate = [_defaults objectForKey:lastActiveDateKey];

    }
    return self;
}

#pragma mark - Update defaults
-(void)updateTipPercent:(float)tipPercent
{
    self.tipPercent = tipPercent;
    [_defaults setInteger:tipPercent forKey:tipPercentKey];
    [_defaults synchronize];
}

-(void)updateRoundOff:(BOOL)roundOff
{
    self.roundOffTotal = roundOff;
    [_defaults setBool:roundOff forKey:roundOffTotalKey];
    [_defaults synchronize];
}

-(void)updateColorScheme:(NSString *)colorScheme
{
    self.colorScheme = colorScheme;
    [_defaults setObject:colorScheme forKey:colorSchemeKey];
    [_defaults synchronize];
}

-(void)updateLastBillAmount:(float)billAmount
{
    self.lastBillAmount = billAmount;
    [_defaults setInteger:billAmount forKey:lastBillAmountKey];
    [_defaults synchronize];
}

-(void)updateLastLaunchDate:(NSDate*)date
{
    self.lastLaunchDate = date;
    [_defaults setObject:date forKey:lastActiveDateKey];
    [_defaults synchronize];
}

@end

