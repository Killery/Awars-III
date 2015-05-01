//
//  UnitChipList.h
//  Awars III
//
//  Created by Killery on 2012/12/17.
//  Copyright (c) 2012年 Killery. All rights reserved.
//


typedef struct _RESIST{

    int blow;
    int slash;
    int stub;
    int arrow;
    int gun;
    int shell;
    
    int flame;
    int cold;
    int electoric;
    int air;
    int water;
    int gas;
    int holy;
    int dark;
    int explosion;
    int blood;
    
    int paralysis;
    int confusion;
    int poison;
    int sleep;
    int charm;
    int silent;
    
    
}RESIST;

typedef struct _DAMAGE{
    
    int index;
    struct _DAMAGE *next;
    
    int type;//攻撃力とか
    double count;
    double pCount;
    
    RESIST R;
    int seed;//属性
    int sort;//ダメージとか回復とか
    
    bool continium;
    bool absolute;
    bool beam;
    bool noSizeFix;

}DAMAGE;

typedef struct _DMGEXTEND{

    int index;
    struct _DMGEXTEND *next;
    
    int rate;
    int hit;
    int atkHit;
    
}DMGEXTEND;

typedef struct _ATTACK{

    int index;
    struct _ATTACK *next;
    
    DAMAGE *D;
    double totalD;
    
    DMGEXTEND *E;
    
    NSString *name;
    NSString *nameID;
    
    int rangeA;
    int rangeB;
    int rangeAB;
    int extent;
    
    int costType;
    
    double MP;
    double AP;
    double HP;
    double EN;
    
    int pMP;
    int pAP;
    int pHP;
    int pEN;
    
    int bullet;
    int bulletC;
    int hitCount;
    int successRate;
    int vigor;
    int hitPercent;
    
    int type;
    bool trig;
    bool melee;
    bool P;
    bool dmgExtend;
    
    int cSupply;
    int cFood;
    int cMoney;
    
    int riku;//A120% B100% C60% D20% E0% S150% SS200%の補正値
    int chu;
    int umi;
    int sora;
    
    NSString *cmd;
    NSString *msg;
    
}ATTACK;

typedef struct _EQUIP{
    NSString *name;
    NSString *nameRecognition;
    NSString *nameID;
    
    ATTACK *A;
    int attackListNum;
    
    double Weight;
    double price;
    
    double HP;
    double MP;
    double AP;
    double WT;
    double BP;
    
    double STR;
    double VIT;
    double AGI;
    double DEX;
    double MEN;
    double INT;
    double LUK;
    
    int pSTR;
    int pVIT;
    int pAGI;
    int pDEX;
    int pMEN;
    int pINT;
    int pLUK;
    
    int MOV;
    int type;
    
    double recHP;
    int recpHP;
    double recMP;
    int recpMP;
    
    NSString *comment;
    
    RESIST R;
    
}EQUIP;

typedef struct _COMMANDS{
    
    struct _COMMANDS *next;
    NSString *cmd;
    int waza;
    NSString *hasei;
    

}COMMANDS;

typedef struct _COMBO{
    
    struct _COMBO *next;
    NSString *mbo;

}COMBO;

typedef struct _COMMAND{

    int A;
    int B;
    int C;
    int D;
    
    COMMANDS *cs;
    COMBO *co;

}COMMAND;

typedef struct _STATUS{

    double HP;
    double MP;
    double AP;
    double WT;
    double BP;

    double STR;
    double VIT;
    double AGI;
    double DEX;
    double MEN;
    double INT;
    double LUK;
    
    double MEL;
    double MIS;
    double HIT;
    double DOD;
    double REA;
    double SKI;

    int MOV;
    int typeMONS;
    int typeMOVE;
    
    double ATK;
    double DEF;
    double CAP;
    double ACU;
    double EVA;

    int cSupply;
    int cFood;
    int cMoney;
    int cWT;
    
    int vigor;

}STATUS;

typedef struct _SKILL{
    struct _SKILL *next;
    
    int index;
    int type;
    
    int list[255];
    double cost[255];
    int Lv[255];


}SKILL;

typedef struct _UNITCHIP{
    
    RESIST R_C;
    RESIST R_M;
    ATTACK *A;
    SKILL *S;
    
    NSString *name;
    NSString *nameNick;
    NSString *nameClass;
    NSString *nameRecognition;
    NSString *nameID;
    bool aura;
    
    struct _STATUS S_C;
    struct _STATUS S_M;
    
    NSString *iName;
    NSImage *img;
    
    NSString *iNameb;
    NSImage *imgb;
    
    int chipNumb;
    
    EQUIP eHead;
    EQUIP eHandL;
    EQUIP eHandR;
    EQUIP eBody;
    EQUIP eArm;
    EQUIP eFoot;
    
    bool eHandLflag;
    bool eHandRflag;
    bool eHandLRflag;
    bool eHeadflag;
    bool eBodyflag;
    bool eArmflag;
    bool eFootflag;
    
    NSString *aName;
    int attackListNum;
    
    COMMAND CM;
    
    
    struct _UNITCHIP *E;//装備の総値
    struct _UNITCHIP *N;//現在値に使用
    
}UNITCHIP;

typedef struct _SKILLLIST{
    struct _SKILLLIST *next;
    
    NSString *name;
    NSString *nameID;
    NSString *explain;
    
    int type;
    
    int build[128];
    int unit[128];
}SKILLLIST;

#import <Foundation/Foundation.h>
#import "MapEditor.h"


UNITCHIP UC[4096];

EQUIP EQ[4096];
EQUIP nilEquip;

NSInteger eItemNum;

SKILLLIST *SKL, *SKLtop;
int SKLrow;
int SKLBrow;
int SKLUrow;

SKILL *Stop;

int UCN;

int UnitChipNum;

@interface UnitChipList : NSObject
{
    NSTimer *UCLtime;
    IBOutlet NSPanel* UCLPanel;
    IBOutlet NSPanel* UCLDetailPanel;
    IBOutlet NSPanel* UCLRegisterPanel;
    NSPoint UCLDpoint;
    
    
    NSMutableArray *unitChipListMA;
    IBOutlet NSArrayController *unitChipListAC;
    IBOutlet NSTableView *unitChipListTV;
    
    NSMutableArray *equipItemMA;
    IBOutlet NSArrayController *equipItemAC;
    IBOutlet NSTableView *equipItemTV;
    NSInteger pubEquipItemIndex;
    
    NSArray *fileDataArray;
    NSInteger chipNumb;
    NSInteger itemNumb;
    NSInteger comboItemNumb;
    IBOutlet NSTextField* TFchipNumb;
    
    IBOutlet NSPanel* UCLPanelSkill;
    IBOutlet NSPanel* UCLPanelAttack;
    IBOutlet NSPanel* UCLPanelRegist;
    NSPoint windowPoint;
    
    IBOutlet NSPanel* UCLPanelAttackDetail;
    IBOutlet NSPanel* UCLPanelAttackList;
    
    IBOutlet NSPanel* UCLPanelEquipList;
    IBOutlet NSPanel* UCLPanelSkillList;
    
    IBOutlet NSPanel* UCLPanelEquipDetail;
    IBOutlet NSPanel* UCLPanelSkillDetail;
    
    NSMutableArray *attackListMA;
    IBOutlet NSArrayController *attackListAC;
    IBOutlet NSTableView *attackListTV;
    
    NSMutableArray *damageListMA;
    IBOutlet NSArrayController *damageListAC;
    IBOutlet NSTableView *damageListTV;
    
    NSMutableArray *hitListMA;
    IBOutlet NSArrayController *hitListAC;
    IBOutlet NSTableView *hitListTV;
    
    NSMutableArray *equipListMA;
    IBOutlet NSArrayController *equipListAC;
    IBOutlet NSTableView *equipListTV;
    
    NSMutableArray *skillListMA;
    IBOutlet NSArrayController *skillListAC;
    IBOutlet NSTableView *skillListTV;
    IBOutlet NSPopUpButton *PUBsl;
    
    NSMutableArray *skillListBuildMA;
    IBOutlet NSArrayController *skillListBuildAC;
    IBOutlet NSTableView *skillListBuildTV;
    
    NSMutableArray *skillListUnitMA;
    IBOutlet NSArrayController *skillListUnitAC;
    IBOutlet NSTableView *skillListUnitTV;
    
    IBOutlet NSPanel* SLBpanel;
    IBOutlet NSPanel* SLUpanel;
    
    IBOutlet NSTextField *TFname;
    IBOutlet NSTextField *TFnameN;
    IBOutlet NSTextField *TFnameR;
    IBOutlet NSTextField *TFnameID;
    IBOutlet NSTextField *TFnameC;
    
    IBOutlet NSButton *Baura;
    
    IBOutlet NSTextField *TFhp;
    IBOutlet NSTextField *TFmp;
    IBOutlet NSTextField *TFap;
    IBOutlet NSTextField *TFwt;
    
    IBOutlet NSTextField *TFbp;
    IBOutlet NSTextField *TFatk;
    IBOutlet NSTextField *TFdef;
    IBOutlet NSTextField *TFcap;
    IBOutlet NSTextField *TFacu;
    IBOutlet NSTextField *TFeva;
    
    IBOutlet NSTextField *TFstr;
    IBOutlet NSTextField *TFvit;
    IBOutlet NSTextField *TFagi;
    IBOutlet NSTextField *TFdex;
    IBOutlet NSTextField *TFmen;
    IBOutlet NSTextField *TFint;
    IBOutlet NSTextField *TFluk;
    IBOutlet NSTextField *TFmov;
    
    IBOutlet NSTextField *TFmel;
    IBOutlet NSTextField *TFmis;
    IBOutlet NSTextField *TFhit;
    IBOutlet NSTextField *TFdod;
    IBOutlet NSTextField *TFrea;
    IBOutlet NSTextField *TFski;

    IBOutlet NSTextField *TFcSupply;
    IBOutlet NSTextField *TFcFood;
    IBOutlet NSTextField *TFcMoney;
    IBOutlet NSTextField *TFcWT;
    
    IBOutlet NSPopUpButton *PUPtMons;
    IBOutlet NSPopUpButton *PUPtMove;
    IBOutlet NSPopUpButton *PUPtEquip;
    
    IBOutlet NSImageView *IVimg;
    IBOutlet NSImageView *IVimgBig;
    
    
    IBOutlet NSWindow *ILregiWIndow;
    IBOutlet NSTextField *ILregiTF;
    
    IBOutlet NSTextField *ILTFname;
    IBOutlet NSTextField *ILTFnameR;
    IBOutlet NSTextField *ILTFnameID;
    
    IBOutlet NSTextField *ILTFweight;
    IBOutlet NSTextField *ILTFprice;
    IBOutlet NSTextField *ILTFMOV;
    IBOutlet NSTextField *ILTFHP;
    IBOutlet NSTextField *ILTFMP;
    IBOutlet NSTextField *ILTFAP;
    IBOutlet NSTextField *ILTFWT;
    
    IBOutlet NSTextField *ILTFSTR;
    IBOutlet NSTextField *ILTFVIT;
    IBOutlet NSTextField *ILTFAGI;
    IBOutlet NSTextField *ILTFDEX;
    IBOutlet NSTextField *ILTFMEN;
    IBOutlet NSTextField *ILTFINT;
    IBOutlet NSTextField *ILTFLUK;
    
    IBOutlet NSTextField *ILTFpSTR;
    IBOutlet NSTextField *ILTFpVIT;
    IBOutlet NSTextField *ILTFpAGI;
    IBOutlet NSTextField *ILTFpDEX;
    IBOutlet NSTextField *ILTFpMEN;
    IBOutlet NSTextField *ILTFpINT;
    IBOutlet NSTextField *ILTFpLUK;
    
    IBOutlet NSTextField *ILTFblow;
    IBOutlet NSTextField *ILTFslash;
    IBOutlet NSTextField *ILTFstub;
    IBOutlet NSTextField *ILTFarrow;
    IBOutlet NSTextField *ILTFgun;
    IBOutlet NSTextField *ILTFshell;
    IBOutlet NSTextField *ILTFparalysis;
    IBOutlet NSTextField *ILTFpoison;
    IBOutlet NSTextField *ILTFcharm;
    IBOutlet NSTextField *ILTFconfusion;
    IBOutlet NSTextField *ILTFsleep;
    IBOutlet NSTextField *ILTFsilent;
    
    IBOutlet NSTextField *ILTFflame;
    IBOutlet NSTextField *ILTFcold;
    IBOutlet NSTextField *ILTFelectoric;
    IBOutlet NSTextField *ILTFair;
    IBOutlet NSTextField *ILTFwater;
    IBOutlet NSTextField *ILTFgas;
    IBOutlet NSTextField *ILTFholy;
    IBOutlet NSTextField *ILTFdark;
    IBOutlet NSTextField *ILTFexplosion;
    IBOutlet NSTextField *ILTFblood;
    
    IBOutlet NSTextField *ILTFrecHP;
    IBOutlet NSTextField *ILTFrecHPp;
    IBOutlet NSTextField *ILTFrecMP;
    IBOutlet NSTextField *ILTFrecMPp;
    IBOutlet NSTextField *ILTFcomment;
    
    IBOutlet NSPopUpButton *ILPUBtype;
    
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
    
    IBOutlet NSPopUpButton *AMbtnA;
    IBOutlet NSPopUpButton *AMbtnB;
    IBOutlet NSPopUpButton *AMbtnC;
    IBOutlet NSPopUpButton *AMbtnD;
    
    NSMutableArray *commandListMA;
    IBOutlet NSArrayController *commandListAC;
    IBOutlet NSTableView *commandListTV;
    
    NSMutableArray *comboListMA;
    IBOutlet NSArrayController *comboListAC;
    IBOutlet NSTableView *comboListTV;
    
    IBOutlet NSTextField *RETFblow;
    IBOutlet NSTextField *RETFslash;
    IBOutlet NSTextField *RETFstub;
    IBOutlet NSTextField *RETFarrow;
    IBOutlet NSTextField *RETFgun;
    IBOutlet NSTextField *RETFshell;
    IBOutlet NSTextField *RETFparalysis;
    IBOutlet NSTextField *RETFpoison;
    IBOutlet NSTextField *RETFcharm;
    IBOutlet NSTextField *RETFconfusion;
    IBOutlet NSTextField *RETFsleep;
    IBOutlet NSTextField *RETFsilent;
    
    IBOutlet NSTextField *RETFflame;
    IBOutlet NSTextField *RETFcold;
    IBOutlet NSTextField *RETFelectoric;
    IBOutlet NSTextField *RETFair;
    IBOutlet NSTextField *RETFwater;
    IBOutlet NSTextField *RETFgas;
    IBOutlet NSTextField *RETFholy;
    IBOutlet NSTextField *RETFdark;
    IBOutlet NSTextField *RETFexplosion;
    IBOutlet NSTextField *RETFblood;
    
    UNITCHIP *UCtop[4096];
    
    ATTACK *atkTop;
    int clickedRowAT;
    int SLpbtn;
    
}

-(IBAction)submit:(id)sender;
- (NSMutableArray*)unitChipListMA;

-(IBAction)saveUCL:(id)sender;
-(IBAction)cancelUCL:(id)sender;

-(IBAction)mobileUCL:(id)sender;
-(IBAction)skillUCL:(id)sender;
-(IBAction)equiplUCL:(id)sender;

-(IBAction)skillListBtnUCL:(id)sender;
-(IBAction)attackListBtnlUCL:(id)sender;
-(IBAction)registListBtnlUCL:(id)sender;

-(IBAction)equipItemSelected:(id)sender;
-(IBAction)insertEquip:(id)sender;
-(IBAction)removeEquip:(id)sender;

-(IBAction)skillListBtnSubmitUCL:(id)sender;
-(IBAction)attackListBtnSubmitlUCL:(id)sender;
-(IBAction)registListBtnlSubmitUCL:(id)sender;

-(IBAction)insertSkillUCL:(id)sender;
-(IBAction)removeSkillUCL:(id)sender;

-(IBAction)UCLPanelEquipListSubmitBtn:(id)sender;
-(IBAction)UCLPanelSkillListSubmitBtn:(id)sender;

-(IBAction)UCLPanelEquipListOpenBtn:(id)sender;
-(IBAction)UCLPanelSkillListOpenBtn:(id)sender;

-(IBAction)saveIL:(id)sender;
-(IBAction)canceIL:(id)sender;
-(IBAction)ILregi:(id)sender;
-(IBAction)saveILregi:(id)sender;
-(IBAction)cancelILregi:(id)sender;
-(IBAction)attackIL:(id)sender;

-(IBAction)insertAttackList:(id)sender;
-(IBAction)removeAttackList:(id)sender;
-(IBAction)insertComboList:(id)sender;
-(IBAction)removeComboList:(id)sender;

-(IBAction)submitAttackList:(id)sender;

-(IBAction)insertDamageList:(id)sender;
-(IBAction)removeDamageList:(id)sender;
-(IBAction)insertHitList:(id)sender;
-(IBAction)removeHitList:(id)sender;

-(IBAction)registUCL:(id)sender;
-(IBAction)registSaveUCL:(id)sender;
-(IBAction)registCancelUCL:(id)sender;

-(IBAction)attackListTotalSubmit:(id)sender;
-(IBAction)attackListOpenBtn:(id)sender;
-(IBAction)commandListAdd:(id)sender;
-(IBAction)commandListRemove:(id)sender;
-(IBAction)comboListAdd:(id)sender;
-(IBAction)comboListRemove:(id)sender;

-(IBAction)skillListInsert:(id)sender;
-(IBAction)skillListDelete:(id)sender;

-(IBAction)SLbuildAdd:(id)sender;
-(IBAction)SLbuildDelete:(id)sender;
-(IBAction)SLbuildSubmit:(id)sender;

-(IBAction)SLunitAdd:(id)sender;
-(IBAction)SLunitDelete:(id)sender;
-(IBAction)SLunitSubmit:(id)sender;

-(IBAction)addSubjMark:(id)sender;
-(IBAction)addObjeMark:(id)sender;

-(void)initFileDirectoryAttack2;
-(void)setTotalDamage2:(int)i row:(int)r;

@end
