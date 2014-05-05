//
//  FISViewController.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/26/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import "FISZipSearchOperation.h"

@interface FISViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

- (IBAction)searchZipCodeTapped:(id)sender;
@end

@implementation FISViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.accessibilityLabel=@"Main View";
    // Do any additional setup after loading the view.
    
    self.zipCode.delegate = self;
    
    //[self parseCSV];
    [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(changeBackgroundColor) userInfo:nil repeats:YES];
}

- (void)changeBackgroundColor
{
    CGFloat redValue = ( arc4random() % 256 / 256.0 );
    CGFloat greenValue = ( arc4random() % 256 / 256.0 );
    CGFloat blueValue = ( arc4random() % 256 / 256.0 );
    UIColor *color = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0];
    
    self.view.backgroundColor = color;
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self lookupZipCode];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)searchZipCodeTapped:(id)sender
{
    [self lookupZipCode];
}

- (void)lookupZipCode
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    FISZipSearchOperation *zipCodeOp = [[FISZipSearchOperation alloc] init];
    zipCodeOp.searchZipCode = self.zipCode.text;
    
    zipCodeOp.zipCodeBlock = ^void(FISZipCode *zipCode, NSError *error){
        if (!error)
        {
            self.countyLabel.text = zipCode.county;
            self.cityLabel.text = zipCode.city;
            self.stateLabel.text = zipCode.state;
            self.latitudeLabel.text = zipCode.latitude;
            self.longitudeLabel.text = zipCode.longitude;
        }
        else
        {
            if (error.code == 100)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Zip Code Error" message:@"Couldn't find that zip code" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                alertView.accessibilityLabel = @"Zip Code Error";
                [alertView show];
            }
            else if (error.code == 101)
            {
                UIAlertView *zipCodeError = [[UIAlertView alloc] initWithTitle:@"Zip Code Error" message:@"Zip Codes need to be 5 digits" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                zipCodeError.accessibilityLabel = @"Zip Code Error";
                [zipCodeError show];
            }
        }
    };
    
    [queue addOperation:zipCodeOp];
    [self.zipCode resignFirstResponder];
}

@end
