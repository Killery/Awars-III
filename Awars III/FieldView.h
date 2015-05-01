//
//  FieldView.h
//  Awars III
//
//  Created by Killery on 2013/02/22.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MapView.h"
#import "ScenarioList.h"
#import "EventScene.h"
#import "MapChipList.h"
#import "BuildChipList.h"
#import "UnitChipList.h"
#import "FieldScene.h"

int possionX;
int possionY;

int g_selectRange[1002][1002];
int g_moveCost[4][128];
int g_map[1002][1002];

int g_attackRange[1002][1002];
int g_attackRangeDelta[1002][1002];
int g_attackCost[4][128];

int g_attackRangeAlpha[1002][1002];
int g_attackRangeBeta[1002][1002];
int g_attackRangeTheta[1002][1002];
int g_enemyRange[1002][1002];
bool unitNoMoveFlag;
bool unitCPUAttackFlag;
bool CPUAttackFlag;
bool CPUAttackFlag2;
bool CPUAttackSubmitFlag;

int g_targUnit[1002][1002];
int g_entireUnit[1002][1002];
int g_visibleRange[1002][1002];
int g_targX;
int g_targY;
int eval_point;

int g_summonRange[1002][1002];
int g_summonRangeDelta[1002][1002];

int g_tmpRoute[2100][2];
int g_moveRoute[2100][2];

int g_tmpRoute2[2100][2];
int g_moveRoute2[2100][2];
int g_tmpMap2[2100][2100];


int g_stackPointer;
int g_shallowDepth;
int g_tmpMap[2100][2100];
int g_target_x;
int g_target_y;
int g_cursol_x;
int g_cursol_y;
int g_enemy_x;
int g_enemy_y;
int g_point_x;
int g_point_y;

int g_moveCount;
int currentPosX;
int currentPosY;

int slctedUnitNum;

bool moveFlag;
bool stanbyFlag;
bool submitFlag;
bool attackFlag;
bool createFlag;
bool summonFlag;


int registerNum;
int registerNumB;

bool initMapFlag;
bool battleWindowFlag;
bool battleFlag;

int attackMaxNum;
bool deltaFlag;

bool buildSelectedFlag;

bool unitColorInitFlag;
UNITCHIP UCselected;
LOADCHIP LCselected;
struct _UNIT *Uselected;

struct _UNIT *Utarget;

int researchTeam;
bool buildCaptureFlag;
bool unitMoveEndFlag;
bool chipTargetFlag;

bool summonRdyFlag;

bool cpuTurnEndFlag;

bool cpuCursolMode;

bool fieldViewBattleInitFlag;

bool cpuModeMOVEflag;
bool cpuModeATTACKflag;
bool cpuModeBATTLEflag;
bool cpuModeBATTLEendFlag;
int cpuTargX;
int cpuTargY;

bool unitMoveBugFixFlag;
bool unitNoMoveStanbyFlag;

@interface FieldView : NSView
{
    NSTimer *time;
    NSImage *chip;
    NSImage *chipSelect;
    NSImage *chipMove;
    NSImage *chipAttack;
    NSImage *chipTarget;
    NSImage *chipSummon;
    
    NSImage *chipTeam0;
    NSImage *chipTeam1;
    NSImage *chipTeam2;
    
    NSPoint drugPoint;
    
    NSArray *fileDataArray;
    
    NSImage *n1, *n2, *n3, *n4, *n5, *n6, *n7, *n8, *n9, *n10;
    NSImage *n11, *n12, *n13, *n14, *n15, *n16, *n17, *n18, *n19, *n20;
    
}

-(NSImage*)LoadImage:(NSString*)name;
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy f:(float)frac;

-(void)loadMesh:(NSMutableArray *)theMapString;

@end
