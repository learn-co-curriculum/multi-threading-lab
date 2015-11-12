//
//  FISZipCodeSpec.m
//  multiThreadLab
//
//  Created by Joe Burgess on 4/22/14.
//  Copyright 2014 Joe Burgess. All rights reserved.
//

#ifdef ADVANCED

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "FISZipCode.h"


SpecBegin(FISZipCode)

describe(@"FISZipCode", ^{
    __block FISZipCode *zipCode;

    beforeEach(^{
        zipCode = [[FISZipCode alloc] init];
    });

    it(@"Should have a county NSString property", ^{
        expect(zipCode).to.respondTo(@selector(county));
        expect(zipCode).to.respondTo(@selector(setCounty:));

        zipCode.county=@"Fairfax";

        expect(zipCode.county).to.beKindOf([NSString class]);
        expect(zipCode.county).to.equal(@"Fairfax");
    });
    
    it(@"Should have a latitude NSString property", ^{
        expect(zipCode).to.respondTo(@selector(latitude));
        expect(zipCode).to.respondTo(@selector(setLatitude:));

        zipCode.latitude=@"Fairfax";

        expect(zipCode.latitude).to.beKindOf([NSString class]);
        expect(zipCode.latitude).to.equal(@"Fairfax");
    });

    it(@"Should have a longitude NSString property", ^{
        expect(zipCode).to.respondTo(@selector(longitude));
        expect(zipCode).to.respondTo(@selector(setLongitude:));

        zipCode.longitude=@"Fairfax";

        expect(zipCode.longitude).to.beKindOf([NSString class]);
        expect(zipCode.longitude).to.equal(@"Fairfax");
    });

    it(@"Should have a city NSString property", ^{
        expect(zipCode).to.respondTo(@selector(city));
        expect(zipCode).to.respondTo(@selector(setCity:));

        zipCode.city=@"Fairfax";

        expect(zipCode.city).to.beKindOf([NSString class]);
        expect(zipCode.city).to.equal(@"Fairfax");
    });

    it(@"Should have a state NSString property", ^{
        expect(zipCode).to.respondTo(@selector(state));
        expect(zipCode).to.respondTo(@selector(setState:));

        zipCode.state=@"Fairfax";

        expect(zipCode.state).to.beKindOf([NSString class]);
        expect(zipCode.state).to.equal(@"Fairfax");
    });
});

SpecEnd
#endif