//
//  ShareWebViewController.m
//  sharePDF
//
//  Created by Mario de Biase on 31/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "SharePDFWebViewController.h"
#import "NSFileManager+FileUrlForDocumentNamed.h"

static NSString *const directory = @"www";
static NSString *const webAppName = @"index";
static NSDataBase64EncodingOptions const NSDataBase64EncodingOneLineLength = 0;

@interface SharePDFWebViewController () <WKScriptMessageHandler, WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSMutableArray<PDFDocument *> *pdfList;
@property (strong, nonatomic) PDFDocument *selectedPDF;
@property (nonatomic, copy) NSString *currentPDFDataWithBase64Encoding;

@end

@implementation SharePDFWebViewController

#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];

    [self readPDFsFromFileSystem];
    [self setupWebView];
    [self loadHTMLFile];
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self loadPDFList];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // // Messages from javascript handlers
    if ([message.name isEqualToString:@"SelectedFileObserver"]) {
        [self retrieveCurrentPDFData:(NSString *)message.body];
    
    } else if ( [message.name isEqualToString:@"SendDataObserver"] ) {
        NSString *script = [NSString stringWithFormat:@"$(document).trigger('uploadFile', ['%@', '%@']);",
                            self.selectedPDF.title ,self.currentPDFDataWithBase64Encoding];
        [self evaluateJavascript:script];
    }
}

#pragma mark - Private methods

- (void) readPDFsFromFileSystem {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.pdfList = [[fileManager getAllPDFsInFileSystem] mutableCopy];
}

- (void) setupWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    // Add handlers. For example, window.webkit.messageHandlers.SharePDFListObserver.postMessage()
    [controller addScriptMessageHandler:self name:@"SelectedFileObserver"];
    [controller addScriptMessageHandler:self name:@"SendDataObserver"];
    configuration.userContentController = controller;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, CGRectGetHeight([UIScreen mainScreen].bounds) - 84) configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}

- (void) loadHTMLFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:webAppName ofType:@"html" inDirectory:directory];
    NSString *html = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    [self.webView loadHTMLString:html baseURL:[self getBaseURL:filePath]];
}
    
- (NSURL*) getBaseURL:(NSString *) path {
    NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
    path = [path substringToIndex:range.location];
    
    path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    path = [NSString stringWithFormat:@"file://%@/",path];
    
    return  [NSURL URLWithString:path];
}

- (void) retrieveCurrentPDFData:(NSString *) fileName {
    
    self.selectedPDF = [self filterPDFListWithFileName:fileName];
    [self openPDFDocument:self.selectedPDF withResult:^(NSData* pdfData) {
        [self savePDFWithBase64Encoding:pdfData];
    }];
}

- (PDFDocument *) filterPDFListWithFileName:(NSString*) fileName {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", fileName];
    NSArray<PDFDocument *> *filteredArray = [self.pdfList filteredArrayUsingPredicate:predicate];
    
    return [filteredArray firstObject];
}

- (void) openPDFDocument:(PDFDocument *) pdfDocument withResult:(void (^)(NSData *pdfData))result {
    
    [pdfDocument openWithCompletionHandler:^(BOOL success) {
        if (!success) {
            NSLog(@"Failed to open %@", pdfDocument.title);
            result(nil);
        }
        [pdfDocument closeWithCompletionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"Failed to close %@", pdfDocument.title);
                result(nil);
            }
            result(pdfDocument.contents);
        }];
    }];
}

- (void) savePDFWithBase64Encoding:(NSData *) pdfData {
    
    if (pdfData) {
        NSString *base64String = [pdfData base64EncodedStringWithOptions:NSDataBase64EncodingOneLineLength];
        base64String = [@"data:application/pdf;base64," stringByAppendingString:base64String];
        
        self.currentPDFDataWithBase64Encoding = base64String;
    }
}

- (void) loadPDFList {
    NSString *pdfTitleJSON = [self parsePDFList:[self.pdfList valueForKey:@"title"]];
    NSString *script = [NSString stringWithFormat:@"loadPDFList(%@)", pdfTitleJSON];
    [self evaluateJavascript:script];
}

#pragma mark - Methods to connect with javascript

- (void) evaluateJavascript:(NSString *) script {
    
    [self.webView evaluateJavaScript:script completionHandler:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"Error:%@", [error localizedDescription]);
        } else {
            NSLog(@"Result:%@", result);
        }
    }];
}

- (NSString *) parsePDFList:(NSArray<NSString *> *) pdfTitleList {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pdfTitleList options:NSJSONWritingPrettyPrinted error:&error];
    NSString *pdfTitleJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return pdfTitleJSON;
}

@end
