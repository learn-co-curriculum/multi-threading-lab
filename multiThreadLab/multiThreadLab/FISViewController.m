//
//  FISViewController.m
//  multiThreadLab
//
//  Created by Joe Burgess on 3/24/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"
#import "FISZipSearchOperation.h"

@interface FISViewController ()
@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
- (IBAction)searchZipCodeTapped:(id)sender;
- (void) setRandomBGColor;

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.accessibilityLabel=@"Main View";
	// Do any additional setup after loading the view, typically from a nib.
    [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(setRandomBGColor) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchZipCodeTapped:(id)sender {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    FISZipSearchOperation *searchOp = [[FISZipSearchOperation alloc] init];
    searchOp.searchZipCode=self.zipCode.text;
    searchOp.zipCodeBlock = ^void(FISZipCode *zipCode, NSError *error)
    {
        if (zipCode) {
            self.countyLabel.text=zipCode.county;
            self.latitudeLabel.text=zipCode.latitude;
            self.longitudeLabel.text=zipCode.longitude;
            self.cityLabel.text=zipCode.city;
            self.stateLabel.text=zipCode.state;
        } else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Zip Code Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    };
    [queue addOperation:searchOp];
    [self.zipCode resignFirstResponder];
}

- (void)setRandomBGColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.backgroundColor = color;
}
@end
