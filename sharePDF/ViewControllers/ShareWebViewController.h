//
//  ShareWebViewController.h
//  sharePDF
//
//  Created by Mario de Biase on 31/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareWebViewController : UIViewController

@property (nonatomic, copy) NSString* pdfDocument;
@property (weak, nonatomic) IBOutlet UILabel *documentTitle;

@end
