//
//  MovepopVC.h
//  FileSystem
//
//  Created by Admins on 1/19/13.
//  Copyright (c) 2013 Softweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatasourceManager.h"
#import "SorterViewController.h"

@protocol MovepopViewControllerDelegate <NSObject>
-(void)moveFilesToNewFolder:(NSString *)newPath;
@end

@class MovepopVC;
@class DetailViewController;
@class DatasourceManager;
@class N4PromptAlertView;



@interface MovepopVC : UIViewController <DatasourceManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, SorterViewControllerDelegate>{
    NSString *currentPath;
    NSMutableArray *newArray;
    IBOutlet UITableView *tableView;
    id<MovepopViewControllerDelegate> delegate;

    DatasourceManager *datasourceManager;
	NSMutableArray *sortDescriptors;
	UIPopoverController *sorterPopoverController;
	UIPopoverController *fileCreatorPopoverController;
    IBOutlet UINavigationBar *navigationBar;

	UIAlertView *createFileAlert;
	UIAlertView *createDirectoryAlert;
	UIAlertView *duplicateFileAlert;
    NSString *StrMovePath;

}
@property(nonatomic,assign)	id<MovepopViewControllerDelegate> delegate;
@property (nonatomic, retain) DatasourceManager *dataManager;
@property (nonatomic, retain) NSMutableArray *sortDescriptors;
//@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;
@property(nonatomic,copy)NSString *StrMovePath;



- (IBAction) showSortingMenu:(id)sender;
- (IBAction)MoveButtonClick:(id)sender;

@end
