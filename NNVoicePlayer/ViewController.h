//
//  ViewController.h
//  NNVoicePlayer
//
//  Created by n3tr on 5/30/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AudioPlayerCell.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
<AudioPlayerCellDelegate,
UITableViewDataSource,
UITableViewDelegate,
AVAudioPlayerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet AudioPlayerCell *_audioCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSMutableArray *dataSource;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;




@end
