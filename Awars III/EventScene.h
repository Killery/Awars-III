//
//  EventScene.h
//  Awars III
//
//  Created by Killery on 2013/02/18.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringText.h"
#import "MapView.h"
#import "MapEditor.h"

bool evMouseClicked;
bool evMouseDowned;
bool evMouseHolding;

bool evActive;
bool evActiveEnd;
int evDialogMax;

bool evInitMap;

struct _STRING *evSTtop;

bool startES;

bool startOrEndFlag;

int dialogLengh;
int dialogNumber;

bool jumpFlag;
NSString *jumpName;
bool mapInitFlag;
bool stringInitFlag;
bool namingFlag;
NSString *namingName;
bool selectionFlag;

bool setBattleModeFlag;

struct _SVALUE *Slists;
struct _SVALUE *SlistsTop;

@interface EventScene : NSObject
{
    NSTimer *timer;
    
    NSArray *fileDataArray;
    
    IBOutlet NSTextField *nameTF;
    IBOutlet NSTextField *dialogTF;
    IBOutlet NSImageView *faceIV;
    IBOutlet NSImageView *backIV;
    IBOutlet NSImageView *wallIV;
    
    IBOutlet NSWindow *esWindow;
    IBOutlet NSWindow *fsWindow;
    IBOutlet NSWindow *titleWindow;
    IBOutlet NSWindow *bsWindow;

    IBOutlet NSWindow *selectionDialog;
    IBOutlet NSTextField *selectionTF;
    IBOutlet NSWindow *trueSelectionDialog;
    
    IBOutlet NSButton *BTN1;
    IBOutlet NSButton *BTN2;
    IBOutlet NSButton *BTN3;
    IBOutlet NSButton *BTN4;
    IBOutlet NSButton *BTN5;
    IBOutlet NSButton *BTN6;
    IBOutlet NSButton *BTN7;
    IBOutlet NSButton *BTN8;
    IBOutlet NSButton *BTN9;
}

-(IBAction)selectionSubmit:(id)sender;
-(IBAction)btn1:(id)sender;
-(IBAction)btn2:(id)sender;
-(IBAction)btn3:(id)sender;
-(IBAction)btn4:(id)sender;
-(IBAction)btn5:(id)sender;
-(IBAction)btn6:(id)sender;
-(IBAction)btn7:(id)sender;
-(IBAction)btn8:(id)sender;
-(IBAction)btn9:(id)sender;


@end
