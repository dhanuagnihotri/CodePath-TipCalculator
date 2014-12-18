//
//  SettingsTableViewController.m
//  TipCalculator
//
//  Created by Dhanu Agnihotri on 12/14/14.
//  Copyright (c) 2014 ___SocietyTech___. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppDelegate.h"
#import "DefaultsManager.h"

@interface SettingsTableViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tipPercentTextField;
@property (strong, nonatomic) IBOutlet UISwitch *roundOffSwitch;
- (IBAction)tipPercentEditingDidEnd:(id)sender;
- (IBAction)roundOffValueChanged:(id)sender;

@property float tipPercent;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Load the default values
    self.tipPercent = [[DefaultsManager sharedManager] tipPercent];
    self.tipPercentTextField.text = [NSString stringWithFormat:@"%1.0f", self.tipPercent];

    self.roundOffSwitch.on = [[DefaultsManager sharedManager] roundOffTotal];
    
    [self loadColorScheme];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTableView:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapRecognizer];

}

// Hide on tap
- (void)didTapTableView:(UITapGestureRecognizer *)tap
{
    [self.tableView endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadColorScheme];
}

-(void) loadColorScheme
{
    if([[[DefaultsManager sharedManager] colorScheme] isEqualToString:@"Dark"])
    {
        self.view.backgroundColor = [UIColor colorWithRed:0.071 green:0.208 blue:0.51 alpha:1]; /*#123582*/
        UITableViewCell *darkThemeOption = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        darkThemeOption.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        UITableViewCell *lightThemeOption = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        lightThemeOption.accessoryType = UITableViewCellAccessoryCheckmark;
        self.view.backgroundColor = [UIColor colorWithRed:0.816 green:0.957 blue:0.996 alpha:1]; /*#d0f4fe*/
    }
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    switch (section)
    {
        case 1: //color theme
        {
            //Allow user to select only one at a time
            //Remove checkmark from all in this section
            NSInteger numRows =  [tableView numberOfRowsInSection:section];
            for (int i = 0; i < numRows; i++)
            {
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:index];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            //Add a checkmark for the selected row
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            if(row==0)
            {
                [[DefaultsManager sharedManager] updateColorScheme:@"Dark"];
                self.view.backgroundColor = [UIColor colorWithRed:0.071 green:0.208 blue:0.51 alpha:1]; /*#123582*/
            }
            else
            {
                [[DefaultsManager sharedManager] updateColorScheme:@"Light"];
                self.view.backgroundColor = [UIColor colorWithRed:0.816 green:0.957 blue:0.996 alpha:1]; /*#d0f4fe*/
           }
            break;
        }
        case 2: //Support
        {
            if(row==1) //email
                [self emailClicked:@"Support" toRecipient:@[@"dhanuagnihotri@gmail.com"] withBody:nil];
            break;
        }
        default:
            break;
    }
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - Email Support
- (IBAction)emailClicked:(NSString *)subject toRecipient:(NSArray *)recipient withBody:(NSString *)emailBody
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        if(subject)
            [composeViewController setSubject:subject];
        if(recipient)
            [composeViewController setToRecipients:recipient];
        if(emailBody)
            [composeViewController setMessageBody:emailBody isHTML:NO];
        
        [self presentViewController:composeViewController animated:YES completion:NULL];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - User defaults
- (IBAction)tipPercentEditingDidEnd:(id)sender {
    
    float percentValue = [self.tipPercentTextField.text floatValue];
    [[DefaultsManager sharedManager] updateTipPercent:percentValue];
    
}

- (IBAction)roundOffValueChanged:(id)sender {

    BOOL switchState = [self.roundOffSwitch isOn];
    [[DefaultsManager sharedManager] updateRoundOff:switchState];
    
}

@end
