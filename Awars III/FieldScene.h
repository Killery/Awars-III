//
//  FieldScene.h
//  Awars III
//
//  Created by Killery on 2013/02/22.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapView.h"
#import "FieldView.h"
#import "MapChipList.h"
#import "BuildChipList.h"
#import "UnitChipList.h"
#import "EventScene.h"
#import "MapEditor.h"

typedef struct _UNIT{
    struct _UNIT *next;
    struct _UNITCHIP C;
    struct _LOADCHIP CL;
    bool CPU;
    int number;
    int team;
    int chipNumber;
    int chipNumberL;
    
    int x;
    int y;
    int z;
    
    NSImage *img;
    
    bool loadChipFlag;
    
    bool dead;
    NSString *army;
    bool unControlable;
    bool joinArmyFromNext;
    bool persuasion;
    int atkRange;
    
    bool targType1L;
    bool targType2L;
    bool targType1D;
    bool targType2D;
    
}UNIT;

typedef struct _UNION{
    
    
    
}UNION;

typedef struct _BUILD{
    struct _BUILD *next;
    struct _BUILDCHIP C;
    int number;
    int team;
    int chipNumber;
    int makeLv;
    
    int x;
    int y;
    int z;
    
    NSImage *img;
    
    bool dead;
    

}BUILD;


typedef struct _PLAYER{
    
    NSString *name;
    int type;
    
    int resource;
    int food;
    int money;
    
    int base;
    int unit;
    
    UNIT *U;

}PLAYER;

PLAYER P[10];

UNIT *U;
UNIT *U2;
int AUN[255];
int DUN[255];
int messageProcess;

int targType1cnt[2];
int targType2cnt[2];
bool targType2Lflag;
bool targType2Dflag;

int placeVL[64];
int placeVD[64];

BUILD *B;
BUILD *BTop;

NSPoint menuPoint;
bool menuDisplayFlag;
bool initStatusFlag;

bool bLoopFlag;
int crCAL;
int crCAL1;
int crCAL2;
bool dcRdy;

int crCRL;

int crBCL;
bool bclRdy;

int crCSL;
bool cslRdy;
UNITCHIP CSLUC;
UNIT *CSLU;
UNIT *CSLUorigin;

bool battleRdy;
bool pushStanbyFlag;

UNITCHIP *BRU;
int BRUindex;

bool wtRdy;
bool wtRdyB;
int wtPx, wtPy, wtUnitNum;
UNIT *unitBreak;
bool wtMovedFlag;
bool wtAttackedFlag;

bool battleBegin;

int TeamCount0;
int TeamCount2;
bool TeamCountFlag;

bool endGameCondition;
bool blueWinFlag;
bool redWinFlag;

bool battleDef1Flag;
bool battleDef2Flag;
bool battleDod1Flag;
bool battleDod2Flag;
bool battleSet1Flag;
bool battleSet2Flag;
bool battleSet2PushedFlag;
bool battleSettingFlag;

bool cIncludeCreateFlag;
bool cIncludeSummonFlag;

bool initMapEventFlag;
bool messageDialog;
int msgLvl;
int msgCnt;
int msgMax;
int msgLvlMax;
bool initImgFlag;
int MSDnum;
bool initStringNum;
bool messageSwitchFlag1;
bool bugFixFlag1;
bool bugFixFlag2;
bool bugFixFlag3;

bool messageEndFlag;

bool SwitchONflag;
bool SwitchOFFflag;

int mostNumSub;
bool cpuAImodeflag;

UNIT *UTop;

bool retardhelp1;
bool retardhelp2;
bool battleReadyUpFlag;

@interface FieldScene : NSObject
{
    NSTimer *time;
    
    
    IBOutlet NSTextField *battleReadyUpPN1;
    IBOutlet NSTextField *battleReadyUpPN2;
    IBOutlet NSTextField *battleReadyUpRule;
    IBOutlet NSButtonCell *battleReadyUpMAN1A;
    IBOutlet NSButtonCell *battleReadyUpMAN1B;
    IBOutlet NSButtonCell *battleReadyUpMAN2A;
    IBOutlet NSButtonCell *battleReadyUpMAN2B;
    IBOutlet NSTextField *battleReadyUpSupply1;
    IBOutlet NSTextField *battleReadyUpFood1;
    IBOutlet NSTextField *battleReadyUpMoney1;
    IBOutlet NSTextField *battleReadyUpSupply2;
    IBOutlet NSTextField *battleReadyUpFood2;
    IBOutlet NSTextField *battleReadyUpMoney2;
    IBOutlet NSTextField *battleReadyUpLeader1;
    IBOutlet NSTextField *battleReadyUpLeader2;
    IBOutlet NSImageView *battleReadyUpIV1;
    IBOutlet NSImageView *battleReadyUpIV2;
    IBOutlet NSWindow *bsWindow;
    
    IBOutlet NSImageView *selectMesh;
    IBOutlet NSTextField *selectMeshText;
    IBOutlet NSTextField *selectMeshValue;
    IBOutlet NSImageView *selectChara;
    
    IBOutlet NSWindow *mapWindow;
    
    IBOutlet NSPanel *menuPanel;
    IBOutlet NSButton *TFmove;
    IBOutlet NSButton *TFattack;
    IBOutlet NSButton *TFstandby;
    IBOutlet NSButton *TFcreate;
    IBOutlet NSButton *TFstatus;
    IBOutlet NSButton *TFcancel;
    
    IBOutlet NSPanel *menuPanel2;
    IBOutlet NSButton *TFstatus2;
    IBOutlet NSButton *TFcancel2;
    
    
    NSMutableArray *CAttackListMA;
    IBOutlet NSArrayController *CAttackListAC;
    IBOutlet NSTableView *CAttackListTV;
    
    IBOutlet NSPanel *atkPanel;
    NSPoint windowPoint;
    
    NSMutableArray *BCreateListMA;
    IBOutlet NSArrayController *BCreateListAC;
    IBOutlet NSTableView *BCreateListTV;
    
    IBOutlet NSPanel *createPanel;
    
    NSMutableArray *CSummonListMA;
    IBOutlet NSArrayController *CSummonListAC;
    IBOutlet NSTableView *CSummonListTV;
    
    IBOutlet NSPanel *summonPanel;
    
    IBOutlet NSTextField *bullet;
    IBOutlet NSTextField *costP;
    IBOutlet NSTextField *costV;
    IBOutlet NSTextField *region;
    IBOutlet NSTextField *crytical;
    IBOutlet NSTextField *atkProperty;
    
    IBOutlet NSTextField *HPbarTF;
    IBOutlet NSLevelIndicator *HPbarLI;
    IBOutlet NSTextField *MPbarTF;
    
    
    IBOutlet NSWindow *battleWindow;
    IBOutlet NSImageView *bplayer1;
    IBOutlet NSImageView *bplayer2;
    IBOutlet NSTextField *nplayer1;
    IBOutlet NSTextField *nplayer2;
    IBOutlet NSTextField *tplayer1;
    IBOutlet NSTextField *tplayer2;
    IBOutlet NSLevelIndicator *lplayer1;
    IBOutlet NSLevelIndicator *lplayer2;
    IBOutlet NSTextField *mplayer1;
    IBOutlet NSTextField *mplayer2;
    IBOutlet NSImageView *iplayer1;
    IBOutlet NSImageView *iplayer2;
    IBOutlet NSTextField *rplayer1;
    IBOutlet NSTextField *rplayer2;
    IBOutlet NSTextField *hplayer1;
    IBOutlet NSTextField *hplayer2;
    IBOutlet NSTextField *battleDialog;
    IBOutlet NSButton *battleCancelBtn;
    IBOutlet NSButton *battleAttackBtn1;
    IBOutlet NSButton *battleAttackBtn2;
    IBOutlet NSButton *battleGuardBtn1;
    IBOutlet NSButton *battleGuardBtn2;
    IBOutlet NSButton *battleDodgeBtn1;
    IBOutlet NSButton *battleDodgeBtn2;
    IBOutlet NSButton *battleStartBtn;
    
    IBOutlet NSTextField *tfAttack;
    IBOutlet NSTextField *tfDefence;
    IBOutlet NSTextField *tfCalc;
    IBOutlet NSTextField *tfHit;
    IBOutlet NSTextField *tfDodge;
    IBOutlet NSTextField *tfMove;
    IBOutlet NSTextField *tfWait;
    
    IBOutlet NSTextField *tfName;
    IBOutlet NSTextField *tfArmy;
    IBOutlet NSTextField *tfResource;
    IBOutlet NSTextField *tfFood;
    IBOutlet NSTextField *tfMoney;
    
    IBOutlet NSPanel *battlePanel;
    IBOutlet NSTextField *combatNAME1;
    IBOutlet NSTextField *combatNAME2;
    IBOutlet NSTextField *combatHP1;
    IBOutlet NSTextField *combatHP2;
    IBOutlet NSTextField *combatMP1;
    IBOutlet NSTextField *combatMP2;
    IBOutlet NSLevelIndicator *combatLHP1;
    IBOutlet NSLevelIndicator *combatLHP2;
    IBOutlet NSLevelIndicator *combatLMP1;
    IBOutlet NSLevelIndicator *combatLMP2;
    IBOutlet NSTextField *combatHIT1;
    IBOutlet NSTextField *combatHIT2;
    IBOutlet NSTextField *combatVIG1;
    IBOutlet NSTextField *combatVIG2;
    IBOutlet NSTextField *combatAP1;
    IBOutlet NSTextField *combatAP2;
    IBOutlet NSTextField *combatATK1;
    IBOutlet NSTextField *combatATK2;
    
    IBOutlet NSPanel *researchPanel;
    IBOutlet NSTextField *researchATK;
    IBOutlet NSTextField *researchDEF;
    IBOutlet NSTextField *researchCAP;
    IBOutlet NSTextField *researchACU;
    IBOutlet NSTextField *researchEVA;
    IBOutlet NSTextField *researchMOV;
    IBOutlet NSImageView *researchIMG;
    
    NSMutableArray *CResearchListMA;
    IBOutlet NSArrayController *CResearchListAC;
    IBOutlet NSTableView *CResearchListTV;
    
    ATTACK *U2A;
    double dmg;
    double hit;
    double hitFix;
    double mapDmgFix;
    double costMP;
    bool healFlag;
    double graze;
    bool grazeFlag;
    
    IBOutlet NSWindow *esWindow;
    IBOutlet NSWindow *fsWindow;
    IBOutlet NSPanel *endGamePanel;
    IBOutlet NSTextField *endGameText;
    
    IBOutlet NSPanel *commandPanel;
    IBOutlet NSButton *moveBtn;
    IBOutlet NSButton *attackBtn;
    IBOutlet NSButton *stanbyBtn;
    IBOutlet NSButton *createBtn;
    IBOutlet NSButton *summonBtn;
    IBOutlet NSButton *statusBtn;
    IBOutlet NSButton *cancelBtn;
    
    bool buildSkillFlag;
    bool summonSkillFlag;
    
    IBOutlet NSImageView *IVimage;
    IBOutlet NSTextField *TFmessage;
    IBOutlet NSTextField *TFname;
    IBOutlet NSBox *BXmessage;
    IBOutlet NSBox *BXname;


}

-(IBAction)battleReadyUpStartBtn:(id)sender;
-(IBAction)battleReadyUpState1:(id)sender;
-(IBAction)battleReadyUpState2:(id)sender;

-(IBAction)pushMove:(id)sender;
-(IBAction)pushAttack:(id)sender;
-(IBAction)pushStandby:(id)sender;
-(IBAction)pushCreate:(id)sender;
-(IBAction)pushSummon:(id)sender;
-(IBAction)pushStatus:(id)sender;
-(IBAction)pushCancel:(id)sender;

-(IBAction)battleStart:(id)sender;
-(IBAction)battleSet1:(id)sender;
-(IBAction)battleDef1:(id)sender;
-(IBAction)battleDod1:(id)sender;
-(IBAction)battleSet2:(id)sender;
-(IBAction)battleDef2:(id)sender;
-(IBAction)battleDod2:(id)sender;
-(IBAction)battleCancel:(id)sender;

-(IBAction)pushCancelCAL:(id)sender;
-(IBAction)pushCancelBCL:(id)sender;
-(IBAction)pushCancelCSL:(id)sender;

-(IBAction)researchCancel:(id)sender;

@end
