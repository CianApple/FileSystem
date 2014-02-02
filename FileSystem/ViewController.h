//
//  ViewController.h
//  FileSystem
//
//  Created by Jai Dhorajia on 04/06/13.
//  Copyright (c) 2013 Softweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "ZipKit/ZKFileArchive.h"
#import "BlockTextPromptAlertView.h"
#import "MovepopVC.h"
#import "SVProgressHUD.h"

@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate,ZipKitDelegate,MovepopViewControllerDelegate,UIScrollViewDelegate,UIDocumentInteractionControllerDelegate,UIGestureRecognizerDelegate>
{
    NSString *currentPath;
    NSMutableArray *ary_filelist;
    NSMutableArray *ary_selectedfilelist;
    BOOL isTableOrGridEditing;
    BOOL isGrid;
    BOOL folder;
    
    MovepopVC *movepopvc;
    UIPopoverController *popcontroller;
    
    int currentGridPage;
    int totalPageCount;
    int currentProgress;
    int totalSizeProgress;
    
    int timerCounter;
    CGPoint originalCenter;
    UIButton *buttonSelectedToMove;
}

//////////////////////////
//      Synthesizers
//////////////////////////
@property (retain, nonatomic) NSString *currentPath;
@property (retain, nonatomic) NSMutableArray *ary_filelist;
@property (retain, nonatomic) NSMutableArray *ary_selectedfilelist;

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
//////////////////////////
//      Toolbar
//////////////////////////
@property (retain, nonatomic) IBOutlet UIView *vw_unedit;
@property (retain, nonatomic) IBOutlet UIView *vw_edit;

@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_sort;
@property (retain, nonatomic) IBOutlet UISegmentedControl *seg_mode;

@property (retain, nonatomic) IBOutlet UIButton *btn_delete;
@property (retain, nonatomic) IBOutlet UIButton *btn_selection;
@property (retain, nonatomic) IBOutlet UIButton *btn_zip;
@property (retain, nonatomic) IBOutlet UIButton *btn_move;
@property (retain, nonatomic) IBOutlet UIButton *btn_mail;
@property (retain, nonatomic) IBOutlet UIButton *btn_newfolder;
@property (retain, nonatomic) IBOutlet UIButton *btn_refresh;
@property (retain, nonatomic) IBOutlet UILabel *lbl_selectioncount;

@property (retain, nonatomic) IBOutlet UIButton *btn_back;
@property (retain, nonatomic) IBOutlet UIButton *btn_mode;

@property (retain, nonatomic) IBOutlet UILabel *lbl_back;
@property (retain, nonatomic) IBOutlet UILabel *lbl_heading;

@property (retain, nonatomic) IBOutlet UIScrollView *scrl_grid;
@property (retain, nonatomic) IBOutlet UITableView *tbl_files;

//////////////////////////
//      Action Methods
//////////////////////////
- (IBAction)btn_delete_pressed:(id)sender;
- (IBAction)btn_selection_pressed:(id)sender;
- (IBAction)btn_zip_pressed:(id)sender;
- (IBAction)btn_move_pressed:(id)sender;
- (IBAction)btn_mail_pressed:(id)sender;
- (IBAction)btn_newfolder_pressed:(id)sender;
- (IBAction)btn_refresh_pressed:(id)sender;

- (IBAction)btn_extraback_pressed:(id)sender;
- (IBAction)btn_back_pressed:(id)sender;
- (IBAction)btn_mode_pressed:(id)sender;

- (IBAction)seg_sort_pressed:(id)sender;
- (IBAction)seg_mode_pressed:(id)sender;
@end
