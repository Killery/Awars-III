//
//  BuildChipList.h
//  Awars III
//
//  Created by Killery on 2012/12/16.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapEditor.h"

typedef struct _RESEARCH{

    struct _RESEARCH *next;
    
    int type;
    int numb;
    int Lv;
    
    void *U;
    void *R;
    void *O;

}RESEARCH;

typedef struct _BSTATUS{
    int HP;
    int WT;
    int WTE;
    int WTN;
    NSString *name;
    
}BSTATUS;

typedef struct _BUILDCHIP{
    
    NSString *name;
    NSString *nameR;
    NSString *nameID;
    
    struct _RESEARCH *R;
    struct _BSTATUS S_C;
    struct _BSTATUS S_M;
    
    
    int dmgfix;
    int type;
    int defLv;
    
    int Csupply;
    int Cfood;
    int Cmoney;
    
    
    int CsupplyNext;
    int CfoodNext;
    int CmoneyNext;
    
    int Esupply;
    int Efood;
    int Emoney;
    
    
    int recHP;
    int recMP;
    int recEN;
    bool inroadsFlag;
    bool capture;
    NSString *linkDest;
    NSString *linkNext;
    
    
    NSString *iName;
    NSImage *img;
    
    NSString *iNameb;
    NSImage *imgb;
    
    
}BUILDCHIP;

BUILDCHIP BC[128];
RESEARCH *Rtop;

int BuildChipNum;

@interface BuildChipList : NSObject <NSTableViewDelegate>
{
    IBOutlet NSPanel* BCLPanel;
    IBOutlet NSPanel* BCLDetailPanel;
    IBOutlet NSPanel* BCLDetailOptionPanel;
    IBOutlet NSPanel* BCLUnitResearchPanel;
    IBOutlet NSPanel* BCLregisterPanel;
    NSPoint BCLDpoint;
    
    
    NSMutableArray *buildChipListMA;
    IBOutlet NSArrayController *buildChipListAC;
    IBOutlet NSTableView *buildChipListTV;
    
    NSArray *fileDataArray;
    NSInteger chipNumb;
    IBOutlet NSTextField* TFchipNumb;
    
    
    IBOutlet NSTextField *TFname;
    IBOutlet NSTextField *TFnameR;
    IBOutlet NSTextField *TFnameID;
    IBOutlet NSTextField *TFfix;
    IBOutlet NSTextField *TFWT;
    IBOutlet NSTextField *TFDLv;
    IBOutlet NSTextField *TFHP;
    IBOutlet NSTextField *TFRHP;
    IBOutlet NSTextField *TFRMP;
    IBOutlet NSTextField *TFREN;
    IBOutlet NSTextField *TFcostS;
    IBOutlet NSTextField *TFcostF;
    IBOutlet NSTextField *TFcostM;
    IBOutlet NSTextField *TFcostSn;
    IBOutlet NSTextField *TFcostFn;
    IBOutlet NSTextField *TFcostMn;
    IBOutlet NSTextField *TFcostSe;
    IBOutlet NSTextField *TFcostFe;
    IBOutlet NSTextField *TFcostMe;
    IBOutlet NSTextField *TFWTE;
    IBOutlet NSTextField *TFWTN;
    IBOutlet NSButton *BTNinroads;
    IBOutlet NSButton *BTNcapture;
    IBOutlet NSPopUpButton *PUPtype;
    IBOutlet NSPopUpButton *PUPlinkD;
    IBOutlet NSPopUpButton *PUPlinkN;
    IBOutlet NSImageView *IVimg;
    IBOutlet NSImageView *IVimgBig;
    
    IBOutlet NSPopUpButton *PUunit;
    IBOutlet NSPopUpButton *PUresearch;
    IBOutlet NSPopUpButton *PUunion;
    
    NSMutableArray *unitListPU;
    
    NSMutableArray *researchListMA;
    IBOutlet NSArrayController *researchListAC;
    IBOutlet NSTableView *researchListTV;
    
    int RLunitNumb;
    int RLresearchNumb;
    int RLunionNumb;
 
    int RLrow;
}
-(IBAction)submit:(id)sender;
- (NSMutableArray*)buildChipListMA;

-(IBAction)saveBCL:(id)sender;
-(IBAction)cancelBCL:(id)sender;
-(IBAction)optionBCL:(id)sender;
-(IBAction)optionCloseBCL:(id)sender;
-(IBAction)unitResearchBCL:(id)sender;
-(IBAction)unitResearchCloseBCL:(id)sender;

-(IBAction)registBCL:(id)sender;
-(IBAction)registSaveBCL:(id)sender;
-(IBAction)registCancelBCL:(id)sender;

-(IBAction)researchListUnitInsert:(id)sender;
-(IBAction)researchListResearchInsert:(id)sender;
-(IBAction)researchListUnionInsert:(id)sender;

-(IBAction)researchListDelete:(id)sender;

@end
