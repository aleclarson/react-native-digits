
#import <DigitsKit/DigitsKit.h>

#import "RCTUtils.h"
#import "RCTConvert.h"
#import "RNDigits.h"

@implementation RNDigits

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(login:(NSDictionary*)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
  Digits *digits = [Digits sharedInstance];
  DGTAuthenticationConfiguration *config = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];

  config.appearance = [[DGTAppearance alloc] init];
  config.appearance.accentColor = [RCTConvert UIColor:options[@"accentColor"]];
  config.appearance.backgroundColor = [RCTConvert UIColor:options[@"backgroundColor"]];

  [digits
    authenticateWithViewController:nil
    configuration:config
    completion:^(DGTSession *session, NSError *error) {
      if (error) {
        reject(RCTErrorUnspecified, nil, RCTErrorWithMessage(error.localizedDescription));
        return;
      }

      resolve(@{
        @"userId": session.userID,
        @"phoneNumber": session.phoneNumber,
        @"authToken": session.authToken,
        @"authTokenSecret": session.authTokenSecret,
        @"consumerKey": digits.authConfig.consumerKey,
        @"consumerSecret": digits.authConfig.consumerSecret,
      });
    }];
}

RCT_EXPORT_METHOD(logout)
{
  [[Digits sharedInstance] logOut];
}

@end
