//
//  DLDirectoryTableViewController.h
//  DivyaLoka
//
//  Created by @playra on 28.03.14.
//  Copyright (c) 2014 @playra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"

@interface DLDirectoryTableViewController : UITableViewController <ReaderViewControllerDelegate>

- (id) initWithFolderPath:(NSString*) path;
///Users/playra/Desktop/Library

@end
