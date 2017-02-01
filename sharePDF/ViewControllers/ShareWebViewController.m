//
//  ShareWebViewController.m
//  sharePDF
//
//  Created by Mario de Biase on 31/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ShareWebViewController.h"
#import "NSFileManager+FileUrlForDocumentNamed.h"

@interface ShareWebViewController () <WKScriptMessageHandler, WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSMutableArray<PDFDocument *> *pdfList;

@end

@implementation ShareWebViewController

#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.documentTitle.text = self.pdfDocument;
    [self readPDFsFromFileSystem];
    [self setupWebView];
    [self loadHTMLFile];
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //[self loadPDFList];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // Callback from javascript: window.webkit.messageHandlers.SharePDFObserver.postMessage(message)
    NSString *text = (NSString *)message.body;
}

#pragma mark - Events

- (IBAction)loadDocumentsButtonTapped:(id)sender {
    [self loadPDFList];
}

#pragma mark - Private methods

- (void) readPDFsFromFileSystem {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.pdfList = [[fileManager getAllPDFsInFileSystem] mutableCopy];
}

- (void) setupWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    // Add script message handler for function window.webkit.messageHandlers.SharePDFObserver.postMessage()
    [controller addScriptMessageHandler:self name:@"SharePDFObserver"];
    configuration.userContentController = controller;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, CGRectGetHeight([UIScreen mainScreen].bounds) - 84) configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}

- (void) loadHTMLFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"upload_file" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:[NSBundle mainBundle].resourceURL];
}

- (void) loadPDFList {
    NSString *pdfTitleJSON = [self parsePDFList:[self.pdfList valueForKey:@"title"]];
    NSString *script = [NSString stringWithFormat:@"loadComponent(%@)", pdfTitleJSON];
    
    //script = @"loadComponent(['mario', 'mario', 'mario'])";
    
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
