//
//  MapEditor.h
//  Awars III
//
//  Created by Killery on 2012/12/06.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChipView.h"
#import "SeedView.h"
#import "MapView.h"

struct _MAPSCRIPT0;

typedef struct _ENDGAMECONDITION{
    
    int endType1;
    int endType2;
    
    NSString *etValue1[64];
    NSString *etValue2[64];
    
}ENDGAMECONDITION;
typedef struct _MAPSCRIPT1{
    //文章スクリプト
    NSString *name;
    NSString *str;
    NSImage *img;
    NSString *iName;
    NSString *nameID;

}MAPSCRIPT1;

typedef struct _MAPSCRIPT2A{

    struct _MAPSCRIPT2A *next;
    
    struct _MAPSCRIPT0 *P;
    
}MAPSCRIPT2A;

typedef struct _MAPSCRIPT2{
    //文章選択肢スクリプト
    NSMutableArray *sel;
    struct _MAPSCRIPT2A *S;
    
}MAPSCRIPT2;

typedef struct _MAPSCRIPT0{
    struct _MAPSCRIPT0 *next;
    
    int type;
    struct _MAPSCRIPT1 S1;
    struct _MAPSCRIPT2 S2;
    int indent;
    
    int *switch1;
    int *switch2;
    
    int val;
    int valCnt;
    
    int timerMin;
    int timerSec;
    int timerEntire;
    bool timerFlag;
    bool timerVisible;
    bool timerRun;
    bool timerMode;
    
    UNITCHIP U;
    int unitAction;
    
    bool endFlag;
    
}MAPSCRIPT0;

typedef struct _MAPSCRIPTD{

    struct _MAPSCRIPTD *next;
    int index;
    int x;
    int y;
    int type;
    bool endFlag;
    
    int *switch1;
    int *switch2;
    bool switch1f;
    bool switch2f;
    struct _MAPSCRIPT0 *P;
    NSMutableArray *SCRPT;
    
}MAPSCRIPTD;

typedef struct _MAPSCRIPT{
    
    ENDGAMECONDITION EGClight;
    ENDGAMECONDITION EGCdark;
    
    int playerSet1;
    int playerSet2;
    bool battleSetMode;
    
    NSMutableArray *SCRPTname;
    struct _MAPSCRIPTD *D;
    
}MAPSCRIPT;

typedef struct _MAPFILE{

    NSString *fileName;

    MAPSCRIPT MS;

}MAPFILE;

typedef struct _EVENTIMAGE{

    struct _EVENTIMAGE *next;
    
    NSString *name;
    
    NSImage *img;

}EVENTIMAGE;

bool loadChipSideFlag;

MAPFILE MF[512];
ENDGAMECONDITION EGC[2];
EVENTIMAGE *EIMG;
EVENTIMAGE *EIMGtop;
NSString *CEIMG;
int EIMGN;

int MapChipMax;
int BuildChipMax;
int UnitChipMax;
int LoadChipMax;

int MapChipListIndex;
int BuildChipListIndex;
int UnitChipListIndex;
int LoadChipListIndex;

bool saveMapChipFlag;
bool loadMapChipFlag;
bool mapSizeChangedFlag;
bool initMapChipNumbFlag;
bool loadMapListSubmitFlag;
bool saveMapListSubmitFlag;

int postHeight;
int postWidth;

int MFselectedRow;
NSString *saveMapDataName;


bool EEGCslctFlag;
bool EEGCslctFlag2;
int EEGCslctCnt;
int etValueCnt;

int EDtextImageRow;

int EEGC1row;
int EEGC2row;

int eventListRow;

bool eventPosFlag;

NSInteger ELrow;
NSInteger EDrow;
int squareCnt;
bool editFlag;
bool insertFlag;

NSInteger EDselRow;

bool mapLoadFlagForMSD;
bool mapLoadFlagForMSD2;
MAPSCRIPTD *MSDTOPP;//一番もとの先頭
MAPSCRIPTD *MSDTOP;//一番先頭
MAPSCRIPTD *msdtop;//スクリプト上の先頭

bool Suicchi[9999];
bool SuicchiONOFFsentakuflag;
bool SuicchiSentakuflag;
int Hensuu[9999];

bool suicchiDBLslickFlag;
bool timerDBLslickFlag;

int *ichijihensuS1;

bool EDproceedFlag;

bool EQmodeFlag;

bool battleSetMode;
int playerSet1;
int playerSet2;
NSRect scCenter;
NSInteger headerFrame;

bool fuckingRetardedBtnPushed1;
@interface MapEditor : NSObject
{
    NSTimer *time0;
    
    IBOutlet NSImageView *topIV;
    IBOutlet NSTextField *topName;
    IBOutlet NSTextField *topHealth;
    
    IBOutlet NSButtonCell *EDSWON;
    IBOutlet NSButtonCell *EDSWOFF;
    IBOutlet NSTextField *EDSWTF;
    IBOutlet NSWindow *EDSwitchWindow2;
    
    
    IBOutlet NSTextField *TFcurrentChipIndex;
    
    IBOutlet NSPanel *PMCL;
    IBOutlet NSPanel *PBCL;
    IBOutlet NSPanel *PUCL;
    IBOutlet NSPanel *PLCL;
    
    IBOutlet NSWindow *MapEditorWindow;
    NSPoint windowPoint;
    
    IBOutlet NSWindow *TitleWindow;
    
    IBOutlet NSPanel *mapSizeWindow;
    IBOutlet NSTextField *mapSizeHeight;
    IBOutlet NSTextField *mapSizeWidth;
    
    
    IBOutlet NSPanel *loadMapWindow;
    NSMutableArray *loadMapListMA;
    IBOutlet NSArrayController *loadMapListAC;
    IBOutlet NSTableView *loadMapListTV;
    
    IBOutlet NSPanel *saveMapWindow;
    NSMutableArray *saveMapListMA;
    IBOutlet NSArrayController *saveMapListAC;
    IBOutlet NSTableView *saveMapListTV;
    IBOutlet NSTextField *saveMapTF;
    
    
    int fileNumb;
    
    
    IBOutlet NSWindow *eventWindow;
    NSMutableArray *eventListMA;
    IBOutlet NSArrayController *eventListAC;
    IBOutlet NSTableView *eventListTV;
    
    IBOutlet NSButton *eventCheckBtn;
    IBOutlet NSPopUpButton *eventPopupBtn;
    NSMutableArray *eventPosMA;
    IBOutlet NSArrayController *eventPosAC;
    IBOutlet NSTableView *eventPosTV;
    
    IBOutlet NSPopUpButton *eventPlayerSetPUB1;
    IBOutlet NSPopUpButton *eventPlayerSetPUB2;
    IBOutlet NSButton *eventBattleDetailBtn;
    
    
    IBOutlet NSWindow *eventEndGameCondition;
    IBOutlet NSPopUpButton *EPUB1;
    IBOutlet NSPopUpButton *EPUB2;
    NSMutableArray *EEGC1MA;
    IBOutlet NSArrayController *EEGC1AC;
    IBOutlet NSTableView *EEGC1TV;
    NSMutableArray *EEGC2MA;
    IBOutlet NSArrayController *EEGC2AC;
    IBOutlet NSTableView *EEGC2TV;
    
    IBOutlet NSTextField *EEGCstr;
    
    NSMutableArray *EEGC01MA;
    IBOutlet NSArrayController *EEGC01AC;
    IBOutlet NSTableView *EEGC01TV;
    IBOutlet NSTextField *EEGC01str;
    IBOutlet NSTextField *EEGC012str;
    
    NSMutableArray *EEGC02MA;
    IBOutlet NSArrayController *EEGC02AC;
    IBOutlet NSTableView *EEGC02TV;
    IBOutlet NSTextField *EEGC02str;
    IBOutlet NSTextField *EEGC022str;
    
    short EEGCflag;
    
    IBOutlet NSWindow *eventDetailWindow;
    NSMutableArray *eventDetailListMA;
    IBOutlet NSArrayController *eventDetailListAC;
    IBOutlet NSTableView *eventDetailListTV;
    
    NSMutableArray *EDswitch1MA;
    IBOutlet NSArrayController *EDswitch1AC;
    IBOutlet NSTableView *EDswitch1TV;
    
    NSMutableArray *EDswitch2MA;
    IBOutlet NSArrayController *EDswitch2AC;
    IBOutlet NSTableView *EDswitch2TV;
    
    NSMutableArray *EDvariableMA;
    IBOutlet NSArrayController *EDvariableAC;
    IBOutlet NSTableView *EDvariableTV;
    IBOutlet NSTextField *EDvariableTF;
    
    IBOutlet NSPopUpButton *EDitemPUB;
    IBOutlet NSPopUpButton *EDunitPUB;
    
    IBOutlet NSTextField *EDnameTF;
    IBOutlet NSButton *EDswitch1Btn;
    IBOutlet NSButton *EDswitch2Btn;
    IBOutlet NSButton *EDvariableBtn;
    IBOutlet NSButton *EDitemBtn;
    IBOutlet NSButton *EDunitBtn;
    
    IBOutlet NSWindow *eventDetailSelectionWindow;
    
    IBOutlet NSWindow *EDtextWindow;
    IBOutlet NSTextField *EDtextName;
    IBOutlet NSTextField *EDtextString;
    IBOutlet NSImageView *EDtextImage;
    
    IBOutlet NSWindow *EDtextImageWindow;
    NSMutableArray *EDtextImageMA;
    IBOutlet NSArrayController *EDtextImageAC;
    IBOutlet NSTableView *EDtextImageTV;
    IBOutlet NSButtonCell *EDtextImageButton1;
    IBOutlet NSButtonCell *EDtextImageButton2;
    IBOutlet NSButtonCell *EDtextImageButton3;
    NSInteger EDtextImageButtonValue;
    
    IBOutlet NSWindow *EDselectionWindow;
    NSMutableArray *EDselectionMA;
    IBOutlet NSArrayController *EDselectionAC;
    IBOutlet NSTableView *EDselectionTV;
    bool EDselectionEditing;
    
    IBOutlet NSWindow *EDvalueWindow;
    NSMutableArray *EDvalueMA;
    IBOutlet NSArrayController *EDvalueAC;
    IBOutlet NSTableView *EDvalueTV;
 
    
    IBOutlet NSWindow *EDswitchWindow;
    IBOutlet NSTextField *EDswitchTF;
    
    IBOutlet NSWindow *EDvarWindow;
    NSMutableArray *EDvarMA;
    IBOutlet NSArrayController *EDvarAC;
    IBOutlet NSTableView *EDvarTV;
    IBOutlet NSTextField *EDvarTF1;
    IBOutlet NSTextField *EDvarTF2;
    IBOutlet NSButtonCell *EDvarButtonT;
    IBOutlet NSButtonCell *EDvarButtonI;
    IBOutlet NSButtonCell *EDvarButton1;
    IBOutlet NSButtonCell *EDvarButton2;
    IBOutlet NSButtonCell *EDvarButton3;
    IBOutlet NSButtonCell *EDvarButton4;
    IBOutlet NSButtonCell *EDvarButton5;
    IBOutlet NSButtonCell *EDvarButton6;
    IBOutlet NSButtonCell *EDvarButtonA;
    IBOutlet NSButtonCell *EDvarButtonB;
    IBOutlet NSButtonCell *EDvarButtonC;
    IBOutlet NSButtonCell *EDvarButtonD;
    IBOutlet NSButtonCell *EDvarButtonE;
    IBOutlet NSButtonCell *EDvarButtonF;
    IBOutlet NSButtonCell *EDvarButtonG;
    IBOutlet NSTextField *EDvarTeisu;
    NSMutableArray *EDvarHensuMA;
    IBOutlet NSArrayController *EDvarHensuAC;
    IBOutlet NSTableView *EDvarHensuTV;
    IBOutlet NSTextField *EDvarRansu1;
    IBOutlet NSTextField *EDvarRansu2;
    IBOutlet NSPopUpButton *EDvarItem;
    IBOutlet NSPopUpButton *EDvarUnit1;
    IBOutlet NSPopUpButton *EDvarUnit2;
    IBOutlet NSPopUpButton *EDvarEtc;

    IBOutlet NSWindow *EDtimerWindow;
    IBOutlet NSButtonCell *EDtimerButton1;
    IBOutlet NSButtonCell *EDtimerButton2;
    IBOutlet NSTextField *EDtimerTF1;
    IBOutlet NSTextField *EDtimerTF2;
    
    IBOutlet NSWindow *EDtermsWindow;
    
    
    
    
    
    
    
    
    
    
    IBOutlet NSWindow *EDlabelWindow;
    IBOutlet NSTextField *EDlabelTF;
    
    IBOutlet NSWindow *EDlabelJumpWindow;
    IBOutlet NSTextField *EDlabelJumpTF;
    
    IBOutlet NSWindow *EDmemoWindow;
    IBOutlet NSTextField *EDmemoTF;
    
    IBOutlet NSWindow *EDresourceWindow;
    IBOutlet NSButton *EDresourceBtn1;
    IBOutlet NSButton *EDresourceBtn2;
    IBOutlet NSButton *EDresourceBtn3;
    IBOutlet NSButtonCell *EDresourceButton1;
    IBOutlet NSButtonCell *EDresourceButton2;
    IBOutlet NSButtonCell *EDresourceButtonA;
    IBOutlet NSButtonCell *EDresourceButtonB;
    IBOutlet NSTextField *EDresourceTF;
    NSMutableArray *EDresourceMA;
    IBOutlet NSArrayController *EDresourceAC;
    IBOutlet NSTableView *EDresourceTV;
    
    
    IBOutlet NSWindow *EDitemWindow;
    
    
    
    
    
    
    IBOutlet NSWindow *EDmemberWindow;
    
    
    
    
    
    
    IBOutlet NSWindow *EDhpWindow;
    IBOutlet NSButtonCell *EDhpButton1;
    IBOutlet NSButtonCell *EDhpButton2;
    IBOutlet NSButtonCell *EDhpButtonA;
    IBOutlet NSButtonCell *EDhpButtonB;
    IBOutlet NSTextField *EDhpTF;
    NSMutableArray *EDhp1MA;
    IBOutlet NSArrayController *EDhp1AC;
    IBOutlet NSTableView *EDhp1TV;
    NSMutableArray *EDhp2MA;
    IBOutlet NSArrayController *EDhp2AC;
    IBOutlet NSTableView *EDhp2TV;
    
    IBOutlet NSWindow *EDmpWindow;
    IBOutlet NSButtonCell *EDmpButton1;
    IBOutlet NSButtonCell *EDmpButton2;
    IBOutlet NSButtonCell *EDmpButtonA;
    IBOutlet NSButtonCell *EDmpButtonB;
    IBOutlet NSTextField *EDmpTF;
    NSMutableArray *EDmp1MA;
    IBOutlet NSArrayController *EDmp1AC;
    IBOutlet NSTableView *EDmp1TV;
    NSMutableArray *EDmp2MA;
    IBOutlet NSArrayController *EDmp2AC;
    IBOutlet NSTableView *EDmp2TV;
    
    IBOutlet NSWindow *EDstatus;
    IBOutlet NSPopUpButton *EDstpubA;
    IBOutlet NSButtonCell *EDstButtonA11;
    IBOutlet NSButtonCell *EDstButtonA12;
    IBOutlet NSButtonCell *EDstButtonA13;
    IBOutlet NSButtonCell *EDstButtonA21;
    IBOutlet NSButtonCell *EDstButtonA22;
    IBOutlet NSTextField *EDstTFA;
    NSMutableArray *EDstA1MA;
    IBOutlet NSArrayController *EDstA1AC;
    IBOutlet NSTableView *EDstA1TV;
    NSMutableArray *EDstA2MA;
    IBOutlet NSArrayController *EDstA2AC;
    IBOutlet NSTableView *EDstA2TV;
    
    IBOutlet NSPopUpButton *EDstpubB;
    IBOutlet NSButtonCell *EDstButtonB11;
    IBOutlet NSButtonCell *EDstButtonB12;
    IBOutlet NSButtonCell *EDstButtonB13;
    IBOutlet NSButtonCell *EDstButtonB21;
    IBOutlet NSButtonCell *EDstButtonB22;
    IBOutlet NSTextField *EDstTFB;
    NSMutableArray *EDstB1MA;
    IBOutlet NSArrayController *EDstB1AC;
    IBOutlet NSTableView *EDstB1TV;
    NSMutableArray *EDstB2MA;
    IBOutlet NSArrayController *EDstB2AC;
    IBOutlet NSTableView *EDstB2TV;
    
    IBOutlet NSButtonCell *EDTimerSet1A;
    IBOutlet NSButtonCell *EDTimerSet1B;
    IBOutlet NSButtonCell *EDTimerSet2A;
    IBOutlet NSButtonCell *EDTimerSet2B;
    IBOutlet NSButtonCell *EDTimerSet3A;
    IBOutlet NSButtonCell *EDTimerSet3B;
    IBOutlet NSTextField *EDTimerTF1;
    IBOutlet NSTextField *EDTimerTF2;
    
}

-(IBAction)EDSWOKbtn:(id)sender;
-(IBAction)EDSWCancelbtn:(id)sender;

-(IBAction)backTitle:(id)sender;

-(IBAction)backTitle:(id)sender;
-(IBAction)saveMap:(id)sender;
-(IBAction)loadMap:(id)sender;
-(IBAction)mapSize:(id)sender;
-(IBAction)setEvent:(id)sender;

-(IBAction)mapSizeSubmit:(id)sender;
-(IBAction)mapSizeCancel:(id)sender;

-(IBAction)loadMapSubmit:(id)sender;
-(IBAction)loadMapCancel:(id)sender;

-(IBAction)saveMapSubmit:(id)sender;
-(IBAction)saveMapCancel:(id)sender;

-(IBAction)previous:(id)sender;
-(IBAction)next:(id)sender;

-(IBAction)eventInsert:(id)sender;
-(IBAction)eventDelete:(id)sender;
-(IBAction)eventSubmit:(id)sender;

-(IBAction)EEGClight:(id)sender;
-(IBAction)EEGCdark:(id)sender;
-(IBAction)EEGC1insert:(id)sender;
-(IBAction)EEGC1delete:(id)sender;
-(IBAction)EEGC2insert:(id)sender;
-(IBAction)EEGC2delete:(id)sender;
-(IBAction)EEGCsubmit:(id)sender;
-(IBAction)EEGCcancel:(id)sender;
-(IBAction)EEGC1select:(id)sender;
-(IBAction)EEGC2select:(id)sender;


-(IBAction)eventCheckBtn:(id)sender;
-(IBAction)eventPopupBtn:(id)sender;

-(IBAction)EDclose:(id)sender;
-(IBAction)EDinsert:(id)sender;
-(IBAction)EDdelete:(id)sender;

-(IBAction)EDtext:(id)sender;
-(IBAction)EDselection:(id)sender;
-(IBAction)EDvalue:(id)sender;

-(IBAction)EDswitch:(id)sender;
-(IBAction)EDvariable:(id)sender;
-(IBAction)EDtimer:(id)sender;

-(IBAction)EDterms:(id)sender;
-(IBAction)EDlabel:(id)sender;
-(IBAction)EDlabelJump:(id)sender;
-(IBAction)EDmemo:(id)sender;

-(IBAction)EDresource:(id)sender;
-(IBAction)EDitem:(id)sender;
-(IBAction)EDmember:(id)sender;

-(IBAction)EDhp:(id)sender;
-(IBAction)EDmp:(id)sender;
-(IBAction)EDstatus:(id)sender;
-(IBAction)EDstate:(id)sender;
-(IBAction)EDskill:(id)sender;
-(IBAction)EDname:(id)sender;
-(IBAction)EDequip:(id)sender;
-(IBAction)EDattackFlagOn:(id)sender;

-(IBAction)EDmove:(id)sender;
-(IBAction)EDappear:(id)sender;
-(IBAction)EDdissapear:(id)sender;

-(IBAction)EDplace:(id)sender;
-(IBAction)EDwait:(id)sender;
-(IBAction)EDpilot:(id)sender;
-(IBAction)EDunit:(id)sender;
-(IBAction)EDbgm:(id)sender;
-(IBAction)EDbgmFadeOut:(id)sender;
-(IBAction)EDse:(id)sender;
-(IBAction)EDseStop:(id)sender;

-(IBAction)EDbattle:(id)sender;
-(IBAction)EDshop:(id)sender;
-(IBAction)EDnameInput:(id)sender;

-(IBAction)EDgameOver:(id)sender;
-(IBAction)EDstageClear:(id)sender;
-(IBAction)EDtitle:(id)sender;

-(IBAction)EDcancel:(id)sender;

-(IBAction)EDtextSubmit:(id)sender;
-(IBAction)EDtextCancel:(id)sender;
-(IBAction)EDtextImageSlct:(id)sender;

-(IBAction)EDtextImageSubmit:(id)sender;
-(IBAction)EDtextImageCancel:(id)sender;
-(IBAction)EDtextImageButton:(id)sender;

-(IBAction)EDselectionAdd:(id)sender;
-(IBAction)EDselectionDelete:(id)sender;
-(IBAction)EDselectionSubmit:(id)sender;
-(IBAction)EDselectionCancel:(id)sender;

-(IBAction)EDvalueSubmit:(id)sender;
-(IBAction)EDvalueCancel:(id)sender;

-(IBAction)EDswitchSubmit:(id)sender;
-(IBAction)EDswitchCancel:(id)sender;

-(IBAction)EDvariableSubmit:(id)sender;
-(IBAction)EDvariableCancel:(id)sender;

-(IBAction)EDtimerSubmit:(id)sender;
-(IBAction)EDtimerCancel:(id)sender;

-(IBAction)EDtermsSubmit:(id)sender;
-(IBAction)EDtermsCancel:(id)sender;

-(IBAction)EDlabelSubmit:(id)sender;
-(IBAction)EDlabelCancel:(id)sender;

-(IBAction)EDlabelJumpSubmit:(id)sender;
-(IBAction)EDlabelJumpCancel:(id)sender;

-(IBAction)EDmemoSubmit:(id)sender;
-(IBAction)EDmemoCancel:(id)sender;

-(IBAction)EDresourceSubmit:(id)sender;
-(IBAction)EDresourceCancel:(id)sender;

-(IBAction)EDhpSubmit:(id)sender;
-(IBAction)EDhpCancel:(id)sender;

-(IBAction)EDmpSubmit:(id)sender;
-(IBAction)EDmpCancel:(id)sender;

-(IBAction)EDstatusSubmit:(id)sender;
-(IBAction)EDstatusCancel:(id)sender;

-(IBAction)setBattleModeBtn:(id)sender;
-(IBAction)playerSetBtn1:(id)sender;
-(IBAction)playerSetBtn2:(id)sender;

-(IBAction)EDTimerSetBtn1:(id)sender;
-(IBAction)EDTimerSetBtn2:(id)sender;
-(IBAction)EDTimerSetBtn3:(id)sender;

@end
