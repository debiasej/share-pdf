//
//  PDFDocument.h
//  sharePDF
//
//  Created by Mario de Biase on 27/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFDocument : UIDocument

@property (strong) NSData *contents;

- (id)initWithFileURL:(NSURL *)url;
- (void)saveDocumentData:(NSData *)newData;

@end
