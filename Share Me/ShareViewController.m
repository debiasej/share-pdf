//
//  ShareViewController.m
//  Share Me
//
//  Created by Mario de Biase on 26/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import "ShareViewController.h"

static NSString *const appGroupId = @"group.debiasej.sharePDF";
static NSString *const pfdFileExtension = @"com.adobe.pdf";
static NSString *const dictKey = @"dictPdf";

@interface ShareViewController () {
    NSExtensionItem *extensionItem;
    NSUserDefaults *sharedUserDefaults;
}

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    extensionItem = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = extensionItem.attachments.firstObject;
    
    if([itemProvider hasItemConformingToTypeIdentifier:pfdFileExtension]) {
        NSLog(@"itemprovider = %@", itemProvider);
    
        [itemProvider loadItemForTypeIdentifier:pfdFileExtension options:nil completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
        
            NSData *pdfData;
            
            if([(NSObject*)item isKindOfClass:[NSURL class]]) {
                pdfData = [NSData dataWithContentsOfURL:(NSURL*)item];
            }

            NSDictionary *dict = @{
                                   @"pdfData" : pdfData,
                                   @"name" : [(NSURL *)item lastPathComponent]
                                   };
            
            sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:appGroupId];
            [sharedUserDefaults setObject:dict forKey:dictKey];
            [sharedUserDefaults synchronize];
        }];
    }
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
