
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <substrate.h>
#include <mach-o/dyld.h>
#import <dlfcn.h>

%hook SCPreLoginAttestationImpl
-(id)generateAttestationPayloadForLoginOrRegistration:(id) username timestamp:(id) timestamp requestPath:(id) requestPath requestType:(int)requestType {


    __block UITextField *namefield2;
    __block NSString *NewCode;
    NSData* payload = %orig;
    NSString *base64String = [payload base64EncodedStringWithOptions:0];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

        while (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"انسخ التوكن" message:nil preferredStyle:UIAlertControllerStyleAlert];

        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = base64String;
        }];

        UIAlertAction *send = [UIAlertAction actionWithTitle:@"انسخ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:base64String];
            // Handle the data or perform any necessary action here
        }];

        [alert addAction:send];


        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"إلـغـاء" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // Dismiss the alert when Cancel is tapped
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];

        [alert addAction:cancel];

        [topViewController presentViewController:alert animated:YES completion:nil];

    });


    [NSThread sleepForTimeInterval:10];

    return payload;
}
%end
