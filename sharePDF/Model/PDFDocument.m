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
    }
    return self;
}

- (NSString *)localizedName {
    return [self.fileURL lastPathComponent];
}

- (BOOL)loadFromContents:(id)fileContents ofType:(NSString *)typeName error:(NSError **)outError {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        if ([fileContents length] > 0) {
            self.contents = [[NSData alloc] initWithData:fileContents];
        } else {
            self.contents = [[NSData alloc] init];
        }
    });
    
    return YES;
}


- (void)saveDocumentData:(NSData *)newData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        NSData *oldData = self.contents;
        self.contents = [newData copy];
        
        // Register the undo operation
        [self.undoManager setActionName:@"Data Change"];
        [self.undoManager registerUndoWithTarget:self selector:@selector(saveDocumentData:) object:oldData];
    });
}

@end
