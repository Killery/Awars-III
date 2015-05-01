//
//  FieldScene.m
//  Awars III
//
//  Created by Killery on 2013/02/22.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "FieldScene.h"

@implementation FieldScene

-(void)awakeFromNib{

    [CAttackListTV setTarget:self];
    [CAttackListTV setDoubleAction:@selector(doubleClickCAL:)];
    [CAttackListTV setTarget:self];
    [CAttackListTV setAction:@selector(clickCAL:)];
    
    [CResearchListTV setTarget:self];
    [CResearchListTV setDoubleAction:@selector(doubleClickCRL:)];
    [CResearchListTV setTarget:self];
    [CResearchListTV setAction:@selector(clickCRL:)];
    
    [BCreateListTV setTarget:self];
    [BCreateListTV setDoubleAction:@selector(doubleClickBCL:)];
    [BCreateListTV setTarget:self];
    [BCreateListTV setAction:@selector(clickBCL:)];
    
    [CSummonListTV setTarget:self];
    [CSummonListTV setDoubleAction:@selector(doubleClickCSL:)];
    [CSummonListTV setTarget:self];
    [CSummonListTV setAction:@selector(clickCSL:)];
    
    
    
    CAttackListMA = [NSMutableArray new];
    CResearchListMA = [NSMutableArray new];
    BCreateListMA = [NSMutableArray new];
    CSummonListMA = [NSMutableArray new];
    
    
    [IVimage setHidden:YES];
    [TFname setHidden:YES];
    [TFmessage setHidden:YES];
    [BXname setHidden:YES];
    [BXmessage setHidden:YES];
    [IVimage setEnabled:NO];
    [TFname setEnabled:NO];
    [TFmessage setEnabled:NO];
    
}

-(id)init{

    if(self){
        time  = [NSTimer
                 scheduledTimerWithTimeInterval:0.05f
                 target:self
                 selector:@selector(EventLoopFS:)
                 userInfo:nil
                 repeats:YES
                 ];
        P[0].name = @"青軍";
        P[1].type = 0;
        P[0].resource = 500;
        P[0].food = 500;
        P[0].money = 500;
        
        P[1].name = @"赤軍";
        P[1].type = 0;
        P[1].resource = 500;
        P[1].food = 500;
        P[1].money = 500;
        
        
    }
    

    return self;
}

-(void)doubleClickBCL:(id)sender{
    
    enum{
        MC_ANTEI,
        MC_FUANTEI,
        MC_CHIKURIN,
        MC_MIZUBA,
        MC_ASASE,
        MC_NAIBU
    };
    
    enum{
        BC_ANTEI,
        BC_CHIKURIN,
        BC_ASASE,
        BC_SONOTA
    };
    
    bclRdy = false;
    
    U = UTop;
    for(int i = 0;i < slctedUnitNum;i++){
        U = U->next;
    }
    
    if (MC[chipNum[possionX][possionY]].type == MC_ANTEI) {
        
        if(BC[U->C.S->list[crBCL]-1].type == BC_ANTEI){
            bclRdy = true;
        }
        
    }
 
    if (MC[chipNum[possionX][possionY]].type == MC_CHIKURIN) {
        
        if(BC[U->C.S->list[crBCL]-1].type == BC_CHIKURIN){
            bclRdy = true;
        }
        
    }
    
    if (MC[chipNum[possionX][possionY]].type == MC_ASASE) {
        
        if(BC[U->C.S->list[crBCL]-1].type == BC_ASASE){
            bclRdy = true;
        }
        
    }

    if(BC[U->C.S->list[crBCL]].type == BC_SONOTA){
        bclRdy = true;
    }
    
    if(bclRdy){
        bclRdy = false;
        if(buildNum[possionX][possionY] >= 0){
            U = UTop;
            return;
        }
        
        if(U->team == 0)
        if(P[0].resource >= BC[U->C.S->list[crBCL]-1].Csupply){
            if(P[0].food >= BC[U->C.S->list[crBCL]-1].Cfood){
                if (P[0].money >= BC[U->C.S->list[crBCL]-1].Cmoney) {
                    P[0].resource -= BC[U->C.S->list[crBCL]-1].Csupply;
                    P[0].food -= BC[U->C.S->list[crBCL]-1].Cfood;
                    P[0].money -= BC[U->C.S->list[crBCL]-1].Cmoney;
                    
                    buildNum[possionX][possionY] = U->C.S->list[crBCL]-1;
                    
                    buildTeam[possionX][possionY] = 0;
                   
                    
                    [self addBuildStatus];
                    
                    bclRdy = true;
                }
            }
        }
        
        if(U->team == 2)
        if(P[1].resource >= BC[U->C.S->list[crBCL]-1].Csupply){
            if(P[1].food >= BC[U->C.S->list[crBCL]-1].Cfood){
                if (P[1].money >= BC[U->C.S->list[crBCL]-1].Cmoney) {
                    P[1].resource -= BC[U->C.S->list[crBCL]-1].Csupply;
                    P[1].food -= BC[U->C.S->list[crBCL]-1].Cfood;
                    P[1].money -= BC[U->C.S->list[crBCL]-1].Cmoney;
                    
                    buildNum[possionX][possionY] = U->C.S->list[crBCL]-1;
                    
                    buildTeam[possionX][possionY] = 2;
                    
                    [self addBuildStatus];
                    
                    bclRdy = true;
                }
            }
        }
        [createPanel close];
    }
    
    U = UTop;
}

-(void)clickBCL:(id)sender{
    crBCL = (int)[BCreateListTV clickedRow];
    
    
    
}


-(void)doubleClickCSL:(id)sender{
   
    U = UTop;
    for(int i = 0;i < slctedUnitNum;i++){
        U = U->next;
    }
    CSLU = U;
    
    SKILL *sTop = U->C.S;
    while (U->C.S) {
        if(U->C.S->type == 2) break;
        U->C.S = U->C.S->next;
    }
    if(!U->C.S){
        U->C.S = sTop;
        U = UTop;
        return;
    }
    
    if(U->team == 0)
        if(U->C.S->cost[crCSL] <= U->C.S_C.MP){
            //U->C.S_C.MP -= U->C.S->cost[crCSL];
            CSLUC = UC[U->C.S->list[crCSL]-1];
            
            U->C.S = sTop;
            cslRdy = true;
            [summonPanel close];
            //unitColorInitFlag = true;
        }
    if(U->team == 2)
        if(U->C.S->cost[crCSL] <= U->C.S_C.MP){
            
            //U->C.S_C.MP -= U->C.S->cost[crCSL];
            CSLUC = UC[U->C.S->list[crCSL]-1];
            
            U->C.S = sTop;
            cslRdy = true;
            [summonPanel close];
            //unitColorInitFlag = true;
        }
    
    U = UTop;
    
}

-(void)clickCSL:(id)sender{
    crCSL = (int)[CSummonListTV clickedRow];
    
    
}

-(void)doubleClickCAL:(id)sender{
    
    if(crCAL < 0)
        crCAL = 0;
    
    int postCAL1 = crCAL1;
    int postCAL2 = crCAL2;
    
    if(!battleSet1Flag && !battleSet2Flag){
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
        
        
        if(U->chipNumberL < 0){
        
            ATTACK *aTop = U->C.A;
            
            crCAL = (int)[CAttackListTV clickedRow];
            crCAL1 = (int)[CAttackListTV clickedRow];
            for(int i = 0;i < crCAL;i++){
                U->C.A = U->C.A->next;
            }
    
            costMP = U->C.A->MP + floor(U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
    
            if(costMP <= U->C.S_C.MP){
                dcRdy = true;
                [atkPanel close];
            }
            U->C.A = aTop;
            U = UTop;
            return;
        }else{
            ATTACK *aTop = U->CL.A;
            crCAL = (int)[CAttackListTV clickedRow];
            crCAL1 = (int)[CAttackListTV clickedRow];
            for(int i = 0;i < crCAL;i++){
                U->CL.A = U->CL.A->next;
            }
            
            costMP = U->CL.A->EN + floor(U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
            
            if(costMP <= U->CL.S_C.EN){
                dcRdy = true;
                [atkPanel close];
            }
            U->CL.A = aTop;
            U = UTop;
            return;
        }
    }
    
    if(battleSet1Flag && !battleSet2PushedFlag){
        
    
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
       
        if(U->chipNumberL < 0){
            ATTACK *aTop = U->C.A;
            crCAL1 = (int)[CAttackListTV clickedRow];
            for(int i = 0;i < crCAL1;i++){
                U->C.A = U->C.A->next;
            }
        
            costMP = U->C.A->MP + floor(U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
        
            if(costMP <= U->C.S_C.MP && U->atkRange >= U->C.A->rangeA && U->atkRange <= U->C.A->rangeB){
                //dcRdy = true;
                [atkPanel close];
                U->C.A = aTop;
                U = UTop;
                return;
            }
            U->C.A = aTop;
            U = UTop;
            
        }else{
            ATTACK *aTop = U->CL.A;
            crCAL1 = (int)[CAttackListTV clickedRow];
            for(int i = 0;i < crCAL1;i++){
                U->CL.A = U->CL.A->next;
            }
            
            costMP = U->CL.A->EN + floor(U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
            
            if(costMP <= U->CL.S_C.EN && U->atkRange >= U->CL.A->rangeA && U->atkRange <= U->CL.A->rangeB){
                //dcRdy = true;
                [atkPanel close];
                U->CL.A = aTop;
                U = UTop;
                return;
            }
            U->CL.A = aTop;
            U = UTop;
        }
    
    }
    
    if(battleSet2Flag && battleSet2PushedFlag){
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        
        if(U->chipNumberL < 0){
            U = UTop;
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
        
            int omgRange = U->atkRange;
        
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
        
            U->atkRange = omgRange;
        
            ATTACK *aTop = U->C.A;
            crCAL2 = (int)[CAttackListTV clickedRow];
            for(int i = 0;i < crCAL2;i++){
                U->C.A = U->C.A->next;
            }
        
            costMP = U->C.A->MP + floor(U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
        
            if(costMP <= U->C.S_C.MP && U->atkRange >= U->C.A->rangeA && U->atkRange <= U->C.A->rangeB){
                //dcRdy = true;
                [atkPanel close];
                U->C.A = aTop;
                U = UTop;
                return;
            }
            U->C.A = aTop;
            U = UTop;
        }else{
            U = UTop;
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            
            int omgRange = U->atkRange;
            
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
            
            U->atkRange = omgRange;
            
            ATTACK *aTop = U->CL.A;
            crCAL2 = (int)[CAttackListTV clickedRow];
            for(int i = 0;i < crCAL2;i++){
                U->CL.A = U->CL.A->next;
            }
            
            costMP = U->CL.A->EN + floor(U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
            
            if(costMP <= U->CL.S_C.EN && U->atkRange >= U->CL.A->rangeA && U->atkRange <= U->CL.A->rangeB){
                //dcRdy = true;
                [atkPanel close];
                U->CL.A = aTop;
                U = UTop;
                return;
            }
            U->CL.A = aTop;
            U = UTop;
        
        }
        
        U = UTop;
        
    }
    

    crCAL1 = postCAL1;
    crCAL2 = postCAL2;
}


-(void)clickCAL:(id)sender{

    crCAL = (int)[CAttackListTV clickedRow];
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(U->chipNumberL >= 0) {
        U = UTop;
        [self initCAttackSelect2];
    }
    else if(U->chipNumber >= 0) {
        U = UTop;
        [self initCAttackSelect];
    }
    U = UTop;
}

-(void)initCAttackSelect{
    
    U = UTop;
    
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    if(battleSet1Flag){crCAL = crCAL1;
        //crCAL1 = (int)[CAttackListTV clickedRow];
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
    }
    if(battleSet2Flag){crCAL = crCAL2;
        //crCAL2 = (int)[CAttackListTV clickedRow];
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        
    }
    
    ATTACK *aTop = U->C.A;
    for(int i = 0;i < crCAL;i++){
        U->C.A = U->C.A->next;
    }
    
    
    if(U->C.A->bullet > 0) [bullet setStringValue:[NSString stringWithFormat:@"%d／%d", U->C.A->bulletC, U->C.A->bullet]];
    else [bullet setStringValue:[NSString stringWithFormat:@"---／---"]];
    if(U->C.A->MP > 0) [costP setStringValue:[NSString stringWithFormat:@"%g（%g）", U->C.A->MP + floor(U->C.A->pMP*U->C.S_M.MP/100+0.5), U->C.S_C.MP]];
    else [costP setStringValue:[NSString stringWithFormat:@"---（%g）", U->C.S_C.MP]];
    if(U->C.A->vigor > 0) [costV setStringValue:[NSString stringWithFormat:@"%d（%d）", U->C.A->vigor, U->C.S_C.vigor]];
    else [costV setStringValue:[NSString stringWithFormat:@"---（%d）",  U->C.S_C.vigor]];
    
    NSString *Riku, *Chu, *Umi, *Sora;
    
    switch (U->C.A->riku) {
        case 0:
            Riku = [@"A" retain];
            break;
        case 1:
            Riku = [@"B"retain];
            break;
        case 2:
            Riku = [@"C"retain];
            break;
        case 3:
            Riku = [@"D"retain];
            break;
        case 4:
            Riku = [@"E"retain];
            break;
        case 5:
            Riku = [@"S"retain];
            break;
        case 6:
            Riku = [@"SS"retain];
            break;
    }
    switch (U->C.A->chu) {
        case 0:
            Chu = [@"A" retain];
            break;
        case 1:
            Chu = [@"B" retain];
            break;
        case 2:
            Chu = [@"C" retain];
            break;
        case 3:
            Chu = [@"D" retain];
            break;
        case 4:
            Chu = [@"E" retain];
            break;
        case 5:
            Chu = [@"S" retain];
            break;
        case 6:
            Chu = [@"SS" retain];
            break;
    }
    switch (U->C.A->umi) {
        case 0:
            Umi = [@"A" retain];
            break;
        case 1:
            Umi = [@"B" retain];
            break;
        case 2:
            Umi = [@"C" retain];
            break;
        case 3:
            Umi = [@"D" retain];
            break;
        case 4:
            Umi = [@"E" retain];
            break;
        case 5:
            Umi = [@"S" retain];
            break;
        case 6:
            Umi = [@"SS" retain];
            break;
    }
    switch (U->C.A->sora) {
        case 0:
            Sora = [@"A" retain];
            break;
        case 1:
            Sora = [@"B" retain];
            break;
        case 2:
            Sora = [@"C" retain];
            break;
        case 3:
            Sora = [@"D" retain];
            break;
        case 4:
            Sora = [@"E" retain];
            break;
        case 5:
            Sora = [@"S" retain];
            break;
        case 6:
            Sora = [@"SS" retain];
            break;
    }
    
    if(!U->C.A->name){
        Riku = @"--";
        Chu = @"--";
        Umi = @"--";
        Sora = @"--";
    }
    
    [region setStringValue:[NSString stringWithFormat:@"陸%@ 宙%@ 海%@ 空%@",  Riku, Chu, Umi, Sora]];
    [crytical setStringValue:@""];
    [atkProperty setStringValue:@""];
    
    U->C.A = aTop;
    U = UTop;
}

-(void)initCAttackSelect2{
    
    U = UTop;
    
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    if(battleSet1Flag){
        //crCAL1 = (int)[CAttackListTV clickedRow];
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
    }
    if(battleSet2Flag){
        //crCAL2 = (int)[CAttackListTV clickedRow];
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        
    }
    
    ATTACK *aTop = U->CL.A;
    for(int i = 0;i < crCAL;i++){
        U->CL.A = U->CL.A->next;
    }
    
    if(!U->CL.A) {
        
        U = UTop;
        return;
    }
    if(U->CL.A->bullet > 0) [bullet setStringValue:[NSString stringWithFormat:@"%d／%d", U->CL.A->bulletC, U->CL.A->bullet]];
    else [bullet setStringValue:[NSString stringWithFormat:@"---／---"]];
    if(U->CL.A->EN > 0) [costP setStringValue:[NSString stringWithFormat:@"%g（%g）", U->CL.A->EN + floor(U->CL.A->pEN*U->CL.S_M.EN/100+0.5), U->CL.S_C.EN]];
    else [costP setStringValue:[NSString stringWithFormat:@"---（%g）", U->CL.S_C.EN]];
    if(U->CL.A->vigor > 0) [costV setStringValue:[NSString stringWithFormat:@"%d（%d）", U->CL.A->vigor, U->C.S_C.vigor]];
    else [costV setStringValue:[NSString stringWithFormat:@"---（%d）",  U->C.S_C.vigor]];
    
    NSString *Riku, *Chu, *Umi, *Sora;
    
    switch (U->CL.A->riku) {
        case 0:
            Riku = @"A";
            break;
        case 1:
            Riku = @"B";
            break;
        case 2:
            Riku = @"C";
            break;
        case 3:
            Riku = @"D";
            break;
        case 4:
            Riku = @"E";
            break;
        case 5:
            Riku = @"S";
            break;
        case 6:
            Riku = @"SS";
            break;
    }
    switch (U->CL.A->chu) {
        case 0:
            Chu = @"A";
            break;
        case 1:
            Chu = @"B";
            break;
        case 2:
            Chu = @"C";
            break;
        case 3:
            Chu = @"D";
            break;
        case 4:
            Chu = @"E";
            break;
        case 5:
            Chu = @"S";
            break;
        case 6:
            Chu = @"SS";
            break;
    }
    switch (U->CL.A->umi) {
        case 0:
            Umi = @"A";
            break;
        case 1:
            Umi = @"B";
            break;
        case 2:
            Umi = @"C";
            break;
        case 3:
            Umi = @"D";
            break;
        case 4:
            Umi = @"E";
            break;
        case 5:
            Umi = @"S";
            break;
        case 6:
            Umi = @"SS";
            break;
    }
    switch (U->CL.A->sora) {
        case 0:
            Sora = @"A";
            break;
        case 1:
            Sora = @"B";
            break;
        case 2:
            Sora = @"C";
            break;
        case 3:
            Sora = @"D";
            break;
        case 4:
            Sora = @"E";
            break;
        case 5:
            Sora = @"S";
            break;
        case 6:
            Sora = @"SS";
            break;
    }
    
    if(!U->CL.A->name){
        Riku = @"--";
        Chu = @"--";
        Umi = @"--";
        Sora = @"--";
    }
    
    [region setStringValue:[NSString stringWithFormat:@"陸%@ 宙%@ 海%@ 空%@",  Riku, Chu, Umi, Sora]];
    [crytical setStringValue:@""];
    [atkProperty setStringValue:@""];
    
    U->CL.A = aTop;
    U = UTop;
}


-(void)doubleClickCRL:(id)sender{
    
    if(crCRL == -1) return;
    
    if(unitBreak->team == 0)
    if(P[0].resource >= BRU->S_M.cSupply && P[0].food >= BRU->S_M.cFood && P[0].money >= BRU->S_M.cMoney){
        
        P[0].resource -= BRU->S_M.cSupply;
        P[0].food -= BRU->S_M.cFood;
        P[0].money -= BRU->S_M.cMoney;
        
        unitNum[possionX][possionY] = BRUindex;
        if(researchTeam == 0) unitTeam[possionX][possionY] = 0;
        if(researchTeam == 2) unitTeam[possionX][possionY] = 2;

        [self addUnitStatus];
        
        unitColorInitFlag = true;
        
        [researchPanel close];
    }
    
    if(unitBreak->team == 2)
        if(P[1].resource >= BRU->S_M.cSupply && P[1].food >= BRU->S_M.cFood && P[1].money >= BRU->S_M.cMoney){
            
            P[1].resource -= BRU->S_M.cSupply;
            P[1].food -= BRU->S_M.cFood;
            P[1].money -= BRU->S_M.cMoney;
            
            unitNum[possionX][possionY] = BRUindex;
            if(researchTeam == 0) unitTeam[possionX][possionY] = 0;
            if(researchTeam == 2) unitTeam[possionX][possionY] = 2;
            
            [self addUnitStatus];
            
            unitColorInitFlag = true;
            
            [researchPanel close];
        }

}

-(void)clickCRL:(id)sender{
    
    crCRL = (int)[CResearchListTV clickedRow];
    
    BUILDCHIP *B;
    
    B = &BC[buildNum[possionX][possionY]];
    
    RESEARCH *Rtop;
    UNITCHIP *BU;
    
    Rtop = B->R;

    BU = B->R->U;
    BRU = BU;
    
    for(int i = 0;i <= crCRL;i++){
        BU = B->R->U;
        BRU = BU;
        [researchATK setStringValue:[NSString stringWithFormat:@"攻撃力 %g", BU->S_M.ATK]];
        [researchDEF setStringValue:[NSString stringWithFormat:@"防御力 %g", BU->S_M.DEF]];
        [researchCAP setStringValue:[NSString stringWithFormat:@"演算力 %g", BU->S_M.CAP]];
        [researchACU setStringValue:[NSString stringWithFormat:@"命中値 %g", BU->S_M.ACU]];
        [researchEVA setStringValue:[NSString stringWithFormat:@"回避値 %g", BU->S_M.EVA]];
        [researchMOV setStringValue:[NSString stringWithFormat:@"移動力 %d", BU->S_M.MOV]];
        [researchIMG setImage:BU->imgb];
        
        B->R = B->R->next;
    }
    B->R = Rtop;
    BRUindex = 0;
    for (int i = 0; BRU->nameID != UC[i].nameID;i++) {
        BRUindex++;
    }
    
}

-(void)SetStatusFunc{
    double STRfix;
    double VITfix;
    double AGIfix;
    double DEXfix;
    double MENfix;
    double INTfix;
    double LUKfix;
    
    double S, V, A, D, M, I;
    
    
    
    U = UTop;
    
    while(U){
    STRfix = (
              U->C.eHandL.STR +
              U->C.eHandR.STR +
              U->C.eHead.STR +
              U->C.eBody.STR +
              U->C.eFoot.STR +
              U->C.eArm.STR) +
    U->C.S_M.STR *(
                         U->C.eHandL.pSTR +
                         U->C.eHandR.pSTR +
                         U->C.eHead.pSTR +
                         U->C.eBody.pSTR +
                         U->C.eFoot.pSTR +
                         U->C.eArm.pSTR +
                         0)/100
    ;
    
    VITfix = (
              U->C.eHandL.VIT +
              U->C.eHandR.VIT +
              U->C.eHead.VIT +
              U->C.eBody.VIT +
              U->C.eFoot.VIT +
              U->C.eArm.VIT) +
    U->C.S_M.VIT *(
                         U->C.eHandL.pVIT +
                         U->C.eHandR.pVIT +
                         U->C.eHead.pVIT +
                         U->C.eBody.pVIT +
                         U->C.eFoot.pVIT +
                         U->C.eArm.pVIT +
                         0)/100
    ;
    AGIfix = (
              U->C.eHandL.AGI +
              U->C.eHandR.AGI +
              U->C.eHead.AGI +
              U->C.eBody.AGI +
              U->C.eFoot.AGI +
              U->C.eArm.AGI) +
    U->C.S_M.AGI *(
                         U->C.eHandL.pAGI +
                         U->C.eHandR.pAGI +
                         U->C.eHead.pAGI +
                         U->C.eBody.pAGI +
                         U->C.eFoot.pAGI +
                         U->C.eArm.pAGI +
                         0)/100
    ;
    DEXfix = (
              U->C.eHandL.DEX +
              U->C.eHandR.DEX +
              U->C.eHead.DEX +
              U->C.eBody.DEX +
              U->C.eFoot.DEX +
              U->C.eArm.DEX) +
    U->C.S_M.DEX *(
                         U->C.eHandL.pDEX +
                         U->C.eHandR.pDEX +
                         U->C.eHead.pDEX +
                         U->C.eBody.pDEX +
                         U->C.eFoot.pDEX +
                         U->C.eArm.pDEX +
                         0)/100
    ;
    MENfix = (
              U->C.eHandL.MEN +
              U->C.eHandR.MEN +
              U->C.eHead.MEN +
              U->C.eBody.MEN +
              U->C.eFoot.MEN +
              U->C.eArm.MEN) +
    U->C.S_M.MEN *(
                         U->C.eHandL.pMEN +
                         U->C.eHandR.pMEN +
                         U->C.eHead.pMEN +
                         U->C.eBody.pMEN +
                         U->C.eFoot.pMEN +
                         U->C.eArm.pMEN +
                         0)/100
    ;
    INTfix = (
              U->C.eHandL.INT +
              U->C.eHandR.INT +
              U->C.eHead.INT +
              U->C.eBody.INT +
              U->C.eFoot.INT +
              U->C.eArm.INT) +
    U->C.S_M.INT *(
                         U->C.eHandL.pINT +
                         U->C.eHandR.pINT +
                         U->C.eHead.pINT +
                         U->C.eBody.pINT +
                         U->C.eFoot.pINT +
                         U->C.eArm.pINT +
                         0)/100
    ;
    LUKfix = (
              U->C.eHandL.LUK +
              U->C.eHandR.LUK +
              U->C.eHead.LUK +
              U->C.eBody.LUK +
              U->C.eFoot.LUK +
              U->C.eArm.LUK) +
    U->C.S_M.LUK *(
                         U->C.eHandL.pLUK +
                         U->C.eHandR.pLUK +
                         U->C.eHead.pLUK +
                         U->C.eBody.pLUK +
                         U->C.eFoot.pLUK +
                         U->C.eArm.pLUK +
                         0)/100
    ;
    
    S = U->C.S_C.STR + STRfix;
    V = U->C.S_C.VIT + VITfix;
    A = U->C.S_C.AGI + AGIfix;
    D = U->C.S_C.DEX + DEXfix;
    M = U->C.S_C.MEN + MENfix;
    I = U->C.S_C.INT + INTfix;
    
    U->C.S_C.ATK = (S*5 + D*2 + A)/8;
    U->C.S_C.DEF = (V*5 + M*2 + S)/8;
    U->C.S_C.CAP = (I*4 + D*1 + M*2)/7;
    U->C.S_C.ACU = (D*4 + A*1 + M)/6;
    U->C.S_C.EVA = (A*4 + A*1 + M)/6;
        
        U->C.S_C.ATK += 0.5;
        U->C.S_C.DEF += 0.5;
        U->C.S_C.CAP += 0.5;
        U->C.S_C.ACU += 0.5;
        U->C.S_C.EVA += 0.5;
        
        U->C.S_C.ATK = floor(U->C.S_C.ATK);
        U->C.S_C.DEF = floor(U->C.S_C.DEF);
        U->C.S_C.CAP = floor(U->C.S_C.CAP);
        U->C.S_C.ACU = floor(U->C.S_C.ACU);
        U->C.S_C.EVA = floor(U->C.S_C.EVA);
        
        U = U->next;
    }U = UTop;

}

-(void)initMapscript{

    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    MAPSCRIPTD *MSDtop = MS.D;
    
    while(MS.D){
        MS.D->endFlag = false;
        MS.D = MS.D->next;
    }
    
    MS.D = MSDtop;
    
    
    MF[MFselectedRow+1].MS = MS;
    
    msgLvl = 0;
    msgLvlMax = 0;
    initImgFlag = false;
    initStringNum = false;
    bugFixFlag1 = false;
    bugFixFlag2 = false;
    bugFixFlag3 = false;
}

-(void)EventLoopFS:(NSTimer*)time{
    
    if(setBattleModeFlag){
        if(!battleReadyUpFlag){battleReadyUpFlag = true;
        [battleReadyUpPN1 setStringValue:P[0].name];
        [battleReadyUpPN2 setStringValue:P[1].name];
        
        NSString *string = @"";
        string = [string stringByAppendingFormat:@"%@の勝利条件\n", P[0].name];
        if(MF[MFselectedRow+1].MS.EGClight.endType1 == 1){
           string = [string stringByAppendingString:@"敵の壊滅\n"];
            
        }else if(MF[MFselectedRow+1].MS.EGClight.endType1 == 2){
            string = [string stringByAppendingString:@"味方の壊滅\n"];
            
        }
        
        string = [string stringByAppendingString:@"\n"];
        
        string = [string stringByAppendingFormat:@"%@の勝利条件\n", P[1].name];
        if(MF[MFselectedRow+1].MS.EGCdark.endType1 == 2){
            string = [string stringByAppendingString:@"敵の壊滅\n"];
        }else if(MF[MFselectedRow+1].MS.EGClight.endType1 == 1){
            string = [string stringByAppendingString:@"味方の壊滅\n"];
            
        }
    
        
        [battleReadyUpSupply1 setIntValue:P[0].resource];
        [battleReadyUpFood1 setIntValue:P[0].food];
        [battleReadyUpMoney1 setIntValue:P[0].money];
        
        [battleReadyUpSupply2 setIntValue:P[1].resource];
        [battleReadyUpFood2 setIntValue:P[1].food];
        [battleReadyUpMoney2 setIntValue:P[1].money];
        
        if(MF[MFselectedRow+1].MS.playerSet1 == 0){
            [battleReadyUpMAN1A setEnabled:YES];
            [battleReadyUpMAN1B setEnabled:YES];
            [battleReadyUpMAN1A setState:1];
            [battleReadyUpMAN1B setState:0];
            
        }else if(MF[MFselectedRow+1].MS.playerSet1 == 1){
            [battleReadyUpMAN1A setEnabled:NO];
            [battleReadyUpMAN1B setEnabled:NO];
            [battleReadyUpMAN1A setState:1];
            [battleReadyUpMAN1B setState:0];
        }else if(MF[MFselectedRow+1].MS.playerSet1 == 2){
            [battleReadyUpMAN1A setEnabled:NO];
            [battleReadyUpMAN1B setEnabled:NO];
            [battleReadyUpMAN1A setState:0];
            [battleReadyUpMAN1B setState:1];
        }
        
        if(MF[MFselectedRow+1].MS.playerSet2 == 0){
            [battleReadyUpMAN2A setEnabled:YES];
            [battleReadyUpMAN2B setEnabled:YES];
            [battleReadyUpMAN2A setState:1];
            [battleReadyUpMAN2B setState:0];
            
        }else if(MF[MFselectedRow+1].MS.playerSet2 == 1){
            [battleReadyUpMAN2A setEnabled:NO];
            [battleReadyUpMAN2B setEnabled:NO];
            [battleReadyUpMAN2A setState:1];
            [battleReadyUpMAN2B setState:0];
        }else if(MF[MFselectedRow+1].MS.playerSet2 == 2){
            [battleReadyUpMAN2A setEnabled:NO];
            [battleReadyUpMAN2B setEnabled:NO];
            [battleReadyUpMAN2A setState:0];
            [battleReadyUpMAN2B setState:1];
        }
        }
        if(retardhelp1){
            if([battleReadyUpMAN1A state] != 0)
                MF[MFselectedRow+1].MS.playerSet1 = 1;
            else
                MF[MFselectedRow+1].MS.playerSet1 = 2;
        }
        if(retardhelp2){
            if([battleReadyUpMAN2A state] != 0)
                MF[MFselectedRow+1].MS.playerSet2 = 1;
            else
                MF[MFselectedRow+1].MS.playerSet2 = 2;
        }
        return;
    }
    

    
    if(buildNum[possionX][possionY] < 0){
        [selectMesh setImage:MC[chipNum[possionX][possionY]].img];
        [selectMeshText setStringValue:MC[chipNum[possionX][possionY]].name];
        [selectMeshValue setStringValue:[NSString stringWithFormat:@"%d％", MC[chipNum[possionX][possionY]].dmgfix]];
    }else{
        [selectMesh setImage:BC[buildNum[possionX][possionY]].img];
        [selectMeshText setStringValue:BC[buildNum[possionX][possionY]].name];
        [selectMeshValue setStringValue:[NSString stringWithFormat:@"%d％", BC[buildNum[possionX][possionY]].dmgfix]];
    }
    [self SetStatusFunc];
    
    if(initStatusFlag){
        
        U = UTop;
        while(U != NULL){
            if(U->x == possionX && U->y == possionY && U->dead == true){
                break;
            }
            
            
            
            
            if(U->chipNumberL < 0){
            if(U->x == possionX && U->y == possionY && U->dead == false && Uselected){
                
                if(U->x == Uselected->x && U->y == Uselected->y && U->team == 0){
                    [tfArmy setStringValue:[NSString stringWithFormat:@"%@", P[0].name]];
                }
                if(U->x == Uselected->x && U->y == Uselected->y && U->team == 2){
                    [tfArmy setStringValue:[NSString stringWithFormat:@"%@", P[1].name]];
                }
                
                [tfName setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
                [HPbarTF setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
                [HPbarLI setIntValue:[[NSString stringWithFormat:@"%g", U->C.S_C.HP/U->C.S_M.HP*100 + 0.5] intValue]];
                [MPbarTF setStringValue:[NSString stringWithFormat:@"MP %g/%g", U->C.S_C.MP, U->C.S_M.MP]];
                [tfAttack setStringValue:[NSString stringWithFormat:@"攻撃力 %g", U->C.S_C.ATK]];
                [tfDefence setStringValue:[NSString stringWithFormat:@"防御力 %g", U->C.S_C.DEF]];
                [tfCalc setStringValue:[NSString stringWithFormat:@"演算力 %g", U->C.S_C.CAP]];
                [tfHit setStringValue:[NSString stringWithFormat:@"命中値 %g", U->C.S_C.ACU]];
                [tfDodge setStringValue:[NSString stringWithFormat:@"回避値 %g", U->C.S_C.EVA]];
                [tfMove setStringValue:[NSString stringWithFormat:@"移動力 %d", U->C.S_C.MOV]];
                [tfWait setStringValue:[NSString stringWithFormat:@"WT %g", U->C.S_C.WT]];
                [selectChara setImage:U->C.imgb];
                
                
                break;
            }else{
                [tfName setStringValue:[NSString stringWithFormat:@"----"]];
                [tfArmy setStringValue:[NSString stringWithFormat:@"----"]];
                [HPbarTF setStringValue:[NSString stringWithFormat:@"HP ----"]];
                [HPbarLI setIntValue:[[NSString stringWithFormat:@"0"] intValue]];
                [MPbarTF setStringValue:[NSString stringWithFormat:@"MP ----"]];
                [tfAttack setStringValue:[NSString stringWithFormat:@"攻撃力 ----"]];
                [tfDefence setStringValue:[NSString stringWithFormat:@"防御力 ----"]];
                [tfCalc setStringValue:[NSString stringWithFormat:@"演算力 ----"]];
                [tfHit setStringValue:[NSString stringWithFormat:@"命中値 ----"]];
                [tfDodge setStringValue:[NSString stringWithFormat:@"回避値 ----"]];
                [tfMove setStringValue:[NSString stringWithFormat:@"移動力 ----"]];
                [tfWait setStringValue:[NSString stringWithFormat:@"WT ----"]];
                [selectChara setImage:NULL];
            
            }
            }else{
                if(U->x == possionX && U->y == possionY && U->dead == false && Uselected){
                    
                    if(U->x == Uselected->x && U->y == Uselected->y && U->team == 0){
                        [tfArmy setStringValue:[NSString stringWithFormat:@"%@", P[0].name]];
                    }
                    if(U->x == Uselected->x && U->y == Uselected->y && U->team == 2){
                        [tfArmy setStringValue:[NSString stringWithFormat:@"%@", P[1].name]];
                    }
                    
                    [tfName setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
                    [HPbarTF setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
                    [HPbarLI setIntValue:[[NSString stringWithFormat:@"%g", U->CL.S_C.HP/U->CL.S_M.HP*100 + 0.5] intValue]];
                    [MPbarTF setStringValue:[NSString stringWithFormat:@"EN %g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
                    [tfAttack setStringValue:[NSString stringWithFormat:@"移動力 %d", U->CL.S_C.MOV]];
                    [tfDefence setStringValue:[NSString stringWithFormat:@"運動性 %g", U->CL.S_C.MOB]];
                    [tfCalc setStringValue:[NSString stringWithFormat:@"装甲 %g", U->CL.S_C.ARM]];
                    [tfHit setStringValue:[NSString stringWithFormat:@"限界 %g", U->CL.S_C.LIM]];
                    [tfDodge setStringValue:[NSString stringWithFormat:@""]];
                    [tfMove setStringValue:[NSString stringWithFormat:@""]];
                    [tfWait setStringValue:[NSString stringWithFormat:@"WT %g", U->CL.S_C.WT]];
                    [selectChara setImage:U->CL.imgb];
                    
                    
                    break;
                }else{
                    [tfName setStringValue:[NSString stringWithFormat:@"----"]];
                    [tfArmy setStringValue:[NSString stringWithFormat:@"----"]];
                    [HPbarTF setStringValue:[NSString stringWithFormat:@"HP ----"]];
                    [HPbarLI setIntValue:[[NSString stringWithFormat:@"0"] intValue]];
                    [MPbarTF setStringValue:[NSString stringWithFormat:@"MP ----"]];
                    [tfAttack setStringValue:[NSString stringWithFormat:@"攻撃力 ----"]];
                    [tfDefence setStringValue:[NSString stringWithFormat:@"防御力 ----"]];
                    [tfCalc setStringValue:[NSString stringWithFormat:@"演算力 ----"]];
                    [tfHit setStringValue:[NSString stringWithFormat:@"命中値 ----"]];
                    [tfDodge setStringValue:[NSString stringWithFormat:@"回避値 ----"]];
                    [tfMove setStringValue:[NSString stringWithFormat:@"移動力 ----"]];
                    [tfWait setStringValue:[NSString stringWithFormat:@"WT ----"]];
                    [selectChara setImage:NULL];
                    
                }
            
            
            
            }
            U = U->next;
        }
        U = UTop;
        
        U = UTop;
        
    }
    
    if(unitBreak){
    if(unitBreak->team == 0){
        [tfResource setStringValue:[NSString stringWithFormat:@"資源 %d", P[0].resource]];
        [tfFood setStringValue:[NSString stringWithFormat:@"食料 %d", P[0].food]];
        [tfMoney setStringValue:[NSString stringWithFormat:@"資金 %d", P[0].money]];
    }else if(unitBreak->team == 2){
        [tfResource setStringValue:[NSString stringWithFormat:@"資源 %d", P[1].resource]];
        [tfFood setStringValue:[NSString stringWithFormat:@"食料 %d", P[1].food]];
        [tfMoney setStringValue:[NSString stringWithFormat:@"資金 %d", P[1].money]];
    }
    }
    
    if(menuDisplayFlag){
        [self SetMenu];
        [self initBCreateList];
        [self initCSummonList];
    }
    
    if (initMapFlag && !initStatusFlag) {
        [self initUnitStatus];
        [self initBuildStatus];
        
        U = UTop;
        
        while (U != NULL) {
            U->C.S_C.HP = U->C.S_M.HP;
            
            U = U->next;
        }
        U = UTop;
        
        initStatusFlag = true;
        battleBegin = true;
        unitBreak = U;
        TeamCountFlag = true;
        
        unitColorInitFlag = true;
        
        MFselectedRow = 0;
        for (int i = 1;i < 512;i++) {
            if([[SC[storyNumb].nameMAP objectAtIndex:scenarioNumb] isEqualToString:[NSString stringWithFormat:@"%@", MF[i].fileName]])
                break;
            MFselectedRow++;
        }
        [self setTargetList];
        
        
        [self initMapscript];
        
        initMapEventFlag = true;
        fieldViewBattleInitFlag = true;
    }
    
    
    U = UTop;
    if(battleBegin)
        while (!wtRdy) {
            wtPx = 0;
            wtPy = 0;
            wtMovedFlag = false;
            wtAttackedFlag = false;
            U = UTop;
            U = unitBreak;
            
            while (U) {
                if(!U->dead) U->C.S_C.WT -= 1;
                if(U->dead) U->C.S_C.WT = 999999;
                if(U->C.S_C.WT <= 0 && !U->dead){
                    U->C.S_C.WT = 0;
                    wtUnitNum = U->number;
                    wtPx = U->x;
                    wtPy = U->y;
                    wtRdy = true;
                    unitBreak = U;
                    possionX = unitBreak->x;
                    possionY = unitBreak->y;
                    break;
                }
                U = U->next;
                if(!U) {
                    unitBreak = UTop;
                    BTop = B;
                    while(B){
                        if(!B->dead) B->C.S_C.WTE -= 1;
                        if(B->C.S_C.WTE <= 0){
                            
                            if(B->team == 0){
                                P[0].resource += B->C.Esupply;
                                P[0].food += B->C.Efood;
                                P[0].money += B->C.Emoney;
                            }
                            if(B->team == 2){
                                P[1].resource += B->C.Esupply;
                                P[1].food += B->C.Efood;
                                P[1].money += B->C.Emoney;
                            }
                            B->C.S_C.WTE = B->C.S_M.WTE;
                        }
                        B = B->next;
                    }B = BTop;
                }
            }
            U = UTop;
            if(!U) break;
        }
    U = UTop;
    
    if(battleWindowFlag){battleFlag = true; battleWindowFlag = false;
    
    }
    
    if(battleFlag){
        if(!battleSettingFlag){
            windowPoint.x = [mapWindow frame].origin.x;
            windowPoint.y = [mapWindow frame].origin.y;
            [battlePanel setFrameOrigin:windowPoint];
            [battlePanel makeKeyAndOrderFront:nil];
        }
        [self setBattlePanel];
    }
    if(battleRdy){
        [self DisplayMessage];
    }
    
    if(buildSelectedFlag){
        windowPoint.x = [mapWindow frame].origin.x;
        windowPoint.y = [mapWindow frame].origin.y;
        [researchPanel setFrameOrigin:windowPoint];
        if([self setBuildList]){
            [researchPanel makeKeyAndOrderFront:nil];
        };
        buildSelectedFlag = false;
    }
    
    if(mapChipDataLoadFail){
        
        [endGamePanel close];
        [esWindow makeKeyAndOrderFront:nil];
        [fsWindow close];
        
        endGameCondition = false;
        initMapFlag = false;
        TeamCountFlag = false;
        initStatusFlag = false;
        battleBegin = false;
        startES = true;
        
        redWinFlag = false;
        blueWinFlag = false;
        battleFlag = false;
        battleRdy = false;
        
        mapChipDataLoadFail = false;
        return;
    }
    
    if(TeamCountFlag && !endGameCondition){
        U = UTop;
        TeamCount0 = 0;
        TeamCount2 = 0;
        while(U){
            if((U->team == 0 || U->team == 1) && !U->dead){
                TeamCount0++;
            }
            else if(U->team == 2 && !U->dead){
                TeamCount2++;
            }
            U = U->next;
        }
        U = UTop;
        
        
        if(targType1cnt[1] == 0 || targType2cnt[1] == 0){
            endGameCondition = true;
            redWinFlag = true;
            [endGameText setStringValue:[NSString stringWithFormat:@"%@の勝利！", P[1].name]];
        }
        if(targType1cnt[0] == 0 || targType2cnt[0] == 0){
            endGameCondition = true;
            blueWinFlag = true;
            [endGameText setStringValue:[NSString stringWithFormat:@"%@の勝利！", P[0].name]];
        }
        
        if(targType2Dflag){
            endGameCondition = true;
            redWinFlag = true;
            [endGameText setStringValue:[NSString stringWithFormat:@"%@の勝利！", P[1].name]];
        }
        if(targType2Lflag){
            endGameCondition = true;
            blueWinFlag = true;
            [endGameText setStringValue:[NSString stringWithFormat:@"%@の勝利！", P[0].name]];
        }
        
        if(TeamCount0 == 0 && (MF[MFselectedRow+1].MS.EGCdark.endType1 == 2 || MF[MFselectedRow+1].MS.EGCdark.endType2 == 2)){
            endGameCondition = true;
            redWinFlag = true;
            [endGameText setStringValue:[NSString stringWithFormat:@"%@の勝利！", P[1].name]];
        }
        if(TeamCount2 == 0 && (MF[MFselectedRow+1].MS.EGClight.endType1 == 1 || MF[MFselectedRow+1].MS.EGClight.endType2 == 1)){
            endGameCondition = true;
            blueWinFlag = true;
            [endGameText setStringValue:[NSString stringWithFormat:@"%@の勝利！", P[0].name]];
        }
    }
    
    
    static int endGamePanelWait = 100;
    
    if(endGameCondition && !battleRdy){
        
        if(redWinFlag && blueWinFlag){
            
        
        }else{
            windowPoint.x = [mapWindow frame].origin.x+30;
            windowPoint.y = [mapWindow frame].origin.y+200;
            [endGamePanel setFrameOrigin:windowPoint];
            [endGamePanel makeKeyAndOrderFront:nil];
            endGamePanelWait--;
            if(endGamePanelWait > 0) return;
        }
        
        [endGamePanel close];
        [esWindow makeKeyAndOrderFront:nil];
        [fsWindow close];
        
        endGameCondition = false;
        initMapFlag = false;
        TeamCountFlag = false;
        initStatusFlag = false;
        battleBegin = false;
        startES = true;
        
        cpuModeMOVEflag = false;
        cpuModeATTACKflag = false;
        
        redWinFlag = false;
        blueWinFlag = false;
        
        wtRdy = false;
        Uselected = NULL;
        
        endGamePanelWait = 100;
    }
    
    
    if(Uselected)
        if(Uselected->dead){
            
            U = UTop;
            
            while (U->number != wtUnitNum) {
                U = U->next;
            }
            
            if(!wtMovedFlag && !wtAttackedFlag){
                U->C.S_C.WT = floor(U->C.S_M.WT/4 + 0.5);
            }else if(wtMovedFlag && wtAttackedFlag){
                U->C.S_C.WT =  floor(U->C.S_M.WT + 0.5);
            }else if(wtMovedFlag){
                U->C.S_C.WT =  floor(U->C.S_M.WT/2 + 0.5);
            }else if(wtAttackedFlag){
                U->C.S_C.WT =  floor(U->C.S_M.WT/2 + 0.5);
            }
            
            U = UTop;
            
            wtRdy = false;
        }
    
    if(summonRdyFlag){
        U = UTop;
        
        
        U = UTop;
        [self addSummonStatus];
        
        U = CSLU;
        
        if(U->team == 0){
            
            SKILL *sTop = U->C.S;
            
            while (U->C.S) {
                if(U->C.S->type == 2) break;
                U->C.S = U->C.S->next;
            }
            
            U->C.S_C.MP -= U->C.S->cost[crCSL];
            
            if(!U->C.S){
                U->C.S = sTop;
                U = UTop;
                return;
            }
            
            
            unitNum[possionX][possionY] = U->C.S->list[crCSL]-1;
            unitTeam[possionX][possionY] = 0;
            
            U->C.S = sTop;
            unitColorInitFlag = true;
        }
        if(U->team == 2){
            
            SKILL *sTop = U->C.S;
            
            while (U->C.S) {
                if(U->C.S->type == 2) break;
                U->C.S = U->C.S->next;
            }
            
            U->C.S_C.MP -= U->C.S->cost[crCSL];
            
            if(!U->C.S){
                U->C.S = sTop;
                U = UTop;
                return;
            }
            
            unitNum[possionX][possionY] = U->C.S->list[crCSL]-1;
            unitTeam[possionX][possionY] = 2;
            
            U->C.S = sTop;
            unitColorInitFlag = true;
        }
    
        summonRdyFlag = false;
        cslRdy = false;
        
        U = UTop;
    }
    
    
    
    if(battleBegin){
        
        MAPSCRIPT MS = MF[MFselectedRow+1].MS;
        MAPSCRIPTD *MSDtop;
        MSDtop = MS.D;
        if(!MSDtop)
            goto w000p;
        MAPSCRIPT0 *MSDPtop;
        MSDPtop = MS.D->P;
        
        
        
        
        while (MS.D) {
            int proccesType = -1;
            
            bool EventFailFlag = false;
            
            enum{
            ENTIRE_MAP,
            CENTER_POINT
            };
            
            while(MS.D){
                if(MS.D->endFlag)
                    MS.D = MS.D->next;
                else
                    break;
            }
            
            if(!MS.D) break;
            
            if(MS.D)
            while(MS.D->P){
                if(MS.D->P->endFlag)
                    MS.D->P = MS.D->P->next;
                else
                    break;
            }
            if(!MS.D->P){
                MS.D->endFlag = true;
                messageDialog = false;
                [self setMessage:NULL];
                MS.D = MS.D->next;
            }
            if(!MS.D) break;
        
            if(MS.D->switch1)
            for(int i = 0;*(MS.D->switch1+i)>0;i++){
                if(Suicchi[*(MS.D->switch1+i)])
                    continue;
                
                EventFailFlag = true;
            }
            
            if(MS.D->switch2)
            for(int i = 0;*(MS.D->switch2+i)>0;i++){
                if(!Suicchi[*(MS.D->switch2+i)])
                    continue;
                
                EventFailFlag = true;
            }
            
            
            
            if(MS.D->type == -1 && !EventFailFlag)
                proccesType = ENTIRE_MAP;
            if(MS.D->type == 0 && pushStanbyFlag && (Uselected->x == MS.D->x && Uselected->y == MS.D->y) && !EventFailFlag)
                proccesType = CENTER_POINT;
            
        switch (proccesType) {
                
            case ENTIRE_MAP:
                MS.D->P = [self setEvent:MS.D->P];
                break;
            case CENTER_POINT:
                MS.D->P = [self setEvent:MS.D->P];
                break;
                
            default:
                break;
        }
            
            
            if(EventFailFlag){
                MS.D = MS.D->next;
                continue;
            }
            
            break;
        }
        MS.D = MSDtop;
    }
w000p:
    
    if(!unitBreak)
        return;
    
    if(unitBreak->team == 2 && MF[MFselectedRow+1].MS.playerSet2 == 2){
        unitBreak->CPU = true;
        cpuAImodeflag = true;
        //NSLog(@"OMFG");
    }else if(unitBreak->team == 0 && MF[MFselectedRow+1].MS.playerSet1 == 2){
        unitBreak->CPU = true;
        cpuAImodeflag = true;
        //NSLog(@"OMFG");
    }else if(unitBreak->team == 1){
        unitBreak->CPU = true;
        cpuAImodeflag = true;
        //NSLog(@"OMFG");
    }
    else{
        unitBreak->CPU = false;
        cpuAImodeflag = false;
    }
    
    if(CPUAttackSubmitFlag){
        battleFlag = true;
        CPUAttackSubmitFlag = false;
        windowPoint.x = [mapWindow frame].origin.x;
        windowPoint.y = [mapWindow frame].origin.y;
        [atkPanel setFrameOrigin:windowPoint];
    }
    
    
    static int oopsCnt = 20;
    
    if(battleFlag && MF[MFselectedRow+1].MS.playerSet1 == 2 && MF[MFselectedRow+1].MS.playerSet2 == 2){
        
        oopsCnt--;
        if(oopsCnt > 0)
            return;
        else{
            oopsCnt = 20;
        }
        
        battleFlag = false;
        battleRdy = true;
        battleSet1Flag = false;
        battleSet2Flag = false;
        battleSettingFlag = false;
        [self AttackDisplay];
        windowPoint.x = [mapWindow frame].origin.x;
        windowPoint.y = [mapWindow frame].origin.y;
        [battleWindow setFrameOrigin:windowPoint];
        [battleWindow makeKeyAndOrderFront:nil];
        [battlePanel close];
    }
    
    
    if(battleRdy && MF[MFselectedRow+1].MS.playerSet1 == 2 && MF[MFselectedRow+1].MS.playerSet2 == 2){
        
        oopsCnt--;
        if(oopsCnt > 0)
            return;
        else{
            oopsCnt = 20;
        }
        
       bLoopFlag = false;
    }

}

-(MAPSCRIPT0*)setEvent:(MAPSCRIPT0*)MS0{

    enum{
        MESSAGE_FLAG,
        SELECTION_FLAG,
        INPUTNUMBER_FLAG,
        SWITCH_FLAG
    };

    int Proc = -1;
    
    if(MS0->type == 0)
        Proc = MESSAGE_FLAG;
    if(MS0->type == 1)
        Proc = SELECTION_FLAG;
    if(MS0->type == 2)
        Proc = INPUTNUMBER_FLAG;
    if(MS0->type == 3)
        Proc = SWITCH_FLAG;
    
    switch(Proc){
            
        case MESSAGE_FLAG:
            messageDialog = true;
            [self setMessage:MS0];
            break;
        case SELECTION_FLAG:
            
            break;
        case INPUTNUMBER_FLAG:
            
            break;
    
        case SWITCH_FLAG:
            MS0 = [self setSwitch:MS0];
            break;
            
    }
    

    return MS0;
}


-(void)setTargetList{

    targType1cnt[0] = -1;
    targType1cnt[1] = -1;
    targType2cnt[0] = -1;
    targType2cnt[1] = -1;
    targType2Lflag = false;
    targType2Dflag = false;
    
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    while(1) {
        
        for (int i = 0;i < 64;i++) {
            if(!MS.EGClight.etValue1[i]) break;
            NSArray *array1 = [MS.EGClight.etValue1[i] componentsSeparatedByString:@"["];
            NSArray *array2 = [[array1 objectAtIndex:1] componentsSeparatedByString:@","];
            
            int Tx = [[array2 objectAtIndex:0] intValue];
            int Ty = [[array2 objectAtIndex:1] intValue];
            if(MS.EGClight.endType1 == 3){
                U = UTop;
                while (U) {
                    if(U->x == Tx && U->y == Ty){
                        U->targType1L = true;
                        if(targType1cnt[0] < 0)
                            targType1cnt[0] = 0;
                        targType1cnt[0]++;
                        break;
                    }
                    U = U->next;
                }U = UTop;
            }
            if(MS.EGClight.endType1 == 4){
                U = UTop;
                while (U) {
                    if(U->x == Tx && U->y == Ty){
                        U->targType2L = true;
                        if(targType2cnt[0] < 0)
                            targType2cnt[0] = 0;
                        targType2cnt[0]++;
                        break;
                    }
                    U = U->next;
                }U = UTop;
            }
        }
        for (int i = 0;i < 64;i++) {
            if(!MS.EGClight.etValue2[i]) break;
            NSArray *array1 = [MS.EGClight.etValue2[i] componentsSeparatedByString:@"["];
            NSArray *array2 = [[array1 objectAtIndex:1] componentsSeparatedByString:@","];
            
            int Tx = [[array2 objectAtIndex:0] intValue];
            int Ty = [[array2 objectAtIndex:1] intValue];
            
            if(MS.EGClight.endType2 == 3){
            U = UTop;
                while (U) {
                    if(U->x == Tx && U->y == Ty){
                        U->targType1L = true;
                        if(targType1cnt[0] < 0)
                            targType1cnt[0] = 0;
                        targType1cnt[0]++;
                        break;
                    }
                    U = U->next;
                }U = UTop;
            }
            if(MS.EGClight.endType2 == 4){
                U = UTop;
                while (U) {
                    if(U->x == Tx && U->y == Ty){
                        U->targType2L = true;
                        if(targType2cnt[0] < 0)
                            targType2cnt[0] = 0;
                        targType2cnt[0]++;
                        break;
                    }
                    U = U->next;
                }U = UTop;
            }
        }
        for (int i = 0;i < 64;i++) {
            if(!MS.EGCdark.etValue1[i]) break;
            NSArray *array1 = [MS.EGCdark.etValue1[i] componentsSeparatedByString:@"["];
            NSArray *array2 = [[array1 objectAtIndex:1] componentsSeparatedByString:@","];
            
            int Tx = [[array2 objectAtIndex:0] intValue];
            int Ty = [[array2 objectAtIndex:1] intValue];
            
            if(MS.EGCdark.endType1 == 3){
                    U = UTop;
                while (U) {
                    if(U->x == Tx && U->y == Ty){
                        U->targType1D = true;
                        if(targType1cnt[1] < 0)
                            targType1cnt[1] = 0;
                        targType1cnt[1]++;
                        break;
                    }
                    U = U->next;
                }U = UTop;
            }
            if(MS.EGCdark.endType1 == 4){
                U = UTop;
                while (U) {
                    if(U->x == Tx && U->y == Ty){
                        U->targType2D = true;
                        if(targType2cnt[1] < 0)
                            targType2cnt[1] = 0;
                        targType2cnt[1]++;
                        break;
                    }
                    U = U->next;
                }U = UTop;
            }
        }
        for (int i = 0;i < 64;i++) {
            if(!MS.EGCdark.etValue2[i]) break;
            NSArray *array1 = [MS.EGCdark.etValue2[i] componentsSeparatedByString:@"["];
            NSArray *array2 = [[array1 objectAtIndex:1] componentsSeparatedByString:@","];
            
            int Tx = [[array2 objectAtIndex:0] intValue];
            int Ty = [[array2 objectAtIndex:1] intValue];
            
            if(MS.EGCdark.endType2 == 3){
                U = UTop;
                while (U) {
                    if(U->x == Tx && U->y == Ty){
                        U->targType1D = true;
                        if(targType1cnt[1] < 0)
                            targType1cnt[1] = 0;
                        targType1cnt[1]++;
                        break;
                    }
                    U = U->next;
                }U = UTop;
            }
            if(MS.EGCdark.endType2 == 4){
                U = UTop;
                while (U) {
                    if(U->x == Tx && U->y == Ty){
                        U->targType2D = true;
                        if(targType2cnt[1] < 0)
                            targType2cnt[1] = 0;
                        targType2cnt[1]++;
                        break;
                    }
                    U = U->next;
                }U = UTop;
            }
        }
        break;
    }




}

-(bool)setBuildList{

    [self willChangeValueForKey:@"CResearchListMA"];
    [CResearchListMA removeAllObjects];
    [self didChangeValueForKey:@"CResearchListMA"];
    
    BUILDCHIP *B0;
    
    B = BTop;
    
    while (B->x == possionX && B->y == possionY) {
        B = B->next;
    }
    B0 = &BC[buildNum[possionX][possionY]];
    
    RESEARCH *Rtop;
    UNITCHIP *BU;
    
    Rtop = B0->R;
    
    if(!B0->R){
        return false;
    }
    
    while(B0->R){
        BU = B0->R->U;
        
        if(B->makeLv >= B0->R->Lv){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", BU->nameClass] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%g", BU->S_M.HP] forKey:@"HP"];
        [dict setValue:[NSString stringWithFormat:@"資%d 食%d 金%d", BU->S_M.cSupply, BU->S_M.cFood, BU->S_M.cMoney] forKey:@"cost"];
        [dict setValue:BU->img forKey:@"img"];

        
        [self willChangeValueForKey:@"CResearchListMA"];
        [CResearchListMA addObject:dict];
        [self didChangeValueForKey:@"CResearchListMA"];
        }
        B0->R = B0->R->next;
    }
    B0->R = Rtop;
    
    B = BTop;
    return true;
}

-(void)SetMenu{
    
    [self setCommandPanel];
    [menuPanel makeKeyAndOrderFront:nil];
}

-(IBAction)pushMove:(id)sender{menuDisplayFlag = false;
    [menuPanel close];
    moveFlag = true;
    attackFlag = false;
    createFlag = false;
    summonFlag = false;
}
-(IBAction)pushAttack:(id)sender{menuDisplayFlag = false;
    [menuPanel close];
    attackFlag = true;
    moveFlag = false;
    windowPoint.x = [mapWindow frame].origin.x;
    windowPoint.y = [mapWindow frame].origin.y;
    [atkPanel setFrameOrigin:windowPoint];
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(U->chipNumberL >= 0){
        U = UTop;
        [self initCAttackList2];
        [self initCAttackSelect2];
    }
    else if(U->chipNumber >= 0) {
        U = UTop;
        [self initCAttackList];
        [self initCAttackSelect];
    }
    U = UTop;
    [atkPanel makeKeyAndOrderFront:nil];
}
-(IBAction)pushStandby:(id)sender{menuDisplayFlag = false;
    
    U = UTop;
    
    while (U->number != wtUnitNum) {
        U = U->next;
    }
    
    if(!wtMovedFlag && !wtAttackedFlag){
        U->C.S_C.WT = floor(U->C.S_M.WT/4 + 0.5);
    }else if(wtMovedFlag && wtAttackedFlag){
        U->C.S_C.WT =  floor(U->C.S_M.WT + 0.5);
    }else if(wtMovedFlag){
        U->C.S_C.WT =  floor(U->C.S_M.WT/2 + 0.5);
    }else if(wtAttackedFlag){
        U->C.S_C.WT =  floor(U->C.S_M.WT/2 + 0.5);
    }
    
    U = UTop;
    
    wtRdy = false;
    pushStanbyFlag = true;
    [menuPanel close];
}
-(IBAction)pushCreate:(id)sender{menuDisplayFlag = false;
    [menuPanel close];
    createFlag = true;
    moveFlag = false;
    
    windowPoint.x = [mapWindow frame].origin.x;
    windowPoint.y = [mapWindow frame].origin.y;
    [createPanel setFrameOrigin:windowPoint];
    
    [self initBCreateList];
    [createPanel makeKeyAndOrderFront:nil];
}

-(IBAction)pushSummon:(id)sender{menuDisplayFlag = false;
    [menuPanel close];
    summonFlag = true;
    moveFlag = false;
    
    windowPoint.x = [mapWindow frame].origin.x;
    windowPoint.y = [mapWindow frame].origin.y;
    [summonPanel setFrameOrigin:windowPoint];
    
    [self initCSummonList];
    [summonPanel makeKeyAndOrderFront:nil];
}

-(IBAction)pushStatus:(id)sender{menuDisplayFlag = false;
    [menuPanel close];
}
-(IBAction)pushCancel:(id)sender{menuDisplayFlag = false;
    moveFlag = false;
    attackFlag = false;
    summonFlag = false;
    [menuPanel close];
}
-(IBAction)pushCancelCAL:(id)sender{
    attackFlag = false;
    battleSet1Flag = false;
    battleSet2Flag = false;
    [atkPanel close];
}

-(IBAction)pushCancelBCL:(id)sender{
    createFlag = false;
    [createPanel close];
}

-(IBAction)pushCancelCSL:(id)sender{
    summonFlag = false;
    [summonPanel close];
}

-(void)addBuildStatus{
    int omgCnt = 0;
    BTop = B;
    while (B->next) {omgCnt++;
        B = B->next;
    }
    B->next = calloc(1, sizeof(BUILD));
    B = B->next;
    B->next = NULL;
    if(omgCnt == 0) BTop = B;
    B->number = registerNumB;
    B->x = possionX;
    B->y = possionY;
    B->C = BC[buildNum[possionX][possionY]];
    B->img = BC[buildNum[possionX][possionY]].img;
    unitColorInitFlag = true;
    if(buildTeam[possionX][possionY] == 0 || buildTeam[possionX][possionY] == 1){
        B->team = 0;
        if(unitTeam[possionX][possionY] == 0){
            U->joinArmyFromNext = true;
            U->persuasion = true;
        }
    }
    if(buildTeam[possionX][possionY] == 2 || buildTeam[possionX][possionY] == 3){
        B->team = 2;
    }
    if(buildTeam[possionX][possionY] == 4 || buildTeam[possionX][possionY] == 5){
        B->team = 1;
    }
    if(buildTeam[possionX][possionY] == -1){
        B->team = -1;

    }
    [self SetUnitStatus:unitNum[possionX][possionY]];
    registerNumB++;
    B = BTop;
}


-(void)addUnitStatus{
    int omgCnt = 0;
    UTop = U;
    while (U->next) {omgCnt++;
        U = U->next;
    }
    U->next = calloc(1, sizeof(UNIT));
    U = U->next;
    U->next = NULL;
    if(omgCnt == 0) UTop = U;
    U->number = registerNum;
    
    for(int i = 0;i < UCN;i++){
        if([U->C.nameID isEqualToString:UC[i].nameID])
            U->chipNumber = i;
    }
    
    U->chipNumberL = -1;
    
    U->x = possionX;
    U->y = possionY;
    U->C = *BRU;
                if(unitTeam[possionX][possionY] == 0 || unitTeam[possionX][possionY] == 1){
                    U->team = 0;
                    if(unitTeam[possionX][possionY] == 1){
                        U->joinArmyFromNext = true;
                        U->persuasion = true;
                    }
                }
                if(unitTeam[possionX][possionY] == 2 || unitTeam[possionX][possionY] == 3){
                    U->team = 2;
                    if(unitTeam[possionX][possionY] == 3){
                        U->joinArmyFromNext = true;
                        U->persuasion = true;
                    }
                }
                if(unitTeam[possionX][possionY] == 4 || unitTeam[possionX][possionY] == 5){
                    U->team = 1;
                    if(unitTeam[possionX][possionY] == 5){
                        U->joinArmyFromNext = true;
                        U->persuasion = true;
                    }
                }
                if(unitTeam[possionX][possionY] == -1){
                    U->team = -1;
                    if(unitTeam[possionX][possionY] == 0){
                        U->joinArmyFromNext = false;
                        U->persuasion = true;
                    }
                }
                [self SetUnitStatus:unitNum[possionX][possionY]];
    registerNum++;
    U = UTop;
}

-(void)addSummonStatus{
    
    int omgCnt = 0;
    UTop = U;
    while (U->next) {omgCnt++;
        U = U->next;
    }
    U->next = calloc(1, sizeof(UNIT));
    U = U->next;
    U->next = NULL;
    if(omgCnt == 0) UTop = U;
    U->number = registerNum;
    for(int i = 0;i < UCN;i++){
        if([U->C.nameID isEqualToString:UC[i].nameID])
            U->chipNumber = i;
    }
    
    U->chipNumberL = -1;
    U->x = possionX;
    U->y = possionY;

    U->C = CSLUC;
    if(unitTeam[CSLU->x][CSLU->y] == 0 || unitTeam[CSLU->x][CSLU->y] == 1){
        U->team = 0;
        if(unitTeam[CSLU->x][CSLU->y] == 1){
            U->joinArmyFromNext = true;
            U->persuasion = true;
        }
    }
    if(unitTeam[CSLU->x][CSLU->y] == 2 || unitTeam[CSLU->x][CSLU->y] == 3){
        U->team = 2;
        if(unitTeam[CSLU->x][CSLU->y] == 3){
            U->joinArmyFromNext = true;
            U->persuasion = true;
        }
    }
    if(unitTeam[CSLU->x][CSLU->y] == 4 || unitTeam[CSLU->x][CSLU->y] == 5){
        U->team = 1;
        if(unitTeam[CSLU->x][CSLU->y] == 5){
            U->joinArmyFromNext = true;
            U->persuasion = true;
        }
    }
    if(unitTeam[CSLU->x][CSLU->y] == -1){
        U->team = -1;
        if(unitTeam[CSLU->x][CSLU->y] == 0){
            U->joinArmyFromNext = false;
            U->persuasion = true;
        }
    }
    
    registerNum++;
    U = UTop;

}

-(void)initUnitStatus{
    registerNum = 1;
    U = NULL;
    UTop = NULL;
    for(int i=1;i <= chipHeight;i++){
        for(int j=1;j<= chipWidth;j++){
            if(unitNum[j][i] >= 0 || loadNum[j][i] >= 0){
                if(registerNum == 1){
                    U = calloc(1, sizeof(UNIT));
                    UTop = U;
                }
                if(registerNum > 1)
                    U = U->next;
                U->x = j;
                U->y = i;
                U->number = registerNum;
                U->chipNumber = unitNum[j][i];
                U->chipNumberL = loadNum[j][i];
                
                
                
                registerNum++;
                if(unitTeam[j][i] == 0 || unitTeam[j][i] == 1){
                    U->team = 0;
                    if(unitTeam[j][i] == 1){
                        U->joinArmyFromNext = true;
                        U->persuasion = true;
                    }
                    if(MF[MFselectedRow+1].MS.playerSet1 == 2)
                        U->CPU = true;
                }
                if(unitTeam[j][i] == 2 || unitTeam[j][i] == 3){
                    U->team = 2;
                    if(unitTeam[i][j] == 2){
                        U->joinArmyFromNext = true;
                        U->persuasion = true;
                    }
                    if(MF[MFselectedRow+1].MS.playerSet2 == 2)
                        U->CPU = true;
                }
                if(unitTeam[j][i] == 4 || unitTeam[j][i] == 5){
                    U->team = 1;
                    if(unitTeam[j][i] == 5){
                        U->joinArmyFromNext = true;
                        U->persuasion = true;
                    }
                    U->CPU = true;
                }
                if(unitTeam[j][i] == -1){
                    U->team = -1;
                    if(unitTeam[j][i] == -1){
                        U->joinArmyFromNext = false;
                        U->persuasion = true;
                    }
                    U->CPU = true;
                }
                if(unitNum[j][i] >= 0) [self SetUnitStatus:unitNum[j][i]];
                if(loadNum[j][i] >= 0) [self SetUnitStatus2:loadNum[j][i]];
                
                U->next = calloc(1, sizeof(UNIT));
                U->atkRange = 0;
            }
        
        }
    }
    
    if(U) U->next = NULL;
    U = UTop;

}

-(void)initBuildStatus{
    registerNumB = 1;
    B = NULL;
    BTop = NULL;
    for(int i=1;i <= chipHeight;i++){
        for(int j=1;j<= chipWidth;j++){
            if(buildNum[j][i] >= 0){
                if(registerNumB == 1){
                    B = calloc(1, sizeof(BUILD));
                    BTop = B;
                }
                if(registerNumB > 1)
                    B = B->next;
                B->x = j;
                B->y = i;
                B->number = registerNumB;
                B->chipNumber = buildNum[j][i];
                B->makeLv = 1;
                registerNumB++;
                if(buildTeam[j][i] == 0 || buildTeam[j][i] == 1){
                    B->team = 0;

                }
                if(buildTeam[j][i] == 2 || buildTeam[j][i] == 3){
                    B->team = 2;

                }
                if(buildTeam[j][i] == 4 || buildTeam[j][i] == 5){
                    B->team = 1;

                }
                if(buildTeam[j][i] == -1){
                    B->team = -1;

                }
                //[self SetUnitStatus:unitNum[j][i]];
                
                B->C = BC[buildNum[j][i]];
                
                B->next = calloc(1, sizeof(BUILD));

            }
            
        }
    }
    if(B) B->next = NULL;
    B = BTop;
    
}

-(void)SetUnitStatus:(int)UN{
    
    U->C = UC[UN];
    
    ATTACK *Atop;
    ATTACK *AtopE1;
    ATTACK *AtopE2;
    ATTACK *UAtop;
    Atop = UC[UN].A;
    AtopE1 = UC[UN].eHandL.A;
    AtopE2 = UC[UN].eHandR.A;
    U->C.A = calloc(1, sizeof(ATTACK));
    UAtop = U->C.A;
    
    bool ow1;
    bool ow2;
    
    while(UC[UN].eHandR.A != NULL){ow1 = true;
        *U->C.A = *UC[UN].eHandR.A;
        U->C.A->next = calloc(1, sizeof(ATTACK));
        U->C.A->next->next = NULL;
        if(UC[UN].eHandR.A->next != NULL) U->C.A = U->C.A->next;
        UC[UN].eHandR.A = UC[UN].eHandR.A->next;
        U->C.attackListNum++;
    }
    UC[UN].eHandR.A = AtopE2;
    if(ow1) {
        U->C.A->next = calloc(1, sizeof(ATTACK));
        U->C.A = U->C.A->next;
        ow1 = false;
    }
    while(UC[UN].eHandL.A != NULL){ow2 = true;
        *U->C.A = *UC[UN].eHandL.A;
        U->C.A->next = calloc(1, sizeof(ATTACK));
        U->C.A->next->next = NULL;
        if(UC[UN].eHandL.A->next != NULL) U->C.A = U->C.A->next;
        UC[UN].eHandL.A = UC[UN].eHandL.A->next;
        U->C.attackListNum++;
    }
    UC[UN].eHandL.A = AtopE1;
    if(ow2) {
        U->C.A->next = calloc(1, sizeof(ATTACK));
        U->C.A = U->C.A->next;
        ow1 = false;
    }
    while(UC[UN].A != NULL){
        *U->C.A = *UC[UN].A;
        U->C.A->next = calloc(1, sizeof(ATTACK));
        U->C.A->next->next = NULL;
        if(UC[UN].A->next != NULL) U->C.A = U->C.A->next;
        UC[UN].A = UC[UN].A->next;
    }
    U->C.A->next = NULL;
    UC[UN].A = Atop;
    U->C.A = UAtop;
    
}

-(void)SetUnitStatus2:(int)UN{
    
    U->CL = LC[UN];
    
    ATTACK *Atop;
    ATTACK *UAtop;
    Atop = LC[UN].A;
    U->CL.A = calloc(1, sizeof(ATTACK));
    UAtop = U->CL.A;
    while(LC[UN].A != NULL){
        *U->CL.A = *LC[UN].A;
        U->CL.A->next = calloc(1, sizeof(ATTACK));
        U->CL.A->next->next = NULL;
        if(LC[UN].A->next != NULL) U->CL.A = U->CL.A->next;
        LC[UN].A = LC[UN].A->next;
    }
    U->CL.A->next = NULL;
    LC[UN].A = Atop;
    U->CL.A = UAtop;
    
}


-(void)initCAttackList2{
    crCAL = 0;
    
    CAttackListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"CAttackListMA"];
    [CAttackListMA removeAllObjects];
    [self didChangeValueForKey:@"CAttackListMA"];
    
    U = UTop;
    if(!battleSet2PushedFlag){
        ATTACK *Atop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        Atop = U->CL.A;
        for(int i = 0;i < U->CL.attackListNum;i++){
            if(!U->CL.A) break;
            NSMutableDictionary* dict = [NSMutableDictionary new];
            [dict setValue:[NSString stringWithFormat:@"%@", U->CL.A->name] forKey:@"name"];
            [dict setValue:[NSString stringWithFormat:@"%g", U->CL.A->totalD] forKey:@"atk"];
            if(U->CL.A->rangeA != U->CL.A->rangeB){
                [dict setValue:[NSString stringWithFormat:@"%d-%d", U->CL.A->rangeA, U->CL.A->rangeB] forKey:@"range"];
            }else{
                [dict setValue:[NSString stringWithFormat:@"%d", U->CL.A->rangeA] forKey:@"range"];
            }
            [dict setValue:[NSString stringWithFormat:@"%d", U->CL.A->hitPercent] forKey:@"hit"];
            //[dict setValue:[NSString stringWithFormat:@"%d", U->C.A->bulletC] forKey:@"bullet"];
            
            [self willChangeValueForKey:@"CAttackListMA"];
            [CAttackListMA addObject:dict];
            [self didChangeValueForKey:@"CAttackListMA"];
            
            U->CL.A = U->CL.A->next;
        }
        
        U->CL.A = Atop;
    }else{
        ATTACK *Atop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        Atop = U->CL.A;
        for(int i = 0;i < U->CL.attackListNum;i++){
            
            if(!U->CL.A){
                U->CL.attackListNum = i;
                break;
            }
            NSMutableDictionary* dict = [NSMutableDictionary new];
            [dict setValue:[NSString stringWithFormat:@"%@", U->CL.A->name] forKey:@"name"];
            [dict setValue:[NSString stringWithFormat:@"%g", U->CL.A->totalD] forKey:@"atk"];
            if(U->CL.A->rangeA != U->CL.A->rangeB){
                [dict setValue:[NSString stringWithFormat:@"%d-%d", U->CL.A->rangeA, U->CL.A->rangeB] forKey:@"range"];
            }else{
                [dict setValue:[NSString stringWithFormat:@"%d", U->CL.A->rangeA] forKey:@"range"];
            }
            [dict setValue:[NSString stringWithFormat:@"%d", U->CL.A->hitPercent] forKey:@"hit"];
            //[dict setValue:[NSString stringWithFormat:@"%d", U->C.A->bulletC] forKey:@"bullet"];
            
            [self willChangeValueForKey:@"CAttackListMA"];
            [CAttackListMA addObject:dict];
            [self didChangeValueForKey:@"CAttackListMA"];
            
            U->CL.A = U->CL.A->next;
        }
        
        U->CL.A = Atop;
        
    }
    U = UTop;
    
    [CAttackListAC setSelectionIndex:crCAL];
    
    [self initCAttackSelect2];




}

-(void)initCAttackList{
    crCAL = 0;
    CAttackListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"CAttackListMA"];
    [CAttackListMA removeAllObjects];
    [self didChangeValueForKey:@"CAttackListMA"];

    U = UTop;
    if(!battleSet2PushedFlag){
        ATTACK *Atop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    Atop = U->C.A;
        for(int i = 0;i < U->C.attackListNum;i++){
            if(!U->C.A) {
                U->C.attackListNum = i;
                break;
            };
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", U->C.A->name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%g", U->C.A->totalD] forKey:@"atk"];
        if(U->C.A->rangeA != U->C.A->rangeB){
            [dict setValue:[NSString stringWithFormat:@"%d-%d", U->C.A->rangeA, U->C.A->rangeB] forKey:@"range"];
        }else{
            [dict setValue:[NSString stringWithFormat:@"%d", U->C.A->rangeA] forKey:@"range"];
        }
        [dict setValue:[NSString stringWithFormat:@"%d", U->C.A->hitPercent] forKey:@"hit"];
        //[dict setValue:[NSString stringWithFormat:@"%d", U->C.A->bulletC] forKey:@"bullet"];
    
        [self willChangeValueForKey:@"CAttackListMA"];
        [CAttackListMA addObject:dict];
        [self didChangeValueForKey:@"CAttackListMA"];
        
        U->C.A = U->C.A->next;
    }
    
    U->C.A = Atop;
    }else{
        
        ATTACK *Atop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        Atop = U->C.A;
        for(int i = 0;i < U->C.attackListNum;i++){
            NSMutableDictionary* dict = [NSMutableDictionary new];
            [dict setValue:[NSString stringWithFormat:@"%@", U->C.A->name] forKey:@"name"];
            [dict setValue:[NSString stringWithFormat:@"%g", U->C.A->totalD] forKey:@"atk"];
            if(U->C.A->rangeA != U->C.A->rangeB){
                [dict setValue:[NSString stringWithFormat:@"%d-%d", U->C.A->rangeA, U->C.A->rangeB] forKey:@"range"];
            }else{
                [dict setValue:[NSString stringWithFormat:@"%d", U->C.A->rangeA] forKey:@"range"];
            }
            [dict setValue:[NSString stringWithFormat:@"%d", U->C.A->hitPercent] forKey:@"hit"];
            //[dict setValue:[NSString stringWithFormat:@"%d", U->C.A->bulletC] forKey:@"bullet"];
            
            [self willChangeValueForKey:@"CAttackListMA"];
            [CAttackListMA addObject:dict];
            [self didChangeValueForKey:@"CAttackListMA"];
            
            U->C.A = U->C.A->next;
        }
        
        U->C.A = Atop;
    
    }
    U = UTop;
    
    [CAttackListAC setSelectionIndex:crCAL];
    
    [self initCAttackSelect];
}

-(void)initBCreateList{
    BCreateListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"BCreateListMA"];
    [BCreateListMA removeAllObjects];
    [self didChangeValueForKey:@"BCreateListMA"];
    buildSkillFlag = false;
    
    U = UTop;
    SKILL *Stop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    Stop = U->C.S;
    if(!U->C.S) {
        U = UTop;
        return;
    }
    while (U->C.S->type != 1 && U->C.S->next) {
        U->C.S = U->C.S->next;
    }
    if(U->C.S->type != 1) {
        U->C.S = Stop;
        U = UTop;
        return;
    }
    for(int i = 0;U->C.S->list[i] > 0;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", BC[U->C.S->list[i]-1].name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"資%d 食%d 金%d",
                        BC[U->C.S->list[i]-1].Csupply, BC[U->C.S->list[i]-1].Cfood, BC[U->C.S->list[i]-1].Cmoney] forKey:@"cost"];
        [dict setValue:BC[U->C.S->list[i]-1].img forKey:@"img"];
        
        [self willChangeValueForKey:@"BCreateListMA"];
        [BCreateListMA addObject:dict];
        [self didChangeValueForKey:@"BCreateListMA"];
        
        buildSkillFlag = true;
    }
    U->C.S = Stop;
    U = UTop;
}

-(void)initCSummonList{
    CSummonListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"CSummonListMA"];
    [CSummonListMA removeAllObjects];
    [self didChangeValueForKey:@"CSummonListMA"];
    
    summonSkillFlag = false;
    
    U = UTop;
    SKILL *Stop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    Stop = U->C.S;
    if(!U->C.S) {
        U = UTop;
        return;
    }
    while (U->C.S->type != 2 && U->C.S->next) {
        U->C.S = U->C.S->next;
    }
    if(U->C.S->type != 2) {
        U->C.S = Stop;
        U = UTop;
        return;
    }
    for(int i = 0;U->C.S->list[i] > 0;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", UC[U->C.S->list[i]-1].nameClass] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%g", UC[U->C.S->list[i]-1].S_M.HP] forKey:@"HP"];
        [dict setValue:[NSString stringWithFormat:@"%g", U->C.S->cost[i]] forKey:@"cost"];
        [dict setValue:UC[U->C.S->list[i]-1].img forKey:@"img"];
        
        [self willChangeValueForKey:@"CSummonListMA"];
        [CSummonListMA addObject:dict];
        [self didChangeValueForKey:@"CSummonListMA"];
        
        summonSkillFlag = true;
    }
    U->C.S = Stop;
    U = UTop;
    
}


-(void)AttackDisplay{

    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    [bplayer1 setImage:U->C.imgb];
    [nplayer1 setStringValue:U->C.name];
    [tplayer1 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
    [lplayer1 setIntValue:U->C.S_C.HP/U->C.S_M.HP*100];
    [iplayer1 setImage:MC[chipNum[U->x][U->y]].img];
    [mplayer1 setStringValue:MC[chipNum[U->x][U->y]].name];
    [rplayer1 setStringValue:[NSString stringWithFormat:@"地形効果 %d％", MC[chipNum[U->x][U->y]].dmgfix]];
    
    U = UTop;
    
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    [bplayer2 setImage:U->C.imgb];
    [nplayer2 setStringValue:U->C.name];
    [tplayer2 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
    [lplayer2 setIntValue:U->C.S_C.HP/U->C.S_M.HP*100];
    [iplayer2 setImage:MC[chipNum[U->x][U->y]].img];
    [mplayer2 setStringValue:MC[chipNum[U->x][U->y]].name];
    [rplayer2 setStringValue:[NSString stringWithFormat:@"地形効果 %d％", MC[chipNum[U->x][U->y]].dmgfix]];
    U = UTop;
    
    [self AttackDisplay2];
    
    messageProcess = 0;
    [battleDialog setStringValue:@"攻撃開始！"];

}

-(void)AttackDisplay2{

    U = UTop;
    
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    
    if(U->chipNumberL >= 0 && U2->chipNumberL >= 0){U = UTop;
    
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        [bplayer1 setImage:U->CL.imgb];
        [nplayer1 setStringValue:U->CL.name];
        [tplayer1 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [lplayer1 setIntValue:U->CL.S_C.HP/U->CL.S_M.HP*100];
        
        U = UTop;
        
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        [bplayer2 setImage:U->CL.imgb];
        [nplayer2 setStringValue:U->CL.name];
        [tplayer2 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [lplayer2 setIntValue:U->CL.S_C.HP/U->CL.S_M.HP*100];
        U = UTop;
    
    
    }else if(U->chipNumberL >= 0 && U2->chipNumberL < 0){U = UTop;
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        [bplayer1 setImage:U->CL.imgb];
        [nplayer1 setStringValue:U->CL.name];
        [tplayer1 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [lplayer1 setIntValue:U->CL.S_C.HP/U->CL.S_M.HP*100];
        
        U = UTop;
        
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        [bplayer2 setImage:U->C.imgb];
        [nplayer2 setStringValue:U->C.name];
        [tplayer2 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [lplayer2 setIntValue:U->C.S_C.HP/U->C.S_M.HP*100];
        U = UTop;
        
        
        
        
    }else if(U->chipNumberL < 0 && U2->chipNumberL >= 0){U = UTop;
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        [bplayer1 setImage:U->C.imgb];
        [nplayer1 setStringValue:U->C.name];
        [tplayer1 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [lplayer1 setIntValue:U->C.S_C.HP/U->C.S_M.HP*100];
        
        U = UTop;
        
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        [bplayer2 setImage:U->CL.imgb];
        [nplayer2 setStringValue:U->CL.name];
        [tplayer2 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [lplayer2 setIntValue:U->CL.S_C.HP/U->CL.S_M.HP*100];
        U = UTop;
    }


    U = UTop;
}

-(void)setBattlePanel{
    
    U = UTop;
    
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(U->chipNumberL >= 0 && U2->chipNumberL >= 0){
        U = UTop;
        [self setBattlePanelT2];
        return;
    }else if(U->chipNumberL >= 0 && U2->chipNumberL <= 0){
        U = UTop;
        [self setBattlePanelT3];
        return;
    }else if(U->chipNumberL <= 0 && U2->chipNumberL >= 0){
        U = UTop;
        [self setBattlePanelT4];
        return;
    }
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(cpuModeBATTLEflag && (MF[MFselectedRow+1].MS.playerSet1 == 2 || MF[MFselectedRow+1].MS.playerSet2 == 2)){
        cpuModeBATTLEflag = false;
        crCAL1 = 0;
    int mostDmg = 0;
    int mostDmg2 = 0;
    int mostHit = 0;
    int mostNum = 0;
    int num = 0;
    ATTACK *aTop2 = U->C.A;
    int mpCost = 0;
    if(U->C.A)
        if(!U->C.A->D){
            U->C.A = NULL;
            aTop2 = U->C.A;
        }
        
        double urSupposedToGet;
        
        urSupposedToGet = pow(8, log(3+U->C.A->totalD/16));
    
    double oopsIsRight = 0;
    
    if(U->C.A){
        if(U->C.A->melee){
            oopsIsRight = U->C.S_C.MEL;
        }else
            oopsIsRight = U->C.S_C.MIS;
    }
    oopsIsRight = oopsIsRight/100;
    
    
    while(U->C.A){
        mpCost = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
        
        if(!U2->C.aura){
            if(U->C.A->D->type == 0) mostDmg2 = (U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF;
            if(U->C.A->D->type == 1) mostDmg2 = (U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK;
            if(U->C.A->D->type == 2) mostDmg2 = (U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA;
            if(U->C.A->D->type == 3) mostDmg2 = (U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU;
            if(U->C.A->D->type == 4) mostDmg2 = (U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP;
            if(U->C.A->D->type == 5) mostDmg2 = U->C.A->totalD;
        }else{
            double val = val = 1/log(3+U2->C.S_C.MP/64);
            if(U->C.A->D->type == 0) mostDmg2 = ((U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF)*val;
            if(U->C.A->D->type == 1) mostDmg2 = ((U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK)*val;
            if(U->C.A->D->type == 2) mostDmg2 = ((U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA)*val;
            if(U->C.A->D->type == 3) mostDmg2 = ((U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU)*val;
            if(U->C.A->D->type == 4) mostDmg2 = ((U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP)*val;
            if(U->C.A->D->type == 5) mostDmg2 = U->C.A->totalD*val;
        }
        double val2 = log(3+U2->C.S_C.MP/64);
        if(U->C.aura){
            dmg = dmg*val2;
        }
        
        U2A = U->C.A;
        
        UNIT *oops = U;
        U = U2;
        mostDmg2 = [self dmgResist:mostDmg2];
        if(mostDmg2 < 0) mostDmg2 = 1;
        U = oops;
        if(mostDmg < mostDmg2 && U->C.A->rangeA <= unitBreak->atkRange && U->C.A->rangeB >= unitBreak->atkRange && mpCost <= U->C.S_C.MP && U->C.A->D->sort != 1){
            
            mostDmg = mostDmg2;
            
            //mostDmg = U->C.A->totalD;
            mostNum = num;
        }
        if(mostHit < U->C.A->hitPercent && hit < 50 && mostDmg/2 < mostDmg2 && U->C.A->rangeA <= unitBreak->atkRange && U->C.A->rangeB >= unitBreak->atkRange && mpCost <= U->C.S_C.MP && U->C.A->D->sort != 1){
            //mostDmg = U->C.A->totalD;
            mostHit = U->C.A->hitPercent;
            mostNum = num;
        }
        U->C.A = U->C.A->next;
        num++;
    }
    
    U->C.A = aTop2;
    if(U->C.A){
        mostNumSub = mostNum;
        
        for(int i = 0;i < mostNum;i++){
            U->C.A = U->C.A->next;
            crCAL1++;
        }
        mpCost = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
        
        if(U->C.A->rangeA <= unitBreak->atkRange && U->C.A->rangeB >= unitBreak->atkRange && mpCost <= U->C.S_C.MP){
            
        }else while(U->C.A){
            U->C.A = U->C.A->next;
            crCAL1++;
        }
        
    }U->C.A = aTop2;
    }
    U = UTop;

    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    ATTACK *aTop = U->C.A;
    ATTACK *u2A;
    
    if(!U->C.A)
        crCAL1 = crCAL;
    
    for(int i = 0;i < crCAL1;i++){
        U->C.A = U->C.A->next;
    }
    
    if(battleSet1Flag){
    
        U->C.A = aTop;
        for (int i = 0;i < crCAL1;i++) {
            U->C.A = U->C.A->next;
        }
        
    }
    
    [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
    [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
    [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
    [combatATK1 setStringValue:[NSString stringWithFormat:@"%@", U->C.A->name]];
    [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
    [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
    double oops = U->C.S_C.HP/U->C.S_M.HP*100;
    [combatLHP1 setIntValue:(int)oops];
    oops = U->C.S_C.MP/U->C.S_M.MP*100;
    [combatLMP1 setIntValue:(int)oops];
    
    hit = U->C.S_C.ACU*U->C.S_C.HIT/100;
    hitFix = U->C.A->hitPercent;
    
    u2A = U->C.A;
    U->C.A = aTop;
    
    if(battleDef1Flag){
        [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
        [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
        [combatATK1 setStringValue:[NSString stringWithFormat:@"防御耐性"]];
        [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    if(battleDod1Flag){
        [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
        [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
        [combatATK1 setStringValue:[NSString stringWithFormat:@"回避耐性"]];
        [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];

    }
    
    
    
    
    
    
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    
    double hit2 = U->C.S_C.EVA*U->C.S_C.DOD/100;
    
    double hi = U->C.S_C.LUK - U2->C.S_C.LUK;
    if(hi < 0) hi = 0;
    
    hit = 60 + hit/hit2*10 - hit2/hit*10 + hitFix - log(hi+1)*hit2/hit*10;

    if(battleDod2Flag) hit = hit / 2;
    hit = floor(hit);
    
    if(hit > 100) hit = 100;
    if(hit < 0) hit = 0;
    
    if(u2A->D->sort == 1){
        hit = 100;
    }
    [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　%g", hit]];
    if(battleDef1Flag || battleDod1Flag) [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    
    
    
    int mostDmg = 0;
    int mostDmg2 = 0;
    int mostHit = 0;
    int mostNum = 0;
    int num = 0;
    ATTACK *aTop2 = U->C.A;
    int mpCost = 0;
    
    
    double urSupposedToGet;
    
    urSupposedToGet = pow(8, log(3+U->C.A->totalD/16));
    
    double oopsIsRight = 0;
    
    if(U->C.A){
        if(U->C.A->melee){
            oopsIsRight = U->C.S_C.MEL;
        }else
            oopsIsRight = U->C.S_C.MIS;
    }
    oopsIsRight = oopsIsRight/100;

    
    while(U->C.A){
        mpCost = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
        
        if(!U2->C.aura){
            if(U->C.A->D->type == 0) mostDmg2 = (U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF;
            if(U->C.A->D->type == 1) mostDmg2 = (U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK;
            if(U->C.A->D->type == 2) mostDmg2 = (U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA;
            if(U->C.A->D->type == 3) mostDmg2 = (U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU;
            if(U->C.A->D->type == 4) mostDmg2 = (U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP;
            if(U->C.A->D->type == 5) mostDmg2 = U->C.A->totalD;
        }else{
            double val = val = 1/log(3+U2->C.S_C.MP/64);
            if(U->C.A->D->type == 0) mostDmg2 = ((U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF)*val;
            if(U->C.A->D->type == 1) mostDmg2 = ((U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK)*val;
            if(U->C.A->D->type == 2) mostDmg2 = ((U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA)*val;
            if(U->C.A->D->type == 3) mostDmg2 = ((U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU)*val;
            if(U->C.A->D->type == 4) mostDmg2 = ((U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP)*val;
            if(U->C.A->D->type == 5) mostDmg2 = U->C.A->totalD*val;
        }
        double val2 = log(3+U2->C.S_C.MP/64);
        if(U->C.aura){
            dmg = dmg*val2;
        }
        
        U2A = U->C.A;
        
        UNIT *oops = U;
        U = U2;
        mostDmg2 = [self dmgResist:mostDmg2];
        U = oops;
        if(mostDmg < mostDmg2 && U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && mpCost <= U->C.S_C.MP && U->C.A->D->sort != 1){
            
            mostDmg = mostDmg2;
            
            //mostDmg = U->C.A->totalD;
            mostNum = num;
        }
        if(mostHit < U->C.A->hitPercent && hit < 50 && mostDmg/2 < mostDmg2 && U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && mpCost <= U->C.S_C.MP && U->C.A->D->sort != 1){
            //mostDmg = U->C.A->totalD;
            mostHit = U->C.A->hitPercent;
            mostNum = num;
        }
        U->C.A = U->C.A->next;
        num++;
    }
    
    U->C.A = aTop2;
    if(U->C.A){
    mostNumSub = mostNum;
    
    for(int i = 0;i < mostNum;i++){
        U->C.A = U->C.A->next;
    }
    mpCost = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
    
    if(U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && mpCost <= U->C.S_C.MP){
        
    }else while(U->C.A){
        U->C.A = U->C.A->next;
    }
    
    }
    
    if(battleSet2Flag){
    
            U->C.A = aTop2;
        
        for (int i = 0;i < crCAL2;i++) {
            U->C.A = U->C.A->next;
        }
    
    }
    
    
    [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
    [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
    [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
    [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
    [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
    double oops2 = U->C.S_C.HP/U->C.S_M.HP*100;
    [combatLHP2 setIntValue:(int)oops2];
    oops2 = U->C.S_C.MP/U->C.S_M.MP*100;
    [combatLMP2 setIntValue:(int)oops2];
    
    bool counter;
    int mpCost2 = 0;
    if(U->C.A){
        mpCost2 = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
        
    }
    if(U->C.A && !(u2A->D->sort == 1) && U->C.A->D->sort != 1 && mpCost2 <= U->C.S_C.MP){
        [combatATK2 setStringValue:[NSString stringWithFormat:@"%@", U->C.A->name]];
        hit = U->C.S_C.ACU*U->C.S_C.HIT/100;
        hitFix = U->C.A->hitPercent;
        counter = true;
    }else if(u2A->D->sort == 1 || !U->C.A || U->C.A->D->sort == 1){
        [combatATK2 setStringValue:[NSString stringWithFormat:@"反撃不可能"]];
    }
    
    U->C.A = aTop2;
    
    if(battleDef2Flag){
        [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
        [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
        [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatATK2 setStringValue:[NSString stringWithFormat:@"防御態勢"]];
        [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    
    if(battleDod2Flag){
        [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
        [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
        [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatATK2 setStringValue:[NSString stringWithFormat:@"回避耐性"]];
        [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(counter){
        
        double hit2 = U->C.S_C.EVA*U->C.S_C.DOD/100;
        
        
        double hi = U->C.S_C.LUK - U2->C.S_C.LUK;
        if(hi < 0) hi = 0;
        
        hit = 60 + hit/hit2*10 - hit2/hit*10 + hitFix - log(hi+1)*hit2/hit*10;
        if(battleDod1Flag) hit /= 2;
        hit = floor(hit);
        
        if(hit > 100) hit = 100;
        if(hit < 0) hit = 0;
        
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　%g", hit]];
        if(battleDef2Flag || battleDod2Flag) [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }else{
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    
    U = UTop;
    
    if(CPUAttackSubmitFlag){
        if(unitCPUAttackFlag){
            [battleCancelBtn setEnabled:NO];
            [battleCancelBtn setTransparent:YES];
        }else{
            [battleCancelBtn setEnabled:YES];
            [battleCancelBtn setTransparent:NO];
        }
    }
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(U->CPU){
        [battleAttackBtn1 setEnabled:NO];
        [battleAttackBtn1 setTransparent:YES];
        [battleGuardBtn1 setEnabled:NO];
        [battleGuardBtn1 setTransparent:YES];
        [battleDodgeBtn1 setEnabled:NO];
        [battleDodgeBtn1 setTransparent:YES];
    }else{
        [battleAttackBtn1 setEnabled:YES];
        [battleAttackBtn1 setTransparent:NO];
        [battleGuardBtn1 setEnabled:YES];
        [battleGuardBtn1 setTransparent:NO];
        [battleDodgeBtn1 setEnabled:YES];
        [battleDodgeBtn1 setTransparent:NO];
    }U = UTop;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    if(U->CPU){
        [battleAttackBtn2 setEnabled:NO];
        [battleAttackBtn2 setTransparent:YES];
        [battleGuardBtn2 setEnabled:NO];
        [battleGuardBtn2 setTransparent:YES];
        [battleDodgeBtn2 setEnabled:NO];
        [battleDodgeBtn2 setTransparent:YES];
    }else{
        [battleAttackBtn2 setEnabled:YES];
        [battleAttackBtn2 setTransparent:NO];
        [battleGuardBtn2 setEnabled:YES];
        [battleGuardBtn2 setTransparent:NO];
        [battleDodgeBtn2 setEnabled:YES];
        [battleDodgeBtn2 setTransparent:NO];
    }U = UTop;

    if(MF[MFselectedRow+1].MS.playerSet1 == 2 && MF[MFselectedRow+1].MS.playerSet2 == 2){
        [battleStartBtn setEnabled:NO];
        [battleStartBtn setTransparent:YES];
    }else{
        [battleStartBtn setEnabled:YES];
        [battleStartBtn setTransparent:NO];
    }
}

-(void)setBattlePanelT2{
    
    U = UTop;
    
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(cpuModeBATTLEflag && (MF[MFselectedRow+1].MS.playerSet1 == 2 || MF[MFselectedRow+1].MS.playerSet2 == 2)){
        cpuModeBATTLEflag = false;
        crCAL1 = 0;
    int mostDmg = 0;
    int mostHit = 0;
    int mostNum = -1;
    int num = 0;
    ATTACK *aTop2 = U->CL.A;
    int mpCost = 0;
    while(U->CL.A){
        mpCost = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
        if(mostDmg < U->CL.A->totalD && U->CL.A->rangeA <= unitBreak->atkRange && U->CL.A->rangeB >= unitBreak->atkRange && mpCost <= U->CL.S_C.EN && U->CL.A->D->sort != 1){
            mostDmg = U->CL.A->totalD;
            mostNum = num;
        }
        if(mostHit < U->CL.A->hitPercent && mostDmg/2 < U->CL.A->totalD && U->CL.A->rangeA <= unitBreak->atkRange && U->CL.A->rangeB >= unitBreak->atkRange && mpCost <= U->CL.S_C.EN && U->CL.A->D->sort != 1){
            //mostDmg = U->C.A->totalD;
            mostHit = U->CL.A->hitPercent;
            mostNum = num;
        }
        U->CL.A = U->CL.A->next;
        num++;
    }
    
    U->CL.A = aTop2;
    
    mostNumSub = mostNum;
    
    if(mostNum >= 0){
        for(int i = 0;i < mostNum;i++){
            U->CL.A = U->CL.A->next;
            crCAL1++;
        }
    }else{
        
        U->CL.A = NULL;
    }
    if(U->CL.A)
        mpCost = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
    if(U->CL.A){
        if(U->CL.A->rangeA <= unitBreak->atkRange && U->CL.A->rangeB >= unitBreak->atkRange && mpCost <= U->CL.S_C.EN){
            
        }else while(U->CL.A){
            U->CL.A = U->CL.A->next;
            crCAL1++;
        }
    }U->CL.A = aTop2;
    
    }
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    ATTACK *aTop = U->CL.A;
    ATTACK *u2A;
    
    if(!U->C.A)
        crCAL1 = crCAL;
    
    for(int i = 0;i < crCAL1;i++){
        U->CL.A = U->CL.A->next;
    }

    
    if(battleSet1Flag){
        
        U->CL.A = aTop;
        for (int i = 0;i < crCAL1;i++) {
            U->CL.A = U->CL.A->next;
        }
        
    }
    
    [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
    [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
    [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
    [combatATK1 setStringValue:[NSString stringWithFormat:@"%@", U->CL.A->name]];
    [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
    [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
    double oops = U->CL.S_C.HP/U->CL.S_M.HP*100;
    [combatLHP1 setIntValue:(int)oops];
    oops = U->CL.S_C.EN/U->CL.S_M.EN*100;
    [combatLMP1 setIntValue:(int)oops];
    
    hit = U->CL.S_C.MOB + U->C.S_C.HIT;
    hitFix = U->CL.A->hitPercent;
    
    u2A = U->CL.A;
    U->CL.A = aTop;
    
    if(battleDef1Flag){
        [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
        [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
        [combatATK1 setStringValue:[NSString stringWithFormat:@"防御耐性"]];
        [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    if(battleDod1Flag){
        [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
        [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
        [combatATK1 setStringValue:[NSString stringWithFormat:@"回避耐性"]];
        [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }
    
    
    
    
    
    
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    
    hit = 60 + hit/(U->CL.S_C.MOB*U->C.S_C.DOD/100)*10 - (U->CL.S_C.MOB*U->C.S_C.DOD/100)/hit*10 + hitFix;
    if(battleDod2Flag) hit = hit / 2;
    hit = floor(hit);
    
    if(hit > 100) hit = 100;
    if(hit < 0) hit = 0;
    
    if(u2A->D->sort == 1){
        hit = 100;
    }
    [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　%g", hit]];
    if(battleDef1Flag || battleDod1Flag) [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    
    
    
    int mostDmg = 0;
    int mostHit = 0;
    int mostNum = -1;
    int num = 0;
    ATTACK *aTop2 = U->CL.A;
    int mpCost = 0;
    while(U->CL.A){
        mpCost = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
        if(mostDmg < U->CL.A->totalD && U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && mpCost <= U->CL.S_C.EN && U->CL.A->D->sort != 1){
            mostDmg = U->CL.A->totalD;
            mostNum = num;
        }
        if(mostHit < U->CL.A->hitPercent && mostDmg/2 < U->CL.A->totalD && U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && mpCost <= U->CL.S_C.EN && U->CL.A->D->sort != 1){
            //mostDmg = U->C.A->totalD;
            mostHit = U->CL.A->hitPercent;
            mostNum = num;
        }
        U->CL.A = U->CL.A->next;
        num++;
    }
    
    U->CL.A = aTop2;
    
    mostNumSub = mostNum;
    
    if(mostNum >= 0){
    for(int i = 0;i < mostNum;i++){
        U->CL.A = U->CL.A->next;
    }
    }else{
    
        U->CL.A = NULL;
    }
    if(U->CL.A)
    mpCost = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
    if(U->CL.A){
    if(U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && mpCost <= U->CL.S_C.EN){
        
    }else while(U->CL.A){
        U->CL.A = U->CL.A->next;
    }
    }
    
    
    
    if(battleSet2Flag){
        
        U->CL.A = aTop2;
        
        for (int i = 0;i < crCAL2;i++) {
            U->CL.A = U->CL.A->next;
        }
        
    }
    
    
    [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
    [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
    [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
    [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
    [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
    double oops2 = U->CL.S_C.HP/U->CL.S_M.HP*100;
    [combatLHP2 setIntValue:(int)oops2];
    oops2 = U->CL.S_C.EN/U->CL.S_M.EN*100;
    [combatLMP2 setIntValue:(int)oops2];
    
    bool counter;
    int mpCost2 = 0;
    if(U->CL.A){
    if(U->CL.A->name){
        
    if(U->CL.A){
        mpCost2 = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
        
    }
    if(U->CL.A && !(u2A->D->sort == 1) && U->CL.A->D->sort != 1 && mpCost2 <= U->CL.S_C.EN){
        [combatATK2 setStringValue:[NSString stringWithFormat:@"%@", U->CL.A->name]];
        hit = U->CL.S_C.MOB + U->C.S_C.HIT;
        hitFix = U->CL.A->hitPercent;
        counter = true;
    }else if(u2A->D->sort == 1 || !U->CL.A || U->CL.A->D->sort == 1){
        [combatATK2 setStringValue:[NSString stringWithFormat:@"反撃不可能"]];
    }
    
    }else{
        [combatATK2 setStringValue:[NSString stringWithFormat:@"反撃不可能"]];
    }
    }else{
        [combatATK2 setStringValue:[NSString stringWithFormat:@"反撃不可能"]];
    }
    U->CL.A = aTop2;
    
    if(battleDef2Flag){
        [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
        [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
        [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatATK2 setStringValue:[NSString stringWithFormat:@"防御態勢"]];
        [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    
    if(battleDod2Flag){
        [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
        [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
        [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatATK2 setStringValue:[NSString stringWithFormat:@"回避耐性"]];
        [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(counter){
        hit = 60 + hit/(U->CL.S_C.MOB*U->C.S_C.DOD/100)*10 - (U->CL.S_C.MOB*U->C.S_C.DOD/100)/hit*10 + hitFix;
        if(battleDod1Flag) hit /= 2;
        hit = floor(hit);
        
        if(hit > 100) hit = 100;
        if(hit < 0) hit = 0;
        
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　%g", hit]];
        if(battleDef2Flag || battleDod2Flag) [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }else{
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    
    U = UTop;
}

-(void)setBattlePanelT3{
    
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(cpuModeBATTLEflag && (MF[MFselectedRow+1].MS.playerSet1 == 2 &&MF[MFselectedRow+1].MS.playerSet2 == 2)){
        cpuModeBATTLEflag = false;
        crCAL1 = 0;
    int mostDmg = 0;
    int mostHit = 0;
    int mostNum = 0;
    int num = 0;
    ATTACK *aTop2 = U->C.A;
    int mpCost = 0;
    while(U->C.A){
        mpCost = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
        if(mostDmg < U->C.A->totalD && U->C.A->rangeA <= unitBreak->atkRange && U->C.A->rangeB >= unitBreak->atkRange && mpCost <= U->C.S_C.MP && U->C.A->D->sort != 1){
            mostDmg = U->C.A->totalD;
            mostNum = num;
        }
        if(mostHit < U->C.A->hitPercent && mostDmg/2 < U->C.A->totalD && U->C.A->rangeA <= unitBreak->atkRange && U->C.A->rangeB >= unitBreak->atkRange && mpCost <= U->C.S_C.MP && U->C.A->D->sort != 1){
            //mostDmg = U->C.A->totalD;
            mostHit = U->C.A->hitPercent;
            mostNum = num;
        }
        U->C.A = U->C.A->next;
        num++;
    }
    
    U->C.A = aTop2;
    
    mostNumSub = mostNum;
    
    for(int i = 0;i < mostNum;i++){
        U->C.A = U->C.A->next;
        crCAL1++;
    }
    mpCost = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
    
    if(U->C.A->rangeA <= unitBreak->atkRange && U->C.A->rangeB >= unitBreak->atkRange && mpCost <= U->C.S_C.MP){
        
    }else while(U->C.A){
        U->C.A = U->C.A->next;
        crCAL1++;
        
    }
      U->C.A = aTop2;
    }
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    
    ATTACK *aTop = U->CL.A;
    ATTACK *u2A;
    
    if(!U->C.A)
        crCAL1 = crCAL;
    
    for(int i = 0;i < crCAL1;i++){
        U->CL.A = U->CL.A->next;
    }
    
    if(battleSet1Flag){
        
        U->CL.A = aTop;
        for (int i = 0;i < crCAL1;i++) {
            U->CL.A = U->CL.A->next;
        }
        
    }
    
    [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
    [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
    [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
    [combatATK1 setStringValue:[NSString stringWithFormat:@"%@", U->CL.A->name]];
    [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
    [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
    double oops = U->CL.S_C.HP/U->CL.S_M.HP*100;
    [combatLHP1 setIntValue:(int)oops];
    oops = U->CL.S_C.EN/U->CL.S_M.EN*100;
    [combatLMP1 setIntValue:(int)oops];
    
    hit = U->CL.S_C.MOB + U->C.S_C.HIT;
    hitFix = U->CL.A->hitPercent;
    
    u2A = U->CL.A;
    U->CL.A = aTop;
    
    if(battleDef1Flag){
        [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
        [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
        [combatATK1 setStringValue:[NSString stringWithFormat:@"防御耐性"]];
        [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    if(battleDod1Flag){
        [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
        [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
        [combatATK1 setStringValue:[NSString stringWithFormat:@"回避耐性"]];
        [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }
    
    
    
    
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    
    double hit2 = U->C.S_C.EVA*U->C.S_C.DOD/100;
    
    double hi = U->C.S_C.LUK - U2->C.S_C.LUK;
    if(hi < 0) hi = 0;
    
    hit = 60 + hit/hit2*10 - hit2/hit*10 + hitFix - log(hi+1)*hit2/hit*10;
    if(battleDod2Flag) hit = hit / 2;
    hit = floor(hit);
    
    if(hit > 100) hit = 100;
    if(hit < 0) hit = 0;
    
    if(u2A->D->sort == 1){
        hit = 100;
    }
    [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　%g", hit]];
    if(battleDef1Flag || battleDod1Flag) [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    
    
    
    int mostDmg = 0;
    int mostHit = 0;
    int mostNum = 0;
    int num = 0;
    ATTACK *aTop2 = U->C.A;
    int mpCost = 0;
    while(U->C.A){
        mpCost = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
        if(mostDmg < U->C.A->totalD && U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && mpCost <= U->C.S_C.MP && U->C.A->D->sort != 1){
            mostDmg = U->C.A->totalD;
            mostNum = num;
        }
        if(mostHit < U->C.A->hitPercent && mostDmg/2 < U->C.A->totalD && U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && mpCost <= U->C.S_C.MP && U->C.A->D->sort != 1){
            //mostDmg = U->C.A->totalD;
            mostHit = U->C.A->hitPercent;
            mostNum = num;
        }
        U->C.A = U->C.A->next;
        num++;
    }
    
    U->C.A = aTop2;
    
    mostNumSub = mostNum;
    
    for(int i = 0;i < mostNum;i++){
        U->C.A = U->C.A->next;
    }
    mpCost = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
    
    if(U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && mpCost <= U->C.S_C.MP){
        
    }else while(U->C.A){
        U->C.A = U->C.A->next;
    }
    
    
    if(battleSet2Flag){
        
        U->C.A = aTop2;
        
        for (int i = 0;i < crCAL2;i++) {
            U->C.A = U->C.A->next;
        }
        
    }
    
    
    [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
    [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
    [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
    [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
    [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
    double oops2 = U->C.S_C.HP/U->C.S_M.HP*100;
    [combatLHP2 setIntValue:(int)oops2];
    oops2 = U->C.S_C.MP/U->C.S_M.MP*100;
    [combatLMP2 setIntValue:(int)oops2];
    
    bool counter;
    int mpCost2 = 0;
    if(U->C.A){
        mpCost2 = U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5;
        
    }
    if(U->C.A && !(u2A->D->sort == 1) && U->C.A->D->sort != 1 && mpCost2 <= U->C.S_C.MP){
        [combatATK2 setStringValue:[NSString stringWithFormat:@"%@", U->C.A->name]];
        hit = U->C.S_C.ACU*U->C.S_C.HIT/100;
        hitFix = U->C.A->hitPercent;
        counter = true;
    }else if(u2A->D->sort == 1 || !U->C.A || U->C.A->D->sort == 1){
        [combatATK2 setStringValue:[NSString stringWithFormat:@"反撃不可能"]];
    }
    
    U->C.A = aTop2;
    
    if(battleDef2Flag){
        [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
        [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
        [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatATK2 setStringValue:[NSString stringWithFormat:@"防御態勢"]];
        [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    
    if(battleDod2Flag){
        [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
        [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
        [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatATK2 setStringValue:[NSString stringWithFormat:@"回避耐性"]];
        [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(counter){
        hit = 60 + hit/(U->CL.S_C.MOB*U->C.S_C.DOD/100)*10 - (U->CL.S_C.MOB*U->C.S_C.DOD/100)/hit*10 + hitFix;
        if(battleDod1Flag) hit /= 2;
        hit = floor(hit);
        
        if(hit > 100) hit = 100;
        if(hit < 0) hit = 0;
        
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　%g", hit]];
        if(battleDef2Flag || battleDod2Flag) [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }else{
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    
    U = UTop;
}

-(void)setBattlePanelT4{

    U = UTop;
    
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(cpuModeBATTLEflag && (MF[MFselectedRow+1].MS.playerSet1 == 2 && MF[MFselectedRow+1].MS.playerSet2 == 2)){
        cpuModeBATTLEflag = false;
        crCAL1 = 0;
    int mostDmg = 0;
    int mostHit = 0;
    int mostNum = 0;
    int num = 0;
    ATTACK *aTop2 = U->CL.A;
    int mpCost = 0;
    while(U->CL.A){
        mpCost = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
        if(mostDmg < U->CL.A->totalD && U->CL.A->rangeA <= unitBreak->atkRange && U->CL.A->rangeB >= unitBreak->atkRange && mpCost <= U->CL.S_C.EN && U->CL.A->D->sort != 1){
            mostDmg = U->CL.A->totalD;
            mostNum = num;
        }
        if(mostHit < U->CL.A->hitPercent && mostDmg/2 < U->CL.A->totalD && U->CL.A->rangeA <= unitBreak->atkRange && U->CL.A->rangeB >= unitBreak->atkRange && mpCost <= U->CL.S_C.EN && U->CL.A->D->sort != 1){
            //mostDmg = U->C.A->totalD;
            mostHit = U->CL.A->hitPercent;
            mostNum = num;
        }
        U->CL.A = U->CL.A->next;
        num++;
    }
    
    mostNumSub = mostNum;
    
    U->CL.A = aTop2;
    
    for(int i = 0;i < mostNum;i++){
        U->CL.A = U->CL.A->next;
        crCAL1++;
    }
    mpCost = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
    
    if(U->CL.A->rangeA <= unitBreak->atkRange && U->CL.A->rangeB >= unitBreak->atkRange && mpCost <= U->CL.S_C.EN){
        
    }else while(U->CL.A){
        U->CL.A = U->CL.A->next;
        crCAL1++;
    }
      U->CL.A = aTop2;
    }
    U = UTop;
    
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    ATTACK *aTop = U->C.A;
    ATTACK *u2A;
    
    if(!U->C.A)
        crCAL1 = crCAL;
    
    for(int i = 0;i < crCAL1;i++){
        U->C.A = U->C.A->next;
    }
    
    if(battleSet1Flag){
        
        U->C.A = aTop;
        for (int i = 0;i < crCAL1;i++) {
            U->C.A = U->C.A->next;
        }
        
    }
    
    [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
    [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
    [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
    [combatATK1 setStringValue:[NSString stringWithFormat:@"%@", U->C.A->name]];
    [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
    [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
    double oops = U->C.S_C.HP/U->C.S_M.HP*100;
    [combatLHP1 setIntValue:(int)oops];
    oops = U->C.S_C.MP/U->C.S_M.MP*100;
    [combatLMP1 setIntValue:(int)oops];
    
    hit = U->C.S_C.ACU*U->C.S_C.HIT/100;
    hitFix = U->C.A->hitPercent;
    
    u2A = U->C.A;
    U->C.A = aTop;
    
    if(battleDef1Flag){
        [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
        [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
        [combatATK1 setStringValue:[NSString stringWithFormat:@"防御耐性"]];
        [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    if(battleDod1Flag){
        [combatNAME1 setStringValue:[NSString stringWithFormat:@"%@", U->C.name]];
        [combatHP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [combatMP1 setStringValue:[NSString stringWithFormat:@"%g/%g", U->C.S_C.MP, U->C.S_M.MP]];
        [combatATK1 setStringValue:[NSString stringWithFormat:@"回避耐性"]];
        [combatVIG1 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatAP1 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }
    
    
    
    
    
    
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    
    hit = 60 + hit/(U->CL.S_C.MOB*U->C.S_C.DOD/100)*10 - (U->CL.S_C.MOB*U->C.S_C.DOD/100)/hit*10 + hitFix;
    if(battleDod2Flag) hit = hit / 2;
    hit = floor(hit);
    
    if(hit > 100) hit = 100;
    if(hit < 0) hit = 0;
    
    if(u2A->D->sort == 1){
        hit = 100;
    }
    [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　%g", hit]];
    if(battleDef1Flag || battleDod1Flag) [combatHIT1 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    
    
    
    int mostDmg = 0;
    int mostHit = 0;
    int mostNum = 0;
    int num = 0;
    ATTACK *aTop2 = U->CL.A;
    int mpCost = 0;
    while(U->CL.A){
        mpCost = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
        if(mostDmg < U->CL.A->totalD && U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && mpCost <= U->CL.S_C.EN && U->CL.A->D->sort != 1){
            mostDmg = U->CL.A->totalD;
            mostNum = num;
        }
        if(mostHit < U->CL.A->hitPercent && mostDmg/2 < U->CL.A->totalD && U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && mpCost <= U->CL.S_C.EN && U->CL.A->D->sort != 1){
            //mostDmg = U->C.A->totalD;
            mostHit = U->CL.A->hitPercent;
            mostNum = num;
        }
        U->CL.A = U->CL.A->next;
        num++;
    }
    
    mostNumSub = mostNum;
    
    U->CL.A = aTop2;
    
    for(int i = 0;i < mostNum;i++){
        U->CL.A = U->CL.A->next;
    }
    mpCost = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
    
    if(U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && mpCost <= U->CL.S_C.EN){
        
    }else while(U->CL.A){
        U->CL.A = U->CL.A->next;
    }
    
    
    if(battleSet2Flag){
        
        U->CL.A = aTop2;
        
        for (int i = 0;i < crCAL2;i++) {
            U->CL.A = U->CL.A->next;
        }
        
    }
    
    
    [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
    [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
    [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
    [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
    [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
    double oops2 = U->CL.S_C.HP/U->CL.S_M.HP*100;
    [combatLHP2 setIntValue:(int)oops2];
    oops2 = U->CL.S_C.EN/U->CL.S_M.EN*100;
    [combatLMP2 setIntValue:(int)oops2];
    
    bool counter;
    int mpCost2 = 0;
    if(U->CL.A){
        mpCost2 = U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5;
        
    }
    if(U->CL.A && !(u2A->D->sort == 1) && U->CL.A->D->sort != 1 && mpCost2 <= U->CL.S_C.EN){
        [combatATK2 setStringValue:[NSString stringWithFormat:@"%@", U->CL.A->name]];
        hit = U->CL.S_C.MOB + U->C.S_C.HIT;
        hitFix = U->CL.A->hitPercent;
        counter = true;
    }else if(u2A->D->sort == 1 || !U->CL.A || U->CL.A->D->sort == 1){
        [combatATK2 setStringValue:[NSString stringWithFormat:@"反撃不可能"]];
    }
    
    U->CL.A = aTop2;
    
    if(battleDef2Flag){
        [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
        [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
        [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatATK2 setStringValue:[NSString stringWithFormat:@"防御態勢"]];
        [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    
    if(battleDod2Flag){
        [combatNAME2 setStringValue:[NSString stringWithFormat:@"%@", U->CL.name]];
        [combatHP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [combatMP2 setStringValue:[NSString stringWithFormat:@"%g/%g", U->CL.S_C.EN, U->CL.S_M.EN]];
        [combatVIG2 setStringValue:[NSString stringWithFormat:@"気力　%d", U->C.S_C.vigor]];
        [combatATK2 setStringValue:[NSString stringWithFormat:@"回避耐性"]];
        [combatAP2 setStringValue:[NSString stringWithFormat:@"%g", U->C.S_C.AP]];
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    if(counter){
        
        double hit2 = U->C.S_C.EVA*U->C.S_C.DOD/100;
        
        double hi = U->C.S_C.LUK - U2->C.S_C.LUK;
        if(hi < 0) hi = 0;
        
        hit = 60 + hit/hit2*10 - hit2/hit*10 + hitFix - log(hi+1)*hit2/hit*10;
        if(battleDod1Flag) hit /= 2;
        hit = floor(hit);
        
        if(hit > 100) hit = 100;
        if(hit < 0) hit = 0;
        
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　%g", hit]];
        if(battleDef2Flag || battleDod2Flag) [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
        
    }else{
        [combatHIT2 setStringValue:[NSString stringWithFormat:@"命中率　----"]];
    }
    
    U = UTop;
}

-(void)DisplayMessage{
    
    double def2 = (double)31/32;
    NSString *message = @"";
    
    enum{
        RIKU,
        UMI,
        CHU,
        SORA
    };
    
    enum{
        A,
        B,
        C,
        D,
        E,
        S,
        SS
    };
    
    switch (messageProcess) {
        case 0:
            if(bLoopFlag) break;
            
            [battleDialog setStringValue:@"攻撃開始！"];
            bLoopFlag = true;
            messageProcess++;
            break;
        case 1:
            
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
            U2 = U;
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            
            if(U->chipNumberL >= 0 && U2->chipNumberL >= 0){
                U = UTop;
                [self DisplayMessageMod1A];
                return;
            }else if(U->chipNumberL >= 0 && U2->chipNumberL < 0){
                U = UTop;
                [self DisplayMessageMod2A];
                return;
            }else if(U->chipNumberL < 0 && U2->chipNumberL >= 0){
                U = UTop;
                [self DisplayMessageMod3A];
                return;
            }
            
            
            U = UTop;
            if(bLoopFlag) break;
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            ATTACK *aTop = U->C.A;
            for(int i = 0;i < crCAL1;i++){
                U->C.A = U->C.A->next;
            }
            
            
            if(!battleDef1Flag && !battleDod1Flag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@の%@\n", U->C.name, U->C.A->name]];
            
            double urSupposedToGet;
           
            urSupposedToGet = pow(8, log(3+U->C.A->totalD/16));
            
            double oopsIsRight;
            
            if(U->C.A->melee) oopsIsRight = U->C.S_C.MEL;
            else oopsIsRight = U->C.S_C.MIS;
            
            oopsIsRight = oopsIsRight/100;
            double val;
            if(!U2->C.aura){
            if(U->C.A->D->type == 0) dmg = (U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF;
            if(U->C.A->D->type == 1) dmg = (U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK;
            if(U->C.A->D->type == 2) dmg = (U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA;
            if(U->C.A->D->type == 3) dmg = (U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU;
            if(U->C.A->D->type == 4) dmg = (U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP;
            if(U->C.A->D->type == 5) dmg = U->C.A->totalD;
            }else{
                val = 1/log(3+U2->C.S_C.MP/64);
                if(U->C.A->D->type == 0) dmg = ((U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF)*val;
                if(U->C.A->D->type == 1) dmg = ((U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK)*val;
                if(U->C.A->D->type == 2) dmg = ((U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA)*val;
                if(U->C.A->D->type == 3) dmg = ((U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU)*val;
                if(U->C.A->D->type == 4) dmg = ((U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP)*val;
                if(U->C.A->D->type == 5) dmg = U->C.A->totalD*val;
            }
            double val2 = log(3+U2->C.S_C.MP/64);
            if(U->C.aura){
                dmg = dmg*val2;
            }
            
            costMP = U->C.A->MP + floor(U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
            U->C.S_C.MP -= costMP;
            
            hit = U->C.S_C.ACU*U->C.S_C.HIT/100;
            hitFix = U->C.A->hitPercent;
            
            U2A = U->C.A;
            U->C.A = aTop;
            
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            U2 = U;
            
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
            
            double hit2 = U->C.S_C.EVA*U->C.S_C.DOD/100;
            
            double hi = U->C.S_C.LUK - U2->C.S_C.LUK;
            if(hi < 0) hi = 0;
            
            hit = 60 + hit/hit2*10 - hit2/hit*10 + hitFix - log(hi+1)*hit2/hit*10;
            if(hit > 100) hit = 100;
            if(hit < 0) hit = 0;
            if(U2A->D->sort == 1){
                hit = 100;
            }
            
            healFlag = false;
            
            int wtf = 100;
            if(battleDod2Flag) wtf = 50;
            if(hit - rand()%wtf > 0 && !battleDef1Flag && !battleDod1Flag){
                
                if(U2A->D->sort == 0){
                    if(U2A->D->type == 0) NSLog(@"計算式：((%g+%g)*%g-%g)*%g*%g", U2->C.S_C.ATK,U2A->totalD,oopsIsRight,U->C.S_C.DEF, val, val2);
                    if(U2A->D->type == 4) NSLog(@"計算式：((%g+%g)*%g-%g)*%g*%g", U2->C.S_C.CAP,U2A->totalD,oopsIsRight,U->C.S_C.CAP, val, val2);
                    NSLog(@"修正前のダメージ:%g", dmg);
                    dmg = [self dmgResist:dmg];
                    NSLog(@"属性後のダメージ:%g", dmg);
                    def2 = pow(def2, U->C.S_C.DEF);
                    int omfg = rand()%100;
                    NSLog(@"ダメージ幅:%g〜%g", floor(dmg), floor(dmg + dmg/10));
                    dmg = (dmg*omfg/100/10 + dmg);
                    NSLog(@"地形効果:%g - %g", dmg, dmg*MC[chipNum[possionX][possionY]].dmgfix/100);
                    if(buildNum[possionX][possionY] < 0) dmg -= dmg*MC[chipNum[possionX][possionY]].dmgfix/100 - 0.5;
                    else dmg -= dmg*BC[buildNum[possionX][possionY]].dmgfix/100 - 0.5;
                    
                    if(U->C.S_C.typeMOVE == RIKU){
                        if(U2A->riku == A) dmg = dmg*1.2;
                        if(U2A->riku == B) dmg = dmg*1.0;
                        if(U2A->riku == C) dmg = dmg*0.6;
                        if(U2A->riku == D) dmg = dmg*0.2;
                        if(U2A->riku == E) dmg = 0;
                        if(U2A->riku == S) dmg = dmg*1.5;
                        if(U2A->riku == SS) dmg = dmg*2.0;
                    } if(U->C.S_C.typeMOVE == UMI &&
                       (MC[chipNum[possionX][possionY]].type == 3 || MC[chipNum[possionX][possionY]].type == 4)){
                        if(U2A->umi == A) dmg = dmg*1.2;
                        if(U2A->umi == B) dmg = dmg*1.0;
                        if(U2A->umi == C) dmg = dmg*0.6;
                        if(U2A->umi == D) dmg = dmg*0.2;
                        if(U2A->umi == E) dmg = 0;
                        if(U2A->umi == S) dmg = dmg*1.5;
                        if(U2A->umi == SS) dmg = dmg*2.0;
                    }else if(U->C.S_C.typeMOVE == UMI){
                        if(U2A->riku == A) dmg = dmg*1.2;
                        if(U2A->riku == B) dmg = dmg*1.0;
                        if(U2A->riku == C) dmg = dmg*0.6;
                        if(U2A->riku == D) dmg = dmg*0.2;
                        if(U2A->riku == E) dmg = 0;
                        if(U2A->riku == S) dmg = dmg*1.5;
                        if(U2A->riku == SS) dmg = dmg*2.0;
                    
                    } if(U->C.S_C.typeMOVE == CHU){
                        if(U2A->chu == A) dmg = dmg*1.2;
                        if(U2A->chu == B) dmg = dmg*1.0;
                        if(U2A->chu == C) dmg = dmg*0.6;
                        if(U2A->chu == D) dmg = dmg*0.2;
                        if(U2A->chu == E) dmg = 0;
                        if(U2A->chu == S) dmg = dmg*1.5;
                        if(U2A->chu == SS) dmg = dmg*2.0;
                    } if(U->C.S_C.typeMOVE == SORA){
                        if(U2A->sora == A) dmg = dmg*1.2;
                        if(U2A->sora == B) dmg = dmg*1.0;
                        if(U2A->sora == C) dmg = dmg*0.6;
                        if(U2A->sora == D) dmg = dmg*0.2;
                        if(U2A->sora == E) dmg = 0;
                        if(U2A->sora == S) dmg = dmg*1.5;
                        if(U2A->sora == SS) dmg = dmg*2.0;
                    }
                    
                    NSLog(@"ユニットの地形適用後:%g", dmg);
                    if(battleDef2Flag) NSLog(@"防御後のダメージ:%g", dmg/2);
                    graze = U->C.S_C.MEN/U2->C.S_C.MEN*U->C.S_C.LUK/3;
                    
                    grazeFlag = false;
                    omfg = rand()%100;
                    if(graze > omfg && !healFlag) {dmg = dmg/5;
                        grazeFlag = true;
                    }
                    if(battleDef2Flag) dmg -= dmg*0.5;
                    battleDef2Flag = false;
                    dmg = floor(dmg);
                    if(dmg < 0) dmg = 0;
                    U->C.S_C.HP -= dmg;
                    
                }else if(U2A->D->sort == 1){
                    dmg = dmg + rand()%5*dmg/10 - rand()%5*dmg/10;
                    dmg = floor(dmg);
                    
                    U->C.S_C.HP += dmg;
                    if(U->C.S_C.HP > U->C.S_M.HP) U->C.S_C.HP = U->C.S_M.HP;
                    healFlag = true;
                }
                
                while(1){
                    if(U->C.S_C.HP <= 0) {
                        U->C.S_C.HP = 0;
                        
                        messageProcess = 2;
                        if(U->dead) break;
                        U->dead = true;
                        
                        
                        if(U->targType1L)
                            targType1cnt[0]--;
                        if(U->targType2L) {
                            targType2cnt[0]--;
                            targType2Lflag = true;
                        }
                        
                        if(U->targType1D)
                            targType1cnt[1]--;
                        if(U->targType2D) {
                            targType2cnt[1]--;
                            targType2Dflag = true;
                        }
                        
                        break;
                    }
                    break;
                }
                
            [tplayer2 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
            [lplayer2 setIntValue:U->C.S_C.HP/U->C.S_M.HP*100];
            
                if(![U2A->msg isEqualToString:@""]){
                    
                    message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",
                                                                [self originalMessage:U2A->msg subj:U2->C.name obje:U->C.name]]];
                    
                }
                
            if(grazeFlag) message = [message stringByAppendingString:[NSString stringWithFormat:@"かすりヒット！\n"]];
            if(!healFlag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は%gのダメージを受けた！", U->C.name, dmg]];
                else message = [message stringByAppendingString:[NSString stringWithFormat:@"%@はHPが%g回復した！", U->C.name, dmg]];
            }else if(battleDef1Flag){
            
                
                U = UTop;
                while (!(AUN[1] == U->number)) {
                    U = U->next;
                }
                
                
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は身構えている", U->C.name]];
            
            
            }else if(battleDod1Flag){
            
                U = UTop;
                while (!(AUN[1] == U->number)) {
                    U = U->next;
                }
                
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は様子をうかがっている", U->C.name]];
                
            
            }else{
            
                message = [message stringByAppendingString:[NSString stringWithFormat:@"ミス！%@はダメージを受けていない！", U->C.name]];
            
            }
                [battleDialog setStringValue:message];
            
            
            U = UTop;
            
            bLoopFlag = true;
            
            if(healFlag) {
                messageProcess++;
            };
            messageProcess++;
            
            break;
        case 2:
            
            
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
            U2 = U;
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            
            if(U->chipNumberL >= 0 && U2->chipNumberL >= 0){
                U = UTop;
                [self DisplayMessageMod1B];
                return;
            }else if(U->chipNumberL >= 0 && U2->chipNumberL < 0){
                U = UTop;
                [self DisplayMessageMod2B];
                return;
            }else if(U->chipNumberL < 0 && U2->chipNumberL >= 0){
                U = UTop;
                [self DisplayMessageMod3B];
                return;
            }
            U = UTop;
            
            if(bLoopFlag) break;
            
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            U2 = U;
            U = UTop;
            
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
            
            ATTACK *aTop2 = U->C.A;
            int mostDmg = 0;
            int mostDmg2 = 0;
            int mostNum = 0;
            int num = 0;
            int mpCost =0;
            
            if(!U->C.A) goto SKIP3;
            
            
            
            urSupposedToGet = pow(8, log(3+U->C.A->totalD/16));
            
            if(U->C.A->melee) oopsIsRight = U->C.S_C.MEL;
            else oopsIsRight = U->C.S_C.MIS;
            
            oopsIsRight = oopsIsRight/100;
            
            if(U->C.A) {
                mpCost = floor(U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
            }
            while(U->C.A){
                mpCost = floor(U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
                if(!U2->C.aura){
                    if(U->C.A->D->type == 0) mostDmg2 = (U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF;
                    if(U->C.A->D->type == 1) mostDmg2 = (U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK;
                    if(U->C.A->D->type == 2) mostDmg2 = (U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA;
                    if(U->C.A->D->type == 3) mostDmg2 = (U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU;
                    if(U->C.A->D->type == 4) mostDmg2 = (U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP;
                    if(U->C.A->D->type == 5) mostDmg2 = U->C.A->totalD;
                }else{
                    val = 1/log(3+U2->C.S_C.MP/64);
                    if(U->C.A->D->type == 0) mostDmg2 = ((U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF)*val;
                    if(U->C.A->D->type == 1) mostDmg2 = ((U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK)*val;
                    if(U->C.A->D->type == 2) mostDmg2 = ((U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA)*val;
                    if(U->C.A->D->type == 3) mostDmg2 = ((U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU)*val;
                    if(U->C.A->D->type == 4) mostDmg2 = ((U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP)*val;
                    if(U->C.A->D->type == 5) mostDmg2 = U->C.A->totalD*val;
                }
                double val2 = log(3+U2->C.S_C.MP/64);
                if(U->C.aura){
                    mostDmg2 = mostDmg2*val2;
                }
                U2A = U->C.A;
                UNIT *oops = U;
                U = U2;
                mostDmg2 = [self dmgResist:mostDmg2];
                U = oops;
                if(mostDmg < mostDmg2 && U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && U->C.A->D->sort != 1 && mpCost <= U->C.S_C.MP){
                    
            
                    mostDmg = mostDmg2;
                    
                    
                    //mostDmg = U->C.A->totalD;
                    mostNum = num;
                }
                U->C.A = U->C.A->next;
                num++;
            }
            
            U->C.A = aTop2;
            
            if(!battleSet2PushedFlag){
                for(int i = 0;i < mostNumSub;i++){
                U->C.A = U->C.A->next;
            }
            
            }else{
            for(int i = 0;i < crCAL2;i++){
                U->C.A = U->C.A->next;
            }
            
            
            }
            
            if(U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && U->C.A->D->sort != 1){
            
            }else while(U->C.A){
                U->C.A = U->C.A->next;
            }
            
            if(!U->C.A){
                U->C.A = aTop2;
                U = UTop;
                message = [message stringByAppendingString:[NSString stringWithFormat:@"射程外\n"]];
                goto SKIP1;
            }
            
            if(!battleDef2Flag && !battleDod2Flag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@の%@\n", U->C.name, U->C.A->name]];
            
            U2A = U->C.A;
            
            /*
            if(U->C.A->D->type == 0) dmg = U->C.S_C.ATK + U->C.A->totalD;
            if(U->C.A->D->type == 1) dmg = U->C.S_C.DEF + U->C.A->totalD;
            if(U->C.A->D->type == 2) dmg = U->C.S_C.ACU + U->C.A->totalD;
            if(U->C.A->D->type == 3) dmg = U->C.S_C.EVA + U->C.A->totalD;
            if(U->C.A->D->type == 4) dmg = U->C.S_C.CAP + U->C.A->totalD;
            if(U->C.A->D->type == 5) dmg = U->C.A->totalD;
            */
            
            U->C.A = aTop2;
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            U2 = U;
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
            NSString *string = [U2A->name retain];
            while (![U->C.A->name isEqualToString:string] && U->C.A) {
                U->C.A = U->C.A->next;
            }
            
            if(!U->C.A) U->C.A = aTop2;
            
            urSupposedToGet = pow(8, log(3+U->C.A->totalD/16));
            
            if(U->C.A->melee) oopsIsRight = U->C.S_C.MEL;
            else oopsIsRight = U->C.S_C.MIS;
            
            oopsIsRight = oopsIsRight/100;

            
            if(!U2->C.aura){
                if(U->C.A->D->type == 0) dmg = (U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF;
                if(U->C.A->D->type == 1) dmg = (U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK;
                if(U->C.A->D->type == 2) dmg = (U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA;
                if(U->C.A->D->type == 3) dmg = (U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU;
                if(U->C.A->D->type == 4) dmg = (U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP;
                if(U->C.A->D->type == 5) dmg = U->C.A->totalD;
            }else{
                double val = val = 1/log(3+U2->C.S_C.MP/64);
                if(U->C.A->D->type == 0) dmg = ((U->C.S_C.ATK+urSupposedToGet)*oopsIsRight - U2->C.S_C.DEF)*val;
                if(U->C.A->D->type == 1) dmg = ((U->C.S_C.DEF+urSupposedToGet)*oopsIsRight - U2->C.S_C.ATK)*val;
                if(U->C.A->D->type == 2) dmg = ((U->C.S_C.ACU+urSupposedToGet)*oopsIsRight - U2->C.S_C.EVA)*val;
                if(U->C.A->D->type == 3) dmg = ((U->C.S_C.EVA+urSupposedToGet)*oopsIsRight - U2->C.S_C.ACU)*val;
                if(U->C.A->D->type == 4) dmg = ((U->C.S_C.CAP+urSupposedToGet)*oopsIsRight - U2->C.S_C.CAP)*val;
                if(U->C.A->D->type == 5) dmg = U->C.A->totalD*val;
            }
            val2 = log(3+U2->C.S_C.MP/64);
            if(U->C.aura){
                dmg = dmg*val2;
            }
            costMP = U->C.A->MP + floor(U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
            U->C.S_C.MP -= costMP;
            
            hit = U->C.S_C.ACU*U->C.S_C.HIT/100;
            hitFix = U->C.A->hitPercent;
            
            U2A = U->C.A;
            
            U->C.A = aTop2;
            
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
            U2 = U;
            
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            
            hit2 = U->C.S_C.EVA*U->C.S_C.DOD/100;
            
            hi = U->C.S_C.LUK - U2->C.S_C.LUK;
            if(hi < 0) hi = 0;
            
            hit = 60 + hit/hit2*10 - hit2/hit*10 + hitFix - log(hi+1)*hit2/hit*10;
            if(hit > 100) hit = 100;
            if(hit < 0) hit = 0;
            
            battleDod1Flag = false;
            
            U = UTop;
            while (!(DUN[1] == U->number)) {
                U = U->next;
            }
            U2 = U;
            
            U = UTop;
            while (!(AUN[1] == U->number)) {
                U = U->next;
            }
            
            int omg = 100;
            if(battleDod1Flag) omg = 50;
            
            if(hit - rand()%omg > 0 && !battleDef2Flag && !battleDod2Flag){
                if(U2A->D->type == 0) NSLog(@"計算式：((%g+%g)*%g-%g)*%g*%g", U2->C.S_C.ATK,U2A->totalD,oopsIsRight,U->C.S_C.DEF, val, val2);
                if(U2A->D->type == 4) NSLog(@"計算式：((%g+%g)*%g-%g)*%g%g", U2->C.S_C.CAP,U2A->totalD,oopsIsRight,U->C.S_C.CAP, val, val2);
                NSLog(@"修正前のダメージ:%g", dmg);
                dmg = [self dmgResist:dmg];
                NSLog(@"属性後のダメージ:%g", dmg);
            def2 = pow(def2, U->C.S_C.DEF);
            int omfg = rand()%100;
                NSLog(@"ダメージ幅:%g〜%g", floor(dmg), floor(dmg + dmg/10));
                dmg = (dmg*omfg/100/10 + dmg);
                NSLog(@"地形効果:%g - %g", dmg, dmg*MC[chipNum[possionX][possionY]].dmgfix/100);
                if(buildNum[possionX][possionY] < 0) dmg -= dmg*MC[chipNum[possionX][possionY]].dmgfix/100 - 0.5;
                else dmg -= dmg*BC[buildNum[possionX][possionY]].dmgfix/100 - 0.5;
            
                if(U->C.S_C.typeMOVE == RIKU){
                    if(U2A->riku == A) dmg = dmg*1.2;
                    if(U2A->riku == B) dmg = dmg*1.0;
                    if(U2A->riku == C) dmg = dmg*0.6;
                    if(U2A->riku == D) dmg = dmg*0.2;
                    if(U2A->riku == E) dmg = 0;
                    if(U2A->riku == S) dmg = dmg*1.5;
                    if(U2A->riku == SS) dmg = dmg*2.0;
                } if(U->C.S_C.typeMOVE == UMI &&
                     (MC[chipNum[possionX][possionY]].type == 3 || MC[chipNum[possionX][possionY]].type == 4)){
                    if(U2A->umi == A) dmg = dmg*1.2;
                    if(U2A->umi == B) dmg = dmg*1.0;
                    if(U2A->umi == C) dmg = dmg*0.6;
                    if(U2A->umi == D) dmg = dmg*0.2;
                    if(U2A->umi == E) dmg = 0;
                    if(U2A->umi == S) dmg = dmg*1.5;
                    if(U2A->umi == SS) dmg = dmg*2.0;
                }else if(U->C.S_C.typeMOVE == UMI){
                    if(U2A->riku == A) dmg = dmg*1.2;
                    if(U2A->riku == B) dmg = dmg*1.0;
                    if(U2A->riku == C) dmg = dmg*0.6;
                    if(U2A->riku == D) dmg = dmg*0.2;
                    if(U2A->riku == E) dmg = 0;
                    if(U2A->riku == S) dmg = dmg*1.5;
                    if(U2A->riku == SS) dmg = dmg*2.0;
                    
                } if(U->C.S_C.typeMOVE == CHU){
                    if(U2A->chu == A) dmg = dmg*1.2;
                    if(U2A->chu == B) dmg = dmg*1.0;
                    if(U2A->chu == C) dmg = dmg*0.6;
                    if(U2A->chu == D) dmg = dmg*0.2;
                    if(U2A->chu == E) dmg = 0;
                    if(U2A->chu == S) dmg = dmg*1.5;
                    if(U2A->chu == SS) dmg = dmg*2.0;
                } if(U->C.S_C.typeMOVE == SORA){
                    if(U2A->sora == A) dmg = dmg*1.2;
                    if(U2A->sora == B) dmg = dmg*1.0;
                    if(U2A->sora == C) dmg = dmg*0.6;
                    if(U2A->sora == D) dmg = dmg*0.2;
                    if(U2A->sora == E) dmg = 0;
                    if(U2A->sora == S) dmg = dmg*1.5;
                    if(U2A->sora == SS) dmg = dmg*2.0;
                }
                
                NSLog(@"ユニットの地形適用後:%g", dmg);
                
                graze = U->C.S_C.MEN/U2->C.S_C.MEN*U->C.S_C.LUK/3;
                
                grazeFlag = false;
                omfg = rand()&100;
                if(graze > omfg && !healFlag) {dmg = dmg/5;
                    grazeFlag = true;
                }

            if(battleDef1Flag) dmg -= dmg*0.5;
            battleDef1Flag = false;
                dmg = floor(dmg);
                if(dmg < 0) dmg = 0;
            U->C.S_C.HP -= dmg;
                
                while(1){
                if(U->C.S_C.HP <= 0) {
                    U->C.S_C.HP = 0;
                
                    messageProcess = 2;
                    if(U->dead) break;
                    U->dead = true;
                    
                    
                    if(U->targType1L)
                        targType1cnt[0]--;
                    if(U->targType2L) {
                        targType2cnt[0]--;
                        targType2Lflag = true;
                    }
                
                    if(U->targType1D)
                        targType1cnt[1]--;
                    if(U->targType2D) {
                        targType2cnt[1]--;
                        targType2Dflag = true;
                    }
                    
                    break;
                }
                    break;
                }
                
      
        
                [tplayer1 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
            
                [lplayer1 setIntValue:U->C.S_C.HP/U->C.S_M.HP*100];
            
                if(![U2A->msg isEqualToString:@""]){
                    message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",
                                                                [self originalMessage:U2A->msg subj:U2->C.name obje:U->C.name]]];
                }
                
                
           
                if(grazeFlag)
                    message = [message stringByAppendingString:[NSString stringWithFormat:@"かすりヒット！\n"]];
            
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は%gのダメージを受けた！", U->C.name, dmg]];
           
            }else if(battleDef2Flag){
                
                
                U = UTop;
                while (!(DUN[1] == U->number)) {
                    U = U->next;
                }
                
                
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は身構えている", U->C.name]];
                
                
            }else if(battleDod2Flag){
                
                U = UTop;
                while (!(DUN[1] == U->number)) {
                    U = U->next;
                }
                
                message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は様子をうかがっている", U->C.name]];
                
                
            }else{
            
                message = [message stringByAppendingString:[NSString stringWithFormat:@"ミス！%@はダメージを受けていない！", U->C.name]];
            }
        SKIP1:
            [battleDialog setStringValue:message];
        SKIP3:
            U = UTop;
            bLoopFlag = true;
            messageProcess++;
            break;
        case 3:
            if(bLoopFlag) break;
            
            battleFlag = false;
            battleRdy = false;
            battleSet2PushedFlag = false;
            cpuModeBATTLEendFlag = true;
            [battleWindow close];
            break;
            
        default:
            break;
    }


    UCselected = UC[-1];


}

-(void)DisplayMessageMod1A{//両方モビール

    double def2 = (double)31/32;
    NSString *message = @"";
    
    enum{
        RIKU,
        UMI,
        CHU,
        SORA,
    };
    
    enum{
        A,
        B,
        C,
        D,
        E,
        S,
        SS
    };

    
    
    if(bLoopFlag) return;
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    ATTACK *aTop = U->CL.A;
    for(int i = 0;i < crCAL1;i++){
        U->CL.A = U->CL.A->next;
    }
    
    
    if(!battleDef1Flag && !battleDod1Flag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@の%@\n", U->CL.name, U->CL.A->name]];
    
    
    
    dmg = U->CL.A->totalD;
    
    costMP = U->CL.A->EN + floor(U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
    U->CL.S_C.EN -= costMP;
    
    hit = U->CL.S_C.MOB+U->C.S_C.HIT;
    hitFix = U->CL.A->hitPercent;
    
    U2A = U->CL.A;
    U->CL.A = aTop;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    hit = 60 + hit/(U->CL.S_C.MOB*U->C.S_C.DOD/100)*10 - (U->CL.S_C.MOB*U->C.S_C.DOD/100)/hit*10 + hitFix;
    if(hit > 100) hit = 100;
    if(U2A->D->sort == 1){
        hit = 100;
    }
    
    healFlag = false;
    
    int wtf = 100;
    if(battleDod2Flag) wtf = 50;
    if(hit - rand()%wtf > 0 && !battleDef1Flag && !battleDod1Flag){
        
        if(U2A->D->sort == 0){
            NSLog(@"修正前のダメージ:%g", dmg);
            dmg = [self dmgResist:dmg];
            NSLog(@"属性後のダメージ:%g", dmg);
            def2 = pow(def2, U->CL.S_C.ARM);
            int omfg = rand()%100;
            NSLog(@"計算式:(%g + %g - %g)", dmg*omfg/100, dmg, U->CL.S_C.ARM);
            
            NSLog(@"ダメージ幅:%g〜%g", (0 + dmg - U->CL.S_C.ARM), (dmg + dmg - U->CL.S_C.ARM));
            dmg = (dmg*omfg/100 + dmg - U->CL.S_C.ARM);
            NSLog(@"地形効果:%g - %g", dmg, dmg*MC[chipNum[possionX][possionY]].dmgfix/100);
            if(buildNum[possionX][possionY] < 0) dmg -= dmg*MC[chipNum[possionX][possionY]].dmgfix/100 - 0.5;
            else dmg -= dmg*BC[buildNum[possionX][possionY]].dmgfix/100 - 0.5;
            
            if(U->CL.S_C.typeMOVE == RIKU){
                if(U2A->riku == A) dmg = dmg*1.2;
                if(U2A->riku == B) dmg = dmg*1.0;
                if(U2A->riku == C) dmg = dmg*0.6;
                if(U2A->riku == D) dmg = dmg*0.2;
                if(U2A->riku == E) dmg = 0;
                if(U2A->riku == S) dmg = dmg*1.5;
                if(U2A->riku == SS) dmg = dmg*2.0;
            } if(U->CL.S_C.typeMOVE == UMI &&
                 (MC[chipNum[possionX][possionY]].type == 3 || MC[chipNum[possionX][possionY]].type == 4)){
                if(U2A->umi == A) dmg = dmg*1.2;
                if(U2A->umi == B) dmg = dmg*1.0;
                if(U2A->umi == C) dmg = dmg*0.6;
                if(U2A->umi == D) dmg = dmg*0.2;
                if(U2A->umi == E) dmg = 0;
                if(U2A->umi == S) dmg = dmg*1.5;
                if(U2A->umi == SS) dmg = dmg*2.0;
            }else if(U->CL.S_C.typeMOVE == UMI){
                if(U2A->riku == A) dmg = dmg*1.2;
                if(U2A->riku == B) dmg = dmg*1.0;
                if(U2A->riku == C) dmg = dmg*0.6;
                if(U2A->riku == D) dmg = dmg*0.2;
                if(U2A->riku == E) dmg = 0;
                if(U2A->riku == S) dmg = dmg*1.5;
                if(U2A->riku == SS) dmg = dmg*2.0;
                
            } if(U->CL.S_C.typeMOVE == CHU){
                if(U2A->chu == A) dmg = dmg*1.2;
                if(U2A->chu == B) dmg = dmg*1.0;
                if(U2A->chu == C) dmg = dmg*0.6;
                if(U2A->chu == D) dmg = dmg*0.2;
                if(U2A->chu == E) dmg = 0;
                if(U2A->chu == S) dmg = dmg*1.5;
                if(U2A->chu == SS) dmg = dmg*2.0;
            } if(U->CL.S_C.typeMOVE == SORA){
                if(U2A->sora == A) dmg = dmg*1.2;
                if(U2A->sora == B) dmg = dmg*1.0;
                if(U2A->sora == C) dmg = dmg*0.6;
                if(U2A->sora == D) dmg = dmg*0.2;
                if(U2A->sora == E) dmg = 0;
                if(U2A->sora == S) dmg = dmg*1.5;
                if(U2A->sora == SS) dmg = dmg*2.0;
            }
            
            NSLog(@"ユニットの地形適用後:%g", dmg);
            if(battleDef2Flag) NSLog(@"防御後のダメージ:%g", dmg/2);
            graze = U->C.S_C.MEN/U2->C.S_C.MEN*U->C.S_C.LUK/3;
            
            grazeFlag = false;
            omfg = rand()%100;
            if(graze > omfg && !healFlag) {dmg = dmg/5;
                grazeFlag = true;
            }
            if(battleDef2Flag) dmg -= dmg*0.5;
            battleDef2Flag = false;
            dmg = floor(dmg);
            if(dmg < 0) dmg = 0;
            U->CL.S_C.HP -= dmg;
            
        }else if(U2A->D->sort == 1){
            dmg = dmg + rand()%5*dmg/10 - rand()%5*dmg/10;
            dmg = floor(dmg);
            
            U->CL.S_C.HP += dmg;
            if(U->CL.S_C.HP > U->CL.S_M.HP) U->CL.S_C.HP = U->CL.S_M.HP;
            healFlag = true;
        }
        
        while(1){
            if(U->CL.S_C.HP <= 0) {
                U->CL.S_C.HP = 0;
                
                messageProcess = 2;
                if(U->dead) break;
                U->dead = true;
                
                
                if(U->targType1L)
                    targType1cnt[0]--;
                if(U->targType2L) {
                    targType2cnt[0]--;
                    targType2Lflag = true;
                }
                
                if(U->targType1D)
                    targType1cnt[1]--;
                if(U->targType2D) {
                    targType2cnt[1]--;
                    targType2Dflag = true;
                }
                
                break;
            }
            break;
        }
        
        [tplayer2 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [lplayer2 setIntValue:U->CL.S_C.HP/U->CL.S_M.HP*100];
        
        if(![U2A->msg isEqualToString:@""]){
            
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",
                                                        [self originalMessage:U2A->msg subj:U2->CL.name obje:U->CL.name]]];
            
        }
        
        if(grazeFlag) message = [message stringByAppendingString:[NSString stringWithFormat:@"かすりヒット！\n"]];
        if(!healFlag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は%gのダメージを受けた！", U->CL.name, dmg]];
        else message = [message stringByAppendingString:[NSString stringWithFormat:@"%@はHPが%g回復した！", U->CL.name, dmg]];
    }else if(battleDef1Flag){
        
        
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は身構えている", U->CL.name]];
        
        
    }else if(battleDod1Flag){
        
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は様子をうかがっている", U->CL.name]];
        
        
    }else{
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"ミス！%@はダメージを受けていない！", U->CL.name]];
        
    }
    [battleDialog setStringValue:message];
    
    
    U = UTop;
    
    bLoopFlag = true;
    
    if(healFlag) {
        messageProcess++;
    };
    messageProcess++;
    
    return;

}

-(void)DisplayMessageMod1B{

    double def2 = (double)31/32;
    NSString *message = @"";
    
    enum{
        RIKU,
        UMI,
        CHU,
        SORA,
    };
    
    enum{
        A,
        B,
        C,
        D,
        E,
        S,
        SS
    };

    
    if(bLoopFlag) return;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    U = UTop;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    
    ATTACK *aTop2 = U->CL.A;
    int mostDmg = 0;
    int mostNum = 0;
    int num = 0;
    int mpCost =0;
    if(U->CL.A) {
        mpCost = floor(U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
    }
    while(U->CL.A){
        mpCost = floor(U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
        if(mostDmg < U->CL.A->totalD && U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && U->CL.A->D->sort != 1 && mpCost <= U->CL.S_C.EN){
            mostDmg = U->CL.A->totalD;
            mostNum = num;
        }
        U->CL.A = U->CL.A->next;
        num++;
    }
    
    U->CL.A = aTop2;
    
    if(!battleSet2PushedFlag){
        for(int i = 0;i < mostNumSub;i++){
            U->CL.A = U->CL.A->next;
        }
        
    }else{
        for(int i = 0;i < crCAL2;i++){
            U->CL.A = U->CL.A->next;
        }
    }
    
    if(!U->CL.A->name){
    
        U->CL.A = NULL;
    }
    if(U->CL.A){
    if(U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && U->CL.A->D->sort != 1){
    }else while(U->CL.A){
        U->CL.A = U->CL.A->next;
    }
    }
    
    if(!U->CL.A){
        U->CL.A = aTop2;
        U = UTop;
        message = [message stringByAppendingString:[NSString stringWithFormat:@"射程外\n"]];
        goto SKIP1;
    }
    
    if(!battleDef2Flag && !battleDod2Flag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@の%@\n", U->CL.name, U->CL.A->name]];
    
    
    dmg = U->CL.A->totalD;
    
    costMP = U->CL.A->EN + floor(U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
    U->CL.S_C.EN -= costMP;
    
    hit = U->CL.S_C.MOB + U->C.S_C.HIT;
    hitFix = U->CL.A->hitPercent;
    
    U2A = U->CL.A;
    U->CL.A = aTop2;
    
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    
    hit = 60 + hit/(U->CL.S_C.MOB*U->C.S_C.DOD/100)*10 - (U->CL.S_C.MOB*U->C.S_C.DOD/100)/hit*10 + hitFix;
    if(hit > 100) hit = 100;
    
    battleDod1Flag = false;
    
    int omg = 100;
    if(battleDod1Flag) omg = 50;
    
    if(hit - rand()%omg > 0 && !battleDef2Flag && !battleDod2Flag){
        NSLog(@"修正前のダメージ:%g", dmg);
        dmg = [self dmgResist:dmg];
        NSLog(@"属性後のダメージ:%g", dmg);
        def2 = pow(def2, U->CL.S_C.ARM);
        int omfg = rand()%100;
        NSLog(@"計算式:(%g + %g - %g)", dmg*omfg/100, dmg, U->CL.S_C.ARM);
        NSLog(@"ダメージ幅:%g〜%g", (0 + dmg - U->CL.S_C.ARM), (dmg + dmg - U->CL.S_C.ARM));
        dmg = (dmg*omfg/100 + dmg - U->CL.S_C.ARM);
        
        
        NSLog(@"地形効果:%g - %g", dmg, dmg*MC[chipNum[possionX][possionY]].dmgfix/100);
        if(buildNum[possionX][possionY] < 0) dmg -= dmg*MC[chipNum[possionX][possionY]].dmgfix/100 - 0.5;
        else dmg -= dmg*BC[buildNum[possionX][possionY]].dmgfix/100 - 0.5;
        
        if(U->CL.S_C.typeMOVE == RIKU){
            if(U2A->riku == A) dmg = dmg*1.2;
            if(U2A->riku == B) dmg = dmg*1.0;
            if(U2A->riku == C) dmg = dmg*0.6;
            if(U2A->riku == D) dmg = dmg*0.2;
            if(U2A->riku == E) dmg = 0;
            if(U2A->riku == S) dmg = dmg*1.5;
            if(U2A->riku == SS) dmg = dmg*2.0;
        } if(U->CL.S_C.typeMOVE == UMI &&
             (MC[chipNum[possionX][possionY]].type == 3 || MC[chipNum[possionX][possionY]].type == 4)){
            if(U2A->umi == A) dmg = dmg*1.2;
            if(U2A->umi == B) dmg = dmg*1.0;
            if(U2A->umi == C) dmg = dmg*0.6;
            if(U2A->umi == D) dmg = dmg*0.2;
            if(U2A->umi == E) dmg = 0;
            if(U2A->umi == S) dmg = dmg*1.5;
            if(U2A->umi == SS) dmg = dmg*2.0;
        }else if(U->CL.S_C.typeMOVE == UMI){
            if(U2A->riku == A) dmg = dmg*1.2;
            if(U2A->riku == B) dmg = dmg*1.0;
            if(U2A->riku == C) dmg = dmg*0.6;
            if(U2A->riku == D) dmg = dmg*0.2;
            if(U2A->riku == E) dmg = 0;
            if(U2A->riku == S) dmg = dmg*1.5;
            if(U2A->riku == SS) dmg = dmg*2.0;
            
        } if(U->CL.S_C.typeMOVE == CHU){
            if(U2A->chu == A) dmg = dmg*1.2;
            if(U2A->chu == B) dmg = dmg*1.0;
            if(U2A->chu == C) dmg = dmg*0.6;
            if(U2A->chu == D) dmg = dmg*0.2;
            if(U2A->chu == E) dmg = 0;
            if(U2A->chu == S) dmg = dmg*1.5;
            if(U2A->chu == SS) dmg = dmg*2.0;
        } if(U->CL.S_C.typeMOVE == SORA){
            if(U2A->sora == A) dmg = dmg*1.2;
            if(U2A->sora == B) dmg = dmg*1.0;
            if(U2A->sora == C) dmg = dmg*0.6;
            if(U2A->sora == D) dmg = dmg*0.2;
            if(U2A->sora == E) dmg = 0;
            if(U2A->sora == S) dmg = dmg*1.5;
            if(U2A->sora == SS) dmg = dmg*2.0;
        }
        
        NSLog(@"ユニットの地形適用後:%g", dmg);
        
        graze = U->C.S_C.MEN/U2->C.S_C.MEN*U->C.S_C.LUK/3;
        
        grazeFlag = false;
        omfg = rand()&100;
        if(graze > omfg && !healFlag) {dmg = dmg/5;
            grazeFlag = true;
        }
        
        if(battleDef1Flag) dmg -= dmg*0.5;
        battleDef1Flag = false;
        dmg = floor(dmg);
        if(dmg < 0) dmg = 0;
        U->CL.S_C.HP -= dmg;
        
        while(1){
            if(U->CL.S_C.HP <= 0) {
                U->CL.S_C.HP = 0;
                
                messageProcess = 2;
                if(U->dead) break;
                U->dead = true;
                
                
                if(U->targType1L)
                    targType1cnt[0]--;
                if(U->targType2L) {
                    targType2cnt[0]--;
                    targType2Lflag = true;
                }
                
                if(U->targType1D)
                    targType1cnt[1]--;
                if(U->targType2D) {
                    targType2cnt[1]--;
                    targType2Dflag = true;
                }
                
                break;
            }
            break;
        }
        
        
        
        [tplayer1 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        
        [lplayer1 setIntValue:U->CL.S_C.HP/U->CL.S_M.HP*100];
        
        if(![U2A->msg isEqualToString:@""]){
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",
                                                        [self originalMessage:U2A->msg subj:U2->CL.name obje:U->CL.name]]];
        }
        
        
        
        if(grazeFlag)
            message = [message stringByAppendingString:[NSString stringWithFormat:@"かすりヒット！\n"]];
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は%gのダメージを受けた！", U->CL.name, dmg]];
        
    }else if(battleDef2Flag){
        
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は身構えている", U->CL.name]];
        
        
    }else if(battleDod2Flag){
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は様子をうかがっている", U->CL.name]];
        
        
    }else{
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"ミス！%@はダメージを受けていない！", U->CL.name]];
    }
SKIP1:
    [battleDialog setStringValue:message];
    
    U = UTop;
    bLoopFlag = true;
    messageProcess++;
    return;

}

-(void)DisplayMessageMod2A{//攻撃側モビール

    double def2 = (double)31/32;
    NSString *message = @"";
    
    enum{
        RIKU,
        UMI,
        CHU,
        SORA,
    };
    
    enum{
        A,
        B,
        C,
        D,
        E,
        S,
        SS
    };


    if(bLoopFlag) return;
    U = UTop;
    
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    ATTACK *aTop = U->CL.A;
    for(int i = 0;i < crCAL1;i++){
        U->CL.A = U->CL.A->next;
    }
    
    
    if(!battleDef1Flag && !battleDod1Flag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@の%@\n", U->CL.name, U->CL.A->name]];
    
    
    
    dmg = U->CL.A->totalD;
    double val = 1/log(3+U2->C.S_C.MP/64);
    if(U2->C.aura){
        dmg = dmg*val;
    }
    
    costMP = U->CL.A->EN + floor(U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
    U->CL.S_C.EN -= costMP;
    
    hit = U->CL.S_C.MOB + U->C.S_C.HIT;
    hitFix = U->CL.A->hitPercent;
    
    U2A = U->CL.A;
    U->CL.A = aTop;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    
    double hit2 = U->C.S_C.EVA*U->C.S_C.DOD/100;
    
    double hi = U->C.S_C.LUK - U2->C.S_C.LUK;
    if(hi < 0) hi = 0;
    
    hit = 60 + hit/hit2*10 - hit2/hit*10 + hitFix - log(hi+1)*hit2/hit*10;
    if(hit > 100) hit = 100;
    if(U2A->D->sort == 1){
        hit = 100;
    }
    
    healFlag = false;
    
    int wtf = 100;
    if(battleDod2Flag) wtf = 50;
    if(hit - rand()%wtf > 0 && !battleDef1Flag && !battleDod1Flag){
        
        if(U2A->D->sort == 0){
            NSLog(@"修正前のダメージ:%g", dmg);
            dmg = [self dmgResist:dmg];
            NSLog(@"属性後のダメージ:%g", dmg);
            def2 = pow(def2, U->C.S_C.DEF);
            int omfg = rand()%100;
            NSLog(@"計算式:(%g + %g - %g)", dmg*omfg/100, dmg, U->C.S_C.DEF);
            NSLog(@"ダメージ幅:%g〜%g", (0 + dmg - U->C.S_C.DEF), (dmg/10 + dmg - U->C.S_C.DEF));
            dmg = (dmg*omfg/100/10 + dmg - U->C.S_C.DEF);
            NSLog(@"地形効果:%g - %g", dmg, dmg*MC[chipNum[possionX][possionY]].dmgfix/100);
            if(buildNum[possionX][possionY] < 0) dmg -= dmg*MC[chipNum[possionX][possionY]].dmgfix/100 - 0.5;
            else dmg -= dmg*BC[buildNum[possionX][possionY]].dmgfix/100 - 0.5;
            
            if(U->C.S_C.typeMOVE == RIKU){
                if(U2A->riku == A) dmg = dmg*1.2;
                if(U2A->riku == B) dmg = dmg*1.0;
                if(U2A->riku == C) dmg = dmg*0.6;
                if(U2A->riku == D) dmg = dmg*0.2;
                if(U2A->riku == E) dmg = 0;
                if(U2A->riku == S) dmg = dmg*1.5;
                if(U2A->riku == SS) dmg = dmg*2.0;
            } if(U->C.S_C.typeMOVE == UMI &&
                 (MC[chipNum[possionX][possionY]].type == 3 || MC[chipNum[possionX][possionY]].type == 4)){
                if(U2A->umi == A) dmg = dmg*1.2;
                if(U2A->umi == B) dmg = dmg*1.0;
                if(U2A->umi == C) dmg = dmg*0.6;
                if(U2A->umi == D) dmg = dmg*0.2;
                if(U2A->umi == E) dmg = 0;
                if(U2A->umi == S) dmg = dmg*1.5;
                if(U2A->umi == SS) dmg = dmg*2.0;
            }else if(U->C.S_C.typeMOVE == UMI){
                if(U2A->riku == A) dmg = dmg*1.2;
                if(U2A->riku == B) dmg = dmg*1.0;
                if(U2A->riku == C) dmg = dmg*0.6;
                if(U2A->riku == D) dmg = dmg*0.2;
                if(U2A->riku == E) dmg = 0;
                if(U2A->riku == S) dmg = dmg*1.5;
                if(U2A->riku == SS) dmg = dmg*2.0;
                
            } if(U->C.S_C.typeMOVE == CHU){
                if(U2A->chu == A) dmg = dmg*1.2;
                if(U2A->chu == B) dmg = dmg*1.0;
                if(U2A->chu == C) dmg = dmg*0.6;
                if(U2A->chu == D) dmg = dmg*0.2;
                if(U2A->chu == E) dmg = 0;
                if(U2A->chu == S) dmg = dmg*1.5;
                if(U2A->chu == SS) dmg = dmg*2.0;
            } if(U->C.S_C.typeMOVE == SORA){
                if(U2A->sora == A) dmg = dmg*1.2;
                if(U2A->sora == B) dmg = dmg*1.0;
                if(U2A->sora == C) dmg = dmg*0.6;
                if(U2A->sora == D) dmg = dmg*0.2;
                if(U2A->sora == E) dmg = 0;
                if(U2A->sora == S) dmg = dmg*1.5;
                if(U2A->sora == SS) dmg = dmg*2.0;
            }
            
            NSLog(@"ユニットの地形適用後:%g", dmg);
            if(battleDef2Flag) NSLog(@"防御後のダメージ:%g", dmg/2);
            graze = U->C.S_C.MEN/U2->C.S_C.MEN*U->C.S_C.LUK/3;
            
            grazeFlag = false;
            omfg = rand()%100;
            if(graze > omfg && !healFlag) {dmg = dmg/5;
                grazeFlag = true;
            }
            if(battleDef2Flag) dmg -= dmg*0.5;
            battleDef2Flag = false;
            dmg = floor(dmg);
            if(dmg < 0) dmg = 0;
            U->C.S_C.HP -= dmg;
            
        }else if(U2A->D->sort == 1){
            dmg = dmg + rand()%5*dmg/10 - rand()%5*dmg/10;
            dmg = floor(dmg);
            
            U->CL.S_C.HP += dmg;
            if(U->CL.S_C.HP > U->CL.S_M.HP) U->CL.S_C.HP = U->CL.S_M.HP;
            healFlag = true;
        }
        
        while(1){
            if(U->C.S_C.HP <= 0) {
                U->C.S_C.HP = 0;
                
                messageProcess = 2;
                if(U->dead) break;
                U->dead = true;
                
                
                if(U->targType1L)
                    targType1cnt[0]--;
                if(U->targType2L) {
                    targType2cnt[0]--;
                    targType2Lflag = true;
                }
                
                if(U->targType1D)
                    targType1cnt[1]--;
                if(U->targType2D) {
                    targType2cnt[1]--;
                    targType2Dflag = true;
                }
                
                break;
            }
            break;
        }
        
        [tplayer2 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        [lplayer2 setIntValue:U->C.S_C.HP/U->C.S_M.HP*100];
        
        if(![U2A->msg isEqualToString:@""]){
            
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",
                                                        [self originalMessage:U2A->msg subj:U2->CL.name obje:U->C.name]]];
            
        }
        
        if(grazeFlag) message = [message stringByAppendingString:[NSString stringWithFormat:@"かすりヒット！\n"]];
        if(!healFlag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は%gのダメージを受けた！", U->C.name, dmg]];
        else message = [message stringByAppendingString:[NSString stringWithFormat:@"%@はHPが%g回復した！", U->C.name, dmg]];
    }else if(battleDef1Flag){
        
        
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は身構えている", U->CL.name]];
        
        
    }else if(battleDod1Flag){
        
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は様子をうかがっている", U->CL.name]];
        
        
    }else{
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"ミス！%@はダメージを受けていない！", U->C.name]];
        
    }
    [battleDialog setStringValue:message];
    
    
    U = UTop;
    
    bLoopFlag = true;
    
    if(healFlag) {
        messageProcess++;
    };
    messageProcess++;
    
    return;


}

-(void)DisplayMessageMod2B{
    
    double def2 = (double)31/32;
    NSString *message = @"";
    
    enum{
        RIKU,
        UMI,
        CHU,
        SORA,
    };
    
    enum{
        A,
        B,
        C,
        D,
        E,
        S,
        SS
    };

    
    if(bLoopFlag) return;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    U = UTop;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    
    ATTACK *aTop2 = U->C.A;
    int mostDmg = 0;
    int mostNum = -1;
    int num = 0;
    int mpCost =0;
    if(U->C.A) {
        mpCost = floor(U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
    }
    while(U->C.A){
        mpCost = floor(U->C.A->MP + U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
        if(mostDmg < U->C.A->totalD && U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && U->C.A->D->sort != 1 && mpCost <= U->C.S_C.MP){
            mostDmg = U->C.A->totalD;
            mostNum = num;
        }
        U->C.A = U->C.A->next;
        num++;
    }
    
    U->C.A = aTop2;
    
    if(!battleSet2PushedFlag){
        for(int i = 0;i < mostNumSub;i++){
            U->C.A = U->C.A->next;
        }
        
        if(mostNum < 0) U->C.A = NULL;
    }else{
        for(int i = 0;i < crCAL2;i++){
            U->C.A = U->C.A->next;
        }
    }
    if(U->C.A){
    if(U->C.A->rangeA <= U2->atkRange && U->C.A->rangeB >= U2->atkRange && U->C.A->D->sort != 1){
    }else while(U->CL.A){
        U->C.A = U->C.A->next;
    }
    }
    if(!U->C.A){
        U->C.A = aTop2;
        U = UTop;
        message = [message stringByAppendingString:[NSString stringWithFormat:@"射程外\n"]];
        goto SKIP1;
    }
    if(!U->C.A->name){
        U->C.A = aTop2;
        U = UTop;
        message = [message stringByAppendingString:[NSString stringWithFormat:@"射程外\n"]];
        goto SKIP1;
    }
    
    if(!battleDef2Flag && !battleDod2Flag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@の%@\n", U->C.name, U->C.A->name]];
    
    /*
    if(U->C.A->D->type == 0) dmg = U->C.S_C.ATK + U->C.A->totalD;
    if(U->C.A->D->type == 1) dmg = U->C.S_C.DEF + U->C.A->totalD;
    if(U->C.A->D->type == 2) dmg = U->C.S_C.ACU + U->C.A->totalD;
    if(U->C.A->D->type == 3) dmg = U->C.S_C.EVA + U->C.A->totalD;
    if(U->C.A->D->type == 4) dmg = U->C.S_C.CAP + U->C.A->totalD;
    if(U->C.A->D->type == 5) dmg = U->C.A->totalD;
    */

    double urSupposedToGet;
    
    urSupposedToGet = pow(8, log(3+U->C.A->totalD/16));
    
    double oopsIsRight;
    
    if(U->C.A->melee) oopsIsRight = U->C.S_C.MEL;
    else oopsIsRight = U->C.S_C.MIS;
    
    bool lolFlag = false;
    if(U->C.A->D->type == 0) dmg = (U->C.S_C.ATK + urSupposedToGet)*oopsIsRight/100;
    if(U->C.A->D->type == 1) dmg = (U->C.S_C.DEF + urSupposedToGet)*oopsIsRight/100;
    if(U->C.A->D->type == 2) dmg = (U->C.S_C.ACU + urSupposedToGet)*oopsIsRight/100;
    if(U->C.A->D->type == 3) dmg = (U->C.S_C.EVA + urSupposedToGet)*oopsIsRight/100;
    if(U->C.A->D->type == 4) {
        lolFlag = true;
        dmg = (U->C.S_C.CAP + urSupposedToGet)*oopsIsRight/100;
    }
    if(U->C.A->D->type == 5) dmg = U->C.A->totalD;
    
    costMP = U->C.A->MP + floor(U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
    U->C.S_C.MP -= costMP;
    
    hit = U->C.S_C.ACU*U->C.S_C.HIT/100;
    hitFix = U->C.A->hitPercent;
    
    U2A = U->C.A;
    U->C.A = aTop2;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    hit = 60 + hit/(U->CL.S_C.MOB*U->C.S_C.DOD/100)*10 - (U->CL.S_C.MOB*U->C.S_C.DOD/100)/hit*10 + hitFix;
    if(hit > 100) hit = 100;
    
    battleDod1Flag = false;
    
    int omg = 100;
    if(battleDod1Flag) omg = 50;
    
    if(hit - rand()%omg > 0 && !battleDef2Flag && !battleDod2Flag){
        NSLog(@"修正前のダメージ:%g, %g", dmg, U2A->D->seed);
        
        dmg = [self dmgResist:dmg];
        NSLog(@"属性後のダメージ:%g", dmg);
        def2 = pow(def2, U->CL.S_C.ARM);
        int omfg = rand()%100;
        NSLog(@"計算式:(%g + %g - %g)", dmg*omfg/100, dmg, U->CL.S_C.ARM);
        NSLog(@"ダメージ幅:%g〜%g", (0 + dmg - U->CL.S_C.ARM), (dmg/10 + dmg - U->CL.S_C.ARM));
        if(lolFlag) dmg = (dmg*omfg/100/10 + dmg);
        else dmg = (dmg*omfg/100/10+ dmg - U->CL.S_C.ARM);

        
        NSLog(@"地形効果:%g - %g", dmg, dmg*MC[chipNum[possionX][possionY]].dmgfix/100);
        if(buildNum[possionX][possionY] < 0) dmg -= dmg*MC[chipNum[possionX][possionY]].dmgfix/100 - 0.5;
        else dmg -= dmg*BC[buildNum[possionX][possionY]].dmgfix/100 - 0.5;
        
        if(U->CL.S_C.typeMOVE == RIKU){
            if(U2A->riku == A) dmg = dmg*1.2;
            if(U2A->riku == B) dmg = dmg*1.0;
            if(U2A->riku == C) dmg = dmg*0.6;
            if(U2A->riku == D) dmg = dmg*0.2;
            if(U2A->riku == E) dmg = 0;
            if(U2A->riku == S) dmg = dmg*1.5;
            if(U2A->riku == SS) dmg = dmg*2.0;
        } if(U->CL.S_C.typeMOVE == UMI &&
             (MC[chipNum[possionX][possionY]].type == 3 || MC[chipNum[possionX][possionY]].type == 4)){
            if(U2A->umi == A) dmg = dmg*1.2;
            if(U2A->umi == B) dmg = dmg*1.0;
            if(U2A->umi == C) dmg = dmg*0.6;
            if(U2A->umi == D) dmg = dmg*0.2;
            if(U2A->umi == E) dmg = 0;
            if(U2A->umi == S) dmg = dmg*1.5;
            if(U2A->umi == SS) dmg = dmg*2.0;
        }else if(U->CL.S_C.typeMOVE == UMI){
            if(U2A->riku == A) dmg = dmg*1.2;
            if(U2A->riku == B) dmg = dmg*1.0;
            if(U2A->riku == C) dmg = dmg*0.6;
            if(U2A->riku == D) dmg = dmg*0.2;
            if(U2A->riku == E) dmg = 0;
            if(U2A->riku == S) dmg = dmg*1.5;
            if(U2A->riku == SS) dmg = dmg*2.0;
            
        } if(U->CL.S_C.typeMOVE == CHU){
            if(U2A->chu == A) dmg = dmg*1.2;
            if(U2A->chu == B) dmg = dmg*1.0;
            if(U2A->chu == C) dmg = dmg*0.6;
            if(U2A->chu == D) dmg = dmg*0.2;
            if(U2A->chu == E) dmg = 0;
            if(U2A->chu == S) dmg = dmg*1.5;
            if(U2A->chu == SS) dmg = dmg*2.0;
        } if(U->CL.S_C.typeMOVE == SORA){
            if(U2A->sora == A) dmg = dmg*1.2;
            if(U2A->sora == B) dmg = dmg*1.0;
            if(U2A->sora == C) dmg = dmg*0.6;
            if(U2A->sora == D) dmg = dmg*0.2;
            if(U2A->sora == E) dmg = 0;
            if(U2A->sora == S) dmg = dmg*1.5;
            if(U2A->sora == SS) dmg = dmg*2.0;
        }
        
        NSLog(@"ユニットの地形適用後:%g", dmg);
        
        graze = U->C.S_C.MEN/U2->C.S_C.MEN*U->C.S_C.LUK/3;
        
        grazeFlag = false;
        omfg = rand()&100;
        if(graze > omfg && !healFlag) {dmg = dmg/5;
            grazeFlag = true;
        }
        
        if(battleDef1Flag) dmg -= dmg*0.5;
        battleDef1Flag = false;
        dmg = floor(dmg);
        if(dmg < 0) dmg = 0;
        U->CL.S_C.HP -= dmg;
        
        while(1){
            if(U->CL.S_C.HP <= 0) {
                U->CL.S_C.HP = 0;
                
                messageProcess = 2;
                if(U->dead) break;
                U->dead = true;
               
                
                if(U->targType1L)
                    targType1cnt[0]--;
                if(U->targType2L) {
                    targType2cnt[0]--;
                    targType2Lflag = true;
                }
                
                if(U->targType1D)
                    targType1cnt[1]--;
                if(U->targType2D) {
                    targType2cnt[1]--;
                    targType2Dflag = true;
                }
                
                break;
            }
            break;
        }
        
        
        
        [tplayer1 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        
        [lplayer1 setIntValue:U->CL.S_C.HP/U->CL.S_M.HP*100];
        
        if(![U2A->msg isEqualToString:@""]){
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",
                                                        [self originalMessage:U2A->msg subj:U2->C.name obje:U->CL.name]]];
        }
        
        
        
        if(grazeFlag)
            message = [message stringByAppendingString:[NSString stringWithFormat:@"かすりヒット！\n"]];
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は%gのダメージを受けた！", U->CL.name, dmg]];
        
    }else if(battleDef2Flag){
        
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は身構えている", U->C.name]];
        
        
    }else if(battleDod2Flag){
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は様子をうかがっている", U->C.name]];
        
        
    }else{
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"ミス！%@はダメージを受けていない！", U->CL.name]];
    }
SKIP1:
    [battleDialog setStringValue:message];
    
    U = UTop;
    bLoopFlag = true;
    messageProcess++;
    return;


}

-(void)DisplayMessageMod3A{//防御側モビール

    double def2 = (double)31/32;
    NSString *message = @"";
    
    enum{
        RIKU,
        UMI,
        CHU,
        SORA,
    };
    
    enum{
        A,
        B,
        C,
        D,
        E,
        S,
        SS
    };
    
    if(bLoopFlag) return;
    U = UTop;
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    ATTACK *aTop = U->C.A;
    for(int i = 0;i < crCAL1;i++){
        U->C.A = U->C.A->next;
    }
    
    
    if(!battleDef1Flag && !battleDod1Flag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@の%@\n", U->C.name, U->C.A->name]];
    
    
    /*
    if(U->C.A->D->type == 0) dmg = U->C.S_C.ATK + U->C.A->totalD;
    if(U->C.A->D->type == 1) dmg = U->C.S_C.DEF + U->C.A->totalD;
    if(U->C.A->D->type == 2) dmg = U->C.S_C.ACU + U->C.A->totalD;
    if(U->C.A->D->type == 3) dmg = U->C.S_C.EVA + U->C.A->totalD;
    if(U->C.A->D->type == 4) dmg = U->C.S_C.CAP + U->C.A->totalD;
    if(U->C.A->D->type == 5) dmg = U->C.A->totalD;
    */
    
    double urSupposedToGet;
    
    urSupposedToGet = pow(8, log(3+U->C.A->totalD/16));
    
    double oopsIsRight;
    
    if(U->C.A->melee) oopsIsRight = U->C.S_C.MEL;
    else oopsIsRight = U->C.S_C.MIS;
    bool lolflag = false;
    if(U->C.A->D->type == 0) dmg = (U->C.S_C.ATK + urSupposedToGet)*oopsIsRight/100;
    if(U->C.A->D->type == 1) dmg = (U->C.S_C.DEF + urSupposedToGet)*oopsIsRight/100;
    if(U->C.A->D->type == 2) dmg = (U->C.S_C.ACU + urSupposedToGet)*oopsIsRight/100;
    if(U->C.A->D->type == 3) dmg = (U->C.S_C.EVA + urSupposedToGet)*oopsIsRight/100;
    
    if(U->C.A->D->type == 4){
        lolflag = true;
        dmg = (U->C.S_C.CAP + U->C.A->totalD)*oopsIsRight/100;
    
    }
    if(U->C.A->D->type == 5) dmg = U->C.A->totalD;
    double val2 = log(3+U2->C.S_C.MP/64);
        if(U->C.aura){
            dmg = dmg*val2;
        }
    
    costMP = U->C.A->MP + floor(U->C.A->pMP*U->C.S_M.MP/100 + 0.5);
    U->C.S_C.MP -= costMP;
    
    hit = U->C.S_C.ACU*U->C.S_C.HIT/100;
    hitFix = U->C.A->hitPercent;
    
    U2A = U->C.A;
    U->C.A = aTop;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    hit = 60 + hit/(U->CL.S_C.MOB*U->C.S_C.DOD/100)*10 - (U->CL.S_C.MOB*U->C.S_C.DOD/100)/hit*10 + hitFix;
    if(hit > 100) hit = 100;
    if(U2A->D->sort == 1){
        hit = 100;
    }
    
    healFlag = false;
    
    int wtf = 100;
    if(battleDod2Flag) wtf = 50;
    if(hit - rand()%wtf > 0 && !battleDef1Flag && !battleDod1Flag){
        
        if(U2A->D->sort == 0){
            NSLog(@"修正前のダメージ:%g", dmg);
            dmg = [self dmgResist:dmg];
            NSLog(@"属性後のダメージ:%g", dmg);
            def2 = pow(def2, U->CL.S_C.ARM);
            int omfg = rand()%100;
            NSLog(@"計算式:(%g + %g - %g)", dmg*omfg/100, dmg, (U->CL.S_C.ARM));
            NSLog(@"ダメージ幅:%g〜%g", (0 + dmg - U->CL.S_C.ARM), (dmg/10 + dmg - U->CL.S_C.ARM));
            if(lolflag) dmg = (dmg*omfg/100/10 + dmg);
            else dmg = (dmg*omfg/100/10 + dmg - U->CL.S_C.ARM);
            NSLog(@"地形効果:%g - %g", dmg, dmg*MC[chipNum[possionX][possionY]].dmgfix/100);
            if(buildNum[possionX][possionY] < 0) dmg -= dmg*MC[chipNum[possionX][possionY]].dmgfix/100 - 0.5;
            else dmg -= dmg*BC[buildNum[possionX][possionY]].dmgfix/100 - 0.5;
            
            if(U->CL.S_C.typeMOVE == RIKU){
                if(U2A->riku == A) dmg = dmg*1.2;
                if(U2A->riku == B) dmg = dmg*1.0;
                if(U2A->riku == C) dmg = dmg*0.6;
                if(U2A->riku == D) dmg = dmg*0.2;
                if(U2A->riku == E) dmg = 0;
                if(U2A->riku == S) dmg = dmg*1.5;
                if(U2A->riku == SS) dmg = dmg*2.0;
            } if(U->CL.S_C.typeMOVE == UMI &&
                 (MC[chipNum[possionX][possionY]].type == 3 || MC[chipNum[possionX][possionY]].type == 4)){
                if(U2A->umi == A) dmg = dmg*1.2;
                if(U2A->umi == B) dmg = dmg*1.0;
                if(U2A->umi == C) dmg = dmg*0.6;
                if(U2A->umi == D) dmg = dmg*0.2;
                if(U2A->umi == E) dmg = 0;
                if(U2A->umi == S) dmg = dmg*1.5;
                if(U2A->umi == SS) dmg = dmg*2.0;
            }else if(U->CL.S_C.typeMOVE == UMI){
                if(U2A->riku == A) dmg = dmg*1.2;
                if(U2A->riku == B) dmg = dmg*1.0;
                if(U2A->riku == C) dmg = dmg*0.6;
                if(U2A->riku == D) dmg = dmg*0.2;
                if(U2A->riku == E) dmg = 0;
                if(U2A->riku == S) dmg = dmg*1.5;
                if(U2A->riku == SS) dmg = dmg*2.0;
                
            } if(U->CL.S_C.typeMOVE == CHU){
                if(U2A->chu == A) dmg = dmg*1.2;
                if(U2A->chu == B) dmg = dmg*1.0;
                if(U2A->chu == C) dmg = dmg*0.6;
                if(U2A->chu == D) dmg = dmg*0.2;
                if(U2A->chu == E) dmg = 0;
                if(U2A->chu == S) dmg = dmg*1.5;
                if(U2A->chu == SS) dmg = dmg*2.0;
            } if(U->CL.S_C.typeMOVE == SORA){
                if(U2A->sora == A) dmg = dmg*1.2;
                if(U2A->sora == B) dmg = dmg*1.0;
                if(U2A->sora == C) dmg = dmg*0.6;
                if(U2A->sora == D) dmg = dmg*0.2;
                if(U2A->sora == E) dmg = 0;
                if(U2A->sora == S) dmg = dmg*1.5;
                if(U2A->sora == SS) dmg = dmg*2.0;
            }
            
            NSLog(@"ユニットの地形適用後:%g", dmg);
            if(battleDef2Flag) NSLog(@"防御後のダメージ:%g", dmg/2);
            graze = U->C.S_C.MEN/U2->C.S_C.MEN*U->C.S_C.LUK/3;
            
            grazeFlag = false;
            omfg = rand()%100;
            if(graze > omfg && !healFlag) {dmg = dmg/5;
                grazeFlag = true;
            }
            if(battleDef2Flag) dmg -= dmg*0.5;
            battleDef2Flag = false;
            dmg = floor(dmg);
            if(dmg < 0) dmg = 0;
            U->CL.S_C.HP -= dmg;
            
        }else if(U2A->D->sort == 1){
            dmg = dmg + rand()%5*dmg/10 - rand()%5*dmg/10;
            dmg = floor(dmg);
            
            U->C.S_C.HP += dmg;
            if(U->C.S_C.HP > U->C.S_M.HP) U->C.S_C.HP = U->C.S_M.HP;
            healFlag = true;
        }
        
        while(1){
            if(U->CL.S_C.HP <= 0) {
                U->CL.S_C.HP = 0;
                
                messageProcess = 2;
                if(U->dead) break;
                U->dead = true;
                
                
                if(U->targType1L)
                    targType1cnt[0]--;
                if(U->targType2L) {
                    targType2cnt[0]--;
                    targType2Lflag = true;
                }
                
                if(U->targType1D)
                    targType1cnt[1]--;
                if(U->targType2D) {
                    targType2cnt[1]--;
                    targType2Dflag = true;
                }
                
                break;
            }
            break;
        }
        
        [tplayer2 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->CL.S_C.HP, U->CL.S_M.HP]];
        [lplayer2 setIntValue:U->CL.S_C.HP/U->CL.S_M.HP*100];
        
        if(![U2A->msg isEqualToString:@""]){
            
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",
                                                        [self originalMessage:U2A->msg subj:U2->C.name obje:U->CL.name]]];
            
        }
        
        if(grazeFlag) message = [message stringByAppendingString:[NSString stringWithFormat:@"かすりヒット！\n"]];
        if(!healFlag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は%gのダメージを受けた！", U->CL.name, dmg]];
        else message = [message stringByAppendingString:[NSString stringWithFormat:@"%@はHPが%g回復した！", U->CL.name, dmg]];
    }else if(battleDef1Flag){
        
        
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は身構えている", U->C.name]];
        
        
    }else if(battleDod1Flag){
        
        U = UTop;
        while (!(AUN[1] == U->number)) {
            U = U->next;
        }
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は様子をうかがっている", U->C.name]];
        
        
    }else{
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"ミス！%@はダメージを受けていない！", U->CL.name]];
        
    }
    [battleDialog setStringValue:message];
    
    
    U = UTop;
    
    bLoopFlag = true;
    
    if(healFlag) {
        messageProcess++;
    };
    messageProcess++;
    
    return;

}

-(void)DisplayMessageMod3B{

    
    double def2 = (double)31/32;
    NSString *message = @"";
    
    enum{
        RIKU,
        UMI,
        CHU,
        SORA,
    };
    
    enum{
        A,
        B,
        C,
        D,
        E,
        S,
        SS
    };

    
    if(bLoopFlag) return;
    U = UTop;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    U2 = U;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    ATTACK *aTop2 = U->CL.A;
    int mostDmg = 0;
    int mostNum = -1;
    int num = 0;
    int mpCost =0;
    if(U->CL.A) {
        mpCost = floor(U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
    }
    while(U->CL.A){
        mpCost = floor(U->CL.A->EN + U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
        if(mostDmg < U->CL.A->totalD && U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && U->CL.A->D->sort != 1 && mpCost <= U->CL.S_C.EN){
            mostDmg = U->CL.A->totalD;
            mostNum = num;
        }
        U->CL.A = U->CL.A->next;
        num++;
    }
    
    if(mostNum < 0) U->C.A = NULL;
    
    U->CL.A = aTop2;
    
    if(!battleSet2PushedFlag){
        for(int i = 0;i < mostNumSub;i++){
            U->CL.A = U->CL.A->next;
        }
        
        
    }else{
        for(int i = 0;i < crCAL2;i++){
            U->CL.A = U->C.A->next;
        }
    }
    
    if(U->CL.A->rangeA <= U2->atkRange && U->CL.A->rangeB >= U2->atkRange && U->CL.A->D->sort != 1){
    }else while(U->CL.A){
        U->CL.A = U->CL.A->next;
    }
    
    if(!U->CL.A){
        U->CL.A = aTop2;
        U = UTop;
        message = [message stringByAppendingString:[NSString stringWithFormat:@"射程外\n"]];
        goto SKIP1;
    }
    
    if(!battleDef2Flag && !battleDod2Flag) message = [message stringByAppendingString:[NSString stringWithFormat:@"%@の%@\n", U->CL.name, U->CL.A->name]];
    
    
    

    dmg = U->CL.A->totalD;
    
    costMP = U->CL.A->EN + floor(U->CL.A->pEN*U->CL.S_M.EN/100 + 0.5);
    U->CL.S_C.EN -= costMP;
    
    hit = U->CL.S_C.MOB + U->C.S_C.HIT;
    hitFix = U->CL.A->hitPercent;
    
    U2A = U->CL.A;
    U->CL.A = aTop2;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    
    double hit2 = U->C.S_C.EVA*U->C.S_C.DOD/100;
    
    double hi = U->C.S_C.LUK - U2->C.S_C.LUK;
    if(hi < 0) hi = 0;
    
    hit = 60 + hit/hit2*10 - hit2/hit*10 + hitFix - log(hi+1)*hit2/hit*10;
    if(hit > 100) hit = 100;
    
    battleDod1Flag = false;
    
    int omg = 100;
    if(battleDod1Flag) omg = 50;
    
    if(hit - rand()%omg > 0 && !battleDef2Flag && !battleDod2Flag){
        NSLog(@"修正前のダメージ:%g", dmg);
        dmg = [self dmgResist:dmg];
        NSLog(@"属性後のダメージ:%g", dmg);
        def2 = pow(def2, U->C.S_C.DEF);
        int omfg = rand()%100;
        NSLog(@"計算式:(%g + %g - %g)", dmg*omfg/100, dmg, U->C.S_C.DEF);
        NSLog(@"ダメージ幅:%g〜%g", (0 + dmg - U->C.S_C.DEF), (dmg/10 + dmg - U->C.S_C.DEF));
        dmg = (dmg*omfg/100/10 + dmg - U->C.S_C.DEF);
        
        
        NSLog(@"地形効果:%g - %g", dmg, dmg*MC[chipNum[possionX][possionY]].dmgfix/100);
        if(buildNum[possionX][possionY] < 0) dmg -= dmg*MC[chipNum[possionX][possionY]].dmgfix/100 - 0.5;
        else dmg -= dmg*BC[buildNum[possionX][possionY]].dmgfix/100 - 0.5;
        
        if(U->C.S_C.typeMOVE == RIKU){
            if(U2A->riku == A) dmg = dmg*1.2;
            if(U2A->riku == B) dmg = dmg*1.0;
            if(U2A->riku == C) dmg = dmg*0.6;
            if(U2A->riku == D) dmg = dmg*0.2;
            if(U2A->riku == E) dmg = 0;
            if(U2A->riku == S) dmg = dmg*1.5;
            if(U2A->riku == SS) dmg = dmg*2.0;
        } if(U->C.S_C.typeMOVE == UMI &&
             (MC[chipNum[possionX][possionY]].type == 3 || MC[chipNum[possionX][possionY]].type == 4)){
            if(U2A->umi == A) dmg = dmg*1.2;
            if(U2A->umi == B) dmg = dmg*1.0;
            if(U2A->umi == C) dmg = dmg*0.6;
            if(U2A->umi == D) dmg = dmg*0.2;
            if(U2A->umi == E) dmg = 0;
            if(U2A->umi == S) dmg = dmg*1.5;
            if(U2A->umi == SS) dmg = dmg*2.0;
        }else if(U->C.S_C.typeMOVE == UMI){
            if(U2A->riku == A) dmg = dmg*1.2;
            if(U2A->riku == B) dmg = dmg*1.0;
            if(U2A->riku == C) dmg = dmg*0.6;
            if(U2A->riku == D) dmg = dmg*0.2;
            if(U2A->riku == E) dmg = 0;
            if(U2A->riku == S) dmg = dmg*1.5;
            if(U2A->riku == SS) dmg = dmg*2.0;
            
        } if(U->C.S_C.typeMOVE == CHU){
            if(U2A->chu == A) dmg = dmg*1.2;
            if(U2A->chu == B) dmg = dmg*1.0;
            if(U2A->chu == C) dmg = dmg*0.6;
            if(U2A->chu == D) dmg = dmg*0.2;
            if(U2A->chu == E) dmg = 0;
            if(U2A->chu == S) dmg = dmg*1.5;
            if(U2A->chu == SS) dmg = dmg*2.0;
        } if(U->C.S_C.typeMOVE == SORA){
            if(U2A->sora == A) dmg = dmg*1.2;
            if(U2A->sora == B) dmg = dmg*1.0;
            if(U2A->sora == C) dmg = dmg*0.6;
            if(U2A->sora == D) dmg = dmg*0.2;
            if(U2A->sora == E) dmg = 0;
            if(U2A->sora == S) dmg = dmg*1.5;
            if(U2A->sora == SS) dmg = dmg*2.0;
        }
        
        NSLog(@"ユニットの地形適用後:%g", dmg);
        
        graze = U->C.S_C.MEN/U2->C.S_C.MEN*U->C.S_C.LUK/3;
        
        grazeFlag = false;
        omfg = rand()&100;
        if(graze > omfg && !healFlag) {dmg = dmg/5;
            grazeFlag = true;
        }
        
        if(battleDef1Flag) dmg -= dmg*0.5;
        battleDef1Flag = false;
        dmg = floor(dmg);
        if(dmg < 0) dmg = 0;
        U->C.S_C.HP -= dmg;
        
        while(1){
            if(U->C.S_C.HP <= 0) {
                U->C.S_C.HP = 0;
                
                messageProcess = 2;
                if(U->dead) break;
                U->dead = true;
               
                
                if(U->targType1L)
                    targType1cnt[0]--;
                if(U->targType2L) {
                    targType2cnt[0]--;
                    targType2Lflag = true;
                }
                
                if(U->targType1D)
                    targType1cnt[1]--;
                if(U->targType2D) {
                    targType2cnt[1]--;
                    targType2Dflag = true;
                }
                
                break;
            }
            break;
        }
        
        
        
        [tplayer1 setStringValue:[NSString stringWithFormat:@"HP %g/%g", U->C.S_C.HP, U->C.S_M.HP]];
        
        [lplayer1 setIntValue:U->C.S_C.HP/U->C.S_M.HP*100];
        
        if(![U2A->msg isEqualToString:@""]){
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@\n",
                                                        [self originalMessage:U2A->msg subj:U2->CL.name obje:U->C.name]]];
        }
        
        
        
        if(grazeFlag)
            message = [message stringByAppendingString:[NSString stringWithFormat:@"かすりヒット！\n"]];
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は%gのダメージを受けた！", U->C.name, dmg]];
        
    }else if(battleDef2Flag){
        
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は身構えている", U->CL.name]];
        
        
    }else if(battleDod2Flag){
        
        U = UTop;
        while (!(DUN[1] == U->number)) {
            U = U->next;
        }
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"%@は様子をうかがっている", U->CL.name]];
        
        
    }else{
        
        message = [message stringByAppendingString:[NSString stringWithFormat:@"ミス！%@はダメージを受けていない！", U->C.name]];
    }
SKIP1:
    [battleDialog setStringValue:message];
    
    U = UTop;
    bLoopFlag = true;
    messageProcess++;
    return;

}

-(NSString*)originalMessage:(NSString*)str subj:(NSString*)subj obje:(NSString*)obje{

    NSString *string;
    NSArray *array;
    NSString *result = @"";
    
    string = [str copy];
    
    array = [string componentsSeparatedByString:@"$subj"];
    
    for(int i = 0;i < [array count];i++){
        if(i != 0)
            result = [[result stringByAppendingString:[NSString stringWithFormat:@"%@", subj]] retain];
        
        result = [[result stringByAppendingString:[array objectAtIndex:i]] retain];
    }
    
    string = [result copy];
    
    array = [string componentsSeparatedByString:@"$obje"];
    
    result = @"";
    
    for(int i = 0;i < [array count];i++){
        if(i != 0)
            result = [[result stringByAppendingString:[NSString stringWithFormat:@"%@", obje]] retain];
        
        result = [[result stringByAppendingString:[array objectAtIndex:i]] retain];
    }
    
    NSLog(@"%@", result);
    
    return result;
}



-(double)dmgResist:(double)DMG{

    if(U2A->D->seed == 0) DMG = DMG * U->C.R_C.blow/100;
    if(U2A->D->seed == 1) DMG = DMG * U->C.R_C.slash/100;
    if(U2A->D->seed == 2) DMG = DMG * U->C.R_C.stub/100;
    if(U2A->D->seed == 3) DMG = DMG * U->C.R_C.arrow/100;
    if(U2A->D->seed == 4) DMG = DMG * U->C.R_C.gun/100;
    if(U2A->D->seed == 5) DMG = DMG * U->C.R_C.shell/100;
    
    if(U2A->D->seed == 6) DMG = DMG * U->C.R_C.flame/100;
    if(U2A->D->seed == 7) DMG = DMG * U->C.R_C.cold/100;
    if(U2A->D->seed == 8) DMG = DMG * U->C.R_C.electoric/100;
    if(U2A->D->seed == 9) DMG = DMG * U->C.R_C.air/100;
    if(U2A->D->seed == 10) DMG = DMG * U->C.R_C.water/100;
    if(U2A->D->seed == 11) DMG = DMG * U->C.R_C.gas/100;
    if(U2A->D->seed == 12) DMG = DMG * U->C.R_C.holy/100;
    if(U2A->D->seed == 13) DMG = DMG * U->C.R_C.dark/100;
    if(U2A->D->seed == 14) DMG = DMG * U->C.R_C.explosion/100;
    if(U2A->D->seed == 15) DMG = DMG * U->C.R_C.blood/100;
    
    if(U2A->D->seed == 16) DMG = DMG * U->C.R_C.paralysis/100;
    if(U2A->D->seed == 17) DMG = DMG * U->C.R_C.confusion/100;
    if(U2A->D->seed == 18) DMG = DMG * U->C.R_C.poison/100;
    if(U2A->D->seed == 19) DMG = DMG * U->C.R_C.sleep/100;
    if(U2A->D->seed == 20) DMG = DMG * U->C.R_C.charm/100;
    if(U2A->D->seed == 21) DMG = DMG * U->C.R_C.silent/100;
    
    return DMG;
}

-(IBAction)battleStart:(id)sender{
    battleFlag = false;
    battleRdy = true;
    battleSet1Flag = false;
    battleSet2Flag = false;
    battleSettingFlag = false;
    [self AttackDisplay];
    
    windowPoint.x = [mapWindow frame].origin.x;
    windowPoint.y = [mapWindow frame].origin.y;
    [battleWindow setFrameOrigin:windowPoint];
    [battleWindow makeKeyAndOrderFront:nil];
    [battlePanel close];
}


-(void)battleStartCPU{
    battleFlag = false;
    battleRdy = true;
    battleSet1Flag = false;
    battleSet2Flag = false;
    battleSettingFlag = false;
    [self AttackDisplay];
    
    windowPoint.x = [mapWindow frame].origin.x;
    windowPoint.y = [mapWindow frame].origin.y;
    [battleWindow setFrameOrigin:windowPoint];
    [battleWindow makeKeyAndOrderFront:nil];
    [battlePanel close];
}

-(IBAction)battleSet1:(id)sender{
    battleSet1Flag = true;
    battleDef1Flag = false;
    battleDod1Flag = false;
    battleSettingFlag = true;
    battleSet2PushedFlag = false;
    
    U = UTop;
    while (!(AUN[1] == U->number)) {
        U = U->next;
    }
    if(U->chipNumberL >= 0)
    {
        U = UTop;
        [self initCAttackList2];
        [self initCAttackSelect2];
    }
    else if(U->chipNumber >= 0) {
        U = UTop;
        [self initCAttackList];
        [self initCAttackSelect];
    }
    U = UTop;
    
    [atkPanel makeKeyAndOrderFront:nil];
}
-(IBAction)battleDef1:(id)sender{
    battleDef1Flag = true;
    battleSet1Flag = false;
    battleDod1Flag = false;
}
-(IBAction)battleDod1:(id)sender{
    battleDod1Flag = true;
    battleDef1Flag = false;
    battleSet1Flag = false;
}
-(IBAction)battleSet2:(id)sender{
    battleSet2Flag = true;
    battleDef2Flag = false;
    battleDod2Flag = false;
    battleSettingFlag = true;
    battleSet2PushedFlag = true;
    
    U = UTop;
    while (!(DUN[1] == U->number)) {
        U = U->next;
    }
    
    if(U->chipNumberL >= 0){
        U = UTop;
        [self initCAttackList2];
        [self initCAttackSelect2];
    }
    else if(U->chipNumber >= 0) {
        U = UTop;
        [self initCAttackList];
        [self initCAttackSelect];
    }
    U = UTop;
    [atkPanel makeKeyAndOrderFront:nil];
}
-(IBAction)battleDef2:(id)sender{
    battleDef2Flag = true;
    battleSet2Flag = false;
    battleDod2Flag = false;
}
-(IBAction)battleDod2:(id)sender{
    battleDod2Flag = true;
    battleDef2Flag = false;
    battleSet2Flag = false;
}

-(IBAction)battleCancel:(id)sender{
    battleFlag = false;
    battleSettingFlag = false;
    
    battleSet2PushedFlag = false;
    
    [battlePanel close];
}

-(IBAction)researchCancel:(id)sender{
    [researchPanel close];
}

-(void)setCommandPanel{
    
    if(buildSkillFlag) cIncludeCreateFlag = true;
    else cIncludeCreateFlag = false;
    if(summonSkillFlag) cIncludeSummonFlag = true;
    else cIncludeSummonFlag = false;
    
    menuPoint.x = [mapWindow frame].origin.x + 200;
    menuPoint.y = [mapWindow frame].origin.y + 200;
    
    int plusBtnValue = 0;
    
    if(cIncludeCreateFlag && cIncludeSummonFlag){
        
        plusBtnValue = 200;
        [commandPanel setFrame:NSMakeRect(menuPoint.x, menuPoint.y, 150, plusBtnValue) display:YES];
        
        
        plusBtnValue -= moveBtn.frame.size.height + 12;
        [moveBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:moveBtn];
        
        plusBtnValue -= attackBtn.frame.size.height + 2;
        [attackBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:attackBtn];
        
        plusBtnValue -= stanbyBtn.frame.size.height + 2;
        [stanbyBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:stanbyBtn];
        
        [createBtn setTransparent: NO];
        [createBtn setEnabled: YES];
        plusBtnValue -= createBtn.frame.size.height + 2;
        [createBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:createBtn];
        
        [summonBtn setTransparent: NO];
        [summonBtn setEnabled: YES];
        plusBtnValue -= summonBtn.frame.size.height + 2;
        [summonBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:summonBtn];
        
        plusBtnValue -= statusBtn.frame.size.height + 2;
        [statusBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:statusBtn];
        
        plusBtnValue -= cancelBtn.frame.size.height + 2;
        [cancelBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:cancelBtn];
        
    }
    else if(cIncludeCreateFlag && !cIncludeSummonFlag){
        plusBtnValue = 180;
        [commandPanel setFrame:NSMakeRect(menuPoint.x, menuPoint.y, 150, plusBtnValue) display:YES];
        
        plusBtnValue -= moveBtn.frame.size.height + 12;
        [moveBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:moveBtn];
        
        plusBtnValue -= attackBtn.frame.size.height + 2;
        [attackBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:attackBtn];
        
        plusBtnValue -= stanbyBtn.frame.size.height + 2;
        [stanbyBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:stanbyBtn];
        
        [createBtn setTransparent: NO];
        [createBtn setEnabled: YES];
        plusBtnValue -= createBtn.frame.size.height + 2;
        [createBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:createBtn];
        
        [summonBtn setTransparent: YES];
        [summonBtn setEnabled: NO];
        
        plusBtnValue -= statusBtn.frame.size.height + 2;
        [statusBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:statusBtn];
        
        plusBtnValue -= cancelBtn.frame.size.height + 2;
        [cancelBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:cancelBtn];
        
        
    }else if(cIncludeSummonFlag && !cIncludeCreateFlag){
        
        [commandPanel setFrame:NSMakeRect(menuPoint.x, menuPoint.y, 150, 210) display:YES];
        
        plusBtnValue = 180;
        [commandPanel setFrame:NSMakeRect(menuPoint.x, menuPoint.y, 150, plusBtnValue) display:YES];
        
        
        plusBtnValue -= moveBtn.frame.size.height + 12;
        [moveBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:moveBtn];
        
        plusBtnValue -= attackBtn.frame.size.height + 2;
        [attackBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:attackBtn];
        
        plusBtnValue -= stanbyBtn.frame.size.height + 2;
        [stanbyBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:stanbyBtn];
        
        [createBtn setTransparent: YES];
        [createBtn setEnabled: NO];
        
        [summonBtn setTransparent: NO];
        [summonBtn setEnabled: YES];
        plusBtnValue -= summonBtn.frame.size.height + 2;
        [summonBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:summonBtn];
        
        plusBtnValue -= statusBtn.frame.size.height + 2;
        [statusBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:statusBtn];
        
        plusBtnValue -= cancelBtn.frame.size.height + 2;
        [cancelBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:cancelBtn];
    }else{
        
        plusBtnValue = 160;
        [commandPanel setFrame:NSMakeRect(menuPoint.x, menuPoint.y, 150, plusBtnValue) display:YES];
        
        plusBtnValue -= moveBtn.frame.size.height + 12;
        [moveBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:moveBtn];
        
        plusBtnValue -= attackBtn.frame.size.height + 2;
        [attackBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:attackBtn];
        
        plusBtnValue -= stanbyBtn.frame.size.height + 2;
        [stanbyBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:stanbyBtn];
        
        [createBtn setTransparent: YES];
        [createBtn setEnabled: NO];
        
        [summonBtn setTransparent: YES];
        [summonBtn setEnabled: NO];
        
        plusBtnValue -= statusBtn.frame.size.height + 2;
        [statusBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:statusBtn];
        
        plusBtnValue -= cancelBtn.frame.size.height + 2;
        [cancelBtn setFrame:NSMakeRect(25, plusBtnValue, 100, 23)];
        [[commandPanel contentView] addSubview:cancelBtn];
    }
    

}

-(void)openMessage{
    [IVimage setHidden:NO];
    [TFname setHidden:NO];
    [TFmessage setHidden:NO];
    [BXname setHidden:NO];
    [BXmessage setHidden:NO];
    [IVimage setEnabled:YES];
    [TFname setEnabled:YES];
    [TFmessage setEnabled:YES];
}

-(void)closeMessage{
    [IVimage setHidden:YES];
    [TFname setHidden:YES];
    [TFmessage setHidden:YES];
    [BXname setHidden:YES];
    [BXmessage setHidden:YES];
    [IVimage setEnabled:NO];
    [TFname setEnabled:NO];
    [TFmessage setEnabled:NO];
}

-(MAPSCRIPT0*)setMessage:(MAPSCRIPT0*)MS0{

    
    if(!messageDialog){
        [self closeMessage];
    }else{
        [self openMessage];
    
        if(!initStringNum){
            msgLvl = 0;
            msgCnt = 0;
            initStringNum = true;
        }
    
    NSString *string = @"";
    
        string = [MS0->S1.str retain];
        msgMax = (int)[string length];
        if(!initImgFlag)
        {
            [self loadImg];
            initImgFlag = true;
        }
        
        [IVimage setImage:MS0->S1.img];
        [TFname setStringValue:MS0->S1.name];
    
        if(msgCnt <= msgMax){
            [TFmessage setStringValue:[string substringToIndex:msgCnt]];
            msgCnt++;
        }
        
        
        if(messageEndFlag){
            MS0->endFlag = true;
            messageEndFlag = false;
        }
        
        return MS0;
    }
    
    
    
}

-(void) loadImg{
    
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSString *path = @"Map/";
    NSString *fileData = nil;
    NSArray *fileDataArray;
    
    path = [path stringByAppendingFormat:@"%@"  ,MF[MFselectedRow+1].fileName];
    
    fileData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    
    MAPSCRIPT0 *MS00 = MF[MFselectedRow+1].MS.D->P;
    MAPSCRIPT0 *m00Top = MS00;
    for (int i = 0; i < [fileDataArray count]; i++) {
        if(!MS00) break;
        NSRange range = [[fileDataArray objectAtIndex:i] rangeOfString:@"◆"];
        if(range.location != NSNotFound){
            
            NSArray *array2 = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@","];
            if(MS00->type == 1)
            {
                MS00->S1.iName = [[array2 objectAtIndex:2] retain];
            
            for(int k = 0; k < UCN;k++){
                
                if([MS00->S1.iName isEqualToString:UC[k].nameClass]){
                    MS00->S1.img = [UC[k].imgb retain];
                    MS00 = MS00->next;
                    break;
                }
            
            }
            }
            
        }
    }
    
    MS00 = m00Top;
    
}


-(MAPSCRIPT0*)setSwitch:(MAPSCRIPT0*)MS0{
    
    if(MS0->switch1)
    for(int i = 0;*(MS0->switch1 + i) >0;i++){
        Suicchi[*(MS0->switch1+i)] = true;
    
    }
    if(MS0->switch2)
    for(int i = 0;*(MS0->switch2 + i) >0;i++){
        Suicchi[*(MS0->switch2+i)] = false;
        
    }
    
    
    MS0 = MS0->endFlag;
    return MS0;
}

-(IBAction)battleReadyUpStartBtn:(id)sender{


    P[0].resource = [battleReadyUpSupply1 intValue];
    P[0].food = [battleReadyUpFood1 intValue];
    P[0].money = [battleReadyUpMoney1 intValue];
    
    P[1].resource = [battleReadyUpSupply2 intValue];
    P[1].food = [battleReadyUpFood2 intValue];
    P[1].money = [battleReadyUpMoney2 intValue];

    setBattleModeFlag = false;
    [bsWindow close];
    
}

-(IBAction)battleReadyUpState1:(id)sender{
    retardhelp1 = true;
}
-(IBAction)battleReadyUpState2:(id)sender{
    retardhelp2 = true;
}

@end
