//
//  Gallery.h
//  Awars III
//
//  Created by Killery on 2013/01/09.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _GALLERY{

    struct _GALLERY *next;
    NSString *nameTop;
    NSString *name;
    NSImage *img;
    bool Hscene;
    bool background;
    
    struct _GALLERY *sabun;

}GALLERY;

GALLERY *G[255];
GALLERY *GTop[255];

NSInteger GAclrow;

@interface Gallery : NSObject
{
    NSTimer *timer;
    
    IBOutlet NSWindow *titleWindow;
    IBOutlet NSWindow *galleryWindow;
    
    NSPoint Gpoint;
    
    NSMutableArray *galleryListMA;
    IBOutlet NSArrayController *galleryListAC;
    IBOutlet NSTableView *galleryListTV;
    
    NSArray *fileDataArray;
    
    
    IBOutlet NSImageView *IV01;
    IBOutlet NSImageView *IV02;
    IBOutlet NSImageView *IV03;
    IBOutlet NSImageView *IV04;
    IBOutlet NSImageView *IV05;
    IBOutlet NSImageView *IV06;
    IBOutlet NSImageView *IV07;
    IBOutlet NSImageView *IV08;
    IBOutlet NSImageView *IV09;
    IBOutlet NSImageView *IV10;
    IBOutlet NSImageView *IV11;
    IBOutlet NSImageView *IV12;
    
    IBOutlet NSMatrix *RB;
    
    IBOutlet NSTextField *TF;
    int galleryMax;
    int galleryNumb;

}

-(IBAction)backButton:(id)sender;
-(IBAction)radioButton:(id)sender;

-(IBAction)previous:(id)sender;
-(IBAction)next:(id)sender;


@end
