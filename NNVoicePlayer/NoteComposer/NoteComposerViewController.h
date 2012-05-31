//
//  NoteComposerViewController.h
//  NNVoicePlayer
//
//  Created by n3tr on 5/31/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NNItem;
@interface NoteComposerViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *noteCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *titleCell;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (nonatomic, retain) NNItem *item;

@end
