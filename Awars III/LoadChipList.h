//
//  LoadChipList.h
//  Awars III
//
//  Created by Killery on 2014/01/14.
//  Copyright (c) 2014年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapEditor.h"
#import "UnitChipList.h"

typedef struct _STATUS2{

    double HP;
    double EN;
    double WT;
    
    int MOV;
    double ARM;
    double MOB;
    double LIM;
    
    short size;//T:極小 S:人型サイズ B:乗り物サイズ H:建物サイズ G:巨人サイズ M:モビールスーツサイズ L：戦艦サイズ LL：大戦艦サイズ E：移動基地サイズ I：大陸サイズ
    short typeMOVE;
    short loadCnt;
    
    int cSupply;
    int cFood;
    int cMoney;
    int cWT;
    
}STATUS2;

typedef struct _LOADCHIP{
    
    struct _RESIST R_C;
    struct _RESIST R_M;
    struct _ATTACK *A;
    
    NSString *name;
    NSString *nameRecognition;
    NSString *nameID;
    
    struct _STATUS2 S_C;
    struct _STATUS2 S_M;
    
    NSString *iName;
    NSImage *img;
    
    NSString *iNameb;
    NSImage *imgb;
    
    int chipNumb;
    
    NSString *aName;
    int attackListNum;
    
}LOADCHIP;

LOADCHIP LC[4096];

int LCN;

int LoadChipNum;

NSInteger cil;

@interface LoadChipList : NSObject
{
    NSTimer *LCLtime;
    IBOutlet NSPanel* LCLPanel;
    IBOutlet NSPanel* LCLDetailPanel;
    IBOutlet NSPanel* LCLRegisterPanel;

    NSMutableArray *loadChipListMA;
    IBOutlet NSArrayController *loadChipListAC;
    IBOutlet NSTableView *loadChipListTV;
    
    IBOutlet NSTextField *TFname;
    IBOutlet NSTextField *TFnameR;
    IBOutlet NSTextField *TFnameID;
    
    IBOutlet NSTextField *TFhp;
    IBOutlet NSTextField *TFen;
    IBOutlet NSTextField *TFwt;

    IBOutlet NSTextField *TFmov;
    IBOutlet NSTextField *TFarm;
    IBOutlet NSTextField *TFmob;
    IBOutlet NSTextField *TFlim;
    
    IBOutlet NSTextField *TFcSupply;
    IBOutlet NSTextField *TFcFood;
    IBOutlet NSTextField *TFcMoney;
    IBOutlet NSTextField *TFcWT;

    IBOutlet NSTextField *TFloadCount;
    IBOutlet NSPopUpButton *PUPtMove;
    IBOutlet NSPopUpButton *PUPtEquip;
    IBOutlet NSPopUpButton *PUPtSize;
    
    IBOutlet NSImageView *IVimg;
    IBOutlet NSImageView *IVimgb;
    
    NSArray *fileDataArray;
    NSInteger chipNumb;
    IBOutlet NSTextField *TFchipNumb;

    IBOutlet NSPanel *commandListPanel;
    IBOutlet NSPanel *attackListPanel;
    IBOutlet NSPanel *attackEditPanel;
    
    IBOutlet NSTextField *ALTFname;
    IBOutlet NSTextField *ALTFrangeA;
    IBOutlet NSTextField *ALTFrangeB;
    IBOutlet NSTextField *ALTFextend;
    IBOutlet NSPopUpButton *ALPUBcost;
    IBOutlet NSPopUpButton *ALPUBwType;
    IBOutlet NSTextField *ALTFcost;
    IBOutlet NSTextField *ALTFcostP;
    
    IBOutlet NSTextField *ALTFbullet;
    IBOutlet NSTextField *ALTFhitCount;
    IBOutlet NSTextField *ALTFsuccessRate;
    IBOutlet NSTextField *ALTFvigor;
    IBOutlet NSTextField *ALTFhitRate;
    
    IBOutlet NSButton *ALTFtrigger;
    IBOutlet NSButton *ALTFmelee;
    IBOutlet NSButton *ALTFpass;
    IBOutlet NSButton *ALTFdmgExtent;
    
    IBOutlet NSPopUpButton *ALPUBriku;
    IBOutlet NSPopUpButton *ALPUBchu;
    IBOutlet NSPopUpButton *ALPUBumi;
    IBOutlet NSPopUpButton *ALPUBsora;
    
    IBOutlet NSTextField *ALTFcSupply;
    IBOutlet NSTextField *ALTFcFood;
    IBOutlet NSTextField *ALTFcMoney;
    IBOutlet NSTextField *ALTFcmd;
    IBOutlet NSTextField *ALTFmsg;
    
    IBOutlet NSTextField *ALTFrate;
    IBOutlet NSTextField *ALTFhit;
    IBOutlet NSTextField *ALTFatkHit;
    
    IBOutlet NSPopUpButton *ALPUBtype;
    IBOutlet NSPopUpButton *ALPUBseed;
    IBOutlet NSPopUpButton *ALPUBsort;
    IBOutlet NSTextField *ALTFdmgCount;
    IBOutlet NSTextField *ALTFdmgRate;
    
    IBOutlet NSButton *ALTFcontinuum;
    IBOutlet NSButton *ALTFabsolute;
    IBOutlet NSButton *ALTFbeam;
    IBOutlet NSButton *ALTFnoSizeFix;

}



-(IBAction)submit:(id)sender;

-(IBAction)saveLCL:(id)sender;
-(IBAction)cancelLCL:(id)sender;

-(IBAction)registLCL:(id)sender;
-(IBAction)registSaveLCL:(id)sender;
-(IBAction)registCancelLCL:(id)sender;

@end
