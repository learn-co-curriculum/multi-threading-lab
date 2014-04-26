//
//  FISZipCode.h
//  multiThreadLab
//
//  Created by Joe Burgess on 4/20/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISZipCode : NSObject

@property (strong, nonatomic) NSString *county;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;

@end
