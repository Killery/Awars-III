//
//  MapView.h
//  Awars III
//
//  Created by Killery on 2012/12/15.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MapChipList.h"
#import "BuildChipList.h"
#import "UnitChipList.h"
#import "ChipView.h"
#import "CommandView.h"
#import "MapEditor.h"
#import "EventScene.h"
#import "ScenarioList.h"

int chipNum[1002][1002];
int buildNum[1002][1002];
int unitNum[1002][1002];
int loadNum[1002][1002];
int buildTeam[1002][1002];
int unitTeam[1002][1002];
int posX;
int posY;

int chipHeight;
int chipWidth;
int chipHeightPost;
int chipWidthPost;

bool mapChipDataLoadFail;

int eSlctX;
int eSlctY;
int clickUpCnt;
bool doubleClickedFlag;

int MSDPONOFFFlagNum;

@interface MapView : NSView
{
    NSTimer *time0;
    NSImage *chip, *chip2;
    NSImage *chip1A;
    NSImage *chip2A;
    NSImage *chip3A, *chip4A, *chip5A, *chip6A;
    NSImage *chip1B, *chip2B, *chip3B, *chip4B, *chip5B, *chip6B;
    
    NSImage *buildTeamImg[9];
    NSImage *unitTeamImg[9];
    
    NSPoint drugPoint;

    NSArray *fileDataArray;
    
}
-(NSImage*)LoadImage:(NSString*)name;
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy;

-(void)loadMapChip;

@end
