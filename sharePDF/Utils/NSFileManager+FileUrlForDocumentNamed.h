//
//  NSFileManager+AppGroupContainerURL.h
//  sharePDF
//
//  Created by Mario de Biase on 27/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDFDocument.h"

@interface NSFileManager (FileUrlForDocumentNamed)

- (NSURL *)fileUrlForDocumentNamed:(NSString *) fileName;
- (NSArray<PDFDocument *> *) getAllPDFsInFileSystem;

@end
