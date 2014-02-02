//
//  MovepopVC.m
//  FileSystem
//
//  Created by Admins on 1/19/13.
//  Copyright (c) 2013 Softweb. All rights reserved.
//

#import "MovepopVC.h"
#import <QuartzCore/QuartzCore.h>
#import "N4File.h"
#import "ViewCell.h"
#import "N4PromptAlertView.h"

@interface MovepopVC ()
@end

@implementation MovepopVC
@synthesize tableView;
@synthesize dataManager,sortDescriptors;
@synthesize delegate;
@synthesize StrMovePath;
- (id)initWithStyle:(UITableViewStyle)style
{
//    self = [super initWithStyle:style];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(500, 100);
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.StrMovePath = [[NSString alloc] init];
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Move"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(MoveButtonClick:)];
    self.navigationItem.rightBarButtonItem = flipButton;
    [flipButton release];
    self.navigationItem.title = @"Home";
    //    self.navigationController.navigationBarHidden = NO;
        self.contentSizeForViewInPopover = CGSizeMake(900, 700);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    currentPath = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
    dataManager = [[DatasourceManager alloc] initWithRootPath:[self applicationDocumentsDirectory] sortDescriptors:sortDescriptors];
    self.StrMovePath = [self applicationDocumentsDirectory];
	dataManager.delegate = self;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark N4FileAccordionDatasourceManagerDelegate methods

- (void) fileAccordionDatasourceManager:(DatasourceManager *) manager didInsertRowsAtIndexPaths:(NSArray *)indexPaths{
	[self.tableView insertRowsAtIndexPaths:indexPaths
						  withRowAnimation: UITableViewRowAnimationLeft];
//	if ([indexPaths count] == 1) { //ok here?
//		[self.tableView selectRowAtIndexPath:[indexPaths objectAtIndex:0]
//									animated:YES scrollPosition:UITableViewScrollPositionNone];
//	}
}
- (void) fileAccordionDatasourceManager:(DatasourceManager *) manager didRemoveRowsAtIndexPaths:(NSArray *)indexPaths{
	[self.tableView deleteRowsAtIndexPaths:indexPaths
						  withRowAnimation:UITableViewRowAnimationLeft];
}

- (void) fileAccordionDatasourceManager:(DatasourceManager *) manager didCreateSuccessfullyFile:(N4File *) file{
	
}
- (void) fileAccordionDatasourceManager:(DatasourceManager *) manager didFailOnCreationofFile:(N4File *)file error:(NSError *)error{
	
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    
	return [dataManager.mergedRootBranch count];
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyCellIdentifier";
	ViewCell *cell = (ViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[ViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.indentationWidth = 30.0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	N4File *file = [dataManager.mergedRootBranch objectAtIndex:indexPath.row];
	cell.cellType = (file.isDirectory)? CellTypeDirectory : CellTypeFile;
	cell.directoryAccessoryImageView.image = (file.isDirectory)? [UIImage imageNamed:@"TriangleSmall.png"] : nil;
	cell.imageView.image = [file image];
	cell.textLabel.text = [file name];
	cell.detailTextLabel.text = [file name];
	return cell;
}

/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 N4File * file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
 if (!file.isDirectory || file.isEmptyDirectory) return YES;
 else return NO;
 }
 */

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.StrMovePath = @"";
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[dataManager deleteFileAtIndex:indexPath.row];
        [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
		
		[dataManager createFileAtIndex:indexPath.row withName:[NSString stringWithFormat:@"%@", [NSDate date]]];
		[aTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
    }   
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	N4File *file = [dataManager.mergedRootBranch objectAtIndex:indexPath.row];
//    NSLog(@"%@", file.parentDirectory);

	if (file.isDirectory) {
		if (file.isExpanded){
			ViewCell *curCell = (ViewCell *)[aTableView cellForRowAtIndexPath:indexPath];
            self.StrMovePath  = [NSString stringWithFormat:@"%@/%@",file.parentDirectory,curCell.textLabel.text];
            self.navigationItem.title = curCell.textLabel.text;
//            NSLog(@"%@",self.StrMovePath);
			curCell.expanded = NO;
			[dataManager collapseBranchAtIndex:indexPath.row];
			file.expanded = NO;
		}
		else{
			ViewCell *curCell = (ViewCell *)[aTableView cellForRowAtIndexPath:indexPath];
            self.StrMovePath  = [NSString stringWithFormat:@"%@/%@",file.parentDirectory,curCell.textLabel.text];
//            NSLog(@"%@",self.StrMovePath);
            self.navigationItem.title = curCell.textLabel.text;
			curCell.expanded = YES;
			[dataManager expandBranchAtIndex:indexPath.row];
			file.expanded = YES;
		}
		
		//[self.tableView reloadData]; //do not update datasource or tableview here
		//rows will be inserted/deleted using datasourceManager delegate methods
		
	}
	else{
        self.StrMovePath = @"";
//		detailViewController.detailItem = [NSString stringWithFormat:@"%@", file.name];
//		detailViewController.backgroundImageVIew.image = [file imageBig];
//		[detailViewController addFile:file];
		
		
	}
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
	N4File *file = [dataManager.mergedRootBranch objectAtIndex:indexPath.row];
	return file.level;
}

- (void) fileSorterViewController:(SorterViewController *)filerSorterViewController
			  didUpdateDataSource:(NSMutableArray*)datasource{
	[dataManager sort];
	[self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
	
}

- (IBAction) showSortingMenu:(id)sender
{
    
}
- (IBAction)MoveButtonClick:(id)sender {
    NSLog(@"%@",self.StrMovePath);
    if (![self.StrMovePath isEqualToString:@""])
    {
        [delegate moveFilesToNewFolder:self.StrMovePath];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Please Select Folder" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];

    }
}
@end
