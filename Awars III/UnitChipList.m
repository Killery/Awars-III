//
//  UnitChipList.m
//  Awars III
//
//  Created by Killery on 2012/12/17.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import "UnitChipList.h"

@implementation UnitChipList
- (void)dealloc
{
    [super dealloc];
}

- (NSMutableArray*)unitChipListMA{
    return unitChipListMA;
}
-(IBAction)submit:(id)sender{
    [UCLPanel close];
}

-(void)awakeFromNib{
    [unitChipListTV setTarget:self];
    [unitChipListTV setDoubleAction:@selector(doubleClickUCL:)];
    
    [attackListTV setTarget:self];
    [attackListTV setDoubleAction:@selector(doubleClickAL:)];
    
    [equipListTV setTarget:self];
    [equipListTV setDoubleAction:@selector(doubleClickEQ:)];
    
    [attackListTV setTarget:self];
    [attackListTV setAction:@selector(ClickAL:)];
    
    [skillListTV setTarget:self];
    [skillListTV setAction:@selector(ClickSL:)];
    [skillListTV setDoubleAction:@selector(doubleClickSL:)];
    
    [skillListBuildTV setTarget:self];
    [skillListBuildTV setAction:@selector(ClickSLB:)];
    
    [skillListUnitTV setTarget:self];
    [skillListUnitTV setAction:@selector(ClickSLU:)];
    
    [self addPUBEquipList];
    equipItemMA = [NSMutableArray new];
    attackListMA = [NSMutableArray new];
    damageListMA = [NSMutableArray new];
    hitListMA = [NSMutableArray new];
    commandListMA = [NSMutableArray new];
    comboListMA = [NSMutableArray new];
    skillListMA = [NSMutableArray new];
    skillListBuildMA = [NSMutableArray new];
    skillListUnitMA = [NSMutableArray new];
    
}
-(id)init{
    [super init];
    
    if (self) {
        UCLtime  = [NSTimer
                    scheduledTimerWithTimeInterval:0.01f
                    target:self
                    selector:@selector(EventLoopUCL:)
                    userInfo:nil
                    repeats:YES
                    ];
        [self initFileDirectoryItem];
        [self initItemList];
        [self initFileDirectoryAttackEQ];
        [self initFileDirectory];
        [self initUnitChipList];
        [self initFileDirectoryAttack];
        [self initFileDirectoryCombo];
        [self initTotalDamage];
        [self initOMG];
        [self initSkill];
        UnitChipMax = (int)chipNumb/25+1;
        
        
    }
    
    return self;
}

-(void)ClickSL:(id)sender{
    SKLrow = (int)[skillListTV clickedRow];
}

-(void)doubleClickSL:(id)sender{
    
    if(!UC[clickIndex].S || SKLrow < 0) return;
    
    Stop = UC[clickIndex].S;
    for (int i = 0;i < SKLrow;i++) {
        UC[clickIndex].S = UC[clickIndex].S->next;
    }
    
    if(UC[clickIndex].S->type == 1){
        windowPoint.x = [UCLPanelSkill frame].origin.x + 50;
        windowPoint.y = [UCLPanelSkill frame].origin.y;
        [SLBpanel setFrameOrigin:windowPoint];
        
        
        [self initskillListBuild];
        
        [SLBpanel makeKeyAndOrderFront:nil];
    }
    
    if(UC[clickIndex].S->type == 2){
        windowPoint.x = [UCLPanelSkill frame].origin.x + 50;
        windowPoint.y = [UCLPanelSkill frame].origin.y;
        [SLUpanel setFrameOrigin:windowPoint];
        
        
        [self initskillListUnit];
        
        [SLUpanel makeKeyAndOrderFront:nil];
    }
    
    UC[clickIndex].S = Stop;
}

-(void)ClickSLB:(id)sender{
    SKLBrow = (int)[skillListBuildTV clickedRow];
}

-(void)ClickSLU:(id)sender{
    SKLUrow = (int)[skillListUnitTV clickedRow];
}

-(void)initSkill{

    SKILLLIST skill[] = {
        {NULL, @"建設", @"skl1", @"フィールドに建物を建設する", 1, 0, 0},
        {NULL, @"召還", @"skl2", @"フィールドにユニットを召還する", 2, 0, 0},
        {NULL, @"必殺", @"skl3", @"一定の確率で与えるダメージが2倍になる", 2, 0, 0},
    };
    
    const int skillNum = 3;
    
    
    SKL = calloc(1, sizeof(SKILL));
    SKLtop = SKL;
    
    for(int i=0;i<skillNum;i++){
        *SKL = skill[i];
        if(i+1 < skillNum) {
            SKL->next = calloc(1, sizeof(SKILL));
            *SKL->next = skill[i+1];
        }
        if(i == 0) SKLtop = SKL;
        if(i+1 < skillNum) SKL = SKL->next;
    }SKL->next = NULL;
    SKL = SKLtop;
    
    [PUBsl removeAllItems];
    [PUBsl addItemWithTitle:[NSString stringWithFormat:@"スキルリスト"]];
    
    SKL = SKLtop;
    while(SKL){
        [PUBsl addItemWithTitle:[NSString stringWithFormat:@"%@",SKL->name]];
        SKL = SKL->next;
    }SKL = SKLtop;
}




-(void)initOMG{
    double STRfix;
    double VITfix;
    double AGIfix;
    double DEXfix;
    double MENfix;
    double INTfix;
    double LUKfix;
    
    double S, V, A, D, M, I;
    
    for(int i = 0;i < chipNumb;i++){
        STRfix = (
                  UC[i].eHandL.STR +
                  UC[i].eHandR.STR +
                  UC[i].eHead.STR +
                  UC[i].eBody.STR +
                  UC[i].eFoot.STR +
                  UC[i].eArm.STR) +
        UC[i].S_M.STR *(
                    UC[i].eHandL.pSTR +
                    UC[i].eHandR.pSTR +
                    UC[i].eHead.pSTR +
                    UC[i].eBody.pSTR +
                    UC[i].eFoot.pSTR +
                    UC[i].eArm.pSTR +
                    0)/100
        ;
        
        VITfix = (
                  UC[i].eHandL.VIT +
                  UC[i].eHandR.VIT +
                  UC[i].eHead.VIT +
                  UC[i].eBody.VIT +
                  UC[i].eFoot.VIT +
                  UC[i].eArm.VIT) +
        UC[i].S_M.VIT *(
                             UC[i].eHandL.pVIT +
                             UC[i].eHandR.pVIT +
                             UC[i].eHead.pVIT +
                             UC[i].eBody.pVIT +
                             UC[i].eFoot.pVIT +
                             UC[i].eArm.pVIT +
                             0)/100
        ;
        AGIfix = (
                  UC[i].eHandL.AGI +
                  UC[i].eHandR.AGI +
                  UC[i].eHead.AGI +
                  UC[i].eBody.AGI +
                  UC[i].eFoot.AGI +
                  UC[i].eArm.AGI) +
        UC[i].S_M.AGI *(
                             UC[i].eHandL.pAGI +
                             UC[i].eHandR.pAGI +
                             UC[i].eHead.pAGI +
                             UC[i].eBody.pAGI +
                             UC[i].eFoot.pAGI +
                             UC[i].eArm.pAGI +
                             0)/100
        ;
        DEXfix = (
                  UC[i].eHandL.DEX +
                  UC[i].eHandR.DEX +
                  UC[i].eHead.DEX +
                  UC[i].eBody.DEX +
                  UC[i].eFoot.DEX +
                  UC[i].eArm.DEX) +
        UC[i].S_M.DEX *(
                             UC[i].eHandL.pDEX +
                             UC[i].eHandR.pDEX +
                             UC[i].eHead.pDEX +
                             UC[i].eBody.pDEX +
                             UC[i].eFoot.pDEX +
                             UC[i].eArm.pDEX +
                             0)/100
        ;
        MENfix = (
                  UC[i].eHandL.MEN +
                  UC[i].eHandR.MEN +
                  UC[i].eHead.MEN +
                  UC[i].eBody.MEN +
                  UC[i].eFoot.MEN +
                  UC[i].eArm.MEN) +
        UC[i].S_M.MEN *(
                             UC[i].eHandL.pMEN +
                             UC[i].eHandR.pMEN +
                             UC[i].eHead.pMEN +
                             UC[i].eBody.pMEN +
                             UC[i].eFoot.pMEN +
                             UC[i].eArm.pMEN +
                             0)/100
        ;
        INTfix = (
                  UC[i].eHandL.INT +
                  UC[i].eHandR.INT +
                  UC[i].eHead.INT +
                  UC[i].eBody.INT +
                  UC[i].eFoot.INT +
                  UC[i].eArm.INT) +
        UC[i].S_M.INT *(
                             UC[i].eHandL.pINT +
                             UC[i].eHandR.pINT +
                             UC[i].eHead.pINT +
                             UC[i].eBody.pINT +
                             UC[i].eFoot.pINT +
                             UC[i].eArm.pINT +
                             0)/100
        ;
        LUKfix = (
                  UC[i].eHandL.LUK +
                  UC[i].eHandR.LUK +
                  UC[i].eHead.LUK +
                  UC[i].eBody.LUK +
                  UC[i].eFoot.LUK +
                  UC[i].eArm.LUK) +
        UC[i].S_M.LUK *(
                             UC[i].eHandL.pLUK +
                             UC[i].eHandR.pLUK +
                             UC[i].eHead.pLUK +
                             UC[i].eBody.pLUK +
                             UC[i].eFoot.pLUK +
                             UC[i].eArm.pLUK +
                             0)/100
        ;
        
        S = UC[i].S_M.STR + STRfix;
        V = UC[i].S_M.VIT + VITfix;
        A = UC[i].S_M.AGI + AGIfix;
        D = UC[i].S_M.DEX + DEXfix;
        M = UC[i].S_M.MEN + MENfix;
        I = UC[i].S_M.INT + INTfix;
        
        UC[i].S_M.ATK = (S*5 + D*2 + A)/8;
        UC[i].S_M.DEF = (V*5 + M*2 + S)/8;
        UC[i].S_M.CAP = (I*4 + D*1 + M*2)/7;
        UC[i].S_M.ACU = (D*4 + A*1 + M)/6;
        UC[i].S_M.EVA = (A*4 + V*1 + M)/6;
        
        UC[i].S_M.ATK += 0.5;
        UC[i].S_M.DEF += 0.5;
        UC[i].S_M.CAP += 0.5;
        UC[i].S_M.ACU += 0.5;
        UC[i].S_M.EVA += 0.5;
        
        UC[i].S_M.ATK = floor(UC[i].S_M.ATK);
        UC[i].S_M.DEF = floor(UC[i].S_M.DEF);
        UC[i].S_M.CAP = floor(UC[i].S_M.CAP);
        UC[i].S_M.ACU = floor(UC[i].S_M.ACU);
        UC[i].S_M.EVA = floor(UC[i].S_M.EVA);
    }

}

NSInteger clickIndex = -1;
NSInteger clickIndexAL = -1;
NSInteger clickIndexEQ = -1;
bool InitialFlag;

-(void)EventLoopUCL:(NSTimer*)time{
    
    
    double STRfix;
    double VITfix;
    double AGIfix;
    double DEXfix;
    double MENfix;
    double INTfix;
    double LUKfix;
    
    double S, V, A, D, M, I;
    
    
    STRfix = (
    UC[clickIndex].eHandL.STR +
    UC[clickIndex].eHandR.STR +
    UC[clickIndex].eHead.STR +
    UC[clickIndex].eBody.STR +
    UC[clickIndex].eFoot.STR +
    UC[clickIndex].eArm.STR) +
    UC[clickIndex].S_M.STR *(
    UC[clickIndex].eHandL.pSTR +
    UC[clickIndex].eHandR.pSTR +
    UC[clickIndex].eHead.pSTR +
    UC[clickIndex].eBody.pSTR +
    UC[clickIndex].eFoot.pSTR +
    UC[clickIndex].eArm.pSTR +
    0)/100
    ;
    
    VITfix = (
              UC[clickIndex].eHandL.VIT +
              UC[clickIndex].eHandR.VIT +
              UC[clickIndex].eHead.VIT +
              UC[clickIndex].eBody.VIT +
              UC[clickIndex].eFoot.VIT +
              UC[clickIndex].eArm.VIT) +
    UC[clickIndex].S_M.VIT *(
                         UC[clickIndex].eHandL.pVIT +
                         UC[clickIndex].eHandR.pVIT +
                         UC[clickIndex].eHead.pVIT +
                         UC[clickIndex].eBody.pVIT +
                         UC[clickIndex].eFoot.pVIT +
                         UC[clickIndex].eArm.pVIT +
                         0)/100
    ;
    AGIfix = (
              UC[clickIndex].eHandL.AGI +
              UC[clickIndex].eHandR.AGI +
              UC[clickIndex].eHead.AGI +
              UC[clickIndex].eBody.AGI +
              UC[clickIndex].eFoot.AGI +
              UC[clickIndex].eArm.AGI) +
    UC[clickIndex].S_M.AGI *(
                         UC[clickIndex].eHandL.pAGI +
                         UC[clickIndex].eHandR.pAGI +
                         UC[clickIndex].eHead.pAGI +
                         UC[clickIndex].eBody.pAGI +
                         UC[clickIndex].eFoot.pAGI +
                         UC[clickIndex].eArm.pAGI +
                         0)/100
    ;
    DEXfix = (
              UC[clickIndex].eHandL.DEX +
              UC[clickIndex].eHandR.DEX +
              UC[clickIndex].eHead.DEX +
              UC[clickIndex].eBody.DEX +
              UC[clickIndex].eFoot.DEX +
              UC[clickIndex].eArm.DEX) +
    UC[clickIndex].S_M.DEX *(
                         UC[clickIndex].eHandL.pDEX +
                         UC[clickIndex].eHandR.pDEX +
                         UC[clickIndex].eHead.pDEX +
                         UC[clickIndex].eBody.pDEX +
                         UC[clickIndex].eFoot.pDEX +
                         UC[clickIndex].eArm.pDEX +
                         0)/100
    ;
    MENfix = (
              UC[clickIndex].eHandL.MEN +
              UC[clickIndex].eHandR.MEN +
              UC[clickIndex].eHead.MEN +
              UC[clickIndex].eBody.MEN +
              UC[clickIndex].eFoot.MEN +
              UC[clickIndex].eArm.MEN) +
    UC[clickIndex].S_M.MEN *(
                         UC[clickIndex].eHandL.pMEN +
                         UC[clickIndex].eHandR.pMEN +
                         UC[clickIndex].eHead.pMEN +
                         UC[clickIndex].eBody.pMEN +
                         UC[clickIndex].eFoot.pMEN +
                         UC[clickIndex].eArm.pMEN +
                         0)/100
    ;
    INTfix = (
              UC[clickIndex].eHandL.INT +
              UC[clickIndex].eHandR.INT +
              UC[clickIndex].eHead.INT +
              UC[clickIndex].eBody.INT +
              UC[clickIndex].eFoot.INT +
              UC[clickIndex].eArm.INT) +
    UC[clickIndex].S_M.INT *(
                         UC[clickIndex].eHandL.pINT +
                         UC[clickIndex].eHandR.pINT +
                         UC[clickIndex].eHead.pINT +
                         UC[clickIndex].eBody.pINT +
                         UC[clickIndex].eFoot.pINT +
                         UC[clickIndex].eArm.pINT +
                         0)/100
    ;
    LUKfix = (
              UC[clickIndex].eHandL.LUK +
              UC[clickIndex].eHandR.LUK +
              UC[clickIndex].eHead.LUK +
              UC[clickIndex].eBody.LUK +
              UC[clickIndex].eFoot.LUK +
              UC[clickIndex].eArm.LUK) +
    UC[clickIndex].S_M.LUK *(
                         UC[clickIndex].eHandL.pLUK +
                         UC[clickIndex].eHandR.pLUK +
                         UC[clickIndex].eHead.pLUK +
                         UC[clickIndex].eBody.pLUK +
                         UC[clickIndex].eFoot.pLUK +
                         UC[clickIndex].eArm.pLUK +
                         0)/100
    ;
    
    S = [TFstr intValue] + STRfix;
    V = [TFvit intValue] + VITfix;
    A = [TFagi intValue] + AGIfix;
    D = [TFdex intValue] + DEXfix;
    M = [TFmen intValue] + MENfix;
    I = [TFint intValue] + INTfix;
    
    UC[clickIndex].S_M.ATK = (S*5 + D*2 + A)/8;
    UC[clickIndex].S_M.DEF = (V*5 + M*2 + S)/8;
    UC[clickIndex].S_M.CAP = (I*4 + D*1 + M*2)/7;
    UC[clickIndex].S_M.ACU = (D*4 + A*1 + M)/6;
    UC[clickIndex].S_M.EVA = (A*4 + A*1 + M)/6;
        
        UC[clickIndex].S_M.ATK += 0.5;
        UC[clickIndex].S_M.DEF += 0.5;
        UC[clickIndex].S_M.CAP += 0.5;
        UC[clickIndex].S_M.ACU += 0.5;
        UC[clickIndex].S_M.EVA += 0.5;
        
        UC[clickIndex].S_M.ATK = floor(UC[clickIndex].S_M.ATK);
        UC[clickIndex].S_M.DEF = floor(UC[clickIndex].S_M.DEF);
        UC[clickIndex].S_M.CAP = floor(UC[clickIndex].S_M.CAP);
        UC[clickIndex].S_M.ACU = floor(UC[clickIndex].S_M.ACU);
        UC[clickIndex].S_M.EVA = floor(UC[clickIndex].S_M.EVA);
    
    
    [TFbp setStringValue:[NSString stringWithFormat:@"BP %g", (floor)(UC[clickIndex].S_M.BP)]];
    [TFatk setStringValue:[NSString stringWithFormat:@"攻撃力 %g", (floor)(UC[clickIndex].S_M.ATK)]];
    [TFdef setStringValue:[NSString stringWithFormat:@"防御力 %g", (floor)(UC[clickIndex].S_M.DEF)]];
    [TFcap setStringValue:[NSString stringWithFormat:@"演算力 %g", (floor)(UC[clickIndex].S_M.CAP)]];
    [TFacu setStringValue:[NSString stringWithFormat:@"命中値 %g", (floor)(UC[clickIndex].S_M.ACU)]];
    [TFeva setStringValue:[NSString stringWithFormat:@"回避値 %g", (floor)(UC[clickIndex].S_M.EVA)]];
    
    
    
    long sup;
    if(SKLBrow == -1 || [skillListBuildMA count] == 0){}
    else{
        
        Stop = UC[clickIndex].S;
        for(int i = 0;i< SKLrow;i++){
            UC[clickIndex].S = UC[clickIndex].S->next;
        }
        
    sup = [[skillListBuildMA objectAtIndex:SKLBrow] valueForKeyPath:@"sel"];
    sup = sup>>8 & 0xffff;
    UC[clickIndex].S->list[SKLBrow] = (int)sup+1;
    [skillListBuildAC setValue:[NSString stringWithFormat:@"資%d食%d金%d",
    BC[sup].Csupply, BC[sup].Cfood, BC[sup].Cmoney] forKeyPath:@"selection.manko"];
        
        UC[clickIndex].S = Stop;
    }
    
    long oops;
    if(SKLUrow == -1 || [skillListUnitMA count] == 0){}
    else{
        
        Stop = UC[clickIndex].S;
        for(int i = 0;i< SKLrow;i++){
            UC[clickIndex].S = UC[clickIndex].S->next;
        }
        
    oops = [[skillListUnitMA objectAtIndex:SKLUrow] valueForKeyPath:@"sel"];
    oops = oops>>8 & 0xffff;
    UC[clickIndex].S->list[SKLUrow] = (int)oops+1;
    oops = [[[skillListUnitMA objectAtIndex:SKLUrow] valueForKeyPath:@"MP"] intValue];
    //oops = oops>>8 & 0xffff;
    UC[clickIndex].S->cost[SKLUrow] = (int)oops;
        
        UC[clickIndex].S = Stop;
    }
    
    
}

-(void)setTotalDamage:(int)index row:(int)row{
    
    ATTACK *Atop;
    Atop = UC[index].A;
    if(!UC[index].A) return;
    for (int i=0; i < row;i++) {
        if(UC[index].A->next != NULL) UC[index].A = UC[index].A->next;
    }
    DAMAGE *Dtop;
    Dtop = UC[index].A->D;
    UC[index].A->totalD = 0;
    UC[index].A->bulletC = UC[index].A->bullet;
    while (UC[index].A->D != NULL) {
        if(UC[index].A->D->type == 0) UC[index].A->totalD += UC[index].A->D->count + UC[index].A->D->pCount/100*UC[index].S_M.ATK;
        if(UC[index].A->D->type == 1) UC[index].A->totalD += UC[index].A->D->count + UC[index].A->D->pCount/100*UC[index].S_M.DEF;
        if(UC[index].A->D->type == 2) UC[index].A->totalD += UC[index].A->D->count + UC[index].A->D->pCount/100*UC[index].S_M.ACU;
        if(UC[index].A->D->type == 3) UC[index].A->totalD += UC[index].A->D->count + UC[index].A->D->pCount/100*UC[index].S_M.EVA;
        if(UC[index].A->D->type == 4) UC[index].A->totalD += UC[index].A->D->count + UC[index].A->D->pCount/100*UC[index].S_M.CAP;
        UC[index].A->D = UC[index].A->D->next;
    }
    UC[index].A->totalD = floor(UC[index].A->totalD + 0.5);
    UC[index].A->D = Dtop;
    UC[index].A = Atop;
}

-(void)setTotalDamage2:(int)index row:(int)row{
    
    ATTACK *Atop;
    Atop = LC[index].A;
    if(!LC[index].A) return;
    for (int i=0; i < row;i++) {
        if(LC[index].A->next != NULL) LC[index].A = LC[index].A->next;
    }
    DAMAGE *Dtop;
    Dtop = LC[index].A->D;
    LC[index].A->totalD = 0;
    LC[index].A->bulletC = LC[index].A->bullet;
    while (LC[index].A->D != NULL) {
        LC[index].A->totalD += LC[index].A->D->count;
        LC[index].A->D = LC[index].A->D->next;
    }
    LC[index].A->totalD = floor(LC[index].A->totalD + 0.5);
    LC[index].A->D = Dtop;
    LC[index].A = Atop;
}


-(void)setTotalDamageEQ:(int)index row:(int)row{
    
    ATTACK *Atop;
    Atop = EQ[index].A;
    if(!EQ[index].A) return;
    for (int i=0; i < row;i++) {
        if(EQ[index].A->next != NULL) EQ[index].A = EQ[index].A->next;
    }
    DAMAGE *Dtop;
    Dtop = EQ[index].A->D;
    EQ[index].A->totalD = 0;
    EQ[index].A->bulletC = EQ[index].A->bullet;
    while (EQ[index].A->D != NULL) {
        if(EQ[index].A->D->type == 0) EQ[index].A->totalD += EQ[index].A->D->count;
        if(EQ[index].A->D->type == 1) EQ[index].A->totalD += EQ[index].A->D->count;
        if(EQ[index].A->D->type == 2) EQ[index].A->totalD += EQ[index].A->D->count;
        if(EQ[index].A->D->type == 3) EQ[index].A->totalD += EQ[index].A->D->count;
        if(EQ[index].A->D->type == 4) EQ[index].A->totalD += EQ[index].A->D->count;
        EQ[index].A->D = EQ[index].A->D->next;
    }
    EQ[index].A->totalD = floor(EQ[index].A->totalD + 0.5);
    EQ[index].A->D = Dtop;
    EQ[index].A = Atop;
}


-(void)addPUBEquipList{
    
    [PUPtEquip removeAllItems];
    
    [PUPtEquip addItemWithTitle:@"装備リスト"];
    for (int i = 0; i < eItemNum; i++) {
        [PUPtEquip addItemWithTitle:EQ[i].name];
    }
}


-(void)initSkillList{
    [self willChangeValueForKey:@"skillListMA"];
    [skillListMA removeAllObjects];
    [self didChangeValueForKey:@"skillListMA"];
    
    
    SKILL *SKtop;
    SKtop = UC[clickIndex].S;
    while (UC[clickIndex].S) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        SKL = SKLtop;
        for(int i = 1;i < UC[clickIndex].S->type;i++){
            SKL = SKL->next;
        }
        [dict setValue:[NSString stringWithFormat:@"%@", SKL->name] forKey:@"name"];
        SKL = SKLtop;
        
        [self willChangeValueForKey:@"skillListMA"];
        [skillListMA addObject:dict];
        [self didChangeValueForKey:@"skillListMA"];
        
        UC[clickIndex].S = UC[clickIndex].S->next;
    }UC[clickIndex].S = SKtop;

}

-(void)initskillListBuild{
    [self willChangeValueForKey:@"skillListBuildMA"];
    [skillListBuildMA removeAllObjects];
    [self didChangeValueForKey:@"skillListBuildMA"];
    
    for(int i = 0;UC[clickIndex].S->list[i] > 0;i++) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        NSMutableArray *Array = [NSMutableArray array];
        
        for(int k = 0;k<BuildChipNum;k++){
            [Array addObject:[BC[k].name retain]];
            [dict setValue:[NSString stringWithFormat:@"資%d食%d金%d", BC[k].Csupply, BC[k].Cfood, BC[k].Cmoney] forKey:@"manko"];
        }
        [dict setValue:Array forKey:@"name"];
        
        int val;
        val = UC[clickIndex].S->list[i] - 1;
        val = val<<8 | (0xc7 & 0xff);
        [dict setValue:val forKey:@"sel"];
        
        [self willChangeValueForKey:@"skillListBuildMA"];
        [skillListBuildMA addObject:dict];
        [self didChangeValueForKey:@"skillListBuildMA"];
    }


}

-(void)initskillListUnit{
    [self willChangeValueForKey:@"skillListUnitMA"];
    [skillListUnitMA removeAllObjects];
    [self didChangeValueForKey:@"skillListUnitMA"];
    
    
    for(int i = 0;UC[clickIndex].S->list[i] > 0;i++) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        NSMutableArray *Array = [NSMutableArray array];
        
        for(int k = 0;k<UCN;k++){
            [Array addObject:[UC[k].name retain]];
        }
        [dict setValue:Array forKey:@"name"];
        
        [dict setValue:[NSString stringWithFormat:@"%g", UC[clickIndex].S->cost[i]] forKey:@"MP"];
        
        int val;
        val = UC[clickIndex].S->list[i] - 1;
        val = val<<8 | (0xc7 & 0xff);
        [dict setValue:val forKey:@"sel"];
        
        [self willChangeValueForKey:@"skillListUnitMA"];
        [skillListUnitMA addObject:dict];
        [self didChangeValueForKey:@"skillListUnitMA"];
    }
    
}


-(void)initEquip{
    [self willChangeValueForKey:@"equipItemMA"];
    [equipItemMA removeAllObjects];
    [self didChangeValueForKey:@"equipItemMA"];
    eHeadFlag = false;
    eBodyFlag = false;
    eFootFlag = false;
    eArmFlag = false;
    eHandRFlag = false;
    eHandLFlag = false;
    
    if(UC[clickIndex].eHandR.name != NULL) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].eHandR.name] forKey:@"name"];
        UC[clickIndex].eHandRflag = true;
        [self willChangeValueForKey:@"equipItemMA"];
        [equipItemMA insertObject:dict atIndex:[equipItemTV selectedRow]+1];
        [self didChangeValueForKey:@"equipItemMA"];
    }
    if(UC[clickIndex].eHandL.name != NULL) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].eHandL.name] forKey:@"name"];
        UC[clickIndex].eHandLflag = true;
        [self willChangeValueForKey:@"equipItemMA"];
        [equipItemMA insertObject:dict atIndex:[equipItemTV selectedRow]+1];
        [self didChangeValueForKey:@"equipItemMA"];
    }
    if(UC[clickIndex].eHead.name != NULL) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].eHead.name] forKey:@"name"];
        eHeadFlag = true;
        [self willChangeValueForKey:@"equipItemMA"];
        [equipItemMA insertObject:dict atIndex:[equipItemTV selectedRow]+1];
        [self didChangeValueForKey:@"equipItemMA"];
    }
    if(UC[clickIndex].eBody.name != NULL) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].eBody.name] forKey:@"name"];
        eBodyFlag = true;
        [self willChangeValueForKey:@"equipItemMA"];
        [equipItemMA insertObject:dict atIndex:[equipItemTV selectedRow]+1];
        [self didChangeValueForKey:@"equipItemMA"];
    }
    if(UC[clickIndex].eFoot.name != NULL) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].eFoot.name] forKey:@"name"];
        eFootFlag = true;
        [self willChangeValueForKey:@"equipItemMA"];
        [equipItemMA insertObject:dict atIndex:[equipItemTV selectedRow]+1];
        [self didChangeValueForKey:@"equipItemMA"];
    }
    if(UC[clickIndex].eArm.name != NULL) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].eArm.name] forKey:@"name"];
        eArmFlag = true;
        [self willChangeValueForKey:@"equipItemMA"];
        [equipItemMA insertObject:dict atIndex:[equipItemTV selectedRow]+1];
        [self didChangeValueForKey:@"equipItemMA"];
    }
    
    
    if(UC[clickIndex].eHandL.nameID){
        for(int j = 0;j < eItemNum;j++){
            if([UC[clickIndex].eHandL.nameID isEqualToString:EQ[j].nameID]){
                UC[clickIndex].eHandL = EQ[j];
                UC[clickIndex].eHandL.A = EQ[j].A;
            }
        }
    }
    
    if(UC[clickIndex].eHandR.nameID){
        for(int j = 0;j < eItemNum;j++){
            if([UC[clickIndex].eHandR.nameID isEqualToString:EQ[j].nameID]){
                UC[clickIndex].eHandR = EQ[j];
                UC[clickIndex].eHandR.A = EQ[j].A;
            }
        }
    }
    
    if(UC[clickIndex].eHead.nameID){
        for(int j = 0;j < eItemNum;j++){
            if([UC[clickIndex].eHead.nameID isEqualToString:EQ[j].nameID]){
                UC[clickIndex].eHead = EQ[j];
            }
        }
    }
    
    if(UC[clickIndex].eBody.nameID){
        for(int j = 0;j < eItemNum;j++){
            if([UC[clickIndex].eBody.nameID isEqualToString:EQ[j].nameID]){
                UC[clickIndex].eBody = EQ[j];
            }
        }
    }
    
    if(UC[clickIndex].eFoot.nameID){
        for(int j = 0;j < eItemNum;j++){
            if([UC[clickIndex].eFoot.nameID isEqualToString:EQ[j].nameID]){
                UC[clickIndex].eFoot = EQ[j];
            }
        }
    }
    
    if(UC[clickIndex].eArm.nameID){
        for(int j = 0;j < eItemNum;j++){
            if([UC[clickIndex].eArm.nameID isEqualToString:EQ[j].nameID]){
                UC[clickIndex].eArm = EQ[j];
            }
        }
    }
}

-(IBAction)equipItemSelected:(id)sender{
    pubEquipItemIndex = [PUPtEquip indexOfSelectedItem];
    pubEquipItemIndex -= 1;
}

bool eHeadFlag = false;
bool eBodyFlag = false;
bool eFootFlag = false;
bool eArmFlag = false;
bool eHandRFlag = false;
bool eHandLFlag = false;

-(IBAction)insertEquip:(id)sender{
    
    if(pubEquipItemIndex >= 0){
        
        if(EQ[pubEquipItemIndex].type == 2){
            if(UC[clickIndex].eHandLflag && UC[clickIndex].eHandRflag) return;
            if(UC[clickIndex].eHandRflag) {
                UC[clickIndex].eHandLflag = true;
                UC[clickIndex].eHandL = EQ[pubEquipItemIndex];
            }else{
            UC[clickIndex].eHandR = EQ[pubEquipItemIndex];
                UC[clickIndex].eHandRflag = true;
            }
        }else if(EQ[pubEquipItemIndex].type == 3){
            if(UC[clickIndex].eHeadflag) return;
            UC[clickIndex].eHead = EQ[pubEquipItemIndex];
            UC[clickIndex].eHeadflag = true;
        }else if(EQ[pubEquipItemIndex].type == 4){
            if(UC[clickIndex].eBodyflag) return;
            UC[clickIndex].eBody = EQ[pubEquipItemIndex];
            UC[clickIndex].eBodyflag = true;
        }else if(EQ[pubEquipItemIndex].type == 5){
            if(UC[clickIndex].eFootflag) return;
            UC[clickIndex].eFoot = EQ[pubEquipItemIndex];
            UC[clickIndex].eFootflag = true;
        }else if(EQ[pubEquipItemIndex].type == 6){
            if(UC[clickIndex].eArmflag) return;
            UC[clickIndex].eArm = EQ[pubEquipItemIndex];
            UC[clickIndex].eArmflag = true;
        }else if(EQ[pubEquipItemIndex].type == 7){
            if(!UC[clickIndex].eHandLflag && !UC[clickIndex].eHandRflag){
            
            UC[clickIndex].eHandLflag = true;
            UC[clickIndex].eHandRflag = true;
            UC[clickIndex].eHandR = EQ[pubEquipItemIndex];
            }else
                return;
        }
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", EQ[pubEquipItemIndex].name] forKey:@"name"];
        [self willChangeValueForKey:@"equipItemMA"];
        [equipItemMA insertObject:dict atIndex:[equipItemTV selectedRow]+1];
        [self didChangeValueForKey:@"equipItemMA"];
    }
}
-(IBAction)removeEquip:(id)sender{
    
    
    if([equipItemTV selectedRow] >= 0){
        
        if([[[equipItemMA objectAtIndex:[equipItemTV selectedRow]] valueForKey:@"name"] isEqualToString:UC[clickIndex].eHandL.name]){
            
            if(UC[clickIndex].eHandLflag){
                if(UC[clickIndex].eHandL.type == 7){
                    UC[clickIndex].eHandR = nilEquip;
                    UC[clickIndex].eHandRflag = false;
                }
                UC[clickIndex].eHandL = nilEquip;
                UC[clickIndex].eHandLflag = false;
            }
            
        }
        else if([[[equipItemMA objectAtIndex:[equipItemTV selectedRow]] valueForKey:@"name"] isEqualToString:UC[clickIndex].eHandR.name]){
            if(UC[clickIndex].eHandRflag){
                if(UC[clickIndex].eHandR.type == 7){
                    UC[clickIndex].eHandL = nilEquip;
                    UC[clickIndex].eHandLflag = false;
                }
                UC[clickIndex].eHandR = nilEquip;
                UC[clickIndex].eHandRflag = false;
            }
        }
        else if([[[equipItemMA objectAtIndex:[equipItemTV selectedRow]] valueForKey:@"name"] isEqualToString:UC[clickIndex].eHead.name]){
            UC[clickIndex].eHead = nilEquip;
            UC[clickIndex].eHeadflag = false;
        }
        else if([[[equipItemMA objectAtIndex:[equipItemTV selectedRow]] valueForKey:@"name"] isEqualToString:UC[clickIndex].eBody.name]){
            UC[clickIndex].eBody = nilEquip;
            UC[clickIndex].eBodyflag = false;
        }
        else if([[[equipItemMA objectAtIndex:[equipItemTV selectedRow]] valueForKey:@"name"] isEqualToString:UC[clickIndex].eFoot.name]){
            UC[clickIndex].eFoot = nilEquip;
            UC[clickIndex].eFootflag = false;
        }
        else if([[[equipItemMA objectAtIndex:[equipItemTV selectedRow]] valueForKey:@"name"] isEqualToString:UC[clickIndex].eArm.name]){
            UC[clickIndex].eArm = nilEquip;
            UC[clickIndex].eArmflag = false;
        }
        
        
        
        [self willChangeValueForKey:@"equipItemMA"];
        [equipItemMA removeObjectAtIndex:[equipItemTV selectedRow]];
        [self didChangeValueForKey:@"equipItemMA"];
    }
}


-(void)doubleClickEQ:(id)sender{
    clickIndexEQ = [equipListTV clickedRow];
    
    if(EQ[clickIndexEQ].name) [ILTFname setStringValue:EQ[clickIndexEQ].name];
    else [ILTFname setStringValue:@""];
    if(EQ[clickIndexEQ].nameRecognition) [ILTFnameR setStringValue:EQ[clickIndexEQ].nameRecognition];
    else [ILTFnameR setStringValue:@""];
    if(EQ[clickIndexEQ].nameID) [ILTFnameID setStringValue:EQ[clickIndexEQ].nameID];
    else [ILTFnameID setStringValue:@""];
    [ILTFweight setDoubleValue:EQ[clickIndexEQ].Weight];
    [ILTFprice setDoubleValue:EQ[clickIndexEQ].price];
    [ILTFMOV setIntValue:EQ[clickIndexEQ].MOV];
    [ILTFHP setDoubleValue:EQ[clickIndexEQ].HP];
    [ILTFMP setDoubleValue:EQ[clickIndexEQ].MP];
    [ILTFAP setDoubleValue:EQ[clickIndexEQ].AP];
    [ILTFWT setDoubleValue:EQ[clickIndexEQ].WT];
    
    [ILTFSTR setDoubleValue:EQ[clickIndexEQ].STR];
    [ILTFVIT setDoubleValue:EQ[clickIndexEQ].VIT];
    [ILTFAGI setDoubleValue:EQ[clickIndexEQ].AGI];
    [ILTFDEX setDoubleValue:EQ[clickIndexEQ].DEX];
    [ILTFMEN setDoubleValue:EQ[clickIndexEQ].MEN];
    [ILTFINT setDoubleValue:EQ[clickIndexEQ].INT];
    [ILTFLUK setDoubleValue:EQ[clickIndexEQ].LUK];
    
    [ILTFpSTR setDoubleValue:EQ[clickIndexEQ].pSTR];
    [ILTFpVIT setDoubleValue:EQ[clickIndexEQ].pVIT];
    [ILTFpAGI setDoubleValue:EQ[clickIndexEQ].pAGI];
    [ILTFpDEX setDoubleValue:EQ[clickIndexEQ].pDEX];
    [ILTFpMEN setDoubleValue:EQ[clickIndexEQ].pMEN];
    [ILTFpINT setDoubleValue:EQ[clickIndexEQ].pINT];
    [ILTFpLUK setDoubleValue:EQ[clickIndexEQ].pLUK];
    
    [ILTFblow setIntValue:EQ[clickIndexEQ].R.blow];
    [ILTFslash setIntValue:EQ[clickIndexEQ].R.slash];
    [ILTFstub setIntValue:EQ[clickIndexEQ].R.stub];
    [ILTFarrow setIntValue:EQ[clickIndexEQ].R.arrow];
    [ILTFgun setIntValue:EQ[clickIndexEQ].R.gun];
    [ILTFshell setIntValue:EQ[clickIndexEQ].R.shell];
    [ILTFparalysis setIntValue:EQ[clickIndexEQ].R.paralysis];
    [ILTFpoison setIntValue:EQ[clickIndexEQ].R.poison];
    [ILTFcharm setIntValue:EQ[clickIndexEQ].R.charm];
    [ILTFconfusion setIntValue:EQ[clickIndexEQ].R.confusion];
    [ILTFsleep setIntValue:EQ[clickIndexEQ].R.sleep];
    [ILTFsilent setIntValue:EQ[clickIndexEQ].R.silent];
    
    [ILTFflame setIntValue:EQ[clickIndexEQ].R.flame];
    [ILTFcold setIntValue:EQ[clickIndexEQ].R.cold];
    [ILTFelectoric setIntValue:EQ[clickIndexEQ].R.electoric];
    [ILTFair setIntValue:EQ[clickIndexEQ].R.air];
    [ILTFwater setIntValue:EQ[clickIndexEQ].R.water];
    [ILTFgas setIntValue:EQ[clickIndexEQ].R.gas];
    [ILTFholy setIntValue:EQ[clickIndexEQ].R.holy];
    [ILTFdark setIntValue:EQ[clickIndexEQ].R.dark];
    [ILTFexplosion setIntValue:EQ[clickIndexEQ].R.explosion];
    [ILTFblood setIntValue:EQ[clickIndexEQ].R.blood];
    
    [ILTFrecHP setIntValue:EQ[clickIndexEQ].recHP];
    [ILTFrecHPp setIntValue:EQ[clickIndexEQ].recpHP];
    [ILTFrecMP setIntValue:EQ[clickIndexEQ].recMP];
    [ILTFrecMPp setIntValue:EQ[clickIndexEQ].recpMP];
    if(EQ[clickIndexEQ].comment) [ILTFcomment setStringValue:EQ[clickIndexEQ].comment];
    else [ILTFcomment setStringValue:@""];
    
    [ILPUBtype selectItemAtIndex:EQ[clickIndexEQ].type];
    
    UCLDpoint.x = [UCLPanelEquipList frame].origin.x + 0;
    UCLDpoint.y = [UCLPanelEquipList frame].origin.y + 0;
    [UCLPanelEquipDetail setFrameOrigin:UCLDpoint];
    [UCLPanelEquipDetail makeKeyAndOrderFront:nil];
}

-(IBAction)saveIL:(id)sender{
    
    EQ[clickIndexEQ].name = [[ILTFname stringValue] retain];
    EQ[clickIndexEQ].nameRecognition = [[ILTFnameR stringValue] retain];
    EQ[clickIndexEQ].nameID = [[ILTFnameID stringValue] retain];
    
    EQ[clickIndexEQ].Weight = [ILTFweight doubleValue];
    EQ[clickIndexEQ].price = [ILTFprice doubleValue];
    EQ[clickIndexEQ].MOV = [ILTFMOV intValue];
    EQ[clickIndexEQ].HP = [ILTFHP doubleValue];
    EQ[clickIndexEQ].MP = [ILTFMP doubleValue];
    EQ[clickIndexEQ].AP = [ILTFAP doubleValue];
    EQ[clickIndexEQ].WT = [ILTFWT doubleValue];
    
    EQ[clickIndexEQ].STR = [ILTFSTR doubleValue];
    EQ[clickIndexEQ].VIT = [ILTFVIT doubleValue];
    EQ[clickIndexEQ].AGI = [ILTFAGI doubleValue];
    EQ[clickIndexEQ].DEX = [ILTFDEX doubleValue];
    EQ[clickIndexEQ].MEN = [ILTFMEN doubleValue];
    EQ[clickIndexEQ].INT = [ILTFINT doubleValue];
    EQ[clickIndexEQ].LUK = [ILTFLUK doubleValue];
    
    EQ[clickIndexEQ].pSTR = [ILTFpSTR doubleValue];
    EQ[clickIndexEQ].pVIT = [ILTFpVIT doubleValue];
    EQ[clickIndexEQ].pAGI = [ILTFpAGI doubleValue];
    EQ[clickIndexEQ].pDEX = [ILTFpDEX doubleValue];
    EQ[clickIndexEQ].pMEN = [ILTFpMEN doubleValue];
    EQ[clickIndexEQ].pINT = [ILTFpINT doubleValue];
    EQ[clickIndexEQ].pLUK = [ILTFpLUK doubleValue];
    
    EQ[clickIndexEQ].R.blow = [ILTFblow intValue];
    EQ[clickIndexEQ].R.slash = [ILTFslash intValue];
    EQ[clickIndexEQ].R.stub = [ILTFstub intValue];
    EQ[clickIndexEQ].R.arrow = [ILTFarrow intValue];
    EQ[clickIndexEQ].R.gun = [ILTFgun intValue];
    EQ[clickIndexEQ].R.shell = [ILTFshell intValue];
    EQ[clickIndexEQ].R.paralysis = [ILTFparalysis intValue];
    EQ[clickIndexEQ].R.poison = [ILTFpoison intValue];
    EQ[clickIndexEQ].R.charm = [ILTFcharm intValue];
    EQ[clickIndexEQ].R.confusion = [ILTFconfusion intValue];
    EQ[clickIndexEQ].R.sleep = [ILTFsleep intValue];
    EQ[clickIndexEQ].R.silent = [ILTFsilent intValue];
    
    EQ[clickIndexEQ].R.flame = [ILTFflame intValue];
    EQ[clickIndexEQ].R.cold = [ILTFcold intValue];
    EQ[clickIndexEQ].R.electoric = [ILTFelectoric intValue];
    EQ[clickIndexEQ].R.air = [ILTFair intValue];
    EQ[clickIndexEQ].R.water = [ILTFwater intValue];
    EQ[clickIndexEQ].R.gas = [ILTFgas intValue];
    EQ[clickIndexEQ].R.holy = [ILTFholy intValue];
    EQ[clickIndexEQ].R.dark = [ILTFdark intValue];
    EQ[clickIndexEQ].R.explosion = [ILTFexplosion intValue];
    EQ[clickIndexEQ].R.blood = [ILTFblood intValue];
    
    EQ[clickIndexEQ].recHP = [ILTFrecHP intValue];
    EQ[clickIndexEQ].recpHP = [ILTFrecHPp intValue];
    EQ[clickIndexEQ].recMP = [ILTFrecMP intValue];
    EQ[clickIndexEQ].recpMP = [ILTFrecMPp intValue];
    EQ[clickIndexEQ].comment = [[ILTFcomment stringValue] retain];
    
    EQ[clickIndexEQ].type = (int)[ILPUBtype indexOfSelectedItem];
    
    [equipListAC setValue:[NSString stringWithFormat:@"%@", EQ[clickIndexEQ].name] forKeyPath:@"selection.name"];
    
    NSString *str = @"";
    
    if(EQ[clickIndexEQ].HP != 0)
        str = [str stringByAppendingFormat:@"HP %d ", (int)EQ[clickIndexEQ].HP];
    if(EQ[clickIndexEQ].MP != 0)
        str = [str stringByAppendingFormat:@"MP %d ", (int)EQ[clickIndexEQ].MP];
    if(EQ[clickIndexEQ].STR != 0)
        str = [str stringByAppendingFormat:@"STR %d ", (int)EQ[clickIndexEQ].STR];
    if(EQ[clickIndexEQ].VIT != 0)
        str = [str stringByAppendingFormat:@"VIT %d ", (int)EQ[clickIndexEQ].VIT];
    if(EQ[clickIndexEQ].AGI != 0)
        str = [str stringByAppendingFormat:@"AGI %d ", (int)EQ[clickIndexEQ].AGI];
    if(EQ[clickIndexEQ].DEX != 0)
        str = [str stringByAppendingFormat:@"DEX %d ", (int)EQ[clickIndexEQ].DEX];
    if(EQ[clickIndexEQ].MEN != 0)
        str = [str stringByAppendingFormat:@"MEN %d ", (int)EQ[clickIndexEQ].MEN];
    if(EQ[clickIndexEQ].INT != 0)
        str = [str stringByAppendingFormat:@"INT %d ", (int)EQ[clickIndexEQ].INT];
    if(EQ[clickIndexEQ].LUK != 0)
        str = [str stringByAppendingFormat:@"LUK %d ", (int)EQ[clickIndexEQ].LUK];
    if(EQ[clickIndexEQ].Weight != 0)
        str = [str stringByAppendingFormat:@"重さ %d ", (int)EQ[clickIndexEQ].Weight];
    
    [equipListAC setValue:[NSString stringWithFormat:@"%@", str] forKeyPath:@"selection.memo"];
    
    [self saveEquip];
    [UCLPanelEquipDetail close];
}

-(void)saveEquip{
    
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    for (int i=0; i<eItemNum; i++) {
        NSString *fdata = @"data/ItemList/ILdata";
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        NSString *fileData = @"";
       
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", EQ[i].name]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", EQ[i].nameRecognition]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", EQ[i].nameID]] stringByAppendingString:@"\n"];
        
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].price]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].Weight]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].type]] stringByAppendingString:@"\n"];
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].HP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].MP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].AP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].WT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].MOV]] stringByAppendingString:@"\n"];
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].STR]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].VIT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].AGI]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].DEX]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].MEN]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].INT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].LUK]] stringByAppendingString:@"\n"];
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].pSTR]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].pVIT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].pAGI]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].pDEX]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].pMEN]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].pINT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].pLUK]] stringByAppendingString:@"\n"];
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].recHP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].recpHP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].recMP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].recpMP]] stringByAppendingString:@"\n"];
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.blow]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.slash]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.stub]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.arrow]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.gun]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.shell]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.paralysis]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.poison]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.charm]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.confusion]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.sleep]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.silent]] stringByAppendingString:@"\n"];
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.flame]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.cold]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.electoric]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.air]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.water]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.gas]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.holy]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.dark]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.explosion]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].R.blood]] stringByAppendingString:@"\n"];
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", EQ[i].comment]] stringByAppendingString:@"\n"];
               fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"----\n"]];
        
        [fileData writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    

    
}

-(IBAction)canceIL:(id)sender{
    [UCLPanelEquipDetail close];
}

-(void)ClickAL:(id)sender{
    clickedRowAT = (int)[attackListTV clickedRow];
}

-(void)doubleClickAL:(id)sender{
    
    
    if(EQmodeFlag){
        if(clickIndexEQ < 0) return;
        atkTop = EQ[clickIndexEQ].A;
        
        clickIndexAL = [attackListTV clickedRow];
        
        [self willChangeValueForKey:@"damageListMA"];
        [damageListMA removeAllObjects];
        [self didChangeValueForKey:@"damageListMA"];
        
        [self willChangeValueForKey:@"hitListMA"];
        [hitListMA removeAllObjects];
        [self didChangeValueForKey:@"hitListMA"];
        
        if(clickIndexAL <= -1) return;
        
        for(int i = 0;i < clickIndexAL;i++){
            EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
        }
        
        [ALTFname setStringValue:EQ[clickIndexEQ].A->name];
        [ALTFrangeA setIntValue:EQ[clickIndexEQ].A->rangeA];
        [ALTFrangeB setIntValue:EQ[clickIndexEQ].A->rangeB];
        [ALTFextend setIntValue:EQ[clickIndexEQ].A->extent];
        
        [ALTFtrigger setIntValue:EQ[clickIndexEQ].A->trig];
        [ALTFmelee setIntValue:EQ[clickIndexEQ].A->melee];
        [ALTFpass setIntValue:EQ[clickIndexEQ].A->P];
        [ALTFdmgExtent setIntValue:EQ[clickIndexEQ].A->dmgExtend];
        [ALPUBwType selectItemAtIndex:EQ[clickIndexEQ].A->type];
        
        [ALPUBtype removeAllItems];
        [ALPUBtype addItemWithTitle:@"攻撃力"];
        [ALPUBtype addItemWithTitle:@"防御力"];
        [ALPUBtype addItemWithTitle:@"命中値"];
        [ALPUBtype addItemWithTitle:@"回避値"];
        [ALPUBtype addItemWithTitle:@"演算力"];
        [ALPUBtype addItemWithTitle:@"無修正"];
        
        [ALPUBcost removeAllItems];
        [ALPUBcost addItemWithTitle:@"MP"];
        [ALPUBcost addItemWithTitle:@"AP"];
        [ALPUBcost addItemWithTitle:@"HP"];
        [ALPUBcost selectItemAtIndex:EQ[clickIndexEQ].A->costType];
        if(EQ[clickIndexEQ].A->costType == 0){
            [ALTFcost setIntValue:EQ[clickIndexEQ].A->MP];
            [ALTFcostP setIntValue:EQ[clickIndexEQ].A->pMP];
        }else if(EQ[clickIndexEQ].A->costType == 1){
            [ALTFcost setIntValue:EQ[clickIndexEQ].A->AP];
            [ALTFcostP setIntValue:EQ[clickIndexEQ].A->pAP];
        }else if(EQ[clickIndexEQ].A->costType == 2){
            [ALTFcost setIntValue:EQ[clickIndexEQ].A->HP];
            [ALTFcostP setIntValue:EQ[clickIndexEQ].A->pHP];
        }
        
        [ALTFbullet setIntValue:EQ[clickIndexEQ].A->bullet];
        [ALTFhitCount setIntValue:EQ[clickIndexEQ].A->hitCount];
        [ALTFsuccessRate setIntValue:EQ[clickIndexEQ].A->successRate];
        [ALTFvigor setIntValue:EQ[clickIndexEQ].A->vigor];
        [ALTFhitRate setIntValue:EQ[clickIndexEQ].A->hitPercent];
        
        [ALPUBriku selectItemAtIndex:EQ[clickIndexEQ].A->riku];
        [ALPUBchu selectItemAtIndex:EQ[clickIndexEQ].A->chu];
        [ALPUBumi selectItemAtIndex:EQ[clickIndexEQ].A->umi];
        [ALPUBsora selectItemAtIndex:EQ[clickIndexEQ].A->sora];
        
        [ALTFcSupply setIntValue:EQ[clickIndexEQ].A->cSupply];
        [ALTFcFood setIntValue:EQ[clickIndexEQ].A->cFood];
        [ALTFcMoney setIntValue:EQ[clickIndexEQ].A->cMoney];
        
        [ALTFcmd setStringValue:EQ[clickIndexEQ].A->cmd];
        if(EQ[clickIndexEQ].A->msg != NULL) [ALTFmsg setStringValue:EQ[clickIndexEQ].A->msg];
        
        DAMAGE *Dtop = EQ[clickIndexEQ].A->D;
        do{
            
            NSMutableDictionary* dict = [NSMutableDictionary new];
            if(!EQ[clickIndexEQ].A->D){
                [dict setValue:[NSString stringWithFormat:@""] forKey:@"count"];
            }
            else if(EQ[clickIndexEQ].A->D->count > 0 || EQ[clickIndexEQ].A->D->pCount > 0){
                if(EQ[clickIndexEQ].A->D->type == 0)
                    [dict setValue:[NSString stringWithFormat:@"攻%g+%g％", EQ[clickIndexEQ].A->D->count, EQ[clickIndexEQ].A->D->pCount] forKey:@"count"];
                if(EQ[clickIndexEQ].A->D->type == 1)
                    [dict setValue:[NSString stringWithFormat:@"防%g+%g％", EQ[clickIndexEQ].A->D->count, EQ[clickIndexEQ].A->D->pCount] forKey:@"count"];
                if(EQ[clickIndexEQ].A->D->type == 2)
                    [dict setValue:[NSString stringWithFormat:@"命%g+%g％", EQ[clickIndexEQ].A->D->count, EQ[clickIndexEQ].A->D->pCount] forKey:@"count"];
                if(EQ[clickIndexEQ].A->D->type == 3)
                    [dict setValue:[NSString stringWithFormat:@"回%g+%g％", EQ[clickIndexEQ].A->D->count, EQ[clickIndexEQ].A->D->pCount] forKey:@"count"];
                if(EQ[clickIndexEQ].A->D->type == 4)
                    [dict setValue:[NSString stringWithFormat:@"演%g+%g％", EQ[clickIndexEQ].A->D->count, EQ[clickIndexEQ].A->D->pCount] forKey:@"count"];
                if(EQ[clickIndexEQ].A->D->type == 5)
                    [dict setValue:[NSString stringWithFormat:@"会%g%g％", EQ[clickIndexEQ].A->D->count, EQ[clickIndexEQ].A->D->pCount] forKey:@"count"];
            }
            NSString *str;
            
            if(EQ[clickIndexEQ].A->D){
                if(EQ[clickIndexEQ].A->D->sort == 0) str = [NSString stringWithFormat:@"ダ・"];
                if(EQ[clickIndexEQ].A->D->sort == 1) str = [NSString stringWithFormat:@"回・"];
                if(EQ[clickIndexEQ].A->D->sort == 2) str = [NSString stringWithFormat:@"復・"];
                if(EQ[clickIndexEQ].A->D->sort == 3) str = [NSString stringWithFormat:@"減・"];
                if(EQ[clickIndexEQ].A->D->sort == 4) str = [NSString stringWithFormat:@"増・"];
                if(EQ[clickIndexEQ].A->D->sort == 5) str = [NSString stringWithFormat:@"毒・"];
                if(EQ[clickIndexEQ].A->D->sort == 6) str = [NSString stringWithFormat:@"睡・"];
                if(EQ[clickIndexEQ].A->D->sort == 7) str = [NSString stringWithFormat:@"混・"];
                if(EQ[clickIndexEQ].A->D->sort == 8) str = [NSString stringWithFormat:@"麻・"];
                if(EQ[clickIndexEQ].A->D->sort == 9) str = [NSString stringWithFormat:@"沈・"];
                if(EQ[clickIndexEQ].A->D->sort == 10) str = [NSString stringWithFormat:@"魅・"];
                
                if(EQ[clickIndexEQ].A->D->seed == 0) str = [str stringByAppendingFormat:@"打撃"];
                if(EQ[clickIndexEQ].A->D->seed == 1) str = [str stringByAppendingFormat:@"斬撃"];
                if(EQ[clickIndexEQ].A->D->seed == 2) str = [str stringByAppendingFormat:@"突き"];
                if(EQ[clickIndexEQ].A->D->seed == 3) str = [str stringByAppendingFormat:@"射手"];
                if(EQ[clickIndexEQ].A->D->seed == 4) str = [str stringByAppendingFormat:@"銃撃"];
                if(EQ[clickIndexEQ].A->D->seed == 5) str = [str stringByAppendingFormat:@"砲撃"];
                if(EQ[clickIndexEQ].A->D->seed == 6) str = [str stringByAppendingFormat:@"火炎"];
                if(EQ[clickIndexEQ].A->D->seed == 7) str = [str stringByAppendingFormat:@"冷気"];
                if(EQ[clickIndexEQ].A->D->seed == 8) str = [str stringByAppendingFormat:@"電撃"];
                if(EQ[clickIndexEQ].A->D->seed == 9) str = [str stringByAppendingFormat:@"風圧"];
                if(EQ[clickIndexEQ].A->D->seed == 10) str = [str stringByAppendingFormat:@"流水"];
                if(EQ[clickIndexEQ].A->D->seed == 11) str = [str stringByAppendingFormat:@"ガス"];
                if(EQ[clickIndexEQ].A->D->seed == 12) str = [str stringByAppendingFormat:@"神聖"];
                if(EQ[clickIndexEQ].A->D->seed == 13) str = [str stringByAppendingFormat:@"暗黒"];
                if(EQ[clickIndexEQ].A->D->seed == 14) str = [str stringByAppendingFormat:@"爆撃"];
                if(EQ[clickIndexEQ].A->D->seed == 15) str = [str stringByAppendingFormat:@"流血"];
                
                [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"type"];
            }
            
            if(EQ[clickIndexEQ].A->D){
                if(EQ[clickIndexEQ].A->D->count <= 0 && EQ[clickIndexEQ].A->D->sort == 0)
                {
                    EQ[clickIndexEQ].A->D = NULL;
                    break;
                }
                [self willChangeValueForKey:@"damageListMA"];
                [damageListMA addObject:dict];
                [self didChangeValueForKey:@"damageListMA"];
                
                EQ[clickIndexEQ].A->D = EQ[clickIndexEQ].A->D->next;
            }
        }while(EQ[clickIndexEQ].A->D != NULL);
        
        EQ[clickIndexEQ].A->D = Dtop;
        
        DMGEXTEND *Etop = EQ[clickIndexEQ].A->E;
        while(EQ[clickIndexEQ].A->E != NULL){
            
            NSMutableDictionary* dict = [NSMutableDictionary new];
            
            
            [dict setValue:[NSString stringWithFormat:@"%d", EQ[clickIndexEQ].A->E->rate] forKey:@"rate"];
            [dict setValue:[NSString stringWithFormat:@"%d", EQ[clickIndexEQ].A->E->atkHit] forKey:@"atkHit"];
            [dict setValue:[NSString stringWithFormat:@"%d", EQ[clickIndexEQ].A->E->hit] forKey:@"hit"];
            
            [self willChangeValueForKey:@"hitListMA"];
            [hitListMA addObject:dict];
            [self didChangeValueForKey:@"hitListMA"];
            
            EQ[clickIndexEQ].A->E = EQ[clickIndexEQ].A->E->next;
        };
        
        EQ[clickIndexEQ].A->E = Etop;
        
        EQ[clickIndexEQ].A = atkTop;
        
    
        UCLDpoint.x = [UCLPanelAttack frame].origin.x + 0;
        UCLDpoint.y = [UCLPanelAttack frame].origin.y + 0;
        [UCLPanelAttackDetail setFrameOrigin:UCLDpoint];
        [UCLPanelAttackDetail makeKeyAndOrderFront:nil];
        
        return;
    }
    
    if(!loadChipSideFlag){
    
    atkTop = UC[clickIndex].A;
    
    clickIndexAL = [attackListTV clickedRow];
    
        
    [self willChangeValueForKey:@"damageListMA"];
    [damageListMA removeAllObjects];
    [self didChangeValueForKey:@"damageListMA"];
    
    [self willChangeValueForKey:@"hitListMA"];
    [hitListMA removeAllObjects];
    [self didChangeValueForKey:@"hitListMA"];
    
    if(clickIndexAL <= -1) return;
        
    NSLog(@"%@, %ld", atkTop->name, clickIndexAL);
        
    for(int i = 0;i < clickIndexAL;i++){
        UC[clickIndex].A = UC[clickIndex].A->next;
    }
        
    [ALTFname setStringValue:UC[clickIndex].A->name];
    [ALTFrangeA setIntValue:UC[clickIndex].A->rangeA];
    [ALTFrangeB setIntValue:UC[clickIndex].A->rangeB];
    [ALTFextend setIntValue:UC[clickIndex].A->extent];
    
    [ALTFtrigger setIntValue:UC[clickIndex].A->trig];
    [ALTFmelee setIntValue:UC[clickIndex].A->melee];
    [ALTFpass setIntValue:UC[clickIndex].A->P];
    [ALTFdmgExtent setIntValue:UC[clickIndex].A->dmgExtend];
    [ALPUBwType selectItemAtIndex:UC[clickIndex].A->type];
    
        [ALPUBtype removeAllItems];
        [ALPUBtype addItemWithTitle:@"攻撃力"];
        [ALPUBtype addItemWithTitle:@"防御力"];
        [ALPUBtype addItemWithTitle:@"命中値"];
        [ALPUBtype addItemWithTitle:@"回避値"];
        [ALPUBtype addItemWithTitle:@"演算力"];
        [ALPUBtype addItemWithTitle:@"無修正"];
        
    [ALPUBcost removeAllItems];
    [ALPUBcost addItemWithTitle:@"MP"];
        [ALPUBcost addItemWithTitle:@"AP"];
        [ALPUBcost addItemWithTitle:@"HP"];
    [ALPUBcost selectItemAtIndex:UC[clickIndex].A->costType];
    if(UC[clickIndex].A->costType == 0){
        [ALTFcost setIntValue:UC[clickIndex].A->MP];
        [ALTFcostP setIntValue:UC[clickIndex].A->pMP];
    }else if(UC[clickIndex].A->costType == 1){
        [ALTFcost setIntValue:UC[clickIndex].A->AP];
        [ALTFcostP setIntValue:UC[clickIndex].A->pAP];
    }else if(UC[clickIndex].A->costType == 2){
            [ALTFcost setIntValue:UC[clickIndex].A->HP];
            [ALTFcostP setIntValue:UC[clickIndex].A->pHP];
    }
    
    [ALTFbullet setIntValue:UC[clickIndex].A->bullet];
    [ALTFhitCount setIntValue:UC[clickIndex].A->hitCount];
    [ALTFsuccessRate setIntValue:UC[clickIndex].A->successRate];
    [ALTFvigor setIntValue:UC[clickIndex].A->vigor];
    [ALTFhitRate setIntValue:UC[clickIndex].A->hitPercent];
    
    [ALPUBriku selectItemAtIndex:UC[clickIndex].A->riku];
    [ALPUBchu selectItemAtIndex:UC[clickIndex].A->chu];
    [ALPUBumi selectItemAtIndex:UC[clickIndex].A->umi];
    [ALPUBsora selectItemAtIndex:UC[clickIndex].A->sora];
    
    [ALTFcSupply setIntValue:UC[clickIndex].A->cSupply];
    [ALTFcFood setIntValue:UC[clickIndex].A->cFood];
    [ALTFcMoney setIntValue:UC[clickIndex].A->cMoney];
    
    [ALTFcmd setStringValue:UC[clickIndex].A->cmd];
    if(UC[clickIndex].A->msg != NULL)
        [ALTFmsg setStringValue:UC[clickIndex].A->msg];
    
    DAMAGE *Dtop = UC[clickIndex].A->D;
    do{
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    if(!UC[clickIndex].A->D){
        [dict setValue:[NSString stringWithFormat:@""] forKey:@"count"];
    }
    else if(UC[clickIndex].A->D->count > 0 || UC[clickIndex].A->D->pCount > 0){
    if(UC[clickIndex].A->D->type == 0)
            [dict setValue:[NSString stringWithFormat:@"攻%g+%g％", UC[clickIndex].A->D->count, UC[clickIndex].A->D->pCount] forKey:@"count"];
    if(UC[clickIndex].A->D->type == 1)
        [dict setValue:[NSString stringWithFormat:@"防%g+%g％", UC[clickIndex].A->D->count, UC[clickIndex].A->D->pCount] forKey:@"count"];
    if(UC[clickIndex].A->D->type == 2)
        [dict setValue:[NSString stringWithFormat:@"命%g+%g％", UC[clickIndex].A->D->count, UC[clickIndex].A->D->pCount] forKey:@"count"];
    if(UC[clickIndex].A->D->type == 3)
        [dict setValue:[NSString stringWithFormat:@"回%g+%g％", UC[clickIndex].A->D->count, UC[clickIndex].A->D->pCount] forKey:@"count"];
    if(UC[clickIndex].A->D->type == 4)
        [dict setValue:[NSString stringWithFormat:@"演%g+%g％", UC[clickIndex].A->D->count, UC[clickIndex].A->D->pCount] forKey:@"count"];
    if(UC[clickIndex].A->D->type == 5)
        [dict setValue:[NSString stringWithFormat:@"会%g%g％", UC[clickIndex].A->D->count, UC[clickIndex].A->D->pCount] forKey:@"count"];
    }
    NSString *str;
    
        if(UC[clickIndex].A->D){
    if(UC[clickIndex].A->D->sort == 0) str = [NSString stringWithFormat:@"ダ・"];
    if(UC[clickIndex].A->D->sort == 1) str = [NSString stringWithFormat:@"回・"];
    if(UC[clickIndex].A->D->sort == 2) str = [NSString stringWithFormat:@"復・"];
    if(UC[clickIndex].A->D->sort == 3) str = [NSString stringWithFormat:@"減・"];
    if(UC[clickIndex].A->D->sort == 4) str = [NSString stringWithFormat:@"増・"];
    if(UC[clickIndex].A->D->sort == 5) str = [NSString stringWithFormat:@"毒・"];
    if(UC[clickIndex].A->D->sort == 6) str = [NSString stringWithFormat:@"睡・"];
    if(UC[clickIndex].A->D->sort == 7) str = [NSString stringWithFormat:@"混・"];
    if(UC[clickIndex].A->D->sort == 8) str = [NSString stringWithFormat:@"麻・"];
    if(UC[clickIndex].A->D->sort == 9) str = [NSString stringWithFormat:@"沈・"];
    if(UC[clickIndex].A->D->sort == 10) str = [NSString stringWithFormat:@"魅・"];
    
    if(UC[clickIndex].A->D->seed == 0) str = [str stringByAppendingFormat:@"打撃"];
    if(UC[clickIndex].A->D->seed == 1) str = [str stringByAppendingFormat:@"斬撃"];
    if(UC[clickIndex].A->D->seed == 2) str = [str stringByAppendingFormat:@"突き"];
    if(UC[clickIndex].A->D->seed == 3) str = [str stringByAppendingFormat:@"射手"];
    if(UC[clickIndex].A->D->seed == 4) str = [str stringByAppendingFormat:@"銃撃"];
    if(UC[clickIndex].A->D->seed == 5) str = [str stringByAppendingFormat:@"砲撃"];
    if(UC[clickIndex].A->D->seed == 6) str = [str stringByAppendingFormat:@"火炎"];
    if(UC[clickIndex].A->D->seed == 7) str = [str stringByAppendingFormat:@"冷気"];
    if(UC[clickIndex].A->D->seed == 8) str = [str stringByAppendingFormat:@"電撃"];
    if(UC[clickIndex].A->D->seed == 9) str = [str stringByAppendingFormat:@"風圧"];
    if(UC[clickIndex].A->D->seed == 10) str = [str stringByAppendingFormat:@"流水"];
    if(UC[clickIndex].A->D->seed == 11) str = [str stringByAppendingFormat:@"ガス"];
    if(UC[clickIndex].A->D->seed == 12) str = [str stringByAppendingFormat:@"神聖"];
    if(UC[clickIndex].A->D->seed == 13) str = [str stringByAppendingFormat:@"暗黒"];
    if(UC[clickIndex].A->D->seed == 14) str = [str stringByAppendingFormat:@"爆撃"];
    if(UC[clickIndex].A->D->seed == 15) str = [str stringByAppendingFormat:@"流血"];
    
    [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"type"];
        }
    
        if(UC[clickIndex].A->D){
            if(UC[clickIndex].A->D->count <= 0 && UC[clickIndex].A->D->sort == 0)
            {
                UC[clickIndex].A->D = NULL;
                break;
            }
            [self willChangeValueForKey:@"damageListMA"];
            [damageListMA addObject:dict];
            [self didChangeValueForKey:@"damageListMA"];
        
        UC[clickIndex].A->D = UC[clickIndex].A->D->next;
    }
    }while(UC[clickIndex].A->D != NULL);
    
    UC[clickIndex].A->D = Dtop;
    
    DMGEXTEND *Etop = UC[clickIndex].A->E;
    while(UC[clickIndex].A->E != NULL){

        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        
        [dict setValue:[NSString stringWithFormat:@"%d", UC[clickIndex].A->E->rate] forKey:@"rate"];
        [dict setValue:[NSString stringWithFormat:@"%d", UC[clickIndex].A->E->atkHit] forKey:@"atkHit"];
        [dict setValue:[NSString stringWithFormat:@"%d", UC[clickIndex].A->E->hit] forKey:@"hit"];
        
        [self willChangeValueForKey:@"hitListMA"];
        [hitListMA addObject:dict];
        [self didChangeValueForKey:@"hitListMA"];
        
       UC[clickIndex].A->E = UC[clickIndex].A->E->next;
    };
    
    UC[clickIndex].A->E = Etop;
    
    UC[clickIndex].A = atkTop;
        
        
    }else{
    
        atkTop = LC[cil].A;
        
        clickIndexAL = [attackListTV clickedRow];
        
        [self willChangeValueForKey:@"damageListMA"];
        [damageListMA removeAllObjects];
        [self didChangeValueForKey:@"damageListMA"];
        
        [self willChangeValueForKey:@"hitListMA"];
        [hitListMA removeAllObjects];
        [self didChangeValueForKey:@"hitListMA"];
        
        if(clickIndexAL <= -1) return;
        
        for(int i = 0;i < clickIndexAL;i++){
            LC[cil].A = LC[cil].A->next;
        }
        
        [ALTFname setStringValue:LC[cil].A->name];
        [ALTFrangeA setIntValue:LC[cil].A->rangeA];
        [ALTFrangeB setIntValue:LC[cil].A->rangeB];
        [ALTFextend setIntValue:LC[cil].A->extent];
        
        [ALTFtrigger setIntValue:LC[cil].A->trig];
        [ALTFmelee setIntValue:LC[cil].A->melee];
        [ALTFpass setIntValue:LC[cil].A->P];
        [ALTFdmgExtent setIntValue:LC[cil].A->dmgExtend];
        [ALPUBwType selectItemAtIndex:LC[cil].A->type];
        
        [ALPUBtype removeAllItems];
        [ALPUBtype addItemWithTitle:@"攻撃力"];
        
        [ALPUBcost removeAllItems];
        [ALPUBcost addItemWithTitle:@"EN"];
        [ALPUBcost addItemWithTitle:@"HP"];
        [ALPUBcost selectItemAtIndex:LC[cil].A->costType];
        if(1){
            if(LC[cil].A->costType == 0){
                [ALTFcost setIntValue:LC[cil].A->EN];
                [ALTFcostP setIntValue:LC[cil].A->pEN];
            }
            if(LC[cil].A->costType == 1){
                [ALTFcost setIntValue:LC[cil].A->HP];
                [ALTFcostP setIntValue:LC[cil].A->pHP];
            }
        }
        [ALTFbullet setIntValue:LC[cil].A->bullet];
        [ALTFhitCount setIntValue:LC[cil].A->hitCount];
        [ALTFsuccessRate setIntValue:LC[cil].A->successRate];
        [ALTFvigor setIntValue:LC[cil].A->vigor];
        [ALTFhitRate setIntValue:LC[cil].A->hitPercent];
        
        [ALPUBriku selectItemAtIndex:LC[cil].A->riku];
        [ALPUBchu selectItemAtIndex:LC[cil].A->chu];
        [ALPUBumi selectItemAtIndex:LC[cil].A->umi];
        [ALPUBsora selectItemAtIndex:LC[cil].A->sora];
        
        [ALTFcSupply setIntValue:LC[cil].A->cSupply];
        [ALTFcFood setIntValue:LC[cil].A->cFood];
        [ALTFcMoney setIntValue:LC[cil].A->cMoney];
        
        [ALTFcmd setStringValue:LC[cil].A->cmd];
        if(LC[cil].A->msg != NULL) [ALTFmsg setStringValue:LC[cil].A->msg];
        
        DAMAGE *Dtop = LC[cil].A->D;
        do{
            
            NSMutableDictionary* dict = [NSMutableDictionary new];
            if(!LC[cil].A->D){
                [dict setValue:[NSString stringWithFormat:@""] forKey:@"count"];
            }
            else if(LC[cil].A->D->count > 0 || LC[cil].A->D->pCount > 0){
                    [dict setValue:[NSString stringWithFormat:@"攻%g+%g％", LC[cil].A->D->count, LC[cil].A->D->pCount] forKey:@"count"];
            }
            NSString *str;
            
            if(LC[cil].A->D){
                if(LC[cil].A->D->sort == 0) str = [NSString stringWithFormat:@"ダ・"];
                if(LC[cil].A->D->sort == 1) str = [NSString stringWithFormat:@"回・"];
                if(LC[cil].A->D->sort == 2) str = [NSString stringWithFormat:@"復・"];
                if(LC[cil].A->D->sort == 3) str = [NSString stringWithFormat:@"減・"];
                if(LC[cil].A->D->sort == 4) str = [NSString stringWithFormat:@"増・"];
                if(LC[cil].A->D->sort == 5) str = [NSString stringWithFormat:@"毒・"];
                if(LC[cil].A->D->sort == 6) str = [NSString stringWithFormat:@"睡・"];
                if(LC[cil].A->D->sort == 7) str = [NSString stringWithFormat:@"混・"];
                if(LC[cil].A->D->sort == 8) str = [NSString stringWithFormat:@"麻・"];
                if(LC[cil].A->D->sort == 9) str = [NSString stringWithFormat:@"沈・"];
                if(LC[cil].A->D->sort == 10) str = [NSString stringWithFormat:@"魅・"];
                
                if(LC[cil].A->D->seed == 0) str = [str stringByAppendingFormat:@"打撃"];
                if(LC[cil].A->D->seed == 1) str = [str stringByAppendingFormat:@"斬撃"];
                if(LC[cil].A->D->seed == 2) str = [str stringByAppendingFormat:@"突き"];
                if(LC[cil].A->D->seed == 3) str = [str stringByAppendingFormat:@"射手"];
                if(LC[cil].A->D->seed == 4) str = [str stringByAppendingFormat:@"銃撃"];
                if(LC[cil].A->D->seed == 5) str = [str stringByAppendingFormat:@"砲撃"];
                if(LC[cil].A->D->seed == 6) str = [str stringByAppendingFormat:@"火炎"];
                if(LC[cil].A->D->seed == 7) str = [str stringByAppendingFormat:@"冷気"];
                if(LC[cil].A->D->seed == 8) str = [str stringByAppendingFormat:@"電撃"];
                if(LC[cil].A->D->seed == 9) str = [str stringByAppendingFormat:@"風圧"];
                if(LC[cil].A->D->seed == 10) str = [str stringByAppendingFormat:@"流水"];
                if(LC[cil].A->D->seed == 11) str = [str stringByAppendingFormat:@"ガス"];
                if(LC[cil].A->D->seed == 12) str = [str stringByAppendingFormat:@"神聖"];
                if(LC[cil].A->D->seed == 13) str = [str stringByAppendingFormat:@"暗黒"];
                if(LC[cil].A->D->seed == 14) str = [str stringByAppendingFormat:@"爆撃"];
                if(LC[cil].A->D->seed == 15) str = [str stringByAppendingFormat:@"流血"];
                
                [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"type"];
            }
            
            if(LC[cil].A->D){
                if(LC[cil].A->D->count <= 0 && LC[cil].A->D->sort == 0)
                {
                    LC[cil].A->D = NULL;
                    break;
                }
                [self willChangeValueForKey:@"damageListMA"];
                [damageListMA addObject:dict];
                [self didChangeValueForKey:@"damageListMA"];
                
                LC[cil].A->D = LC[cil].A->D->next;
            }
        }while(LC[cil].A->D != NULL);
        
        LC[cil].A->D = Dtop;
        
        DMGEXTEND *Etop = LC[cil].A->E;
        while(LC[cil].A->E != NULL){
            NSMutableDictionary* dict = [NSMutableDictionary new];
            
            
            [dict setValue:[NSString stringWithFormat:@"%d", LC[cil].A->E->rate] forKey:@"rate"];
            [dict setValue:[NSString stringWithFormat:@"%d", LC[cil].A->E->atkHit] forKey:@"atkHit"];
            [dict setValue:[NSString stringWithFormat:@"%d", LC[cil].A->E->hit] forKey:@"hit"];
            
            [self willChangeValueForKey:@"hitListMA"];
            [hitListMA addObject:dict];
            [self didChangeValueForKey:@"hitListMA"];
            
            LC[cil].A->E = LC[cil].A->E->next;
        };
        
        LC[cil].A->E = Etop;
        
        LC[cil].A = atkTop;
    
    
    
    
    
    
    
    }
    
    
    UCLDpoint.x = [UCLPanelAttack frame].origin.x + 0;
    UCLDpoint.y = [UCLPanelAttack frame].origin.y + 0;
    [UCLPanelAttackDetail setFrameOrigin:UCLDpoint];
    [UCLPanelAttackDetail makeKeyAndOrderFront:nil];
}

-(void)doubleClickUCL:(id)sender{
    clickIndex = [unitChipListTV clickedRow];
    
    [TFname setStringValue:UC[clickIndex].name];
    [TFnameN setStringValue:UC[clickIndex].nameNick];
    [TFnameR setStringValue:UC[clickIndex].nameRecognition];
    [TFnameID setStringValue:UC[clickIndex].nameID];
    [TFnameC setStringValue:UC[clickIndex].nameClass];
    
    
    [TFhp setDoubleValue:UC[clickIndex].S_M.HP];
    [TFmp setDoubleValue:UC[clickIndex].S_M.MP];
    [TFap setDoubleValue:UC[clickIndex].S_M.AP];
    [TFwt setDoubleValue:UC[clickIndex].S_M.WT];
    
    [TFbp setStringValue:[NSString stringWithFormat:@"BP %g", UC[clickIndex].S_M.BP]];
    [TFatk setStringValue:[NSString stringWithFormat:@"攻撃力 %g", UC[clickIndex].S_M.ATK]];
    [TFdef setStringValue:[NSString stringWithFormat:@"防御力 %g", UC[clickIndex].S_M.DEF]];
    [TFcap setStringValue:[NSString stringWithFormat:@"演算力 %g", UC[clickIndex].S_M.CAP]];
    [TFacu setStringValue:[NSString stringWithFormat:@"命中値 %g", UC[clickIndex].S_M.ACU]];
    [TFeva setStringValue:[NSString stringWithFormat:@"回避値 %g", UC[clickIndex].S_M.EVA]];
    
    [TFstr setDoubleValue:UC[clickIndex].S_M.STR];
    [TFvit setDoubleValue:UC[clickIndex].S_M.VIT];
    [TFagi setDoubleValue:UC[clickIndex].S_M.AGI];
    [TFdex setDoubleValue:UC[clickIndex].S_M.DEX];
    [TFmen setDoubleValue:UC[clickIndex].S_M.MEN];
    [TFint setDoubleValue:UC[clickIndex].S_M.INT];
    [TFluk setDoubleValue:UC[clickIndex].S_M.LUK];
    [TFmov setIntValue:UC[clickIndex].S_M.MOV];
    
    [TFmel setDoubleValue:UC[clickIndex].S_M.MEL];
    [TFmis setDoubleValue:UC[clickIndex].S_M.MIS];
    [TFhit setDoubleValue:UC[clickIndex].S_M.HIT];
    [TFdod setDoubleValue:UC[clickIndex].S_M.DOD];
    [TFrea setDoubleValue:UC[clickIndex].S_M.REA];
    [TFski setDoubleValue:UC[clickIndex].S_M.SKI];
    
    [TFcSupply setIntValue:UC[clickIndex].S_M.cSupply];
    [TFcFood setIntValue:UC[clickIndex].S_M.cFood];
    [TFcMoney setIntValue:UC[clickIndex].S_M.cMoney];
    [TFcWT setIntValue:UC[clickIndex].S_M.cWT];
    
    [PUPtMons selectItemAtIndex:UC[clickIndex].S_M.typeMONS];
    [PUPtMove selectItemAtIndex:UC[clickIndex].S_M.typeMOVE];
    //[PUPtEquip selectItemAtIndex:UC[clickIndex].S_M.typeMOVE];
    
    [IVimg setImage:UC[clickIndex].img];
    [IVimgBig setImage:UC[clickIndex].imgb];
    [Baura setIntValue:UC[clickIndex].aura];
    
    [self addPUBEquipList];
    [self initEquip];
    
    
    UCLDpoint.x = [UCLPanel frame].origin.x + 50;
    UCLDpoint.y = [UCLPanel frame].origin.y + 100;
    [UCLDetailPanel setFrameOrigin:UCLDpoint];
    [UCLDetailPanel makeKeyAndOrderFront:nil];
}

-(IBAction)saveUCL:(id)sender{
    
    UC[clickIndex].name = [[TFname stringValue] retain];
    UC[clickIndex].nameNick = [[TFnameN stringValue] retain];
    UC[clickIndex].nameRecognition = [[TFnameR stringValue] retain];
    UC[clickIndex].nameID = [[TFnameID stringValue] retain];
    UC[clickIndex].nameClass = [[TFnameC stringValue] retain];
    
    UC[clickIndex].S_M.HP = [TFhp doubleValue];
    UC[clickIndex].S_M.MP = [TFmp doubleValue];
    UC[clickIndex].S_M.AP = [TFap doubleValue];
    UC[clickIndex].S_M.WT = [TFwt doubleValue];
    
    UC[clickIndex].S_M.STR = [TFstr doubleValue];
    UC[clickIndex].S_M.VIT = [TFvit doubleValue];
    UC[clickIndex].S_M.AGI = [TFagi doubleValue];
    UC[clickIndex].S_M.DEX = [TFdex doubleValue];
    UC[clickIndex].S_M.MEN = [TFmen doubleValue];
    UC[clickIndex].S_M.INT = [TFint doubleValue];
    UC[clickIndex].S_M.LUK = [TFluk doubleValue];
    UC[clickIndex].S_M.MOV = [TFmov intValue];
    
    UC[clickIndex].S_M.MEL = [TFmel doubleValue];
    UC[clickIndex].S_M.MIS = [TFmis doubleValue];
    UC[clickIndex].S_M.HIT = [TFhit doubleValue];
    UC[clickIndex].S_M.DOD = [TFdod doubleValue];
    UC[clickIndex].S_M.REA = [TFrea doubleValue];
    UC[clickIndex].S_M.SKI = [TFski doubleValue];
    
    UC[clickIndex].S_M.cSupply = [TFcSupply intValue];
    UC[clickIndex].S_M.cFood = [TFcFood intValue];
    UC[clickIndex].S_M.cMoney = [TFcMoney intValue];
    UC[clickIndex].S_M.cWT = [TFcWT intValue];
    
    UC[clickIndex].S_M.typeMONS = (int)[PUPtMons indexOfSelectedItem];
    UC[clickIndex].S_M.typeMOVE = (int)[PUPtMove indexOfSelectedItem];
    
    UC[clickIndex].img = [[IVimg image] retain];
    UC[clickIndex].imgb = [[IVimgBig image] retain];
    UC[clickIndex].aura = [Baura intValue];
    
    [unitChipListAC setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].name] forKeyPath:@"selection.name"];
    [unitChipListAC setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].nameClass] forKeyPath:@"selection.nameC"];
    [unitChipListAC setValue:[NSString stringWithFormat:@"%g", UC[clickIndex].S_M.HP] forKeyPath:@"selection.HP"];
    [unitChipListAC setValue:[NSString stringWithFormat:@"%g", UC[clickIndex].S_M.BP] forKeyPath:@"selection.BP"];
    [unitChipListAC setValue:UC[clickIndex].img forKeyPath:@"selection.img"];
    [unitChipListAC setValue:UC[clickIndex].imgb forKeyPath:@"selection.imgBig"];
    
    
    [self saveData];
    [self saveDataAL];
    [UCLDetailPanel close];
}
-(IBAction)cancelUCL:(id)sender{
    [UCLDetailPanel close];
}

-(void)initFileDirectory{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/UnitChip/preset.txt"];
    NSString *pathUC = @"data/UnitChip/img";
    NSString *pathDATA2 = @"data/UnitChip/preset.txt";
    NSString *pathUCP = @"data/UnitChip/preset.txt";
    NSString *fileData = nil;
    
    chipNumb = 56;
    UCN = (int)chipNumb;
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathUC withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathUCP contents:nil attributes:nil];
        
        NSString *data0 = @"56";
        [data0 writeToFile:pathUCP atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSString *data1 = @"村人\n村人\nパーサント\n村人,uc1,0\n"
        @"100,50,0,500,5\n30,30,30,30,30,30,0,9\n100,100,100,100,100,100\n100,100,100,100,100\n0,0,0,50,0,500\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc1.png,ucb1.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data2 = @"兵士\n兵士\nソルジャー\n兵士,uc2,0\n"
        @"150,80,0,520,6\n50,40,45,40,35,35,0,12\n120,120,100,100,120,130\n100,100,100,100,100\n0,0,0,50,50,500\n"
        @"80,80,100,80,60,100,"
        @"90,80,150,100,100,100,100,100,80,100,"
        @"100,100,100,100,100,100\nuc2.png,ucb2.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data3 = @"戦士\n戦士\nファイター\n戦士,uc3,0\n"
        @"200,100,0,550,6\n55,50,30,40,40,32,0,14\n130,110,100,100,125,135\n100,100,100,100,100\n0,0,0,80,30,500\n"
        @"90,90,100,100,90,100,"
        @"100,100,120,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc3.png,ucb3.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data4 = @"女蛮族\n女蛮族\nアマゾネス\n女蛮族,uc4,0\n"
        @"120,70,0,480,5\n40,35,50,50,45,36,0,11\n110,130,120,120,130,130\n100,100,100,100,100\n0,0,0,30,40,500\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc4.png,ucb4.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data5 = @"僧徒\n僧徒\nアコライト\n僧徒,uc5,0\n"
        @"130,100,0,540,5\n35,32,40,36,55,50,0,10\n105,110,105,100,125,125\n100,100,100,100,100\n0,0,0,20,100,500\n"
        @"100,100,100,100,100,100,"
        @"100,130,80,100,100,100,50,120,100,100,"
        @"100,100,100,100,100,100\nuc5.png,ucb5.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data6 = @"魔法使い\n魔法使い\nマジシャン\n魔法使い,uc6,0\n"
        @"120,150,0,490,5\n38,32,42,45,50,60,0,10\n105,120,120,120,130,140\n100,100,100,100,100\n0,0,100,30,80,500\n"
        @"100,150,80,90,100,100,"
        @"80,70,60,90,90,70,100,80,80,90,"
        @"100,100,100,100,100,100\nuc6.png,ucb6.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";

        NSString *data7 = @"盗賊\n盗賊\nシーフ\n盗賊,uc7,0\n"
        @"140,90,0,450,6\n45,40,60,50,45,40,0,18\n110,115,130,140,130,145\n100,100,100,100,100\n0,0,0,60,40,500\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc7.png,ucb7.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data8 = @"騎士\n騎士\nナイト\n騎士,uc8,0\n"
        @"225,100,0,500,6\n60,50,50,55,55,50,0,12\n130,125,120,120,125,130\n100,100,100,100,100\n0,0,0,60,80,500\n"
        @"70,70,90,80,50,100,"
        @"80,70,150,90,100,100,100,100,80,100,"
        @"100,100,100,100,100,100\nuc8.png,ucb8.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data9 = @"狂戦士\n狂戦士\nバーサーカー\n狂戦士,uc9,0\n"
        @"255,80,0,470,6\n70,40,55,60,58,40,0,14\n140,110,130,110,130,140\n100,100,100,100,100\n0,0,0,100,50,500\n"
        @"100,100,100,100,100,100,"
        @"100,120,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc9.png,ucb9.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data10 = @"闘技士\n闘技士\nグラディエーター\n闘技士,uc10,0\n"
        @"300,100,0,450,6\n80,45,60,65,60,50,0,15\n135,120,125,120,135,135\n100,100,100,100,100\n0,0,0,80,70,500\n"
        @"80,80,100,80,80,100,"
        @"80,80,120,80,80,100,100,100,80,100,"
        @"100,100,100,100,100,100\nuc10.png,ucb10.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data11 = @"傭兵\n傭兵\nマーシナリ\n傭兵,uc11,0\n"
        @"200,100,0,480,6\n55,40,60,60,55,40,0,15\n120,120,120,120,130,130\n100,100,100,100,100\n0,0,0,60,60,500\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc11.png,ucb11.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data12 = @"弓士\n弓士\nアーチャー\n弓士,uc12,0\n"
        @"180,90,0,500,6\n50,50,55,55,50,50,0,13\n120,120,120,120,120,120\n100,100,100,100,100\n0,0,50,50,50,500\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc12.png,ucb12.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data13 = @"僧侶\n僧侶\nクレリック\n僧侶,uc13,0\n"
        @"160,150,0,500,5\n38,34,50,60,60,60,0,10\n110,110,120,120,125,130\n100,100,100,100,100\n0,0,0,30,150,500\n"
        @"100,100,100,100,100,100,"
        @"80,120,70,80,80,100,50,120,100,100,"
        @"100,100,100,100,100,100\nuc13.png,ucb13.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data14 = @"魔術師\n魔術師\nウィザード\n魔術師,uc14,0\n"
        @"150,200,0,450,5\n40,36,54,58,60,80,0,10\n105,130,130,150,150,150\n100,100,100,100,100\n0,0,200,30,100,500\n"
        @"100,130,80,100,100,100,"
        @"70,50,60,80,90,80,100,70,100,100,"
        @"100,100,100,100,100,100\nuc14.png,ucb14.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data15 = @"祈祷師\n祈祷師\nシャーマン\n祈祷師,uc15,0\n"
        @"140,180,0,520,5\n50,50,50,60,80,60,0,10\n110,120,130,130,140,140\n100,100,100,100,100\n0,0,60,40,50,500\n"
        @"100,100,100,100,100,100,"
        @"80,80,80,80,80,80,80,80,100,100,"
        @"100,100,100,100,100,100\nuc15.png,ucb15.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data16 = @"奇術師\n奇術師\nドルイド\n奇術師,uc16,0\n"
        @"180,150,0,460,5\n45,40,60,75,65,65,0,12\n120,120,130,130,130,150\n100,100,100,100,100\n0,0,40,60,60,500\n"
        @"100,100,100,100,100,100,"
        @"80,90,70,60,80,60,100,60,80,80,"
        @"100,100,100,100,100,100\nuc16.png,ucb16.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data17 = @"魔女\n魔女\nウィッチ\n魔女,uc17,0\n"
        @"130,200,0,480,5\n35,45,55,80,80,80,0,10\n110,130,150,140,150,150\n100,100,100,100,100\n0,0,300,30,150,500\n"
        @"100,100,100,100,100,100,"
        @"90,90,80,80,90,80,130,70,100,100,"
        @"100,100,100,100,100,100\nuc17.png,ucb17.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data18 = @"侍\n侍\nサムライ\n侍,uc18,0\n"
        @"200,100,0,450,6\n70,35,70,70,65,45,0,16\n150,110,150,150,150,150\n100,100,100,100,100\n0,0,0,120,0,500\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc18.png,ucb18.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data19 = @"聖騎士\n聖騎士\nホワイトナイト\n聖騎士,uc19,0\n"
        @"250,150,0,420,6\n98,50,76,82,74,52,0,15\n140,130,160,160,150,150\n100,100,100,100,100\n0,0,0,50,200,500\n"
        @"70,70,80,80,50,100,"
        @"80,80,130,80,80,80,80,120,70,100,"
        @"100,100,100,100,100,100\nuc19.png,ucb19.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data20 = @"黒騎士\n黒騎士\nブラックナイト\n黒騎士,uc20,0\n"
        @"270,180,0,460,6\n82,86,60,80,78,60,0,13\n140,140,150,150,150,150\n100,100,100,100,100\n0,0,0,100,150,500\n"
        @"60,60,60,60,50,100,"
        @"80,70,130,80,80,80,150,50,60,100,"
        @"100,100,100,100,100,100\nuc20.png,ucb20.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data21 = @"亡霊騎士\n亡霊騎士\nスタンジャンナイト\n亡霊騎士,uc21,0\n"
        @"300,200,0,500,6\n120,150,45,60,50,40,0,10\n150,120,120,120,120,120\n100,100,100,100,100\n0,0,300,0,100,500\n"
        @"50,50,50,0,0,150,"
        @"50,0,50,50,50,0,200,30,150,0,"
        @"100,100,100,100,100,100\nuc21.png,ucb21.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data22 = @"王国騎士\n王国騎士\nレギオン\n王国騎士,uc22,0\n"
        @"260,160,0,450,6\n90,90,60,70,70,60,0,14\n150,130,150,150,150,150\n100,100,100,100,100\n0,0,0,100,300,500\n"
        @"60,60,80,60,50,100,"
        @"80,80,120,80,80,80,80,80,60,100,"
        @"100,100,100,100,100,100\nuc22.png,ucb22.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data23 = @"怪盗\n怪盗\nレンジャー\n怪盗,uc23,0\n"
        @"230,200,0,400,6\n76,68,92,98,86,72,0,18\n130,140,160,160,155,160\n100,100,100,100,100\n0,0,100,100,100,500\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc23.png,ucb23.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data24 = @"司祭\n司祭\nプリースト\n司祭,uc24,0\n"
        @"200,250,0,480,6\n60,76,64,82,94,90,0,12\n120,120,150,140,145,150\n100,100,100,100,100\n0,0,0,30,250,500\n"
        @"100,100,100,100,100,100,"
        @"80,80,80,80,80,80,50,90,100,100,"
        @"100,100,100,100,100,100\nuc24.png,ucb24.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data25 = @"言語術士\n言語術士\nワーロック\n言語術士,uc25,0\n"
        @"130,300,0,460,5\n34,46,52,75,120,130,0,12\n105,110,140,120,150,155\n100,100,100,100,100\n0,0,500,30,300,500\n"
        @"100,100,100,100,100,100,"
        @"50,50,50,80,80,80,100,100,100,100,"
        @"100,100,100,100,100,100\nuc25.png,ucb25.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data26 = @"聖女\n聖女\nセイレーン\n聖女,uc26,0\n"
        @"150,255,0,470,5\n38,34,68,80,98,112,0,12\n105,150,150,120,140,150\n100,100,100,100,100\n0,0,300,50,200,500\n"
        @"100,120,100,100,100,100,"
        @"60,70,50,60,80,80,60,80,80,100,"
        @"100,100,100,100,100,100\nuc26.png,ucb26.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data27 = @"言霊使い\n言霊使い\nソーサレス\n言霊使い,uc27,0\n"
        @"170,240,0,460,5\n48,40,78,76,85,98,0,10\n120,130,140,140,145,145\n100,100,100,100,100\n0,0,200,30,100,500\n"
        @"100,120,100,100,100,100,"
        @"70,70,70,70,70,70,70,70,70,70,"
        @"100,100,100,100,100,100\nuc27.png,ucb27.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data28 = @"聖戦士\n聖戦士\nヴァルキリー\n聖戦士,uc28,0\n"
        @"200,200,0,450,5\n55,60,82,96,70,100,0,14\n140,140,140,140,140,150\n100,100,100,100,100\n0,0,500,50,500,500\n"
        @"80,80,100,80,80,100,"
        @"80,80,70,80,70,80,80,90,80,90,"
        @"100,100,100,100,100,100\nuc28.png,ucb28.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data29 = @"聖騎士長\n聖騎士長\nパラディン\n聖騎士長,uc29,0\n"
        @"320,230,0,400,7\n120,100,130,115,100,100,0,14\n150,130,150,150,150,150\n100,100,100,100,100\n0,0,0,50,400,500\n"
        @"60,60,60,60,50,100,"
        @"60,60,100,70,80,80,80,120,80,100,"
        @"100,100,100,100,100,100\nuc29.png,ucb29.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data30 = @"暗黒騎士\n暗黒騎士\nテラーナイト\n暗黒騎士,uc30,0\n"
        @"400,150,0,420,7\n130,130,90,100,94,64,0,12\n150,120,150,150,150,150\n100,100,100,100,100\n0,0,0,100,200,500\n"
        @"50,50,50,50,50,100,"
        @"70,70,100,70,50,50,120,50,50,100,"
        @"100,100,100,100,100,100\nuc30.png,ucb30.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data31 = @"教皇騎士\n教皇騎士\nテンプルナイト\n教皇騎士,uc31,0\n"
        @"360,250,0,400,7\n100,100,100,100,100,100,0,12\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,200,100,300,500\n"
        @"60,60,60,60,50,100,"
        @"50,50,50,50,50,50,50,50,50,100,"
        @"100,100,100,100,100,100\nuc31.png,ucb31.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data32 = @"狙撃手\n狙撃手\nスナイパー\n狙撃手,uc32,0\n"
        @"200,160,0,450,5\n60,50,90,90,80,70,0,13\n110,150,180,130,150,150\n100,100,100,100,100\n0,0,200,100,300,500\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\nuc32.png,ucb32.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data33 = @"司教\n司教\nビショップ\n司教,uc33,0\n"
        @"240,400,0,450,5\n62,80,70,98,110,120,0,10\n125,125,150,150,150,150\n100,100,100,100,100\n0,0,0,50,500,500\n"
        @"100,100,100,100,100,100,"
        @"80,80,80,80,80,80,50,150,100,100,"
        @"100,100,100,100,100,100\nuc33.png,ucb33.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data34 = @"賢者\n賢者\nセイジ\n賢者,uc34,0\n"
        @"230,500,0,400,6\n98,86,94,98,120,150,0,13\n130,140,150,150,150,150\n100,100,100,100,100\n0,0,250,50,250,500\n"
        @"70,70,70,80,80,100,"
        @"50,50,50,50,50,50,50,75,100,100,"
        @"100,100,100,100,100,100\nuc34.png,ucb34.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data35 = @"将軍\n将軍\nジェネラル\n将軍,uc35,0\n"
    
        @"600,300,0,450,6\n150,140,80,130,96,120,0,12\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"60,60,80,50,80,100,"
        @"70,70,80,70,70,70,80,80,70,100,"
        @"100,100,100,100,100,100\nuc35.png,ucb35.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data36 = @"男爵\n男爵\nバロン\n男爵,uc36,0\n"
        @"550,500,0,520,6\n100,180,50,90,120,100,0,9\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"50,50,50,50,25,100,"
        @"70,50,150,50,50,60,100,70,50,100,"
        @"100,100,100,100,100,100\nuc36.png,ucb36.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data37 = @"魔導士\n魔導士\nアークメイジ\n魔導士,uc37,0\n"
        @"200,500,0,450,6\n60,50,78,98,140,140,0,12\n120,130,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"100,100,100,100,100,100,"
        @"50,50,50,50,50,50,70,50,50,70,"
        @"100,100,100,100,100,100\nuc37.png,ucb37.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data38 = @"召喚師\n召喚師\nサモナー\n召喚師,uc38,0\n"
        @"220,550,0,480,5\n50,50,60,80,150,150,0,10\n125,125,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"100,100,100,100,100,100,"
        @"70,70,60,60,60,50,80,60,50,80,"
        @"100,100,100,100,100,100\nuc38.png,ucb38.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data39 = @"古語術士\n古語術士\nルーンマスター\n古語術士,uc39,0\n"
        @"180,600,0,500,5\n90,90,90,90,150,150,0,10\n120,130,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"100,100,100,100,100,100,"
        @"50,50,50,50,50,50,50,50,50,50,"
        @"100,100,100,100,100,100\nuc39.png,ucb39.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data40 = @"死霊使い\n死霊使い\nネクロマンサー\n死霊使い,uc40,0\n"
        @"210,700,0,500,5\n50,60,70,140,150,150,0,10\n130,130,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"100,100,100,100,100,100,"
        @"50,50,50,50,50,50,200,25,50,50,"
        @"100,100,100,100,100,100\nuc40.png,ucb40.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data41 = @"占星術士\n占星術士\nアストロマンサー\n占星術士,uc41,0\n"
        @"250,800,0,400,5\n80,70,120,150,150,150,0,12\n130,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"80,80,80,80,80,80,"
        @"50,50,50,50,50,50,50,50,50,50,"
        @"100,100,100,100,100,100\nuc41.png,ucb41.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data42 = @"元帥\n元帥\nマーシャル\n元帥,uc42,0\n"
        @"500,200,0,500,6\n130,150,60,84,76,85,0,9\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"50,50,50,50,25,100,"
        @"80,60,150,50,60,70,100,70,50,100,"
        @"100,100,100,100,100,100\nuc42.png,ucb42.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        
        NSString *data43 = @"勇者\n勇者\nロード\n勇者,uc43,0\n"
        @"500,250,0,400,6\n125,125,125,125,125,125,0,15\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"75,75,75,75,75,75,"
        @"75,75,75,75,75,75,75,75,75,75,"
        @"100,100,100,100,100,100\nuc43.png,ucb43.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        
        NSString *data44 = @"公爵\n公爵\nデューク\n公爵,uc44,0\n"
        @"430,320,0,400,6\n150,150,120,125,120,120,0,12\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"50,50,50,50,25,100,"
        @"50,50,50,50,50,50,80,50,50,100,"
        @"100,100,100,100,100,100\nuc44.png,ucb44.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";

        NSString *data45 = @"王子\n王子\nプリンス\n王子,uc45,0\n"
        @"600,300,0,400,6\n120,100,100,120,130,120,0,14\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"80,80,80,80,80,80,"
        @"80,80,80,80,80,80,50,100,80,80,"
        @"100,100,100,100,100,100\nuc45.png,ucb45.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data46 = @"王女\n王女\nプリンセス\n王女,uc46,0\n"
        @"500,500,0,500,6\n100,100,100,150,150,150,0,12\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"100,100,100,100,100,100,"
        @"50,50,50,50,50,50,50,50,50,50,"
        @"100,100,100,100,100,100\nuc47.png,ucb47.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data47 = @"枢機卿\n枢機卿\nカーディナル\n枢機卿,uc47,0\n"
        @"400,400,0,550,6\n40,40,80,90,100,120,0,10\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"70,70,70,70,70,70,"
        @"50,50,50,50,50,50,25,50,50,50,"
        @"100,100,100,100,100,100\nuc47.png,ucb47.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data48 = @"大司教\n大司教\nアークビショップ\n大司教,uc48,0\n"
        
        @"450,400,0,400,6\n100,100,120,120,120,120,0,14\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"50,50,50,50,50,50,"
        @"50,50,50,50,50,50,50,50,50,50,"
        @"100,100,100,100,100,100\nuc48.png,ucb48.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data49 = @"教皇\n教皇\nポープ\n教皇,uc49,0\n"
        @"300,900,0,450,6\n50,50,100,150,150,150,0,12\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"100,100,100,100,100,100,"
        @"50,50,50,50,50,50,50,50,50,50,"
        @"100,100,100,100,100,100\nuc49.png,ucb49.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data50 = @"王\n王\nキング\n王,uc50,0\n"
        @"500,250,0,500,6\n50,50,50,100,130,120,0,12\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"80,80,80,80,80,80,"
        @"50,50,50,50,50,50,50,50,50,50,"
        @"100,100,100,100,100,100\nuc50.png,ucb50.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data51 = @"女王\n女王\nクイーン\n女王,uc51,0\n"
        @"500,500,0,450,6\n50,50,50,130,120,100,0,15\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"50,50,50,50,50,50,"
        @"50,50,50,50,50,50,50,50,50,50,"
        @"100,100,100,100,100,100\nuc51.png,ucb51.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";

        NSString *data52 = @"皇帝\n皇帝\nエンペラー\n皇帝,uc52,0\n"
        @"900,800,0,450,6\n150,150,150,150,150,150,0,12\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"50,50,50,50,50,50,"
        @"25,25,25,50,50,50,50,50,50,50,"
        @"100,100,100,100,100,100\nuc52.png,ucb52.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data53 = @"三日月王\n三日月王\nクレセント\n三日月王,uc53,0\n"
        @"1200,1000,150,400,6\n200,160,180,230,220,180,0,15\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"50,50,50,50,50,50,"
        @"25,25,25,25,25,25,50,25,25,50,"
        @"100,100,100,100,100,100\nuc53.png,ucb53.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data54 = @"月の王\n月の王\nセレス\n月の王,uc54,0\n"
        @"1500,1000,200,400,6\n225,200,210,250,255,255,0,15\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"25,25,25,25,25,50,"
        @"25,25,25,25,25,25,25,25,25,50,"
        @"100,100,100,100,100,100\nuc54.png,ucb54.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data55 = @"日蝕王\n日蝕王\nイクリプス\n日蝕王,uc55,0\n"
        @"2500,1500,250,400,6\n250,230,240,250,255,255,0,15\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"10,10,10,10,10,25,"
        @"10,10,10,10,10,25,25,25,25,25,"
        @"100,100,100,100,100,100\nuc55.png,ucb55.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        NSString *data56 = @"彗星王\n彗星王\nコメット\n彗星王,uc56,0\n"
        @"5000,2500,300,400,6\n255,255,255,255,255,255,0,15\n150,150,150,150,150,150\n100,100,100,100,100\n0,0,0,100,1000,500\n"
        @"10,10,10,10,10,10,"
        @"10,10,10,10,10,10,10,10,10,10,"
        @"100,100,100,100,100,100\nuc56.png,ucb56.png\n----\n----\n0,0,0,0\n----\n-1,-1,-1,-1,-1,-1\n\n\n----\n";
        
        for (int i=1; i<=chipNumb; i++) {
            NSString *fdata = @"data/UnitChip/UCdata";
            
            fdata = [fdata stringByAppendingFormat:@"%d.txt", i];
            
            switch (i) {
                case 1:
                    [data1 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 2:
                    [data2 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 3:
                    [data3 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 4:
                    [data4 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 5:
                    [data5 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 6:
                    [data6 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 7:
                    [data7 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 8:
                    [data8 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 9:
                    [data9 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 10:
                    [data10 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 11:
                    [data11 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 12:
                    [data12 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 13:
                    [data13 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 14:
                    [data14 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 15:
                    [data15 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 16:
                    [data16 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 17:
                    [data17 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 18:
                    [data18 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 19:
                    [data19 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 20:
                    [data20 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 21:
                    [data21 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 22:
                    [data22 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 23:
                    [data23 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 24:
                    [data24 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 25:
                    [data25 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 26:
                    [data26 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 27:
                    [data27 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 28:
                    [data28 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 29:
                    [data29 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 30:
                    [data30 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 31:
                    [data31 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 32:
                    [data32 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 33:
                    [data33 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 34:
                    [data34 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 35:
                    [data35 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 36:
                    [data36 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 37:
                    [data37 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 38:
                    [data38 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 39:
                    [data39 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 40:
                    [data40 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 41:
                    [data41 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 42:
                    [data42 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 43:
                    [data43 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 44:
                    [data44 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 45:
                    [data45 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 46:
                    [data46 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 47:
                    [data47 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 48:
                    [data48 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 49:
                    [data49 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 50:
                    [data50 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 51:
                    [data51 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 52:
                    [data52 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 53:
                    [data53 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 54:
                    [data54 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 55:
                    [data55 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 56:
                    [data56 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                
                
                default:
                    
                    break;
            }
            
        }
        
    }
    
    
    
    fileData = [NSString stringWithContentsOfFile:pathUCP encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    int instantNum = [[fileDataArray objectAtIndex:0] intValue];
    
    chipNumb = instantNum;
    UCN = (int)chipNumb;
    
    for (int i=0; i<chipNumb; i++) {
        NSString *fdata = @"data/UnitChip/UCdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        fileDataArray = [fileData componentsSeparatedByString:@"\n"];
        
        UC[i].name = [[fileDataArray objectAtIndex:0] retain];
        UC[i].nameNick = [[fileDataArray objectAtIndex:1] retain];
        UC[i].nameClass = [[fileDataArray objectAtIndex:2] retain];
        
        NSArray *items = [[fileDataArray objectAtIndex:3] componentsSeparatedByString:@","];
        
        UC[i].nameRecognition = [[items objectAtIndex:0] retain];
        UC[i].nameID = [[items objectAtIndex:1] retain];
        UC[i].aura = [[items objectAtIndex:2] intValue];
        
        items = [[fileDataArray objectAtIndex:4] componentsSeparatedByString:@","];
        
        UC[i].S_M.HP = [[items objectAtIndex:0] intValue];
        UC[i].S_M.MP = [[items objectAtIndex:1] intValue];
        UC[i].S_M.AP = [[items objectAtIndex:2] intValue];
        UC[i].S_M.WT = [[items objectAtIndex:3] intValue];
        UC[i].S_M.BP = [[items objectAtIndex:4] intValue];
        
        items = [[fileDataArray objectAtIndex:5] componentsSeparatedByString:@","];
        
        UC[i].S_M.STR = [[items objectAtIndex:0] intValue];
        UC[i].S_M.VIT = [[items objectAtIndex:1] intValue];
        UC[i].S_M.AGI = [[items objectAtIndex:2] intValue];
        UC[i].S_M.DEX = [[items objectAtIndex:3] intValue];
        UC[i].S_M.MEN = [[items objectAtIndex:4] intValue];
        UC[i].S_M.INT = [[items objectAtIndex:5] intValue];
        UC[i].S_M.LUK = [[items objectAtIndex:6] intValue];
        UC[i].S_M.MOV = [[items objectAtIndex:7] intValue];

        items = [[fileDataArray objectAtIndex:6] componentsSeparatedByString:@","];
        
        UC[i].S_M.MEL = [[items objectAtIndex:0] intValue];
        UC[i].S_M.MIS = [[items objectAtIndex:1] intValue];
        UC[i].S_M.HIT = [[items objectAtIndex:2] intValue];
        UC[i].S_M.DOD = [[items objectAtIndex:3] intValue];
        UC[i].S_M.REA = [[items objectAtIndex:4] intValue];
        UC[i].S_M.SKI = [[items objectAtIndex:5] intValue];
        
        items = [[fileDataArray objectAtIndex:7] componentsSeparatedByString:@","];
        
        UC[i].S_M.ATK = [[items objectAtIndex:0] intValue];
        UC[i].S_M.DEF = [[items objectAtIndex:1] intValue];
        UC[i].S_M.CAP = [[items objectAtIndex:2] intValue];
        UC[i].S_M.ACU = [[items objectAtIndex:3] intValue];
        UC[i].S_M.EVA = [[items objectAtIndex:4] intValue];
        
        items = [[fileDataArray objectAtIndex:8] componentsSeparatedByString:@","];
        
        UC[i].S_M.typeMONS = [[items objectAtIndex:0] intValue];
        UC[i].S_M.typeMOVE = [[items objectAtIndex:1] intValue];
        UC[i].S_M.cSupply = [[items objectAtIndex:2] intValue];
        UC[i].S_M.cFood = [[items objectAtIndex:3] intValue];
        UC[i].S_M.cMoney = [[items objectAtIndex:4] intValue];
        UC[i].S_M.cWT = [[items objectAtIndex:5] intValue];
        
        items = [[fileDataArray objectAtIndex:9] componentsSeparatedByString:@","];
        
        UC[i].R_M.blow = [[items objectAtIndex:0] intValue];
        UC[i].R_M.slash = [[items objectAtIndex:1] intValue];
        UC[i].R_M.stub = [[items objectAtIndex:2] intValue];
        UC[i].R_M.arrow = [[items objectAtIndex:3] intValue];
        UC[i].R_M.gun = [[items objectAtIndex:4] intValue];
        UC[i].R_M.shell = [[items objectAtIndex:5] intValue];
        
        UC[i].R_M.flame = [[items objectAtIndex:6] intValue];
        UC[i].R_M.cold = [[items objectAtIndex:7] intValue];
        UC[i].R_M.electoric = [[items objectAtIndex:8] intValue];
        UC[i].R_M.air = [[items objectAtIndex:9] intValue];
        UC[i].R_M.water = [[items objectAtIndex:10] intValue];
        UC[i].R_M.gas = [[items objectAtIndex:11] intValue];
        UC[i].R_M.holy = [[items objectAtIndex:12] intValue];
        UC[i].R_M.dark = [[items objectAtIndex:13] intValue];
        UC[i].R_M.explosion = [[items objectAtIndex:14] intValue];
        UC[i].R_M.blood = [[items objectAtIndex:15] intValue];
        
        UC[i].R_M.paralysis = [[items objectAtIndex:16] intValue];
        UC[i].R_M.confusion = [[items objectAtIndex:17] intValue];
        UC[i].R_M.poison = [[items objectAtIndex:18] intValue];
        UC[i].R_M.sleep = [[items objectAtIndex:19] intValue];
        UC[i].R_M.charm = [[items objectAtIndex:20] intValue];
        UC[i].R_M.silent = [[items objectAtIndex:21] intValue];
        
        items = [[fileDataArray objectAtIndex:10] componentsSeparatedByString:@","];
        
        UC[i].iName = [[items objectAtIndex:0] retain];
        //NSLog(@"%@", UC[i].iName);
        UC[i].iNameb = [[items objectAtIndex:1] retain];
        
        NSString *imgName = @"uc";
        imgName = [imgName stringByAppendingFormat:@"%d", i+1];
        UC[i].img = [[NSImage imageNamed:imgName] retain];
        
        
        imgName = [NSString stringWithFormat:@"ucb"];
        imgName = [imgName stringByAppendingFormat:@"%d", i+1];
        UC[i].imgb = [[NSImage imageNamed:imgName] retain];
        
        NSString *imagePath = @"data/UnitChip/img/uc";
        imagePath = [imagePath stringByAppendingFormat:@"%d", i+1];
        NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
        
        if(imgData)
            UC[i].img = [[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]];
        
        imagePath = [NSString stringWithFormat:@"data/UnitChip/img/ucb"];
        imagePath = [imagePath stringByAppendingFormat:@"%d", i+1];
        imgData = [NSData dataWithContentsOfFile:imagePath];
        
        if(imgData)
            UC[i].imgb = [[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]];

    
        UC[i].S_C = UC[i].S_M;
        UC[i].R_C = UC[i].R_M;
        
        SKILL *SKtop = NULL;
        
        for (int k = 12;![[fileDataArray objectAtIndex:k] isEqualToString:@"----"];k++) {
            items = [[fileDataArray objectAtIndex:k] componentsSeparatedByString:@","];
            if(k == 12) {UC[i].S = calloc(1, sizeof(SKILL));
                SKtop = UC[i].S;
            }
            
            UC[i].S->type = [[items objectAtIndex:0] intValue];
            
            int ins1 = 0;
            int ins2 = 0;
            int ins3 = 0;
            for(int l= 0;[items count] > 1+l;l++){
                if(l%3 == 0) {
                    UC[i].S->list[ins1] = [[items objectAtIndex:1+l] intValue];
                    ins1++;
                }
                if(l%3 == 1) {
                    UC[i].S->cost[ins2] = [[items objectAtIndex:1+l] intValue];
                    ins2++;
                }
                if(l%3 == 2) {
                    UC[i].S->Lv[ins3] = [[items objectAtIndex:1+l] intValue];
                    ins3++;
                }
            }
            
            UC[i].S->next = calloc(1, sizeof(SKILL));
            if(![[fileDataArray objectAtIndex:k+1] isEqualToString:@"----"]) UC[i].S = UC[i].S->next;
        }
        if(UC[i].S) UC[i].S->next = NULL;
        UC[i].S = SKtop;
        
        int oopStart = 12;
        for (int k = 12;![[fileDataArray objectAtIndex:k] isEqualToString:@"----"];k++) {
            oopStart++;
        }
        
        items = [[fileDataArray objectAtIndex:oopStart+1] componentsSeparatedByString:@","];
        
        UC[i].CM.A = [[items objectAtIndex:0] intValue];
        UC[i].CM.B = [[items objectAtIndex:1] intValue];
        UC[i].CM.C = [[items objectAtIndex:2] intValue];
        UC[i].CM.D = [[items objectAtIndex:3] intValue];
        
        items = [[fileDataArray objectAtIndex:oopStart+3] componentsSeparatedByString:@","];
        
        if([[items objectAtIndex:0] intValue] >= 0){
            UC[i].eHandL = EQ[[[items objectAtIndex:0] intValue]];
            UC[i].eHandL.A = EQ[[[items objectAtIndex:0] intValue]].A;
            UC[i].eHandLflag = true;
            if(UC[i].eHandL.type == 7)
                UC[i].eHandRflag = true;
        }
        if([[items objectAtIndex:1] intValue] >= 0){
            UC[i].eHandR = EQ[[[items objectAtIndex:1] intValue]];
            UC[i].eHandR.A = EQ[[[items objectAtIndex:1] intValue]].A;
            UC[i].eHandRflag = true;
            if(UC[i].eHandR.type == 7)
                UC[i].eHandLflag = true;
        }
        if([[items objectAtIndex:2] intValue] >= 0){
            UC[i].eHead = EQ[[[items objectAtIndex:2] intValue]];
            UC[i].eHeadflag = true;
        }
        if([[items objectAtIndex:3] intValue] >= 0){
            UC[i].eBody = EQ[[[items objectAtIndex:3] intValue]];
            UC[i].eBodyflag = true;
        }
        if([[items objectAtIndex:4] intValue] >= 0){
            UC[i].eFoot = EQ[[[items objectAtIndex:4] intValue]];
            UC[i].eFootflag = true;
        }
        if([[items objectAtIndex:5] intValue] >= 0){
            UC[i].eArm = EQ[[[items objectAtIndex:5] intValue]];
            UC[i].eArmflag = true;
        }
        
        items = [[fileDataArray objectAtIndex:oopStart+4] componentsSeparatedByString:@","];
        
        
        items = [[fileDataArray objectAtIndex:oopStart+5] componentsSeparatedByString:@","];
        
        UC[i].chipNumb = i;
    }
    
    
    InitialFlag = true;
}

-(void)saveData{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    
    for (int i=0; i<chipNumb; i++) {
        NSString *fdata = @"data/UnitChip/UCdata";
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        NSString *fileData = @"";
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].name]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].nameNick]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].nameClass]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].nameRecognition]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].nameID]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].aura]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.HP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.MP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.AP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.WT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.BP]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.STR]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.VIT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.AGI]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.DEX]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.MEN]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.INT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.LUK]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].S_M.MOV]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.MEL]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.MIS]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.HIT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.DOD]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.REA]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.SKI]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.ATK]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.DEF]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.CAP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.ACU]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].S_M.EVA]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].S_M.typeMONS]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].S_M.typeMOVE]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].S_M.cSupply]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].S_M.cFood]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].S_M.cMoney]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].S_M.cWT]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.blow]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.slash]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.stub]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.arrow]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.gun]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.shell]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.flame]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.cold]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.electoric]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.air]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.water]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.gas]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.holy]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.dark]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.explosion]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.blood]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.paralysis]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.confusion]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.poison]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.sleep]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.charm]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].R_M.silent]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].iName]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].iNameb]] stringByAppendingString:@"\n"];
        
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"----\n"]];
        
        SKILL *SKtop;
        
        SKtop = UC[i].S;
        while(UC[i].S){
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].S->type]];
            for (int j = 0;UC[i].S->list[j] > 0;j++) {
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d", UC[i].S->list[j]]];
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%g", UC[i].S->cost[j]]];
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d", UC[i].S->Lv[j]]];
            }
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];
            UC[i].S = UC[i].S->next;
        }UC[i].S = SKtop;
        
        
        
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"----\n"]];
        
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].CM.A]];
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d", UC[i].CM.B]];
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d", UC[i].CM.C]];
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d", UC[i].CM.D]];
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"----\n"]];
        
        
        if(UC[i].eHandL.nameID){
            for(int j = 0;j < eItemNum;j++){
                if([UC[i].eHandL.nameID isEqualToString:EQ[j].nameID]){
                    fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%d",j]];
                }
            }
        }else{
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"-1"]];
        }
        
        if(UC[i].eHandR.nameID){
            for(int j = 0;j < eItemNum;j++){
                if([UC[i].eHandR.nameID isEqualToString:EQ[j].nameID]){
                    fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d",j]];
                }
            }
        }else{
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",-1"]];
        }
        
        if(UC[i].eHead.nameID){
            for(int j = 0;j < eItemNum;j++){
                if([UC[i].eHead.nameID isEqualToString:EQ[j].nameID]){
                    fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d",j]];
                }
            }
        }else{
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",-1"]];
        }
        
        if(UC[i].eBody.nameID){
            for(int j = 0;j < eItemNum;j++){
                if([UC[i].eBody.nameID isEqualToString:EQ[j].nameID]){
                    fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d",j]];
                }
            }
        }else{
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",-1"]];
        }
        
        if(UC[i].eFoot.nameID){
            for(int j = 0;j < eItemNum;j++){
                if([UC[i].eFoot.nameID isEqualToString:EQ[j].nameID]){
                    fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d",j]];
                }
            }
        }else{
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",-1"]];
        }
        
        if(UC[i].eArm.nameID){
            for(int j = 0;j < eItemNum;j++){
                if([UC[i].eArm.nameID isEqualToString:EQ[j].nameID]){
                    fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",%d",j]];
                }
            }
        }else{
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@",-1"]];
        }
        
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        
        //装飾品は改行して入る予定
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"装飾品\n"]];
        //消耗品は改行して入る予定
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"消耗品\n"]];
        
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"----\n"]];
        
        [fileData writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        if(1){
        NSData *f2Data = [UC[i].img TIFFRepresentation];
        NSBitmapImageRep *brep = [NSBitmapImageRep imageRepWithData:f2Data];
        f2Data = [brep representationUsingType:NSPNGFileType properties:nil];
        
        NSString *bcPath = @"data/UnitChip/img/uc";
        bcPath = [bcPath stringByAppendingFormat:@"%d", i + 1];
        
        [f2Data writeToFile:bcPath atomically:YES];
        }
        
        if(1){
        NSData *f2Data = [UC[i].imgb TIFFRepresentation];
        NSBitmapImageRep *brep = [NSBitmapImageRep imageRepWithData:f2Data];
        f2Data = [brep representationUsingType:NSPNGFileType properties:nil];
        
        NSString *bcPath = @"data/UnitChip/img/ucb";
        bcPath = [bcPath stringByAppendingFormat:@"%d", i + 1];
        
        [f2Data writeToFile:bcPath atomically:YES];
        }
    }
    
    
}


-(void)saveDataAL{

    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];


    for (int i=0; i<chipNumb; i++) {
        NSString *fdata = @"data/AttackList/ALdata";
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        NSString *fileData = @"";
    
        ATTACK *aTop = UC[i].A;
        int Acnt = 0;
        while (UC[i].A) {
            if(Acnt > 0) fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"--------"]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].A->name]] stringByAppendingString:@"\n"];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->trig]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->type]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->melee]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->P]] stringByAppendingString:@"\n"];
        
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->rangeA]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->rangeB]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->extent]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->bullet]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->hitCount]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->successRate]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->vigor]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->hitPercent]] stringByAppendingString:@"\n"];
    
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->costType]] stringByAppendingString:@","];
            if(UC[i].A->costType == 0){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].A->MP]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->pMP]] stringByAppendingString:@","];
            }else if(UC[i].A->costType == 1){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].A->AP]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->pAP]] stringByAppendingString:@","];
            }else if(UC[i].A->costType == 2){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].A->HP]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->pHP]] stringByAppendingString:@","];
            }
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->cSupply]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->cFood]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->cMoney]] stringByAppendingString:@"\n"];
        
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->riku]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->chu]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->umi]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->sora]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->dmgExtend]] stringByAppendingString:@"\n"];
        
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].A->cmd]] stringByAppendingString:@"\n"];
    
            if(UC[i].A->msg){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].A->msg]] stringByAppendingString:@"\n"];
            }
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"----"]] stringByAppendingString:@"\n"];
        
            DAMAGE *dTop = UC[i].A->D;
            while (UC[i].A->D) {
                if(UC[i].A->D->count <= 0 && UC[i].A->D->sort == 0){
                    UC[i].A->D = NULL;
                    break;
                }
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->D->type]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].A->D->count]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", UC[i].A->D->pCount]] stringByAppendingString:@"\n"];
            
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->D->seed]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->D->sort]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->D->continium]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->D->absolute]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->D->beam]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->D->noSizeFix]] stringByAppendingString:@"\n"];
        
                UC[i].A->D = UC[i].A->D->next;
            }UC[i].A->D = dTop;
        
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"----"]] stringByAppendingString:@"\n"];
        
            DMGEXTEND *eTop = UC[i].A->E;
            while (UC[i].A->E) {
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->E->rate]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->E->hit]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", UC[i].A->E->atkHit]] stringByAppendingString:@"\n"];
                
                UC[i].A->E = UC[i].A->E->next;
            }UC[i].A->E = eTop;
        
        
            UC[i].A = UC[i].A->next;
            Acnt++;
        }UC[i].A = aTop;
        
        
        
        
        [fileData writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
}

-(void)saveDataAL2{
    
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    
    for (int i=0; i<LCN; i++) {
        NSString *fdata = @"data/AttackList2/LALdata";
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        NSString *fileData = @"";
        
        ATTACK *aTop = LC[i].A;
        int Acnt = 0;
        while (LC[i].A) {
            
            if(Acnt > 0) fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"--------"]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", LC[i].A->name]] stringByAppendingString:@"\n"];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->trig]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->type]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->melee]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->P]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->rangeA]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->rangeB]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->extent]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->bullet]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->hitCount]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->successRate]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->vigor]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->hitPercent]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->costType]] stringByAppendingString:@","];
            if(LC[i].A->costType == 0){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].A->EN]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->pEN]] stringByAppendingString:@","];
            }else if(LC[i].A->costType == 1){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].A->HP]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->pHP]] stringByAppendingString:@","];
            }
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->cSupply]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->cFood]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->cMoney]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->riku]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->chu]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->umi]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->sora]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->dmgExtend]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", LC[i].A->cmd]] stringByAppendingString:@"\n"];
            
            if(LC[i].A->msg){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", LC[i].A->msg]] stringByAppendingString:@"\n"];
            }
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"----"]] stringByAppendingString:@"\n"];
            
            DAMAGE *dTop = LC[i].A->D;
            while (LC[i].A->D) {
                if(LC[i].A->D->count <= 0 && LC[i].A->D->sort == 0){
                    LC[i].A->D = NULL;
                    break;
                }
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->D->type]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].A->D->count]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].A->D->pCount]] stringByAppendingString:@"\n"];
                
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->D->seed]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->D->sort]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->D->continium]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->D->absolute]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->D->beam]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->D->noSizeFix]] stringByAppendingString:@"\n"];
                
                LC[i].A->D = LC[i].A->D->next;
            }LC[i].A->D = dTop;
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"----"]] stringByAppendingString:@"\n"];
            
            DMGEXTEND *eTop = LC[i].A->E;
            while (LC[i].A->E) {
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->E->rate]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->E->hit]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].A->E->atkHit]] stringByAppendingString:@"\n"];
                
                LC[i].A->E = LC[i].A->E->next;
            }LC[i].A->E = eTop;
            
            
            LC[i].A = LC[i].A->next;
            Acnt++;
        }LC[i].A = aTop;
        
        
        
        
        [fileData writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
}

-(void)saveDataALEQ{
    
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    
    for (int i=0; i<itemNumb; i++) {
        NSString *fdata = @"data/AttackList3/IALdata";
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        NSString *fileData = @"";
        
        ATTACK *aeTop = EQ[i].A;
        int Acnt = 0;
        while (EQ[i].A) {
            if(Acnt > 0) fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"--------"]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", EQ[i].A->name]] stringByAppendingString:@"\n"];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->trig]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->type]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->melee]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->P]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->rangeA]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->rangeB]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->extent]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->bullet]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->hitCount]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->successRate]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->vigor]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->hitPercent]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->costType]] stringByAppendingString:@","];
            if(EQ[i].A->costType == 0){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].A->MP]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->pMP]] stringByAppendingString:@","];
            }else if(EQ[i].A->costType == 1){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].A->AP]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->pAP]] stringByAppendingString:@","];
            }else if(EQ[i].A->costType == 2){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].A->HP]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->pHP]] stringByAppendingString:@","];
            }
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->cSupply]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->cFood]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->cMoney]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->riku]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->chu]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->umi]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->sora]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->dmgExtend]] stringByAppendingString:@"\n"];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", EQ[i].A->cmd]] stringByAppendingString:@"\n"];
            
            if(EQ[i].A->msg){
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", EQ[i].A->msg]] stringByAppendingString:@"\n"];
            }
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"----"]] stringByAppendingString:@"\n"];
            
            DAMAGE *dTop = EQ[i].A->D;
            while (EQ[i].A->D) {
                if(EQ[i].A->D->count <= 0 && EQ[i].A->D->sort == 0){
                    EQ[i].A->D = NULL;
                    break;
                }
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->D->type]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].A->D->count]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", EQ[i].A->D->pCount]] stringByAppendingString:@"\n"];
                
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->D->seed]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->D->sort]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->D->continium]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->D->absolute]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->D->beam]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->D->noSizeFix]] stringByAppendingString:@"\n"];
                
                EQ[i].A->D = EQ[i].A->D->next;
            }EQ[i].A->D = dTop;
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"----"]] stringByAppendingString:@"\n"];
            
            DMGEXTEND *eTop = EQ[i].A->E;
            while (EQ[i].A->E) {
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"####"]] stringByAppendingString:@"\n"];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->E->rate]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->E->hit]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", EQ[i].A->E->atkHit]] stringByAppendingString:@"\n"];
                
                EQ[i].A->E = EQ[i].A->E->next;
            }EQ[i].A->E = eTop;
            
            
            EQ[i].A = EQ[i].A->next;
            Acnt++;
        }EQ[i].A = aeTop;
        
        
        
        
        [fileData writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
}


-(void)initFileDirectoryItem{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/ItemList/preset.txt"];
    NSString *pathILI = @"data/ItemList/img";
    NSString *pathDATA2 = @"data/ItemList/preset.txt";
    NSString *pathIL = @"data/ItemList/preset.txt";
    NSString *fileData = nil;
    
    itemNumb = 3;
    eItemNum = itemNumb;
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathILI withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathIL contents:nil attributes:nil];
        
        [pathIL writeToFile:[NSString stringWithFormat:@"%ld", itemNumb] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSString *data1 = @"鉄の剣\n鉄の剣\neq1\n1000,30,2\n0,0,0,0,0\n32,0,0,0,0,0,0\n2,0,0,0,0,0,0\n0,0,0,0\n0,0,0,0,0,0,0,0,0,0,0,0\n0,0,0,0,0,0,0,0,0,0\n鉄で出来た剣\n----\n";
        NSString *data2 = @"鋼の剣\n鋼の剣\neq2\n1500,35,2\n0,0,0,0,0\n50,0,0,0,0,0,0\n2,0,0,0,0,0,0\n0,0,0,0\n0,0,0,0,0,0,0,0,0,0,0,0\n0,0,0,0,0,0,0,0,0,0\n鋼で出来た剣\n----\n";
        NSString *data3 = @"銀の剣\n銀の剣\neq3\n2000,40,2\n0,0,0,0,0\n90,0,0,0,0,0,0\n2,0,0,0,0,0,0\n0,0,0,0\n0,0,0,0,0,0,0,0,0,0,0,0\n0,0,0,0,0,0,0,0,0,0\n銀で出来た剣\n----\n";
        
        for (int i=1; i<=itemNumb; i++) {
            NSString *fdata = @"data/ItemList/ILdata";
            
            fdata = [fdata stringByAppendingFormat:@"%d.txt", i];
            
            switch (i) {
                case 1:
                    [data1 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 2:
                    [data2 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 3:
                    [data3 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                default:
                    
                    break;
            }
            
        }
        
    }
    
    fileData = [NSString stringWithContentsOfFile:pathIL encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    int instantNum = [[fileDataArray objectAtIndex:0] intValue];
    
    itemNumb = instantNum;
    eItemNum = (int)itemNumb;
    
    for (int i=0; i< itemNumb; i++) {
        NSString *fdata = @"data/ItemList/ILdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        fileDataArray = [fileData componentsSeparatedByString:@"\n"];
        
        EQ[i].name = [[fileDataArray objectAtIndex:0] retain];
        EQ[i].nameRecognition = [[fileDataArray objectAtIndex:1] retain];
        EQ[i].nameID = [[fileDataArray objectAtIndex:2] retain];
        
        NSArray *items = [[fileDataArray objectAtIndex:3] componentsSeparatedByString:@","];
        
        EQ[i].price = [[items objectAtIndex:0] intValue];
        EQ[i].Weight = [[items objectAtIndex:1] intValue];
        EQ[i].type = [[items objectAtIndex:2] intValue];
        
        items = [[fileDataArray objectAtIndex:4] componentsSeparatedByString:@","];
        
        EQ[i].HP = [[items objectAtIndex:0] intValue];
        EQ[i].MP = [[items objectAtIndex:1] intValue];
        EQ[i].AP = [[items objectAtIndex:2] intValue];
        EQ[i].WT = [[items objectAtIndex:3] intValue];
        EQ[i].MOV = [[items objectAtIndex:4] intValue];
        
        items = [[fileDataArray objectAtIndex:5] componentsSeparatedByString:@","];
        
        EQ[i].STR = [[items objectAtIndex:0] intValue];
        EQ[i].VIT = [[items objectAtIndex:1] intValue];
        EQ[i].AGI = [[items objectAtIndex:2] intValue];
        EQ[i].DEX = [[items objectAtIndex:3] intValue];
        EQ[i].MEN = [[items objectAtIndex:4] intValue];
        EQ[i].INT = [[items objectAtIndex:5] intValue];
        EQ[i].LUK = [[items objectAtIndex:6] intValue];
        
        items = [[fileDataArray objectAtIndex:6] componentsSeparatedByString:@","];
        
        EQ[i].pSTR = [[items objectAtIndex:0] intValue];
        EQ[i].pVIT = [[items objectAtIndex:1] intValue];
        EQ[i].pAGI = [[items objectAtIndex:2] intValue];
        EQ[i].pDEX = [[items objectAtIndex:3] intValue];
        EQ[i].pMEN = [[items objectAtIndex:4] intValue];
        EQ[i].pINT = [[items objectAtIndex:5] intValue];
        EQ[i].pLUK = [[items objectAtIndex:6] intValue];
        
        items = [[fileDataArray objectAtIndex:7] componentsSeparatedByString:@","];
        
        EQ[i].recHP = [[items objectAtIndex:0] intValue];
        EQ[i].recpHP = [[items objectAtIndex:1] intValue];
        EQ[i].recMP = [[items objectAtIndex:2] intValue];
        EQ[i].recpMP = [[items objectAtIndex:3] intValue];
        
        items = [[fileDataArray objectAtIndex:8] componentsSeparatedByString:@","];
        
        EQ[i].R.blow = [[items objectAtIndex:0] intValue];
        EQ[i].R.slash = [[items objectAtIndex:1] intValue];
        EQ[i].R.stub = [[items objectAtIndex:2] intValue];
        EQ[i].R.arrow = [[items objectAtIndex:3] intValue];
        EQ[i].R.gun = [[items objectAtIndex:4] intValue];
        EQ[i].R.shell = [[items objectAtIndex:5] intValue];
        EQ[i].R.paralysis = [[items objectAtIndex:6] intValue];
        EQ[i].R.poison = [[items objectAtIndex:7] intValue];
        EQ[i].R.charm = [[items objectAtIndex:8] intValue];
        EQ[i].R.confusion = [[items objectAtIndex:9] intValue];
        EQ[i].R.sleep = [[items objectAtIndex:10] intValue];
        EQ[i].R.silent = [[items objectAtIndex:11] intValue];
        
        items = [[fileDataArray objectAtIndex:9] componentsSeparatedByString:@","];
        
        EQ[i].R.flame = [[items objectAtIndex:0] intValue];
        EQ[i].R.cold = [[items objectAtIndex:1] intValue];
        EQ[i].R.electoric = [[items objectAtIndex:2] intValue];
        EQ[i].R.air = [[items objectAtIndex:3] intValue];
        EQ[i].R.water = [[items objectAtIndex:4] intValue];
        EQ[i].R.gas = [[items objectAtIndex:5] intValue];
        EQ[i].R.holy = [[items objectAtIndex:6] intValue];
        EQ[i].R.dark = [[items objectAtIndex:7] intValue];
        EQ[i].R.explosion = [[items objectAtIndex:8] intValue];
        EQ[i].R.blood = [[items objectAtIndex:9] intValue];
        
        EQ[i].comment = [[fileDataArray objectAtIndex:10] retain];
    }
    
    
    
}

-(void)initFileDirectoryCombo{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/ComboList/preset.txt"];
    NSString *pathCL = @"data/ComboList/preset.txt";
    NSString *path = @"data/ComboList";
    NSString *fileData = nil;
    
    
    comboItemNumb = 2;
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathCL contents:nil attributes:nil];
        
        NSString *data1 = @"0,1,2,3\n####\n236A,0,0\n####\nA>A>A\nA>A>B";
        
        NSString *data2 = @"0,1,2,3\n####\n236A,0,0\n####\nA>A>A\nA>A>B";
        
        for (int i=1; i<=comboItemNumb; i++) {
            NSString *fdata = @"data/ComboList/CLdata";
            
            fdata = [fdata stringByAppendingFormat:@"%d.txt", i];
            
            switch (i) {
                case 1:
                    [data1 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 2:
                    [data2 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                default:
                    
                    break;
            }
            
        }
        
    }
    
    NSArray *fileDataArray2;
    for (int i = 0; i< itemNumb; i++){
        COMMANDS *CStop = UC[i].CM.cs;
        COMBO *COtop = UC[i].CM.co;
        
        NSString *fdata = @"data/ComboList/CLdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        fileDataArray2 = [fileData componentsSeparatedByString:@"\n####\n"];
        
        NSArray *items = [[fileDataArray2 objectAtIndex:0] componentsSeparatedByString:@","];
        
        /*
        UC[i].CM.A = [[items objectAtIndex:0] intValue];
        UC[i].CM.B = [[items objectAtIndex:1] intValue];
        UC[i].CM.C = [[items objectAtIndex:2] intValue];
        UC[i].CM.D = [[items objectAtIndex:3] intValue];
        */
        fileDataArray = [[fileDataArray2 objectAtIndex:1] componentsSeparatedByString:@"\n"];
        
        for(int k = 0;k < [fileDataArray count];k++){
            if (k == 0) {
                UC[i].CM.cs = calloc(1, sizeof(COMMANDS));
                CStop = UC[i].CM.cs;
            }
            items = [[fileDataArray objectAtIndex:k] componentsSeparatedByString:@","];
            
            NSLog(@"%@", UC[i].CM.cs->cmd);
            
            UC[i].CM.cs->cmd = [[items objectAtIndex:0] retain];
            UC[i].CM.cs->waza = [[items objectAtIndex:1] intValue];
            UC[i].CM.cs->hasei = [[items objectAtIndex:2] retain];
            
            UC[i].CM.cs->next = calloc(1, sizeof(COMMANDS));
            UC[i].CM.cs = UC[i].CM.cs->next;
        }
        UC[i].CM.cs = NULL;
        
        fileDataArray = [[fileDataArray2 objectAtIndex:2] componentsSeparatedByString:@"\n"];
        
        
        for(int k = 0;k < [fileDataArray count];k++){
            if (k == 0) {
                UC[i].CM.co = calloc(1, sizeof(COMBO));
                COtop = UC[i].CM.co;
            }
            items = [[fileDataArray objectAtIndex:k] componentsSeparatedByString:@","];
            
            UC[i].CM.co->mbo = [[items objectAtIndex:0] retain];
            
            UC[i].CM.co->next = calloc(1, sizeof(COMBO));
            UC[i].CM.co = UC[i].CM.co->next;
        }
        UC[i].CM.co = NULL;
        
        
        UC[i].CM.co = COtop;
        UC[i].CM.cs = CStop;
    }


}

-(void)initFileDirectoryAttack{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/AttackList/preset.txt"];
    NSString *pathALI = @"data/AttackList/img";
    NSString *pathDATA2 = @"data/AttackList/preset.txt";
    NSString *pathAL = @"data/AttackList/preset.txt";
    NSString *fileData = nil;
    
    itemNumb = [unitChipListMA count];
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathALI withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathAL contents:nil attributes:nil];
    
        
        
        for (int i=1; i<=itemNumb; i++) {
            NSString *fdata = @"data/AttackList/ALdata";
            
            fdata = [fdata stringByAppendingFormat:@"%d.txt", i];
            
            switch (i) {
                default:
                    
                    break;
            }
            
        }
        
    }
    
    NSArray *fileDataArray2;
    ATTACK *Atop;
    for (int i=0; i< itemNumb; i++) {
        NSString *fdata = @"data/AttackList/ALdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        fileDataArray2 = [fileData componentsSeparatedByString:@"--------\n"];
        
        bool initAttackAdd = false;
        
        if(fileData == 0x00007fff7e19dfa0) continue;
        
        if([fileDataArray2 count] <= 0) continue;
        
        for(int j=0;j < [fileDataArray2 count];j++){
            if(![[fileDataArray2 objectAtIndex:0] isEqualToString:@""]) UC[i].attackListNum++;
        fileDataArray = [[fileDataArray2 objectAtIndex:j] componentsSeparatedByString:@"\n"];
            
            if(!initAttackAdd)
                [self AddATTACK:&UC[i].A :0];
      
            [self AddATTACK:&UC[i].A :j];
            
            if(!initAttackAdd) {
                Atop = UC[i].A;
            }
            initAttackAdd = true;
            
        UC[i].A->name = [[fileDataArray objectAtIndex:0] retain];
        
            if([fileDataArray count] <= 1) continue;
        NSArray *items = [[fileDataArray objectAtIndex:1] componentsSeparatedByString:@","];
        
        UC[i].A->trig = [[items objectAtIndex:0] intValue];
        UC[i].A->type = [[items objectAtIndex:1] intValue];
        UC[i].A->melee = [[items objectAtIndex:2] intValue];
        UC[i].A->P = [[items objectAtIndex:3] intValue];
        
        items = [[fileDataArray objectAtIndex:2] componentsSeparatedByString:@","];
        
        UC[i].A->rangeA = [[items objectAtIndex:0] intValue];
        UC[i].A->rangeB = [[items objectAtIndex:1] intValue];
        UC[i].A->extent = [[items objectAtIndex:2] intValue];
        UC[i].A->bullet = [[items objectAtIndex:3] intValue];
        UC[i].A->hitCount = [[items objectAtIndex:4] intValue];
        UC[i].A->successRate = [[items objectAtIndex:5] intValue];
        UC[i].A->vigor = [[items objectAtIndex:6] intValue];
        UC[i].A->hitPercent = [[items objectAtIndex:7] intValue];
        
        items = [[fileDataArray objectAtIndex:3] componentsSeparatedByString:@","];
        
        UC[i].A->costType = [[items objectAtIndex:0] intValue];
        
        if(UC[i].A->costType == 0) {
            UC[i].A->MP = [[items objectAtIndex:1] intValue];
            UC[i].A->pMP = [[items objectAtIndex:2] intValue];
        }
        else if(UC[i].A->costType == 1) {
            UC[i].A->AP = [[items objectAtIndex:1] intValue];
            UC[i].A->pAP = [[items objectAtIndex:2] intValue];
        }
        else if(UC[i].A->costType == 2) {
            UC[i].A->HP = [[items objectAtIndex:1] intValue];
            UC[i].A->pHP = [[items objectAtIndex:2] intValue];
        }
        
        UC[i].A->cSupply = [[items objectAtIndex:3] intValue];
        UC[i].A->cFood = [[items objectAtIndex:4] intValue];
        UC[i].A->cMoney = [[items objectAtIndex:5] intValue];

        items = [[fileDataArray objectAtIndex:4] componentsSeparatedByString:@","];
        
        UC[i].A->riku = [[items objectAtIndex:0] intValue];
        UC[i].A->chu = [[items objectAtIndex:1] intValue];
        UC[i].A->umi = [[items objectAtIndex:2] intValue];
        UC[i].A->sora = [[items objectAtIndex:3] intValue];
        UC[i].A->dmgExtend = [[items objectAtIndex:4] intValue];
        
        UC[i].A->cmd = [[fileDataArray objectAtIndex:5] retain];
        UC[i].A->msg = @"";
            
        //[self AddDAMAGE:&UC[i].A->D :0];
        //[self AddDMGEXTEND:&UC[i].A->E :0];
        
        DAMAGE *Dtop = UC[i].A->D;
        DMGEXTEND *Etop = UC[i].A->E;
        static bool omfgFlag;
            
        int stringType = 0;
        int stringRange = 1;
        int stringNumber = 0;
        for (int k = 6; k<[fileDataArray count];k++) {
            NSString *str = [fileDataArray objectAtIndex:k];
            NSRange rangeSearch, rangeSearch2;
            NSArray *rangeArray;
            rangeSearch = [str rangeOfString:@"####"];
            rangeArray = [str componentsSeparatedByString:@","];
            rangeSearch2 = [str rangeOfString:@"----"];
            static int omg = 0;
            static int omg2 = 0;
            
            if(k == [fileDataArray count] - 1){
                omg2 = 0;
            }
            
            if(stringType == 0)
            if (rangeSearch.location != NSNotFound) {
            }else if(rangeSearch2.location != NSNotFound){
                stringType = 1;
                omg = 0;
            }else{
                if(UC[i].A->msg == NULL){
                    UC[i].A->msg = [str retain];
                }else{
                    if(omfgFlag) UC[i].A->msg = [[UC[i].A->msg stringByAppendingFormat:@"\n"] retain];
                    UC[i].A->msg = [[UC[i].A->msg stringByAppendingFormat:@"%@", str] retain];
                    omfgFlag = true;
                }
            }else if(stringType == 1){stringRange ++;
                if(rangeSearch2.location != NSNotFound){
                    stringType = 2;
                }
                else if(rangeSearch.location != NSNotFound){
                    stringRange = 0;
                }else if(stringRange == 1){
                    if(omg == 0) {
                        [self AddDAMAGE:&UC[i].A->D :0];
                        Dtop = UC[i].A->D;
                    }
                    omg++;
                    UC[i].A->D->type = [[rangeArray objectAtIndex:0] intValue];
                    UC[i].A->D->count = [[rangeArray objectAtIndex:1] intValue];
                    UC[i].A->D->pCount = [[rangeArray objectAtIndex:2] intValue];
                }else if(stringRange == 2){
                    
                    UC[i].A->D->seed = [[rangeArray objectAtIndex:0] intValue];
                    UC[i].A->D->sort = [[rangeArray objectAtIndex:1] intValue];
                    UC[i].A->D->continium = [[rangeArray objectAtIndex:2] intValue];
                    UC[i].A->D->absolute = [[rangeArray objectAtIndex:3] intValue];
                    UC[i].A->D->beam = [[rangeArray objectAtIndex:4] intValue];
                    UC[i].A->D->noSizeFix = [[rangeArray objectAtIndex:5] intValue];
                    
                    stringNumber++;
                    NSString *str2 = [fileDataArray objectAtIndex:k+1];
                    NSRange rangeSearch3 = [str2 rangeOfString:@"####"];
                    if(stringNumber >= 1 && rangeSearch3.location != NSNotFound) [self AddDAMAGE:&UC[i].A->D :stringNumber-1];
                    UC[i].A->D = UC[i].A->D->next;
                }
            }else if(stringType == 2){stringRange ++;
                
                if(rangeSearch2.location != NSNotFound){
                    stringType = 3;
                }
                else if(rangeSearch.location != NSNotFound){
                    stringRange = 0;
                    stringNumber = 0;
                }else if(stringRange == 1){stringNumber++;
                    if(omg2 == 0) {
                        [self AddDMGEXTEND:&UC[i].A->E :0];
                        Etop = UC[i].A->E;
                    }
                    omg2++;
                    UC[i].A->E->rate = [[rangeArray objectAtIndex:0] intValue];
                    UC[i].A->E->hit = [[rangeArray objectAtIndex:2] intValue];
                    UC[i].A->E->atkHit = [[rangeArray objectAtIndex:1] intValue];
                    
                    NSString *str2 = [fileDataArray objectAtIndex:k+1];
                    NSRange rangeSearch3 = [str2 rangeOfString:@"####"];
                    if(stringNumber >= 1 && rangeSearch3.location != NSNotFound) [self AddDMGEXTEND:&UC[i].A->E :stringNumber-1];
                    
                    UC[i].A->E = UC[i].A->E->next;
                }
            
            }
        }
            UC[i].A->D = Dtop;
            UC[i].A->E = Etop;
            
            omfgFlag = false;
            if([fileDataArray2 count]-1 > j) UC[i].A = UC[i].A->next;
            else UC[i].A->next = NULL;
        }
        
        if(UC[i].attackListNum <= 0) Atop = NULL;
        UC[i].A = Atop;
    }
    
    /*
    for (int i=0; i< itemNumb; i++)
    [self setTotalDamage:i row:<#(int)#>];
    */
}

-(void)initFileDirectoryAttack2{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/AttackList2/preset.txt"];
    NSString *pathALI = @"data/AttackList2/img";
    NSString *pathDATA2 = @"data/AttackList2/preset.txt";
    NSString *pathAL = @"data/AttackList2/preset.txt";
    NSString *fileData = nil;
    
    itemNumb = LCN;
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathALI withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathAL contents:nil attributes:nil];
        
        NSString *data1 = @"砲撃\n1,0,0,1\n1,3,0,10,1,100,0,30\n0,0,0,0,0,0\n0,0,0,0,0\nA\n####\n----\n####\n0,800,0\n5,0,0,0,0,0\n----\n####\n5,80,1\n--------\n";
        
        NSString *data2 = @"砲撃\n1,0,0,1\n1,3,0,0,20,100,0,30\n0,0,0,0,0,0\n0,0,0,0,0\nA\n####\n----\n####\n0,1000,0\n5,0,0,0,0,0\n----\n####\n4,100,1\n--------\n";
        
        
        for (int i=1; i<=itemNumb; i++) {
            NSString *fdata = @"data/AttackList2/LALdata";
            
            fdata = [fdata stringByAppendingFormat:@"%d.txt", i];
            
            switch (i) {
                case 1:
                    [data1 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 2:
                    [data2 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                default:
                    
                    break;
            }
            
        }
        
    }
    
    NSArray *fileDataArray2;
    ATTACK *Atop;
    for (int i=0; i< itemNumb; i++) {
        NSString *fdata = @"data/AttackList2/LALdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        fileDataArray2 = [fileData componentsSeparatedByString:@"--------\n"];
        
        bool initAttackAdd = false;
        
        if(fileData == 0x00007fff7e19dfa0) continue;
        
        for(int j=0;j < [fileDataArray2 count];j++){
            if(![[fileDataArray2 objectAtIndex:0] isEqualToString:@""]) LC[i].attackListNum++;
            fileDataArray = [[fileDataArray2 objectAtIndex:j] componentsSeparatedByString:@"\n"];
            
            if(!initAttackAdd)
                [self AddATTACK:&LC[i].A :0];
            
            [self AddATTACK:&LC[i].A :j];
            
            if(!initAttackAdd) {Atop = LC[i].A;}
            initAttackAdd = true;
            
            LC[i].A->name = [[fileDataArray objectAtIndex:0] retain];
            
            if([fileDataArray count] <= 1) continue;
            NSArray *items = [[fileDataArray objectAtIndex:1] componentsSeparatedByString:@","];
            
            LC[i].A->trig = [[items objectAtIndex:0] intValue];
            LC[i].A->type = [[items objectAtIndex:1] intValue];
            LC[i].A->melee = [[items objectAtIndex:2] intValue];
            LC[i].A->P = [[items objectAtIndex:3] intValue];
            
            items = [[fileDataArray objectAtIndex:2] componentsSeparatedByString:@","];
            
            LC[i].A->rangeA = [[items objectAtIndex:0] intValue];
            LC[i].A->rangeB = [[items objectAtIndex:1] intValue];
            LC[i].A->extent = [[items objectAtIndex:2] intValue];
            LC[i].A->bullet = [[items objectAtIndex:3] intValue];
            LC[i].A->hitCount = [[items objectAtIndex:4] intValue];
            LC[i].A->successRate = [[items objectAtIndex:5] intValue];
            LC[i].A->vigor = [[items objectAtIndex:6] intValue];
            LC[i].A->hitPercent = [[items objectAtIndex:7] intValue];
            
            items = [[fileDataArray objectAtIndex:3] componentsSeparatedByString:@","];
            
            LC[i].A->costType = [[items objectAtIndex:0] intValue];
            
            if(LC[i].A->costType == 0) {
                LC[i].A->EN = [[items objectAtIndex:1] intValue];
                LC[i].A->pEN = [[items objectAtIndex:2] intValue];
            }
            else if(LC[i].A->costType == 1) {
                LC[i].A->HP = [[items objectAtIndex:1] intValue];
                LC[i].A->pHP = [[items objectAtIndex:2] intValue];
            }
            
            LC[i].A->cSupply = [[items objectAtIndex:3] intValue];
            LC[i].A->cFood = [[items objectAtIndex:4] intValue];
            LC[i].A->cMoney = [[items objectAtIndex:5] intValue];
            
            items = [[fileDataArray objectAtIndex:4] componentsSeparatedByString:@","];
            
            LC[i].A->riku = [[items objectAtIndex:0] intValue];
            LC[i].A->chu = [[items objectAtIndex:1] intValue];
            LC[i].A->umi = [[items objectAtIndex:2] intValue];
            LC[i].A->sora = [[items objectAtIndex:3] intValue];
            LC[i].A->dmgExtend = [[items objectAtIndex:4] intValue];
            
            LC[i].A->cmd = [[fileDataArray objectAtIndex:5] retain];
            LC[i].A->msg = @"";
            
            //[self AddDAMAGE:&UC[i].A->D :0];
            //[self AddDMGEXTEND:&UC[i].A->E :0];
            
            DAMAGE *Dtop = LC[i].A->D;
            DMGEXTEND *Etop = LC[i].A->E;
            static bool omfgFlag;
            
            int stringType = 0;
            int stringRange = 1;
            int stringNumber = 0;
            for (int k = 6; k<[fileDataArray count];k++) {
                NSString *str = [fileDataArray objectAtIndex:k];
                NSRange rangeSearch, rangeSearch2;
                NSArray *rangeArray;
                rangeSearch = [str rangeOfString:@"####"];
                rangeArray = [str componentsSeparatedByString:@","];
                rangeSearch2 = [str rangeOfString:@"----"];
                static int omg = 0;
                static int omg2 = 0;
                
                if(k == [fileDataArray count] - 1){
                    omg2 = 0;
                }
                
                if(stringType == 0)
                    if (rangeSearch.location != NSNotFound) {
                    }else if(rangeSearch2.location != NSNotFound){
                        stringType = 1;
                        omg = 0;
                    }else{
                        if(LC[i].A->msg == NULL){
                            LC[i].A->msg = [str retain];
                        }else{
                            if(omfgFlag) LC[i].A->msg = [[LC[i].A->msg stringByAppendingFormat:@"\n"] retain];
                            LC[i].A->msg = [[LC[i].A->msg stringByAppendingFormat:@"%@", str] retain];
                            omfgFlag = true;
                        }
                    }else if(stringType == 1){stringRange ++;
                        if(rangeSearch2.location != NSNotFound){
                            stringType = 2;
                        }
                        else if(rangeSearch.location != NSNotFound){
                            stringRange = 0;
                        }else if(stringRange == 1){
                            if(omg == 0) {
                                [self AddDAMAGE:&LC[i].A->D :0];
                                Dtop = LC[i].A->D;
                            }
                            omg++;
                            LC[i].A->D->type = [[rangeArray objectAtIndex:0] intValue];
                            LC[i].A->D->count = [[rangeArray objectAtIndex:1] intValue];
                            LC[i].A->D->pCount = [[rangeArray objectAtIndex:2] intValue];
                        }else if(stringRange == 2){
                            
                            LC[i].A->D->seed = [[rangeArray objectAtIndex:0] intValue];
                            LC[i].A->D->sort = [[rangeArray objectAtIndex:1] intValue];
                            LC[i].A->D->continium = [[rangeArray objectAtIndex:2] intValue];
                            LC[i].A->D->absolute = [[rangeArray objectAtIndex:3] intValue];
                            LC[i].A->D->beam = [[rangeArray objectAtIndex:4] intValue];
                            LC[i].A->D->noSizeFix = [[rangeArray objectAtIndex:5] intValue];
                            
                            stringNumber++;
                            NSString *str2 = [fileDataArray objectAtIndex:k+1];
                            NSRange rangeSearch3 = [str2 rangeOfString:@"####"];
                            if(stringNumber >= 1 && rangeSearch3.location != NSNotFound) [self AddDAMAGE:&LC[i].A->D :stringNumber-1];
                            LC[i].A->D = LC[i].A->D->next;
                        }
                    }else if(stringType == 2){stringRange ++;
                        
                        if(rangeSearch2.location != NSNotFound){
                            stringType = 3;
                        }
                        else if(rangeSearch.location != NSNotFound){
                            stringRange = 0;
                            stringNumber = 0;
                        }else if(stringRange == 1){stringNumber++;
                            if(omg2 == 0) {
                                [self AddDMGEXTEND:&LC[i].A->E :0];
                                Etop = LC[i].A->E;
                            }
                            omg2++;
                            LC[i].A->E->rate = [[rangeArray objectAtIndex:0] intValue];
                            LC[i].A->E->hit = [[rangeArray objectAtIndex:2] intValue];
                            LC[i].A->E->atkHit = [[rangeArray objectAtIndex:1] intValue];
                            
                            NSString *str2 = [fileDataArray objectAtIndex:k+1];
                            NSRange rangeSearch3 = [str2 rangeOfString:@"####"];
                            if(stringNumber >= 1 && rangeSearch3.location != NSNotFound) [self AddDMGEXTEND:&LC[i].A->E :stringNumber-1];
                            
                            LC[i].A->E = LC[i].A->E->next;
                        }
                        
                    }
            }
            LC[i].A->D = Dtop;
            LC[i].A->E = Etop;
            
            omfgFlag = false;
            if([fileDataArray2 count]-1 > j) LC[i].A = LC[i].A->next;
            else LC[i].A->next = NULL;
        }
        
        if(LC[i].attackListNum <= 0) Atop = NULL;
        LC[i].A = Atop;
    }
    
    /*
     for (int i=0; i< itemNumb; i++)
     [self setTotalDamage:i row:<#(int)#>];
     */
}

-(void)initFileDirectoryAttackEQ{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/AttackList3/preset.txt"];
    NSString *pathALI = @"data/AttackList3/img";
    NSString *pathDATA2 = @"data/AttackList3/preset.txt";
    NSString *pathAL = @"data/AttackList3/preset.txt";
    NSString *fileData = nil;
    
    itemNumb = [equipListMA count];
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathALI withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathAL contents:nil attributes:nil];
        
        
        
        for (int i=1; i<=itemNumb; i++) {
            NSString *fdata = @"data/AttackList3/IALdata";
            
            fdata = [fdata stringByAppendingFormat:@"%d.txt", i];
            
            switch (i) {
                default:
                    
                    break;
            }
            
        }
        
    }
    
    NSArray *fileDataArray2;
    ATTACK *Atop;
    for (int i=0; i< itemNumb; i++) {
        NSString *fdata = @"data/AttackList3/IALdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        fileDataArray2 = [fileData componentsSeparatedByString:@"--------\n"];
        
        bool initAttackAdd = false;
        
        if(fileData == 0x00007fff7e19dfa0) continue;
        
        if([fileDataArray2 count] <= 0) continue;
        
        for(int j=0;j < [fileDataArray2 count];j++){
            if(![[fileDataArray2 objectAtIndex:0] isEqualToString:@""]) EQ[i].attackListNum++;
            fileDataArray = [[fileDataArray2 objectAtIndex:j] componentsSeparatedByString:@"\n"];
            
            if(!initAttackAdd)
                [self AddATTACK:&EQ[i].A :0];
            
            [self AddATTACK:&EQ[i].A :j];
            
            if(!initAttackAdd) {
                Atop = EQ[i].A;
            }
            initAttackAdd = true;
            
            EQ[i].A->name = [[fileDataArray objectAtIndex:0] retain];
            
            if([fileDataArray count] <= 1) continue;
            NSArray *items = [[fileDataArray objectAtIndex:1] componentsSeparatedByString:@","];
            
            EQ[i].A->trig = [[items objectAtIndex:0] intValue];
            EQ[i].A->type = [[items objectAtIndex:1] intValue];
            EQ[i].A->melee = [[items objectAtIndex:2] intValue];
            EQ[i].A->P = [[items objectAtIndex:3] intValue];
            
            items = [[fileDataArray objectAtIndex:2] componentsSeparatedByString:@","];
            
            EQ[i].A->rangeA = [[items objectAtIndex:0] intValue];
            EQ[i].A->rangeB = [[items objectAtIndex:1] intValue];
            EQ[i].A->extent = [[items objectAtIndex:2] intValue];
            EQ[i].A->bullet = [[items objectAtIndex:3] intValue];
            EQ[i].A->hitCount = [[items objectAtIndex:4] intValue];
            EQ[i].A->successRate = [[items objectAtIndex:5] intValue];
            EQ[i].A->vigor = [[items objectAtIndex:6] intValue];
            EQ[i].A->hitPercent = [[items objectAtIndex:7] intValue];
            
            items = [[fileDataArray objectAtIndex:3] componentsSeparatedByString:@","];
            
            EQ[i].A->costType = [[items objectAtIndex:0] intValue];
            
            if(EQ[i].A->costType == 0) {
                EQ[i].A->MP = [[items objectAtIndex:1] intValue];
                EQ[i].A->pMP = [[items objectAtIndex:2] intValue];
            }
            else if(EQ[i].A->costType == 1) {
                EQ[i].A->AP = [[items objectAtIndex:1] intValue];
                EQ[i].A->pAP = [[items objectAtIndex:2] intValue];
            }
            else if(EQ[i].A->costType == 2) {
                EQ[i].A->HP = [[items objectAtIndex:1] intValue];
                EQ[i].A->pHP = [[items objectAtIndex:2] intValue];
            }
            
            EQ[i].A->cSupply = [[items objectAtIndex:3] intValue];
            EQ[i].A->cFood = [[items objectAtIndex:4] intValue];
            EQ[i].A->cMoney = [[items objectAtIndex:5] intValue];
            
            items = [[fileDataArray objectAtIndex:4] componentsSeparatedByString:@","];
            
            EQ[i].A->riku = [[items objectAtIndex:0] intValue];
            EQ[i].A->chu = [[items objectAtIndex:1] intValue];
            EQ[i].A->umi = [[items objectAtIndex:2] intValue];
            EQ[i].A->sora = [[items objectAtIndex:3] intValue];
            EQ[i].A->dmgExtend = [[items objectAtIndex:4] intValue];
            
            EQ[i].A->cmd = [[fileDataArray objectAtIndex:5] retain];
            EQ[i].A->msg = @"";
            
            //[self AddDAMAGE:&UC[i].A->D :0];
            //[self AddDMGEXTEND:&UC[i].A->E :0];
            
            DAMAGE *Dtop = EQ[i].A->D;
            DMGEXTEND *Etop = EQ[i].A->E;
            static bool omfgFlag;
            
            int stringType = 0;
            int stringRange = 1;
            int stringNumber = 0;
            for (int k = 6; k<[fileDataArray count];k++) {
                NSString *str = [fileDataArray objectAtIndex:k];
                NSRange rangeSearch, rangeSearch2;
                NSArray *rangeArray;
                rangeSearch = [str rangeOfString:@"####"];
                rangeArray = [str componentsSeparatedByString:@","];
                rangeSearch2 = [str rangeOfString:@"----"];
                static int omg = 0;
                static int omg2 = 0;
                
                if(k == [fileDataArray count] - 1){
                    omg2 = 0;
                }
                
                if(stringType == 0)
                    if (rangeSearch.location != NSNotFound) {
                    }else if(rangeSearch2.location != NSNotFound){
                        stringType = 1;
                        omg = 0;
                    }else{
                        if(EQ[i].A->msg == NULL){
                            EQ[i].A->msg = [str retain];
                        }else{
                            if(omfgFlag) EQ[i].A->msg = [[EQ[i].A->msg stringByAppendingFormat:@"\n"] retain];
                            EQ[i].A->msg = [[EQ[i].A->msg stringByAppendingFormat:@"%@", str] retain];
                            omfgFlag = true;
                        }
                    }else if(stringType == 1){stringRange ++;
                        if(rangeSearch2.location != NSNotFound){
                            stringType = 2;
                        }
                        else if(rangeSearch.location != NSNotFound){
                            stringRange = 0;
                        }else if(stringRange == 1){
                            if(omg == 0) {
                                [self AddDAMAGE:&EQ[i].A->D :0];
                                Dtop = EQ[i].A->D;
                            }
                            omg++;
                            EQ[i].A->D->type = [[rangeArray objectAtIndex:0] intValue];
                            EQ[i].A->D->count = [[rangeArray objectAtIndex:1] intValue];
                            EQ[i].A->D->pCount = [[rangeArray objectAtIndex:2] intValue];
                        }else if(stringRange == 2){
                            
                            EQ[i].A->D->seed = [[rangeArray objectAtIndex:0] intValue];
                            EQ[i].A->D->sort = [[rangeArray objectAtIndex:1] intValue];
                            EQ[i].A->D->continium = [[rangeArray objectAtIndex:2] intValue];
                            EQ[i].A->D->absolute = [[rangeArray objectAtIndex:3] intValue];
                            EQ[i].A->D->beam = [[rangeArray objectAtIndex:4] intValue];
                            EQ[i].A->D->noSizeFix = [[rangeArray objectAtIndex:5] intValue];
                            
                            stringNumber++;
                            NSString *str2 = [fileDataArray objectAtIndex:k+1];
                            NSRange rangeSearch3 = [str2 rangeOfString:@"####"];
                            if(stringNumber >= 1 && rangeSearch3.location != NSNotFound) [self AddDAMAGE:&EQ[i].A->D :stringNumber-1];
                            EQ[i].A->D = EQ[i].A->D->next;
                        }
                    }else if(stringType == 2){stringRange ++;
                        
                        if(rangeSearch2.location != NSNotFound){
                            stringType = 3;
                        }
                        else if(rangeSearch.location != NSNotFound){
                            stringRange = 0;
                            stringNumber = 0;
                        }else if(stringRange == 1){stringNumber++;
                            if(omg2 == 0) {
                                [self AddDMGEXTEND:&EQ[i].A->E :0];
                                Etop = EQ[i].A->E;
                            }
                            omg2++;
                            EQ[i].A->E->rate = [[rangeArray objectAtIndex:0] intValue];
                            EQ[i].A->E->hit = [[rangeArray objectAtIndex:2] intValue];
                            EQ[i].A->E->atkHit = [[rangeArray objectAtIndex:1] intValue];
                            
                            NSString *str2 = [fileDataArray objectAtIndex:k+1];
                            NSRange rangeSearch3 = [str2 rangeOfString:@"####"];
                            if(stringNumber >= 1 && rangeSearch3.location != NSNotFound) [self AddDMGEXTEND:&EQ[i].A->E :stringNumber-1];
                            
                            EQ[i].A->E = EQ[i].A->E->next;
                        }
                        
                    }
            }
            EQ[i].A->D = Dtop;
            EQ[i].A->E = Etop;
            
            omfgFlag = false;
            if([fileDataArray2 count]-1 > j) EQ[i].A = EQ[i].A->next;
            else EQ[i].A->next = NULL;
        }
        
        if(EQ[i].attackListNum <= 0) Atop = NULL;
        EQ[i].A = Atop;
    }
    
    /*
     for (int i=0; i< itemNumb; i++)
     [self setTotalDamage:i row:<#(int)#>];
     */
}


-(ATTACK*)AllocATTACK{
    return (calloc(1, sizeof(ATTACK)));
}
-(DAMAGE*)AllocDAMAGE{
    return (calloc(1, sizeof(DAMAGE)));
}
-(DMGEXTEND*)AllocDMGEXTEND{
    return (calloc(1, sizeof(DMGEXTEND)));
}

-(void)AddATTACK:(ATTACK**)top:(int)no{
    ATTACK *ptr = *top;
    if(*top == NULL){
        *top = [self AllocATTACK];
        ptr = *top;
        ptr->index = no;
        ptr->next = NULL;
    }else{
        while(ptr->next != NULL) ptr = ptr->next;
        ptr->next = [self AllocATTACK];
        ptr->index = no;
        ptr->next->next = NULL;
        
    }
    
    
}

-(void)AddDAMAGE:(DAMAGE**)top:(int)no{
    DAMAGE *ptr = *top;
    if(*top == NULL){
        *top = [self AllocDAMAGE];
        ptr = *top;
        ptr->index = no;
        ptr->next = NULL;
    }else{
        while(ptr->next != NULL) ptr = ptr->next;
        ptr->next = [self AllocDAMAGE];
        ptr->index = no;
        ptr->next->next = NULL;
        
    }
    
    
}

-(void)AddDMGEXTEND:(DMGEXTEND**)top:(int)no{
    DMGEXTEND *ptr = *top;
    if(*top == NULL){
        *top = [self AllocDMGEXTEND];
        ptr = *top;
        ptr->index = no;
        ptr->next = NULL;
    }else{
        while(ptr->next != NULL) ptr = ptr->next;
        ptr->next = [self AllocDMGEXTEND];
        ptr->index = no;
        ptr->next->next = NULL;
        
    }
    
    
}



-(void)initItemList{
    equipListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"equipItemMA"];
    [equipItemMA removeAllObjects];
    [self didChangeValueForKey:@"equipItemMA"];
    
    for(int i = 0;i < eItemNum;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        NSString *str = @"";
        [dict setValue:[NSString stringWithFormat:@"%@", EQ[i].name] forKey:@"name"];
        
        if(!EQ[i].name){
            EQ[i].name = [[NSString stringWithFormat:@"新規アイテム%d", i] retain];
            EQ[i].nameRecognition = [[NSString stringWithFormat:@"新規アイテム%d", i] retain];
            EQ[i].nameID = [[NSString stringWithFormat:@"eq%d", i] retain];
            [dict setValue:EQ[i].name forKey:@"name"];
        }
        
        if(EQ[i].HP != 0)
            str = [str stringByAppendingFormat:@"HP %d ", (int)EQ[i].HP];
        if(EQ[i].MP != 0)
            str = [str stringByAppendingFormat:@"MP %d ", (int)EQ[i].MP];
        if(EQ[i].STR != 0) 
            str = [str stringByAppendingFormat:@"STR %d ", (int)EQ[i].STR];
        if(EQ[i].VIT != 0)
            str = [str stringByAppendingFormat:@"VIT %d ", (int)EQ[i].VIT];
        if(EQ[i].AGI != 0)
            str = [str stringByAppendingFormat:@"AGI %d ", (int)EQ[i].AGI];
        if(EQ[i].DEX != 0)
            str = [str stringByAppendingFormat:@"DEX %d ", (int)EQ[i].DEX];
        if(EQ[i].MEN != 0)
            str = [str stringByAppendingFormat:@"MEN %d ", (int)EQ[i].MEN];
        if(EQ[i].INT != 0)
            str = [str stringByAppendingFormat:@"INT %d ", (int)EQ[i].INT];
        if(EQ[i].LUK != 0)
            str = [str stringByAppendingFormat:@"LUK %d ", (int)EQ[i].LUK];
        if(EQ[i].Weight != 0)
            str = [str stringByAppendingFormat:@"重さ %d ", (int)EQ[i].Weight];
        
        [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"memo"];
        
        [self willChangeValueForKey:@"equipListMA"];
        [equipListMA addObject:dict];
        [self didChangeValueForKey:@"equipListMA"];
    }
    
    
}


-(void)initUnitChipList{
    unitChipListMA = [NSMutableArray new];
    
    for(int i = 0;i < chipNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        if(!UC[i].nameID){
            UC[i].name = [[NSString stringWithFormat:@"新規ユニット"] retain];
            UC[i].nameNick = [[NSString stringWithFormat:@"新規ニックネーム"] retain];
            UC[i].nameClass = [[NSString stringWithFormat:@"新規クラス"] retain];
            UC[i].name = [[UC[i].name stringByAppendingFormat:@"%d",i+1] retain];
            UC[i].nameID = @"uc";
            UC[i].nameID = [[UC[i].nameID stringByAppendingFormat:@"%d",i+1] retain];
            UC[i].nameRecognition = [@"新規名前" retain];
            UC[i].nameRecognition = [[UC[i].nameRecognition stringByAppendingFormat:@"%d",i+1] retain];
            UC[i].iName = @"uc";
            UC[i].iName = [[UC[i].iName stringByAppendingFormat:@"%d",i+1] retain];
            UC[i].iNameb = @"ucb";
            UC[i].iNameb = [[UC[i].iNameb stringByAppendingFormat:@"%d",i+1] retain];
            UC[i].R_M.air = 100;
            UC[i].R_M.arrow = 100;
            UC[i].R_M.blood = 100;
            UC[i].R_M.blow = 100;
            
            UC[i].R_M.charm = 100;
            UC[i].R_M.cold = 100;
            UC[i].R_M.confusion = 100;
            UC[i].R_M.dark = 100;
            
            UC[i].R_M.electoric = 100;
            UC[i].R_M.explosion = 100;
            UC[i].R_M.flame = 100;
            UC[i].R_M.gas = 100;
            
            UC[i].R_M.gun = 100;
            UC[i].R_M.holy = 100;
            UC[i].R_M.paralysis = 100;
            UC[i].R_M.poison = 100;
            
            UC[i].R_M.shell = 100;
            UC[i].R_M.silent = 100;
            UC[i].R_M.slash = 100;
            UC[i].R_M.sleep = 100;
            
            UC[i].R_M.stub = 100;
            UC[i].R_M.water = 100;
        }
        
        [dict setValue:UC[i].img forKey:@"img"];
        [dict setValue:UC[i].imgb forKey:@"imgBig"];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[i].name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%g", UC[i].S_M.HP] forKey:@"HP"];
        [dict setValue:[NSString stringWithFormat:@"%g", UC[i].S_M.BP] forKey:@"BP"];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[i].nameClass] forKey:@"nameC"];
        [self willChangeValueForKey:@"unitChipListMA"];
        [unitChipListMA addObject:dict];
        [self didChangeValueForKey:@"unitChipListMA"];
    }
    
    
}

-(void)initTotalDamage{
    for(int i = 0;i < chipNumb;i++){
        int j = 0;
        while (j < 64) {
            [self setTotalDamage:i row:j];
            j++;
        }
    }
    
    for(int i = 0;i < itemNumb;i++){
        int j = 0;
        while (j < 64) {
            [self setTotalDamageEQ:i row:j];
            j++;
        }
    }

}

-(void)initAttackList{
    attackListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"attackListMA"];
    [attackListMA removeAllObjects];
    [self didChangeValueForKey:@"attackListMA"];
    
    int i0 = 0;
    
    ATTACK *Atop = UC[clickIndex].A;
    
    while (i0 < 64) {
     [self setTotalDamage:(int)clickIndex row:i0];
        i0++;
    }
    
    UC[clickIndex].A = Atop;
    
    if(UC[clickIndex].A == NULL) return;
    
    for(int i = 0;i < UC[clickIndex].attackListNum;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        NSString *str = NULL;
        double countNumb;
        if(UC[clickIndex].A == NULL) break;
        if(UC[clickIndex].A->name == NULL) continue;
        
        if(UC[clickIndex].A->D != NULL){
            if(UC[clickIndex].A->D->type == 0) str = [NSString stringWithFormat:@"攻"];
            if(UC[clickIndex].A->D->type == 1) str = [NSString stringWithFormat:@"防"];
            if(UC[clickIndex].A->D->type == 2) str = [NSString stringWithFormat:@"命"];
            if(UC[clickIndex].A->D->type == 3) str = [NSString stringWithFormat:@"回"];
            if(UC[clickIndex].A->D->type == 4) str = [NSString stringWithFormat:@"演"];
            if(UC[clickIndex].A->D->type == 5) str = [NSString stringWithFormat:@"会"];
            
            countNumb = UC[clickIndex].A->totalD;
            str = [str stringByAppendingFormat:@"%g", countNumb];
            
        }
        [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"atk"];
        
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].A->name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d", UC[clickIndex].A->hitPercent] forKey:@"hit"];
        [dict setValue:[NSString stringWithFormat:@"%d", UC[clickIndex].A->vigor] forKey:@"vigor"];
        [dict setValue:[NSString stringWithFormat:@"%d", UC[clickIndex].A->bullet] forKey:@"bullet"];
        NSString *rangeStr = @"";
        if(UC[clickIndex].A->P) rangeStr = @"P";
        if(UC[clickIndex].A->melee) rangeStr = [rangeStr stringByAppendingFormat:@"●"];
        else rangeStr = [rangeStr stringByAppendingFormat:@"□"];
        if(UC[clickIndex].A->rangeA == UC[clickIndex].A->rangeB)
            [dict setValue:[NSString stringWithFormat:@"%@%d", rangeStr, UC[clickIndex].A->rangeA] forKey:@"range"];
        else
            [dict setValue:[NSString stringWithFormat:@"%@%d-%d", rangeStr, UC[clickIndex].A->rangeA, UC[clickIndex].A->rangeB] forKey:@"range"];
        
        if(UC[clickIndex].A->MP > 0)
        [dict setValue:[NSString stringWithFormat:@"MP%g", UC[clickIndex].A->MP + floor(UC[clickIndex].A->pMP*UC[clickIndex].S_M.MP/100 + 0.5)] forKey:@"cost"];
        else if(UC[clickIndex].A->AP > 0)
        [dict setValue:[NSString stringWithFormat:@"AP%g", UC[clickIndex].A->AP+ floor(UC[clickIndex].A->pAP*UC[clickIndex].S_M.AP/100 + 0.5)] forKey:@"cost"];
        else if(UC[clickIndex].A->HP > 0)
        [dict setValue:[NSString stringWithFormat:@"HP%g", UC[clickIndex].A->HP+ floor(UC[clickIndex].A->pHP*UC[clickIndex].S_M.HP/100 + 0.5)] forKey:@"cost"];
        
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].A->cmd] forKey:@"command"];
        
        if(UC[clickIndex].A->D != NULL){
        if(UC[clickIndex].A->D->seed == 0) [dict setValue:[NSString stringWithFormat:@"打撃"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 1) [dict setValue:[NSString stringWithFormat:@"斬撃"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 2) [dict setValue:[NSString stringWithFormat:@"突き"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 3) [dict setValue:[NSString stringWithFormat:@"射手"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 4) [dict setValue:[NSString stringWithFormat:@"銃撃"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 5) [dict setValue:[NSString stringWithFormat:@"砲撃"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 6) [dict setValue:[NSString stringWithFormat:@"火炎"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 7) [dict setValue:[NSString stringWithFormat:@"冷気"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 8) [dict setValue:[NSString stringWithFormat:@"電撃"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 9) [dict setValue:[NSString stringWithFormat:@"風圧"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 10) [dict setValue:[NSString stringWithFormat:@"流水"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 11) [dict setValue:[NSString stringWithFormat:@"ガス"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 12) [dict setValue:[NSString stringWithFormat:@"神聖"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 13) [dict setValue:[NSString stringWithFormat:@"暗黒"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 14) [dict setValue:[NSString stringWithFormat:@"爆撃"] forKey:@"type"];
        if(UC[clickIndex].A->D->seed == 15) [dict setValue:[NSString stringWithFormat:@"流血"] forKey:@"type"];
        }
        [self willChangeValueForKey:@"attackListMA"];
        [attackListMA addObject:dict];
        [self didChangeValueForKey:@"attackListMA"];
        
        UC[clickIndex].A = UC[clickIndex].A->next;
    }
    
    UC[clickIndex].A = Atop;
    
}

-(void)initAttackList2{
    attackListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"attackListMA"];
    [attackListMA removeAllObjects];
    [self didChangeValueForKey:@"attackListMA"];
    
    int i0 = 0;
    
    ATTACK *Atop = LC[cil].A;
    
    while (i0 < 64) {
        [self setTotalDamage2:(int)cil row:i0];
        i0++;
    }
    
    LC[cil].A = Atop;
    
    if(LC[cil].A == NULL) return;
    
    for(int i = 0;i < LC[cil].attackListNum;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        NSString *str = NULL;
        double countNumb = 0;
        if(LC[cil].A == NULL) break;
        if(LC[cil].A->name == NULL) continue;
        
        if(LC[cil].A->D != NULL){

            str = [NSString stringWithFormat:@"攻"];
            
            countNumb = LC[cil].A->totalD;
            str = [str stringByAppendingFormat:@"%g", countNumb];
            
        }
        [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"atk"];
        
        [dict setValue:[NSString stringWithFormat:@"%@", LC[cil].A->name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d", LC[cil].A->hitPercent] forKey:@"hit"];
        [dict setValue:[NSString stringWithFormat:@"%d", LC[cil].A->vigor] forKey:@"vigor"];
        [dict setValue:[NSString stringWithFormat:@"%d", LC[cil].A->bullet] forKey:@"bullet"];
        NSString *rangeStr = @"";
        if(LC[cil].A->P) rangeStr = @"P";
        if(LC[cil].A->melee) rangeStr = [rangeStr stringByAppendingFormat:@"●"];
        else rangeStr = [rangeStr stringByAppendingFormat:@"□"];
        if(LC[cil].A->rangeA == LC[cil].A->rangeB)
            [dict setValue:[NSString stringWithFormat:@"%@%d", rangeStr, LC[cil].A->rangeA] forKey:@"range"];
        else
            [dict setValue:[NSString stringWithFormat:@"%@%d-%d", rangeStr, LC[cil].A->rangeA, LC[cil].A->rangeB] forKey:@"range"];
        
        if(LC[cil].A->EN > 0)
            [dict setValue:[NSString stringWithFormat:@"EN%g", LC[cil].A->EN + floor(LC[cil].A->pEN*LC[cil].S_M.EN/100 + 0.5)] forKey:@"cost"];
        if(LC[cil].A->HP > 0)
            [dict setValue:[NSString stringWithFormat:@"HP%g", LC[cil].A->HP + floor(LC[cil].A->pEN*LC[cil].S_M.HP/100 + 0.5)] forKey:@"cost"];
        
        [dict setValue:[NSString stringWithFormat:@"%@", LC[cil].A->cmd] forKey:@"command"];
        
        if(LC[cil].A->D != NULL){
            if(LC[cil].A->D->seed == 0) [dict setValue:[NSString stringWithFormat:@"打撃"] forKey:@"type"];
            if(LC[cil].A->D->seed == 1) [dict setValue:[NSString stringWithFormat:@"斬撃"] forKey:@"type"];
            if(LC[cil].A->D->seed == 2) [dict setValue:[NSString stringWithFormat:@"突き"] forKey:@"type"];
            if(LC[cil].A->D->seed == 3) [dict setValue:[NSString stringWithFormat:@"射手"] forKey:@"type"];
            if(LC[cil].A->D->seed == 4) [dict setValue:[NSString stringWithFormat:@"銃撃"] forKey:@"type"];
            if(LC[cil].A->D->seed == 5) [dict setValue:[NSString stringWithFormat:@"砲撃"] forKey:@"type"];
            if(LC[cil].A->D->seed == 6) [dict setValue:[NSString stringWithFormat:@"火炎"] forKey:@"type"];
            if(LC[cil].A->D->seed == 7) [dict setValue:[NSString stringWithFormat:@"冷気"] forKey:@"type"];
            if(LC[cil].A->D->seed == 8) [dict setValue:[NSString stringWithFormat:@"電撃"] forKey:@"type"];
            if(LC[cil].A->D->seed == 9) [dict setValue:[NSString stringWithFormat:@"風圧"] forKey:@"type"];
            if(LC[cil].A->D->seed == 10) [dict setValue:[NSString stringWithFormat:@"流水"] forKey:@"type"];
            if(LC[cil].A->D->seed == 11) [dict setValue:[NSString stringWithFormat:@"ガス"] forKey:@"type"];
            if(LC[cil].A->D->seed == 12) [dict setValue:[NSString stringWithFormat:@"神聖"] forKey:@"type"];
            if(LC[cil].A->D->seed == 13) [dict setValue:[NSString stringWithFormat:@"暗黒"] forKey:@"type"];
            if(LC[cil].A->D->seed == 14) [dict setValue:[NSString stringWithFormat:@"爆撃"] forKey:@"type"];
            if(LC[cil].A->D->seed == 15) [dict setValue:[NSString stringWithFormat:@"流血"] forKey:@"type"];
        }
        [self willChangeValueForKey:@"attackListMA"];
        [attackListMA addObject:dict];
        [self didChangeValueForKey:@"attackListMA"];
        
        LC[cil].A = LC[cil].A->next;
    }
    
    LC[cil].A = Atop;
    
}

-(void)initAttackListEQ{
    attackListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"attackListMA"];
    [attackListMA removeAllObjects];
    [self didChangeValueForKey:@"attackListMA"];
    
    int i0 = 0;
    
    ATTACK *Atop = EQ[clickIndexEQ].A;
    
    while (i0 < 64) {
        [self setTotalDamageEQ:(int)clickIndexEQ row:i0];
        i0++;
    }
    
    EQ[clickIndexEQ].A = Atop;
    
    if(EQ[clickIndexEQ].A == NULL) return;
    
    for(int i = 0;i < EQ[clickIndexEQ].attackListNum;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        NSString *str = NULL;
        double countNumb;
        if(EQ[clickIndexEQ].A == NULL) break;
        if(EQ[clickIndexEQ].A->name == NULL) continue;
        
        if(EQ[clickIndexEQ].A->D != NULL){
            if(EQ[clickIndexEQ].A->D->type == 0) str = [NSString stringWithFormat:@"攻"];
            if(EQ[clickIndexEQ].A->D->type == 1) str = [NSString stringWithFormat:@"防"];
            if(EQ[clickIndexEQ].A->D->type == 2) str = [NSString stringWithFormat:@"命"];
            if(EQ[clickIndexEQ].A->D->type == 3) str = [NSString stringWithFormat:@"回"];
            if(EQ[clickIndexEQ].A->D->type == 4) str = [NSString stringWithFormat:@"演"];
            if(EQ[clickIndexEQ].A->D->type == 5) str = [NSString stringWithFormat:@"会"];
            
            countNumb = EQ[clickIndexEQ].A->totalD;
            str = [str stringByAppendingFormat:@"%g", countNumb];
            
        }
        [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"atk"];
        
        [dict setValue:[NSString stringWithFormat:@"%@", EQ[clickIndexEQ].A->name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d", EQ[clickIndexEQ].A->hitPercent] forKey:@"hit"];
        [dict setValue:[NSString stringWithFormat:@"%d", EQ[clickIndexEQ].A->vigor] forKey:@"vigor"];
        [dict setValue:[NSString stringWithFormat:@"%d", EQ[clickIndexEQ].A->bullet] forKey:@"bullet"];
        NSString *rangeStr = @"";
        if(EQ[clickIndexEQ].A->P) rangeStr = @"P";
        if(EQ[clickIndexEQ].A->melee) rangeStr = [rangeStr stringByAppendingFormat:@"●"];
        else rangeStr = [rangeStr stringByAppendingFormat:@"□"];
        if(EQ[clickIndexEQ].A->rangeA == EQ[clickIndexEQ].A->rangeB)
            [dict setValue:[NSString stringWithFormat:@"%@%d", rangeStr, EQ[clickIndexEQ].A->rangeA] forKey:@"range"];
        else
            [dict setValue:[NSString stringWithFormat:@"%@%d-%d", rangeStr, EQ[clickIndexEQ].A->rangeA, EQ[clickIndexEQ].A->rangeB] forKey:@"range"];
        
        if(EQ[clickIndexEQ].A->MP > 0)
            [dict setValue:[NSString stringWithFormat:@"MP%g", EQ[clickIndexEQ].A->MP + floor(EQ[clickIndexEQ].A->pMP)] forKey:@"cost"];
        else if(EQ[clickIndexEQ].A->AP > 0)
            [dict setValue:[NSString stringWithFormat:@"AP%g", EQ[clickIndexEQ].A->AP+ floor(EQ[clickIndexEQ].A->pAP)] forKey:@"cost"];
        else if(EQ[clickIndexEQ].A->HP > 0)
            [dict setValue:[NSString stringWithFormat:@"HP%g", EQ[clickIndexEQ].A->HP+ floor(EQ[clickIndexEQ].A->pHP)] forKey:@"cost"];
        
        [dict setValue:[NSString stringWithFormat:@"%@", EQ[clickIndexEQ].A->cmd] forKey:@"command"];
        
        if(EQ[clickIndexEQ].A->D != NULL){
            if(EQ[clickIndexEQ].A->D->seed == 0) [dict setValue:[NSString stringWithFormat:@"打撃"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 1) [dict setValue:[NSString stringWithFormat:@"斬撃"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 2) [dict setValue:[NSString stringWithFormat:@"突き"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 3) [dict setValue:[NSString stringWithFormat:@"射手"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 4) [dict setValue:[NSString stringWithFormat:@"銃撃"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 5) [dict setValue:[NSString stringWithFormat:@"砲撃"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 6) [dict setValue:[NSString stringWithFormat:@"火炎"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 7) [dict setValue:[NSString stringWithFormat:@"冷気"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 8) [dict setValue:[NSString stringWithFormat:@"電撃"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 9) [dict setValue:[NSString stringWithFormat:@"風圧"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 10) [dict setValue:[NSString stringWithFormat:@"流水"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 11) [dict setValue:[NSString stringWithFormat:@"ガス"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 12) [dict setValue:[NSString stringWithFormat:@"神聖"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 13) [dict setValue:[NSString stringWithFormat:@"暗黒"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 14) [dict setValue:[NSString stringWithFormat:@"爆撃"] forKey:@"type"];
            if(EQ[clickIndexEQ].A->D->seed == 15) [dict setValue:[NSString stringWithFormat:@"流血"] forKey:@"type"];
        }
        [self willChangeValueForKey:@"attackListMA"];
        [attackListMA addObject:dict];
        [self didChangeValueForKey:@"attackListMA"];
        
        EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
    }
    
    EQ[clickIndexEQ].A = Atop;
    
}


-(IBAction)skillListBtnUCL:(id)sender{
    windowPoint.x = [UCLDetailPanel frame].origin.x + 40;
    windowPoint.y = [UCLDetailPanel frame].origin.y + 80;
    [UCLPanelSkill setFrameOrigin:windowPoint];
    [self initSkill];
    [self initSkillList];
    SKLrow = -1;
    [UCLPanelSkill makeKeyAndOrderFront:nil];
}

-(IBAction)attackListBtnlUCL:(id)sender{
    
    if(!loadChipSideFlag){
        [self initAttackSet];
    }else{
        [self initAttackSet2];
    }
    
    /*
    windowPoint.x = [UCLDetailPanel frame].origin.x;
    windowPoint.y = [UCLDetailPanel frame].origin.y;
    [UCLPanelAttackList setFrameOrigin:windowPoint];
     */
    [UCLPanelAttackList makeKeyAndOrderFront:nil];
}

-(IBAction)registListBtnlUCL:(id)sender{
    
    
    if(!loadChipSideFlag){
    [RETFblow setIntValue:UC[clickIndex].R_M.blow];
    [RETFslash setIntValue:UC[clickIndex].R_M.slash];
    [RETFstub setIntValue:UC[clickIndex].R_M.stub];
    [RETFarrow setIntValue:UC[clickIndex].R_M.arrow];
    [RETFgun setIntValue:UC[clickIndex].R_M.gun];
    [RETFshell setIntValue:UC[clickIndex].R_M.shell];
    
    [RETFflame setIntValue:UC[clickIndex].R_M.flame];
    [RETFcold setIntValue:UC[clickIndex].R_M.cold];
    [RETFelectoric setIntValue:UC[clickIndex].R_M.electoric];
    [RETFair setIntValue:UC[clickIndex].R_M.air];
    [RETFwater setIntValue:UC[clickIndex].R_M.water];
    [RETFgas setIntValue:UC[clickIndex].R_M.gas];
    [RETFholy setIntValue:UC[clickIndex].R_M.holy];
    [RETFdark setIntValue:UC[clickIndex].R_M.dark];
    [RETFexplosion setIntValue:UC[clickIndex].R_M.explosion];
    [RETFblood setIntValue:UC[clickIndex].R_M.blood];
    
    [RETFparalysis setIntValue:UC[clickIndex].R_M.paralysis];
    [RETFconfusion setIntValue:UC[clickIndex].R_M.confusion];
    [RETFpoison setIntValue:UC[clickIndex].R_M.poison];
    [RETFsleep setIntValue:UC[clickIndex].R_M.sleep];
    [RETFcharm setIntValue:UC[clickIndex].R_M.charm];
    [RETFsilent setIntValue:UC[clickIndex].R_M.silent];
        
    }else{
        [RETFblow setIntValue:LC[cil].R_M.blow];
        [RETFslash setIntValue:LC[cil].R_M.slash];
        [RETFstub setIntValue:LC[cil].R_M.stub];
        [RETFarrow setIntValue:LC[cil].R_M.arrow];
        [RETFgun setIntValue:LC[cil].R_M.gun];
        [RETFshell setIntValue:LC[cil].R_M.shell];
        
        [RETFflame setIntValue:LC[cil].R_M.flame];
        [RETFcold setIntValue:LC[cil].R_M.cold];
        [RETFelectoric setIntValue:LC[cil].R_M.electoric];
        [RETFair setIntValue:LC[cil].R_M.air];
        [RETFwater setIntValue:LC[cil].R_M.water];
        [RETFgas setIntValue:LC[cil].R_M.gas];
        [RETFholy setIntValue:LC[cil].R_M.holy];
        [RETFdark setIntValue:LC[cil].R_M.dark];
        [RETFexplosion setIntValue:LC[cil].R_M.explosion];
        [RETFblood setIntValue:LC[cil].R_M.blood];
        
        [RETFparalysis setIntValue:LC[cil].R_M.paralysis];
        [RETFconfusion setIntValue:LC[cil].R_M.confusion];
        [RETFpoison setIntValue:LC[cil].R_M.poison];
        [RETFsleep setIntValue:LC[cil].R_M.sleep];
        [RETFcharm setIntValue:LC[cil].R_M.charm];
        [RETFsilent setIntValue:LC[cil].R_M.silent];
    
    }
    
    windowPoint.x = [UCLDetailPanel frame].origin.x + 150;
    windowPoint.y = [UCLDetailPanel frame].origin.y;
    [UCLPanelRegist setFrameOrigin:windowPoint];
    [UCLPanelRegist makeKeyAndOrderFront:nil];
}


-(IBAction)skillListBtnSubmitUCL:(id)sender{
    [self willChangeValueForKey:@"skillListMA"];
    [skillListMA removeAllObjects];
    [self didChangeValueForKey:@"skillListMA"];
    [UCLPanelSkill close];
}
-(IBAction)attackListBtnSubmitlUCL:(id)sender{
    
    if(EQmodeFlag){
        [self saveDataALEQ];
        
        [UCLPanelAttack close];
        return;
    }
    
    if(!loadChipSideFlag){
        [self saveDataAL];
    }else{
        [self saveDataAL2];
    }
    [UCLPanelAttack close];
}
-(IBAction)registListBtnlSubmitUCL:(id)sender{
    
    
    if(!loadChipSideFlag){
    UC[clickIndex].R_M.blow = [RETFblow intValue];
    UC[clickIndex].R_M.slash = [RETFslash intValue];
    UC[clickIndex].R_M.stub = [RETFstub intValue];
    UC[clickIndex].R_M.arrow = [RETFarrow intValue];
    UC[clickIndex].R_M.gun = [RETFgun intValue];
    UC[clickIndex].R_M.shell = [RETFshell intValue];
    
    UC[clickIndex].R_M.flame = [RETFflame intValue];
    UC[clickIndex].R_M.cold = [RETFcold intValue];
    UC[clickIndex].R_M.electoric = [RETFelectoric intValue];
    UC[clickIndex].R_M.air = [RETFair intValue];
    UC[clickIndex].R_M.water = [RETFwater intValue];
    UC[clickIndex].R_M.gas = [RETFgas intValue];
    UC[clickIndex].R_M.holy = [RETFholy intValue];
    UC[clickIndex].R_M.dark = [RETFdark intValue];
    UC[clickIndex].R_M.explosion = [RETFexplosion intValue];
    UC[clickIndex].R_M.blood = [RETFblood intValue];
    
    UC[clickIndex].R_M.paralysis = [RETFparalysis intValue];
    UC[clickIndex].R_M.confusion = [RETFconfusion intValue];
    UC[clickIndex].R_M.poison = [RETFpoison intValue];
    UC[clickIndex].R_M.sleep = [RETFsleep intValue];
    UC[clickIndex].R_M.charm = [RETFcharm intValue];
    UC[clickIndex].R_M.silent = [RETFsilent intValue];
    
    UC[clickIndex].R_C = UC[clickIndex].R_M;
    }else{
        LC[cil].R_M.blow = [RETFblow intValue];
        LC[cil].R_M.slash = [RETFslash intValue];
        LC[cil].R_M.stub = [RETFstub intValue];
        LC[cil].R_M.arrow = [RETFarrow intValue];
        LC[cil].R_M.gun = [RETFgun intValue];
        LC[cil].R_M.shell = [RETFshell intValue];
        
        LC[cil].R_M.flame = [RETFflame intValue];
        LC[cil].R_M.cold = [RETFcold intValue];
        LC[cil].R_M.electoric = [RETFelectoric intValue];
        LC[cil].R_M.air = [RETFair intValue];
        LC[cil].R_M.water = [RETFwater intValue];
        LC[cil].R_M.gas = [RETFgas intValue];
        LC[cil].R_M.holy = [RETFholy intValue];
        LC[cil].R_M.dark = [RETFdark intValue];
        LC[cil].R_M.explosion = [RETFexplosion intValue];
        LC[cil].R_M.blood = [RETFblood intValue];
        
        LC[cil].R_M.paralysis = [RETFparalysis intValue];
        LC[cil].R_M.confusion = [RETFconfusion intValue];
        LC[cil].R_M.poison = [RETFpoison intValue];
        LC[cil].R_M.sleep = [RETFsleep intValue];
        LC[cil].R_M.charm = [RETFcharm intValue];
        LC[cil].R_M.silent = [RETFsilent intValue];
        
        LC[cil].R_C = LC[cil].R_M;
    }
    
    
    [UCLPanelRegist close];
}

-(IBAction)insertSkillUCL:(id)sender{

}
-(IBAction)removeSkillUCL:(id)sender{

}

-(IBAction)mobileUCL:(id)sender{

}
-(IBAction)skillUCL:(id)sender{

}
-(IBAction)equiplUCL:(id)sender{

}


-(IBAction)UCLPanelEquipListSubmitBtn:(id)sender{
    [UCLPanelEquipList close];
}
-(IBAction)UCLPanelSkillListSubmitBtn:(id)sender{
    [UCLPanelSkillList close];
}

-(IBAction)UCLPanelEquipListOpenBtn:(id)sender{
    windowPoint.x = [UCLPanel frame].origin.x + 50;
    windowPoint.y = [UCLPanel frame].origin.y;
    [UCLPanelEquipList setFrameOrigin:windowPoint];
    [UCLPanelEquipList makeKeyAndOrderFront:nil];
}
-(IBAction)UCLPanelSkillListOpenBtn:(id)sender{
    windowPoint.x = [UCLPanel frame].origin.x + 50;
    windowPoint.y = [UCLPanel frame].origin.y;
    [UCLPanelSkillList setFrameOrigin:windowPoint];
    [UCLPanelSkillList makeKeyAndOrderFront:nil];
}

-(IBAction)insertAttackList:(id)sender{
    
    if(EQmodeFlag){
    
        if(1){
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setValue:[NSString stringWithFormat:@"新技"] forKey:@"name"];
            
            ATTACK *Atop = EQ[clickIndexEQ].A;
            
            if(clickedRowAT < 0){
                EQ[clickIndexEQ].A = Atop;
                if([attackListMA count] == 0){
                    EQ[clickIndexEQ].A = (ATTACK*)malloc(sizeof(ATTACK));
                    //INIT 処理
                    
                    EQ[clickIndexEQ].A = [self initAttackData:EQ[clickIndexEQ].A];
                    Atop = EQ[clickIndexEQ].A;
                }else{
                    while(EQ[clickIndexEQ].A->next) EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
                    EQ[clickIndexEQ].A->next = (ATTACK*)malloc(sizeof(ATTACK));
                    EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
                    //INIT 処理
                    EQ[clickIndexEQ].A = [self initAttackData:EQ[clickIndexEQ].A];
                    EQ[clickIndexEQ].A = Atop;
                }
                
                [dict setValue:[NSString stringWithFormat:@"%@", EQ[clickIndexEQ].A->name] forKey:@"name"];
                
                [self willChangeValueForKey:@"attackListMA"];
                [attackListMA insertObject:dict atIndex:[attackListMA count]];
                [self didChangeValueForKey:@"attackListMA"];
                [attackListAC setSelectionIndex:999];
                EQ[clickIndexEQ].attackListNum++;
                clickedRowAT = -1;
            }else{
                EQ[clickIndexEQ].A = Atop;
                if([attackListMA count] == 0){
                    EQ[clickIndexEQ].A = (ATTACK*)malloc(sizeof(ATTACK));
                    //INIT 処理
                    EQ[clickIndexEQ].A = [self initAttackData:EQ[clickIndexEQ].A];
                    Atop = EQ[clickIndexEQ].A;
                }else if(clickedRowAT > 0){
                    for (int i = 0; i < clickedRowAT-1;i++)
                        EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
                    ATTACK *tmp = (ATTACK*)malloc(sizeof(ATTACK));
                    *tmp = *EQ[clickIndexEQ].A->next;
                    EQ[clickIndexEQ].A->next = (ATTACK*)malloc(sizeof(ATTACK));
                    EQ[clickIndexEQ].A->next->next = tmp;
                    EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
                    //INIT 処理
                    EQ[clickIndexEQ].A = [self initAttackData:EQ[clickIndexEQ].A];
                    EQ[clickIndexEQ].A = Atop;
                }else{
                    ATTACK *tmp = (ATTACK*)malloc(sizeof(ATTACK));
                    tmp->next = EQ[clickIndexEQ].A;
                    // INIT 処理[self InitAttack:tmp];
                    tmp = [self initAttackData:tmp];
                    Atop = tmp;
                    EQ[clickIndexEQ].A = Atop;
                }
                
                [dict setValue:[NSString stringWithFormat:@"%@", EQ[clickIndexEQ].A->name] forKey:@"name"];
                
                [self willChangeValueForKey:@"attackListMA"];
                [attackListMA insertObject:dict atIndex:clickedRowAT];
                [self didChangeValueForKey:@"attackListMA"];
                [attackListAC setSelectionIndex:clickedRowAT];
                EQ[clickIndexEQ].attackListNum++;
            }
            
        }
    
        return;
    }
    
    if(!loadChipSideFlag){
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"新技"] forKey:@"name"];
    
    ATTACK *Atop = UC[clickIndex].A;
    
    if(clickedRowAT < 0){
        UC[clickIndex].A = Atop;
        if([attackListMA count] == 0){
            UC[clickIndex].A = (ATTACK*)malloc(sizeof(ATTACK));
            //INIT 処理
            
            UC[clickIndex].A = [self initAttackData:UC[clickIndex].A];
            
            Atop = UC[clickIndex].A;
        }else{
            while(UC[clickIndex].A->next) UC[clickIndex].A = UC[clickIndex].A->next;
            UC[clickIndex].A->next = (ATTACK*)malloc(sizeof(ATTACK));
            UC[clickIndex].A = UC[clickIndex].A->next;
            //INIT 処理
            UC[clickIndex].A = [self initAttackData:UC[clickIndex].A];
            
            UC[clickIndex].A = Atop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].A->name] forKey:@"name"];
        
        [self willChangeValueForKey:@"attackListMA"];
        [attackListMA insertObject:dict atIndex:[attackListMA count]];
        [self didChangeValueForKey:@"attackListMA"];
        [attackListAC setSelectionIndex:999];
        UC[clickIndex].attackListNum++;
        clickedRowAT = -1;
    }else{
        UC[clickIndex].A = Atop;
        if([attackListMA count] == 0){
            UC[clickIndex].A = (ATTACK*)malloc(sizeof(ATTACK));
            //INIT 処理
            UC[clickIndex].A = [self initAttackData:UC[clickIndex].A];
            
            Atop = UC[clickIndex].A;
        }else if(clickedRowAT > 0){
            for (int i = 0; i < clickedRowAT-1;i++)
                UC[clickIndex].A = UC[clickIndex].A->next;
            ATTACK *tmp = (ATTACK*)malloc(sizeof(ATTACK));
            *tmp = *UC[clickIndex].A->next;
            UC[clickIndex].A->next = (ATTACK*)malloc(sizeof(ATTACK));
            UC[clickIndex].A->next->next = tmp;
            UC[clickIndex].A = UC[clickIndex].A->next;
            //INIT 処理
            [self initAttackData:UC[clickIndex].A];
            UC[clickIndex].A = Atop;
        }else{
            ATTACK *tmp = (ATTACK*)malloc(sizeof(ATTACK));
            tmp->next = UC[clickIndex].A;
            // INIT 処理[self InitAttack:tmp];
            tmp = [self initAttackData:tmp];
            Atop = tmp;
            UC[clickIndex].A = Atop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].A->name] forKey:@"name"];
        
        [self willChangeValueForKey:@"attackListMA"];
        [attackListMA insertObject:dict atIndex:clickedRowAT];
        [self didChangeValueForKey:@"attackListMA"];
        [attackListAC setSelectionIndex:clickedRowAT];
        UC[clickIndex].attackListNum++;
    }

    }else{
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"新技"] forKey:@"name"];
        
        ATTACK *Atop = LC[cil].A;
        
        if(clickedRowAT < 0){
            LC[cil].A = Atop;
            if([attackListMA count] == 0){
                LC[cil].A = (ATTACK*)malloc(sizeof(ATTACK));
                //INIT 処理
                
                LC[cil].A->name = [@"新技" retain];
                LC[cil].A->cmd = [@"A" retain];
                LC[cil].A->rangeA = 1;
                LC[cil].A->rangeB = 1;
                LC[cil].A->extent = 0;
                LC[cil].A->successRate = 100;
                LC[cil].A->costType = 0;
                LC[cil].A->type = 0;
                LC[cil].A = [self initAfuckingSTATUS2:LC[cil].A];
                LC[cil].A->D = NULL;
                LC[cil].A->E = NULL;
                LC[cil].A->next = NULL;
                Atop = LC[cil].A;
            }else{
                while(LC[cil].A->next) LC[cil].A = LC[cil].A->next;
                LC[cil].A->next = (ATTACK*)malloc(sizeof(ATTACK));
                LC[cil].A = LC[cil].A->next;
                //INIT 処理
                LC[cil].A->name = [@"新技" retain];
                LC[cil].A->cmd = [@"A" retain];
                LC[cil].A->rangeA = 1;
                LC[cil].A->rangeB = 1;
                LC[cil].A->extent = 0;
                LC[cil].A->successRate = 100;
                LC[cil].A->costType = 0;
                LC[cil].A->type = 0;
                LC[cil].A = [self initAfuckingSTATUS2:LC[cil].A];
                LC[cil].A->D = NULL;
                LC[cil].A->E = NULL;
                LC[cil].A->next = NULL;
                LC[cil].A = Atop;
            }
            
            [dict setValue:[NSString stringWithFormat:@"%@", LC[cil].A->name] forKey:@"name"];
            
            [self willChangeValueForKey:@"attackListMA"];
            [attackListMA insertObject:dict atIndex:[attackListMA count]];
            [self didChangeValueForKey:@"attackListMA"];
            [attackListAC setSelectionIndex:999];
            LC[cil].attackListNum++;
            clickedRowAT = -1;
        }else{
            LC[cil].A = Atop;
            if([attackListMA count] == 0){
                LC[cil].A = (ATTACK*)malloc(sizeof(ATTACK));
                //INIT 処理
                LC[cil].A->name = [@"新技" retain];
                LC[cil].A->cmd = [@"A" retain];
                LC[cil].A->rangeA = 1;
                LC[cil].A->rangeB = 1;
                LC[cil].A->extent = 0;
                LC[cil].A->successRate = 100;
                LC[cil].A->costType = 0;
                LC[cil].A->type = 0;
                LC[cil].A = [self initAfuckingSTATUS2:LC[cil].A];
                LC[cil].A->D = NULL;
                LC[cil].A->E = NULL;
                LC[cil].A->next = NULL;
                Atop = LC[cil].A;
            }else if(clickedRowAT > 0){
                for (int i = 0; i < clickedRowAT-1;i++)
                    LC[cil].A = LC[cil].A->next;
                ATTACK *tmp = (ATTACK*)malloc(sizeof(ATTACK));
                *tmp = *LC[cil].A->next;
                LC[cil].A->next = (ATTACK*)malloc(sizeof(ATTACK));
                LC[cil].A->next->next = tmp;
                LC[cil].A = LC[cil].A->next;
                //INIT 処理
                LC[cil].A->name = [@"新技" retain];
                LC[cil].A->cmd = [@"A" retain];
                LC[cil].A->rangeA = 1;
                LC[cil].A->rangeB = 1;
                LC[cil].A->extent = 0;
                LC[cil].A->successRate = 100;
                LC[cil].A->costType = 0;
                LC[cil].A->type = 0;
                LC[cil].A = [self initAfuckingSTATUS2:LC[cil].A];
                LC[cil].A->D = NULL;
                LC[cil].A->E = NULL;
                LC[cil].A = Atop;
            }else{
                ATTACK *tmp = (ATTACK*)malloc(sizeof(ATTACK));
                tmp->next = LC[cil].A;
                // INIT 処理[self InitAttack:tmp];
                tmp->name = [@"新技" retain];
                tmp->cmd = [@"A" retain];
                tmp->rangeA = 1;
                tmp->rangeB = 1;
                tmp->extent = 0;
                tmp->successRate = 100;
                tmp->costType = 0;
                tmp->type = 0;
                tmp = [self initAfuckingSTATUS2:tmp];
                
                tmp->D = NULL;
                tmp->E = NULL;
                Atop = tmp;
                LC[cil].A = Atop;
            }
            
            [dict setValue:[NSString stringWithFormat:@"%@", LC[cil].A->name] forKey:@"name"];
            
            [self willChangeValueForKey:@"attackListMA"];
            [attackListMA insertObject:dict atIndex:clickedRowAT];
            [self didChangeValueForKey:@"attackListMA"];
            [attackListAC setSelectionIndex:clickedRowAT];
            LC[cil].attackListNum++;
    
        }
    }
    
}

-(ATTACK*)initAttackData:(ATTACK*)A{


    A->name = [@"新技" retain];
    A->cmd = [@"A" retain];
    A->msg = [@"" retain];
    A->rangeA = 1;
    A->rangeB = 1;
    A->extent = 0;
    A->type = 0;
    A->costType = 0;
    A->MP = 0;
    A->pMP = 0;
    A->hitCount = 1;
    A->hitPercent = 0;
    A->successRate = 100;
    A->bullet = -1;
    A->riku = 0;
    A->sora = 0;
    A->umi = 0;
    A->chu = 0;
    A->melee = 0;
    A->P = 0;
    A->vigor = 0;
    A->cSupply = 0;
    A->cMoney = 0;
    A->cFood = 0;
    A->dmgExtend = 0;
    A->D = NULL;
    A->E = NULL;
    
    return A;
}

-(ATTACK*)initAfuckingSTATUS2:(ATTACK*)A{

    A->trig = 0;
    A->type = 0;
    A->melee = 0;
    A->P = 0;
    
    A->rangeA = 1;
    A->rangeB = 1;
    A->extent = 0;
    A->bullet = 0;
    A->hitCount = 0;
    A->successRate = 100;
    A->vigor = 0;
    A->hitPercent = 0;
    
    A->costType = 0;

    A->EN = 0;
    A->pEN = 0;

    A->HP = 0;
    A->pHP = 0;

    A->cSupply = 0;
    A->cFood = 0;
    A->cMoney = 0;
    
    A->riku = 0;
    A->umi = 0;
    A->sora = 0;
    A->dmgExtend = 0;
    
    A->cmd = @"A";
    A->msg = @"";

    
    return A;
}

-(IBAction)removeAttackList:(id)sender{
    
    if(EQmodeFlag){
    
        ATTACK *Atop = EQ[clickIndexEQ].A;
        
        if(clickedRowAT == -1){
            clickedRowAT = (int)[attackListMA count] - 1;
        }
        
        if([attackListMA count] > 0){
            
            if(clickedRowAT == 0){
                EQ[clickIndexEQ].A = Atop;
                EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
                Atop = EQ[clickIndexEQ].A;
            }else if(clickedRowAT == [attackListMA count] - 1){
                EQ[clickIndexEQ].A = Atop;
                while(EQ[clickIndexEQ].A->next->next){
                    EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
                }
                EQ[clickIndexEQ].A->next = NULL;
            }else{
                EQ[clickIndexEQ].A = Atop;
                for (int i = 0; i < clickedRowAT - 1;i++)
                    EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
                EQ[clickIndexEQ].A->next = EQ[clickIndexEQ].A->next->next;
            }
            
            [self willChangeValueForKey:@"attackListMA"];
            [attackListMA removeObjectAtIndex:clickedRowAT];
            [self didChangeValueForKey:@"attackListMA"];
            [attackListAC setSelectionIndex:clickedRowAT-1];
            if(clickedRowAT < 0) [attackListAC setSelectionIndex:[attackListMA count]-1];
            if(clickedRowAT == 0) [attackListAC setSelectionIndex:0];
            if(clickedRowAT > 0) clickedRowAT--;
        }
        EQ[clickIndexEQ].A = Atop;
        EQ[clickIndexEQ].attackListNum--;
      
        
        return;
    }
    
    if(!loadChipSideFlag){
    
        ATTACK *Atop = UC[clickIndex].A;
        
        if(clickedRowAT == -1){
            clickedRowAT = (int)[attackListMA count] - 1;
        }
        
        if([attackListMA count] > 0){
            
            if(clickedRowAT == 0){
                UC[clickIndex].A = Atop;
                UC[clickIndex].A = UC[clickIndex].A->next;
                Atop = UC[clickIndex].A;
            }else if(clickedRowAT == [attackListMA count] - 1){
                UC[clickIndex].A = Atop;
                while(UC[clickIndex].A->next->next){
                    UC[clickIndex].A = UC[clickIndex].A->next;
                }
                UC[clickIndex].A->next = NULL;
            }else{
                UC[clickIndex].A = Atop;
                for (int i = 0; i < clickedRowAT - 1;i++)
                    UC[clickIndex].A = UC[clickIndex].A->next;
                UC[clickIndex].A->next = UC[clickIndex].A->next->next;
            }
            
            [self willChangeValueForKey:@"attackListMA"];
            [attackListMA removeObjectAtIndex:clickedRowAT];
            [self didChangeValueForKey:@"attackListMA"];
            [attackListAC setSelectionIndex:clickedRowAT-1];
            if(clickedRowAT < 0) [attackListAC setSelectionIndex:[attackListMA count]-1];
            if(clickedRowAT == 0) [attackListAC setSelectionIndex:0];
            if(clickedRowAT > 0) clickedRowAT--;
        }
        UC[clickIndex].A = Atop;
        UC[clickIndex].attackListNum--;
    }else{
        ATTACK *Atop = LC[cil].A;
        
        if(clickedRowAT == -1){
            clickedRowAT = (int)[attackListMA count] - 1;
        }
        
        if([attackListMA count] > 0){
            
            if(clickedRowAT == 0){
                LC[cil].A = Atop;
                LC[cil].A = LC[cil].A->next;
                Atop = LC[cil].A;
            }else if(clickedRowAT == [attackListMA count] - 1){
                LC[cil].A = Atop;
                while(LC[cil].A->next->next){
                    LC[cil].A = LC[cil].A->next;
                }
                LC[cil].A->next = NULL;
            }else{
                LC[cil].A = Atop;
                for (int i = 0; i < clickedRowAT - 1;i++)
                    LC[cil].A = LC[cil].A->next;
                LC[cil].A->next = LC[cil].A->next->next;
            }
            
            [self willChangeValueForKey:@"attackListMA"];
            [attackListMA removeObjectAtIndex:clickedRowAT];
            [self didChangeValueForKey:@"attackListMA"];
            [attackListAC setSelectionIndex:clickedRowAT-1];
            if(clickedRowAT < 0) [attackListAC setSelectionIndex:[attackListMA count]-1];
            if(clickedRowAT == 0) [attackListAC setSelectionIndex:0];
            if(clickedRowAT > 0) clickedRowAT--;
        }
        LC[cil].A = Atop;
        LC[cil].attackListNum--;
    
    
    
    }
    
}
-(IBAction)insertComboList:(id)sender{

}
-(IBAction)removeComboList:(id)sender{
    
}

-(IBAction)submitAttackList:(id)sender{
    
    if(EQmodeFlag){
    
        ATTACK *Atop = EQ[clickIndexEQ].A;
        
        
        for(int i = 0;i < clickIndexAL;i++){
            EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
        }
        
        EQ[clickIndexEQ].A->name = [[ALTFname stringValue] retain];
        EQ[clickIndexEQ].A->rangeA = [ALTFrangeA intValue];
        EQ[clickIndexEQ].A->rangeB = [ALTFrangeB intValue];
        EQ[clickIndexEQ].A->extent = [ALTFextend intValue];
        
        EQ[clickIndexEQ].A->trig = [ALTFtrigger intValue];
        EQ[clickIndexEQ].A->melee = [ALTFmelee intValue];
        EQ[clickIndexEQ].A->P = [ALTFpass intValue];
        EQ[clickIndexEQ].A->dmgExtend = [ALTFdmgExtent intValue];
        EQ[clickIndexEQ].A->type = (int)[ALPUBwType indexOfSelectedItem];
        
        if([ALPUBcost indexOfSelectedItem] == 0){
            EQ[clickIndexEQ].A->costType = 0;
            EQ[clickIndexEQ].A->MP = [ALTFcost intValue];
            EQ[clickIndexEQ].A->pMP = [ALTFcostP intValue];
            EQ[clickIndexEQ].A->AP = 0;
            EQ[clickIndexEQ].A->pAP = 0;
            EQ[clickIndexEQ].A->HP = 0;
            EQ[clickIndexEQ].A->pHP = 0;
        }
        if([ALPUBcost indexOfSelectedItem] == 1){
            EQ[clickIndexEQ].A->costType = 1;
            EQ[clickIndexEQ].A->MP = 0;
            EQ[clickIndexEQ].A->pMP = 0;
            EQ[clickIndexEQ].A->HP = 0;
            EQ[clickIndexEQ].A->pHP = 0;
            EQ[clickIndexEQ].A->AP = [ALTFcost intValue];
            EQ[clickIndexEQ].A->pAP = [ALTFcostP intValue];
        }
        if([ALPUBcost indexOfSelectedItem] == 2){
            EQ[clickIndexEQ].A->costType = 2;
            EQ[clickIndexEQ].A->MP = 0;
            EQ[clickIndexEQ].A->pMP = 0;
            EQ[clickIndexEQ].A->AP = 0;
            EQ[clickIndexEQ].A->pAP = 0;
            EQ[clickIndexEQ].A->HP = [ALTFcost intValue];
            EQ[clickIndexEQ].A->pHP = [ALTFcostP intValue];
        }
        
        EQ[clickIndexEQ].A->bullet = [ALTFbullet intValue];
        EQ[clickIndexEQ].A->hitCount = [ALTFhitCount intValue];
        EQ[clickIndexEQ].A->successRate = [ALTFsuccessRate intValue];
        EQ[clickIndexEQ].A->vigor = [ALTFvigor intValue];
        EQ[clickIndexEQ].A->hitPercent = [ALTFhitRate intValue];
        
        EQ[clickIndexEQ].A->riku = (int)[ALPUBriku indexOfSelectedItem];
        EQ[clickIndexEQ].A->chu = (int)[ALPUBchu indexOfSelectedItem];
        EQ[clickIndexEQ].A->umi = (int)[ALPUBumi indexOfSelectedItem];
        EQ[clickIndexEQ].A->sora = (int)[ALPUBsora indexOfSelectedItem];
        
        EQ[clickIndexEQ].A->cSupply = [ALTFcSupply intValue];
        EQ[clickIndexEQ].A->cFood = [ALTFcFood intValue];
        EQ[clickIndexEQ].A->cMoney = [ALTFcMoney intValue];
        
        EQ[clickIndexEQ].A->cmd = [[ALTFcmd stringValue] retain];
        
        EQ[clickIndexEQ].A->msg = [[ALTFmsg stringValue] retain];
        
        
        EQ[clickIndexEQ].A = Atop;
        
        [self initAttackListEQ];
        [self saveDataALEQ];
        [attackListAC setSelectionIndex:clickIndexAL];

        [UCLPanelAttackDetail close];
        return;
    }
    
    if(!loadChipSideFlag){
        ATTACK *Atop = UC[clickIndex].A;
    
    
        for(int i = 0;i < clickIndexAL;i++){
            UC[clickIndex].A = UC[clickIndex].A->next;
        }
    
        UC[clickIndex].A->name = [[ALTFname stringValue] retain];
        UC[clickIndex].A->rangeA = [ALTFrangeA intValue];
        UC[clickIndex].A->rangeB = [ALTFrangeB intValue];
        UC[clickIndex].A->extent = [ALTFextend intValue];
    
        UC[clickIndex].A->trig = [ALTFtrigger intValue];
        UC[clickIndex].A->melee = [ALTFmelee intValue];
        UC[clickIndex].A->P = [ALTFpass intValue];
        UC[clickIndex].A->dmgExtend = [ALTFdmgExtent intValue];
        UC[clickIndex].A->type = (int)[ALPUBwType indexOfSelectedItem];
    
        if([ALPUBcost indexOfSelectedItem] == 0){
            UC[clickIndex].A->costType = 0;
            UC[clickIndex].A->MP = [ALTFcost intValue];
            UC[clickIndex].A->pMP = [ALTFcostP intValue];
            UC[clickIndex].A->AP = 0;
            UC[clickIndex].A->pAP = 0;
            UC[clickIndex].A->HP = 0;
            UC[clickIndex].A->pHP = 0;
        }
        if([ALPUBcost indexOfSelectedItem] == 1){
            UC[clickIndex].A->costType = 1;
            UC[clickIndex].A->MP = 0;
            UC[clickIndex].A->pMP = 0;
            UC[clickIndex].A->HP = 0;
            UC[clickIndex].A->pHP = 0;
            UC[clickIndex].A->AP = [ALTFcost intValue];
            UC[clickIndex].A->pAP = [ALTFcostP intValue];
        }
        if([ALPUBcost indexOfSelectedItem] == 2){
            UC[clickIndex].A->costType = 2;
            UC[clickIndex].A->MP = 0;
            UC[clickIndex].A->pMP = 0;
            UC[clickIndex].A->AP = 0;
            UC[clickIndex].A->pAP = 0;
            UC[clickIndex].A->HP = [ALTFcost intValue];
            UC[clickIndex].A->pHP = [ALTFcostP intValue];
        }
    
        UC[clickIndex].A->bullet = [ALTFbullet intValue];
        UC[clickIndex].A->hitCount = [ALTFhitCount intValue];
        UC[clickIndex].A->successRate = [ALTFsuccessRate intValue];
        UC[clickIndex].A->vigor = [ALTFvigor intValue];
        UC[clickIndex].A->hitPercent = [ALTFhitRate intValue];
    
        UC[clickIndex].A->riku = (int)[ALPUBriku indexOfSelectedItem];
        UC[clickIndex].A->chu = (int)[ALPUBchu indexOfSelectedItem];
        UC[clickIndex].A->umi = (int)[ALPUBumi indexOfSelectedItem];
        UC[clickIndex].A->sora = (int)[ALPUBsora indexOfSelectedItem];
    
        UC[clickIndex].A->cSupply = [ALTFcSupply intValue];
        UC[clickIndex].A->cFood = [ALTFcFood intValue];
        UC[clickIndex].A->cMoney = [ALTFcMoney intValue];
    
        UC[clickIndex].A->cmd = [[ALTFcmd stringValue] retain];
    
        UC[clickIndex].A->msg = [[ALTFmsg stringValue] retain];
    

        UC[clickIndex].A = Atop;
    
        [self initAttackList];
        [self saveDataAL];
        [attackListAC setSelectionIndex:clickIndexAL];
    }else{
    
        ATTACK *Atop = LC[cil].A;
        
        
        for(int i = 0;i < clickIndexAL;i++){
            LC[cil].A = LC[cil].A->next;
        }
        
        LC[cil].A->name = [[ALTFname stringValue] retain];
        LC[cil].A->rangeA = [ALTFrangeA intValue];
        LC[cil].A->rangeB = [ALTFrangeB intValue];
        LC[cil].A->extent = [ALTFextend intValue];
        
        LC[cil].A->trig = [ALTFtrigger intValue];
        LC[cil].A->melee = [ALTFmelee intValue];
        LC[cil].A->P = [ALTFpass intValue];
        LC[cil].A->dmgExtend = [ALTFdmgExtent intValue];
        LC[cil].A->type = (int)[ALPUBwType indexOfSelectedItem];
        
        if([ALPUBcost indexOfSelectedItem] == 0){
            LC[cil].A->costType = 0;
            LC[cil].A->EN = [ALTFcost intValue];
            LC[cil].A->pEN = [ALTFcostP intValue];
            LC[cil].A->HP = 0;
            LC[cil].A->pHP = 0;
        }
        if([ALPUBcost indexOfSelectedItem] == 1){
            LC[cil].A->costType = 1;
            LC[cil].A->EN = 0;
            LC[cil].A->pEN = 0;
            UC[clickIndex].A->HP = [ALTFcost intValue];
            UC[clickIndex].A->pHP = [ALTFcostP intValue];

        }
        
        LC[cil].A->bullet = [ALTFbullet intValue];
        LC[cil].A->hitCount = [ALTFhitCount intValue];
        LC[cil].A->successRate = [ALTFsuccessRate intValue];
        LC[cil].A->vigor = [ALTFvigor intValue];
        LC[cil].A->hitPercent = [ALTFhitRate intValue];
        
        LC[cil].A->riku = (int)[ALPUBriku indexOfSelectedItem];
        LC[cil].A->chu = (int)[ALPUBchu indexOfSelectedItem];
        LC[cil].A->umi = (int)[ALPUBumi indexOfSelectedItem];
        LC[cil].A->sora = (int)[ALPUBsora indexOfSelectedItem];
        
        LC[cil].A->cSupply = [ALTFcSupply intValue];
        LC[cil].A->cFood = [ALTFcFood intValue];
        LC[cil].A->cMoney = [ALTFcMoney intValue];
        
        LC[cil].A->cmd = [[ALTFcmd stringValue] retain];
        
        LC[cil].A->msg = [[ALTFmsg stringValue] retain];
        
        
        LC[cil].A = Atop;
        
        [self initAttackList2];
        [self saveDataAL2];
        [attackListAC setSelectionIndex:clickIndexAL];
    
    
    
    
    
    
    
    }
    
    [UCLPanelAttackDetail close];
}

-(IBAction)insertDamageList:(id)sender{
    
    if(EQmodeFlag){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        if([ALPUBtype indexOfSelectedItem] == 0)
            [dict setValue:[NSString stringWithFormat:@"攻%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
        if([ALPUBtype indexOfSelectedItem] == 1)
            [dict setValue:[NSString stringWithFormat:@"防%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
        if([ALPUBtype indexOfSelectedItem] == 2)
            [dict setValue:[NSString stringWithFormat:@"命%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
        if([ALPUBtype indexOfSelectedItem] == 3)
            [dict setValue:[NSString stringWithFormat:@"回%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
        if([ALPUBtype indexOfSelectedItem] == 4)
            [dict setValue:[NSString stringWithFormat:@"演%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
        if([ALPUBtype indexOfSelectedItem] == 5)
            [dict setValue:[NSString stringWithFormat:@"会%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
        
        NSString *str;
        
        if([ALPUBsort indexOfSelectedItem] == 0) str = [NSString stringWithFormat:@"ダ・"];
        if([ALPUBsort indexOfSelectedItem] == 1) str = [NSString stringWithFormat:@"回・"];
        if([ALPUBsort indexOfSelectedItem] == 2) str = [NSString stringWithFormat:@"復・"];
        if([ALPUBsort indexOfSelectedItem] == 3) str = [NSString stringWithFormat:@"減・"];
        if([ALPUBsort indexOfSelectedItem] == 4) str = [NSString stringWithFormat:@"増・"];
        if([ALPUBsort indexOfSelectedItem] == 5) str = [NSString stringWithFormat:@"毒・"];
        if([ALPUBsort indexOfSelectedItem] == 6) str = [NSString stringWithFormat:@"睡・"];
        if([ALPUBsort indexOfSelectedItem] == 7) str = [NSString stringWithFormat:@"混・"];
        if([ALPUBsort indexOfSelectedItem] == 8) str = [NSString stringWithFormat:@"麻・"];
        if([ALPUBsort indexOfSelectedItem] == 9) str = [NSString stringWithFormat:@"沈・"];
        if([ALPUBsort indexOfSelectedItem] == 10) str = [NSString stringWithFormat:@"魅・"];
        
        if([ALPUBseed indexOfSelectedItem] == 0) str = [str stringByAppendingFormat:@"打撃"];
        if([ALPUBseed indexOfSelectedItem] == 1) str = [str stringByAppendingFormat:@"斬撃"];
        if([ALPUBseed indexOfSelectedItem] == 2) str = [str stringByAppendingFormat:@"突き"];
        if([ALPUBseed indexOfSelectedItem] == 3) str = [str stringByAppendingFormat:@"射手"];
        if([ALPUBseed indexOfSelectedItem] == 4) str = [str stringByAppendingFormat:@"銃撃"];
        if([ALPUBseed indexOfSelectedItem] == 5) str = [str stringByAppendingFormat:@"砲撃"];
        if([ALPUBseed indexOfSelectedItem] == 6) str = [str stringByAppendingFormat:@"火炎"];
        if([ALPUBseed indexOfSelectedItem] == 7) str = [str stringByAppendingFormat:@"冷気"];
        if([ALPUBseed indexOfSelectedItem] == 8) str = [str stringByAppendingFormat:@"電撃"];
        if([ALPUBseed indexOfSelectedItem] == 9) str = [str stringByAppendingFormat:@"風圧"];
        if([ALPUBseed indexOfSelectedItem] == 10) str = [str stringByAppendingFormat:@"流水"];
        if([ALPUBseed indexOfSelectedItem] == 11) str = [str stringByAppendingFormat:@"ガス"];
        if([ALPUBseed indexOfSelectedItem] == 12) str = [str stringByAppendingFormat:@"神聖"];
        if([ALPUBseed indexOfSelectedItem] == 13) str = [str stringByAppendingFormat:@"暗黒"];
        if([ALPUBseed indexOfSelectedItem] == 14) str = [str stringByAppendingFormat:@"爆撃"];
        if([ALPUBseed indexOfSelectedItem] == 15) str = [str stringByAppendingFormat:@"流血"];
        
        
        ATTACK *aTop = EQ[clickIndexEQ].A;
        for(int k = 0;k < clickIndexAL;k++) {
            EQ[clickIndexEQ].A = EQ[clickIndex].A->next;
        }
        
        DAMAGE *Dtop = EQ[clickIndexEQ].A->D;
        if(!EQ[clickIndexEQ].A->D){
            EQ[clickIndexEQ].A->D = calloc(1, sizeof(DAMAGE));
            Dtop = EQ[clickIndexEQ].A->D;
        }
        while(EQ[clickIndexEQ].A->D->next){
            EQ[clickIndexEQ].A->D = EQ[clickIndexEQ].A->D->next;
        }
        
        if([damageListMA count] >= 1){
            EQ[clickIndexEQ].A->D->next = calloc(1, sizeof(DAMAGE));
            EQ[clickIndexEQ].A->D = EQ[clickIndexEQ].A->D->next;
        }
        EQ[clickIndexEQ].A->D->next = NULL;//Dtop;
        EQ[clickIndexEQ].A->D->count = [ALTFdmgCount intValue];
        EQ[clickIndexEQ].A->D->pCount = [ALTFdmgRate intValue];
        EQ[clickIndexEQ].A->D->type = (int)[ALPUBtype indexOfSelectedItem];
        EQ[clickIndexEQ].A->D->seed = (int)[ALPUBseed indexOfSelectedItem];
        EQ[clickIndexEQ].A->D->sort = (int)[ALPUBsort indexOfSelectedItem];
        EQ[clickIndexEQ].A->D->beam = [ALTFbeam intValue];
        EQ[clickIndexEQ].A->D->absolute = [ALTFabsolute intValue];
        EQ[clickIndexEQ].A->D->noSizeFix = [ALTFnoSizeFix intValue];
        EQ[clickIndexEQ].A->D->continium = [ALTFcontinuum intValue];
        
        [self setTotalDamageEQ:(int)clickIndex row:clickedRowAT];
        
        [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"type"];
        [self willChangeValueForKey:@"damageListMA"];
        [damageListMA addObject:dict];
        [self didChangeValueForKey:@"damageListMA"];
        [damageListAC setSelectionIndex:[damageListTV selectedRow]];
        
        EQ[clickIndexEQ].A->D = Dtop;
        
        EQ[clickIndexEQ].A = aTop;
    
    
        return;
    }
    
    
    if(!loadChipSideFlag){
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    if([ALPUBtype indexOfSelectedItem] == 0)
        [dict setValue:[NSString stringWithFormat:@"攻%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
    if([ALPUBtype indexOfSelectedItem] == 1)
        [dict setValue:[NSString stringWithFormat:@"防%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
    if([ALPUBtype indexOfSelectedItem] == 2)
        [dict setValue:[NSString stringWithFormat:@"命%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
    if([ALPUBtype indexOfSelectedItem] == 3)
        [dict setValue:[NSString stringWithFormat:@"回%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
    if([ALPUBtype indexOfSelectedItem] == 4)
        [dict setValue:[NSString stringWithFormat:@"演%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
    if([ALPUBtype indexOfSelectedItem] == 5)
        [dict setValue:[NSString stringWithFormat:@"会%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
    
    NSString *str;
    
    if([ALPUBsort indexOfSelectedItem] == 0) str = [NSString stringWithFormat:@"ダ・"];
    if([ALPUBsort indexOfSelectedItem] == 1) str = [NSString stringWithFormat:@"回・"];
    if([ALPUBsort indexOfSelectedItem] == 2) str = [NSString stringWithFormat:@"復・"];
    if([ALPUBsort indexOfSelectedItem] == 3) str = [NSString stringWithFormat:@"減・"];
    if([ALPUBsort indexOfSelectedItem] == 4) str = [NSString stringWithFormat:@"増・"];
    if([ALPUBsort indexOfSelectedItem] == 5) str = [NSString stringWithFormat:@"毒・"];
    if([ALPUBsort indexOfSelectedItem] == 6) str = [NSString stringWithFormat:@"睡・"];
    if([ALPUBsort indexOfSelectedItem] == 7) str = [NSString stringWithFormat:@"混・"];
    if([ALPUBsort indexOfSelectedItem] == 8) str = [NSString stringWithFormat:@"麻・"];
    if([ALPUBsort indexOfSelectedItem] == 9) str = [NSString stringWithFormat:@"沈・"];
    if([ALPUBsort indexOfSelectedItem] == 10) str = [NSString stringWithFormat:@"魅・"];
    
    if([ALPUBseed indexOfSelectedItem] == 0) str = [str stringByAppendingFormat:@"打撃"];
    if([ALPUBseed indexOfSelectedItem] == 1) str = [str stringByAppendingFormat:@"斬撃"];
    if([ALPUBseed indexOfSelectedItem] == 2) str = [str stringByAppendingFormat:@"突き"];
    if([ALPUBseed indexOfSelectedItem] == 3) str = [str stringByAppendingFormat:@"射手"];
    if([ALPUBseed indexOfSelectedItem] == 4) str = [str stringByAppendingFormat:@"銃撃"];
    if([ALPUBseed indexOfSelectedItem] == 5) str = [str stringByAppendingFormat:@"砲撃"];
    if([ALPUBseed indexOfSelectedItem] == 6) str = [str stringByAppendingFormat:@"火炎"];
    if([ALPUBseed indexOfSelectedItem] == 7) str = [str stringByAppendingFormat:@"冷気"];
    if([ALPUBseed indexOfSelectedItem] == 8) str = [str stringByAppendingFormat:@"電撃"];
    if([ALPUBseed indexOfSelectedItem] == 9) str = [str stringByAppendingFormat:@"風圧"];
    if([ALPUBseed indexOfSelectedItem] == 10) str = [str stringByAppendingFormat:@"流水"];
    if([ALPUBseed indexOfSelectedItem] == 11) str = [str stringByAppendingFormat:@"ガス"];
    if([ALPUBseed indexOfSelectedItem] == 12) str = [str stringByAppendingFormat:@"神聖"];
    if([ALPUBseed indexOfSelectedItem] == 13) str = [str stringByAppendingFormat:@"暗黒"];
    if([ALPUBseed indexOfSelectedItem] == 14) str = [str stringByAppendingFormat:@"爆撃"];
    if([ALPUBseed indexOfSelectedItem] == 15) str = [str stringByAppendingFormat:@"流血"];
    
    
    ATTACK *aTop = UC[clickIndex].A;
    for(int k = 0;k < clickIndexAL;k++) {
        UC[clickIndex].A = UC[clickIndex].A->next;
    }
    
    DAMAGE *Dtop = UC[clickIndex].A->D;
    if(!UC[clickIndex].A->D){
        UC[clickIndex].A->D = calloc(1, sizeof(DAMAGE));
        Dtop = UC[clickIndex].A->D;
    }
    while(UC[clickIndex].A->D->next){
        UC[clickIndex].A->D = UC[clickIndex].A->D->next;
    }
    
    if([damageListMA count] >= 1){
        UC[clickIndex].A->D->next = calloc(1, sizeof(DAMAGE));
        UC[clickIndex].A->D = UC[clickIndex].A->D->next;
    }
    UC[clickIndex].A->D->next = NULL;//Dtop;
        UC[clickIndex].A->D->count = [ALTFdmgCount intValue];
        UC[clickIndex].A->D->pCount = [ALTFdmgRate intValue];
        UC[clickIndex].A->D->type = (int)[ALPUBtype indexOfSelectedItem];
        UC[clickIndex].A->D->seed = (int)[ALPUBseed indexOfSelectedItem];
        UC[clickIndex].A->D->sort = (int)[ALPUBsort indexOfSelectedItem];
        UC[clickIndex].A->D->beam = [ALTFbeam intValue];
        UC[clickIndex].A->D->absolute = [ALTFabsolute intValue];
        UC[clickIndex].A->D->noSizeFix = [ALTFnoSizeFix intValue];
        UC[clickIndex].A->D->continium = [ALTFcontinuum intValue];
    
    [self setTotalDamage:(int)clickIndex row:clickedRowAT];
    
    [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"type"];
    [self willChangeValueForKey:@"damageListMA"];
    [damageListMA addObject:dict];
    [self didChangeValueForKey:@"damageListMA"];
    [damageListAC setSelectionIndex:[damageListTV selectedRow]];
    
        UC[clickIndex].A->D = Dtop;
    
        UC[clickIndex].A = aTop;
    }else{
    
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
            [dict setValue:[NSString stringWithFormat:@"攻%d+%d％", [ALTFdmgCount intValue], [ALTFdmgRate intValue]] forKey:@"count"];
        
        NSString *str;
        
        if([ALPUBsort indexOfSelectedItem] == 0) str = [NSString stringWithFormat:@"ダ・"];
        if([ALPUBsort indexOfSelectedItem] == 1) str = [NSString stringWithFormat:@"回・"];
        if([ALPUBsort indexOfSelectedItem] == 2) str = [NSString stringWithFormat:@"復・"];
        if([ALPUBsort indexOfSelectedItem] == 3) str = [NSString stringWithFormat:@"減・"];
        if([ALPUBsort indexOfSelectedItem] == 4) str = [NSString stringWithFormat:@"増・"];
        if([ALPUBsort indexOfSelectedItem] == 5) str = [NSString stringWithFormat:@"毒・"];
        if([ALPUBsort indexOfSelectedItem] == 6) str = [NSString stringWithFormat:@"睡・"];
        if([ALPUBsort indexOfSelectedItem] == 7) str = [NSString stringWithFormat:@"混・"];
        if([ALPUBsort indexOfSelectedItem] == 8) str = [NSString stringWithFormat:@"麻・"];
        if([ALPUBsort indexOfSelectedItem] == 9) str = [NSString stringWithFormat:@"沈・"];
        if([ALPUBsort indexOfSelectedItem] == 10) str = [NSString stringWithFormat:@"魅・"];
        
        if([ALPUBseed indexOfSelectedItem] == 0) str = [str stringByAppendingFormat:@"打撃"];
        if([ALPUBseed indexOfSelectedItem] == 1) str = [str stringByAppendingFormat:@"斬撃"];
        if([ALPUBseed indexOfSelectedItem] == 2) str = [str stringByAppendingFormat:@"突き"];
        if([ALPUBseed indexOfSelectedItem] == 3) str = [str stringByAppendingFormat:@"射手"];
        if([ALPUBseed indexOfSelectedItem] == 4) str = [str stringByAppendingFormat:@"銃撃"];
        if([ALPUBseed indexOfSelectedItem] == 5) str = [str stringByAppendingFormat:@"砲撃"];
        if([ALPUBseed indexOfSelectedItem] == 6) str = [str stringByAppendingFormat:@"火炎"];
        if([ALPUBseed indexOfSelectedItem] == 7) str = [str stringByAppendingFormat:@"冷気"];
        if([ALPUBseed indexOfSelectedItem] == 8) str = [str stringByAppendingFormat:@"電撃"];
        if([ALPUBseed indexOfSelectedItem] == 9) str = [str stringByAppendingFormat:@"風圧"];
        if([ALPUBseed indexOfSelectedItem] == 10) str = [str stringByAppendingFormat:@"流水"];
        if([ALPUBseed indexOfSelectedItem] == 11) str = [str stringByAppendingFormat:@"ガス"];
        if([ALPUBseed indexOfSelectedItem] == 12) str = [str stringByAppendingFormat:@"神聖"];
        if([ALPUBseed indexOfSelectedItem] == 13) str = [str stringByAppendingFormat:@"暗黒"];
        if([ALPUBseed indexOfSelectedItem] == 14) str = [str stringByAppendingFormat:@"爆撃"];
        if([ALPUBseed indexOfSelectedItem] == 15) str = [str stringByAppendingFormat:@"流血"];
        
        
        ATTACK *aTop = LC[cil].A;
        for(int k = 0;k < clickIndexAL;k++) {
            LC[cil].A = LC[cil].A->next;
        }
        
        DAMAGE *Dtop = LC[cil].A->D;
        if(!LC[cil].A->D){
            LC[cil].A->D = calloc(1, sizeof(DAMAGE));
            Dtop = LC[cil].A->D;
        }
        while(LC[cil].A->D->next){
            LC[cil].A->D = LC[cil].A->D->next;
        }
        
        if([damageListMA count] >= 1){
            LC[cil].A->D->next = calloc(1, sizeof(DAMAGE));
            LC[cil].A->D = LC[cil].A->D->next;
        }
        LC[cil].A->D->next = NULL;//Dtop;
        LC[cil].A->D->count = [ALTFdmgCount intValue];
        LC[cil].A->D->pCount = [ALTFdmgRate intValue];
        LC[cil].A->D->type = (int)[ALPUBtype indexOfSelectedItem];
        LC[cil].A->D->seed = (int)[ALPUBseed indexOfSelectedItem];
        LC[cil].A->D->sort = (int)[ALPUBsort indexOfSelectedItem];
        LC[cil].A->D->beam = [ALTFbeam intValue];
        LC[cil].A->D->absolute = [ALTFabsolute intValue];
        LC[cil].A->D->noSizeFix = [ALTFnoSizeFix intValue];
        LC[cil].A->D->continium = [ALTFcontinuum intValue];
        
        [self setTotalDamage2:(int)clickIndex row:clickedRowAT];
        
        [dict setValue:[NSString stringWithFormat:@"%@", str] forKey:@"type"];
        [self willChangeValueForKey:@"damageListMA"];
        [damageListMA addObject:dict];
        [self didChangeValueForKey:@"damageListMA"];
        [damageListAC setSelectionIndex:[damageListTV selectedRow]];
        
        LC[cil].A->D = Dtop;
        
        LC[cil].A = aTop;
    
    }
    
}

-(IBAction)removeDamageList:(id)sender{
    
    if(EQmodeFlag){
        if([damageListTV selectedRow] >= 0){
            
            ATTACK *aTop = EQ[clickIndexEQ].A;
            for(int k = 0;k < clickIndexAL;k++) {
                EQ[clickIndexEQ].A = EQ[clickIndexEQ].A->next;
            }
            DAMAGE *dmgNext = NULL;
            dmgNext = calloc(1, sizeof(DAMAGE));
            
            int clickIndexDL = (int)[damageListTV selectedRow];
            
            DAMAGE *dTop = EQ[clickIndexEQ].A->D;
            for(int k = 0;k < clickIndexDL;k++){
                EQ[clickIndexEQ].A->D = EQ[clickIndexEQ].A->D->next;
            }
            
            if(clickIndexDL >= 0 && [damageListMA count] > 0){
                if(clickIndexDL == 0){
                    EQ[clickIndexEQ].A->D = dTop;
                    EQ[clickIndexEQ].A->D = EQ[clickIndexEQ].A->D->next;
                    dTop = EQ[clickIndexEQ].A->D;
                }else if(clickIndexDL == [damageListMA count] - 1){
                    EQ[clickIndexEQ].A->D = dTop;
                    while(EQ[clickIndexEQ].A->D->next->next){
                        EQ[clickIndexEQ].A->D = EQ[clickIndexEQ].A->D->next;
                    }
                    EQ[clickIndex].A->D->next = NULL;
                }else{
                    EQ[clickIndexEQ].A->D = dTop;
                    for (int i = 0; i < clickIndexDL - 1;i++)
                        EQ[clickIndexEQ].A->D = EQ[clickIndexEQ].A->D->next;
                    EQ[clickIndexEQ].A->D->next = EQ[clickIndexEQ].A->D->next->next;
                }
            }
            EQ[clickIndexEQ].A->D = dTop;
            
            [self willChangeValueForKey:@"damageListMA"];
            [damageListMA removeObjectAtIndex:[damageListTV selectedRow]];
            [self didChangeValueForKey:@"damageListMA"];
            if([damageListMA count] > 0) [damageListAC setSelectionIndex:[damageListTV selectedRow]-1];
            
            EQ[clickIndexEQ].A = aTop;
    
    
    
        }
        return;
    }
    
    if(!loadChipSideFlag){
    if([damageListTV selectedRow] >= 0){
        
        ATTACK *aTop = UC[clickIndex].A;
        for(int k = 0;k < clickIndexAL;k++) {
            UC[clickIndex].A = UC[clickIndex].A->next;
        }
        DAMAGE *dmgNext = NULL;
        dmgNext = calloc(1, sizeof(DAMAGE));
        
        int clickIndexDL = (int)[damageListTV selectedRow];
        
        DAMAGE *dTop = UC[clickIndex].A->D;
        for(int k = 0;k < clickIndexDL;k++){
            UC[clickIndex].A->D = UC[clickIndex].A->D->next;
        }
    
        if(clickIndexDL >= 0 && [damageListMA count] > 0){
        if(clickIndexDL == 0){
            UC[clickIndex].A->D = dTop;
            UC[clickIndex].A->D = UC[clickIndex].A->D->next;
            dTop = UC[clickIndex].A->D;
        }else if(clickIndexDL == [damageListMA count] - 1){
            UC[clickIndex].A->D = dTop;
            while(UC[clickIndex].A->D->next->next){
                UC[clickIndex].A->D = UC[clickIndex].A->D->next;
            }
            UC[clickIndex].A->D->next = NULL;
        }else{
            UC[clickIndex].A->D = dTop;
            for (int i = 0; i < clickIndexDL - 1;i++)
                UC[clickIndex].A->D = UC[clickIndex].A->D->next;
            UC[clickIndex].A->D->next = UC[clickIndex].A->D->next->next;
        }
        }
        UC[clickIndex].A->D = dTop;
        
        [self willChangeValueForKey:@"damageListMA"];
        [damageListMA removeObjectAtIndex:[damageListTV selectedRow]];
        [self didChangeValueForKey:@"damageListMA"];
        if([damageListMA count] > 0) [damageListAC setSelectionIndex:[damageListTV selectedRow]-1];
        
        UC[clickIndex].A = aTop;
    }
    
    }else{
        if([damageListTV selectedRow] >= 0){
            
            ATTACK *aTop = LC[cil].A;
            for(int k = 0;k < clickIndexAL;k++) {
                LC[cil].A = LC[cil].A->next;
            }
            DAMAGE *dmgNext = NULL;
            dmgNext = calloc(1, sizeof(DAMAGE));
            
            int clickIndexDL = (int)[damageListTV selectedRow];
            
            DAMAGE *dTop = LC[cil].A->D;
            for(int k = 0;k < clickIndexDL;k++){
                LC[cil].A->D = LC[cil].A->D->next;
            }
            
            if(clickIndexDL >= 0 && [damageListMA count] > 0){
                if(clickIndexDL == 0){
                    LC[cil].A->D = dTop;
                    LC[cil].A->D = LC[cil].A->D->next;
                    dTop = LC[cil].A->D;
                }else if(clickIndexDL == [damageListMA count] - 1){
                    LC[cil].A->D = dTop;
                    while(LC[cil].A->D->next->next){
                        LC[cil].A->D = LC[cil].A->D->next;
                    }
                    LC[cil].A->D->next = NULL;
                }else{
                    LC[cil].A->D = dTop;
                    for (int i = 0; i < clickIndexDL - 1;i++)
                        LC[cil].A->D = LC[cil].A->D->next;
                    LC[cil].A->D->next = LC[cil].A->D->next->next;
                }
            }
            LC[cil].A->D = dTop;
            
            [self willChangeValueForKey:@"damageListMA"];
            [damageListMA removeObjectAtIndex:[damageListTV selectedRow]];
            [self didChangeValueForKey:@"damageListMA"];
            if([damageListMA count] > 0) [damageListAC setSelectionIndex:[damageListTV selectedRow]-1];
            
            LC[cil].A = aTop;
        }
    
    }
}



-(IBAction)insertHitList:(id)sender{
    
    if(!loadChipSideFlag){
    ATTACK *aTop = UC[clickIndex].A;
    for(int k = 0;k < clickIndexAL;k++) {
        UC[clickIndex].A = UC[clickIndex].A->next;
    }
    
    DMGEXTEND *Etop = UC[clickIndex].A->E;
    
    UC[clickIndex].A->E = Etop;
    
    if(!UC[clickIndex].A->E) {[self AddDMGEXTEND:&UC[clickIndex].A->E :0];
        Etop = UC[clickIndex].A->E;
    }
    
    for(int k = 0;k < (int)[hitListMA count]-1;k++) {
     UC[clickIndex].A->E = UC[clickIndex].A->E->next;
    }
    
    
    if((int)[hitListMA count] > 0){
    UC[clickIndex].A->E->next = calloc(1, sizeof(DMGEXTEND));
    UC[clickIndex].A->E = UC[clickIndex].A->E->next;
    }
    UC[clickIndex].A->E->next = NULL;
    UC[clickIndex].A->E->atkHit = [ALTFatkHit intValue];
    UC[clickIndex].A->E->hit = [ALTFhit intValue];
    UC[clickIndex].A->E->rate = [ALTFrate intValue];
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"%d", [ALTFrate intValue]] forKey:@"rate"];
    [dict setValue:[NSString stringWithFormat:@"%d", [ALTFhit intValue]] forKey:@"hit"];
    [dict setValue:[NSString stringWithFormat:@"%d", [ALTFatkHit intValue]] forKey:@"atkHit"];
    
    [self willChangeValueForKey:@"hitListMA"];
    [hitListMA addObject:dict];
    [self didChangeValueForKey:@"hitListMA"];
    [hitListAC setSelectionIndex:[hitListTV selectedRow]];
    
    UC[clickIndex].A->E = Etop;
    
    UC[clickIndex].A = aTop;
    
    }else{
    
        ATTACK *aTop = LC[cil].A;
        for(int k = 0;k < clickIndexAL;k++) {
            LC[cil].A = LC[cil].A->next;
        }
        
        DMGEXTEND *Etop = LC[cil].A->E;
        
        LC[cil].A->E = Etop;
        
        if(!LC[cil].A->E) {[self AddDMGEXTEND:&LC[cil].A->E :0];
            Etop = LC[cil].A->E;
        }
        
        for(int k = 0;k < (int)[hitListMA count]-1;k++) {
            LC[cil].A->E = LC[cil].A->E->next;
        }
        
        
        if((int)[hitListMA count] > 0){
            LC[cil].A->E->next = calloc(1, sizeof(DMGEXTEND));
            LC[cil].A->E = LC[cil].A->E->next;
        }
        LC[cil].A->E->next = NULL;
        LC[cil].A->E->atkHit = [ALTFatkHit intValue];
        LC[cil].A->E->hit = [ALTFhit intValue];
        LC[cil].A->E->rate = [ALTFrate intValue];
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%d", [ALTFrate intValue]] forKey:@"rate"];
        [dict setValue:[NSString stringWithFormat:@"%d", [ALTFhit intValue]] forKey:@"hit"];
        [dict setValue:[NSString stringWithFormat:@"%d", [ALTFatkHit intValue]] forKey:@"atkHit"];
        
        [self willChangeValueForKey:@"hitListMA"];
        [hitListMA addObject:dict];
        [self didChangeValueForKey:@"hitListMA"];
        [hitListAC setSelectionIndex:[hitListTV selectedRow]];
        
        LC[cil].A->E = Etop;
        
        LC[cil].A = aTop;
        

    
    }
    
}

-(IBAction)removeHitList:(id)sender{

    
    if(!loadChipSideFlag){
    if([hitListTV selectedRow] >= 0){
        ATTACK *aTop = UC[clickIndex].A;
        for(int k = 0;k < clickIndexAL;k++) {
            UC[clickIndex].A = UC[clickIndex].A->next;
        }
        DMGEXTEND *Etop = UC[clickIndex].A->E;
        DMGEXTEND *eNext = NULL;
        
        
         int clickIndexHL = (int)[hitListTV selectedRow];
        
        for(int k = 0;k < clickIndexHL-1;k++){
            UC[clickIndex].A->E = UC[clickIndex].A->E->next;
        }
        
        if(clickIndexHL == 0) {
            
            UC[clickIndex].A->E = UC[clickIndex].A->E->next;
            Etop = UC[clickIndex].A->E;
        
        }
        
        else{
            eNext = UC[clickIndex].A->E->next->next;
        
        UC[clickIndex].A->E->next = eNext;
        }
        
        UC[clickIndex].A->E = Etop;
        
        [self willChangeValueForKey:@"hitListMA"];
        [hitListMA removeObjectAtIndex:[hitListTV selectedRow]];
        [self didChangeValueForKey:@"hitListMA"];
        if([hitListMA count] > 0) [hitListAC setSelectionIndex:[hitListTV selectedRow]-1];
        
        UC[clickIndex].A = aTop;
    }
    
    }else{
    
        if([hitListTV selectedRow] >= 0){
            ATTACK *aTop = LC[cil].A;
            for(int k = 0;k < clickIndexAL;k++) {
                LC[cil].A = LC[cil].A->next;
            }
            DMGEXTEND *Etop = LC[cil].A->E;
            DMGEXTEND *eNext = NULL;
            
            
            int clickIndexHL = (int)[hitListTV selectedRow];
            
            for(int k = 0;k < clickIndexHL-1;k++){
                LC[cil].A->E = LC[cil].A->E->next;
            }
            
            if(clickIndexHL == 0) {
                
                LC[cil].A->E = LC[cil].A->E->next;
                Etop = LC[cil].A->E;
                
            }
            
            else{
                eNext = LC[cil].A->E->next->next;
                
                LC[cil].A->E->next = eNext;
            }
            
            LC[cil].A->E = Etop;
            
            [self willChangeValueForKey:@"hitListMA"];
            [hitListMA removeObjectAtIndex:[hitListTV selectedRow]];
            [self didChangeValueForKey:@"hitListMA"];
            if([hitListMA count] > 0) [hitListAC setSelectionIndex:[hitListTV selectedRow]-1];
            
            LC[cil].A = aTop;
        }
    
    
    }
}

-(IBAction)skillListInsert:(id)sender{
    SLpbtn = (int)[PUBsl indexOfSelectedItem];
    
    if(SLpbtn <= 0) return;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"新規スキル"] forKey:@"name"];
    
    Stop = UC[clickIndex].S;
    
    if(SKLrow < 0){
        if([skillListMA count] == 0){
            UC[clickIndex].S = (SKILL*)malloc(sizeof(SKILL));
            //INIT 処理
            UC[clickIndex].S->type = SLpbtn;
            [self SLbuildinit];
            UC[clickIndex].S->next = NULL;
            Stop = UC[clickIndex].S;
        }else{
            while(UC[clickIndex].S->next) UC[clickIndex].S = UC[clickIndex].S->next;
            UC[clickIndex].S->next = (SKILL*)malloc(sizeof(SKILL));
            UC[clickIndex].S = UC[clickIndex].S->next;
            //INIT 処理
            UC[clickIndex].S->type = SLpbtn;
            [self SLbuildinit];
            UC[clickIndex].S->next = NULL;
            UC[clickIndex].S = Stop;
        }
        
        SKL = SKLtop;
        for(int i = 1;i < SLpbtn;i++){
            SKL = SKL->next;
        }
        [dict setValue:[NSString stringWithFormat:@"%@", SKL->name] forKey:@"name"];
        SKL = SKLtop;
        [self willChangeValueForKey:@"skillListMA"];
        [skillListMA insertObject:dict atIndex:[skillListMA count]];
        [self didChangeValueForKey:@"skillListMA"];
        [skillListAC setSelectionIndex:999];
        SKLrow = -1;
    }else{
        UC[clickIndex].S = Stop;
        if([skillListMA count] == 0){
            UC[clickIndex].S = (SKILL*)malloc(sizeof(SKILL));
            //INIT 処理
            UC[clickIndex].S->type = SLpbtn;
            [self SLbuildinit];
            UC[clickIndex].S->next = NULL;
            Stop = UC[clickIndex].S;
        }else if(SKLrow > 0){
            for (int i = 0; i < SKLrow-1;i++)
                UC[clickIndex].S = UC[clickIndex].S->next;
            
            SKILL *tmp = (SKILL*)malloc(sizeof(SKILL));
            *tmp = *UC[clickIndex].S->next;
            UC[clickIndex].S->next = (SKILL*)malloc(sizeof(SKILL));
            UC[clickIndex].S->next->next = tmp;
            UC[clickIndex].S = UC[clickIndex].S->next;
            //INIT 処理
            UC[clickIndex].S->type = SLpbtn;
            [self SLbuildinit];
            UC[clickIndex].S = Stop;
        }else{
            SKILL *tmp = (SKILL*)malloc(sizeof(SKILL));
            tmp->next = UC[clickIndex].S;
            
            UC[clickIndex].S->type = SLpbtn;
            [self SLbuildinit];
            Stop = tmp;
            UC[clickIndex].S = Stop;
        }
        SKL = SKLtop;
        for(int i = 1;i < SLpbtn;i++){
            SKL = SKL->next;
        }
        [dict setValue:[NSString stringWithFormat:@"%@", SKL->name] forKey:@"name"];
        SKL = SKLtop;
        [self willChangeValueForKey:@"skillListMA"];
        [skillListMA insertObject:dict atIndex:SKLrow];
        [self didChangeValueForKey:@"skillListMA"];
        [skillListAC setSelectionIndex:SKLrow];
    }
}
-(IBAction)skillListDelete:(id)sender{
    Stop = UC[clickIndex].S;
    
    if(SKLrow == -1){
        SKLrow = (int)[skillListMA count] - 1;
    }
    
    if([skillListMA count] > 0){
        
        if(SKLrow == 0){
            UC[clickIndex].S = Stop;
            UC[clickIndex].S = UC[clickIndex].S->next;
            Stop = UC[clickIndex].S;
        }else if(SKLrow == [skillListMA count] - 1){
            UC[clickIndex].S = Stop;
            while(UC[clickIndex].S->next->next){
                UC[clickIndex].S = UC[clickIndex].S->next;
            }
            UC[clickIndex].S->next = NULL;
        }else{
            UC[clickIndex].S = Stop;
            for (int i = 0; i < SKLrow - 1;i++)
                UC[clickIndex].S = UC[clickIndex].S->next;
            UC[clickIndex].S->next = UC[clickIndex].S->next->next;
        }
        
        [self willChangeValueForKey:@"skillListMA"];
        [skillListMA removeObjectAtIndex:SKLrow];
        [self didChangeValueForKey:@"skillListMA"];
        [skillListAC setSelectionIndex:SKLrow-1];
        if(SKLrow < 0) [skillListAC setSelectionIndex:[skillListMA count]-1];
        if(SKLrow == 0) [skillListAC setSelectionIndex:0];
        if(SKLrow > 0) SKLrow--;
    }
    UC[clickIndex].S = Stop;
}


-(IBAction)SLbuildAdd:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableArray *Array = [NSMutableArray array];
    
    for(int i = 0;i<BuildChipNum;i++){
        [Array addObject:[BC[i].name retain]];
    }
    [dict setValue:Array forKey:@"name"];
    [dict setValue:0xc7 forKey:@"sel"];
    [dict setValue:[NSString stringWithFormat:@"資%d食%d金%d", BC[0].Csupply, BC[0].Cfood, BC[0].Cmoney] forKey:@"manko"];
    Stop = UC[clickIndex].S;
    
    if(SKLrow <= 0) SKLrow = 0;
    
    for(int i = 0;i < SKLrow;i++){
        UC[clickIndex].S = UC[clickIndex].S->next;
    }
    
    if(1){
        if([skillListBuildMA count] == 0){
            UC[clickIndex].S->list[0] = 1;
        }else{
            int k = 0;
            for(int i = 0;UC[clickIndex].S->list[i] > 0;i++){
                k++;
            }
            UC[clickIndex].S->list[k] = 1;
        }
        
        [self willChangeValueForKey:@"skillListBuildMA"];
        [skillListBuildMA addObject:dict];
        [self didChangeValueForKey:@"skillListBuildMA"];
        [skillListBuildAC setSelectionIndex:[skillListBuildMA count]-1];
        SKLBrow = (int)[skillListBuildMA count]-1;
    }
    UC[clickIndex].S = Stop;


}
-(IBAction)SLbuildDelete:(id)sender{
    Stop = UC[clickIndex].S;
    
    if(SKLrow <= 0) SKLrow = 0;
    
    for(int i = 0;i < SKLrow;i++){
        UC[clickIndex].S = UC[clickIndex].S->next;
    }
    
    if([skillListBuildMA count] > 0){
        int k = 0;
        if(1){
            UC[clickIndex].S = Stop;
            for(int i = 0;UC[clickIndex].S->list[i] == 0;i++){
                k++;
            }
            UC[clickIndex].S->list[k-1] = 0;
        }
        
        [self willChangeValueForKey:@"skillListBuildMA"];
        [skillListBuildMA removeObjectAtIndex:k];
        [self didChangeValueForKey:@"skillListBuildMA"];
        [skillListBuildAC setSelectionIndex:SKLBrow-1];
        SKLBrow = -1;
    }
    UC[clickIndex].S = Stop;
}
-(IBAction)SLbuildSubmit:(id)sender{
    [self willChangeValueForKey:@"skillListBuildMA"];
    [skillListBuildMA removeAllObjects];
    [self didChangeValueForKey:@"skillListBuildMA"];
    [SLBpanel close];
}

-(void)SLbuildinit{


    for(int i = 0;i< 255;i++){
        UC[clickIndex].S->list[i] = 0;
        UC[clickIndex].S->cost[i] = 0;

    }
    
}


-(IBAction)SLunitAdd:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSMutableArray *Array = [NSMutableArray array];
    
    for(int i = 0;i<UCN;i++){
        [Array addObject:[UC[i].name retain]];
    }
    [dict setValue:Array forKey:@"name"];
    [dict setValue:0xc7 forKey:@"sel"];
    [dict setValue:[NSString stringWithFormat:@"%d", 0] forKey:@"MP"];
    Stop = UC[clickIndex].S;
    
    if(SKLrow <= 0) SKLrow = 0;
    
    for(int i = 0;i < SKLrow;i++){
        UC[clickIndex].S = UC[clickIndex].S->next;
    }
    
    if(1){
        if([skillListUnitMA count] == 0){
            UC[clickIndex].S->list[0] = 2;
        }else{
            int k = 0;
            for(int i = 0;UC[clickIndex].S->list[i] > 0;i++){
                k++;
            }
            UC[clickIndex].S->list[k] = 2;
        }
        
        [self willChangeValueForKey:@"skillListUnitMA"];
        [skillListUnitMA addObject:dict];
        [self didChangeValueForKey:@"skillListUnitMA"];
        [skillListUnitAC setSelectionIndex:[skillListUnitMA count]-1];
        SKLBrow = (int)[skillListUnitMA count]-1;
    }UC[clickIndex].S = Stop;
    
    

}
-(IBAction)SLunitDelete:(id)sender{
    Stop = UC[clickIndex].S;
    
    if(SKLrow <= 0) SKLrow = 0;
    
    for(int i = 0;i < SKLrow;i++){
        UC[clickIndex].S = UC[clickIndex].S->next;
    }
    
    if([skillListBuildMA count] > 0){
        int k = 0;
        if(1){
            UC[clickIndex].S = Stop;
            for(int i = 0;UC[clickIndex].S->list[i] == 0;i++){
                k++;
            }
            UC[clickIndex].S->list[k-1] = 0;
        }
        
        [self willChangeValueForKey:@"skillListUnitMA"];
        [skillListUnitMA removeObjectAtIndex:k];
        [self didChangeValueForKey:@"skillListUnitMA"];
        [skillListUnitAC setSelectionIndex:SKLUrow-1];
        SKLUrow = -1;
    }
    UC[clickIndex].S = Stop;
}
-(IBAction)SLunitSubmit:(id)sender{
    [self willChangeValueForKey:@"skillListUnitMA"];
    [skillListUnitMA removeAllObjects];
    [self didChangeValueForKey:@"skillListUnitMA"];
    
    [SLUpanel close];
}

-(IBAction)registUCL:(id)sender{
    [TFchipNumb setIntValue:(int)chipNumb];
    UCN = (int)chipNumb;
    UnitChipMax = (int)chipNumb/25+1;
    [UCLRegisterPanel makeKeyAndOrderFront:nil];
}

-(void)savePresetUnitNumber{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSString *path = @"data/UnitChip/preset.txt";
    
    NSString *data = [NSString stringWithFormat:@"%d", (int)chipNumb];
    
    [data writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

-(void)savePresetItemNumber{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSString *path = @"data/ItemList/preset.txt";
    
    NSString *data = [NSString stringWithFormat:@"%d", (int)eItemNum];
    
    [data writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

-(IBAction)registSaveUCL:(id)sender{
    chipNumb = [TFchipNumb intValue];
    [self savePresetUnitNumber];
    UCN = (int)chipNumb;
    UnitChipMax = (int)chipNumb/25+1;
    [self initUnitChipList];
    [UCLRegisterPanel close];
}
-(IBAction)registCancelUCL:(id)sender{
    [UCLRegisterPanel close];
}   

-(void)initAttackSet{
    
    [AMbtnA removeAllItems];
    [AMbtnB removeAllItems];
    [AMbtnC removeAllItems];
    [AMbtnD removeAllItems];
    
    [self willChangeValueForKey:@"commandListMA"];
    [commandListMA removeAllObjects];
    [self didChangeValueForKey:@"commandListMA"];
    [self willChangeValueForKey:@"comboListMA"];
    [comboListMA removeAllObjects];
    [self didChangeValueForKey:@"comboListMA"];
    
    ATTACK *Atop = UC[clickIndex].A;
    while (UC[clickIndex].A != NULL) {
        if(UC[clickIndex].A->name != NULL){
            [AMbtnA addItemWithTitle:UC[clickIndex].A->name];
            [AMbtnB addItemWithTitle:UC[clickIndex].A->name];
            [AMbtnC addItemWithTitle:UC[clickIndex].A->name];
            [AMbtnD addItemWithTitle:UC[clickIndex].A->name];
        }
        UC[clickIndex].A = UC[clickIndex].A->next;
    }
    UC[clickIndex].A = Atop;
    
    COMMANDS *CMtop = UC[clickIndex].CM.cs;
    if(UC[clickIndex].CM.cs != NULL)
    while (UC[clickIndex].CM.cs->cmd != NULL) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].CM.cs->cmd] forKey:@"name"];
        if(![UC[clickIndex].CM.cs->hasei isEqualToString:@"0"])
            [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].CM.cs->hasei] forKey:@"hasei"];
        
        NSMutableArray *Array = [NSMutableArray array];
        ATTACK *AAtop = UC[clickIndex].A;
        while (UC[clickIndex].A != NULL) {
            [Array addObject:UC[clickIndex].A->name];
            UC[clickIndex].A = UC[clickIndex].A->next;
        }
        UC[clickIndex].A = AAtop;
        [dict setValue:Array forKey:@"waza"];
        
        [self willChangeValueForKey:@"commandListMA"];
        [commandListMA addObject:dict];
        [self didChangeValueForKey:@"commandListMA"];
        UC[clickIndex].CM.cs = UC[clickIndex].CM.cs->next;
    }
    
    
    UC[clickIndex].CM.cs = CMtop;
    
    
    
    
    COMBO *Ctop = UC[clickIndex].CM.co;
    if(UC[clickIndex].CM.co != NULL)
    while (UC[clickIndex].CM.co->mbo != NULL) {
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[clickIndex].CM.co->mbo] forKey:@"name"];
        [self willChangeValueForKey:@"comboListMA"];
        [comboListMA addObject:dict];
        [self didChangeValueForKey:@"comboListMA"];
        UC[clickIndex].CM.co = UC[clickIndex].CM.co->next;
    }
    UC[clickIndex].CM.co = Ctop;
    
    
    [AMbtnA selectItemAtIndex:UC[clickIndex].CM.A];
    [AMbtnB selectItemAtIndex:UC[clickIndex].CM.B];
    [AMbtnC selectItemAtIndex:UC[clickIndex].CM.C];
    [AMbtnD selectItemAtIndex:UC[clickIndex].CM.D];
    
    
    
    
    
    UC[clickIndex].A = Atop;
}

-(void)initAttackSet2{
    
    [AMbtnA removeAllItems];
    [AMbtnB removeAllItems];
    [AMbtnC removeAllItems];
    [AMbtnD removeAllItems];
    
    [self willChangeValueForKey:@"commandListMA"];
    [commandListMA removeAllObjects];
    [self didChangeValueForKey:@"commandListMA"];
    [self willChangeValueForKey:@"comboListMA"];
    [comboListMA removeAllObjects];
    [self didChangeValueForKey:@"comboListMA"];

}


-(IBAction)attackListTotalSubmit:(id)sender{
    
    UC[clickIndex].CM.A = (int)[AMbtnA indexOfSelectedItem];
    UC[clickIndex].CM.B = (int)[AMbtnB indexOfSelectedItem];
    UC[clickIndex].CM.C = (int)[AMbtnC indexOfSelectedItem];
    UC[clickIndex].CM.D = (int)[AMbtnD indexOfSelectedItem];
    
    [UCLPanelAttackList close];
}
-(IBAction)attackListOpenBtn:(id)sender{
    clickedRowAT = -1;
    if(!loadChipSideFlag){
        [self initAttackList];
    }else{
        [self initAttackList2];
    }
    /*
    windowPoint.x = [UCLDetailPanel frame].origin.x;
    windowPoint.y = [UCLDetailPanel frame].origin.y + 50;
    [UCLPanelAttack setFrameOrigin:windowPoint];
     */
    [UCLPanelAttack makeKeyAndOrderFront:nil];
}
-(IBAction)commandListAdd:(id)sender{}
-(IBAction)commandListRemove:(id)sender{}
-(IBAction)comboListAdd:(id)sender{}
-(IBAction)comboListRemove:(id)sender{}


-(IBAction)addSubjMark:(id)sender{
    NSString* str = [[ALTFmsg stringValue] retain];
    str = [[str stringByAppendingFormat:@"$subj"] retain];
    [ALTFmsg setStringValue:str];
}
-(IBAction)addObjeMark:(id)sender{
    NSString* str = [[ALTFmsg stringValue] retain];
    str = [[str stringByAppendingFormat:@"$obje"] retain];
    [ALTFmsg setStringValue:str];
}


-(IBAction)ILregi:(id)sender{

    [ILregiTF setIntValue:(int)eItemNum];
    [ILregiWIndow makeKeyAndOrderFront:nil];
}

-(IBAction)saveILregi:(id)sender{

    eItemNum = [ILregiTF intValue];
    [self initItemList];
    [self savePresetItemNumber];
    
    [ILregiWIndow close];
}


-(IBAction)cancelILregi:(id)sender{

    [ILregiWIndow close];
}

-(IBAction)attackIL:(id)sender{

    EQmodeFlag = true;
    [self initAttackListEQ];
    [UCLPanelAttack makeKeyAndOrderFront:nil];
}

@end
