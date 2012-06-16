//
//  NNItem.h
//  NNVoicePlayer
//
//  Created by n3tr on 5/31/55 BE.
//  Copyright (c) 2555 Simpletail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NNItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * textBody;
@property (nonatomic, retain) NSString * type;

- (void)removeAccsosiateFile;

@end
