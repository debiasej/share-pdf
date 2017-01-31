//
//  SharePDFViewController.m
//  sharePDF
//
//  Created by Mario de Biase on 27/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import "SharePDFViewController.h"
#import "NSFileManager+FileUrlForDocumentNamed.h"

static NSString *const appGroupId = @"group.debiasej.sharePDF";
static NSString *const dictKey = @"dictPdf";

@interface SharePDFViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *pdfList;
@property (strong, nonatomic) UITableViewController *tableViewController;

@end

@implementation SharePDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPullAndRefreshControl];
    self.pdfList =  [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //[self readPDFsFromUserDefaults];
    [self readPDFsFromFileSystem];
}

- (void) addPullAndRefreshControl {
    
    UIRefreshControl *refreshControl = [self createRefreshControl];
    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.tableview;
    self.tableViewController.refreshControl = refreshControl;
}

- (UIRefreshControl *) createRefreshControl {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    return refreshControl;
}

-(void)refreshData {
    
    [self readPDFsFromFileSystem];
    [self.tableview reloadData];
    [self.tableViewController.refreshControl endRefreshing];
}

- (void) readPDFsFromFileSystem {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.pdfList = [[fileManager getAllPDFsInFileSystem] mutableCopy];
}

- (void)readPDFsFromUserDefaults {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:appGroupId];
    NSDictionary *dict = [defaults valueForKey:dictKey];
    
    if (dict) {
        //NSData *pdfData = [dict valueForKey:@"pdfData"];
        NSString *fileName = [dict valueForKey:@"name"];
        [self.pdfList addObject:fileName];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pdfList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myCell";
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text =  [self documentTitleAt:indexPath.row];
    return cell;
}

- (NSString *) documentTitleAt:(NSUInteger) index {
    PDFDocument *pdf = (PDFDocument *)[self.pdfList objectAtIndex:index];
    return pdf.title;
}

@end
