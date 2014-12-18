//
//  Defaults.h
//  TipCalculator
//
//  Created by Dhanu Agnihotri on 12/17/14.
//  Copyright (c) 2014 ___SocietyTech___. All rights reserved.

@import Foundation;

@interface DefaultsManager : NSObject

+ (instancetype)sharedManager;

@property float tipPercent;
@property BOOL roundOffTotal;
@property (nonatomic,strong) NSString *colorScheme;
@property float lastBillAmount;
@property (nonatomic,strong) NSDate* lastLaunchDate;

-(void)updateTipPercent:(float)tipPercent;
-(void)updateRoundOff:(BOOL)roundOff;
-(void)updateColorScheme:(NSString *)colorScheme;
-(void)updateLastBillAmount:(float)billAmount;
-(void)updateLastLaunchDate:(NSDate*)date;

@end
