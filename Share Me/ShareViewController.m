//
//  ShareViewController.m
//  Share Me
//
//  Created by Mario de Biase on 26/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import "ShareViewController.h"
#import "NSFileManager+FileUrlForDocumentNamed.h"
#import "PdfDocument.h"

//static NSString *const appGroupId = @"group.debiasej.sharePDF";
static NSString *const appGroupId = @"group.avantgarde.Share-PDF";
static NSString *const pfdFileExtension = @"com.adobe.pdf";
static NSString *const dictKey = @"dictPdf";

@interface ShareViewController () {
    NSExtensionItem *extensionItem;
    NSUserDefaults *sharedUserDefaults;
    NSFileManager *fileManager;
    PDFDocument *pdfDocument;
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
                NSLog(@"Path origen: %@", item);
            }
            
            NSString *fileName = [(NSURL *)item lastPathComponent];
            //[self savePdfUsingSharedUserDefaults:pdfData withName:fileName];
            [self savePdfUsingFileSystem:pdfData withName:fileName];
            
            // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
            [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
        }];
    }
}

- (IBAction)shareButtonTapped:(id)sender {
    [self didSelectPost];
}

-(void) savePdfUsingFileSystem:(NSData *) pdfData withName:(NSString *) fileName {
    
    fileManager = [NSFileManager defaultManager];
    NSURL *pdfURL = [fileManager fileUrlForDocumentNamed:fileName];
        
    pdfDocument = [[PDFDocument alloc] initWithFileURL:pdfURL];
    [pdfDocument saveDocumentData:pdfData];
    
}

-(void) savePdfUsingSharedUserDefaults:(NSData *) pdfData withName:(NSString *) fileName {
    
    NSDictionary *dict = @{
                           @"pdfData" : pdfData,
                           @"name" : fileName
                           };
    
    sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:appGroupId];
    [sharedUserDefaults setObject:dict forKey:dictKey];
    [sharedUserDefaults synchronize];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
