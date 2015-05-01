//
//  StringText.h
//  Awars III
//
//  Created by Killery on 2012/12/31.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventScene.h"
#import "ScenarioList.h"

typedef struct _SVALUE{
    struct _SVALUE *next;
    NSString *slct;
    NSString *jump;
    NSString *fName;

}SVALUE;

typedef struct _NVALUE{
    struct _NVALUE *next;
    NSString *title;
    NSString *value;
    NSString *key;
    
}NVALUE;

typedef struct _STRING{
    
    int index;
    NSString *name;
    NSString *string;
    
    
    NSImage *img;
    NSString *iName;//##
    
    NSImage *imgStand;
    NSString *iNameStand;//$$
    int standPossition;
    int standWidth;
    int standHeight;
    
    NSImage *imgWall;
    NSString *iNameWall;//%%
    
    NSString *jumpName;//@@
    NSString *labelName;//&&
    NSString *namingName;//≠≠
    
    struct _NVALUE *N;//≠≠
    struct _SVALUE *S;//**
    
    NSMutableArray *selectionName;//**
    
    NSMutableArray *flagName;//¥¥
    
    bool wallFadeIn;
    bool wallFadeOut;
    bool wallChanged;
    
    struct _STRING *next;
}STRING;

STRING *ST;

bool mouseClicked;
bool mouseDowned;
bool mouseHolding;

@interface StringText : NSObject
{
    NSTimer *timer;
    
    NSArray *fileDataArray;
    
    IBOutlet NSTextField *TFCname;
    IBOutlet NSTextField *TFdialog;
    IBOutlet NSImageView *IVface;
    IBOutlet NSImageView *IVwall;
    IBOutlet NSImageView *IVbackGround;
    
    STRING *STtop;
    int dialogLengh;
    int dialogNumber;
    int dialogMax;
}

-(void)AddString:(STRING**)top:(int)no;

-(void)InitStringList;
@end



