//
//  ViewController.m
//  NNVoicePlayer
//
//  Created by n3tr on 5/30/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import "ViewController.h"
#import "AudioPlayerCell.h"
#import "NoteComposerViewController.h"
#import "VoiceRecorderViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "NNItem.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    AVAudioPlayer *audioPlayer;
    NSInteger playingAudioAtIndex;
    BOOL isPause;
    AudioPlayerCell *playingCell;
    NSTimer *loopTimer;
    
}

- (void)updateSlider;
- (void)skipAudioToSecond:(float)position;
- (void)addNewNote:(id)sender;
- (void)addNewVoice:(id)sender;

@end

@implementation ViewController
@synthesize _audioCell;
@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;




- (void)viewDidLoad
{
    [super viewDidLoad];    
    _dataSource = [[NSMutableArray alloc] init];
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = appDel.managedObjectContext;
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    if ([[[_fetchedResultsController sections] objectAtIndex:0] numberOfObjects] == 0) {
        NNItem *item1 = [NSEntityDescription insertNewObjectForEntityForName:@"NNItem" inManagedObjectContext:_managedObjectContext];
        item1.title = @"Dance";
        item1.type = @"voice";
        item1.created_date = [NSDate date];
        item1.filePath = [[NSBundle mainBundle ] pathForResource:@"dance.mp3" ofType:nil];
        [appDel saveContext];
        
        NNItem *item2 = [NSEntityDescription insertNewObjectForEntityForName:@"NNItem" inManagedObjectContext:_managedObjectContext];
        item2.title = @"Dance";
        item2.type = @"voice";
        item2.created_date = [NSDate date];
        item2.filePath = [[NSBundle mainBundle ] pathForResource:@"openlove.mp3" ofType:nil];
        [appDel saveContext];
        
        NNItem *item3 = [NSEntityDescription insertNewObjectForEntityForName:@"NNItem" inManagedObjectContext:_managedObjectContext];
        item3.title = @"Dance";
        item3.type = @"voice";
        item3.created_date = [NSDate date];
        item3.filePath = [[NSBundle mainBundle ] pathForResource:@"bossa1.mp3" ofType:nil];
        [appDel saveContext];
    }
    
    
    // negative playing index
    playingAudioAtIndex = -1;
    
    // bar button
    UIBarButtonItem *composeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addNewNote:)];
    
    UIBarButtonItem *voicBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(addNewVoice:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:composeBtn,voicBtn, nil];

}

- (void)viewDidUnload
{
    [self set_audioCell:nil];
    [self setTableView:nil];
    [_dataSource removeAllObjects];
    _dataSource = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *audioCellID = @"AudioCell";
	static NSString *noteCellID = @"NoteCell";
    
    NNItem *item = [_fetchedResultsController objectAtIndexPath:indexPath];
    if ([item.type isEqualToString:@"note"]) {
        
        UITableViewCell *cell =(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:noteCellID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noteCellID];
        }
        
        cell.textLabel.text = item.title;
        
        return cell;
        
    } else {
	
    
        if (playingAudioAtIndex == -1 || playingAudioAtIndex != indexPath.row) { // normal cell
            
            AudioPlayerCell *cell = (AudioPlayerCell*)[tableView dequeueReusableCellWithIdentifier:audioCellID]; // changed this
            
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"AudioPlayerCell" owner:self options:nil];
                cell = _audioCell;
                _audioCell = nil;
            }
            cell.sliderTiming.enabled = NO;
            cell.rowNumber = indexPath.row;
            cell.delegate = self;
            return cell;
            
        } else { // current playing cell
            return playingCell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NNItem *item = [_fetchedResultsController objectAtIndexPath:indexPath];
    if ([item.type isEqualToString:@"note"]) {
        NoteComposerViewController *noteVC = [[NoteComposerViewController alloc] initWithNibName:@"NoteComposerViewController" bundle:nil];
        noteVC.item = item;
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:noteVC];
        
        [navVC setModalPresentationStyle:UIModalPresentationFormSheet];
        
        
        [self.navigationController presentModalViewController:navVC animated:YES];
        navVC = nil;
        noteVC = nil; 
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)audioCellPlayButtonDidClickedInRowNumber:(NSInteger)rowNum
{
    NSLog(@"Play at Index:%d", rowNum);
    
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum inSection:0];
    NNItem *item = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSString *path = item.filePath;
    
    
    NSLog(@"%@",path);
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) { // file must be exist
        
        if (!audioPlayer) { // Check if no audio exist 
            
            // create audio
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
            audioPlayer.delegate = self;
            
        
            // config cell
            playingCell = (AudioPlayerCell*)[_tableView cellForRowAtIndexPath:indexPath];
            playingCell.sliderTiming.maximumValue = audioPlayer.duration;
            playingCell.sliderTiming.minimumValue = 0;
            playingCell.sliderTiming.value = 0;
            playingCell.sliderTiming.enabled = YES;
            
            // playing index
            playingAudioAtIndex = rowNum;
            
            // loop slider
            loopTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
            
            [[NSRunLoop currentRunLoop] addTimer:loopTimer forMode:@"NSDefaultRunLoopMode"];
        
            // play
            [audioPlayer play];
            
        } else { // audio is playing or pause
            
            if (rowNum != playingAudioAtIndex) {
                
                // if click on anothor sound, stop first
                [self stopAudioPlayer];
                
                // create new audio
                audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
                audioPlayer.delegate = self;
                
                // config cell
                playingCell = (AudioPlayerCell*)[_tableView cellForRowAtIndexPath:indexPath];
                playingCell.sliderTiming.maximumValue = audioPlayer.duration;
                playingCell.sliderTiming.minimumValue = 0;
                playingCell.sliderTiming.value = 0;
                playingCell.sliderTiming.enabled = YES;
                
                // set playing index
                playingAudioAtIndex = rowNum;
                
                // loop slide
                loopTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
                
                [[NSRunLoop currentRunLoop] addTimer:loopTimer forMode:@"NSDefaultRunLoopMode"];
                
                // play
                [audioPlayer play];
                
            } else { // audio is playing then tap on play button
                
                if (audioPlayer.playing) { // playing -> pause
                    [audioPlayer pause];
                } else{ // pause -> resume
                    [audioPlayer prepareToPlay];
                    [audioPlayer play];
                }
               
            }

        }
        
    }
    
}

- (void)audioCellStopButtonDidClickedInRowNumber:(NSInteger)rowNum
{
    NSLog(@"Stop at Index:%d", rowNum);
    if (playingAudioAtIndex == rowNum) {
        [self stopAudioPlayer];
    }
}

- (void)stopAudioPlayer
{
    if (audioPlayer) {
        [audioPlayer stop];
        [loopTimer invalidate];
        audioPlayer = nil;
        playingCell.sliderTiming.value = 0;
        playingCell.sliderTiming.enabled = NO;
        playingCell = nil;
        playingAudioAtIndex = -1;
    }
}

- (void)updateSlider
{
    playingCell.sliderTiming.value = audioPlayer.currentTime;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopAudioPlayer];
}

- (void)audioCellStartScrollInRowNumber:(NSInteger)rowNum
{
    if (rowNum == playingAudioAtIndex) {
        [loopTimer invalidate];
        loopTimer = nil;
    }   
}

- (void)audioCellSliderInRowNumber:(NSInteger)rowNum DidMoveTo:(float)value
{
    if (rowNum == playingAudioAtIndex) {
        [self skipAudioToSecond:value];
        
        loopTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:loopTimer forMode:@"NSDefaultRunLoopMode"];    
    }
}

- (void) skipAudioToSecond:(float)position
{
    
    @synchronized(self) 
    {
        // Negative values skip to start of file
        if ( position<0.0f )
            position = 0.0f;
        
        // Rounds down to remove sub-second precision
        position = (int)position;
        
        // Prevent skipping past end of file
        if ( position>=(int)audioPlayer.duration )
        {
            NSLog( @"Audio: IGNORING skip to <%.02f> (past EOF) of <%.02f> seconds", position, audioPlayer.duration );
            return;
        }
        
        // See if playback is active prior to skipping
        BOOL skipWhilePlaying = audioPlayer.playing;
        
        // Perform skip
        NSLog( @"Audio: skip to <%.02f> of <%.02f> seconds", position, audioPlayer.duration );
        
        // NOTE: This stop,set,prepare,(play) sequence produces reliable results on the simulator and device.
        [audioPlayer stop];
        [audioPlayer setCurrentTime:position];
        [audioPlayer prepareToPlay];
        
        // Resume playback if it was active prior to skipping
        if ( skipWhilePlaying )
            [audioPlayer play];
    }
}


- (void)addNewNote:(id)sender
{
    
    NoteComposerViewController *noteVC = [[NoteComposerViewController alloc] initWithNibName:@"NoteComposerViewController" bundle:nil];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:noteVC];
    
    [navVC setModalPresentationStyle:UIModalPresentationFormSheet];
    
    
    [self.navigationController presentModalViewController:navVC animated:YES];
    navVC = nil;
    noteVC = nil;
}

- (void)addNewVoice:(id)sender
{
    VoiceRecorderViewController *voiceVC = [[VoiceRecorderViewController alloc] initWithNibName:@"VoiceRecorderViewController" bundle:nil];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:voiceVC];
    
    [navVC setModalPresentationStyle:UIModalPresentationFormSheet];
    
    
    [self.navigationController presentModalViewController:navVC animated:YES];
    navVC = nil;
    voiceVC = nil;
}


#pragma mark - fetch

#pragma mark - Fetched Result Delegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"NNItem" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"created_date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//    [self.tableView endUpdates];
    [_tableView reloadData];
}





@end
