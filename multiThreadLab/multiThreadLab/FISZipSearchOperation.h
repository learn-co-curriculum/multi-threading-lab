//
//  FISZipSearchOperation.h
//  multiThreadLab
//
//  Created by Joe Burgess on 4/26/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISZipCode.h"

@interface FISZipSearchOperation : NSOperation

@property (nonatomic, copy) void(^zipCodeBlock)(FISZipCode *zipCode, NSError *error);
@property (nonatomic) NSString *searchZipCode; 

@end
