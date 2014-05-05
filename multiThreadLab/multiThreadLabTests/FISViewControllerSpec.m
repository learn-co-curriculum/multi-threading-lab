//
//  FISViewControllerSpec.m
//  
//
//  Created by Joe Burgess on 4/17/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "KIF.h"
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "Swizzlean.h"

SpecBegin(FISViewController)


describe(@"FISViewController", ^{
    __block Swizzlean *swizzle;

    beforeAll(^{
        swizzle = [[Swizzlean alloc] initWithClassToSwizzle:[NSString class]];

        // Replace the stringWithContents method with a much smaller dataset. Also check it doesn't get called on the main thread

        [swizzle swizzleClassMethod:@selector(stringWithContentsOfURL:encoding:error:) withReplacementImplementation:^(id _self, NSURL *url, NSStringEncoding enc, NSError **error){

            expect([NSThread isMainThread]).to.equal(NO);
            
            return @"\"zip_code\",\"latitude\",\"longitude\",\"city\",\"state\",\"county\"\n\"00501\",40.922326,-72.637078,\"Holtsville\",\"NY\",\"Suffolk\"\n\"00544\",40.922326,-72.637078,\"Holtsville\",\"NY\",\"Suffolk\"\n\"00601\",18.165273,-66.722583,\"Adjuntas\",\"PR\",\"Adjuntas\"\n\"00602\",18.393103,-67.180953,\"Aguada\",\"PR\",\"Aguada\"";
        }];
    });
    
    it(@"should change the background at least every second", ^{
        UIView *backgroundView = [tester waitForViewWithAccessibilityLabel:@"Main View"];
        UIColor *before = [UIColor colorWithCGColor:backgroundView.backgroundColor.CGColor];
        [tester waitForTimeInterval:1.0];
        expect(before).willNot.equal(backgroundView.backgroundColor);
    });

    it(@"should work with a valid zip code", ^{
        [tester waitForTappableViewWithAccessibilityLabel:@"search Button"];
        [tester enterText:@"00501" intoViewWithAccessibilityLabel:@"Zip Code Input"];
        [tester tapViewWithAccessibilityLabel:@"search Button"];

        UILabel *countyLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"County Label"];
        UILabel *cityLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"City Label"];
        UILabel *stateLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"State Label"];
        UILabel *latitudeLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"Latitude Label"];
        UILabel *longitudeLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"Longitude Label"];

        expect(countyLabel.text).to.equal(@"Suffolk");
        expect(cityLabel.text).to.equal(@"Holtsville");
        expect(stateLabel.text).to.equal(@"NY");
        expect(latitudeLabel.text).to.equal(@"40.922326");
        expect(longitudeLabel.text).to.equal(@"-72.637078");
    });

    it(@"should handle a too small zip code", ^{
        [tester waitForTappableViewWithAccessibilityLabel:@"search Button"];
        [tester enterText:@"0402" intoViewWithAccessibilityLabel:@"Zip Code Input"];
        [tester tapViewWithAccessibilityLabel:@"search Button"];

        // Should open a UIAlertView with title "Zip Code Error" and message "Zip Codes need to be 5 digits"
        [tester waitForViewWithAccessibilityLabel:@"Zip Code Error"];
        [tester waitForViewWithAccessibilityLabel:@"Zip Codes need to be 5 digits"];
        [tester tapViewWithAccessibilityLabel:@"OK"];
    });

    it(@"should handle no zip code", ^{
        [tester waitForTappableViewWithAccessibilityLabel:@"search Button"];
        [tester tapViewWithAccessibilityLabel:@"search Button"];

        // Should open a UIAlertView with title "Zip Code Error" and message "Zip Codes need to be 5 digits"
        [tester waitForViewWithAccessibilityLabel:@"Zip Code Error"];
        [tester waitForViewWithAccessibilityLabel:@"Zip Codes need to be 5 digits"];
        [tester tapViewWithAccessibilityLabel:@"OK"];
    });

    it(@"should handle a too large Zip Code", ^{
        [tester waitForTappableViewWithAccessibilityLabel:@"search Button"];
        [tester enterText:@"040234234234" intoViewWithAccessibilityLabel:@"Zip Code Input"];
        [tester tapViewWithAccessibilityLabel:@"search Button"];

        // Should open a UIAlertView with title "Zip Code Error" and message "Zip Codes need to be 5 digits"
        [tester waitForViewWithAccessibilityLabel:@"Zip Code Error"];
        [tester waitForViewWithAccessibilityLabel:@"Zip Codes need to be 5 digits"];
        [tester tapViewWithAccessibilityLabel:@"OK"];
    });

    it(@"should handle badZipCode Lookup", ^{
        [tester waitForTappableViewWithAccessibilityLabel:@"search Button"];
        [tester enterText:@"00502" intoViewWithAccessibilityLabel:@"Zip Code Input"];
        [tester tapViewWithAccessibilityLabel:@"search Button"];

        // Should open a UIAlertView with title "Zip Code Error" and message "Couldn't find that zip code"
        [tester waitForViewWithAccessibilityLabel:@"Zip Code Error"];
        [tester waitForViewWithAccessibilityLabel:@"Couldn't find that zip code"];
        [tester tapViewWithAccessibilityLabel:@"OK"];
    });


    afterEach(^{
        [tester clearTextFromViewWithAccessibilityLabel:@"Zip Code Input"];
    });
    
    afterAll(^{
        [swizzle resetSwizzledClassMethod];
    });
});

SpecEnd