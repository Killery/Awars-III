//
//  FieldView.m
//  Awars III
//
//  Created by Killery on 2013/02/22.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "FieldView.h"


@implementation FieldView
-(BOOL)isFlipped{
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        time  = [NSTimer
                  scheduledTimerWithTimeInterval:0.01f
                  target:self
                  selector:@selector(EventLoopFV:)
                  userInfo:nil
                  repeats:YES
                  ];
        chip = [[self LoadImage:@"マス.png"] retain];
        chipSelect = [[self LoadImage:@"セレクター.png"] retain];
        chipMove = [[self LoadImage:@"セレクター（移動）.png"] retain];
        chipAttack = [[self LoadImage:@"セレクター（攻撃）.png"] retain];
        chipTarget = [[self LoadImage:@"セレクター（選択）.png"] retain];
        chipSummon = [[self LoadImage:@"セレクター（攻撃）.png"] retain];
        chipTeam0 = [[self LoadImage:@"ハイライト（青）.png"] retain];
        chipTeam1 = [[self LoadImage:@"ハイライト（黄）.png"] retain];
        chipTeam2 = [[self LoadImage:@"ハイライト（赤）.png"] retain];
        
        n1 = [[self LoadImage:@"num1"] retain];
        n2 = [[self LoadImage:@"num2"] retain];
        n3 = [[self LoadImage:@"num3"] retain];
        n4 = [[self LoadImage:@"num4"] retain];
        n5 = [[self LoadImage:@"num5"] retain];
        n6 = [[self LoadImage:@"num6"] retain];
        n7 = [[self LoadImage:@"num7"] retain];
        n8 = [[self LoadImage:@"num8"] retain];
        n9 = [[self LoadImage:@"num9"] retain];
        n10 = [[self LoadImage:@"num10"] retain];
        n11 = [[self LoadImage:@"num11"] retain];
        n12 = [[self LoadImage:@"num12"] retain];
        n13 = [[self LoadImage:@"num13"] retain];
        n14 = [[self LoadImage:@"num14"] retain];
        n15 = [[self LoadImage:@"num15"] retain];
        n16 = [[self LoadImage:@"num16"] retain];
        n17 = [[self LoadImage:@"num17"] retain];
        n18 = [[self LoadImage:@"num18"] retain];
        n19 = [[self LoadImage:@"num19"] retain];
        n20 = [[self LoadImage:@"num20"] retain];
        
        g_shallowDepth = 1002;
       
    }
    
    return self;
}


-(void)EventLoopFV:(NSTimer*)timer{
    
    
    if(evInitMap) {evInitMap = false;
        //[self loadMesh:SC[storyNumb].nameMAP index:scenarioNumb];
        /*
        MapView *MV = [MapView alloc];
        [MV loadMapChip];
         */
        NSRect seRect = NSMakeRect(0, 0, chipWidth*32, chipHeight*32);
        [self setFrame:seRect];
        chipNum[0][0] = 0;
        
    }
    static int i0 = 0;
    static int movePlus = 0;
    static int cPosX;
    static int cPosY;
    
    static int chipTargetCnt = 0;
    
    chipTargetCnt++;
    
    if(chipTargetCnt > 60){

        if(!chipTargetFlag) chipTargetFlag = true;
        else chipTargetFlag = false;
        chipTargetCnt = 0;
    }
    
    if(!Uselected)
        Uselected = unitBreak;
    
    if(stanbyFlag){
        if(i0 == 0) {
            unitNum[g_moveRoute[i0][1]][g_moveRoute[i0][0]] = -1;
            unitTeam[g_moveRoute[i0][1]][g_moveRoute[i0][0]] = -1;
            loadNum[g_moveRoute[i0][1]][g_moveRoute[i0][0]] = -1;
            U = UTop;
            while(U != NULL){
                if(g_moveRoute[0][1] == U->x && g_moveRoute[0][0] == U->y){
                    U->x = g_moveRoute[g_shallowDepth-1][1];
                    U->y = g_moveRoute[g_shallowDepth-1][0];
                    break;
                }
                U = U->next;
            }
            U = UTop;
        }
    if(!submitFlag) movePlus += 4;
    if( i0 < g_shallowDepth && movePlus >= 32)
    {
        cPosX = g_moveRoute[i0][1]*32;
        cPosY = g_moveRoute[i0][0]*32;
        i0++;
        movePlus = 0;
        currentPosX = cPosX;
        currentPosY = cPosY;
        unitMoveBugFixFlag = true;
    }
        if(i0 >= g_shallowDepth) {i0--;
            unitNum[g_moveRoute[i0][1]][g_moveRoute[i0][0]] = UCselected.chipNumb;
            loadNum[g_moveRoute[i0][1]][g_moveRoute[i0][0]] = LCselected.chipNumb;
            unitTeam[g_moveRoute[i0][1]][g_moveRoute[i0][0]] = Uselected->team;
            submitFlag = true;
            unitMoveEndFlag = true;
            unitMoveBugFixFlag = false;
            i0 = 0;
        }
        
    }else submitFlag = false;
    
    U = UTop;
    while (U != NULL) {
        if(U->dead){
            unitNum[U->x][U->y] = -1;
            unitTeam[U->x][U->y] = -1;
            U->x = -1;
            U->y = -1;
        }
        U = U->next;
    }
    U = UTop;
    
    
    if(1){
        U = UTop;
        slctedUnitNum = 0;
        while(U != NULL){
            if(U->x == possionX && U->y == possionY){
                break;
            }
            slctedUnitNum++;
            U = U->next;
        }
        if(!U) slctedUnitNum = -1;
        U = UTop;
        
    }
    
    if(dcRdy){
        U = UTop;
        for (int i = 0; i < slctedUnitNum; i++) {
            U = U->next;
        }
        if(U->chipNumberL < 0){
            U = UTop;
            
            while(U && !(possionX == U->x && possionY == U->y)){
                U = U->next;
            }
            
            [self LookupAttackRange:possionY startY:possionX aPiece:&U->C turnSide:YES];
            U = UTop;
        }else {
            U = UTop;
            [self LookupAttackRange2:possionY startY:possionX aPiece:&LC[loadNum[possionX][possionY]] turnSide:YES];
        }
        U = UTop;
            
        dcRdy = false;
    }
    if(bclRdy){
        U = UTop;
        for (int i = 0; i < slctedUnitNum; i++) {
            U = U->next;
        }
        
        buildNum[possionX][possionY] = U->C.S->list[crBCL]-1;
        
        U = UTop;
        bclRdy = false;
        
        createFlag = false;
    }

    if(unitColorInitFlag){
        U = UTop;
        while(U){
            if(!U->CL.nameID){
                if(U->team == 0) U->img = [self SetImageColor:U->C.img color:0];
                if(U->team == 1) U->img = [self SetImageColor:U->C.img color:1];
                if(U->team == 2) U->img = [self SetImageColor:U->C.img color:2];
            }else{
                if(U->team == 0)
                    U->img = [self SetImageColor:U->CL.img color:0];
                if(U->team == 1)
                    U->img = [self SetImageColor:U->CL.img color:1];
                if(U->team == 2)
                    U->img = [self SetImageColor:U->CL.img color:2];
            }
            U = U->next;
        }U = UTop;
        
        BTop = B;
        while(B){
            if(B->team < 0) B->img = B->C.img;
            if(B->team == 0) B->img = [self SetImageColor:B->C.img color:0];
            if(B->team == 1) B->img = [self SetImageColor:B->C.img color:1];
            if(B->team == 2) B->img = [self SetImageColor:B->C.img color:2];
            B = B->next;
        }B = BTop;
        
        
        unitColorInitFlag = false;
        
    }
    if(Uselected)
    if(Uselected->dead){
        Uselected = NULL;
    }
    
    if(cslRdy){
        [self LookupSummonRange:possionY startY:possionX aPiece:&UC[unitNum[possionX][possionY]] turnSide:YES];
        cslRdy = false;
    }
    
    if(buildCaptureFlag && unitMoveEndFlag){
        
        BTop = B;
        while (B) {
            if(B->x == possionX && B->y == possionY){
                if(Uselected->team == 0) B->team = 0;
                if(Uselected->team == 1) B->team = 1;
                if(Uselected->team == 2) B->team = 2;
                unitColorInitFlag = true;
            }
            B = B->next;
        }B = BTop;
    
        buildCaptureFlag = false;
    }
    
    if(cpuAImodeflag){
        
        //if(unitBreak->CPU) cpuTurnEndFlag = false;
        
        if(!cpuTurnEndFlag){
            [self modeCPUturn];
        }
        
    }
    
    
    if(fieldViewBattleInitFlag){
        
    }
    
    chipNum[0][0]= 0;
    [self setNeedsDisplay:YES];
}

-(NSImage*)SetImageColor:(NSImage*)image color:(int)c{
    NSImage *maskBlue, *maskRed, *maskYellow;
    
    maskBlue = [NSImage imageNamed:@"ハイライト（青）"];
    maskRed = [NSImage imageNamed:@"ハイライト（赤）"];
    maskYellow = [NSImage imageNamed:@"ハイライト（黄）"];
    
    NSImage *img = [NSImage alloc];
    img = [image copy];
    
    if(c == 0){
    [img lockFocus];
    //[image drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, maskBlue.size.width, maskBlue.size.height) operation:NSCompositeClear fraction:1.0];
        
    [maskBlue drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, maskBlue.size.width, maskBlue.size.height) operation:NSCompositeXOR fraction:1.0];
    
    [maskBlue drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, maskBlue.size.width, maskBlue.size.height) operation:NSCompositeXOR fraction:1.0];
    
    [img drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, image.size.width, image.size.height) operation:NSCompositeSourceOver fraction:0.6];
    
    [img unlockFocus];
    
    }
    
    if(c == 1){
        [img lockFocus];
        
        [maskYellow drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, maskBlue.size.width, maskBlue.size.height) operation:NSCompositeXOR fraction:1.0];
        
        [maskYellow drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, maskBlue.size.width, maskBlue.size.height) operation:NSCompositeXOR fraction:1.0];
        
        [img drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, image.size.width, image.size.height) operation:NSCompositeSourceOver fraction:0.6];
        
        [img unlockFocus];
    }
    
    if(c == 2){
        [img lockFocus];
        
        [maskRed drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, maskBlue.size.width, maskBlue.size.height) operation:NSCompositeXOR fraction:1.0];
        
        [maskRed drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, maskBlue.size.width, maskBlue.size.height) operation:NSCompositeXOR fraction:1.0];
        
        [img drawInRect:NSMakeRect(0, 0, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, image.size.width, image.size.height) operation:NSCompositeSourceOver fraction:0.6];
        
        [img unlockFocus];
    }
    
    return img;
}

-(NSImage*)LoadImage:(NSString*)name{
    NSImage *image = [NSImage imageNamed:name];
    if(image == nil) return nil;
    //[image setFlipped:[self isFlipped]];
    
    return image;
}

-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy f:(float)frac{
    NSRect frRect;
    frRect.size.height = image.size.height;
    frRect.size.width = image.size.width;
    
    frRect.origin.x = 0;
    frRect.origin.y = 0;
    
    NSRect drRect;
    drRect.origin.x = x;
    drRect.origin.y = y;
    drRect.size.height = 32;
    drRect.size.width = 32;
    
    [image drawInRect:drRect fromRect:frRect operation:NSCompositeSourceOver fraction:frac respectFlipped:YES hints:nil];
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    
    if(setBattleModeFlag) return;
    
    if(endGameCondition) return;
    
    if(messageDialog){
        
        
        if(msgCnt >= msgMax){
            msgLvl++;
            msgCnt = 0;
            messageEndFlag = true;
        }else{
            msgCnt = msgMax-1;
        }
        
    
        return;
    }
    
    if(cpuAImodeflag)
        return;
    
    if(P[1].type == 1){
        
        U = UTop;
        while (U) {
            if(unitBreak->team == 2){
                U = UTop;
                return;
            }
            U = U->next;
        }
        U = UTop;
    }
    
    drugPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    possionX = (int)drugPoint.x/32+1;
    possionY = (int)drugPoint.y/32+1;
    
    menuDisplayFlag = false;
    
    U = UTop;
    if(attackFlag && g_attackRange[possionX][possionY] > 0 && unitNum[possionX][possionY] >= 0){
        
        attackFlag = false;
        battleWindowFlag = true;
        
        U = UTop;
        while (AUN[1] != U->number) {
            U = U->next;
        }
        ATTACK *aTop = U->C.A;
        ATTACK *aTop2 = U->CL.A;
        if(U->chipNumberL < 0){
            for(int i = 0;i < crCAL;i++){
                U->C.A = U->C.A->next;
            }
        }else{
            for(int i = 0;i < crCAL;i++){
                U->CL.A = U->CL.A->next;
            }
        }
        
        if(U->chipNumberL < 0)
            U->atkRange = U->C.A->rangeB - g_attackRange[possionX][possionY] + 1;
        else U->atkRange = U->CL.A->rangeB - g_attackRange[possionX][possionY] + 1;
        
        U->atkRange = U->atkRange;
        U->C.A = aTop;
        U->CL.A = aTop2;
        
        U = UTop;
        while (!(U->x == possionX && U->y == possionY)) {
            U = U->next;
        }
        DUN[1] = U->number;
        U = UTop;
        
        wtAttackedFlag = true;
        return;
    }U = UTop;
    
    if(summonFlag && g_summonRange[possionX][possionY] > 0 && unitNum[possionX][possionY] < 0){
    
        summonRdyFlag = true;
        summonFlag = false;
        
    }
    
    
    if(unitNum[possionX][possionY] >= 0){
        
        moveFlag = false;
        attackFlag = false;
        stanbyFlag = false;
        menuDisplayFlag = true;
        unitMoveEndFlag = false;
        g_cursol_x = 1+(int)drugPoint.y/32;
        g_cursol_y = 1+(int)drugPoint.x/32;
        currentPosX = g_cursol_y*32;
        currentPosY = g_cursol_x*32;
        
        UCselected = UC[unitNum[possionX][possionY]];
        LCselected = LC[loadNum[possionX][possionY]];
        
        U = UTop;
        while (U) {
            if(U->x == possionX && U->y == possionY) break;
            U = U->next;
        }
        if(U){
            AUN[1] = U->number;
            Uselected = U;
        }
        
        if(U->chipNumber >= 0) [self LookupMovableRange:possionY startY:possionX aPiece:&UC[unitNum[possionX][possionY]] turnSide:YES];
        if(U->chipNumberL >= 0) [self LookupMovableRange2:possionY startY:possionX aPiece:&LC[loadNum[possionX][possionY]] turnSide:YES];
        
        U = UTop;

        //return;
    }
    
    if(buildNum[possionX][possionY] >= 0 && unitNum[possionX][possionY] < 0 && !moveFlag){
        //NSLog(@"くりとりすとおちんちん");
        BTop = B;
        while (B) {
            if(B->x == possionX && B->y == possionY){
                researchTeam = -1;
                if(B->team == 0){
                    researchTeam = 0;
                    break;
                }
                if(B->team == 2){
                    researchTeam = 2;
                    break;
                }
            }
            B = B->next;
        }B = BTop;
        
        if (researchTeam < 0) {
            
        }else{
            stanbyFlag = false;
            buildSelectedFlag = true;
        }
    }
    
    if(moveFlag && g_selectRange[possionX][possionY] > 0){
        g_target_y = possionX;
        g_target_x = possionY;
        
        [self searchRoute];
        
        for(int i = 0;i<=chipWidth;i++){
            for(int j = 0;j<=chipHeight;j++){
                g_map[j][i] = chipNum[j][i];
                g_selectRange[j][i] = 0;
            }
        }
        moveFlag = false;
        stanbyFlag = true;
        wtPx = possionX;
        wtPy = possionY;
        wtMovedFlag = true;
        BTop = B;
        while (B) {
            if(B->x == possionX && B->y == possionY && B->C.capture){
                buildCaptureFlag = true;
            }
            B = B->next;
        }B = BTop;

    }
    
    summonFlag = false;
    
    pushStanbyFlag = false;
}




//-----------------------------------------------------------LookupMovableRange
//
// 与えられた位置からの移動可能範囲をg_range配列内に収める
//
//-----------------------------------------------------------------------------
-(void)LookupMovableRange:(int)startX startY:(int)startY aPiece:(UNITCHIP*)aPiece turnSide:(BOOL)turnSide
{
    if(!aPiece->nameID) return;
    
    for(int i = 0;i<=chipWidth;i++){
        for(int j = 0;j<=chipHeight;j++){
            g_map[j][i] = -1;
            g_selectRange[j][i] = 999;
        }
    }
    
    for(int i = 1;i<=chipWidth;i++){
        for(int j = 1;j<=chipHeight;j++){
            g_map[j][i] = chipNum[j][i];
            g_selectRange[j][i] = 0;
        }
    }
    
    //0 リク　1宙 2海 3空
    //0 草原 1荒地
    enum{
        MOVETYPE_RIKU,
        MOVETYPE_CHU,
        MOVETYPE_UMI,
        MOVETYPE_SORA,
    };
    for(int chipType = 0;chipType < 128;chipType++){
        g_moveCost[MOVETYPE_RIKU][chipType] = MC[chipType].riku;
        g_moveCost[MOVETYPE_CHU][chipType] = MC[chipType].chu;
        g_moveCost[MOVETYPE_UMI][chipType] = MC[chipType].umi;
        g_moveCost[MOVETYPE_SORA][chipType] = MC[chipType].sora;
    }
    
    g_selectRange[startY][startX] = aPiece->S_C.MOV+1;
    //[self excludePiece:turnSide fillInt:99];
    // 敵方のコマを迂回させるため、マップ移動最大値を詰め込む
    //[self excludePiece:turnSide fillInt:0];
    [self checkRange:startX startY:startY leftPow:aPiece->S_C.MOV+1 pieceType:aPiece->S_C.typeMOVE aMap:g_selectRange];
    //  [self excludePiece:turnSide fillInt:0];
    // 敵方のコマの位置を移動可能範囲から除外する
    //[self excludePiece:turnSide fillInt:0];
    
    
}

-(void)LookupMovableRange2:(int)startX startY:(int)startY aPiece:(LOADCHIP*)aPiece turnSide:(BOOL)turnSide
{
    if(!aPiece->nameID) return;
    
    for(int i = 0;i<=chipWidth;i++){
        for(int j = 0;j<=chipHeight;j++){
            g_map[j][i] = -1;
            g_selectRange[j][i] = 999;
        }
    }
    
    for(int i = 1;i<=chipWidth;i++){
        for(int j = 1;j<=chipHeight;j++){
            g_map[j][i] = chipNum[j][i];
            g_selectRange[j][i] = 0;
        }
    }
    
    //0 リク　1宙 2海 3空
    //0 草原 1荒地
    enum{
        MOVETYPE_RIKU,
        MOVETYPE_CHU,
        MOVETYPE_UMI,
        MOVETYPE_SORA,
    };
    for(int chipType = 0;chipType < 128;chipType++){
        g_moveCost[MOVETYPE_RIKU][chipType] = MC[chipType].riku;
        g_moveCost[MOVETYPE_CHU][chipType] = MC[chipType].chu;
        g_moveCost[MOVETYPE_UMI][chipType] = MC[chipType].umi;
        g_moveCost[MOVETYPE_SORA][chipType] = MC[chipType].sora;
    }
    
    g_selectRange[startY][startX] = aPiece->S_C.MOV+1;
    //[self excludePiece:turnSide fillInt:99];
    // 敵方のコマを迂回させるため、マップ移動最大値を詰め込む
    [self checkRange2:startX startY:startY leftPow:aPiece->S_C.MOV+1 pieceType:aPiece->S_C.typeMOVE aMap:g_selectRange];
    //[self excludePiece:turnSide fillInt:0];
    // 敵方のコマの位置を移動可能範囲から除外する
    
}

//-----------------------------------------------------------------excludePiece
// 選択範囲からコマを除外する
-(void)excludePiece:(BOOL)turnSide fillInt:(int)fillInt
{
    UNIT *UN = U;
    
    
    U = UTop;
    
    while(U){
        for(int x = 1;x <= chipWidth;x++){
            for(int y = 1;y <= chipHeight;y++){
                if(g_selectRange[U->x][U->y] > 0 && U->x == y && U->y == x){
                    g_selectRange[U->x][U->y] = fillInt;
                }
            }
        }
        U = U->next;
    }U = UN;
    g_selectRange[Uselected->x][Uselected->y] = 999;

}

//-------------------------------------------------------------------checkRange
// 再帰法で移動可能範囲をチェックする
// 配列の添え字と関数の引数が逆になっていることに要注意
-(void)checkRange:(int)startX startY:(int)startY leftPow:(int)leftPow pieceType:(int)pieceType aMap:(int[1002][1002])aMap{
    int  i0;

    
    int chipTeam;
    if(Uselected) chipTeam = Uselected->team;
    
    if(startX < 0) startX = 0;
    if(startY < 0) startY = 0;
    
    aMap[startY][startX] = leftPow;// 残り移動力
    

    i0 = leftPow - g_moveCost[pieceType][g_map[startY-1][startX]];  // 上
    
    if(unitNum[startY-1][startX] > -1 && unitTeam[startY-1][startX] != chipTeam){
        i0 = 0;
    }
    if( aMap[startY-1][startX] < i0 ){
        [self checkRange:startX startY:startY - 1 leftPow:i0 pieceType:pieceType aMap:aMap];
    }
    
   
    i0 = leftPow - g_moveCost[pieceType][g_map[startY+1][startX]];  // 下
    if(unitNum[startY+1][startX] > -1 && unitTeam[startY+1][startX] != chipTeam){
        i0 = 0;
    }
    if( aMap[startY+1][startX] < i0 ){
        [self checkRange:startX startY:startY + 1 leftPow:i0 pieceType:pieceType aMap:aMap];
    }
    
    
    i0 = leftPow - g_moveCost[pieceType][g_map[startY][startX-1]];  // 右
    if(unitNum[startY][startX-1] > -1 && unitTeam[startY][startX-1] != chipTeam){
        i0 = 0;
    }
    if( aMap[startY][startX-1] < i0 ){
        [self checkRange:startX - 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap];
    }
    

    i0 = leftPow - g_moveCost[pieceType][g_map[startY][startX+1]];  // 左
    if(unitNum[startY][startX+1] > -1 && unitTeam[startY][startX+1] != chipTeam){
        i0 = 0;
    }
	if( aMap[startY][startX+1] < i0 ){
        [self checkRange:startX + 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap];
    }
    
}

-(void)checkRange2:(int)startX startY:(int)startY leftPow:(int)leftPow pieceType:(int)pieceType aMap:(int[1002][1002])aMap{
    int  i0;
    
    
    int chipTeam;
    if(Uselected) chipTeam = Uselected->team;
    
    if(startX < 0) startX = 0;
    if(startY < 0) startY = 0;
    
    aMap[startY][startX] = leftPow;// 残り移動力
    
    
    i0 = leftPow - g_moveCost[pieceType][g_map[startY-1][startX]];  // 上
    
    if(loadNum[startY-1][startX] > -1 && unitTeam[startY-1][startX] != chipTeam){
        i0 = 0;
    }
    if( aMap[startY-1][startX] < i0 ){
        [self checkRange:startX startY:startY - 1 leftPow:i0 pieceType:pieceType aMap:aMap];
    }
    
    
    i0 = leftPow - g_moveCost[pieceType][g_map[startY+1][startX]];  // 下
    if(loadNum[startY+1][startX] > -1 && unitTeam[startY+1][startX] != chipTeam){
        i0 = 0;
    }
    if( aMap[startY+1][startX] < i0 ){
        [self checkRange:startX startY:startY + 1 leftPow:i0 pieceType:pieceType aMap:aMap];
    }
    
    
    i0 = leftPow - g_moveCost[pieceType][g_map[startY][startX-1]];  // 右
    if(loadNum[startY][startX-1] > -1 && unitTeam[startY][startX-1] != chipTeam){
        i0 = 0;
    }
    if( aMap[startY][startX-1] < i0 ){
        [self checkRange:startX - 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap];
    }
    
    
    i0 = leftPow - g_moveCost[pieceType][g_map[startY][startX+1]];  // 左
    if(loadNum[startY][startX+1] > -1 && unitTeam[startY][startX+1] != chipTeam){
        i0 = 0;
    }
	if( aMap[startY][startX+1] < i0 ){
        [self checkRange:startX + 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap];
    }
    
}


-(void)LookupSummonRange:(int)startX startY:(int)startY aPiece:(UNITCHIP*)aPiece turnSide:(BOOL)turnSide
{
    
    for(int i = 0;i<=chipWidth;i++){
        for(int j = 0;j<=chipHeight;j++){
            g_summonRange[j][i] = 999;
            g_summonRangeDelta[j][i] = 999;
        }
    }
    
    for(int i = 1;i<=chipWidth;i++){
        for(int j = 1;j<=chipHeight;j++){
            g_summonRange[j][i] = 0;
            g_summonRangeDelta[j][i] = 0;
        }
    }
    
    for(int chipType = 0;chipType < 1024;chipType++){
        g_attackCost[0][chipType] = 1;
    }
    
    //0 リク　1宙 2海 3空
    //0 草原 1荒地
    
    ATTACK *aTop = aPiece->A;
    for(int i = 0;i < crCAL;i++){
        aPiece->A = aPiece->A->next;
    }
    
    g_summonRange[startY][startX] = 1;
    g_summonRangeDelta[startY][startX] = 0;
    //attackMaxNum = aPiece->A->rangeB+1;
    
    //[self excludePiece:turnSide fillInt:99];
    // 敵方のコマを迂回させるため、マップ移動最大値を詰め込む
    [self checkSummonRange:startX startY:startY leftPow:2 pieceType:0 aMap:g_summonRange aPiece:aPiece];
    g_summonRange[startY][startX] = 0;
    g_summonRangeDelta[startY][startX] = 0;
    
    for(int i = 0;i<=chipWidth;i++){
        for(int j = 0;j<=chipHeight;j++){
            if(g_summonRangeDelta[i][j] > 0) g_summonRange[i][j] = 0;
        }
    }
    
    aPiece->A = aTop;
    
    //[self excludePiece:turnSide fillInt:0];
    // 敵方のコマの位置を移動可能範囲から除外する
    
}

-(void)checkSummonRange:(int)startX startY:(int)startY leftPow:(int)leftPow pieceType:(int)pieceType aMap:(int[][1002])aMap aPiece:(UNITCHIP*)aPiece{
    int  i0;
    
    if(startX < 0) startX = 0;
    if(startY < 0) startY = 0;
    
    aMap[startY][startX] = leftPow;    // 残り射程の長さ
    
    i0 = leftPow - 1;  // 上
    if( aMap[startY-1][startX] < i0 ){
        [self checkSummonRange:startX startY:startY - 1 leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 下
    if( aMap[startY+1][startX] < i0 ){
        [self checkSummonRange:startX startY:startY + 1 leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 右
    if( aMap[startY][startX-1] < i0 ){
        [self checkSummonRange:startX - 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 左
	if( aMap[startY][startX+1] < i0 ){
        [self checkSummonRange:startX + 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
}


-(void)LookupAttackRange:(int)startX startY:(int)startY aPiece:(UNITCHIP*)aPiece turnSide:(BOOL)turnSide
{
    
    for(int i = 0;i<=chipWidth;i++){
        for(int j = 0;j<=chipHeight;j++){
            g_attackRange[j][i] = 999;
            g_attackRangeDelta[j][i] = 999;
        }
    }
    
    for(int i = 1;i<=chipWidth;i++){
        for(int j = 1;j<=chipHeight;j++){
            g_attackRange[j][i] = 0;
            g_attackRangeDelta[j][i] = 0;
        }
    }
    
    for(int chipType = 0;chipType < 1024;chipType++){
        g_attackCost[0][chipType] = 1;
    }
    
    //0 リク　1宙 2海 3空
    //0 草原 1荒地
    enum{
        MOVETYPE_RIKU,
        MOVETYPE_CHU,
        MOVETYPE_UMI,
        MOVETYPE_SORA,
    };
    
    ATTACK *aTop = aPiece->A;
    for(int i = 0;i < crCAL;i++){
        aPiece->A = aPiece->A->next;
    }
    
    g_attackRange[startY][startX] = aPiece->A->rangeB;
    g_attackRangeDelta[startY][startX] = aPiece->A->rangeA;
    attackMaxNum = aPiece->A->rangeB+1;
    
    //[self excludePiece:turnSide fillInt:99];
    // 敵方のコマを迂回させるため、マップ移動最大値を詰め込む
    if(aPiece->A->rangeB >= 1 && aPiece->A->rangeA >= 0){
        [self checkAttackRange:startX startY:startY leftPow:aPiece->A->rangeB+1 pieceType:0 aMap:g_attackRange aPiece:aPiece];
        [self checkAttackRange:startX startY:startY leftPow:aPiece->A->rangeA pieceType:1 aMap:g_attackRangeDelta aPiece:aPiece];
        g_attackRange[startY][startX] = 0;
        g_attackRangeDelta[startY][startX] = 0;
        
        for(int i = 0;i<=chipWidth;i++){
            for(int j = 0;j<=chipHeight;j++){
                if(g_attackRangeDelta[i][j] > 0) g_attackRange[i][j] = 0;
            }
        }
        
        if(aPiece->A->rangeA == 0) g_attackRange[startY][startX] = 10;
        
    }else{
        [self checkAttackRange:startX startY:startY leftPow:aPiece->A->rangeA+1 pieceType:1 aMap:g_attackRange aPiece:aPiece];
        g_attackRange[startY][startX] = 0;
        if(aPiece->A->rangeA == 0) g_attackRange[startY][startX] = 10;
    }
    
    aPiece->A = aTop;
    
    //[self excludePiece:turnSide fillInt:0];
    // 敵方のコマの位置を移動可能範囲から除外する
    
}

-(void)LookupAttackRange2:(int)startX startY:(int)startY aPiece:(LOADCHIP*)aPiece turnSide:(BOOL)turnSide
{
    
    for(int i = 0;i<=chipWidth;i++){
        for(int j = 0;j<=chipHeight;j++){
            g_attackRange[j][i] = 999;
            g_attackRangeDelta[j][i] = 999;
        }
    }
    
    for(int i = 1;i<=chipWidth;i++){
        for(int j = 1;j<=chipHeight;j++){
            g_attackRange[j][i] = 0;
            g_attackRangeDelta[j][i] = 0;
        }
    }
    
    for(int chipType = 0;chipType < 1024;chipType++){
        g_attackCost[0][chipType] = 1;
    }
    
    //0 リク　1宙 2海 3空
    //0 草原 1荒地
    enum{
        MOVETYPE_RIKU,
        MOVETYPE_CHU,
        MOVETYPE_UMI,
        MOVETYPE_SORA,
    };
    
    ATTACK *aTop = aPiece->A;
    for(int i = 0;i < crCAL;i++){
        aPiece->A = aPiece->A->next;
    }
    
    g_attackRange[startY][startX] = aPiece->A->rangeB;
    g_attackRangeDelta[startY][startX] = aPiece->A->rangeA;
    attackMaxNum = aPiece->A->rangeB+1;
    
    //[self excludePiece:turnSide fillInt:99];
    // 敵方のコマを迂回させるため、マップ移動最大値を詰め込む
    if(aPiece->A->rangeB > 1 && aPiece->A->rangeA >= 0){
        [self checkAttackRange2:startX startY:startY leftPow:aPiece->A->rangeB+1 pieceType:0 aMap:g_attackRange aPiece:aPiece];
        [self checkAttackRange2:startX startY:startY leftPow:aPiece->A->rangeA pieceType:1 aMap:g_attackRangeDelta aPiece:aPiece];
        g_attackRange[startY][startX] = 0;
        g_attackRangeDelta[startY][startX] = 0;
        
        for(int i = 0;i<=chipWidth;i++){
            for(int j = 0;j<=chipHeight;j++){
                if(g_attackRangeDelta[i][j] > 0) g_attackRange[i][j] = 0;
            }
        }
        
        if(aPiece->A->rangeA == 0) g_attackRange[startY][startX] = 10;
        
    }else{
        [self checkAttackRange2:startX startY:startY leftPow:aPiece->A->rangeA+1 pieceType:1 aMap:g_attackRange aPiece:aPiece];
        g_attackRange[startY][startX] = 0;
        if(aPiece->A->rangeA == 0) g_attackRange[startY][startX] = 10;
    }
    
    aPiece->A = aTop;
    
    //[self excludePiece:turnSide fillInt:0];
    // 敵方のコマの位置を移動可能範囲から除外する
    
}

-(void)checkAttackRange:(int)startX startY:(int)startY leftPow:(int)leftPow pieceType:(int)pieceType aMap:(int[][1002])aMap aPiece:(UNITCHIP*)aPiece{
    int  i0;
    
    int chipTeam;
    if(Uselected) chipTeam = Uselected->team;
    
    if(startX < 0) startX = 0;
    if(startY < 0) startY = 0;
    
    aMap[startY][startX] = leftPow;    // 残り射程の長さ
    i0 = leftPow - 1;  // 上
    /*if(unitTeam[startY][startX] == chipTeam){
        aMap[startY][startX] = 0;
    }*/
    
    if( aMap[startY-1][startX] < i0 ){
        [self checkAttackRange:startX startY:startY - 1 leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 下
    if( aMap[startY+1][startX] < i0 ){
        [self checkAttackRange:startX startY:startY + 1 leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 右
    if( aMap[startY][startX-1] < i0 ){
        [self checkAttackRange:startX - 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 左
	if( aMap[startY][startX+1] < i0 ){
        [self checkAttackRange:startX + 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
}

-(void)checkAttackRange2:(int)startX startY:(int)startY leftPow:(int)leftPow pieceType:(int)pieceType aMap:(int[][1002])aMap aPiece:(LOADCHIP*)aPiece{
    int  i0;
    
    if(startX < 0) startX = 0;
    if(startY < 0) startY = 0;
    
    aMap[startY][startX] = leftPow;    // 残り射程の長さ
    
    i0 = leftPow - 1;  // 上
    if( aMap[startY-1][startX] < i0 ){
        [self checkAttackRange2:startX startY:startY - 1 leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 下
    if( aMap[startY+1][startX] < i0 ){
        [self checkAttackRange2:startX startY:startY + 1 leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 右
    if( aMap[startY][startX-1] < i0 ){
        [self checkAttackRange2:startX - 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
    i0 = leftPow - 1;  // 左
	if( aMap[startY][startX+1] < i0 ){
        [self checkAttackRange2:startX + 1 startY:startY leftPow:i0 pieceType:pieceType aMap:aMap aPiece:aPiece];
    }
    
}

-(void)makeEnemyAI{

    for(int g = 0;g <= chipWidth;g++){
        for(int h = 0; h <= chipHeight;h++){
            g_attackRangeBeta [h][g] = 0;
        }
    }
    [self LookupMovableRange:unitBreak->y startY:unitBreak->x aPiece:&unitBreak->C turnSide:YES];
    

    for (int x = 0; x <= chipWidth;x++) {
        for(int y = 0; y <= chipHeight;y++){
            
            if(g_selectRange[y][x] > 0 && g_selectRange[y][x] != 999 ){
                
                ATTACK *UAT;
                ATTACK *UA = unitBreak->C.A;
                UAT = unitBreak->C.A;
                crCAL1 = 0;
                while (unitBreak->C.A) {
                    double mpcost = floor(unitBreak->C.A->MP + unitBreak->C.A->pMP*unitBreak->C.S_M.MP/100 + 0.5);
                    if(UA->rangeB <= unitBreak->C.A->rangeB && mpcost <= unitBreak->C.S_C.MP){
                        UA = unitBreak->C.A;
                    }
                    
                    unitBreak->C.A = unitBreak->C.A->next;
                }unitBreak->C.A = UAT;
                if(UA->rangeB <= 0) {
                    UA = unitBreak->C.A;
                    UA->rangeB = 1;
                    crCAL1 = 0;
                }
                
                while (unitBreak->C.A && UA != unitBreak->C.A) {
                    unitBreak->C.A = unitBreak->C.A->next;
                    crCAL1++;
                }unitBreak->C.A = UAT;
                
                unitBreak->atkRange = UA->rangeB;
                
                for(int g = 0;g <= chipWidth;g++){
                    for(int h = 0; h <= chipHeight;h++){
                        g_attackRangeAlpha [h][g] = 0;
                    }
                }
                
                [self checkAttackRange:x startY:y leftPow:UA->rangeB+1 pieceType:unitBreak->C.S_C.typeMONS aMap:g_attackRangeAlpha aPiece:&unitBreak->C];
                
                for (int j = 0; j <= chipWidth;j++) {
                    for(int k = 0;k <= chipHeight;k++){
                        if(g_attackRangeBeta[k][j] < g_attackRangeAlpha[k][j]) g_attackRangeBeta[k][j] = g_attackRangeAlpha[k][j];
                    }
                }
            }
        }
    }

}


//-------------------------------------------------------------------searchRute
-(void)searchRoute{
    int i0;
    
    // ルートテンポラリとルートバッファの初期化
    for( i0 = 0; i0 < 2100; i0++ )
    { g_tmpRoute[i0][0] = 0; g_tmpRoute[i0][1] = 0; g_moveRoute[i0][0] = 0;
        g_moveRoute[i0][1] = 0; }
    
    for(int i = 0;i < 2100;i++){// テンポラリマップのゼロリセット
        for(int j = 0;j< 2100;j++){
            g_tmpMap[j][i] = 0;
        }
    }
    g_stackPointer = 0;	             // スタックポインタ初期化
    g_shallowDepth = 1002;   //「最も浅いスタック」を持たせるために、// 最も深い値を与えておく
    
    [self checkRoute:g_cursol_x startY:g_cursol_y];
    
    // 経路をテンポラリマップに書き込む
    i0 = 0;
    g_moveCount = 0;
    while( i0 < g_shallowDepth)
    {
        g_tmpMap[g_moveRoute[i0][1]][g_moveRoute[i0][0]] = 1;
        
        i0++;
    }
}

//-------------------------------------------------------------------checkRout
-(void)checkRoute:(int)startX startY:(int)startY{
    int i0 = 0;
    
    g_tmpMap[startY][startX]=1;
    g_tmpRoute[g_stackPointer][0] = startX;
    g_tmpRoute[g_stackPointer][1] = startY;
    g_stackPointer++;
    
    // ターゲットに到達したとき、スタック深度が今までより浅かったらそれを保存する
    if((( g_target_x == startX )&&( g_target_y == startY )&&( g_stackPointer < g_shallowDepth )))
    {
        g_shallowDepth = g_stackPointer;  // 最浅スタック深度更新
        int  j0 = 0;
        for( j0 = 0; j0 < g_shallowDepth; j0++ ) {
            g_moveRoute[j0][0] = g_tmpRoute[j0][0];
            g_moveRoute[j0][1] = g_tmpRoute[j0][1];
        }
    }
    
    // 再帰法で移動ルートを探し出す
    // 配列の添え字と関数の引数が逆になっていることに要注意
    i0 = g_selectRange[startY][startX];
    if(g_selectRange[startY-1][startX] > 0)
    if(( g_selectRange[startY-1][startX]   < i0 )&&(g_tmpMap[startY-1][startX] == 0 )
       ){
        [self checkRoute:startX startY:startY -1];
    }   // 上
    if(g_selectRange[startY+1][startX] > 0)
    if(( g_selectRange[startY+1][startX]  < i0 )&&(g_tmpMap[startY+1][startX] == 0 )
       ){
        [self checkRoute:startX startY:startY +1];
    }   // 下
    if(g_selectRange[startY][startX-1] > 0)
    if(( g_selectRange[startY][startX-1]  < i0 )&&(g_tmpMap[startY][startX-1] == 0 )
       ){
        [self checkRoute:startX-1 startY:startY];
    }   // 右
    if(g_selectRange[startY][startX+1] > 0)
    if(( g_selectRange[startY][startX+1]  < i0 )&&(g_tmpMap[startY][startX+1] == 0 )
       ){
        [self checkRoute:startX+1 startY:startY];
    }   // 左
    
    g_stackPointer--;                // スタックから捨てる
    //g_tmpMap[startY][startX] = 0;    // 別経路探索のため
    
}


//-------------------------------------------------------------------searchRute
-(void)searchRoute2{
    int i0;
    
    // ルートテンポラリとルートバッファの初期化
    for( i0 = 0; i0 < 2100; i0++ )
    { g_tmpRoute2[i0][0] = 0; g_tmpRoute2[i0][1] = 0; g_moveRoute2[i0][0] = 0;
        g_moveRoute2[i0][1] = 0; }
    
    for(int i = 0;i < 2100;i++){// テンポラリマップのゼロリセット
        for(int j = 0;j< 2100;j++){
            g_tmpMap2[j][i] = 0;
        }
    }
    g_stackPointer = 0;	             // スタックポインタ初期化
    g_shallowDepth = 1002;   //「最も浅いスタック」を持たせるために、// 最も深い値を与えておく
    
    [self checkRoute:g_cursol_x startY:g_cursol_y];
    
    // 経路をテンポラリマップに書き込む
    i0 = 0;
    g_moveCount = 0;
    while( i0 < g_shallowDepth)
    {
        g_tmpMap2[g_moveRoute2[i0][1]][g_moveRoute2[i0][0]] = 1;
        
        i0++;
    }
}

//-------------------------------------------------------------------checkRout
-(void)checkRoute2:(int)startX startY:(int)startY{
    int i0 = 0;
    
    g_tmpMap2[startY][startX]=1;
    g_tmpRoute2[g_stackPointer][0] = startX;
    g_tmpRoute2[g_stackPointer][1] = startY;
    g_stackPointer++;
    
    // ターゲットに到達したとき、スタック深度が今までより浅かったらそれを保存する
    if((( g_target_x == startX )&&( g_target_y == startY )&&( g_stackPointer < g_shallowDepth ))|| ((cpuTargX == startX ) && (cpuTargY == startY)))
    {
        g_shallowDepth = g_stackPointer;  // 最浅スタック深度更新
        int  j0 = 0;
        for( j0 = 0; j0 < g_shallowDepth; j0++ ) {
            g_moveRoute2[j0][0] = g_tmpRoute2[j0][0];
            g_moveRoute2[j0][1] = g_tmpRoute2[j0][1];
        }
    }
    
    // 再帰法で移動ルートを探し出す
    // 配列の添え字と関数の引数が逆になっていることに要注意
    i0 = g_selectRange[startY][startX];
    if(g_selectRange[startY-1][startX] > 0)
        if(( g_selectRange[startY-1][startX]   < i0 )&&(g_tmpMap2[startY-1][startX] == 0 )
           ){
            [self checkRoute:startX startY:startY -1];
        }   // 上
    if(g_selectRange[startY+1][startX] > 0)
        if(( g_selectRange[startY+1][startX]  < i0 )&&(g_tmpMap2[startY+1][startX] == 0 )
           ){
            [self checkRoute:startX startY:startY +1];
        }   // 下
    if(g_selectRange[startY][startX-1] > 0)
        if(( g_selectRange[startY][startX-1]  < i0 )&&(g_tmpMap2[startY][startX-1] == 0 )
           ){
            [self checkRoute:startX-1 startY:startY];
        }   // 右
    if(g_selectRange[startY][startX+1] > 0)
        if(( g_selectRange[startY][startX+1]  < i0 )&&(g_tmpMap2[startY][startX+1] == 0 )
           ){
            [self checkRoute:startX+1 startY:startY];
        }   // 左
    
    g_stackPointer--;                // スタックから捨てる
    //g_tmpMap[startY][startX] = 0;    // 別経路探索のため
    
}


-(void)modeCPUturn{

    enum{
    
        MODE_CPU_IDLE,
        MODE_CPU_SEARCH,
        MODE_CPU_MOVE,
        MODE_CPU_ATTACK,
        MODE_CPU_BATTLE
    };
    
    
    static int cpuMODE = MODE_CPU_IDLE;
    
    switch (cpuMODE) {
        case MODE_CPU_IDLE:
            if(unitMoveEndFlag){
                pushStanbyFlag = true;
            }
            
            if(setBattleModeFlag)
                return;
            
            if(messageDialog)
                return;
            if(endGameCondition)
                return;
            if(battleFlag || battleRdy)
                return;
            
            unitMoveEndFlag = false;
            CPUAttackFlag = false;
            CPUAttackFlag2 = false;
            if(cpuAImodeflag && unitBreak->C.nameID)
                cpuMODE = MODE_CPU_SEARCH;
            possionX = unitBreak->x;
            possionY = unitBreak->y;
            currentPosX = possionX;
            currentPosY = possionY;
                Uselected = unitBreak;
            break;
        case MODE_CPU_SEARCH:
            pushStanbyFlag = false;
            [self makeEnemyAI];
            [self cpuSearchEnemy];
            cpuModeMOVEflag = true;
            if(unitNoMoveStanbyFlag){
                static int waitTimer = 50;
                cpuModeATTACKflag = true;
                if (waitTimer > 0) {
                    waitTimer--;
                    return;
                }else{
                    waitTimer = 50;
                    unitNoMoveFlag = true;
                    U = UTop;
                    
                    while (U->number != wtUnitNum) {
                        U = U->next;
                    }
                    
                    if(!wtMovedFlag && !wtAttackedFlag && unitNoMoveFlag){
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
                    
                    cpuModeMOVEflag = false;
                    cpuModeATTACKflag = false;
                    cpuAImodeflag = false;
                    moveFlag = false;
                    stanbyFlag = true;
                    wtMovedFlag = true;
                    unitNoMoveFlag = false;
                    CPUAttackFlag = false;
                    CPUAttackFlag2 = false;
                    
                    unitNoMoveStanbyFlag = false;

                    cpuMODE = MODE_CPU_IDLE;

                }
                
                return;
            }
            
            cpuMODE = MODE_CPU_MOVE;
            if(unitNoMoveFlag){
                cpuModeATTACKflag = true;
                cpuMODE = MODE_CPU_ATTACK;
            }
            break;
        case MODE_CPU_MOVE:
            moveFlag = true;
            cpuModeATTACKflag = true;
            if ([self cpuMoveFunc] && unitMoveEndFlag) {
                cpuMODE = MODE_CPU_ATTACK;
            }
            
            break;
        case MODE_CPU_ATTACK:
            if(!CPUAttackFlag){
                U = UTop;
                
                while (U->number != wtUnitNum) {
                    U = U->next;
                }
                
                if(!wtMovedFlag && !wtAttackedFlag && unitNoMoveFlag){
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
                
                cpuModeMOVEflag = false;
                cpuModeATTACKflag = false;
                cpuAImodeflag = false;
                moveFlag = false;
                stanbyFlag = true;
                wtMovedFlag = true;
                unitNoMoveFlag = false;
                CPUAttackFlag = false;
                CPUAttackFlag2 = false;
                
                cpuMODE = MODE_CPU_IDLE;
                return;
            }else{
                unitCPUAttackFlag = true;
                cpuMODE = MODE_CPU_BATTLE;
                return;
            }
            break;
        case MODE_CPU_BATTLE:
            
            if(cpuModeBATTLEendFlag){
                
                
                if(cpuModeBATTLEendFlag){
                    cpuMODE = MODE_CPU_IDLE;
                    pushStanbyFlag = true;
                    
                    cpuModeMOVEflag = false;
                    cpuModeATTACKflag = false;
                    cpuAImodeflag = false;
                    moveFlag = false;
                    stanbyFlag = true;
                    wtMovedFlag = true;
                    unitNoMoveFlag = false;
                    CPUAttackFlag = false;
                    CPUAttackFlag2 = false;
                    wtRdy = false;
                    cpuModeBATTLEendFlag = false;
                }
                
                return;
            }else if((CPUAttackFlag && unitMoveEndFlag )|| CPUAttackFlag2){
                
                static int waitTimer = 50;
                
                if (waitTimer > 0) {
                    waitTimer--;
                    return;
                }else{
                    waitTimer = 50;
                    CPUAttackSubmitFlag = true;
                    battleWindowFlag = true;
                    cpuModeBATTLEflag = true;
                    CPUAttackFlag = false;
                    CPUAttackFlag2 = false;
                }
            }else{
                
                return;
            }
            
            
            
            
            
            
            U = UTop;
            while (U->number != wtUnitNum) {
                U = U->next;
            }
            
            if(!wtMovedFlag && !wtAttackedFlag && unitNoMoveFlag){
                U->C.S_C.WT = floor(U->C.S_M.WT/4 + 0.5);
            }else if(wtMovedFlag && wtAttackedFlag){
                U->C.S_C.WT =  floor(U->C.S_M.WT + 0.5);
            }else if(wtMovedFlag){
                U->C.S_C.WT =  floor(U->C.S_M.WT/2 + 0.5);
            }else if(wtAttackedFlag){
                U->C.S_C.WT =  floor(U->C.S_M.WT/2 + 0.5);
            }
            
            U = UTop;
            
            pushStanbyFlag = true;
            
            cpuModeMOVEflag = false;
            cpuModeATTACKflag = false;
            cpuAImodeflag = false;
            moveFlag = false;
            stanbyFlag = true;
            wtMovedFlag = true;
            unitNoMoveFlag = false;
            CPUAttackFlag = false;
            CPUAttackFlag2 = false;
            
            break;
            
        default:
            cpuMODE = MODE_CPU_IDLE;
            break;
    }
















}

-(void)cpuSearchEnemy{

    if(!unitBreak->C.nameID) return;
    
    moveFlag = false;
    attackFlag = false;
    stanbyFlag = false;
    unitMoveEndFlag = false;
    possionX = unitBreak->x;
    possionY = unitBreak->y;
    
    UCselected = UC[unitNum[unitBreak->x][unitBreak->y]];
    LCselected = LC[loadNum[unitBreak->x][unitBreak->y]];
    
    if(unitBreak->chipNumber >= 0) [self LookupMovableRange:unitBreak->y startY:unitBreak->x aPiece:&UC[unitNum[unitBreak->x][unitBreak->y]] turnSide:YES];
    if(unitBreak->chipNumberL >= 0) [self LookupMovableRange2:unitBreak->y startY:unitBreak->x aPiece:&LC[loadNum[unitBreak->x][unitBreak->y]] turnSide:YES];
    
    for (int x = 0; x <= chipWidth; x++) {
        for (int y = 0; y <= chipHeight; y++) {
            g_targUnit[y][x] = 0;
        }
    }
    
    for (int x = 0; x <= chipWidth; x++) {
        for (int y = 0; y <= chipHeight; y++) {
            g_entireUnit[y][x] = 0;
        }
    }
    
    UNIT *UN = U;
    for (int x = 0; x <= chipWidth; x++) {
        for (int y = 0; y <= chipHeight; y++) {
            
            
            U = UTop;
            while(U){
                if(U->y == x && U->x == y){
                    g_entireUnit[y][x] = 1;
                }
                U = U->next;
            }U = UTop;
        }
    }
    
    for (int x = 0; x <= chipWidth; x++) {
        for (int y = 0; y <= chipHeight; y++) {
            
            
            U = UTop;
            while(U){
            if(g_attackRangeBeta[y][x] > 0 && U->y == x && U->x == y){
                g_targUnit[y][x] = 1;
            }
                U = U->next;
            }U = UTop;
        }
    }
    
    AUN[1] = unitBreak;
    Utarget = NULL;
    CPUAttackFlag = false;
    CPUAttackFlag2 = false;
    eval_point = 0;
    U = UTop;
    while (U) {
        
        for (int x = 0; x <= chipWidth; x++) {
            for (int y = 0; y <= chipHeight; y++) {
                g_attackRangeTheta[y][x] = 0;
            }
        }
        [self checkAttackRange:U->y startY:U->x leftPow:unitBreak->atkRange+1 pieceType:U->C.S_C.typeMONS aMap:g_attackRangeTheta aPiece:&U->C];
        
        while (1) {
        if(g_attackRangeTheta[unitBreak->x][unitBreak->y] > 0 && U->team != unitBreak->team && !U->dead){
            if(unitBreak->team == 0)
                if(U->team == 1)
                    break;
            if(unitBreak->team == 1)
                if(U->team == 0)
                    break;
            AUN[1] = unitBreak->number;
            DUN[1] = U->number;
            Utarget = U;
            g_target_x = unitBreak->y;
            g_target_y = unitBreak->x;
            unitNoMoveFlag = true;
            CPUAttackFlag = true;
            CPUAttackFlag2 = true;
            goto w000p;
        }
            break;
        }
        
        if(U->team != unitBreak->team && !U->dead){
            if(unitBreak->team == 0)
                if(U->team == 1)
                    goto w00p;
            if(unitBreak->team == 1)
                if(U->team == 0)
                    goto w00p;
            for (int x = 1; x <= chipWidth; x++) {
                for (int y = 1; y <= chipHeight; y++) {
                    if(g_attackRangeTheta[y][x] > 0 && g_selectRange[y][x] > 0 && g_entireUnit[y][x] == 0){
                    
                        
                        int point = (unitBreak->atkRange - g_attackRangeBeta[y][x])*20 + g_selectRange[y][x]*50;
                        
                        if(eval_point < point){
                            eval_point = point;
                            Utarget = U;
                            g_target_x = x;
                            g_target_y = y;
                            CPUAttackFlag = true;
                            AUN[1] = unitBreak->number;
                            DUN[1] = U->number;
                        }
                    
                    }
            
                }
                
                
            }
        }
        
    w00p:
        U = U->next;
    }U = UTop;
    
    
    if(Utarget){
    w000p:
    for (int k = 0; k <= chipWidth; k++) {
        for (int g = 0; g <= chipHeight; g++) {
            g_enemyRange[g][k] = 0;
        }
    }
    [self checkEnemyRange:unitBreak->atkRange+1 cntNum:0 tX:Utarget->x tY:Utarget->y aMap:g_enemyRange];
    
    unitBreak->atkRange = unitBreak->atkRange+1 - g_enemyRange[g_target_x][g_target_y];
        crCAL1 = 0;
        
        ATTACK *aTop = unitBreak->C.A;
        while(unitBreak->C.A){
        if((unitBreak->C.A->rangeA <= unitBreak->atkRange && unitBreak->C.A->rangeB >= unitBreak->atkRange))
            break;
            
            crCAL1++;
            unitBreak->C.A = unitBreak->C.A->next;
        }unitBreak->C.A = aTop;
        crCAL = crCAL1;
        return;
    }
    
    if(!Utarget){
    eval_point = 999;
    
    U = UTop;
    while (U) {
        
        if(!U->dead && U->team != unitBreak->team){
            for (int x = 1; x <= chipWidth; x++) {
                for (int y = 1; y <= chipHeight;y++) {
                    if(g_selectRange[y][x] > 0 && g_entireUnit[y][x] == 0){
                        int dist = abs(x - U->y) + abs(y - U->x);
                        
                        
                        if(buildNum[y][x] >= 0 && buildTeam[y][x] != unitBreak->team){
                            dist = 999;
                            g_target_x = x;
                            g_target_y = y;
                            U = UTop;
                            U = UN;
                            possionX = g_target_y;
                            possionY = g_target_x;
                            buildTeam[y][x] = unitBreak->team;
                            return;
                        }
                        
                        
                        if(eval_point > dist){
                            eval_point = dist;
                            g_target_x = x;
                            g_target_y = y;
                        }
                    }
                }
            }
        
        }
        U = U->next;
    }U = UTop;
    }
    
    U = UN;
    
    if(g_target_x == 0 && g_target_y == 0){
        g_target_x = unitBreak->y;
        g_target_y = unitBreak->x;
    }
    
    possionX = g_target_y;
    possionY = g_target_x;
    
    if(g_target_x == unitBreak->y && g_target_y == unitBreak->x){
        unitNoMoveStanbyFlag = true;
    }
}

-(bool)cpuMoveFunc{
    
    static int waitTimer = 50;
    
    if (waitTimer > 0) {
        waitTimer--;
        return false;
    }else{
        waitTimer = 50;
    }
    
    g_cursol_x = unitBreak->y;
    g_cursol_y = unitBreak->x;
    
    if(moveFlag && g_selectRange[possionX][possionY] > 0){
        
        [self searchRoute];
        
        for(int i = 0;i<=chipWidth;i++){
            for(int j = 0;j<=chipHeight;j++){
                g_map[j][i] = chipNum[j][i];
                g_selectRange[j][i] = 0;
            }
        }
        moveFlag = false;
        stanbyFlag = true;
        wtPx = g_target_y;
        wtPy = g_target_x;
        wtMovedFlag = true;
        BTop = B;
        while (B) {
            if(B->x == wtPx && B->y == wtPy && B->C.capture){
                buildCaptureFlag = true;
            }
            B = B->next;
        }B = BTop;
        
    }
    

    moveFlag = true;
    attackFlag = false;
    stanbyFlag = true;
    menuDisplayFlag = false;
    Uselected = unitBreak;
    return true;
}

-(void)checkStep:(int)cnsPow tX:(int)startX tY:(int)startY type:(int)pieceType aMap:(int[][1002])aMap{

    int i0;
    
    aMap[startY][startX] = cnsPow;
    
    i0 = cnsPow + g_moveCost[pieceType][g_map[startY-1][startX]];
    if(aMap[startY-1][startX] > i0) [self checkStep:i0 tX:startX tY:startY-1 type:pieceType aMap:aMap];

    i0 = cnsPow + g_moveCost[pieceType][g_map[startY+1][startX]];
    if(aMap[startY+1][startX] > i0) [self checkStep:i0 tX:startX tY:startY+1 type:pieceType aMap:aMap];
    
    i0 = cnsPow + g_moveCost[pieceType][g_map[startY][startX-1]];
    if(aMap[startY][startX-1] > i0) [self checkStep:i0 tX:startX-1 tY:startY type:pieceType aMap:aMap];
    
    i0 = cnsPow + g_moveCost[pieceType][g_map[startY][startX+1]];
    if(aMap[startY][startX+1] > i0) [self checkStep:i0 tX:startX+1 tY:startY type:pieceType aMap:aMap];


}

-(void)checkEnemyRange:(int)cnsPow cntNum:(int)cntNum tX:(int)startX tY:(int)startY aMap:(int[][1002])aMap{
    
    int i0;
    
    aMap[startY][startX] = cnsPow;
    //NSLog(@"[%d,%d]%d\n", startY, startX, cnsPow);
    i0 = cnsPow - 1;
    if(aMap[startY-1][startX] < i0)
        [self checkEnemyRange:i0 cntNum:cnsPow tX:startX tY:startY-1 aMap:aMap];
    
    i0 = cnsPow - 1;
    if(aMap[startY+1][startX] < i0)
        [self checkEnemyRange:i0 cntNum:cnsPow tX:startX tY:startY+1 aMap:aMap];
    
    i0 = cnsPow - 1;
    if(aMap[startY][startX-1] < i0)
        [self checkEnemyRange:i0 cntNum:cnsPow tX:startX-1 tY:startY aMap:aMap];
    
    i0 = cnsPow - 1;
    if(aMap[startY][startX+1] < i0)
        [self checkEnemyRange:i0 cntNum:cnsPow tX:startX+1 tY:startY aMap:aMap];
    
    
}


-(void)mouseUp:(NSEvent *)theEvent{

}

-(void)loadMesh:(NSMutableArray *)theMapString index:(int)index{
    
    /*
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSString *fileData;
    NSString *pathDATA = @"Map/";
    
    for(int i = 0;i<1000;i++){
        for(int j = 0;j< 1000;j++){
            chipNum[i][j] = 0;
            buildNum[i][j] = -1;
            unitNum[i][j] = -1;
        }
    }
    
    NSString *OMFG = [[theMapString objectAtIndex:index] retain];
    
    pathDATA = [pathDATA stringByAppendingFormat:@"%@", OMFG];
    
    //NSLog(@"%@", pathDATA);
    
    fileData = [NSString stringWithContentsOfFile:pathDATA encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    
    int chipType = 0;
    int chipIndexDelta = 0;
    int chipIndexDelta2 = 0;
    NSArray *items0 = [[fileDataArray objectAtIndex:0] componentsSeparatedByString:@","];
    chipWidth = (int)[items0 count];
    int omanko = 0;
    bool oopsIsRight;
    for(int i=0;i < [fileDataArray count];i++){
        if([fileDataArray objectAtIndex:0] == NULL) break;
        NSArray *items = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@","];
        
        NSRange rangeSearch = [[items objectAtIndex:0] rangeOfString:@"####"];
        omanko++;
        if(rangeSearch.location != NSNotFound){
            if(!oopsIsRight) {chipHeight = omanko-1; oopsIsRight = true;}
            chipType++;
            continue;
        }
        
        if(chipType == 0){chipIndexDelta++;
            for(int j=0;j < [items count];j++){
                chipNum[j][i] = [[items objectAtIndex:j] intValue];
                chipWidth = (int)[items count];
                chipHeight = chipIndexDelta;
            }
        }else if(chipType == 1){chipIndexDelta2++;
            for(int j=0;j < [items count];j++){
                buildNum[j][i - chipIndexDelta-1] = [[items objectAtIndex:j] intValue]-1;
            }
        }else if(chipType == 2){
            for(int j=1;j < [items count];j++){
                unitNum[[[items objectAtIndex:2] intValue]][[[items objectAtIndex:1] intValue]] = [[items objectAtIndex:0] intValue]-1;
            }
        }
        
    }
*/
}


- (void)drawRect:(NSRect)dirtyRect
{
    int bx, by;
    for(bx=1;bx<=chipWidth;bx++){
        for(by=1;by<=chipHeight;by++){
            //[self DrawImage:chip x:(bx-1)*32-1 y:(by-1)*32 cx:bx cy:by f:1.0];
            [self DrawImage:MC[chipNum[bx][by]].img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by f:1.0];
            if(buildNum[bx][by] >= 0) {
                
                
                //[self DrawImage:BC[buildNum[bx][by]].img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by f:1.0];
                
                BTop = B;
                while (B) {
                    if(B->x == bx && B->y == by) break;
                    B = B->next;
                }
                if(B) [self DrawImage:B->img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by f:1.0];
                B = BTop;
                
            }
            
            if(g_selectRange[bx][by] > 0 && moveFlag){
                [self DrawImage:chipMove x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by f:0.8];
                switch (g_selectRange[bx][by]) {
                    case 1:
                        [self DrawImage:n1 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 2:
                        [self DrawImage:n2 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 3:
                        [self DrawImage:n3 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 4:
                        [self DrawImage:n4 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 5:
                        [self DrawImage:n5 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 6:
                        [self DrawImage:n6 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 7:
                        [self DrawImage:n7 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 8:
                        [self DrawImage:n8 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 9:
                        [self DrawImage:n9 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 10:
                        [self DrawImage:n10 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 11:
                        [self DrawImage:n11 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 12:
                        [self DrawImage:n12 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 13:
                        [self DrawImage:n13 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 14:
                        [self DrawImage:n14 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 15:
                        [self DrawImage:n15 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 16:
                        [self DrawImage:n16 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 17:
                        [self DrawImage:n17 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 18:
                        [self DrawImage:n18 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 19:
                        [self DrawImage:n19 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                    case 20:
                        [self DrawImage:n20 x:bx*32 y:by*32 cx:bx cy:by f:1];
                        break;
                        
                    default:
                        break;
                }
            }
            
            if(g_attackRange[bx][by] > 0 && attackFlag){
                [self DrawImage:chipAttack x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by f:0.8];
            }
            
            if(g_summonRange[bx][by] > 0 && summonFlag){
                [self DrawImage:chipSummon x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by f:0.8];
            }
            
            if(unitNum[bx][by] >= 0 || loadNum[bx][by] >= 0) {
                //[self DrawImage:UC[unitNum[bx][by]].img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by f:1.0];
               
                
                U = UTop;
                while (U) {
                    if(U->x == bx && U->y == by) break;
                    U = U->next;
                }
                if(U)
                    [self DrawImage:U->img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by f:1.0];
                U = UTop;
                
            }
        }
    }
    
    
    if(cpuModeATTACKflag)
    for (int x = 1; x <= chipWidth;x++) {
        for(int y = 1;y <= chipHeight;y++){
            
            if(g_attackRangeBeta[y][x] > 0)
            [self DrawImage:chipSelect x:(y-1)*32 y:(x-1)*32 cx:bx cy:by f:0.6];
        
        }
    }
    if(cpuModeMOVEflag)
    for (int x = 1; x <= chipWidth;x++) {
        for(int y = 1;y <= chipHeight;y++){
            
            if(g_selectRange[y][x] > 0)
                [self DrawImage:chipMove x:(y-1)*32 y:(x-1)*32 cx:bx cy:by f:0.4];
            
        }
    }
    /*
    if(cpuModeATTACKflag)
        for (int x = 0; x <= chipWidth;x++) {
            for(int y = 0 ;y <= chipHeight;y++){
               if(g_targUnit[y][x] > 0)
                   [self DrawImage:chipAttack x:(y-1)*32 y:(x-1)*32 cx:bx cy:by f:1.0];
            }
        }
     */
    /*
    if(cpuModeATTACKflag)
        for (int x = 0; x <= chipWidth;x++) {
            for(int y = 0 ;y <= chipHeight;y++){
                if(g_visibleRange[y][x] > 0)
                    [self DrawImage:chipMove x:(y-1)*32 y:(x-1)*32 cx:bx cy:by f:1.0];
                    

            }
        }*/
    
    
    //[self DrawImage:UCselected.img x:currentPosX-32 y:currentPosY-32 cx:0 cy:0 f:1.0];
    if(Uselected && unitMoveBugFixFlag) [self DrawImage:Uselected->img x:currentPosX-32 y:currentPosY-32 cx:0 cy:0 f:1.0];
    
    
    [self DrawImage:chipSelect x:(possionX-1)*32 y:(possionY-1)*32 cx:0 cy:0 f:1.0];
    
    
    //if(cpuCursolMode) [self DrawImage:chipSelect x:(g_target_y-1)*32 y:(g_target_x-1)*32 cx:0 cy:0 f:1.0];
    
    if(chipTargetFlag) [self DrawImage:chipTarget x:(wtPx-1)*32 y:(wtPy-1)*32 cx:0 cy:0 f:1.0];
    
    if(Utarget)
        [self DrawImage:chipAttack x:(Utarget->x-1)*32 y:(Utarget->y-1)*32 cx:bx cy:by f:0.6];
   //[self DrawImage:chipSelect x:(2-1)*32 y:(1-1)*32 cx:0 cy:0 f:1.0];
    
    
    initMapFlag = true;
}

@end
