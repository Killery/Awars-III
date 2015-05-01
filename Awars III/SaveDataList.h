//
//  SaveDataList.h
//  Awars III
//
//  Created by Killery on 2013/01/09.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _SAVEDATALIST{
    NSString *name;
    
    NSImage *img;
    NSString *iName;
}SAVEDATALIST;

SAVEDATALIST SDL[1024];


@interface SaveDataList : NSObject
{
    NSTimer *time;
    IBOutlet NSWindow *titleWindow;
    
    IBOutlet NSPanel* SDLPanel;
    NSPoint SDLPpoint;
    
    NSMutableArray *saveListMA;
    IBOutlet NSArrayController *saveListAC;
    
    IBOutlet NSImageView *IVsave;
    
    NSArray *fileDataArray;
    NSInteger saveNumb;
    
    int SDCarray;
}

-(IBAction)loadButton:(id)sender;
-(IBAction)backButton:(id)sender;
@end
