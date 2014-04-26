//
//  FISZipSearchOperation.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/20/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISZipSearchOperation.h"

@implementation FISZipSearchOperation

-(void)main
{
    if ([self.searchZipCode length]!=5)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSDictionary *userInfoDictionary = @{NSLocalizedDescriptionKey: @"Zip Codes need to be 5 digits"};
            NSError *error = [NSError errorWithDomain:@"ZipCodeNotFound" code:101 userInfo:userInfoDictionary];
            self.zipCodeBlock(nil,error);
        }];
        return;
    }
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
            if ([zip isEqualToString:self.searchZipCode]) {
                FISZipCode *zipCode = [[FISZipCode alloc] init];
                zipCode.county= county;
                zipCode.latitude = latitude;
                zipCode.longitude = longitude;
                zipCode.state=state;
                zipCode.city=city;
                found=YES;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    self.zipCodeBlock(zipCode,nil);
                }];
                return;
            }
        }
    }
    if (!found) {
        NSDictionary *userInfoDictionary = @{NSLocalizedDescriptionKey: @"Couldn't find that zip code"};
        NSError *error = [NSError errorWithDomain:@"ZipCodeNotFound" code:100 userInfo:userInfoDictionary];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.zipCodeBlock(nil,error);
        }];
        return;
    }
}
@end
