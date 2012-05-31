//
//  NoteComposerViewController.m
//  NNVoicePlayer
//
//  Created by n3tr on 5/31/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import "NoteComposerViewController.h"
#import "NNItem.h"
#import "AppDelegate.h"

@interface NoteComposerViewController ()
{
    BOOL newEntry;
}
- (void)saveNote:(id)sender;
- (void)dismissCompose:(id)sender;

- (BOOL)validateNote;

@end


@implementation NoteComposerViewController
@synthesize tableView = _tableView;
@synthesize noteCell = _noteCell;
@synthesize titleCell = _titleCell;
@synthesize titleTextField = _titleTextField;
@synthesize noteTextView = _noteTextView;
@synthesize item = _item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if (!_item) {
        [_titleTextField becomeFirstResponder];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNote:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissCompose:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    newEntry = _item ? NO : YES;
    if (!newEntry) {
        _titleTextField.text = _item.title;
        _noteTextView.text = _item.textBody;
    }
    
    _titleTextField.returnKeyType = UIReturnKeyNext;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _titleTextField) {
        [_noteTextView becomeFirstResponder];
    }
    return YES;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setTitleCell:nil];
    [self setTitleTextField:nil];
    [self setNoteCell:nil];
    [self setNoteTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - TableVieww


#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 44 : 640;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0) {
        return _titleCell;
    } else {
        return _noteCell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)saveNote:(id)sender
{
    NSString *titleText = _titleTextField.text;
    if ([[titleText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0) {
        
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (newEntry) {
            NNItem *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"NNItem" inManagedObjectContext:appDel.managedObjectContext];
            newItem.created_date = [NSDate date];
            newItem.type = @"note";
            newItem.title = titleText;
            newItem.textBody = _noteTextView.text;
        } else {
            _item.title = titleText;
            _item.textBody = _noteTextView.text;
        }
        
        [appDel saveContext];
        [self.navigationController dismissModalViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title cannot be blank" message:nil delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)dismissCompose:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end
