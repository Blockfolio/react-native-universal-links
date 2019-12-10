
#import "UniversalLinks.h"

#import <React/RCTUtils.h>

@implementation UniversalLinks

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


RCT_EXPORT_METHOD(openURL:(NSURL *)URL
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    if (![RCTSharedApplication() respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        // OS does not support new selector
        reject(RCTErrorUnspecified, [NSString stringWithFormat:@"options for openURL not available"], nil);
    }

    NSError *error = NULL;
    NSRegularExpression *regex =
        [NSRegularExpression regularExpressionWithPattern:@"^(?!(http|https)).*:////.*|.*itunes/.apple/.com.*"
                                              options:0
                                                error:&error];

    NSUInteger numberOfMatches = [regex numberOfMatchesInString:[URL absoluteString]
                                                        options:0
                                                          range:NSMakeRange(0, [[URL absoluteString] length])];

    if (numberOfMatches > 0) {
        // URL is not http/https, so attempt to open 3rd party app
        [RCTSharedApplication() openURL:URL options:@{} completionHandler:^(BOOL opened) {
            if (opened) {
                resolve(nil);
            } else {
                reject(RCTErrorUnspecified, [NSString stringWithFormat:@"Unable to open deeplink URL: %@", URL], nil);
            }
        }];
    } else {
        // URL is http/https attempt to resolve universal link
        [RCTSharedApplication() openURL:URL
                                options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@1}
                                completionHandler:^(BOOL opened) {
            if (opened) {
                resolve(nil);
            } else {
                reject(RCTErrorUnspecified, [NSString stringWithFormat:@"Unable to open universal URL: %@", URL], nil);
            }
        }];
    }

}

@end
  