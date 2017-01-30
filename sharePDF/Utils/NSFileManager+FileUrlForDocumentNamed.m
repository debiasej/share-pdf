//
//  NSFileManager+AppGroupContainerURL.m
//  sharePDF
//
//  Created by Mario de Biase on 27/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import "NSFileManager+FileUrlForDocumentNamed.h"

static NSString *const appGroupId = @"group.debiasej.sharePDF";

@implementation NSFileManager (FileUrlForDocumentNamed)


- (NSURL *)fileUrlForDocumentNamed:(NSString *) fileName {
    
    NSURL *fileURL = nil;
    NSURL *baseURL = [self appGroupContainerURL];
    
    if (baseURL && fileName && [fileName length] > 0) {
        fileURL = [baseURL URLByAppendingPathComponent:fileName];
    }
    
    return fileURL;
}

- (NSArray<PDFDocument *> *) getAllPDFsInFileSystem {
    NSArray<PDFDocument *> *pdfDocuments = nil;
    NSURL *baseURL = [self appGroupContainerURL];

    if (baseURL) {
        NSError *error;
        NSArray<NSURL *> *documentURLs = [self contentsOfDirectoryAtURL:baseURL
             includingPropertiesForKeys:@[NSURLIsDirectoryKey]
                                options:NSDirectoryEnumerationSkipsHiddenFiles
                                  error:&error];
        
        if (documentURLs && documentURLs.count > 0)
            pdfDocuments = [self arrayOfPDFDocumentsFromArrayOfFileNames: documentURLs];
    }
    return pdfDocuments;
}

-(NSURL *) appGroupContainerURL {
    
    NSURL *storagePathUrl = nil;
    NSURL* containerURL = [self containerURLForSecurityApplicationGroupIdentifier:appGroupId];
    NSLog(@"appGroupContainerURL: %@", containerURL);
    
    if (containerURL) {
        storagePathUrl = [self createDirIfNotExists:containerURL];
    }
    
    return containerURL;
}

- (NSURL *) createDirIfNotExists:(NSURL *) containerURL {
    
    NSURL *storagePathUrl = [containerURL URLByAppendingPathComponent:@"ShareExtensionStorage"];
    NSString *storagePath = storagePathUrl.path;
    BOOL isDir;
    
    if ( ![self fileExistsAtPath:storagePath isDirectory:&isDir] && isDir ) {
        if ( ![self createDirectoryAtPath:storagePath withIntermediateDirectories:NO attributes:nil error:nil] ) {
            
            NSLog(@"ERROR creating filepath");
            return nil;
        }
    }
    
    return storagePathUrl;
}

- (NSArray<PDFDocument *> *)arrayOfPDFDocumentsFromArrayOfFileNames:(NSArray<NSURL *> *) documentURLs {
    NSMutableArray<PDFDocument *> *pdfDocuments = [NSMutableArray new];
    
    for (NSURL* url in documentURLs) {
        
        BOOL isDir;
        if ( [self fileExistsAtPath:url.path isDirectory:&isDir] && !isDir ) {
            PDFDocument *pdf = [[PDFDocument alloc] initWithFileURL:url];
            [pdfDocuments addObject:pdf];
            //TODO: Get NSData from a NSURL and save to content
        }
    }
    return pdfDocuments;
}

@end
