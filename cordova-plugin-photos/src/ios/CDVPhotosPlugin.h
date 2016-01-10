#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CDVPhotosPlugin : CDVPlugin

- (void)getThumbPhotos:(CDVInvokedUrlCommand*)command;
- (void)getRealPhoto:(CDVInvokedUrlCommand*)command;
- (void)pluginInitialize;

@end