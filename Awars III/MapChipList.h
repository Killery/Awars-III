//
//  MapChipList.h
//  Awars III
//
//  Created by Killery on 2012/12/15.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapEditor.h"

typedef struct _MAPCHIP{

    NSString *name;
    int dmgfix;
    int riku;
    int umi;
    int chu;
    int sora;
    int type;
    
    NSString *iName;
    NSImage *img;


}MAPCHIP;

MAPCHIP MC[128];

@interface MapChipList : NSObject <NSTableViewDelegate>
{
    NSTimer *MCLtime;
    IBOutlet NSPanel* MCLPanel;
    IBOutlet NSPanel* MCLDetailPanel;
    IBOutlet NSPanel* MCLregistPanel;
    NSPoint MCLDpoint;
    
    IBOutlet NSTextField* TFchipNumb;
    
    NSMutableArray *mapChipListMA;
    IBOutlet NSArrayController *mapChipListAC;
    IBOutlet NSTableView *mapChipListTV;
    
    NSArray *fileDataArray;
    NSInteger chipNumb;
    
    IBOutlet NSTextField *TFname;
    IBOutlet NSTextField *TFfix;
    IBOutlet NSTextField *TFriku;
    IBOutlet NSTextField *TFumi;
    IBOutlet NSTextField *TFchu;
    IBOutlet NSTextField *TFsora;
    IBOutlet NSPopUpButton *TFtype;
    IBOutlet NSImageView *IVimg;
    
}
-(IBAction)submitMCL:(id)sender;
- (NSMutableArray*)mapChipListMA;

-(IBAction)saveMCL:(id)sender;
-(IBAction)cancelMCL:(id)sender;

-(IBAction)registMCL:(id)sender;
-(IBAction)registSaveMCL:(id)sender;
-(IBAction)registCancelMCL:(id)sender;

@end
