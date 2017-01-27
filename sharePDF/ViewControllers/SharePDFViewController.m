//
//  SharePDFViewController.m
//  sharePDF
//
//  Created by Mario de Biase on 27/1/17.
//  Copyright © 2017 debiasej. All rights reserved.
//

#import "SharePDFViewController.h"

static NSString *const appGroupId = @"group.debiasej.sharePDF";
static NSString *const dictKey = @"dictPdf";

@interface SharePDFViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *pdfList;


@end

@implementation SharePDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pdfList =  [NSMutableArray new];
}

-(void)cofigureTableview
{
    [self.view addSubview:self.tableview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:appGroupId];
    NSDictionary *dict = [defaults valueForKey:dictKey];
    
    if (dict) {
        NSData *pdfData = [dict valueForKey:@"pdfData"];
        NSString *fileName = [dict valueForKey:@"name"];
        
        [self.pdfList addObject:fileName];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pdfList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myCell";
    
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text =  [self.pdfList objectAtIndex:indexPath.row];
    return cell;
}

@end
