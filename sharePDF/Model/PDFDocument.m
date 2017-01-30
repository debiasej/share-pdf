//
//  PDFDocument.m
//  sharePDF
//
//  Created by Mario de Biase on 27/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import "PDFDocument.h"


@implementation PDFDocument

- (id)initWithFileURL:(NSURL *)url {
    self = [super initWithFileURL:url];
    if (self) {
        self.contents = [[NSData alloc] init];
        self.title = [url lastPathComponent];
    }
    return self;
}

- (BOOL)loadFromContents:(id)fileContents ofType:(NSString *)typeName error:(NSError **)outError {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([fileContents length] > 0) {
            self.contents = [[NSData alloc] initWithData:fileContents];
        } else {
            self.contents = [[NSData alloc] init];
        }
    });
    
    return YES;
}

- (void)saveDocumentData:(NSData *)data {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.contents = [data copy];
        BOOL success = [self.contents writeToURL:self.fileURL atomically:YES];
        
        if (!success)
            NSLog(@"ERROR writting the file!");
    });
}

@end
