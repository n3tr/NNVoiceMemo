//
//  VideoPlayerViewController.m
//  NNVoicePlayer
//
//  Created by n3tr on 6/1/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController ()
{
    MPMoviePlayerController *moviePlayer;
}

- (void)dismissView:(id)sender;

@end

@implementation VideoPlayerViewController
@synthesize filePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView:)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    // Do any additional setup after loading the view from its nib.
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    [moviePlayer setFullscreen:YES animated:NO];
    
    [moviePlayer.view setFrame:self.view.bounds];
    [self.view addSubview:moviePlayer.view];
    
    
//    [moviePlayer play];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)dismissView:(id)sender
{
    [moviePlayer stop];
    moviePlayer = nil;
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
