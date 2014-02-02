//
//  N4FileSorterViewController.h
//  MandalaChart
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 8/24/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import <UIKit/UIKit.h>

@class SorterViewController;
@protocol SorterViewControllerDelegate
@required 	
- (void) fileSorterViewController:(SorterViewController *)filerSorterViewController didUpdateDataSource:(NSMutableArray*)datasource;
@end


@interface SorterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
@private
	NSMutableArray *descriptorsDatasource;
	id <SorterViewControllerDelegate> sorterDelegate;
	UITableView *tableView;
}
@property (nonatomic, retain) NSMutableArray *descriptorsDatasource;
@property (nonatomic, assign) id <SorterViewControllerDelegate> sorterDelegate;
@end
