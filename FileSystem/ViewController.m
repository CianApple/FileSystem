//
//  ViewController.m
//  FileSystem
//
//  Created by Jai Dhorajia on 04/06/13.
//  Copyright (c) 2013 Softweb. All rights reserved.
//

#import "ViewController.h"

////////////////////////////////////////////////////
//      Define Constants
////////////////////////////////////////////////////
#pragma mark - Define Constants

#define FILE_MANAGER [NSFileManager defaultManager]
#define BASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] // Change base path here

// File Attribute Keys
#define NSNAME @"NSName"
#define NSPARENTPATH @"NSParentPath"
#define NSPARENTNAME @"NSParentName"
#define NSGRANDPARENTNAME @"NSGrandParentName"
#define NSMIMETYPE @"NSMimeType"
#define NSCHILDCOUNT @"NSChildCount"

#define NSFILETYPE @"NSFileType"
#define NSFILETYPEDIRECTORY @"NSFileTypeDirectory"
#define NSFILETYPEREGULAR @"NSFileTypeRegular"
#define NSFILETYPESYMBOLICLINK @"NSFileTypeSymbolicLink"
#define NSFILETYPESOCKET @"NSFileTypeSocket"
#define NSFILETYPECHARACTERSPECIAL @"NSFileTypeCharacterSpecial"
#define NSFILETYPEBLOCKSPECIAL @"NSFileTypeBlockSpecial"
#define NSFILETYPEUNKNOWN @"NSFileTypeUnknown"
#define NSFILESIZE @"NSFileSize"
#define NSSIZE @"NSSize"
#define NSFILEMODIFICATIONDATE @"NSFileModificationDate"
#define NSFILEREFERENCECOUNT @"NSFileReferenceCount"
#define NSFILEDEVICEIDENTIFIER @"NSFileDeviceIdentifier"
#define NSFILEOWNERACCOUNTNAME @"NSFileOwnerAccountName"
#define NSFILEGROUPOWNERACCOUNTNAME @"NSFileGroupOwnerAccountName"
#define NSFILEPOSIXPERMISSIONS @"NSFilePosixPermissions"
#define NSFILESYSTEMNUMBER @"NSFileSystemNumber"
#define NSFILESYSTEMFILENUMBER @"NSFileSystemFileNumber"
#define NSFILEEXTENSIONHIDDEN @"NSFileExtensionHidden"
#define NSFILEHFSCREATORCODE @"NSFileHFSCreatorCode"
#define NSFILEHFSTYPECODE @"NSFileHFSTypeCode"
#define NSFILEIMMUTABLE @"NSFileImmutable"
#define NSFILEAPPENDONLY @"NSFileAppendOnly"
#define NSFILECREATIONDATE @"NSFileCreationDate"
#define NSFILEOWNERACCOUNTID @"NSFileOwnerAccountID"
#define NSFILEGROUPOWNERACCOUNTID @"NSFileGroupOwnerAccountID"

#define SELECTIONBOOL @"Bool"
#define RENAMETAG 9999
////////////////////////////////////////////////////
//      Interface 
////////////////////////////////////////////////////
#pragma mark - Interface
@interface ViewController ()

@end

@implementation ViewController
////////////////////////////////////////////////////
//      Synthesizers
////////////////////////////////////////////////////
#pragma mark - Synthesizers
@synthesize currentPath;
@synthesize ary_filelist;
@synthesize ary_selectedfilelist;
@synthesize documentInteractionController;
////////////////////////////////////////////////////
//      View Delegates
////////////////////////////////////////////////////
#pragma mark - View Delegates
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add some files to the app's document directory folder so that you can test the app.
    
    // To copy files from main bundle to documents directory
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *documentDBFolderPath = documentsDirectory;
//    NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Documents"];
//    
//    if (![fileManager fileExistsAtPath:documentDBFolderPath]) {
//        //Create Directory!
//        [fileManager createDirectoryAtPath:documentDBFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
//    } else {
//        NSLog(@"Directory exists! %@", documentDBFolderPath);
//    }
//    
//    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceDBFolderPath error:&error];
//    for (NSString *s in fileList) {
//        NSString *newFilePath = [documentDBFolderPath stringByAppendingPathComponent:s];
//        NSString *oldFilePath = [resourceDBFolderPath stringByAppendingPathComponent:s];
//        if (![fileManager fileExistsAtPath:newFilePath]) {
//            //File does not exist, copy it
//            [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
//        } else {
//            NSLog(@"File exists: %@", newFilePath);
//        }
//    }
    
    // Initially when the view load, make respective view and buttons hide or unhide
    _vw_unedit.hidden = NO;
    _vw_edit.hidden = YES;
    
    _scrl_grid.hidden = NO;
    _tbl_files.hidden = YES;
    
    _lbl_back.text = @"";
    _lbl_heading.text = [BASE_PATH lastPathComponent];
    _btn_back.hidden = YES;
    
    isTableOrGridEditing = NO;
    isGrid = YES;
    [self buttonsHideorUnhide];    // Hide editing view buttons accordingly
    
    _scrl_grid.delegate = self;  // Set scrlview delegate
    _tbl_files.layer.cornerRadius = 10.0f;
    
    // Set current path with BASE_PATH
    self.currentPath = @"";
    currentGridPage = 0;
    timerCounter = 0;
    
    // Alloc global array and get list from base folder
    self.ary_selectedfilelist = [[NSMutableArray alloc] init];
    [self cleanFileListArray];
    self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
    //NSLog(@"%@",self.ary_filelist);
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_vw_unedit release];
    [_vw_edit release];
    [_seg_sort release];
    [_seg_mode release];
    [_btn_delete release];
    [_btn_selection release];
    [_btn_zip release];
    [_btn_move release];
    [_btn_mail release];
    [_btn_newfolder release];
    [_btn_back release];
    [_btn_mode release];
    [_lbl_back release];
    [_lbl_heading release];
    [_scrl_grid release];
    [_tbl_files release];
    
    [self.currentPath release];
    [self.ary_filelist release];
    [self.ary_selectedfilelist release];
    
    [_lbl_selectioncount release];
    [_btn_refresh release];
    [super dealloc];
}
////////////////////////////////////////////////////
//      Button Click Methods
////////////////////////////////////////////////////
#pragma mark - Button Click Methods
- (IBAction)btn_mode_pressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    // btn_mode ---> Edit is pressed and done is enabled
    if (button.selected)
    {
        _vw_unedit.hidden = YES;
        _vw_edit.hidden = NO;
        _btn_back.hidden = YES;
        _lbl_back.hidden = YES;
        isTableOrGridEditing = YES;
        if (isGrid)
        {
            [self clearGrid];
            [self createGrid:self.ary_filelist];
        }
        else
            [_tbl_files reloadData];
    }
    // btn_mode ---> Done is pressed and edit is enabled
    else
    {
        for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
            [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
        [self.ary_selectedfilelist removeAllObjects];
        _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
        isTableOrGridEditing = NO;
        if (isGrid)
        {
            [self clearGrid];
            [self createGrid:self.ary_filelist];
        }
        else
            [_tbl_files reloadData];
        _vw_unedit.hidden = NO;
        _vw_edit.hidden = YES;
        if (![self.currentPath isEqualToString:@""]) {
            _btn_back.hidden = NO;
            _lbl_back.hidden = NO;
        }
        [self buttonsHideorUnhide];
        _btn_selection.selected = NO;
    }
}
- (IBAction)btn_back_pressed:(id)sender
{
    self.currentPath = [self.currentPath stringByDeletingLastPathComponent];
    
    [self cleanFileListArray];
    self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
    
    if ([self.currentPath isEqualToString:@""])
    {
        _btn_back.hidden = YES;
        _lbl_back.hidden = YES;
        _lbl_back.text = @"";
        _lbl_heading.text = [BASE_PATH lastPathComponent];
    }
    else
    {
        _btn_back.hidden = NO;
        _lbl_back.hidden = NO;
        _lbl_back.text = [[self.ary_filelist objectAtIndex:0] objectForKey:NSGRANDPARENTNAME];
        _lbl_heading.text = [self.currentPath lastPathComponent];
    }
    
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
        [self pushAnimation:_scrl_grid animationSide:@"Left"];
    }
    else
    {
        [_tbl_files reloadData];
        [self pushAnimation:_tbl_files animationSide:@"Left"];
    }
}
// Duplicate of btn_back_pressed:. Only used to do the same thing when the previous folder name is pressed to move back
- (IBAction)btn_extraback_pressed:(id)sender
{
    self.currentPath = [self.currentPath stringByDeletingLastPathComponent];
    
    [self cleanFileListArray];
    self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
    
    if ([self.currentPath isEqualToString:@""])
    {
        _btn_back.hidden = YES;
        _lbl_back.hidden = YES;
        _lbl_back.text = @"";
        _lbl_heading.text = [BASE_PATH lastPathComponent];
    }
    else
    {
        _btn_back.hidden = NO;
        _lbl_back.hidden = NO;
        _lbl_back.text = [[self.ary_filelist objectAtIndex:0] objectForKey:NSGRANDPARENTNAME];
        _lbl_heading.text = [self.currentPath lastPathComponent];
    }
    
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
        [self pushAnimation:_scrl_grid animationSide:@"Left"];
    }
    else
    {
        [_tbl_files reloadData];
        [self pushAnimation:_tbl_files animationSide:@"Left"];
    }
}
- (IBAction)btn_selection_pressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    // btn_select ---> Select all is pressed and deselect all is enabled
    if (button.selected)
    {
        for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
        {
            [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:YES] forKey:SELECTIONBOOL];
            [self.ary_selectedfilelist addObject:[self.ary_filelist objectAtIndex:cnt]];
            _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
        }
        [self buttonsHideorUnhide];
    }
    // btn_select ---> Deselect all is pressed and select all is enabled
    else
    {
        for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
        {
            [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
        }
        [self.ary_selectedfilelist removeAllObjects];
        _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
        [self buttonsHideorUnhide];
    }
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];
}
- (IBAction)btn_move_pressed:(id)sender
{
    if (movepopvc) {
        [movepopvc release];
        //movepopvc = nil;
    }
    if (popcontroller) {
        [popcontroller release];
        //popcontroller = nil;
    }
    
    movepopvc = [[MovepopVC alloc] initWithNibName:@"MovepopVC" bundle:nil];
    movepopvc.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:movepopvc];
    popcontroller = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    
    if ([popcontroller isPopoverVisible])
    {
        [popcontroller dismissPopoverAnimated:YES];
    }
    else
    {
        [popcontroller presentPopoverFromRect:_vw_edit.frame
                                           inView:self.view
                         permittedArrowDirections:UIPopoverArrowDirectionUp
                                         animated:YES];
    }
}
- (IBAction)btn_delete_pressed:(id)sender
{
    // Go through the selected files and delete them all
    for (int cnt=0; cnt<[self.ary_selectedfilelist count]; cnt++)
        [FILE_MANAGER removeItemAtPath:[[BASE_PATH stringByAppendingPathComponent:self.currentPath] stringByAppendingPathComponent:[[self.ary_selectedfilelist objectAtIndex:cnt] objectForKey:NSNAME]]
                                 error:nil];
    
    // Clear every selection and adjust buttons, then reload table
    [self cleanFileListArray];
    self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
    for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
        [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];

    [self.ary_selectedfilelist removeAllObjects];
    _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
    [self buttonsHideorUnhide];
    _btn_selection.selected = NO;
}
- (IBAction)btn_newfolder_pressed:(id)sender
{
    // Clear every selection and adjust buttons, then reload table
    for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
        [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
    [self.ary_selectedfilelist removeAllObjects];
    _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
    [self buttonsHideorUnhide];
    _btn_selection.selected = NO;
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];
    
    // Prompt the user to enter a name for creating new folder
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"Enter name"
                                                                        message:@"Enter new folder name here"
                                                                      textField:&textField
                                                                          block:^(BlockTextPromptAlertView *alert){
                                                                              [alert.textField resignFirstResponder];
                                                                              return YES;
                                                                          }];
    [alert setCancelButtonWithTitle:@"Cancel" block:^{

    }];
    [alert addButtonWithTitle:@"Okay" block:^{
        //NSLog(@"Text: %@", textField.text);
        
        [FILE_MANAGER createDirectoryAtPath:[[BASE_PATH stringByAppendingPathComponent:self.currentPath] stringByAppendingPathComponent:textField.text]
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
        [self cleanFileListArray];
        self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
        if (isGrid)
        {
            [self clearGrid];
            [self createGrid:self.ary_filelist];
        }
        else
            [_tbl_files reloadData];
    }];
    [alert show];
}

- (IBAction)btn_refresh_pressed:(id)sender
{    
    // Clean everything and if in editing mode, change it
    _btn_mode.selected = NO;
    for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
        [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
    [self.ary_selectedfilelist removeAllObjects];
    _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
    isTableOrGridEditing = NO;
    _vw_unedit.hidden = NO;
    _vw_edit.hidden = YES;
    if (![self.currentPath isEqualToString:@""]) {
        _btn_back.hidden = NO;
        _lbl_back.hidden = NO;
    }
    [self buttonsHideorUnhide];
    _btn_selection.selected = NO;
    
    // Refresh file list array and refresh table or grid
    [self cleanFileListArray];
    self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];
    
    [SVProgressHUD showSuccessWithStatus:@"Refreshed."];
}
- (IBAction)btn_zip_pressed:(id)sender
{
    [self zip:self.ary_selectedfilelist];
}
- (IBAction)btn_mail_pressed:(id)sender
{
    [self mail:self.ary_selectedfilelist];
}
- (void)btn_rename_pressed:(id)sender
{
    UIButton *btn_sel = (UIButton *)sender;
    
    // Prompt the user to enter a name for zip file
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"Enter new name"
                                                                        message:@"Enter new name here (Only type name not extension)"
                                                                      textField:&textField
                                                                          block:^(BlockTextPromptAlertView *alert){
                                                                              [alert.textField resignFirstResponder];
                                                                              return YES;
                                                                          }];
    [alert setCancelButtonWithTitle:@"Cancel" block:^{

    }];
    [alert addButtonWithTitle:@"Okay" block:^{
        //NSLog(@"Text: %@", textField.text);
                
        NSString *filePath = [[self.ary_filelist objectAtIndex:btn_sel.tag-RENAMETAG] objectForKey:NSNAME];
        if ([[[self.ary_filelist objectAtIndex:btn_sel.tag-RENAMETAG] objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
        {
            if ([[filePath pathExtension] isEqualToString:@""])
            {
                // do nothing
            }
            else
            {
                textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@".%@",[filePath pathExtension]]];
            }
        }
        else
        {
            if ([[filePath pathExtension] isEqualToString:@""])
            {
                // do nohting
            }
            else
            {
                textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@".%@",[filePath pathExtension]]];
            }
        }
        
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Changing filename: %@ --> %@",[[self.ary_filelist objectAtIndex:btn_sel.tag-RENAMETAG] objectForKey:NSNAME],textField.text] maskType:SVProgressHUDMaskTypeClear];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing
            [FILE_MANAGER moveItemAtPath:[[[self.ary_filelist objectAtIndex:btn_sel.tag-RENAMETAG] objectForKey:NSPARENTPATH] stringByAppendingString:[[self.ary_filelist objectAtIndex:btn_sel.tag-RENAMETAG] objectForKey:NSNAME]]
                                  toPath:[[[self.ary_filelist objectAtIndex:btn_sel.tag-RENAMETAG] objectForKey:NSPARENTPATH] stringByAppendingString:textField.text]
                                   error:nil];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                
                // Clean filelist array and refill it
                [self cleanFileListArray];
                self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
                
                // Clear every selection and adjust buttons, then reload table
                for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
                    [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
                [self.ary_selectedfilelist removeAllObjects];
                _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
                _btn_mode.selected = NO;
                _vw_edit.hidden = YES;
                _vw_unedit.hidden = NO;
                isTableOrGridEditing = NO;
                if (isGrid)
                {
                    [self clearGrid];
                    [self createGrid:self.ary_filelist];
                }
                else
                    [_tbl_files reloadData];
                
                [SVProgressHUD showSuccessWithStatus:@"File renamed!!!"];
            });
        });
    }];
    [alert show];
}
////////////////////////////////////////////////////
//      Segment Click Methods
////////////////////////////////////////////////////
#pragma mark - Segment Click Methods
- (IBAction)seg_sort_pressed:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    switch (segment.selectedSegmentIndex)
    {
        // When button Creation Date is pressed
        case 0:
        {
            self.ary_filelist = [self sortbyCreationDate:self.ary_filelist];
        }
            break;
            
        // When button Mod Date is pressed
        case 1:
        {
            self.ary_filelist = [self sortbyModDate:self.ary_filelist];
        }
            break;
            
        // When button Name is pressed
        case 2:
        {
            self.ary_filelist = [self sortbyName:self.ary_filelist];
        }
            break;
            
        // When button Size is pressed
        case 3:
        {
            self.ary_filelist = [self sortbySize:self.ary_filelist];
        }
            break;
        
        // When button Kind is pressed
        case 4:
        {
            self.ary_filelist = [self sortbyKind:self.ary_filelist];
        }
            break;
            
        default:
            break;
    }
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];
}
- (IBAction)seg_mode_pressed:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    switch (segment.selectedSegmentIndex)
    {
        // When button Grid is pressed
        case 0:
        {
            isGrid = YES;
            _scrl_grid.hidden = NO;
            _tbl_files.hidden = YES;
        }
            break;
            
        // When button Table is pressed
        case 1:
        {
            isGrid = NO;
            _scrl_grid.hidden = YES;
            _tbl_files.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    // Reset the Table or Grid to display the current level of folder structure
    [self cleanFileListArray];
    self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];
}
////////////////////////////////////////////////////
//      Tableview Delegates
////////////////////////////////////////////////////
#pragma mark - Tableview Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.ary_filelist count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *currentDict = [self.ary_filelist objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    
    // When table is in editing mode, these changes to be made upon selection
    if (isTableOrGridEditing)
    {
        if ([[currentDict objectForKey:SELECTIONBOOL] boolValue]==YES)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton *btn_rename = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_rename.frame=CGRectMake(620, 10, 30, 30);
        [btn_rename setImage:[UIImage imageNamed:@"Rename.png"] forState:UIControlStateNormal];
        [btn_rename addTarget:self action:@selector(btn_rename_pressed:) forControlEvents:UIControlEventTouchUpInside];
        btn_rename.tag = indexPath.row+RENAMETAG;
        [cell.contentView addSubview:btn_rename];
    }
    else
    {
        NSArray *ary_views = [cell.contentView subviews];
        for (int cnt=0; cnt<[ary_views count]; cnt++)
            if ([[ary_views objectAtIndex:cnt] isKindOfClass:[UIButton class]])
                [[ary_views objectAtIndex:cnt] removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Adjust images, name, size, creation date, number of items
    cell.textLabel.text = [currentDict objectForKey:NSNAME];
    cell.imageView.backgroundColor = [UIColor clearColor];
    // Object is Directory
    if ([[currentDict objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
    {
        cell.imageView.image = [UIImage imageNamed:@"grid_folder.png"];
        NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:[[currentDict objectForKey:NSSIZE] longLongValue]
                                                                 countStyle:NSByteCountFormatterCountStyleFile];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ items, Size : %@, Date : %@",[currentDict objectForKey:NSCHILDCOUNT],folderSizeStr,[currentDict objectForKey:NSFILECREATIONDATE]];
    }
    // Object is File
    else
    {
        cell.imageView.image = [self chooseImageFilename:[currentDict objectForKey:NSMIMETYPE]];
        NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:[[currentDict objectForKey:NSFILESIZE] longLongValue]
                                                                 countStyle:NSByteCountFormatterCountStyleFile];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Size : %@, Date : %@",fileSizeStr,[currentDict objectForKey:NSFILECREATIONDATE]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentDict = [[NSDictionary alloc] initWithDictionary:[self.ary_filelist objectAtIndex:indexPath.row]];

    // Table is in editing mode
    if (isTableOrGridEditing)
    {
        if ([[currentDict objectForKey:SELECTIONBOOL] boolValue]==YES)
        {
            [[self.ary_filelist objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
            for (int cnt=0; cnt<[self.ary_selectedfilelist count]; cnt++)
            {
                if ([[currentDict objectForKey:NSFILESYSTEMFILENUMBER] integerValue] == [[[self.ary_selectedfilelist objectAtIndex:cnt] objectForKey:NSFILESYSTEMFILENUMBER] integerValue])
                {
                    [self.ary_selectedfilelist removeObjectAtIndex:cnt];
                    _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
                    break;
                }
            }
        }
        else
        {
            [[self.ary_filelist objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:YES] forKey:SELECTIONBOOL];
            [self.ary_selectedfilelist addObject:[self.ary_filelist objectAtIndex:indexPath.row]];
            _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
        }
        [_tbl_files reloadData];
    }
    // Table is not in editing mode
    else
    {
        // Object is Directory
        if ([[currentDict objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
        {
            _btn_back.hidden = NO;
            _lbl_back.hidden = NO;
            _lbl_heading.text = [currentDict objectForKey:NSNAME];
            _lbl_back.text = [currentDict objectForKey:NSPARENTNAME];
            self.currentPath = [self.currentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[currentDict objectForKey:NSNAME]]];
            
            [self cleanFileListArray];
            self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
            //NSLog(@"Directory Contents - \n%@",self.ary_filelist);
            [self pushAnimation:_tbl_files animationSide:@"Right"];
            [_tbl_files reloadData];
        }
        // Object is File
        else
        {
            // File is a Zip file
            if ([[currentDict objectForKey:NSMIMETYPE] isEqualToString:@"application/zip"])
            {
                [self unzip:[[currentDict objectForKey:NSPARENTPATH] stringByAppendingString:[currentDict objectForKey:NSNAME]]];
            }
            // Rest the files if supported by documentInteractionController will open else nothing will happen
            else
            {
                [self openDocumentForPreview:[[currentDict objectForKey:NSPARENTPATH] stringByAppendingString:[currentDict objectForKey:NSNAME]]];
            }
        }
    }
    [self buttonsHideorUnhide];
    if ([self.ary_selectedfilelist count]==0)
        _btn_selection.selected = NO;
    else
        _btn_selection.selected = YES;
}
////////////////////////////////////////////////////
//      UiScrollview Delegates
////////////////////////////////////////////////////
#pragma mark - UiScrollview Delegates
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    timerCounter = 0;
    if (isGrid) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageHeight = _scrl_grid.frame.size.height;
        currentGridPage = floor((_scrl_grid.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
        //NSLog(@"Current Grid Page - %d",currentGridPage);
    }
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (isGrid) {
//        // When scrolled clear the view and create again
//        [self clearGrid];
//        [self createGrid:self.ary_filelist];
//    }
//}
////////////////////////////////////////////////////
//      Animations On Selected Button
////////////////////////////////////////////////////
#pragma mark - Animations On Selected Button
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void) dragGesture:(UIPanGestureRecognizer *)panGesture
{
    // Fetch button on which pan gesture is initialized and bring it to front
    buttonSelectedToMove = (UIButton *)panGesture.view;
    [_scrl_grid bringSubviewToFront:buttonSelectedToMove];
    CGPoint point = [panGesture locationInView:_scrl_grid];     // Get the position of touch in the view
    
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:{
            _scrl_grid.scrollEnabled = NO;
            originalCenter = buttonSelectedToMove.center;      // Save original center of button so that when it is unhandled, it reaches original position
            buttonSelectedToMove.alpha = 0.4;   // Make the selected button lighter than other buttons
            
            [self animateFirstTouchAtPoint:point button:buttonSelectedToMove];   // Animate button center to touch point
            timerCounter = 0;
        }
            break;
            
        case UIGestureRecognizerStateChanged:{
            buttonSelectedToMove.center = point;
            
            // If button is hold to top of scroll screen, then scroll one screen top
            if (CGRectContainsPoint(CGRectMake(0, _scrl_grid.contentOffset.y, _scrl_grid.frame.size.width, 50), point))
            {
                if (currentGridPage!=0 && timerCounter>15)
                {
                    timerCounter = 0;
                    [_scrl_grid setContentOffset:CGPointMake(0, (currentGridPage-1)*_scrl_grid.frame.size.height) animated:YES];
                }
                else
                    timerCounter = timerCounter+1;
            }
            // If button is hold to bottom of scroll screen, then scroll one screen bottom
            else if (CGRectContainsPoint(CGRectMake(0, _scrl_grid.contentOffset.y+(_scrl_grid.frame.size.height-50), _scrl_grid.frame.size.width, 50), point))
            {
                if (currentGridPage!=totalPageCount-1 && timerCounter>15)
                {
                    timerCounter = 0;
                    [_scrl_grid setContentOffset:CGPointMake(0, (currentGridPage+1)*_scrl_grid.frame.size.height) animated:YES];
                }
                else
                    timerCounter = timerCounter+1;
            }
            // If none of the both conditions above holds true, then check each and every button in scroll to check whether over hovering button is on top of any button. So that we can animate that button.
            else
            {
                for(id obj in _scrl_grid.subviews)
                {
                    if ([obj isKindOfClass:[UIButton class]] && obj != buttonSelectedToMove)
                    {
                        UIButton *button = (UIButton *)obj;
                        CGPoint pointInView = [_scrl_grid convertPoint:point toView:button];
                        
                        if ([button pointInside:pointInView withEvent:nil])
                        {
                            button.layer.shadowColor = [UIColor whiteColor].CGColor;
                            button.layer.shadowOffset = CGSizeZero;
                            button.layer.shadowRadius = 10.0;
                            button.layer.shadowOpacity = 1.0;
                            button.layer.masksToBounds = NO;
                            
                            if ([[[self.ary_filelist objectAtIndex:button.tag] objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
                            {
                                // Animate enlarging button which is hovered if its a directory
                                CABasicAnimation *stetchAnimationX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
                                stetchAnimationX.toValue = [NSNumber numberWithDouble:(button.frame.size.width+30)/button.frame.size.width];
                                
                                CABasicAnimation *stetchAnimationY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
                                stetchAnimationY.toValue = [NSNumber numberWithDouble:(button.frame.size.height+30)/button.frame.size.height];
                                
                                CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
                                animationGroup.animations = [NSArray arrayWithObjects:stetchAnimationX,stetchAnimationY,nil];
                                animationGroup.removedOnCompletion = YES;
                                animationGroup.fillMode = kCAFillModeRemoved;
                                animationGroup.duration = 0.3;
                                
                                [button.layer addAnimation:animationGroup forKey:@"animations"];
                            }
                        }
                        else
                        {
                            button.layer.shadowColor = [UIColor clearColor].CGColor;
                        }
                    }
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            timerCounter = 0;

            // After the button is unhandled, check where it lands. If its a directory then we can animate and shift that file/folder into that directory, else we can animate the button back to its position.
            folder = NO;
            for(id obj in _scrl_grid.subviews)
            {
                if ([obj isKindOfClass:[UIButton class]] && obj != buttonSelectedToMove)
                {
                    UIButton *button = (UIButton *)obj;
                    CGPoint pointInView = [_scrl_grid convertPoint:point toView:button];
                    
                    if ([button pointInside:pointInView withEvent:nil])
                    {                        
                        if ([[[self.ary_filelist objectAtIndex:button.tag] objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
                        {
                            NSString *selectedPath = [NSString stringWithFormat:@"%@%@",[[self.ary_filelist objectAtIndex:buttonSelectedToMove.tag] objectForKey:NSPARENTPATH],[[self.ary_filelist objectAtIndex:buttonSelectedToMove.tag] objectForKey:NSNAME]];
                            NSString *newPath = [NSString stringWithFormat:@"%@%@/%@",[[self.ary_filelist objectAtIndex:button.tag] objectForKey:NSPARENTPATH],[[self.ary_filelist objectAtIndex:button.tag] objectForKey:NSNAME],[[self.ary_filelist objectAtIndex:buttonSelectedToMove.tag] objectForKey:NSNAME]];
                            
                            folder = [FILE_MANAGER moveItemAtPath:selectedPath
                                                  toPath:newPath
                                                   error:nil];
                        }
                    }
                    else
                    {
                        button.layer.shadowColor = [UIColor clearColor].CGColor;
                    }
                }
            }

            if (folder)
            {
                // Animate shrink selected button
                CABasicAnimation *stetchAnimationX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
                stetchAnimationX.toValue = [NSNumber numberWithDouble:(buttonSelectedToMove.frame.size.width-buttonSelectedToMove.frame.size.width)/buttonSelectedToMove.frame.size.width];
                
                CABasicAnimation *stetchAnimationY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
                stetchAnimationY.toValue = [NSNumber numberWithDouble:(buttonSelectedToMove.frame.size.height-buttonSelectedToMove.frame.size.height)/buttonSelectedToMove.frame.size.height];
                
                CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
                animationGroup.delegate = self;
                animationGroup.animations = [NSArray arrayWithObjects:stetchAnimationX,stetchAnimationY,nil];
                animationGroup.removedOnCompletion = YES;
                animationGroup.fillMode = kCAFillModeRemoved;
                animationGroup.duration = 0.4;
                
                [buttonSelectedToMove.layer addAnimation:animationGroup forKey:@"animations"];
            }
            else
            {
                // Animate the button to its original center
                for(id obj in _scrl_grid.subviews)
                {
                    if ([obj isKindOfClass:[UIButton class]])
                    {
                        UIButton *button = (UIButton *)obj;
                        button.layer.shadowColor = [UIColor clearColor].CGColor;
                    }
                }
                [self animateButtonToCenter:buttonSelectedToMove];      // Animate button to its original center
                buttonSelectedToMove.alpha = 1.0;   // Make the selected button normal again
            }
            
            _scrl_grid.scrollEnabled = YES;
        }
            break;
         
        case UIGestureRecognizerStateCancelled:{
            timerCounter = 0;

            // After the button is unhandled, check where it lands. If its a directory then we can animate and shift that file/folder into that directory, else we can animate the button back to its position.
            folder = NO;
            for(id obj in _scrl_grid.subviews)
            {
                if ([obj isKindOfClass:[UIButton class]] && obj != buttonSelectedToMove)
                {
                    UIButton *button = (UIButton *)obj;
                    CGPoint pointInView = [_scrl_grid convertPoint:point toView:button];
                    
                    if ([button pointInside:pointInView withEvent:nil])
                    {
                        if ([[[self.ary_filelist objectAtIndex:button.tag] objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
                        {
                            NSString *selectedPath = [NSString stringWithFormat:@"%@%@",[[self.ary_filelist objectAtIndex:buttonSelectedToMove.tag] objectForKey:NSPARENTPATH],[[self.ary_filelist objectAtIndex:buttonSelectedToMove.tag] objectForKey:NSNAME]];
                            NSString *newPath = [NSString stringWithFormat:@"%@%@/%@",[[self.ary_filelist objectAtIndex:button.tag] objectForKey:NSPARENTPATH],[[self.ary_filelist objectAtIndex:button.tag] objectForKey:NSNAME],[[self.ary_filelist objectAtIndex:buttonSelectedToMove.tag] objectForKey:NSNAME]];
                            
                            folder = [FILE_MANAGER moveItemAtPath:selectedPath
                                                           toPath:newPath
                                                            error:nil];
                        }
                    }
                    else
                    {
                        button.layer.shadowColor = [UIColor clearColor].CGColor;
                    }
                }
            }
            
            if (folder)
            {
                // Animate shrink selected button
                CABasicAnimation *stetchAnimationX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
                stetchAnimationX.toValue = [NSNumber numberWithDouble:(buttonSelectedToMove.frame.size.width-200)/buttonSelectedToMove.frame.size.width];
                
                CABasicAnimation *stetchAnimationY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
                stetchAnimationY.toValue = [NSNumber numberWithDouble:(buttonSelectedToMove.frame.size.height-200)/buttonSelectedToMove.frame.size.height];
                
                CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
                animationGroup.delegate = self;
                animationGroup.animations = [NSArray arrayWithObjects:stetchAnimationX,stetchAnimationY,nil];
                animationGroup.removedOnCompletion = YES;
                animationGroup.fillMode = kCAFillModeRemoved;
                animationGroup.duration = 0.4;
                
                [buttonSelectedToMove.layer addAnimation:animationGroup forKey:@"animations"];
            }
            else
            {
                // Animate the button to its original center
                for(id obj in _scrl_grid.subviews)
                {
                    if ([obj isKindOfClass:[UIButton class]])
                    {
                        UIButton *button = (UIButton *)obj;
                        button.layer.shadowColor = [UIColor clearColor].CGColor;
                    }
                }
                [self animateButtonToCenter:buttonSelectedToMove];    // Animate button to its original center
                buttonSelectedToMove.alpha = 1.0;   // Make the selected button normal again
            }
            
            _scrl_grid.scrollEnabled = YES;
        }
            break;
        
        default:
            break;
    }
}
// Animation selected button to center of touchpoint
- (void)animateFirstTouchAtPoint:(CGPoint)touchPoint button:(UIButton *)buttonSelected
{
    #define GROW_FACTOR 1.2f
    #define SHRINK_FACTOR 1.1f
    #define GROW_ANIMATION_DURATION_SECONDS 0.15
    #define SHRINK_ANIMATION_DURATION_SECONDS 0.15
 
    [UIView animateWithDuration:GROW_ANIMATION_DURATION_SECONDS animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(GROW_FACTOR, GROW_FACTOR);
        buttonSelected.transform = transform;
    }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:(NSTimeInterval)SHRINK_ANIMATION_DURATION_SECONDS animations:^{
                             buttonSelected.transform = CGAffineTransformMakeScale(SHRINK_FACTOR, SHRINK_FACTOR);
                         }];
                         
                     }];
    
    [UIView animateWithDuration:(NSTimeInterval)GROW_ANIMATION_DURATION_SECONDS + SHRINK_ANIMATION_DURATION_SECONDS animations:^{
        buttonSelected.center = touchPoint;
    }];
}
// Animation to make the button reach its original center and bounce
- (void)animateButtonToCenter:(UIButton *)buttonSelected
{
    CALayer *welcomeLayer = buttonSelected.layer;
    
    // Create a keyframe animation to follow a path back to the center.
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    bounceAnimation.removedOnCompletion = NO;
    
    CGFloat animationDuration = 0.5f;
    
    // Create the path for the bounces.
    UIBezierPath *bouncePath = [[[UIBezierPath alloc] init] autorelease];
    
    CGPoint centerPoint = originalCenter;
    CGFloat midX = centerPoint.x;
    CGFloat midY = centerPoint.y;
    CGFloat originalOffsetX = buttonSelected.center.x - midX;
    CGFloat originalOffsetY = buttonSelected.center.y - midY;
    CGFloat offsetDivider = 2.0f;
    
    BOOL stopBouncing = NO;
    
    // Start the path at the button's current location.
    [bouncePath moveToPoint:CGPointMake(buttonSelected.center.x, buttonSelected.center.y)];
    [bouncePath addLineToPoint:CGPointMake(midX, midY)];
    
    // Add to the bounce path in decreasing excursions from the center.
    while (stopBouncing != YES) {
        
        CGPoint excursion = CGPointMake(midX + originalOffsetX/offsetDivider, midY + originalOffsetY/offsetDivider);
        [bouncePath addLineToPoint:excursion];
        [bouncePath addLineToPoint:centerPoint];
        
        offsetDivider += 4;
        animationDuration += 1/offsetDivider;
        if ((abs(originalOffsetX/offsetDivider) < 6) && (abs(originalOffsetY/offsetDivider) < 6)) {
            stopBouncing = YES;
        }
    }
    
    bounceAnimation.path = [bouncePath CGPath];
    bounceAnimation.duration = animationDuration;
    
    // Create a basic animation to restore the size of the button.
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.removedOnCompletion = YES;
    transformAnimation.duration = animationDuration;
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    
    // Create an animation group to combine the keyframe and basic animations.
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
    // Set self as the delegate to allow for a callback to reenable user interaction.
    theGroup.delegate = self;
    theGroup.duration = animationDuration;
    theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    theGroup.animations = @[bounceAnimation, transformAnimation];
    
    // Add the animation group to the layer.
    [welcomeLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
    
    // Set the button view's center and transformation to the original values in preparation for the end of the animation.
    buttonSelected.center = centerPoint;
    buttonSelected.transform = CGAffineTransformIdentity;
}
/**
 Animation delegate method called when the animation's finished: restore the transform and reenable user interaction.
 **/
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	buttonSelectedToMove.transform = CGAffineTransformIdentity;
    _scrl_grid.userInteractionEnabled = YES;
    
    if (folder)
    {
        // Clear every selection and adjust buttons, then reload table
        [self cleanFileListArray];
        self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
        for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
            [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
        if (isGrid)
        {
            [self clearGrid];
            [self createGrid:self.ary_filelist];
        }
        else
            [_tbl_files reloadData];
    }
}
// Animation to make the view shine
- (void)makeViewShine:(UIView*)view
{
    view.layer.shadowColor = [UIColor whiteColor].CGColor;
    view.layer.shadowRadius = 10.0f;
    view.layer.shadowOpacity = 1.0f;
    view.layer.shadowOffset = CGSizeZero;
    
    [UIView animateWithDuration:0.7f delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction  animations:^{
        
        [UIView setAnimationRepeatCount:15];
        view.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        
    } completion:^(BOOL finished) {
        
        view.layer.shadowRadius = 0.0f;
        view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
    }];
}
////////////////////////////////////////////////////
//      Grid Preparation
////////////////////////////////////////////////////
#pragma mark - Grid Preparation
- (void) createGrid:(NSMutableArray *)fileList
{
//    HUD.labelText = [NSString stringWithFormat:@"Loading grid..."];
//    [HUD show:YES];
    
    // All the parameters to be set for the grid
    int noOfItemsPerPage = 9;
    
    int totalItems = [fileList count];
    int itemCounter = 0;
    int modulo = 0;
    int pageCount = 0;
    modulo = totalItems%noOfItemsPerPage;
    pageCount = totalItems/noOfItemsPerPage;
    if (modulo != 0)
        pageCount = pageCount+1;
    totalPageCount = pageCount;
    
    // Changeable properties
    float scrlWidth = 700;
    float scrlHeight = 800;

    float noOfRows = 3;
    float noOfCols = 3;
    
    float xPadding = 15;
    float yPadding = 16.5;
    float itemWidth = 213.33;
    float itemHeight = 244.66;
    
    _scrl_grid.contentSize = CGSizeMake(scrlWidth, pageCount*scrlHeight);
    //_scrl_grid.backgroundColor = [UIColor redColor];
    
    // Create the grid using above properties
    for (int page=0; page<pageCount; page++)
    {
        for (int row=0; row<noOfRows; row++)
        {
            for (int col=0; col<noOfCols; col++)
            {
                if (itemCounter==totalItems)
                    goto loopBroken;
                
                // Main Grid Button
                UIButton *btn_grid = [UIButton buttonWithType:UIButtonTypeCustom];
                btn_grid.frame = CGRectMake((xPadding*(col+1))+(itemWidth*col), ((yPadding*(row+1))+(itemHeight*row))+(page*scrlHeight), itemWidth, itemHeight);
                btn_grid.accessibilityLabel = NSStringFromCGRect(btn_grid.frame);
                [btn_grid.layer setCornerRadius:10.0f];
                [btn_grid setBackgroundColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
                [btn_grid setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                
                [btn_grid addTarget:self action:@selector(btn_itemSelected:) forControlEvents:UIControlEventTouchUpInside];
                                
                // Size/Item label
                UILabel *lbl_details = [[UILabel alloc] init];
                lbl_details.frame = CGRectMake(3, 192, 207, 50);
                lbl_details.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
                lbl_details.textAlignment = NSTextAlignmentCenter;
                //lbl_details.lineBreakMode = NSLineBreakByTruncatingMiddle;
                [lbl_details setTextColor:[UIColor whiteColor]];
                lbl_details.numberOfLines = 3;
                lbl_details.backgroundColor = [UIColor clearColor];
                
                // Set Image and Size/Item
                if ([[[fileList objectAtIndex:itemCounter] objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
                {
                    // Set image insets according to need
                    [btn_grid setImageEdgeInsets:UIEdgeInsetsMake(20, 42.66, 96.66, 42.67)];
                    [btn_grid setImage:[UIImage imageNamed:@"grid_folder.png"] forState:UIControlStateNormal];
                    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:[[[fileList objectAtIndex:itemCounter] objectForKey:NSSIZE] longLongValue]
                                                                             countStyle:NSByteCountFormatterCountStyleFile];
                    lbl_details.text = [NSString stringWithFormat:@"%@ items\n%@\n%@",[[fileList objectAtIndex:itemCounter] objectForKey:NSCHILDCOUNT],folderSizeStr,[[fileList objectAtIndex:itemCounter] objectForKey:NSFILECREATIONDATE]];
                }
                else
                {
                    // Set image insets according to need
                    [btn_grid setImageEdgeInsets:UIEdgeInsetsMake(30, 42.66, 86.66, 42.67)];
                    [btn_grid setImage:[UIImage imageNamed:@"grid_file.png"] forState:UIControlStateNormal];
                    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:[[[fileList objectAtIndex:itemCounter] objectForKey:NSSIZE] longLongValue]
                                                                           countStyle:NSByteCountFormatterCountStyleFile];
                    lbl_details.text = [NSString stringWithFormat:@"%@\n%@",fileSizeStr,[[fileList objectAtIndex:itemCounter] objectForKey:NSFILECREATIONDATE]];
                }
                
                // Title - Name
                [btn_grid setTitle:[[fileList objectAtIndex:itemCounter] objectForKey:NSNAME] forState:UIControlStateNormal];
                //btn_grid.titleLabel.backgroundColor = [UIColor brownColor];
                btn_grid.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Condensed" size:22.0f];
                btn_grid.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn_grid.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
                [btn_grid setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn_grid setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
                btn_grid.titleLabel.numberOfLines = 2;
                [btn_grid setTitleEdgeInsets:UIEdgeInsetsMake(133,-126,40,1)]; // Set Left - should be -(minus)setImage width size
                
                // When gird is in editing mode, these changes to be made upon selection
                // Add a save button and checkmark box to each and every button
                if (isTableOrGridEditing)
                {
                    // Button tick mark for selecting and de-selecting
                    UIButton *btn_tick = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn_tick.frame = CGRectMake(180.33, 5, 28, 28);
                    
                    if ([[[fileList objectAtIndex:itemCounter] objectForKey:SELECTIONBOOL] boolValue]==YES)
                    {
                        [btn_tick setBackgroundImage:[UIImage imageNamed:@"grid_checkmarkbox.png"] forState:UIControlStateNormal];
                        [btn_tick setImage:[UIImage imageNamed:@"grid_checkmark.png"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [btn_tick setBackgroundImage:[UIImage imageNamed:@"grid_checkmarkbox.png"] forState:UIControlStateNormal];
                        [btn_tick setImage:nil forState:UIControlStateNormal];
                    }
                    //[btn_tick setBackgroundColor:[UIColor greenColor]];
                    [btn_grid addSubview:btn_tick];
                    
                    UIButton *btn_rename = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn_rename.frame=CGRectMake(7, 7, 28, 28);
                    [btn_rename setImage:[UIImage imageNamed:@"Rename.png"] forState:UIControlStateNormal];
                    [btn_rename addTarget:self action:@selector(btn_rename_pressed:) forControlEvents:UIControlEventTouchUpInside];
                    btn_rename.tag = RENAMETAG+itemCounter;
                    [btn_grid addSubview:btn_rename];
                }
                // When grid is not in editing mode, do this
                else
                {
                    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                                            initWithTarget:self
                                                                                    action:@selector(dragGesture:)];
                    longPressRecognizer.minimumPressDuration = 1.0;
                    longPressRecognizer.numberOfTouchesRequired = 1;
                    [btn_grid addGestureRecognizer:longPressRecognizer];
                    [longPressRecognizer release];
                }
                
                // Set tag and Add views to main btn_grids as a subview
                btn_grid.tag = itemCounter;
                [btn_grid addSubview:lbl_details];
                [_scrl_grid addSubview:btn_grid];

                itemCounter++;
            }
        }
    }
    loopBroken:;
//    [HUD hide:YES afterDelay:0.3];
}
- (void) clearGrid
{
    for (id view in [_scrl_grid subviews])
        [view removeFromSuperview];
}
- (void) btn_itemSelected:(id)sender
{
    // Grid is in editing mode
    if (isTableOrGridEditing)
    {
        UIButton *button = (UIButton *)sender;
        NSDictionary *currentDict = [[NSDictionary alloc] initWithDictionary:[self.ary_filelist objectAtIndex:button.tag]];
        
        // Toggle checkmark button selection
        if ([[currentDict objectForKey:SELECTIONBOOL] boolValue]==YES)
        {
            [[self.ary_filelist objectAtIndex:button.tag] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
            for (int cnt=0; cnt<[self.ary_selectedfilelist count]; cnt++)
            {
                if ([[currentDict objectForKey:NSFILESYSTEMFILENUMBER] integerValue] == [[[self.ary_selectedfilelist objectAtIndex:cnt] objectForKey:NSFILESYSTEMFILENUMBER] integerValue])
                {
                    [self.ary_selectedfilelist removeObjectAtIndex:cnt];
                    _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
                    break;
                }
            }
        }
        else
        {
            [[self.ary_filelist objectAtIndex:button.tag] setObject:[NSNumber numberWithBool:YES] forKey:SELECTIONBOOL];
            [self.ary_selectedfilelist addObject:[self.ary_filelist objectAtIndex:button.tag]];
            _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
        }
        [self clearGrid];
        [self createGrid:self.ary_filelist];
        
        [self buttonsHideorUnhide];
        if ([self.ary_selectedfilelist count]==0)
            _btn_selection.selected = NO;
        else
            _btn_selection.selected = YES;
    }
    // Grid is not in editing mode
    else
    {
        UIButton *button = (UIButton *)sender;
        //button.backgroundColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1.0f];
        NSDictionary *currentDict = [[[NSDictionary alloc] initWithDictionary:[self.ary_filelist objectAtIndex:button.tag]] autorelease];
        
        // Object is Directory
        if ([[currentDict objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
        {
            _btn_back.hidden = NO;
            _lbl_back.hidden = NO;
            _lbl_heading.text = [currentDict objectForKey:NSNAME];
            _lbl_back.text = [currentDict objectForKey:NSPARENTNAME];
            self.currentPath = [self.currentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[currentDict objectForKey:NSNAME]]];
            
            [self cleanFileListArray];
            self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
            //NSLog(@"Directory Contents - \n%@",self.ary_filelist);
            [self pushAnimation:_scrl_grid animationSide:@"Right"];
            [self clearGrid];
            [self createGrid:self.ary_filelist];
        }
        // Object is File
        else
        {
            // File is a Zip file
            if ([[currentDict objectForKey:NSMIMETYPE] isEqualToString:@"application/zip"])
            {
                [self unzip:[[currentDict objectForKey:NSPARENTPATH] stringByAppendingString:[currentDict objectForKey:NSNAME]]];
            }
            // Rest the files if supported by documentInteractionController will open else nothing will happen
            else
            {
                [self openDocumentForPreview:[[currentDict objectForKey:NSPARENTPATH] stringByAppendingString:[currentDict objectForKey:NSNAME]]];
            }
        }
        
        [self buttonsHideorUnhide];
        if ([self.ary_selectedfilelist count]==0)
            _btn_selection.selected = NO;
        else
            _btn_selection.selected = YES;
    }
}
////////////////////////////////////////////////////
//      Basic Operations on Files/Folders
////////////////////////////////////////////////////
#pragma mark - Basic Operations on Files/Folder
- (NSMutableArray *) getFilesfromFolderName:(NSString *)pathFolder
{
    NSString *parentDirName = @"";
    NSString *parentsParentName = @"";
    int itemCount = [[pathFolder pathComponents] count];
    if (itemCount==0)
    {
        parentDirName = [BASE_PATH lastPathComponent];
        NSArray* pathComponents = [BASE_PATH pathComponents];
        NSArray* lastTwoArray = [pathComponents subarrayWithRange:NSMakeRange([pathComponents count]-2,1)];
        parentsParentName = [NSString pathWithComponents:lastTwoArray];
    }
    else if (itemCount==1)
    {
        parentDirName = [pathFolder lastPathComponent];
        parentsParentName = [BASE_PATH lastPathComponent];
    }
    else
    {
        parentDirName = [pathFolder lastPathComponent];
        NSArray* pathComponents = [pathFolder pathComponents];
        NSArray* lastTwoArray = [pathComponents subarrayWithRange:NSMakeRange([pathComponents count]-2,1)];
        parentsParentName = [NSString pathWithComponents:lastTwoArray];
    }
    
    pathFolder = [NSString stringWithFormat:@"%@",[BASE_PATH stringByAppendingPathComponent:pathFolder]];
    NSArray *fileList = [FILE_MANAGER contentsOfDirectoryAtPath:pathFolder error:nil];
    NSMutableArray *aryFolderContent = [[NSMutableArray alloc] init];
    
    for (int cnt=0; cnt<[fileList count]; cnt++)
    {
        NSDictionary *dictDetailsFile = [FILE_MANAGER attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",pathFolder,[fileList objectAtIndex:cnt]] error:nil];
        NSMutableDictionary *newDictDetailsFile = [[[NSMutableDictionary alloc] initWithDictionary:dictDetailsFile] autorelease];
        [newDictDetailsFile setObject:[fileList objectAtIndex:cnt] forKey:NSNAME];
        [newDictDetailsFile setObject:[pathFolder stringByAppendingString:@"/"] forKey:NSPARENTPATH];
        [newDictDetailsFile setObject:parentDirName forKey:NSPARENTNAME];
        [newDictDetailsFile setObject:parentsParentName forKey:NSGRANDPARENTNAME];
        [newDictDetailsFile setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
        if ([[dictDetailsFile objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEREGULAR])
        {
            [newDictDetailsFile setObject:[self mimeTypeForFileAtPath:[NSString stringWithFormat:@"%@/%@",pathFolder,[fileList objectAtIndex:cnt]]]
                                   forKey:NSMIMETYPE];
            [newDictDetailsFile setObject:[NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",[dictDetailsFile objectForKey:NSFILESIZE]] intValue]]
                                   forKey:NSSIZE];
        }
        else
        {
            [newDictDetailsFile setObject:[NSString stringWithFormat:@"%d",[[FILE_MANAGER contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",pathFolder,[fileList objectAtIndex:cnt]] error:nil] count]]
                                   forKey:NSCHILDCOUNT];
            [newDictDetailsFile setObject:[NSNumber numberWithInt:[[self sizeOfFolder:[pathFolder stringByAppendingPathComponent:[fileList objectAtIndex:cnt]]] intValue]]
                                   forKey:NSSIZE];
        }
        [aryFolderContent addObject:newDictDetailsFile];
    }
    
    if (_seg_sort.selectedSegmentIndex==0)          aryFolderContent = [self sortbyCreationDate:aryFolderContent];
    else if (_seg_sort.selectedSegmentIndex==1)     aryFolderContent = [self sortbyModDate:aryFolderContent];
    else if (_seg_sort.selectedSegmentIndex==2)     aryFolderContent = [self sortbyName:aryFolderContent];
    else if (_seg_sort.selectedSegmentIndex==3)     aryFolderContent = [self sortbySize:aryFolderContent];
    else if (_seg_sort.selectedSegmentIndex==4)     aryFolderContent = [self sortbyKind:aryFolderContent];

    return aryFolderContent;
}
- (void) deleteFileorFolder:(NSMutableArray *)selectedArray
{
    for (int cnt=0; cnt<[selectedArray count]; cnt++)
    {
        NSDictionary *dictCurrent = [selectedArray objectAtIndex:cnt];
        if ([[dictCurrent objectForKey:SELECTIONBOOL] boolValue]==YES)
            [FILE_MANAGER removeItemAtPath:[[dictCurrent objectForKey:NSPARENTPATH] stringByAppendingPathComponent:[dictCurrent objectForKey:NSNAME]] error: nil];
    }
}
// Delegate to move files from controller
-(void)moveFilesToNewFolder:(NSString *)newPath
{
    [popcontroller dismissPopoverAnimated:YES];
    
    for (int cnt=0; cnt<[self.ary_selectedfilelist count]; cnt++)
        [FILE_MANAGER moveItemAtPath:[[[self.ary_selectedfilelist objectAtIndex:cnt] objectForKey:NSPARENTPATH] stringByAppendingString:[[self.ary_selectedfilelist objectAtIndex:cnt] objectForKey:NSNAME]]
                              toPath:[newPath stringByAppendingPathComponent:[[self.ary_selectedfilelist objectAtIndex:cnt] objectForKey:NSNAME]]
                               error:nil];
    
    // Clear every selection and adjust buttons, then reload table
    [self cleanFileListArray];
    self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
    for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
        [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];
    
    [self.ary_selectedfilelist removeAllObjects];
    [self buttonsHideorUnhide];
    _btn_selection.selected = NO;
}
- (void) cleanFileListArray
{
    if((self.ary_filelist!=nil) && ([self.ary_filelist retainCount]>0))
    {
        [self.ary_filelist removeAllObjects];
        [self.ary_filelist release];
        //self.ary_filelist = nil;
    }
    self.ary_filelist = [[[NSMutableArray alloc] init] autorelease];
}
- (NSString*) mimeTypeForFileAtPath:(NSString *)path
{
    if (![FILE_MANAGER fileExistsAtPath:path])
        return nil;
    
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)[path pathExtension], NULL);
    CFStringRef mimeType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!mimeType)
        return @"application/octet-stream";
    return [NSMakeCollectable((NSString *)mimeType) autorelease];
}
- (UIImage *)chooseImageFilename:(NSString *)mimeType
{
    // This function fetches the correct image that needs to be associated with the mimetype. So change image filename here if there are any changes with the images...
//    NSDictionary *mimeTypeDict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                  @"file_hover.png",    @"application/octet-stream",            // File(By Default)
//                                  @"3gp_hover.png",     @"video/3gpp",                          // 3GP
//                                  @"avi_hover.png",     @"video/x-msvideo",                     // AVI
//                                  @"bmp_hover.png",     @"image/bmp",                           // Bitmap
//                                  @"doc_hover.png",     @"application/msword",                  // Doc File
//                                  @"epub_hover.png",    @"application/epub+zip",                // Epub
//                                  @"excel_hover.png",   @"application/vnd.ms-excel",            // Excel
//                                  @"flv_hover.png",     @"video/x-flv",                         // FLV
//                                  @"html_hover.png",    @"text/html",                           // HTML
//                                  @"jpeg_hover.png",    @"image/jpeg",                          // JPEG
//                                  @"mp3_hover.png",     @"audio/mpeg3",                         // MP3
//                                  @"pdf_hover.png",     @"application/pdf",                     // PDF
//                                  @"png_hover.png",     @"image/png",                           // PNG
//                                  @"ppt_hover.png",     @"application/mspowerpoint",            // PPT
//                                  @"wmv_hover.png",     @"video/x-ms-wmv",                      // WMV
//                                  @"xml_hover.png",     @"application/xml",                     // XML
//                                  nil];
//    
//    NSString *imageName = [mimeTypeDict objectForKey:mimeType];
//    [mimeTypeDict release];
//    if (imageName==nil)
//        return [UIImage imageNamed:@"file_hover.png"];          // File (By Default)
//    return [UIImage imageNamed:imageName];
    
    // Currently am using just a single image but we can select image as above logic for selecting and displaying image according to filetype. So for using that uncomment the above code and comment this code
    return [UIImage imageNamed:@"grid_file.png"];
}
- (NSString *) sizeOfFolder:(NSString *)folderPath
{
    NSArray *filesArray = [FILE_MANAGER subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int folderSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [FILE_MANAGER attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        folderSize += [fileDictionary fileSize];
    }
    return [NSString stringWithFormat:@"%llu",folderSize];
    /******************/
    //    This line will give you formatted size from bytes .... to KB,MB,GB
    //    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:folderSize
    //                                   countStyle:NSByteCountFormatterCountStyleFile];
    /******************/
}
- (int) numberOfItemsSelected:(NSMutableArray *)selectedArray
{
    int counter=0;
    for (int cnt=0; cnt<[selectedArray count]; cnt++)
        if ([[[selectedArray objectAtIndex:cnt] objectForKey:SELECTIONBOOL] boolValue]==YES)
            counter++;
    return counter;
}
////////////////////////////////////////////////////
//      Helper Methods
////////////////////////////////////////////////////
#pragma mark - Helper Methods
- (void) buttonsHideorUnhide
{
    // Toggle editing buttons
    if ([self.ary_selectedfilelist count]==0)
    {
        _btn_delete.enabled = NO;
        _btn_mail.enabled = NO;
        _btn_zip.enabled = NO;
        _btn_move.enabled = NO;
    }
    else
    {
        _btn_delete.enabled = YES;
        _btn_mail.enabled = YES;
        _btn_zip.enabled = YES;
        _btn_move.enabled = YES;
    }
}
/////////////////////////////////////////////////////////////////////
///////////       Mailing
/////////////////////////////////////////////////////////////////////
#pragma mark - Mailing
- (void) mail:(NSMutableArray *)selectedArray
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Files"];
        
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"jai.dhorajia@softwebsolutions.com"];
//        NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//        NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
        
        [mailer setToRecipients:toRecipients];
//        [mailer setCcRecipients:ccRecipients];
//        [mailer setBccRecipients:bccRecipients];
        
        // Prepare folder to zip
        [self zipPrepareTemperory:selectedArray ziprORmail:NO];

        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing
            
            // Zip the folder prepared in NSTemporaryDirectory()
            ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",[[selectedArray objectAtIndex:0] objectForKey:NSPARENTNAME]]]];
            [archive setDelegate:self];
            [archive deflateDirectory:[NSTemporaryDirectory() stringByAppendingPathComponent:[[selectedArray objectAtIndex:0] objectForKey:NSPARENTNAME]]
                       relativeToPath:NSTemporaryDirectory()
                    usingResourceFork:NO];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                // Attach zip file to the email
                NSData *zipFileData = [NSData dataWithContentsOfFile:[[NSTemporaryDirectory() stringByAppendingPathComponent:[[selectedArray objectAtIndex:0] objectForKey:NSPARENTNAME]] stringByAppendingString:@".zip"]];
                [mailer addAttachmentData:zipFileData mimeType:@"application/zip" fileName:[[[selectedArray objectAtIndex:0] objectForKey:NSPARENTNAME] stringByAppendingString:@".zip"]];
                
                // Fill out the email body text
                NSString *emailBody = @"Zip file attached to the email...";
                [mailer setMessageBody:emailBody isHTML:NO];
                
                [self presentViewController:mailer animated:YES completion:nil];
                [mailer release];
                
                // Clear every selection and adjust buttons, then reload table
                for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
                    [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
                [self.ary_selectedfilelist removeAllObjects];
                _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
                [self buttonsHideorUnhide];
                _btn_selection.selected = NO;
                if (isGrid)
                {
                    [self clearGrid];
                    [self createGrid:self.ary_filelist];
                }
                else
                    [_tbl_files reloadData];
                
                // Clean the temperory directory
                [self zipClearAll];
            });
        });
      }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
// Delegate for MFMailComposeViewController
- (void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self showAlert:@"Mail cancelled: you cancelled the operation and no email message was queued."];
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            [self showAlert:@"Mail saved: you saved the email message in the drafts folder."];
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            [self showAlert:@"Mail send: the email message is queued in the outbox. It is ready to send."];
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            [self showAlert:@"Mail failed: the email message was not saved or queued, possibly due to an error."];
            //NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            [self showAlert:@"Mail not sent."];
            //NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}
/////////////////////////////////////////////////////////////////////
///////////       Ziping and Unzipping Files
/////////////////////////////////////////////////////////////////////
#pragma mark - Ziping and Unzipping Files
// Unzipping
- (void) unzip:(NSString *)zipFilePath
{
    // Prompt the user to enter a name for zip file
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Message"
                                                   message:@"Are you sure that you want to Unzip this file!!!"];
    [alert setCancelButtonWithTitle:@"Cancel" block:^{
        // do nothing
    }];
    [alert addButtonWithTitle:@"Okay" block:^{
        //NSLog(@"Text: %@", textField.text);
        
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Unzipping - %@",[zipFilePath lastPathComponent]] maskType:SVProgressHUDMaskTypeClear];
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing*****
            
            // UnZip the folder to the current path
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            NSString *archivePath = zipFilePath;
            ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:archivePath];
            [archive setDelegate:self];
            [archive inflateToDiskUsingResourceFork:NO];
            // do something with inflated archive.
            // zipkit puts all inflated files in the same directory as the archive.
            [pool drain];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                
                [SVProgressHUD showSuccessWithStatus:@"Unzipped!!!"];
                [self unzipComplete];
            });
        });
    }];
    [alert show];
}
- (void)unzipComplete
{
    // do something after inflate finishes.
    [self cleanFileListArray];
    self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
    if (isGrid)
    {
        [self clearGrid];
        [self createGrid:self.ary_filelist];
    }
    else
        [_tbl_files reloadData];
}
// Zipping
- (void) zip:(NSMutableArray *)selectedArray
{
    // Prepare folder to zip
    [self zipPrepareTemperory:selectedArray ziprORmail:YES];
}
- (void) zipPrepareTemperory:(NSMutableArray *)selectedArray ziprORmail:(BOOL)type
{
    [SVProgressHUD showWithStatus:@"Preparing files for zipping..." maskType:SVProgressHUDMaskTypeClear];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        NSDictionary *dictOne = [selectedArray objectAtIndex:0];
        
        // Fetch temperory directory path and create directory at path with the parent name of the selected file or folder
        NSString *tmpDirPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[dictOne objectForKey:NSPARENTNAME]];
        [FILE_MANAGER createDirectoryAtPath:tmpDirPath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:nil];
        
        // Iterate through selected files or folders
        for (int cnt=0; cnt<[selectedArray count]; cnt++)
        {
            // Processing item dictionary
            NSDictionary *dictCurrent = [selectedArray objectAtIndex:cnt];
            [SVProgressHUD dismiss];
            [SVProgressHUD showWithStatus:[dictCurrent objectForKey:NSNAME] maskType:SVProgressHUDMaskTypeClear];
            
            // Selected item is folder
            if ([[dictCurrent objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
            {
                // Fetch tree path of folder iterating
                NSArray *subFiles = [FILE_MANAGER subpathsOfDirectoryAtPath:[[dictCurrent objectForKey:NSPARENTPATH] stringByAppendingString:[dictCurrent objectForKey:NSNAME]]
                                                                      error:nil];
                
                // Create folder of iterating item
                [FILE_MANAGER createDirectoryAtPath:[tmpDirPath stringByAppendingPathComponent:[dictCurrent objectForKey:NSNAME]]
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:nil];
                
                // Iterate all subpaths of the iterating folder
                for (int cnt=0; cnt<[subFiles count]; cnt++)
                {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showWithStatus:[[subFiles objectAtIndex:cnt] lastPathComponent] maskType:SVProgressHUDMaskTypeClear];

                    // Fetch details of each file or folder in subfiles
                    NSDictionary *dictDetailsFile = [FILE_MANAGER attributesOfItemAtPath:[[[dictCurrent objectForKey:NSPARENTPATH] stringByAppendingString:[dictCurrent objectForKey:NSNAME]] stringByAppendingPathComponent:[subFiles objectAtIndex:cnt]]
                                                                                   error:nil];
                    // Subfile is a folder
                    if ([[dictDetailsFile objectForKey:NSFILETYPE] isEqualToString:NSFILETYPEDIRECTORY])
                    {
                        [FILE_MANAGER createDirectoryAtPath:[[tmpDirPath stringByAppendingPathComponent:[dictCurrent objectForKey:NSNAME]] stringByAppendingPathComponent:[subFiles objectAtIndex:cnt]]
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:nil];
                    }
                    // Subfile is a file
                    else
                    {
                        [FILE_MANAGER copyItemAtPath:[[[dictCurrent objectForKey:NSPARENTPATH] stringByAppendingString:[dictCurrent objectForKey:NSNAME]] stringByAppendingPathComponent:[subFiles objectAtIndex:cnt]]
                                              toPath:[[tmpDirPath stringByAppendingPathComponent:[dictCurrent objectForKey:NSNAME]] stringByAppendingPathComponent:[subFiles objectAtIndex:cnt]]
                                               error:nil];
                    }
                    //dictDetailsFile = nil;
                }
            }
            // Selected item is file
            else
            {
                [SVProgressHUD dismiss];
                [SVProgressHUD showWithStatus:[dictCurrent objectForKey:NSNAME] maskType:SVProgressHUDMaskTypeClear];

                [FILE_MANAGER copyItemAtPath:[[dictCurrent objectForKey:NSPARENTPATH] stringByAppendingString:[dictCurrent objectForKey:NSNAME]]
                                      toPath:[tmpDirPath stringByAppendingPathComponent:[dictCurrent objectForKey:NSNAME]]
                                       error:nil];
            }
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            [SVProgressHUD showSuccessWithStatus:@"Ready with files to zip."];
            if (type)
                [self zipFinally:selectedArray];
        });
    });
}
- (void) zipFinally:(NSMutableArray *)selectedArray
{
    // Prompt the user to enter a name for zip file
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:@"Enter name"
                                                                        message:@"Enter zip file name here"
                                                                      textField:&textField
                                                                          block:^(BlockTextPromptAlertView *alert){
                                                                              [alert.textField resignFirstResponder];
                                                                              return YES;
                                                                          }];
    [alert setCancelButtonWithTitle:@"Cancel" block:^{
        // Clear every selection and adjust buttons, then reload table
        for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
            [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
        [self.ary_selectedfilelist removeAllObjects];
        _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
        [self buttonsHideorUnhide];
        _btn_selection.selected = NO;
        if (isGrid)
        {
            [self clearGrid];
            [self createGrid:self.ary_filelist];
        }
        else
            [_tbl_files reloadData];
        
        // Clean the temperory directory
        [self zipClearAll];
    }];
    [alert addButtonWithTitle:@"Okay" block:^{
        //NSLog(@"Text: %@", textField.text);
        
        currentProgress = 0;
        totalSizeProgress = [[self sizeOfFolder:NSTemporaryDirectory()] integerValue];
        
        if (![textField.text hasSuffix:@".zip"])
        {
            textField.text = [textField.text stringByAppendingString:@".zip"];
            [SVProgressHUD dismiss];
            [SVProgressHUD showProgress:0 status:[NSString stringWithFormat:@"Processsing - %@",textField.text]];
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showProgress:0 status:[NSString stringWithFormat:@"Processsing - %@.zip",textField.text]];
        }
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing*****
            
            // Zip the folder prepared in NSTemporaryDirectory()
            ZKFileArchive *archive = [ZKFileArchive archiveWithArchivePath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",[[selectedArray objectAtIndex:0] objectForKey:NSPARENTNAME]]]];
            [archive setDelegate:self];
            [archive deflateDirectory:[NSTemporaryDirectory() stringByAppendingPathComponent:[[selectedArray objectAtIndex:0] objectForKey:NSPARENTNAME]]
                       relativeToPath:NSTemporaryDirectory()
                    usingResourceFork:NO];
            
            // Move zipped file from NSTemporaryDirectory() to Document directory
            [FILE_MANAGER copyItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",[[selectedArray objectAtIndex:0] objectForKey:NSPARENTNAME]]]
                                  toPath:[[BASE_PATH stringByAppendingPathComponent:self.currentPath] stringByAppendingPathComponent:textField.text]
                                   error:nil];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
                
                // Clean filelist array and refill it
                [self cleanFileListArray];
                self.ary_filelist = [self getFilesfromFolderName:self.currentPath];
                
                // Clear every selection and adjust buttons, then reload table
                for (int cnt=0; cnt<[self.ary_filelist count]; cnt++)
                    [[self.ary_filelist objectAtIndex:cnt] setObject:[NSNumber numberWithBool:NO] forKey:SELECTIONBOOL];
                [self.ary_selectedfilelist removeAllObjects];
                _lbl_selectioncount.text = [NSString stringWithFormat:@"%d",[self.ary_selectedfilelist count]];
                [self buttonsHideorUnhide];
                _btn_selection.selected = NO;
                if (isGrid)
                {
                    [self clearGrid];
                    [self createGrid:self.ary_filelist];
                }
                else
                    [_tbl_files reloadData];
                
                // Clean the temperory directory
                [self zipClearAll];
                [SVProgressHUD showSuccessWithStatus:@"Zipped!!!"];
            });
        });
    }];
    [alert show];
}
- (void) zipClearAll
{
    NSString *folderPath = NSTemporaryDirectory();
    NSError *error = nil;
    for (NSString *file in [FILE_MANAGER contentsOfDirectoryAtPath:folderPath error:&error]) {
        [FILE_MANAGER removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
    }
}
////////////////////////////////////////////////////
//      ZKArchive delegate methods
////////////////////////////////////////////////////
# pragma mark ZKArchive delegate methods
- (void)onZKArchive:(ZKArchive *) archive didUpdateBytesWritten:(unsigned long long)byteCount
{
    //NSLog(@"%llu",byteCount);
    currentProgress = currentProgress + byteCount;
    
    if (currentProgress > totalSizeProgress)
        [SVProgressHUD dismiss];
    else
        [SVProgressHUD showProgress:(float)currentProgress/(float)totalSizeProgress status:@"Zipping..."];
}
- (BOOL)zkDelegateWantsSizes
{
    return YES;
}
////////////////////////////////////////////////////
//      Document Interaction Controller Delegate Methods
////////////////////////////////////////////////////
#pragma mark Document Interaction Controller Delegate Methods
- (void) openDocumentForPreview:(NSString *)filePath
{
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    if (fileURL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Preview PDF
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
}
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}
/////////////////////////////////////////////////////////////////////
///////////       Sorting Methods
/////////////////////////////////////////////////////////////////////
#pragma mark - Sorting Methods
- (NSMutableArray *) sortbyName:(NSMutableArray *)nameArry
{    
    NSSortDescriptor *sorter = [[[NSSortDescriptor alloc]
                                 initWithKey:NSNAME
                                 ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sorter];
    [nameArry sortUsingDescriptors:sortDescriptors];
    return nameArry;
}
- (NSMutableArray *) sortbyCreationDate:(NSMutableArray *)dateArry
{
    NSSortDescriptor *sorter =[[[NSSortDescriptor alloc]
                               initWithKey:NSFILECREATIONDATE
                               ascending:NO
                               selector:@selector(compare:)] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sorter];
    [dateArry sortUsingDescriptors:sortDescriptors];
    return dateArry;
}
- (NSMutableArray *) sortbyModDate:(NSMutableArray *)dateArry
{
    NSSortDescriptor *sorter =[[[NSSortDescriptor alloc]
                                initWithKey:NSFILEMODIFICATIONDATE
                                ascending:NO
                                selector:@selector(compare:)] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sorter];
    [dateArry sortUsingDescriptors:sortDescriptors];
    return dateArry;
}
- (NSMutableArray *) sortbySize:(NSMutableArray *)sizeArry
{
    NSSortDescriptor *sorter =[[[NSSortDescriptor alloc]
                               initWithKey:NSSIZE
                               ascending:NO
                               selector:@selector(compare:)] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sorter];
    [sizeArry sortUsingDescriptors:sortDescriptors];    
    return sizeArry;
}
- (NSMutableArray *) sortbyKind:(NSMutableArray *)nameArry
{
    NSSortDescriptor *sorter = [[[NSSortDescriptor alloc]
                                 initWithKey:NSFILETYPE
                                 ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject: sorter];
    [nameArry sortUsingDescriptors:sortDescriptors];
    return nameArry;
}
/////////////////////////////////////////////////////////////////////
///////////       Animation
/////////////////////////////////////////////////////////////////////
#pragma mark - Animation
- (void) pushAnimation:(UIView *)targetView animationSide:(NSString *)side
{
    if ([side isEqualToString:@"Left"])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
        [targetView.layer addAnimation:transition forKey:nil];
    }
    else
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [targetView.layer addAnimation:transition forKey:nil];
    }
}
//////////////////////////////////////////////////////////////////////////////////
///////////       Show Alert
//////////////////////////////////////////////////////////////////////////////////
#pragma mark Show Alert
- (void) showAlert:(NSString *)alertMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
@end
