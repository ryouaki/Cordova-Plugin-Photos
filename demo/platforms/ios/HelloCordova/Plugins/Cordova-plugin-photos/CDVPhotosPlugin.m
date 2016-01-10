#import "CDVPhotosPlugin.h"
#import <Cordova/CDVViewController.h>

@import Photos;
@import UIKit;

static BOOL imageHasAlpha(UIImage * image)
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
static NSString * image2DataURL(UIImage * image)
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if (imageHasAlpha(image)) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    if(imageData==nil){
        return nil;
    }else{
        return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
                [imageData base64EncodedStringWithOptions: 0]];
    }
}

@implementation CDVPhotosPlugin

static PHFetchOptions *allPhotosOptions = nil ;
static NSMutableArray *allPhotosURLs = nil ;

- (void)pluginInitialize
{
    // Create a PHFetchResult object for each section in the table view.
    allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    allPhotosURLs = [[NSMutableArray alloc] init];
}

- (void)getThumbPhotos:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^ {
        NSString* index = [command argumentAtIndex:0];
        NSString* num = [command argumentAtIndex:1];
        int mIndex = [index intValue];
        int maxNum = [num intValue];
        
        PHImageManager* imageManager = [PHImageManager defaultManager];
        PHImageRequestOptions* imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.version = PHImageRequestOptionsVersionCurrent;
        imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        imageRequestOptions.synchronous = true;
        
        CDVPluginResult* result;
        NSArray* retArray = nil;
        
        if(allPhotosURLs.count>0) {
            if(mIndex*maxNum+maxNum>allPhotosURLs.count) {
                int max =maxNum - (mIndex*maxNum+maxNum - allPhotosURLs.count);
                if(max>0){
                    retArray = [allPhotosURLs subarrayWithRange:NSMakeRange(mIndex*maxNum,max)];
                }
            } else {
                retArray = [allPhotosURLs subarrayWithRange:NSMakeRange(mIndex*maxNum,maxNum)];
            }
        } else {
            PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
            for (PHAsset* asset in allPhotos) {
                NSString* url = asset.localIdentifier;
                [allPhotosURLs addObject:url];
            }
            int max = 0;
            if(mIndex*maxNum+maxNum>allPhotosURLs.count) {
                max =maxNum - (mIndex*maxNum+maxNum - allPhotosURLs.count);
                maxNum = max;
            }
            retArray = [allPhotosURLs subarrayWithRange:NSMakeRange(0,maxNum)];
        }
        
        PHFetchResult *dstPhoto = [PHAsset fetchAssetsWithLocalIdentifiers:retArray options:nil];
        if (dstPhoto == nil) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"[]"];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        } else {
            NSString* jsonData = @"[";
            for (PHAsset* asset in dstPhoto) {
                __block NSString* data = nil;
                NSString* url = asset.localIdentifier;
                [imageManager requestImageForAsset:asset
                                        targetSize:CGSizeMake(30, 30)
                                       contentMode:PHImageContentModeAspectFill
                                           options:imageRequestOptions
                                     resultHandler:^(UIImage *result, NSDictionary *info) {
                                         data = image2DataURL(result);
                                     }];
                if(data==nil) {
                    continue;
                }
                NSString* str = [[NSString alloc] initWithFormat:@"{\"url\":\"%@\",\"data\":\"%@\"},",url,data];
                jsonData = [jsonData stringByAppendingString:str];
                data = nil;
            }
            jsonData = [jsonData substringWithRange:NSMakeRange(0, [jsonData length] - 1)];
            jsonData = [jsonData stringByAppendingString:@"]"];
            
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:jsonData];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            
            dstPhoto = nil;
            imageManager = nil;
            imageRequestOptions = nil;
            jsonData = nil;
            result = nil;
        }
    }];
}

- (void)getRealPhoto:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^ {
        NSString* param = [command argumentAtIndex:0];
        PHFetchResult *dstPhoto = [PHAsset fetchAssetsWithLocalIdentifiers:@[param] options:nil];
        if(dstPhoto == nil || dstPhoto.count <= 0) {
            CDVPluginResult* result;
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"This URL is invalid!"];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            return;
        } else {
            
            PHImageManager* imageManager = [PHImageManager defaultManager];
            
            PHImageRequestOptions* imageRequestOptions = [[PHImageRequestOptions alloc] init];
            imageRequestOptions.version = PHImageRequestOptionsVersionCurrent;
            imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
            imageRequestOptions.synchronous = true;
            
            [imageManager requestImageDataForAsset:[dstPhoto objectAtIndex:0]
                                           options:imageRequestOptions
                                     resultHandler:^(NSData *__nullable imageData, NSString *__nullable dataUTI, UIImageOrientation orientation, NSDictionary *__nullable info) {
                                         CDVPluginResult* result;
                                         UIImage *image = [[UIImage alloc]initWithData:imageData];
                                         NSString* data = image2DataURL(image);
                                         NSString* res = @"{\"data\":\"";
                                         res = [res stringByAppendingFormat:@"%@\"}",data];
                                         result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:res];
                                         [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                                         result = nil;
                                         image = nil;
                                         data = nil;
                                         res = nil;
                                         
                                     }];
        }
    }];
}
@end