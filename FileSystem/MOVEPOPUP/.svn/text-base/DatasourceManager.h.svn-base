//
//  N4FileAccordionDatasourceManager.h
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/27/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import <UIKit/UIKit.h>

@class N4File;
@class DatasourceManager;
@protocol DatasourceManagerDelegate <NSObject>
@required
- (void) fileAccordionDatasourceManager:(DatasourceManager *) manager didInsertRowsAtIndexPaths:(NSArray *)indexPaths;
- (void) fileAccordionDatasourceManager:(DatasourceManager *) manager didRemoveRowsAtIndexPaths:(NSArray *)indexPaths;
- (void) fileAccordionDatasourceManager:(DatasourceManager *) manager didCreateSuccessfullyFile:(N4File *)file;
- (void) fileAccordionDatasourceManager:(DatasourceManager *) manager didFailOnCreationofFile:(N4File *) file error:(NSError *)error;


@end


@interface DatasourceManager : NSObject {
	
	NSMutableArray *_sortDescriptors;
	NSMutableArray *_mergedRootBranch;
	NSMutableDictionary *_unmergedBranches;
	id<DatasourceManagerDelegate> delegate;
	N4File *rootDirectory;
}

@property (nonatomic, retain) NSMutableArray *sortDescriptors;
@property (nonatomic, retain, readonly) NSMutableArray * mergedRootBranch;
@property (nonatomic, assign) id<DatasourceManagerDelegate> delegate;

+ (NSMutableArray *) defaultSortDescriptors;
- (id) initWithRootPath:(NSString *)path sortDescriptors:(NSMutableArray *)sortDescs;
- (void) sort;

- (void) expandBranchAtIndex:(NSInteger)index;
- (void) collapseBranchAtIndex:(NSInteger)index;

- (void) moveFileFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

- (void) deleteFileAtIndex:(NSInteger)index;

- (void) createDirectoryAtIndex:(NSInteger)index withName:(NSString *)fileName;
- (void) createFileAtIndex:(NSInteger)index withName:(NSString *)fileName;
- (void) duplicateFileAtIndex:(NSInteger)index withName:(NSString *)fileName;




@end
