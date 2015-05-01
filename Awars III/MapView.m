//
//  MapView.m
//  Awars III
//
//  Created by Killery on 2012/12/15.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import "MapView.h"

@implementation MapView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        time0  = [NSTimer
                 scheduledTimerWithTimeInterval:0.05f
                 target:self
                 selector:@selector(EventLoop00:)
                 userInfo:nil
                 repeats:YES
                 ];
        chip = [[self LoadImage:@"マス.png"] retain];
        chip2 = [[self LoadImage:@"セレクター.png"] retain];
        
        chip1A = [[self LoadImage:@"ccはた青.png"] retain];
        chip2A = [[self LoadImage:@"ccはた青2.png"] retain];
        chip3A = [[self LoadImage:@"ccはた赤.png"] retain];
        chip4A = [[self LoadImage:@"ccはた赤2.png"] retain];
        chip5A = [[self LoadImage:@"ccはた黄.png"] retain];
        chip6A = [[self LoadImage:@"ccはた黄2.png"] retain];
        
        chip1B = [[self LoadImage:@"cc旗青.png"] retain];
        chip2B = [[self LoadImage:@"cc旗青2.png"] retain];
        chip3B = [[self LoadImage:@"cc旗赤.png"] retain];
        chip4B = [[self LoadImage:@"cc旗赤2.png"] retain];
        chip5B = [[self LoadImage:@"cc旗黄.png"] retain];
        chip6B = [[self LoadImage:@"cc旗黄2.png"] retain];
        
        buildTeamImg[0] = chip1A;
        buildTeamImg[1] = chip2A;
        buildTeamImg[2] = chip3A;
        buildTeamImg[3] = chip4A;
        buildTeamImg[4] = chip5A;
        buildTeamImg[5] = chip6A;
        unitTeamImg[0] = chip1B;
        unitTeamImg[1] = chip2B;
        unitTeamImg[2] = chip3B;
        unitTeamImg[3] = chip4B;
        unitTeamImg[4] = chip5B;
        unitTeamImg[5] = chip6B;
        [self initMapChipFileDirectory];
        
        for (int i = 0; i <= chipHeight;i++)
            for (int j = 0;j<= chipWidth;j++)
                unitNum[i][j] = -1;
        
        
         NSRect seRect = NSMakeRect(0, 0, chipHeight*32, chipWidth*32);
         [self setFrame:seRect];
         
         
    }
    
    
    
    
    
    
    return self;
}
-(void)EventLoop00:(NSTimer*)time{
    
    if(saveMapChipFlag){saveMapChipFlag = false;
        [self saveMapChip];
    }
    if(mapSizeChangedFlag){mapSizeChangedFlag = false;
        
        NSRect seRect;
        seRect.size.height = chipHeight*32;
        seRect.size.width = chipWidth*32;
        
        [self setFrame:seRect];
    }
    if(initMapChipNumbFlag){initMapChipNumbFlag = false;
        
        for(int i = 0;i <= chipWidth;i++){
            for(int j = 0;j <= chipHeight;j++){
                if(postHeight < j) {
                    buildNum[i][j] = -1;
                    unitNum[i][j] = -1;
                }
                if(postWidth < i){
                    buildNum[i][j] = -1;
                    unitNum[i][j] = -1;
                }
            
            }
        }
    }
    if(loadMapListSubmitFlag){loadMapListSubmitFlag = false;
        chipNum[1][1] = 2;
        [self loadMapChip];
        NSRect seRect;
        seRect.size.height = chipHeight*32;
        seRect.size.width = chipWidth*32;
        [self setFrame:seRect];
    }
    
    if(EEGCslctFlag || eventPosFlag){
        static int clickFrame = 0;
        if(clickUpCnt%2 == 1){
            clickFrame++;
        }
    
        if(clickFrame > 100)
            clickFrame = 0;
        
        if(clickUpCnt%2 == 0 && clickFrame >0){
            doubleClickedFlag = true;
            clickFrame = 0;
        }
    }
    
    [self setNeedsDisplay:YES];
}


-(BOOL)isFlipped{
    return YES;
}

-(NSImage*)LoadImage:(NSString*)name{
    NSImage *image = [NSImage imageNamed:name];
    if(image == nil) return nil;
    
    return image;
}
-(void)DrawImage:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy{
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
    
    [image drawInRect:drRect fromRect:frRect operation:NSCompositeSourceOver fraction:1.0f respectFlipped:YES hints:nil];
    
}

-(void)DrawImage2:(NSImage*)image x:(float)x y:(float)y cx:(int)cx cy:(int)cy{
    NSRect frRect;
    frRect.size.height = image.size.height;
    frRect.size.width = image.size.width;
    
    frRect.origin.x = 0;
    frRect.origin.y = 0;
    
    NSRect drRect;
    drRect.origin.x = x+16-4;
    drRect.origin.y = y+16-4;
    drRect.size.height = 16+4;
    drRect.size.width = 16+4;
    
    [image drawInRect:drRect fromRect:frRect operation:NSCompositeSourceOver fraction:1.0f respectFlipped:YES hints:nil];
    
}

-(void)mouseDown:(NSEvent *)theEvent{
    drugPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    posX = (int)drugPoint.x/32 + 1;
    posY = (int)drugPoint.y/32 + 1;
    
    eSlctX = (int)drugPoint.x/32 + 1;
    eSlctY = (int)drugPoint.y/32 + 1;
    
    if(EEGCslctFlag) return;
    
    if(CommandSelected){
        if(SLSx == 1 && SLCy == 0) buildNum[posX][posY] = -1;
        if(SLSx == 2 && SLCy == 0) unitNum[posX][posY] = -1;
        if(SLSx == 3 && SLCy == 0) loadNum[posX][posY] = -1;
        if(SLSx == 0 && SLCy == 0) {buildTeam[posX][posY] = -1; unitTeam[posX][posY] = -1;}
    }else{
        if(SLSx == 0 && SLCy == 1) buildTeam[posX][posY] = SLindex;
        else if(SLSx == 0 && SLCy == 2) unitTeam[posX][posY] = SLindex;
        else if(SLSx == 0) chipNum[posX][posY] = SLindex;
        if(SLSx == 1) buildNum[posX][posY] = SLindexB;
        if(SLSx == 2) unitNum[posX][posY] = SLindexU;
        if(SLSx == 3) loadNum[posX][posY] = SLindexL;
    
    }
    
}

-(void)mouseUp:(NSEvent *)theEvent{

    clickUpCnt = (int)[theEvent clickCount];
    
    if(EEGCslctFlag){
    
        if([theEvent clickCount] == 2){
        
        }
    
    
    }
}

-(void)mouseDragged:(NSEvent *)theEvent{
    drugPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    posX = (int)drugPoint.x/32+1;
    posY = (int)drugPoint.y/32+1;

    if(EEGCslctFlag) return;
    
    if(CommandSelected){
        if(SLSx == 1 && SLCy == 0) buildNum[posX][posY] = -1;
        if(SLSx == 2 && SLCy == 0) unitNum[posX][posY] = -1;
        if(SLSx == 3 && SLCy == 0) loadNum[posX][posY] = -1;
        if(SLSx == 0 && SLCy == 0) {buildTeam[posX][posY] = -1; unitTeam[posX][posY] = -1;}

    }else{
        if(SLSx == 0 && SLCy == 1) buildTeam[posX][posY] = SLindex;
        else if(SLSx == 0 && SLCy == 2) unitTeam[posX][posY] = SLindex;
        else if(SLSx == 0) chipNum[posX][posY] = SLindex;
        if(SLSx == 1) buildNum[posX][posY] = SLindexB;
        if(SLSx == 2) unitNum[posX][posY] = SLindexU;
        if(SLSx == 3) loadNum[posX][posY] = SLindexL;
    
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    int bx, by;
    for(bx=1;bx<=chipWidth;bx++){
        for(by=1;by<=chipHeight;by++){
            [self DrawImage:chip x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by];
            [self DrawImage:MC[chipNum[bx][by]].img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by];
            if(buildNum[bx][by] >= 0) [self DrawImage:BC[buildNum[bx][by]].img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by];
            if(loadNum[bx][by] >= 0) [self DrawImage:LC[loadNum[bx][by]].img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by];
            if(loadNum[bx][by] < 0)
                if(unitNum[bx][by] >= 0) [self DrawImage:UC[unitNum[bx][by]].img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by];
            if(loadNum[bx][by] >= 0)
                if(unitNum[bx][by] >= 0) [self DrawImage2:UC[unitNum[bx][by]].img x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by];
            
            if(buildTeam[bx][by] >= 0) [self DrawImage:buildTeamImg[buildTeam[bx][by]] x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by];
            if(unitTeam[bx][by] >= 0) [self DrawImage:unitTeamImg[unitTeam[bx][by]] x:(bx-1)*32 y:(by-1)*32 cx:bx cy:by];
            
            
        }
    
    }
    
    if(EEGCslctFlag) [self DrawImage:chip2 x:(eSlctX - 1)*32 y:(eSlctY -1)*32 cx:0 cy:0];
    if(eventPosFlag) [self DrawImage:chip2 x:(eSlctX - 1)*32 y:(eSlctY -1)*32 cx:0 cy:0];
}

-(void)initMapChipFileDirectory{
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];

    NSData *InitialData = [NSData dataWithContentsOfFile:@"Map/preset.txt"];
    
    NSString *path = @"Map";
    NSString *pathDATA = @"Map/MD00.txt";
    NSString *fileData = nil;
    if(!InitialData){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA contents:nil attributes:nil];
        

        NSString *data2 =
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"####\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"00,00,00,00,00,00,00,00,00,00,00,00,00,00,00\n"
        @"####\n"
        @"0,0,0\n"
        @"####\n"
        @"0,0,0\n"
        @"####\n"
        @"0,0,0\n"
        @"####\n"
        @"0,0,0"
        ;

        
        
        fileData = [NSString stringWithFormat:@"%@", data2];
        
        [fileData writeToFile:pathDATA atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }

    for(int i = 0;i<=1000;i++){
        for(int j = 0;j<= 1000;j++){
            chipNum[i][j] = 0;
            buildNum[i][j] = -1;
            unitNum[i][j] = -1;
            loadNum[i][j] = -1;
            buildTeam[i][j] = -1;
            unitTeam[i][j] = -1;
        }
    }
    
    fileData = [NSString stringWithContentsOfFile:pathDATA encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];

    int chipType = 0;
    int chipIndexDelta = 0;
    for(int i=1;i <= [fileDataArray count];i++){
        NSArray *items = [[fileDataArray objectAtIndex:i-1] componentsSeparatedByString:@","];
        
        NSRange rangeSearch = [[items objectAtIndex:0] rangeOfString:@"####"];
        
        if(rangeSearch.location != NSNotFound){
            chipType++;
            continue;
        }
        
        for(int j=1;j <= [items count];j++){
            unitTeam[i][j] = -1;
            buildTeam[i][j] = -1;
        }
        
        if(chipType == 0){chipIndexDelta++;
            for(int j=1;j <= [items count];j++){
                chipNum[j][i] = [[items objectAtIndex:j-1] intValue];
                chipWidth = (int)[items count];
                chipHeight = chipIndexDelta;
            }
        }else if(chipType == 1){
            for(int j=1;j <= [items count];j++){
                buildNum[j][i - chipIndexDelta-1] = [[items objectAtIndex:j-1] intValue]-1;
            }
        }else if(chipType == 2){
            for(int j=1;j <= [items count];j++){
                unitNum[[[items objectAtIndex:2] intValue]][[[items objectAtIndex:1] intValue]] = [[items objectAtIndex:0] intValue]-1;
            }
        }else if(chipType == 3){
            for(int j=1;j <= [items count];j++){
                buildTeam[[[items objectAtIndex:2] intValue]][[[items objectAtIndex:1] intValue]] = [[items objectAtIndex:0] intValue];
            }
        }else if(chipType == 4){
            for(int j=1;j <= [items count];j++){
                unitTeam[[[items objectAtIndex:2] intValue]][[[items objectAtIndex:1] intValue]] = [[items objectAtIndex:0] intValue];
            }
        }else if(chipType == 5){
            for(int j=1;j <= [items count];j++){
                loadNum[[[items objectAtIndex:2] intValue]][[[items objectAtIndex:1] intValue]] = [[items objectAtIndex:0] intValue]-1;
            }
        }
    }
    
    
    mapSizeChangedFlag = true;
}

-(void)loadMapChip{
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSString *fileData = @"";
    NSString *pathDATA = @"Map/";
    
    for(int i = 0;i<=1000;i++){
        for(int j = 0;j<= 1000;j++){
            chipNum[i][j] = 0;
            buildNum[i][j] = -1;
            unitNum[i][j] = -1;
            loadNum[i][j] = -1;
            buildTeam[i][j] = -1;
            unitTeam[i][j] = -1;
        }
    }
    if(!mapInitFlag){
        pathDATA = [pathDATA stringByAppendingFormat:@"%@", MF[MFselectedRow+1].fileName];
    }else if(mapInitFlag){
        pathDATA = [[pathDATA stringByAppendingFormat:@"%@", [SC[storyNumb].nameMAP objectAtIndex:scenarioNumb]] retain];
    }
    
    NSLog(@"%@", pathDATA);
    
    fileData = [NSString stringWithContentsOfFile:pathDATA encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    
    
    if(!fileData){
        mapChipDataLoadFail = true;
        return;
    }
    
    int chipType = 0;
    int chipIndexDelta = 0;
    int chipIndexDelta2 = 0;
    
    NSLog(@"fileDataArray Count:%d", (int)[fileDataArray count]);
    
    int indexCnt = 0;
    
    for(int i=1;i <= [fileDataArray count];i++){indexCnt++;
        if([fileDataArray objectAtIndex:0] == NULL) break;
        NSArray *items = [[fileDataArray objectAtIndex:i-1] componentsSeparatedByString:@","];
        
        NSRange rangeSearch = [[items objectAtIndex:0] rangeOfString:@"####"];
        
        if(rangeSearch.location != NSNotFound){
            chipType++;
            continue;
        }
        
        if(chipType == 0){chipIndexDelta++;
            for(int j=1;j <= [items count] && [items count] >= 2;j++){
                chipNum[j][i] = [[items objectAtIndex:j-1] intValue];
                chipWidth = (int)[items count];
                chipHeight = chipIndexDelta;
            }
        }else if(chipType == 1){chipIndexDelta2++;
            for(int j=1;j <= [items count] && [items count] >= 2;j++){
                buildNum[j][i - chipIndexDelta-1] = [[items objectAtIndex:j-1] intValue]-1;
            }
        }else if(chipType == 2){
            for(int j=1;j <= [items count] && [items count] >= 2;j++){
                unitNum[[[items objectAtIndex:1] intValue]][[[items objectAtIndex:2] intValue]] = [[items objectAtIndex:0] intValue]-1;
            }
        }else if(chipType == 3){
            for(int j=1;j <= [items count] && [items count] >= 2;j++){
                buildTeam[[[items objectAtIndex:1] intValue]][[[items objectAtIndex:2] intValue]] = [[items objectAtIndex:0] intValue];
            }
        }else if(chipType == 4){
            for(int j=1;j <= [items count] && [items count] >= 2;j++){
                unitTeam[[[items objectAtIndex:1] intValue]][[[items objectAtIndex:2] intValue]] = [[items objectAtIndex:0] intValue];
            }
        }else if(chipType == 5){
            for(int j=1;j <= [items count] && [items count] >= 2;j++){
                loadNum[[[items objectAtIndex:1] intValue]][[[items objectAtIndex:2] intValue]] = [[items objectAtIndex:0] intValue]-1;
            }
        }
        
        NSRange rangeSearch2 = [[items objectAtIndex:0] rangeOfString:@"----"];
        
        if(rangeSearch2.location != NSNotFound){
            break;
        }
    }
    
    
    bool EGdarkFlag = false;
    
    if(mapInitFlag){
    MFselectedRow = 0;
    for (int i = 1;i < 512;i++) {
        if([[SC[storyNumb].nameMAP objectAtIndex:scenarioNumb] isEqualToString:[NSString stringWithFormat:@"%@", MF[i].fileName]])
            break;
        MFselectedRow++;
    }
    }
    
    
    int EGcnt = 0;
    for(int i = indexCnt;i < [fileDataArray count];i++){indexCnt++;
        NSArray *items = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@"|"];
        EGcnt++;
        
        NSRange rangeSearch = [[items objectAtIndex:0] rangeOfString:@"####"];
        
        if(rangeSearch.location != NSNotFound){
            EGdarkFlag = true;
            EGcnt = 0;
        }
        
        if(!EGdarkFlag){
            
            if(EGcnt == 1){
                MF[MFselectedRow+1].MS.EGClight.endType1 = [[items objectAtIndex:0] intValue];
                MF[MFselectedRow+1].MS.EGClight.endType2 = [[items objectAtIndex:1] intValue];
            }else if(EGcnt == 2){
                for(int k = 0;k < 64;k++){
                    if(k > [items count]-1) break;
                    if([[items objectAtIndex:k] isEqualToString:@"NULL"]) break;
                    MF[MFselectedRow+1].MS.EGClight.etValue1[k] = [[items objectAtIndex:k] retain];
                }
            }else if(EGcnt == 3){
                for(int k = 0;k < 64;k++){
                    if(k > [items count]-1) break;
                    if([[items objectAtIndex:k] isEqualToString:@"NULL"]) break;
                    MF[MFselectedRow+1].MS.EGClight.etValue2[k] = [[items objectAtIndex:k] retain];
                }
            }
        
        }else{
            if(EGcnt == 1){
                MF[MFselectedRow+1].MS.EGCdark.endType1 = [[items objectAtIndex:0] intValue];
                MF[MFselectedRow+1].MS.EGCdark.endType2 = [[items objectAtIndex:1] intValue];
            }else if(EGcnt == 2){
                for(int k = 0;k < 64;k++){
                    if(k > [items count]-1) break;
                    if([[items objectAtIndex:k] isEqualToString:@"NULL"]) break;
                    MF[MFselectedRow+1].MS.EGCdark.etValue1[k] = [[items objectAtIndex:k] retain];
                }
            }else if(EGcnt == 3){
                for(int k = 0;k < 64;k++){
                    if(k > [items count]-1) break;
                    if([[items objectAtIndex:k] isEqualToString:@"NULL"]) break;
                    MF[MFselectedRow+1].MS.EGCdark.etValue2[k] = [[items objectAtIndex:k] retain];
                }
            }
        
        
        
        }
        if([[fileDataArray objectAtIndex:i] isEqualToString:@"----"])
            break;
    }
    
    NSArray *items = [[fileDataArray objectAtIndex:indexCnt] componentsSeparatedByString:@","];
    
    playerSet1 = [[items objectAtIndex:0] intValue];
    playerSet2 = [[items objectAtIndex:1] intValue];
    battleSetMode = [[items objectAtIndex:2] intValue];
    
    MF[MFselectedRow+1].MS.playerSet1 = playerSet1;
    MF[MFselectedRow+1].MS.playerSet2 = playerSet2;
    MF[MFselectedRow+1].MS.battleSetMode = battleSetMode;
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    [MS.SCRPTname removeAllObjects];
    MAPSCRIPTD *MSDtop = NULL;
    MAPSCRIPT0 *MSDPtop = NULL;
  
    fileData = [NSString stringWithContentsOfFile:pathDATA encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"========\nEVENT\n========\n"];
    
    NSString *fileData2 = [fileDataArray objectAtIndex:1];
    
    fileDataArray = [fileData2 componentsSeparatedByString:@"\n"];
  
    int eventIndex = 0;
    int scriptIndex = 0;
    int indent = 0;
    static bool supFlag = false;
    static bool supFlag2 = false;
    static bool asdflag = false;
    
    for (int i = 0;i < [fileDataArray count]; i++) {
        NSArray *items = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@","];
        NSRange rangeSearch = [[fileDataArray objectAtIndex:i] rangeOfString:@"●"];
        NSArray *array3 = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@"◆"];
                           NSString *string2 = [NSString stringWithFormat:@"%@◆", [array3 objectAtIndex:0]];
        NSRange rangeSearch2 = [[fileDataArray objectAtIndex:i] rangeOfString:string2];
        
        
        if (rangeSearch.location == !NSNotFound) {
            
            if(supFlag){
                //MS.D->P->S1.str = [MS.D->P->S1.str substringToIndex:MS.D->P->S1.str.length-3];
                
                MS.D->P = MSDPtop;
                MS.D->next = calloc(1, sizeof(MAPSCRIPTD));
                MS.D = MS.D->next;
                MSDPtop = MS.D->P;
                asdflag = true;
            }
            if(!supFlag){
                MS.D = calloc(1, sizeof(MAPSCRIPTD));
                MSDtop = MS.D;
                MS.SCRPTname = [NSMutableArray new];
                supFlag = true;
            }
            if(!MS.D){

            }else {
                if(!MS.D->P){
                    MS.D->P = MSDPtop;
                }
            }
            NSArray *items2 = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@" "];
            NSString *string = [[items2 objectAtIndex:0] substringFromIndex:1];
            
            [MS.SCRPTname addObject:string];
            
            if([items2 count] >= 2){
                NSArray *items3 = [[items2 objectAtIndex:1] componentsSeparatedByString:@"["];
                MS.D->type = [[items3 objectAtIndex:0] intValue];
                NSArray *items4 = [[items3 objectAtIndex:1] componentsSeparatedByString:@","];
                MS.D->x = [[items4 objectAtIndex:0] intValue];
                MS.D->y = [[items4 objectAtIndex:1] intValue];
                
                
                NSArray *items51 = [[items2 objectAtIndex:1] componentsSeparatedByString:@"ON["];
                if([items51 count] > 1){
                NSArray *items5 = [[items51 objectAtIndex:1] componentsSeparatedByString:@"OFF["];
                NSArray *items6 = [[items5 objectAtIndex:0] componentsSeparatedByString:@","];
                if([items6 objectAtIndex:0] > 0){
                if([items6 count] > 0 && [items6 objectAtIndex:0] > 0)
                 MS.D->switch1 = calloc([items6 count], sizeof(int));
                    MS.D->switch1f = true;
                for (int i = 0;[items6 count] > i && [[items6 objectAtIndex:i] intValue] > 0;i++) {
                    *(MS.D->switch1+i) = [[items6 objectAtIndex:i] intValue];
                }
                }
                }
               
                NSArray *items7 = [[items2 objectAtIndex:1] componentsSeparatedByString:@"OFF["];
                if([items7 count] > 1){
                NSArray *items8 = [[items7 objectAtIndex:1] componentsSeparatedByString:@","];
                if([items8 objectAtIndex:0] > 0){
                if([items8 count] > 0 && [items8 objectAtIndex:0] > 0)
                    MS.D->switch2 = calloc([items8 count], sizeof(int));
                    MS.D->switch2f = true;
                for (int i = 0;[items8 count] > i && [[items8 objectAtIndex:i] intValue] > 0;i++) {
                    *(MS.D->switch2+i) = [[items8 objectAtIndex:i] intValue];
                }
                }
                }
                //NSLog(@"OMG %d,%d,%d", MS.D->type,MS.D->x,MS.D->y);
            }
            eventIndex++;
            scriptIndex = 0;
            continue;
        }
        
        if (rangeSearch2.location == !NSNotFound) {
            
            if(asdflag){
                MS.D->SCRPT = [NSMutableArray new];
                asdflag = false;
            }
            
            if(!supFlag2){
                MS.D->SCRPT = [NSMutableArray new];
                supFlag2 = true;
                MS.D->P = NULL;
            }
            
            if(!MS.D->P){
                MS.D->P = calloc(1, sizeof(MAPSCRIPT0));
                MSDPtop = MS.D->P;
                MS.D->SCRPT = [NSMutableArray new];
            }
            else {
                MS.D->P->next = calloc(1, sizeof(MAPSCRIPT0));
                MS.D->P = MS.D->P->next;
                MS.D->P->next = NULL;
            }
            
            NSArray *items0 = [[items objectAtIndex:0] componentsSeparatedByString:@"◆"];
            
            indent = [[items0 objectAtIndex:0] intValue];
            MS.D->P->type = [[items0 objectAtIndex:1] intValue];
            
            
            if(MS.D->P->type == 0){
                MS.D->P->indent = indent;
                MS.D->P->S1.nameID = [[items objectAtIndex:1] retain];
                MS.D->P->S1.name = [[items objectAtIndex:2] retain];
                MS.D->P->S1.iName = [[items objectAtIndex:3] retain];
                for(int k = 0; k < UCN;k++){
                    if(MS.D->P->S1.nameID)
                    if([MS.D->P->S1.nameID isEqualToString:UC[k].nameID]){
                        MS.D->P->S1.img = [UC[k].imgb retain];
                        break;
                    }
                }
                for(int k = 0; k < LCN;k++){
                    if(MS.D->P->S1.nameID)
                        if([MS.D->P->S1.nameID isEqualToString:LC[k].nameID]){
                            MS.D->P->S1.img = [UC[k].imgb retain];
                            break;
                        }
                }
                EIMG = EIMGtop;
                while (EIMG) {
                    if(MS.D->P->S1.nameID)
                        if([MS.D->P->S1.nameID isEqualToString:EIMG->name]){
                            MS.D->P->S1.img = [EIMG->img retain];
                            break;
                        }
                    EIMG = EIMG->next;
                }EIMG = EIMGtop;
                
                [MS.D->SCRPT addObject:@"◆文章の表示"];
                if(![MS.D->P->S1.name isEqualToString:@""])
                    [MS.D->SCRPT addObject:[NSString stringWithFormat:@"%@：", MS.D->P->S1.name]];
            }
            
            if(MS.D->P->type == 3){
                MS.D->P->indent = indent;
                if([[items objectAtIndex:1] isEqualToString:@"ON"]){
                    MSDPONOFFFlagNum = 1;
                }
                if([[items objectAtIndex:1] isEqualToString:@"OFF"]){
                    MSDPONOFFFlagNum = 2;
                }
                
                NSString *string;
                
                if(MSDPONOFFFlagNum == 1) string = @"ON";
                if(MSDPONOFFFlagNum == 2) string = @"OFF";
                
                [MS.D->SCRPT addObject:[NSString stringWithFormat:@"◆スイッチの操作%@", string]];
            }
            
            scriptIndex++;
            //continue;
        }else{
            
                if(MS.D){
                        {if(MS.D->P)
                            {if(MS.D->P->type == 0){
                                {    if(!MS.D->P->S1.str) {
                                    MS.D->P->S1.str = @"";
                                }
                                            NSString *string = @"";
                                            string = [[string stringByAppendingFormat:@"%@", [fileDataArray objectAtIndex:i]] retain];
                                    if([string isEqualToString:@""]) continue;
                                            MS.D->P->S1.str = [[MS.D->P->S1.str stringByAppendingString:string] retain];
                                    MS.D->P->S1.str = [[MS.D->P->S1.str stringByAppendingFormat:@"\n"] retain];
                                    if(![string isEqualToString:@""])
                                            [MS.D->SCRPT addObject:[NSString stringWithFormat:@"%@", [fileDataArray objectAtIndex:i]]];
                            
                                }
                            }if(MS.D->P->type == 3){
                                NSString *string = @"";
                                if(MSDPONOFFFlagNum == 1){
                                    NSArray *items0 = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@","];
                                    MS.D->P->switch1 = calloc([items0 count], sizeof(int));
                                    for (int i = 0;i < [items0 count];i++) {
                                        *(MS.D->P->switch1 + i) = [[items0 objectAtIndex:i] intValue];
                                        string = [string stringByAppendingFormat:@"%d",[[items0 objectAtIndex:i] intValue]];
                                        if(i+1 < [items0 count])
                                        string = [string stringByAppendingFormat:@","];
                                    }
                                }if(MSDPONOFFFlagNum == 2){
                                    NSArray *items0 = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@","];
                                    MS.D->P->switch2 = calloc([items0 count], sizeof(int));
                                    for (int i = 0;i < [items0 count];i++) {
                                        *(MS.D->P->switch2 + i) = [[items0 objectAtIndex:i] intValue];
                                        string = [string stringByAppendingFormat:@"%d",[[items0 objectAtIndex:i] intValue]];
                                        if(i+1 < [items0 count])
                                            string = [string stringByAppendingFormat:@","];
                                    }
                                }
                                [MS.D->SCRPT addObject:[NSString stringWithString:string]];
                            }
                            }
                        }
            }scriptIndex++;
        }
    }
    
    //MS.D->P->S1.str = [MS.D->P->S1.str substringToIndex:MS.D->P->S1.str.length-4];
    if(MS.D) MS.D->P = MSDPtop;
    MS.D = MSDtop;
    
    MSDTOPP = MSDtop;
    supFlag = false;
    supFlag2 = false;
    MF[MFselectedRow+1].MS = MS;
    mapSizeChangedFlag = true;
    mapLoadFlagForMSD = false;
    mapLoadFlagForMSD2 = false;
}

-(void)saveMapChip{
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];


    NSString *fileData = @"";
    NSString *pathDATA = @"Map/";

    for(int i = 1;i<= chipHeight;i++){
        for(int j = 1;j <= chipWidth;j++){
            fileData = [fileData stringByAppendingFormat:@"%2d", chipNum[j][i]];
            if(j == chipWidth) fileData = [fileData stringByAppendingFormat:@"\n"];
            else {
                fileData = [fileData stringByAppendingFormat:@","];
            }
        }
    }
    fileData = [fileData stringByAppendingFormat:@"####\n"];
    for(int i = 1;i<= chipHeight;i++){
        for(int j = 1;j <= chipWidth;j++){
            fileData = [fileData stringByAppendingFormat:@"%2d", buildNum[j][i]+1];
            if(j == chipWidth) fileData = [fileData stringByAppendingFormat:@"\n"];
            else {
                fileData = [fileData stringByAppendingFormat:@","];
            }
        }
    }
    fileData = [fileData stringByAppendingFormat:@"####\n"];
    for(int i = 1;i<= chipHeight;i++){
        for(int j = 1;j <= chipWidth;j++){
            if(unitNum[j][i] != -1){
                fileData = [fileData stringByAppendingFormat:@"%d", unitNum[j][i]+1];
                fileData = [fileData stringByAppendingFormat:@","];
                fileData = [fileData stringByAppendingFormat:@"%d", j];
                fileData = [fileData stringByAppendingFormat:@","];
                fileData = [fileData stringByAppendingFormat:@"%d", i];
                fileData = [fileData stringByAppendingFormat:@"\n"];
            }
        }
    }
    fileData = [fileData stringByAppendingFormat:@"####\n"];
    for(int i = 1;i<= chipHeight;i++){
        for(int j = 1;j <= chipWidth;j++){
            if(buildTeam[j][i] != -1){
                fileData = [fileData stringByAppendingFormat:@"%d", buildTeam[j][i]];
                fileData = [fileData stringByAppendingFormat:@","];
                fileData = [fileData stringByAppendingFormat:@"%d", j];
                fileData = [fileData stringByAppendingFormat:@","];
                fileData = [fileData stringByAppendingFormat:@"%d", i];
                fileData = [fileData stringByAppendingFormat:@"\n"];
            }
        }
    }
    fileData = [fileData stringByAppendingFormat:@"####\n"];
    for(int i = 1;i<= chipHeight;i++){
        for(int j = 1;j <= chipWidth;j++){
            if(unitTeam[j][i] != -1){
                fileData = [fileData stringByAppendingFormat:@"%d", unitTeam[j][i]];
                fileData = [fileData stringByAppendingFormat:@","];
                fileData = [fileData stringByAppendingFormat:@"%d", j];
                fileData = [fileData stringByAppendingFormat:@","];
                fileData = [fileData stringByAppendingFormat:@"%d", i];
                fileData = [fileData stringByAppendingFormat:@"\n"];
            }
        }
    }
    fileData = [fileData stringByAppendingFormat:@"####\n"];
    for(int i = 1;i<= chipHeight;i++){
        for(int j = 1;j <= chipWidth;j++){
            if(loadNum[j][i] != -1){
                fileData = [fileData stringByAppendingFormat:@"%d", loadNum[j][i]+1];
                fileData = [fileData stringByAppendingFormat:@","];
                fileData = [fileData stringByAppendingFormat:@"%d", j];
                fileData = [fileData stringByAppendingFormat:@","];
                fileData = [fileData stringByAppendingFormat:@"%d", i];
                fileData = [fileData stringByAppendingFormat:@"\n"];
            }
        }
    }
    
    
    fileData = [fileData stringByAppendingFormat:@"----\n"];
    fileData = [fileData stringByAppendingFormat:@"%d|%d",
                MF[MFselectedRow+1].MS.EGClight.endType1,
                MF[MFselectedRow+1].MS.EGClight.endType2];
    fileData = [fileData stringByAppendingFormat:@"\n"];
    for (int i = 0; i < 64;i++) {
        if(i == 0 && !MF[MFselectedRow+1].MS.EGClight.etValue1[i])
            fileData = [fileData stringByAppendingFormat:@"NULL"];
        if(!MF[MFselectedRow+1].MS.EGClight.etValue1[i]) break;
        if(i > 0) fileData = [fileData stringByAppendingFormat:@"|"];
        fileData = [fileData stringByAppendingFormat:@"%@",
                    MF[MFselectedRow+1].MS.EGClight.etValue1[i]];
    }fileData = [fileData stringByAppendingFormat:@"\n"];
    
    //NSLog(@"%@", fileData);
    
    for (int i = 0; i < 64;i++) {
        if(i == 0 && !MF[MFselectedRow+1].MS.EGClight.etValue2[i])
            fileData = [fileData stringByAppendingFormat:@"NULL"];
        if(!MF[MFselectedRow+1].MS.EGClight.etValue2[i]) break;
        if(i > 0) fileData = [fileData stringByAppendingFormat:@"|"];
        fileData = [fileData stringByAppendingFormat:@"%@",
                    MF[MFselectedRow+1].MS.EGClight.etValue2[i]];
    }fileData = [fileData stringByAppendingFormat:@"\n"];
    
    fileData = [fileData stringByAppendingFormat:@"####\n"];
    
    fileData = [fileData stringByAppendingFormat:@"%d|%d",
                MF[MFselectedRow+1].MS.EGCdark.endType1,
                MF[MFselectedRow+1].MS.EGCdark.endType2];
    fileData = [fileData stringByAppendingFormat:@"\n"];
    for (int i = 0; i < 64;i++) {
        if(i == 0 && !MF[MFselectedRow+1].MS.EGCdark.etValue1[i])
            fileData = [fileData stringByAppendingFormat:@"NULL"];
        if(!MF[MFselectedRow+1].MS.EGCdark.etValue1[i]) break;
        if(i > 0) fileData = [fileData stringByAppendingFormat:@"|"];
        fileData = [fileData stringByAppendingFormat:@"%@",
                    MF[MFselectedRow+1].MS.EGCdark.etValue1[i]];
    }fileData = [fileData stringByAppendingFormat:@"\n"];
    
    for (int i = 0; i < 64;i++) {
        if(i == 0 && !MF[MFselectedRow+1].MS.EGCdark.etValue2[i])
            fileData = [fileData stringByAppendingFormat:@"NULL"];
        if(!MF[MFselectedRow+1].MS.EGCdark.etValue2[i]) break;
        if(i > 0) fileData = [fileData stringByAppendingFormat:@"|"];
        fileData = [fileData stringByAppendingFormat:@"%@",
                    MF[MFselectedRow+1].MS.EGCdark.etValue2[i]];
    }fileData = [fileData stringByAppendingFormat:@"\n"];
    
    fileData = [fileData stringByAppendingFormat:@"----\n"];
    
    fileData = [fileData stringByAppendingFormat:@"%d,%d,%d\n", playerSet1, playerSet2, battleSetMode];
    
    fileData = [fileData stringByAppendingFormat:@"========\nEVENT\n========\n"];
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    int index = 0;
    while(MS.D){
        MAPSCRIPT0 *MSPtop = MS.D->P;
        if(!MS.D->P) break;
        fileData = [fileData stringByAppendingFormat:@"●"];
        fileData = [fileData stringByAppendingFormat:@"%@ ", [MS.SCRPTname objectAtIndex:index]];
        fileData = [fileData stringByAppendingFormat:@"%d[%d,%d]", MS.D->type,MS.D->x, MS.D->y];
        if(MS.D->switch1)
        if(*MS.D->switch1 > 0){
        fileData = [fileData stringByAppendingFormat:@"ON["];
        for(int i = 0;*(MS.D->switch1+i) > 0;i++){
            fileData = [fileData stringByAppendingFormat:@"%d", *(MS.D->switch1+i)];
            if(*(MS.D->switch1+i+1)>0)
                [fileData stringByAppendingFormat:@","];
        }
            fileData = [fileData stringByAppendingFormat:@"]"];
        }
        if(MS.D->switch2)
        if(*MS.D->switch2 > 0){
        fileData = [fileData stringByAppendingFormat:@"OFF["];
        for(int i = 0;*(MS.D->switch2+i) > 0;i++){
            fileData = [fileData stringByAppendingFormat:@"%d", *(MS.D->switch2+i)];
            if(*(MS.D->switch2+i+1)>0)
                [fileData stringByAppendingFormat:@","];
        }
            fileData = [fileData stringByAppendingFormat:@"]"];
        }
        fileData = [fileData stringByAppendingFormat:@"\n"];
        
        while(MS.D->P){
            if(MS.D->P->type == 0){
                fileData = [fileData stringByAppendingFormat:@"%d", MS.D->P->indent];
                fileData = [fileData stringByAppendingFormat:@"◆0,"];
                fileData = [fileData stringByAppendingFormat:@"%@,", MS.D->P->S1.nameID];
                fileData = [fileData stringByAppendingFormat:@"%@,", MS.D->P->S1.name];
                fileData = [fileData stringByAppendingFormat:@"%@\n", MS.D->P->S1.iName];
                fileData = [fileData stringByAppendingFormat:@"%@\n", MS.D->P->S1.str];
            }
            if(MS.D->P->type == 3){
                fileData = [fileData stringByAppendingFormat:@"%d", MS.D->P->indent];
                fileData = [fileData stringByAppendingFormat:@"◆3,"];
                if(MS.D->P->switch1) if(MS.D->P->switch1 > 0) fileData = [fileData stringByAppendingFormat:@"ON"];
                if(MS.D->P->switch2) if(MS.D->P->switch2 > 0) fileData = [fileData stringByAppendingFormat:@"OFF"];
                fileData = [fileData stringByAppendingFormat:@"\n"];
                if(MS.D->P->switch1) for(int i = 0;*(MS.D->P->switch1+ i) > 0;i++){
                    fileData = [fileData stringByAppendingFormat:@"%d", *(MS.D->P->switch1 + i)];
                    if(*(MS.D->P->switch1 + i + 1) > 0) fileData = [fileData stringByAppendingFormat:@","];
                }
                if(MS.D->P->switch2) for(int i = 0;*(MS.D->P->switch2+i) > 0;i++){
                    fileData = [fileData stringByAppendingFormat:@"%d", *(MS.D->P->switch2 + i)];
                    if(*(MS.D->P->switch2 + i + 1) > 0) fileData = [fileData stringByAppendingFormat:@","];
                }
                fileData = [fileData stringByAppendingFormat:@"\n"];
            }
            MS.D->P = MS.D->P->next;
        }
        
        MS.D->P = MSPtop;
        MS.D = MS.D->next;
        index++;
    }
    
    NSLog(@"%@", fileData);
    MS = MF[MFselectedRow+1].MS;
    pathDATA = [pathDATA stringByAppendingFormat:@"%@", saveMapDataName];
    [[NSFileManager defaultManager] createFileAtPath:pathDATA contents:nil attributes:nil];
    [fileData writeToFile:pathDATA atomically:YES encoding:NSUTF8StringEncoding error:nil];

}


@end
