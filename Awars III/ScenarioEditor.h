//
//  ScenarioEditor.h
//  Awars III
//
//  Created by Killery on 2013/01/28.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StringText.h"

typedef struct _STAND{
    struct _STAND *next;
    struct _BASE *B;
    
    NSString *name;
    NSString *fName;
    int index;
    int registerNum;
}STAND;

typedef struct _BASE{
    struct _BASE *next;
    int index;
    struct _LAYER *L;
    
    NSString *name;
    NSString *iName;
    NSImage *img;
    int prefer;
    
    int x;
    int y;
}BASE;

typedef struct _LAYER{
    struct _LAYER *next;
    int index;

    NSString *name;
    NSString *iName;
    NSImage *img;
    int prefer;
    bool visible;

    int x;
    int y;
}LAYER;


typedef struct _TEXT{
    
    NSString *fileName;
    
    struct _STRING *S;
    
}TEXT;

TEXT TX[255];

STAND *I;
STAND *Itop;
BASE *IBtop;
LAYER *IBLtop;

int Irow;
int IBrow;
int IBLrow;

int LLrow;

@interface ScenarioEditor : NSObject
{
    NSTimer *time;
    
    IBOutlet NSWindow *scenarioEditorWindow;
    IBOutlet NSWindow *titleWindow;
    
    NSMutableArray *textListMA;
    IBOutlet NSArrayController *textListAC;
    IBOutlet NSTableView *textListTV;
    
    NSMutableArray *lineListMA;
    IBOutlet NSArrayController *lineListAC;
    IBOutlet NSTableView *lineListTV;
    
    NSInteger textNumb;
    NSInteger listNumb;
    NSInteger st;
    NSInteger sl;
    NSArray *fileDataArray;
    
    
    struct _STRING *STRtop[255];
    
    IBOutlet NSTextField *Dname;
    IBOutlet NSTextField *Dstring;
    
    IBOutlet NSTextField *dialogName;
    IBOutlet NSTextField *dialogString;
    IBOutlet NSImageView *dialogImage;

    bool OMFGflag;
    
    NSMutableArray *standListMA;
    IBOutlet NSArrayController *standListAC;
    IBOutlet NSTableView *standListTV;
    
    NSMutableArray *baseListMA;
    IBOutlet NSArrayController *baseListAC;
    IBOutlet NSTableView *baseListTV;
    NSDictionary *baseListDC;
    
    NSMutableArray *layerListMA;
    IBOutlet NSArrayController *layerListAC;
    IBOutlet NSTableView *layerListTV;
    
    
    IBOutlet NSPanel *standPanel;
    IBOutlet NSPanel *standEditorPanel;
    
    IBOutlet NSTextField *TFposX;
    IBOutlet NSTextField *TFposY;
    
    IBOutlet NSImageView *NSIV;
    IBOutlet NSImageView *NSIV2;
}

-(IBAction)titleBtn:(id)sender;
-(IBAction)detailBtn:(id)sender;
-(IBAction)standBtn:(id)sender;
-(IBAction)saveLineData:(id)sender;

-(IBAction)insertLineStand:(id)sender;
-(IBAction)removeLineStand:(id)sender;
-(IBAction)backStand:(id)sender;

-(IBAction)insertLineBase:(id)sender;
-(IBAction)removeLineBase:(id)sender;
-(IBAction)insertLineLayer:(id)sender;
-(IBAction)removeLineLayer:(id)sender;
-(IBAction)submitStand:(id)sender;

-(IBAction)insertLine:(id)sender;
-(IBAction)removeLine:(id)sender;

-(IBAction)stringData:(id)sender;










@end
