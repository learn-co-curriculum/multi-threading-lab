//
//  FISViewController.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/26/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()
@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

- (IBAction)searchZipCodeTapped:(id)sender;
- (void)setRandomBGColor;
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
    [NSTimer scheduledTimerWithTimeInterval:.25 target:self selector:@selector(setRandomBGColor) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchZipCodeTapped:(id)sender

{
    if ([self.zipCode.text length]!=5)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Zip Code Error" message:@"Zip Codes need to be 5 digits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zip_codes_states" ofType:@"csv"];
        NSString *contents = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [contents componentsSeparatedByString:@"\n"];
        BOOL found=NO;
        for (NSString *line in lines) {
            NSArray *items = [line componentsSeparatedByString:@","];
            if ([items count]==6 && ![items[0] isEqualToString:@"\"zip_code\""] ) {
                NSString *zip = [items[0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSString *latitude = [items[1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSString *longitude = [items[2] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSString *city = [items[3] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSString *state = [items[4] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSString *county = [items[5] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                if ([zip isEqualToString:self.zipCode.text]) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        self.cityLabel.text=city;
                        self.countyLabel.text=county;
                        self.latitudeLabel.text=latitude;
                        self.longitudeLabel.text=longitude;
                        self.stateLabel.text=state;
                    }];
                    found=YES;
                    return;
                }
            }
        }
        if (!found)
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Zip Code Error" message:@"Couldn't find that zip code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }];
            return;
        }
    }];
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


