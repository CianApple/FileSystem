//
//  N4FileTreeCellView.h
//  Accordion
//
//  Created by Ignacio Enriquez Gutierrez on 8/28/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import <Foundation/Foundation.h>

typedef enum{
	CellTypeFile,
	CellTypeDirectory
}CellType;


@interface ViewCell : UITableViewCell {

@private
	IBOutlet UIImageView *directoryAccessoryImageView;
	CellType cellType;
	BOOL expanded;
}

@property (nonatomic) CellType cellType;
@property (nonatomic, getter=isExpanded) BOOL expanded;
@property (nonatomic, retain) IBOutlet UIImageView *directoryAccessoryImageView;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
