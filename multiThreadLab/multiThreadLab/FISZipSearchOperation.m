//
//  FISZipSearchOperation.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/26/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISZipSearchOperation.h"

@implementation FISZipSearchOperation

- (void)main
{
    if ([self.searchZipCode length] != 5)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [NSError errorWithDomain:@"Zip Codes Need to be 5 digits" code:101 userInfo:@{NSLocalizedDescriptionKey : @"Zip Codes need to be 5 digits"}];
            self.zipCodeBlock(nil, error);
        });
    }
    else
    {
        FISZipCode *zipCode = [self findZip:self.searchZipCode];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!zipCode)
            {
                
                NSError *error = [NSError errorWithDomain:@"Couldn't find that zip code" code:100 userInfo:@{NSLocalizedDescriptionKey : @"Couldn't find that zip code"}];
                self.zipCodeBlock(nil, error);
                
            }
            else
            {
                self.zipCodeBlock(zipCode, nil);
            }
        });
    }
}

- (FISZipCode *)findZip:(NSString *)zip
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zip_codes_states" ofType:@"csv"];
    NSError *error;
    NSString *contents = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUTF8StringEncoding error:&error];
    
    if (!error)
    {
        NSArray *rows = [contents componentsSeparatedByString:@"\n"];
        for (NSString *row in rows)
        {
            NSArray *columns = [row componentsSeparatedByString:@","];
            
            if ([[FISZipSearchOperation sanitizeString:columns[0]] isEqualToString:zip])
            {
                FISZipCode *zipcode = [[FISZipCode alloc] init];
                
                zipcode.latitude = [FISZipSearchOperation sanitizeString:columns[1]];
                zipcode.longitude = [FISZipSearchOperation sanitizeString:columns[2]];
                zipcode.city = [FISZipSearchOperation sanitizeString:columns[3]];
                zipcode.state = [FISZipSearchOperation sanitizeString:columns[4]];
                zipcode.county = [FISZipSearchOperation sanitizeString:columns[5]];
                
                return zipcode;
            }
        }
    }
    return nil;
}

+ (NSString *)sanitizeString:(NSString *)string
{
    return [[[string stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
}


@end
