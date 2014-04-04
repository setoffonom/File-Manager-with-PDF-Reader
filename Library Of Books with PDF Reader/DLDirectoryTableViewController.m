//
//  DLDirectoryTableViewController.m
//  DivyaLoka
//
//  Created by @playra on 28.03.14.
//  Copyright (c) 2014 @playra. All rights reserved.
//

#import "DLDirectoryTableViewController.h"

@interface DLDirectoryTableViewController ()

@property (strong, nonatomic) NSString* pathProperty;
@property (strong, nonatomic) NSArray *contents;
@property (strong, nonatomic) NSString *selectedPath;
@property (strong, nonatomic) NSMutableArray *sectionsArrayProperty;
@property (strong, nonatomic) NSArray* namesArrayOfsectionInSearch;

@end

@implementation DLDirectoryTableViewController


- (id) initWithFolderPath:(NSString*) path

{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.pathProperty = path;

    }
    return self;
}


- (void) setPathProperty:(NSString *)pathProperty
{
    _pathProperty = pathProperty;

    NSArray* allContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathProperty error:nil];
    NSMutableArray *removeDS_Store = [NSMutableArray array];
    for (NSString *subpath in allContents) {
        if ( ![[subpath lastPathComponent] hasPrefix:@"."] &&
            ![[subpath lastPathComponent] isEqualToString:@"Icons"] &&
            ![[subpath lastPathComponent] isEqualToString:@"Root.plist"] &&
            ![[subpath lastPathComponent] isEqualToString:@"en.lproj"])
        {
            [removeDS_Store addObject:[pathProperty stringByAppendingPathComponent:subpath]];
        }
    }

    self.contents = removeDS_Store;
    [self.tableView reloadData];
    self.navigationItem.title = [[self.pathProperty lastPathComponent] stringByDeletingPathExtension];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.pathProperty)
    {

        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Collection Of Books" ofType:@"bundle"];
        self.pathProperty = bundlePath;
   
    }

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    


        UIBarButtonItem* rightButton = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Home"
                                 style:UIBarButtonItemStylePlain
                                 target:self action:@selector(actionBackToRoot:)];
        
        [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Trebuchet MS" size:18], NSFontAttributeName,
                                      [UIColor colorWithRed:56.0/255.0 green:56.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = rightButton;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
   
    // Dispose of any resources that can be recreated.
}

- (BOOL) isDirectoryAtIndexPath:(NSIndexPath*) indexPath
{
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];

    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:&isDirectory];
    return isDirectory;
}

#pragma mark - Actions

- (void) actionBackToRoot:(UIBarButtonItem*) sender
{
    NSArray *viewControllers = [[self navigationController] viewControllers];
    for( int i=0; i < [viewControllers count]; i++ )
    {
        id obj = [viewControllers objectAtIndex: i ];
        if([obj isKindOfClass:[DLDirectoryTableViewController class]]){
            [[self navigationController] popToViewController:obj animated:YES];
            return;
        }
    }
    
}

- (IBAction)backButtonItem:(UIBarButtonItem *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.contents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        NSString* theFileName = [[fileName lastPathComponent] stringByDeletingPathExtension];
        cell.textLabel.text = theFileName;

    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDirectoryAtIndexPath:indexPath])
    {
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        self.selectedPath = fileName;
        [self performSegueWithIdentifier:@"navigateDeep" sender:nil];
    }
    else
    {
        NSString *fileNamePdf = [self.contents objectAtIndex:indexPath.row];
        NSString* theFileName = [[fileNamePdf lastPathComponent] stringByDeletingPathExtension];
        NSString *filePathPdf = [[NSBundle mainBundle] pathForResource:theFileName ofType:@"pdf"];
         ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePathPdf password:nil];
        if (document != nil)
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self;
            readerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:readerViewController animated:YES completion:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DLDirectoryTableViewController *dLDirectoryTableViewController = segue.destinationViewController;
    dLDirectoryTableViewController.pathProperty = self.selectedPath;
}


- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
