//
//  FISZipSearchOperationSpec.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/23/14.
//  Copyright 2014 Joe Burgess. All rights reserved.
//

#ifdef ADVANCED

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "FISZipSearchOperation.h"
#import <Swizzlean.h>
#import "FISZipCode.h"


SpecBegin(FISZipSearchOperation)

describe(@"FISZipSearchOperation", ^{

    __block FISZipSearchOperation *zipCodeOp;
    __block NSOperationQueue *queue;
    __block Swizzlean *swizzle;

    beforeAll(^{
        swizzle = [[Swizzlean alloc] initWithClassToSwizzle:[NSString class]];

        //Replace zipcode csv lookup with a much smaller dataset for speed
        [swizzle swizzleClassMethod:@selector(stringWithContentsOfURL:encoding:error:) withReplacementImplementation:^(id _self, NSURL *url, NSStringEncoding enc, NSError **error){
            return @"\"zip_code\",\"latitude\",\"longitude\",\"city\",\"state\",\"county\"\n\"00501\",40.922326,-72.637078,\"Holtsville\",\"NY\",\"Suffolk\"\n\"00544\",40.922326,-72.637078,\"Holtsville\",\"NY\",\"Suffolk\"\n\"00601\",18.165273,-66.722583,\"Adjuntas\",\"PR\",\"Adjuntas\"\n\"00602\",18.393103,-67.180953,\"Aguada\",\"PR\",\"Aguada\"";
        }];
    });

    beforeEach(^{
        zipCodeOp = [[FISZipSearchOperation alloc] init];
        queue = [NSOperationQueue new];
    });

    it(@"Should return an error if the ZipCode isn't found", ^AsyncBlock{
        zipCodeOp.searchZipCode=@"00502";
        zipCodeOp.zipCodeBlock=^void(FISZipCode *zipCode, NSError *error){
            expect(zipCode).to.beNil;
            expect(error).toNot.beNil;
            expect(error.localizedDescription).to.equal(@"Couldn't find that zip code");
            expect(error.code).to.equal(100);
            done();
        };
        [queue addOperation:zipCodeOp];
    });

    it(@"Should return an error if the zipCode is too long", ^AsyncBlock {

        zipCodeOp.searchZipCode=@"000000502";
        zipCodeOp.zipCodeBlock=^void(FISZipCode *zipCode, NSError *error){
            expect(zipCode).to.beNil;
            expect(error).toNot.beNil;
            expect(error.localizedDescription).to.equal(@"Zip Codes need to be 5 digits");
            expect(error.code).to.equal(101);
            done();
        };
        [queue addOperation:zipCodeOp];
    });

    it(@"Should return an error if the zipCode is too short", ^AsyncBlock {

        zipCodeOp.searchZipCode=@"502";
        zipCodeOp.zipCodeBlock=^void(FISZipCode *zipCode, NSError *error){
            expect(zipCode).to.beNil;
            expect(error).toNot.beNil;
            expect(error.localizedDescription).to.equal(@"Zip Codes need to be 5 digits");
            expect(error.code).to.equal(101);
            done();
        };
        [queue addOperation:zipCodeOp];
    });
    
    it(@"should return a valid FISZipCode given a valid Zip Code", ^AsyncBlock{
        zipCodeOp.searchZipCode=@"00501";
        zipCodeOp.zipCodeBlock=^void(FISZipCode *zipCode, NSError *error){
            expect(zipCode).toNot.beNil;
            expect(error).to.beNil;
            expect(zipCode.county).to.equal(@"Suffolk");
            expect(zipCode.latitude).to.equal(@"40.922326");
            expect(zipCode.longitude).to.equal(@"-72.637078");
            expect(zipCode.state).to.equal(@"NY");
            expect(zipCode.city).to.equal(@"Holtsville");
            done();
        };
        [queue addOperation:zipCodeOp];
    });
    
});

SpecEnd

#endif
