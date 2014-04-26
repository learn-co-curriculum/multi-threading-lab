//
//  FISZipSearchOperation.h
//  multiThreadLab
//
//  Created by Joe Burgess on 4/20/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FISZipCode.h"

@interface FISZipSearchOperation : NSOperation
@property (strong, nonatomic) NSString *searchZipCode;
@property (strong, nonatomic) void (^zipCodeBlock)(FISZipCode * zipCode, NSError *error);
@end
