//
//  FISViewController.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/26/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *zipCode;
@property (weak, nonatomic) IBOutlet UILabel *countyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

@property (nonatomic) NSMutableArray *zipCodes;
@property (nonatomic) NSMutableArray *lats;
@property (nonatomic) NSMutableArray *longs;
@property (nonatomic) NSMutableArray *cities;
@property (nonatomic) NSMutableArray *states;
@property (nonatomic) NSMutableArray *counties;


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
    
    [self parseCSV];
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

- (void)zipCodeError
{
    UIAlertView *zipCodeError = [[UIAlertView alloc] initWithTitle:@"Zip Code Error" message:@"Zip Codes need to be 5 digits" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    zipCodeError.accessibilityLabel = @"Zip Code Error";
    
    [zipCodeError show];
}

- (IBAction)searchZipCodeTapped:(id)sender
{
    if ([self.zipCode.text length] == 0 || [self.zipCode.text length] < 5 || [self.zipCode.text length] > 5)
    {
        [self zipCodeError];
    }
    else
    {
        [self lookupZipCode];
    }
}

- (void)lookupZipCode
{
    if ([self.zipCodes containsObject:self.zipCode.text])
    {
        NSUInteger index = [self.zipCodes indexOfObject:self.zipCode.text];
        
        self.countyLabel.text = self.counties[index];
        self.cityLabel.text = self.cities[index];
        self.stateLabel.text = self.states[index];
        self.latitudeLabel.text = self.lats[index];
        self.longitudeLabel.text = self.longs[index];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Zip Code Error" message:@"Couldn't find that zip code" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertView.accessibilityLabel = @"Zip Code Error";
        [alertView show]; 
    }
    
    [self.zipCode resignFirstResponder];
}

- (void)parseCSV
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zip_codes_states" ofType:@"csv"];
    NSError *error;
    NSString *contents = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUTF8StringEncoding error:&error];
    
    if (!error)
    {
        NSArray *rows = [contents componentsSeparatedByString:@"\n"];
        
        self.zipCodes = [NSMutableArray new];
        self.lats = [NSMutableArray new];
        self.longs = [NSMutableArray new];
        self.cities = [NSMutableArray new];
        self.states = [NSMutableArray new];
        self.counties = [NSMutableArray new];
        
        for (NSString *row in rows)
        {
            NSArray *columns = [row componentsSeparatedByString:@","];
            for (NSInteger x = 0; x < 6; x++)
            {
                if ([columns count] == 6)
                {
                    switch (x) {
                        case 0:
                            [self.zipCodes addObject:[FISViewController sanitizeString:columns[x]]];
                            break;
                        case 1:
                            [self.lats addObject:[FISViewController sanitizeString:columns[x]]];
                            break;
                        case 2:
                            [self.longs addObject:[FISViewController sanitizeString:columns[x]]];
                            break;
                        case 3:
                            [self.cities addObject:[FISViewController sanitizeString:columns[x]]];
                            break;
                        case 4:
                            [self.states addObject:[FISViewController sanitizeString:columns[x]]];
                            break;
                        case 5:
                            [self.counties addObject:[FISViewController sanitizeString:columns[x]]];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
        
        [self.zipCodes removeObjectAtIndex:0];
        [self.lats removeObjectAtIndex:0];
        [self.longs removeObjectAtIndex:0];
        [self.cities removeObjectAtIndex:0];
        [self.states removeObjectAtIndex:0];
        [self.counties removeObjectAtIndex:0];
    }
}

+ (NSString *)sanitizeString:(NSString *)string
{
    return [[[string stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
}


@end
