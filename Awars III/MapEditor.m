//
//  MapEditor.m
//  Awars III
//
//  Created by Killery on 2012/12/06.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import "MapEditor.h"

@implementation MapEditor
-(void)awakeFromNib{

    [TFcurrentChipIndex setStringValue:[NSString stringWithFormat:@"%d/%d", MapChipListIndex,MapChipMax]];
    
    [loadMapListTV setTarget:self];
    [loadMapListTV setDoubleAction:@selector(doubleClickLM:)];
    
    [saveMapListTV setTarget:self];
    [saveMapListTV setDoubleAction:@selector(doubleClickSM:)];
    
    [eventListTV setTarget:self];
    [eventListTV setAction:@selector(ClickEL:)];
    [eventListTV setDoubleAction:@selector(doubleClickEL:)];
    
    [eventPosTV setTarget:self];
    [eventPosTV setDoubleAction:@selector(doubleClickPos:)];
    
    
    [eventDetailListTV setTarget:self];
    [eventDetailListTV setAction:@selector(ClickEDL:)];
    [eventDetailListTV setDoubleAction:@selector(doubleClickEDL:)];
    
    [EDtextImageTV setTarget:self];
    [EDtextImageTV setAction:@selector(ClickEDTI:)];
    
    [EDswitch1TV setTarget:self];
    [EDswitch1TV setDoubleAction:@selector(doubleClickSW1:)];
    
    [EDswitch2TV setTarget:self];
    [EDswitch2TV setDoubleAction:@selector(doubleClickSW2:)];
    
    [EDvariableTV setTarget:self];
    [EDvariableTV setDoubleAction:@selector(doubleClickVAR:)];
    
    [EEGC1TV setTarget:self];
    [EEGC1TV setAction:@selector(clickEEGC1:)];
    [EEGC2TV setTarget:self];
    [EEGC2TV setAction:@selector(clickEEGC2:)];
    
    [EDselectionTV setTarget:self];
    [EDselectionTV setAction:@selector(ClickSEL:)];
    
    [EDvalueTV setTarget:self];
    [EDvalueTV setDoubleAction:@selector(doubleClickVAL:)];
    
    [EDvarTV setTarget:self];
    [EDvarTV setDoubleAction:@selector(doubleClickVA:)];
    
    [EDvarHensuTV setTarget:self];
    [EDvarHensuTV setDoubleAction:@selector(doubleClickHEN:)];
    
    [EDresourceTV setTarget:self];
    [EDresourceTV setDoubleAction:@selector(doubleClickRES:)];
    
    [EDhp1TV setTarget:self];
    [EDhp1TV setDoubleAction:@selector(doubleClickHP1:)];
    
    [EDhp2TV setTarget:self];
    [EDhp2TV setDoubleAction:@selector(doubleClickHP2:)];
    
    [EDmp1TV setTarget:self];
    [EDmp1TV setDoubleAction:@selector(doubleClickMP1:)];
    
    [EDmp2TV setTarget:self];
    [EDmp2TV setDoubleAction:@selector(doubleClickMP2:)];
    
    [EDstA1TV setTarget:self];
    [EDstA1TV setDoubleAction:@selector(doubleClickSTA1:)];
    
    [EDstA2TV setTarget:self];
    [EDstA2TV setDoubleAction:@selector(doubleClickSTA2:)];
    
    [EDstB1TV setTarget:self];
    [EDstB1TV setDoubleAction:@selector(doubleClickSTB1:)];
    
    [EDstB2TV setTarget:self];
    [EDstB2TV setDoubleAction:@selector(doubleClickSTB2:)];
    
    EEGC1MA = [NSMutableArray new];
    EEGC2MA = [NSMutableArray new];
    
    eventListMA = [NSMutableArray new];
    eventPosMA = [NSMutableArray new];
    eventDetailListMA = [NSMutableArray new];
    EDswitch1MA = [NSMutableArray new];
    EDswitch2MA = [NSMutableArray new];
    EDvariableMA = [NSMutableArray new];
    EDtextImageMA = [NSMutableArray new];
    EDselectionMA = [NSMutableArray new];
    EDvalueMA = [NSMutableArray new];
    EDvarMA = [NSMutableArray new];
    EDvarHensuMA = [NSMutableArray new];
    EDresourceMA = [NSMutableArray new];
    EDhp1MA = [NSMutableArray new];
    EDhp2MA = [NSMutableArray new];
    EDmp1MA = [NSMutableArray new];
    EDmp2MA = [NSMutableArray new];
    EDstA1MA = [NSMutableArray new];
    EDstA2MA = [NSMutableArray new];
    EDstB1MA = [NSMutableArray new];
    EDstB2MA = [NSMutableArray new];
    
}

-(id)init{
    if (self) {
        time0  = [NSTimer
                 scheduledTimerWithTimeInterval:0.05f
                 target:self
                 selector:@selector(EventLoop0:)
                 userInfo:nil
                 repeats:YES
                 ];
        
        scCenter.origin.x = [NSScreen mainScreen].frame.size.width/2 - 640/2;
        scCenter.origin.y = [NSScreen mainScreen].frame.size.height/2 - 480/2;
        headerFrame = 20;
        
        MapChipListIndex = 1;
        BuildChipListIndex = 1;
        UnitChipListIndex = 1;
        LoadChipListIndex = 1;
        loadMapListMA = [NSMutableArray new];
        [self initLoadMapList];
        saveMapListMA = [NSMutableArray new];
        [self initSaveMapList];
        [self loadEventImage];
        MFselectedRow = -1;
        
    }
    return self;
}

-(void)EDdeleteFunc:(MAPSCRIPT)MS msd:(MAPSCRIPTD*)MSD{
    int cnt = 0;
    int instantCnt = 0;
    int instantCnt2 = 0;
    for (int i = 0;i < [MSD->SCRPT count];i++) {
        NSArray *array = [[MSD->SCRPT objectAtIndex:i] componentsSeparatedByString:@"◆"];
        if([array count] >= 2){
            instantCnt++;
        }
        
        if(instantCnt == squareCnt){
            instantCnt2++;
            cnt--;
        }
        if(instantCnt == squareCnt + 1){
            break;
        }
        cnt++;
    }
    
    [self willChangeValueForKey:@"eventDetailListMA"];
    for(int i = 0;i < instantCnt2;i++){
        
        [MSD->SCRPT removeObjectAtIndex:cnt];
        [eventDetailListMA removeObjectAtIndex:EDrow];
        
    }
    [self didChangeValueForKey:@"eventDetailListMA"];
    
    [eventDetailListAC setSelectionIndex:EDrow];
    
    squareCnt = 1;
    for(int i = 0;i < EDrow;i++){
        NSArray *array = nil;
        if([MS.D->SCRPT count] > 0){
            array = [[MS.D->SCRPT objectAtIndex:i] componentsSeparatedByString:@"◆"];
        }
        if([array count] >= 2){
            squareCnt++;
        }
    }
    
    MAPSCRIPT0 *MS0top = MS.D->P;
    
    if(!MS.D->P){
        MS.D->P = calloc(1, sizeof(MAPSCRIPT0));
        MS0top = MS.D->P;
    }else if(MS.D->P){
        
        if(squareCnt == 1){
            MAPSCRIPT0 *temp = MS.D->P->next;
            MS.D->P = temp;
            MS0top = MS.D->P;
        }else if(squareCnt > 1){
            for (int i = 0; i < squareCnt-2; i++) {
                MS.D->P = MS.D->P->next;
            }
            MAPSCRIPT0 *temp = MS.D->P->next->next;
            MS.D->P->next = temp;
        }
        
    }
    MS.D->P = MS0top;
}


-(void)EventLoop0:(NSTimer*)time{
    
    if(SLSx == 2){
    [topIV setImage:UC[SLindexU].imgb];
    
    [topName setStringValue:[NSString stringWithFormat:@"%@", UC[SLindexU].name]];
    
    [topHealth setStringValue:[NSString stringWithFormat:@"HP %g", UC[SLindexU].S_M.HP]];
    }else if(SLSx == 3){
        [topIV setImage:LC[SLindexL].imgb];
        
        [topName setStringValue:[NSString stringWithFormat:@"%@", LC[SLindexL].name]];
        
        [topHealth setStringValue:[NSString stringWithFormat:@"HP %g", LC[SLindexL].S_M.HP]];
    }
    if(SLSx == 0) [TFcurrentChipIndex setStringValue:[NSString stringWithFormat:@"%d/%d", MapChipListIndex,MapChipMax]];
    if(SLSx == 1) [TFcurrentChipIndex setStringValue:[NSString stringWithFormat:@"%d/%d", BuildChipListIndex,BuildChipMax]];
    if(SLSx == 2) [TFcurrentChipIndex setStringValue:[NSString stringWithFormat:@"%d/%d", UnitChipListIndex,UnitChipMax]];
    if(SLSx == 3) [TFcurrentChipIndex setStringValue:[NSString stringWithFormat:@"%d/%d", LoadChipListIndex,LoadChipMax]];
    
    if(DoubleClicked){DoubleClicked = false;
        windowPoint.x = [MapEditorWindow frame].origin.x;
        windowPoint.y = [MapEditorWindow frame].origin.y;
   
        if(SLSx == 0){
        
            loadChipSideFlag = false;
            
            [PMCL setFrameOrigin:windowPoint];
        
            [PMCL makeKeyAndOrderFront:nil];
    
        }
    
        if(SLSx == 1){
        
            loadChipSideFlag = false;
            
            [PBCL setFrameOrigin:windowPoint];
        
            [PBCL makeKeyAndOrderFront:nil];
   
        }
    
        if(SLSx == 2){
        
            loadChipSideFlag = false;
            
            [PUCL setFrameOrigin:windowPoint];
        
            [PUCL makeKeyAndOrderFront:nil];
    
        }
        
        if(SLSx == 3){
            
            loadChipSideFlag = true;
            
            [PLCL setFrameOrigin:windowPoint];
            
            [PLCL makeKeyAndOrderFront:nil];
            
        }
        
    }

    
    
    if(MF[MFselectedRow+1].MS.EGClight.endType1 == 0 || MF[MFselectedRow+1].MS.EGCdark.endType1 == 0){
        MF[MFselectedRow+1].MS.EGClight.endType1 = 1;
        MF[MFselectedRow+1].MS.EGCdark.endType1 = 2;
        
        [self EEGCset:MF[MFselectedRow+1].MS.EGClight flag:YES];
        [self EEGCset:MF[MFselectedRow+1].MS.EGCdark flag:NO];
    }
    
    if(doubleClickedFlag && EEGCslctFlag){
    
        if(!EEGCslctFlag2){
        
            if(EEGCslctCnt == 2 || EEGCslctCnt == 3){
                if(unitNum[eSlctX][eSlctY] > -1){
                
                    if(EEGCflag == 1){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                
                        [dict setValue:[NSString stringWithFormat:@"%@[%d,%d]", UC[unitNum[eSlctX][eSlctY]].name, eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC1MA"];
                        [EEGC1MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC1MA"];
                    }
                    if(EEGCflag == 2){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                    
                        [dict setValue:[NSString stringWithFormat:@"%@[%d,%d]", UC[unitNum[eSlctX][eSlctY]].name, eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC1MA"];
                        [EEGC1MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC1MA"];
                    }
                }
            }else if(EEGCslctCnt == 4){
                if(1){
                    if(EEGCflag == 1){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                        
                        [dict setValue:[NSString stringWithFormat:@"[%d,%d]", eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC1MA"];
                        [EEGC1MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC1MA"];
                    }
                    if(EEGCflag == 2){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                    
                        [dict setValue:[NSString stringWithFormat:@"[%d,%d]", eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC1MA"];
                        [EEGC1MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC1MA"];
                    }
                }
            }if(EEGCslctCnt == 5){
                if(buildNum[eSlctX][eSlctY] > -1){
                
                    if(EEGCflag == 1){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                    
                        [dict setValue:[NSString stringWithFormat:@"%@[%d,%d]", BC[buildNum[eSlctX][eSlctY]].name, eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC1MA"];
                        [EEGC1MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC1MA"];
                    }
                    if(EEGCflag == 2){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                    
                        [dict setValue:[NSString stringWithFormat:@"%@[%d,%d]", BC[buildNum[eSlctX][eSlctY]].name, eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC1MA"];
                        [EEGC1MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC1MA"];
                    }
                }
            }
      
        }else if(EEGCslctFlag2){
        
            if(EEGCslctCnt == 3 || EEGCslctCnt == 4){
                if(unitNum[eSlctX][eSlctY] > -1){
                    
                    if(EEGCflag == 1){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                        
                        [dict setValue:[NSString stringWithFormat:@"%@[%d,%d]", UC[unitNum[eSlctX][eSlctY]].name, eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC2MA"];
                        [EEGC2MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC2MA"];
                    }
                    if(EEGCflag == 2){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                        
                        [dict setValue:[NSString stringWithFormat:@"%@[%d,%d]", UC[unitNum[eSlctX][eSlctY]].name, eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC2MA"];
                        [EEGC2MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC2MA"];
                    }
                }
            }else if(EEGCslctCnt == 5){
                if(1){
                    if(EEGCflag == 1){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                        
                        [dict setValue:[NSString stringWithFormat:@"[%d,%d]", eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC2MA"];
                        [EEGC2MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC2MA"];
                    }
                    if(EEGCflag == 2){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                        
                        [dict setValue:[NSString stringWithFormat:@"[%d,%d]", eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC2MA"];
                        [EEGC2MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC2MA"];
                    }
                }
            }if(EEGCslctCnt == 6){
                if(buildNum[eSlctX][eSlctY] > -1){
                    
                    if(EEGCflag == 1){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                        
                        [dict setValue:[NSString stringWithFormat:@"%@[%d,%d]", BC[buildNum[eSlctX][eSlctY]].name, eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC2MA"];
                        [EEGC2MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC2MA"];
                    }
                    if(EEGCflag == 2){
                        NSMutableDictionary* dict = [NSMutableDictionary new];
                        
                        [dict setValue:[NSString stringWithFormat:@"%@[%d,%d]", BC[buildNum[eSlctX][eSlctY]].name, eSlctX, eSlctY] forKey:@"value"];
                        [self willChangeValueForKey:@"EEGC2MA"];
                        [EEGC2MA addObject:dict];
                        [self didChangeValueForKey:@"EEGC2MA"];
                    }
                }
            }
        
        }
        
        NSLog(@"%@", MF[MFselectedRow+1].MS.EGClight.etValue1[etValueCnt]);
        
        EEGCslctFlag = false;
        
        [eventWindow makeKeyAndOrderFront:nil];
        [eventEndGameCondition makeKeyAndOrderFront:nil];
        
        
        
        
        
    }else if(doubleClickedFlag && eventPosFlag){
    
        [eventWindow makeKeyAndOrderFront:nil];
    
        [self willChangeValueForKey:@"eventPosMA"];
        [eventPosMA removeAllObjects];
        [self didChangeValueForKey:@"eventPosMA"];
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:[NSString stringWithFormat:@"[%d,%d]", eSlctX, eSlctY] forKey:@"name"];
        [self willChangeValueForKey:@"eventPosMA"];
        [eventPosMA addObject:dict];
        [self didChangeValueForKey:@"eventPosMA"];
        
        MAPSCRIPT MS = MF[MFselectedRow+1].MS;
        MAPSCRIPTD *MSDtop = MS.D;
        
        for(int i = 0;i < eventListRow;i++){
            MS.D = MS.D->next;
        }
        
        MS.D->x = eSlctX;
        MS.D->y = eSlctY;
        
        MS.D = MSDtop;
        
        MF[MFselectedRow+1].MS = MS;
    }
    
    doubleClickedFlag = false;
    
    
    if(EDproceedFlag){
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    MS.D = MSDTOPP;
    for(int i = 0;i < eventListRow;i++){
        MS.D = MS.D->next;
    }
    
    if([EDswitch1Btn state] != 0){
        MS.D->switch1f = true;
    }else{
        MS.D->switch1f = false;
    }
    
    if([EDswitch2Btn state] != 0){
        MS.D->switch2f = true;
    }else{
        MS.D->switch2f = false;
    }
    MS.D = MSDTOPP;
        
    }
    
    if(fuckingRetardedBtnPushed1){
        
        MAPSCRIPT MS = MF[MFselectedRow+1].MS;
        
        MS.D = msdtop;
        
        MAPSCRIPT0 *MSDPt = MS.D->P;
        
        MAPSCRIPT0 *MS0 = MS.D->P;
        
        for(int i = 0;i < squareCnt - 1 ;i++){
            MS0 = MS0->next;
        }
        
        //NSLog(@"%d", [EDTimerSet2A intValue]);
        
        if([EDTimerSet1A state] != 0)
            MS0->timerRun = true;
        else
            MS0->timerRun = false;
        if([EDTimerSet2A state] != 0)
            MS0->timerMode = true;
        else
            MS0->timerMode = false;
        if([EDTimerSet3A state] != 0)
            MS0->timerVisible = true;
        else
            MS0->timerVisible = false;
        
        MS.D->P = MS0;
        
        MS.D->P = MSDPt;
        
        
        
        
        
        
        
        
        fuckingRetardedBtnPushed1 = false;
    }
}

-(IBAction)eventCheckBtn:(id)sender{

    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    MAPSCRIPTD *MSDtop = MS.D;
    
    if(MS.D){
    for (int i = 0; i < ELrow;i++) {
        MS.D = MS.D->next;
    }
    
    MS.D->type = (int)[eventPopupBtn indexOfSelectedItem];
    
    if([eventCheckBtn intValue] == 0 && [eventPopupBtn indexOfSelectedItem] == 0)
        MS.D->type = -1;
    }
    MS.D = MSDtop;
    MF[MFselectedRow+1].MS = MS;
}
-(IBAction)eventPopupBtn:(id)sender{

}


-(void)ClickEDTI:(id)sender{

    EDtextImageRow = (int)[EDtextImageTV clickedRow];

}
-(void)ClickEL:(id)sender{

    eventListRow = (int)[eventListTV clickedRow];
    ELrow = (int)[eventListTV clickedRow];

    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    MAPSCRIPTD *MSDtop = MS.D;
    
    
    if(!MS.D) {
        MS.D = MSDtop;
        [eventCheckBtn setState:NO];
        return;
        
    }
    
    MS.D = MSDTOPP;
    for (int i = 0;i < eventListRow;i++) {
        if(!MS.D->next){
            MS.D->next = calloc(1, sizeof(MAPSCRIPTD));
        }
        MS.D = MS.D->next;
    }
    msdtop = MS.D;
    [self willChangeValueForKey:@"eventPosMA"];
    [eventPosMA removeAllObjects];
    [self didChangeValueForKey:@"eventPosMA"];
    if(!MS.D) {
        MS.D = MSDtop;
        [eventCheckBtn setState:NO];
        return;
    }
    
    if((MS.D->type == 0 && (MS.D->x > 0 && MS.D->y > 0))){
        [eventCheckBtn setState:YES];
    }else{
        [eventCheckBtn setState:NO];
    }
    
    if(MS.D->x > 0&& MS.D->y > 0){
        
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:[NSString stringWithFormat:@"[%d,%d]", MS.D->x, MS.D->y] forKey:@"name"];
    [self willChangeValueForKey:@"eventPosMA"];
    [eventPosMA addObject:dict];
    [self didChangeValueForKey:@"eventPosMA"];
    }
    
    MS.D = MSDTOPP;
    
}
-(void)doubleClickEL:(id)sender{
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    

    for (int i = 0;i < eventListRow;i++) {
        if(!MS.D->next){
            MS.D->next = calloc(1, sizeof(MAPSCRIPTD));
        }
        MS.D = MS.D->next;
    }
    msdtop = MS.D;
    
    if([eventListTV clickedRow] >= 0){

        if([eventListTV clickedRow] == [eventListMA count]-1){
            
            NSMutableDictionary* dict = [NSMutableDictionary new];
            [dict setValue:[NSString stringWithFormat:@"●"] forKey:@"value"];
            [self willChangeValueForKey:@"eventListMA"];
            [eventListMA addObject:dict];
            [self didChangeValueForKey:@"eventListMA"];
            [eventListAC setSelectionIndex:[eventListMA count]-2];
            
            MAPSCRIPTD *mdTop = MS.D;
            
            if(!MS.D){
                MS.D = calloc(1, sizeof(MAPSCRIPTD));
                mdTop = MS.D;
                msdtop = MS.D;
                MS.D->type = -1;
                if(!mapLoadFlagForMSD2 && mapLoadFlagForMSD){
                    MSDTOPP->next = MS.D;
                    mapLoadFlagForMSD2 = true;
                }
                if(!mapLoadFlagForMSD){
                    MSDTOPP = MS.D;
                    mapLoadFlagForMSD = true;
                }
            }
            else{
                while (MS.D->next)
                    MS.D = MS.D->next;
                
                MS.D->next = calloc(1, sizeof(MAPSCRIPTD));
                MS.D->next->type = -1;
                MS.D->next->next = NULL;
                //msdtop = MS.D->next;
            }
            MS.D = mdTop;
            
            if(!MS.SCRPTname) MS.SCRPTname = [NSMutableArray new];
            [MS.SCRPTname addObject:@"新規イベント"];
        }
        
        
        [EDnameTF setStringValue:[MS.SCRPTname objectAtIndex:[eventListTV clickedRow]]];
        
        MF[MFselectedRow+1].MS = MS;
        
        [self initEDlist];
        [eventDetailWindow makeKeyAndOrderFront:nil];
    }
    
    MF[MFselectedRow+1].MS = MS;
    
    EDproceedFlag = true;
}


-(void)ClickEDL:(id)sender{
    EDrow = [eventDetailListTV clickedRow];
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
}


-(void)doubleClickEDL:(id)sender{
    EDrow = [eventDetailListTV clickedRow];
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    
    if([eventDetailListTV clickedRow] >= 0){
        
        
        
        if([eventDetailListTV clickedRow] == [eventDetailListMA count]-1){
        
            NSMutableDictionary* dict = [NSMutableDictionary new];
            [dict setValue:[NSString stringWithFormat:@"◆"] forKey:@"value"];
            [self willChangeValueForKey:@"eventDetailListMA"];
            [eventDetailListMA addObject:dict];
            [self didChangeValueForKey:@"eventDetailListMA"];
            [eventDetailListAC setSelectionIndex:[eventDetailListMA count]-2];
        
            MSDTOP = MF[MFselectedRow+1].MS.D;
            
            MAPSCRIPT0 *MS0top = MS.D->P;
            
            if(!MS.D->P){
                MS.D->P = calloc(1, sizeof(MAPSCRIPT0));
                MS0top = MS.D->P;
            }else if(MS.D->P){
                while (MS.D->P->next) {
                    MS.D->P = MS.D->P->next;
                }
                MS.D->P->next = calloc(1, sizeof(MAPSCRIPT0));
            }
            
            MS.D->P = MS0top;
            
            squareCnt = 1;
            for(int i = 0;i < EDrow;i++){
                NSArray *array = nil;
                if([MS.D->SCRPT count] > 0){
                    array = [[MS.D->SCRPT objectAtIndex:i] componentsSeparatedByString:@"◆"];
                }
                if([array count] >= 2){
                    squareCnt++;
                }
            }
            
            [eventDetailSelectionWindow makeKeyAndOrderFront:nil];
        }else{
            editFlag = true;
            
            
                squareCnt = 0;
                for(int i = 0;i <= EDrow;i++){
                    NSArray *array = [[MS.D->SCRPT objectAtIndex:i] componentsSeparatedByString:@"◆"];
                    if([array count] >= 2){
                        squareCnt++;
                    }
                }
            
            for(int i = 0;i < 9;i++){
            
                for(int j = 0;j < i;j++){
                    
                }
            
            }
            
            if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆文章の表示"]){
                MSDTOP = MF[MFselectedRow+1].MS.D;
                
                for (int i = 0;i < eventListRow;i++) {
                    MF[MFselectedRow+1].MS.D = MF[MFselectedRow+1].MS.D->next;
                }
                
                MF[MFselectedRow+1].MS.D = MSDTOP;
                
                [self initEDtext];
                [EDtextWindow makeKeyAndOrderFront:nil];
            }
            
            
            
            if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆選択肢の表示"]){
                [self initEDselection];
                [EDselectionWindow makeKeyAndOrderFront:nil];
            }
        
        
            if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆スイッチの操作ON"]){
                suicchiDBLslickFlag = true;
                [EDSwitchWindow2 makeKeyAndOrderFront:nil];
            }
            if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆スイッチの操作OFF"]){
                
                suicchiDBLslickFlag = true;
                [EDSwitchWindow2 makeKeyAndOrderFront:nil];
            }if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆タイマーの操作"]){
                timerDBLslickFlag = true;
                [EDtimerWindow makeKeyAndOrderFront:nil];
            }
            
            
        }
        
        
    }
    
    MF[MFselectedRow+1].MS = MS;
    
    
    
   // NSLog(@"oops");
}


-(void)ClickSEL:(id)sender{
    EDselRow = [EDselectionTV clickedRow];
    
}

-(void)doubleClickPos:(id)sender{
    
    eventPosFlag = true;
    [MapEditorWindow makeKeyAndOrderFront:nil];
    
    [MapEditorWindow setFrame:NSMakeRect(scCenter.origin.x,scCenter.origin.y,480,480+headerFrame) display:YES];
    
}

-(void)doubleClickSW1:(id)sender{
    
    
    [EDswitchTF setStringValue:@""];
    SuicchiONOFFsentakuflag = true;
    [EDswitchWindow makeKeyAndOrderFront:nil];

}
-(void)doubleClickSW2:(id)sender{

        
    [EDswitchTF setStringValue:@""];
     SuicchiONOFFsentakuflag = false;
    [EDswitchWindow makeKeyAndOrderFront:nil];

}
-(void)doubleClickVAR:(id)sender{
    
    if([EDvariableTV clickedRow] >= 0){
        
        
    }
}


-(void)doubleClickLM:(id)sender{
    
    MFselectedRow = (int)[loadMapListTV selectedRow];
    if(MFselectedRow < 0) return;
    loadMapListSubmitFlag = true;
    [loadMapWindow close];
}
-(void)doubleClickSM:(id)sender{

}

-(IBAction)backTitle:(id)sender{
    windowPoint.x = [MapEditorWindow frame].origin.x;
    windowPoint.y = [MapEditorWindow frame].origin.y;
    [TitleWindow setFrameOrigin:windowPoint];
    [TitleWindow makeKeyAndOrderFront:nil];
    [MapEditorWindow close];
}
-(void)previous:(id)sender{
    if(SLSx == 0){
        if(MapChipListIndex <= 1) MapChipListIndex = MapChipMax;
        else MapChipListIndex--;
    }
    if(SLSx == 1){
        if(BuildChipListIndex <= 1) BuildChipListIndex = BuildChipMax;
        else BuildChipListIndex--;
    }
    if(SLSx == 2){
        if(UnitChipListIndex <= 1) UnitChipListIndex = UnitChipMax;
        else UnitChipListIndex--;
    }
    if(SLSx == 3){
        if(LoadChipListIndex <= 1) LoadChipListIndex = LoadChipMax;
        else LoadChipListIndex--;
    }
}
-(void)next:(id)sender{
    if(SLSx == 0){
    if(MapChipListIndex >= MapChipMax) MapChipListIndex = 1;
    else MapChipListIndex++;
    }
    if(SLSx == 1){
    if(BuildChipListIndex >= BuildChipMax) BuildChipListIndex = 1;
    else BuildChipListIndex++;
    }
    if(SLSx == 2){
    if(UnitChipListIndex >= UnitChipMax) UnitChipListIndex = 1;
    else UnitChipListIndex++;
    }
    if(SLSx == 3){
        if(LoadChipListIndex >= LoadChipMax) LoadChipListIndex = 1;
        else LoadChipListIndex++;
    }

}

-(IBAction)mapSizeSubmit:(id)sender{
    
    chipHeight = [mapSizeHeight intValue];
    chipWidth = [mapSizeWidth intValue];
    
    if(chipHeight < 15) chipHeight = 15;
    if(chipWidth < 15) chipWidth = 15;
    
    mapSizeChangedFlag = true;
    initMapChipNumbFlag = true;
    [mapSizeWindow close];
}
-(IBAction)mapSizeCancel:(id)sender{
    [mapSizeWindow close];
}

-(IBAction)mapSize:(id)sender{
    
    postWidth = chipWidth;
    postHeight = chipHeight;
    [mapSizeHeight setIntValue:chipHeight];
    [mapSizeWidth setIntValue:chipWidth];
    
    windowPoint.x = [MapEditorWindow frame].origin.x + 50;
    windowPoint.y = [MapEditorWindow frame].origin.y + 100;
    [mapSizeWindow setFrameOrigin:windowPoint];
    
    [mapSizeWindow makeKeyAndOrderFront:nil];
}

-(void)initLoadMapList{

    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSArray *Farray;
    NSString *filePath = @"Map";
    Farray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    
    fileNumb = (int)[Farray count];
    for (int i = 1; i < fileNumb;i++) {
        MF[i].fileName = [[Farray objectAtIndex:i] retain];
    }
    
    [self willChangeValueForKey:@"loadMapListMA"];
    [loadMapListMA removeAllObjects];
    [self didChangeValueForKey:@"loadMapListMA"];
    
    for(int i = 1; i < fileNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:[NSString stringWithFormat:@"%@", MF[i].fileName] forKey:@"name"];
        [self willChangeValueForKey:@"loadMapListMA"];
        [loadMapListMA addObject:dict];
        [self didChangeValueForKey:@"loadMapListMA"];
    }

}

-(void)initSaveMapList{

    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSArray *Farray;
    NSString *filePath = @"Map";
    Farray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    
    fileNumb = (int)[Farray count];
    for (int i = 1; i < fileNumb;i++) {
        MF[i].fileName = [[Farray objectAtIndex:i] retain];
    }
    
    
    [self willChangeValueForKey:@"saveMapListMA"];
    [saveMapListMA removeAllObjects];
    [self didChangeValueForKey:@"saveMapListMA"];
    
    for(int i = 1; i < fileNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:[NSString stringWithFormat:@"%@", MF[i].fileName] forKey:@"name"];
        [self willChangeValueForKey:@"saveMapListMA"];
        [saveMapListMA addObject:dict];
        [self didChangeValueForKey:@"saveMapListMA"];
    }


}

-(IBAction)loadMap:(id)sender{
    [self initLoadMapList];
    [loadMapWindow makeKeyAndOrderFront:nil];
    loadMapChipFlag = true;
}

-(IBAction)loadMapSubmit:(id)sender{
    
    MFselectedRow = (int)[loadMapListTV selectedRow];
    loadMapListSubmitFlag = true;
    [loadMapWindow close];
}
-(IBAction)loadMapCancel:(id)sender{
    [loadMapWindow close];
}

-(IBAction)saveMap:(id)sender{
    
    [self initSaveMapList];
    [saveMapListAC setSelectionIndex:-1];
    [saveMapWindow makeKeyAndOrderFront:nil];
}

-(IBAction)saveMapSubmit:(id)sender{
    
    saveMapDataName = [[saveMapTF stringValue] retain];
    saveMapListSubmitFlag = true;
    saveMapChipFlag = true;
    [saveMapWindow close];
}
-(IBAction)saveMapCancel:(id)sender{
    [saveMapWindow close];
}

-(IBAction)setEvent:(id)sender{
    
    [self EEGCset:MF[MFselectedRow+1].MS.EGClight flag:YES];
    [self EEGCset:MF[MFselectedRow+1].MS.EGCdark flag:NO];
    
    [self initEventList];
    
    [eventPlayerSetPUB1 selectItemAtIndex:playerSet1];
    [eventPlayerSetPUB2 selectItemAtIndex:playerSet2];
    [eventBattleDetailBtn setState:battleSetMode];
    
    [eventWindow makeKeyAndOrderFront:nil];
    
}

-(IBAction)EEGClight:(id)sender{
    
    [EEGCstr setStringValue:@"勝利条件"];
    [eventEndGameCondition makeKeyAndOrderFront:nil];
    [self initEEGC:MF[MFselectedRow+1].MS.EGClight];
    EEGCflag = 1;
    
}


-(IBAction)EEGCdark:(id)sender{
    
    [EEGCstr setStringValue:@"敗北条件"];
    [eventEndGameCondition makeKeyAndOrderFront:nil];
    [self initEEGC:MF[MFselectedRow+1].MS.EGCdark];
    EEGCflag = 2;
    
}

-(void)initEEGC:(ENDGAMECONDITION)EGCD{
    
    if(EGCD.endType1 > 0) [EPUB1 selectItemAtIndex:EGCD.endType1-1];
    if(EGCD.endType2 > 0) [EPUB2 selectItemAtIndex:EGCD.endType2];

    [self willChangeValueForKey:@"EEGC1MA"];
    [EEGC1MA removeAllObjects];
    [self didChangeValueForKey:@"EEGC1MA"];
    
    for (int i = 0; i < 64; i++) {
        if(!EGCD.etValue1[i]) break;
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", EGCD.etValue1[i]] forKey:@"value"];
        [self willChangeValueForKey:@"EEGC1MA"];
        [EEGC1MA addObject:dict];
        [self didChangeValueForKey:@"EEGC1MA"];
        
    }

    [self willChangeValueForKey:@"EEGC2MA"];
    [EEGC2MA removeAllObjects];
    [self didChangeValueForKey:@"EEGC2MA"];
    
    for (int i = 0; i < 64; i++) {
        if(!EGCD.etValue2[i]) break;
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", EGCD.etValue2[i]] forKey:@"value"];
        [self willChangeValueForKey:@"EEGC2MA"];
        [EEGC2MA addObject:dict];
        [self didChangeValueForKey:@"EEGC2MA"];
    }
}

-(void)initEventList{
    [self willChangeValueForKey:@"eventListMA"];
    [eventListMA removeAllObjects];
    [self didChangeValueForKey:@"eventListMA"];
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    MAPSCRIPTD *mdTop = MS.D;

    int indexCnt = 0;
    for(int i = 0;i < [MS.SCRPTname count];i++){
        
        if(!MS.SCRPTname) break;
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"●%@", [MS.SCRPTname objectAtIndex:i]] forKey:@"value"];
        [self willChangeValueForKey:@"eventListMA"];
        [eventListMA addObject:dict];
        [self didChangeValueForKey:@"eventListMA"];
        if(MS.D) {
            MS.D->index = indexCnt;
            MS.D = MS.D->next;
            indexCnt++;
        }
    }
    MS.D = mdTop;
    
    
    MF[MFselectedRow+1].MS = MS;
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"●"] forKey:@"value"];
    [self willChangeValueForKey:@"eventListMA"];
    [eventListMA addObject:dict];
    [self didChangeValueForKey:@"eventListMA"];
    
    if(MS.D){
        
        
        if((MS.D->type == 0 && (MS.D->x > 0 && MS.D->y > 0))){
            [eventCheckBtn setState:YES];
        }else{
            [eventCheckBtn setState:NO];
        }
        
        
        MAPSCRIPT MS = MF[MFselectedRow+1].MS;
        MAPSCRIPTD *MSDtop = MS.D;
        
        if(MS.D){
            for(int i = 0;i< eventListRow;i++){
                MS.D = MS.D->next;
            }
            if(MS.D->type >= 0 && MS.D->x > 0 && MS.D->y > 0) {
                
                
                eventListRow = (int)[eventListTV clickedRow];
                
                MAPSCRIPT MS = MF[MFselectedRow+1].MS;
                
                MAPSCRIPTD *MSDtop = MS.D;
                if(!MS.D) {
                    MS.D = MSDtop;
                    return;
                    
                }
                for (int i = 0;i < eventListRow;i++) {
                    MS.D = MS.D->next;
                }
                [self willChangeValueForKey:@"eventPosMA"];
                [eventPosMA removeAllObjects];
                [self didChangeValueForKey:@"eventPosMA"];
                if(!MS.D) {
                    MS.D = MSDtop;
                    return;
                    
                }
                if(MS.D->x > 0&& MS.D->y > 0){
                    
                    NSMutableDictionary* dict = [NSMutableDictionary new];
                    
                    [dict setValue:[NSString stringWithFormat:@"[%d,%d]", MS.D->x, MS.D->y] forKey:@"name"];
                    [self willChangeValueForKey:@"eventPosMA"];
                    [eventPosMA addObject:dict];
                    [self didChangeValueForKey:@"eventPosMA"];
                }
                
                MS.D = MSDtop;
                
            }
        }
        MS.D = MSDtop;
    }
    
    MSDTOP = MS.D;
    
    
    
}

-(IBAction)eventInsert:(id)sender{

    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    MSDTOPP = MF[MFselectedRow+1].MS.D;
    NSInteger sel = [eventListAC selectionIndex];
    
    if(sel < [eventListMA count]){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"●"] forKey:@"value"];
        [self willChangeValueForKey:@"eventListMA"];
        [eventListMA insertObject:dict atIndex:sel];
        [self didChangeValueForKey:@"eventListMA"];
        [eventListAC setSelectionIndex:sel];
        
        if(!MS.SCRPTname) MS.SCRPTname = [NSMutableArray new];
        [MS.SCRPTname insertObject:@"新規イベント" atIndex:sel];
        
        if(sel == 0){
        //insertのやり方
            MAPSCRIPTD *mdTop = calloc(1, sizeof(MAPSCRIPTD));
            mdTop->next = MS.D;
            mdTop->type = -1;
            MS.D = mdTop;
            MSDTOPP = mdTop;
        }else{
            MAPSCRIPTD *mdTop = MS.D;
            for(int i = 0;i < sel-1;i++){
                MS.D = MS.D->next;
            }
            MAPSCRIPTD *MSD = NULL;
            if(MS.D){
                MSD = MS.D->next;
                MS.D->next = calloc(1, sizeof(MAPSCRIPTD));
                MS.D->next->type = -1;
                MS.D->next->next = MSD;
                
                
            }else{
                MS.D = calloc(1, sizeof(MAPSCRIPTD));
                mdTop = MS.D;
                
                
                
        
        }
        MS.D = mdTop;
        }
        MF[MFselectedRow+1].MS = MS;
        
        
        MSDTOP = MF[MFselectedRow+1].MS.D;
        for (int i = 0;i < eventListRow;i++) {
            MF[MFselectedRow+1].MS.D = MF[MFselectedRow+1].MS.D->next;
        }
        
        [EDnameTF setStringValue:[MS.SCRPTname objectAtIndex:sel]];
        MSDTOP = MF[MFselectedRow+1].MS.D;
        
        for (int i = 0;i < eventListRow;i++) {
            MF[MFselectedRow+1].MS.D = MF[MFselectedRow+1].MS.D->next;
        }
        msdtop = MF[MFselectedRow+1].MS.D;
        
        MF[MFselectedRow+1].MS.D = MSDTOP;
        [self initEDlist];
        [eventDetailWindow makeKeyAndOrderFront:nil];
        EDproceedFlag = true;
    }
    
}

-(IBAction)eventDelete:(id)sender{

    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    NSInteger sel = [eventListAC selectionIndex];
    
    if(sel < [eventListMA count]-1){
        [self willChangeValueForKey:@"eventListMA"];
        [eventListMA removeObjectAtIndex:sel];
        [self didChangeValueForKey:@"eventListMA"];
        [eventListAC setSelectionIndex:sel];
    
        [MS.SCRPTname removeObjectAtIndex:sel];
        
        //deleteのやり方
        
        MAPSCRIPTD *mdTop = MS.D;
        for(int i = 0;i < sel - 1;i++){
            MS.D = MS.D->next;
        }
        MAPSCRIPTD *MSD = NULL;
        if(sel == 0 && MS.D){
            mdTop = MS.D->next;
        }else if(MS.D){
            if(MS.D->next) MSD = MS.D->next->next;
            MS.D->next = MSD;
        }
        MS.D = mdTop;
        
        MF[MFselectedRow+1].MS = MS;
        
    }
    
}

-(IBAction)eventSubmit:(id)sender{
    [MapEditorWindow setFrame:NSMakeRect(scCenter.origin.x,scCenter.origin.y,640,480+headerFrame) display:YES];
    EEGCslctFlag = false;
    eventPosFlag = false;
    [eventWindow close];
}

-(void)EEGCset:(ENDGAMECONDITION)EGCD flag:(bool)flag{
    
    int eValue = EGCD.endType1;
    int eValue2 = EGCD.endType2;
    
    if(flag){
        if(eValue > 0){
            [EEGC01str setStringValue:[NSString stringWithFormat:@"%@", [EPUB1 itemTitleAtIndex:eValue - 1]]];
        }else{
            [EEGC01str setStringValue:[NSString stringWithFormat:@"未決定"]];
        }
        if(eValue2 > 0){
            [EEGC012str setStringValue:[NSString stringWithFormat:@"%@", [EPUB2 itemTitleAtIndex:eValue2]]];
        }else{
            [EEGC012str setStringValue:[NSString stringWithFormat:@""]];
        }
    }

    if(!flag){
        if(eValue > 0){
            [EEGC02str setStringValue:[NSString stringWithFormat:@"%@", [EPUB1 itemTitleAtIndex:eValue - 1]]];
        }else{
            [EEGC02str setStringValue:[NSString stringWithFormat:@"未決定"]];
        }
        if(eValue2 > 0){
            [EEGC022str setStringValue:[NSString stringWithFormat:@"%@", [EPUB2 itemTitleAtIndex:eValue2]]];
        }else{
            [EEGC022str setStringValue:[NSString stringWithFormat:@""]];
        }
    }

}

-(ENDGAMECONDITION)EEGCselection:(ENDGAMECONDITION)EGCD{
    
    if([EPUB1 indexOfSelectedItem] == 0){//敵全滅
        EGCD.endType1 = 1;
    }else if([EPUB1 indexOfSelectedItem] == 1){//味方全滅
        EGCD.endType1 = 2;
            
    }else if([EPUB1 indexOfSelectedItem] == 2){//すべての指定全滅
        EGCD.endType1 = 3;
            
    }else if([EPUB1 indexOfSelectedItem] == 3){//いずれかの指定全滅
        EGCD.endType1 = 4;
            
    }else if([EPUB1 indexOfSelectedItem] == 4){//指定の場所
        EGCD.endType1 = 5;
            
    }else if([EPUB1 indexOfSelectedItem] == 5){//指定の拠点
        EGCD.endType1 = 6;
            
    }else if([EPUB1 indexOfSelectedItem] == 6){//指定の研究
        EGCD.endType1 = 7;
            
    }else if([EPUB1 indexOfSelectedItem] == 7){//指定のスイッチ
        EGCD.endType1 = 8;
            
    }

    if([EPUB2 indexOfSelectedItem] == 0){
        EGCD.endType2 = 0;
    }else if([EPUB2 indexOfSelectedItem] == 1){//敵全滅
        EGCD.endType2 = 1;
    }else if([EPUB2 indexOfSelectedItem] == 2){//味方全滅
        EGCD.endType2 = 2;
        
    }else if([EPUB2 indexOfSelectedItem] == 3){//すべての指定全滅
        EGCD.endType2 = 3;
            
    }else if([EPUB2 indexOfSelectedItem] == 4){//いずれかの指定全滅
        EGCD.endType2 = 4;
            
    }else if([EPUB2 indexOfSelectedItem] == 5){//指定の場所
        EGCD.endType2 = 5;
            
    }else if([EPUB2 indexOfSelectedItem] == 6){//指定の拠点
        EGCD.endType2 = 6;
            
    }else if([EPUB2 indexOfSelectedItem] == 7){//指定の研究
        EGCD.endType2 = 7;
            
    }else if([EPUB2 indexOfSelectedItem] == 8){//指定のスイッチ
        EGCD.endType2 = 8;
            
    }
    
    

    return EGCD;

}

-(IBAction)EEGC1insert:(id)sender{

    EEGCslctCnt = (int)[EPUB1 indexOfSelectedItem];
    
    if(EEGCslctCnt == 2 || EEGCslctCnt == 3
       || EEGCslctCnt == 4 || EEGCslctCnt == 5){
    
        if([EEGC1MA count] >= 64) return;
        
        EEGCslctFlag = true;
        
        [eventWindow close];
        [eventEndGameCondition close];
        
    }else if(EEGCslctCnt == 6){
    
    }else if(EEGCslctCnt == 7){
        
    }
    
}
-(IBAction)EEGC1delete:(id)sender{
    
    [self willChangeValueForKey:@"EEGC1MA"];
    [EEGC1MA removeObjectAtIndex:EEGC1row];
    [self didChangeValueForKey:@"EEGC1MA"];
}

-(void)clickEEGC1:(id)sender{
    EEGC1row = (int)[EEGC1TV selectedRow];
}

-(void)clickEEGC2:(id)sender{
    EEGC2row = (int)[EEGC2TV selectedRow];
}

-(IBAction)EEGC2insert:(id)sender{

    EEGCslctCnt = (int)[EPUB2 indexOfSelectedItem];
    
    if(EEGCslctCnt == 3 || EEGCslctCnt == 4
       || EEGCslctCnt == 5 || EEGCslctCnt == 6){
        
        if([EEGC2MA count] >= 64) return;
        
        EEGCslctFlag = true;
        EEGCslctFlag2 = true;
        
        [eventWindow close];
        [eventEndGameCondition close];
        
    }else if(EEGCslctCnt == 7){
        
    }else if(EEGCslctCnt == 8){
        
    }
    
}
-(IBAction)EEGC2delete:(id)sender{

    [self willChangeValueForKey:@"EEGC2MA"];
    [EEGC2MA removeObjectAtIndex:EEGC2row];
    [self didChangeValueForKey:@"EEGC2MA"];
}

-(IBAction)EEGCsubmit:(id)sender{
    if(EEGCflag == 1){
        MF[MFselectedRow+1].MS.EGClight = [self EEGCselection:MF[MFselectedRow+1].MS.EGClight];
        
        for(int i =0;i<64;i++){
            MF[MFselectedRow+1].MS.EGClight.etValue1[i] = nil;
        }
        
        for(int i = 0;i < [EEGC1MA count];i++){
            MF[MFselectedRow+1].MS.EGClight.etValue1[i] = [[[EEGC1MA objectAtIndex:i] valueForKey:@"value"] retain];
        }
        
        for(int i =0;i<64;i++){
            MF[MFselectedRow+1].MS.EGClight.etValue2[i] = nil;
        }
        
        for(int i = 0;i < [EEGC2MA count];i++){
            MF[MFselectedRow+1].MS.EGClight.etValue2[i] = [[[EEGC2MA objectAtIndex:i] valueForKey:@"value"] retain];
        }
        
        //NSLog(@"%@", [EEGC1MA objectAtIndex:0]);
    }
    if(EEGCflag == 2){
        MF[MFselectedRow+1].MS.EGCdark = [self EEGCselection:MF[MFselectedRow+1].MS.EGCdark];
        
        for(int i =0;i<64;i++){
            MF[MFselectedRow+1].MS.EGCdark.etValue1[i] = nil;
        }
        
        for(int i = 0;i < [EEGC1MA count];i++){
            MF[MFselectedRow+1].MS.EGCdark.etValue1[i] = [[[EEGC1MA objectAtIndex:i] valueForKey:@"value"] retain];
        }
        
        for(int i =0;i<64;i++){
            MF[MFselectedRow+1].MS.EGCdark.etValue2[i] = nil;
        }
        
        for(int i = 0;i < [EEGC2MA count];i++){
            MF[MFselectedRow+1].MS.EGCdark.etValue2[i] = [[[EEGC2MA objectAtIndex:i] valueForKey:@"value"] retain];
        }

    }
    
    [self EEGCset:MF[MFselectedRow+1].MS.EGClight flag:YES];
    [self EEGCset:MF[MFselectedRow+1].MS.EGCdark flag:NO];
    
    [eventEndGameCondition close];

}

-(IBAction)EEGCcancel:(id)sender{

    [eventEndGameCondition close];

}

-(IBAction)EEGC1select:(id)sender{
    [self willChangeValueForKey:@"EEGC1MA"];
    [EEGC1MA removeAllObjects];
    [self didChangeValueForKey:@"EEGC1MA"];
    
    for(int i = 0;i < 64;i++){
        if(EEGCflag == 1)
            MF[MFselectedRow+1].MS.EGClight.etValue1[i] = nil;
        if(EEGCflag == 2)
            MF[MFselectedRow+1].MS.EGCdark.etValue1[i] = nil;
    }
}
-(IBAction)EEGC2select:(id)sender{
    [self willChangeValueForKey:@"EEGC2MA"];
    [EEGC2MA removeAllObjects];
    [self didChangeValueForKey:@"EEGC2MA"];

    for(int i = 0;i < 64;i++){
        if(EEGCflag == 1)
            MF[MFselectedRow+1].MS.EGClight.etValue2[i] = nil;
        if(EEGCflag == 2)
            MF[MFselectedRow+1].MS.EGCdark.etValue2[i] = nil;
    }
}

-(IBAction)EDclose:(id)sender{
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;

    [MS.SCRPTname replaceObjectAtIndex:[eventListAC selectionIndex] withObject:[EDnameTF stringValue]];
    
    
    [eventListAC setValue:[NSString stringWithFormat:@"●%@", [MS.SCRPTname objectAtIndex:[eventListAC selectionIndex]]] forKeyPath:@"selection.value"];
    
    MF[MFselectedRow+1].MS.D = MSDTOPP;
    
    EDproceedFlag = false;
    [eventDetailWindow close];
}

-(void)initEDlist{
    [self willChangeValueForKey:@"eventDetailListMA"];
    [eventDetailListMA removeAllObjects];
    [self didChangeValueForKey:@"eventDetailListMA"];
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    MAPSCRIPTD *mdTop = MS.D;
    
    
    if(MS.D)
    for(int i = 0;i < [MS.D->SCRPT count];i++){
        
        if(!MS.D->SCRPT)
            break;
        
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", [MS.D->SCRPT objectAtIndex:i]] forKey:@"value"];
        [self willChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListMA addObject:dict];
        [self didChangeValueForKey:@"eventDetailListMA"];
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"◆"] forKey:@"value"];
    [self willChangeValueForKey:@"eventDetailListMA"];
    [eventDetailListMA addObject:dict];
    [self didChangeValueForKey:@"eventDetailListMA"];
    
    if(MS.D)
    if(!MS.D->SCRPT){
        MS.D->SCRPT = [NSMutableArray new];
    }
    
        [self willChangeValueForKey:@"EDswitch1MA"];
        [EDswitch1MA removeAllObjects];
        [self didChangeValueForKey:@"EDswitch1MA"];
        [self willChangeValueForKey:@"EDswitch2MA"];
        [EDswitch2MA removeAllObjects];
        [self didChangeValueForKey:@"EDswitch2MA"];
    
    if(MS.D->switch1)
    for(int i = 0; *(MS.D->switch1+i) > 0;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
            [dict setValue:[NSString stringWithFormat:@"%d", *(MS.D->switch1 + i)] forKey:@"value"];
            
            [self willChangeValueForKey:@"EDswitch1MA"];
            [EDswitch1MA addObject:dict];
            [self didChangeValueForKey:@"EDswitch1MA"];
        
    
    }
    
    if(MS.D->switch2)
    for(int i = 0; *(MS.D->switch2+i) > 0;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:[NSString stringWithFormat:@"%d", *(MS.D->switch2 + i)] forKey:@"value"];
        
        [self willChangeValueForKey:@"EDswitch2MA"];
        [EDswitch2MA addObject:dict];
        [self didChangeValueForKey:@"EDswitch2MA"];
        
        
    }
    MS.D->type = -1;
    
    
    if(MS.D->switch1f)
        [EDswitch1Btn setState:YES];
    else
        [EDswitch1Btn setState:NO];

    if(MS.D->switch2f)
        [EDswitch2Btn setState:YES];
    else
        [EDswitch2Btn setState:NO];
    MS.D = mdTop;
    MF[MFselectedRow+1].MS = MS;
        
             
}


-(IBAction)EDinsert:(id)sender{
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    MAPSCRIPTD *mdTop = MS.D;
    
    for(int i = 0;i < [eventListTV clickedRow];i++){
        MS.D = MS.D->next;
    }
    
    if(EDrow >= 0 && [MS.D->SCRPT count] > 0){
        
        
        if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆文章の表示"]){
            NSMutableDictionary* dict = [NSMutableDictionary new];
            [dict setValue:[NSString stringWithFormat:@"◆"] forKey:@"value"];
            [self willChangeValueForKey:@"eventDetailListMA"];
            [eventDetailListMA insertObject:dict atIndex:EDrow];
            [self didChangeValueForKey:@"eventDetailListMA"];
            [eventDetailListAC setSelectionIndex:EDrow];
            
            squareCnt = 1;
            for(int i = 0;i < EDrow;i++){
                NSArray *array = nil;
                if([MS.D->SCRPT count] > 0){
                    array = [[MS.D->SCRPT objectAtIndex:i] componentsSeparatedByString:@"◆"];
                }
                if([array count] >= 2){
                    squareCnt++;
                }
            }
            
            MAPSCRIPT0 *MS0top = MS.D->P;
            
            if(!MS.D->P){
                MS.D->P = calloc(1, sizeof(MAPSCRIPT0));
                MS0top = MS.D->P;
            }else if(MS.D->P){
                
                if(squareCnt == 1){
                    MAPSCRIPT0 *temp = MS.D->P;
                    MS.D->P = calloc(1, sizeof(MAPSCRIPT0));
                    MS.D->P->next = temp;
                    MS0top = MS.D->P;
                }else if(squareCnt > 1){
                    for (int i = 0; i < squareCnt-2; i++) {
                        MS.D->P = MS.D->P->next;
                    }
                    MAPSCRIPT0 *temp = MS.D->P->next;
                    MS.D->P->next = calloc(1, sizeof(MAPSCRIPT0));
                    MS.D->P->next->next = temp;
                }
            }
            
            MS.D->P = MS0top;
            
        }else if(1){
        
        }
        insertFlag = true;
        [eventDetailSelectionWindow makeKeyAndOrderFront:nil];
        }
    
    MS.D = mdTop;
    
    MF[MFselectedRow+1].MS = MS;

}

-(IBAction)EDdelete:(id)sender{
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    MAPSCRIPTD *mdTop = MS.D;
    
    for(int i = 0;i < [eventListTV clickedRow];i++){
        MS.D = MS.D->next;
    }
    
    if(EDrow >= 0 && [MS.D->SCRPT count] > 0){
        
        MAPSCRIPTD *MSD = MF[MFselectedRow+1].MS.D;
        if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆文章の表示"]){
            [self EDdeleteFunc:MS msd:MSD];
        }else if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆選択肢の表示"]){
            [self EDdeleteFunc:MS msd:MSD];
        }else if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆スイッチの操作ON"]){
            [self EDdeleteFunc:MS msd:MSD];
        }else if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆スイッチの操作OFF"]){
            [self EDdeleteFunc:MS msd:MSD];
        }else if([[MS.D->SCRPT objectAtIndex:EDrow] isEqualToString:@"◆タイマーの操作"]){
            [self EDdeleteFunc:MS msd:MSD];


        }
    }
    
    MS.D = mdTop;
    MF[MFselectedRow+1].MS = MS;

}


-(IBAction)EDcancel:(id)sender{
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    if(editFlag){
    
    
    
    }
    if(insertFlag){
    
        
        [self willChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListMA removeObjectAtIndex:EDrow];
        [self didChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListAC setSelectionIndex:EDrow];
        
        MAPSCRIPT0 *MS0top = MS.D->P;
        
        if(squareCnt == 1){
            MAPSCRIPT0 *temp = MS.D->P->next;
            MS.D->P = temp;
            MS0top = MS.D->P;
        }else if(squareCnt > 1){
            for (int i = 0; i < squareCnt-2; i++) {
                MS.D->P = MS.D->P->next;
            }
            MAPSCRIPT0 *temp = MS.D->P->next->next;
            MS.D->P->next = temp;
        }
    
    
        MS.D->P = MS0top;
    }else{
        [self willChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListMA removeObjectAtIndex:EDrow];
        [self didChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListAC setSelectionIndex:EDrow];
    
        MAPSCRIPT0 *MS0top = MS.D->P;
        
        if(squareCnt == 1){
            MAPSCRIPT0 *temp;
            if(MS.D->P)
            {temp = MS.D->P->next;
                MS.D->P = temp;}
            MS0top = MS.D->P;
        }else if(squareCnt > 1){
            for (int i = 0; i < squareCnt-2; i++) {
                MS.D->P = MS.D->P->next;
            }
            MAPSCRIPT0 *temp = MS.D->P->next->next;
            MS.D->P->next = temp;
        }
    
    
        MS.D->P = MS0top;
    }
    
    
    MF[MFselectedRow+1].MS = MS;
    
    editFlag = false;
    insertFlag = false;
    [eventDetailSelectionWindow close];
}

-(void)initEDtext{
    
    MAPSCRIPTD *MSD = msdtop;
    MAPSCRIPT0 *MS0 = msdtop->P;
    MAPSCRIPT0 *m0Top = MS0;
    
    for (int i = 0;i < squareCnt-1;i++) {
        MS0 = MS0->next;
    }
    
    if(MS0){
        if(MS0->S1.name)
            [EDtextName setStringValue:MS0->S1.name];
        else
            [EDtextName setStringValue:@""];
        if(MS0->S1.str)
        [EDtextString setStringValue:MS0->S1.str];
        else
            [EDtextString setStringValue:@""];
        if(MS0->S1.img)
            [EDtextImage setImage:MS0->S1.img];
        else
            [EDtextImage setImage:nil];
    }/*else{
            [EDtextName setStringValue:@""];
            [EDtextString setStringValue:@""];
            [EDtextImage setImage:nil];
    }*/
    
    MS0 = m0Top;
    
    MF[MFselectedRow+1].MS.D = MSDTOP;
    MF[MFselectedRow+1].MS.D->P = MS0;
}


-(IBAction)EDtext:(id)sender{
    
    [self initEDtext];
    
    [EDtextWindow makeKeyAndOrderFront:nil];
}

-(IBAction)EDtextSubmit:(id)sender{
    
    MAPSCRIPT0 *MS0 = msdtop->P;
    MAPSCRIPT0 *m0Top = MS0;
    
    for (int i = 0;i < squareCnt-1;i++) {
        MS0 = MS0->next;
    }
    
    MS0->type = 0;
    MS0->S1.name = [[EDtextName stringValue] retain];
    MS0->S1.str = [[EDtextString stringValue] retain];
    MS0->S1.img = [[EDtextImage image] retain];
    
    MAPSCRIPTD *MSD = msdtop;
    int cnt = 0;
    if(editFlag){
        int instantCnt = 0;
        int instantCnt2 = 0;
        for (int i = 0;i < [MSD->SCRPT count];i++) {
            NSArray *array = [[MSD->SCRPT objectAtIndex:i] componentsSeparatedByString:@"◆"];
            if([array count] >= 2){
                instantCnt++;
            }
            
            if(instantCnt == squareCnt){
                instantCnt2++;
                cnt--;
            }
            if(instantCnt == squareCnt + 1){
                break;
            }
            cnt++;
        }
        
        for(int i = 0;i < instantCnt2;i++){
            
            [MSD->SCRPT removeObjectAtIndex:cnt];
        
        }
     
        [MSD->SCRPT insertObject:@"◆文章の表示"atIndex:cnt];
        if(![MS0->S1.name isEqualToString:@""]) [MSD->SCRPT insertObject:[NSString stringWithFormat:@"%@：", MS0->S1.name] atIndex:cnt+1];
        NSArray *array = [MS0->S1.str componentsSeparatedByString:@"\n"];
        int cnt2 = 1;
        if([MS0->S1.name isEqualToString:@""]) cnt2 = 0;
        for (NSString *str in array) {cnt2++;
            [MSD->SCRPT insertObject:str atIndex:cnt+cnt2];
        }
    }else if(insertFlag){
        int instantCnt = 0;
        int instantCnt2 = 0;
        for (int i = 0;i < [MSD->SCRPT count];i++) {
            NSArray *array = [[MSD->SCRPT objectAtIndex:i] componentsSeparatedByString:@"◆"];
            if([array count] >= 2){
                instantCnt++;
            }
            
            if(instantCnt == squareCnt){
                instantCnt2++;
                cnt--;
            }
            if(instantCnt == squareCnt + 1){
                break;
            }
            cnt++;
        }

        
        [MSD->SCRPT insertObject:@"◆文章の表示"atIndex:cnt];
        if(![MS0->S1.name isEqualToString:@""]) [MSD->SCRPT insertObject:[NSString stringWithFormat:@"%@：", MS0->S1.name] atIndex:cnt+1];
        NSArray *array = [MS0->S1.str componentsSeparatedByString:@"\n"];
        int cnt2 = 1;
        if([MS0->S1.name isEqualToString:@""]) cnt2 = 0;
        for (NSString *str in array) {cnt2++;
            [MSD->SCRPT insertObject:str atIndex:cnt+cnt2];
        }
    }else{
        [MSD->SCRPT addObject:@"◆文章の表示"];
        if(![MS0->S1.name isEqualToString:@""]) [MSD->SCRPT addObject:[NSString stringWithFormat:@"%@：", MS0->S1.name]];
        NSArray *array = [MS0->S1.str componentsSeparatedByString:@"\n"];
        int cnt2 = 1;
        if([MS0->S1.name isEqualToString:@""]) cnt2 = 0;
        for (NSString *str in array) {cnt2++;
            [MSD->SCRPT addObject:str];
        }
    }
    
    MS0 = m0Top;
    msdtop->P = MS0;
    
    msdtop = MSD;
    
    MF[MFselectedRow+1].MS.D = MSDTOP;
    *MF[MFselectedRow+1].MS.D = *msdtop;
    *MF[MFselectedRow+1].MS.D->P = *(msdtop->P);
    MF[MFselectedRow+1].MS.D = MSDTOP;
    editFlag = false;
    insertFlag = false;
    [EDtextWindow close];
    [self initEDlist];
    [eventDetailListAC setSelectionIndex:EDrow];
    [eventDetailSelectionWindow close];
    
}
-(IBAction)EDtextCancel:(id)sender{
    
    editFlag = false;
    insertFlag = false;
    [EDtextWindow close];
}
-(IBAction)EDtextImageSlct:(id)sender{
    
    [EDtextImageButton1 setHighlighted:YES];
    [EDtextImageButton1 setState:YES];
    [EDtextImageButton2 setState:NO];
    [EDtextImageButton3 setState:NO];
    [self setEDtextImage];
    [EDtextImageWindow makeKeyAndOrderFront:nil];
}

-(void)setEDtextImage{
    [self willChangeValueForKey:@"EDtextImageMA"];
    [EDtextImageMA removeAllObjects];
    [self didChangeValueForKey:@"EDtextImageMA"];
    
    
    if([EDtextImageButton1 isHighlighted]){
        EDtextImageButtonValue = 0;
        for(int i = 0;i < UCN;i++){
            NSMutableDictionary* dict = [NSMutableDictionary new];
            
            [dict setValue:[NSString stringWithFormat:@"%@", UC[i].nameClass] forKey:@"name"];
            [dict setValue:UC[i].imgb forKey:@"img"];
            
            [self willChangeValueForKey:@"EDtextImageMA"];
            [EDtextImageMA addObject:dict];
            [self didChangeValueForKey:@"EDtextImageMA"];
            
        }
        
    }else if([EDtextImageButton2 isHighlighted]){
        EDtextImageButtonValue = 1;
        
        for(int i = 0;i < LCN;i++){
            NSMutableDictionary* dict = [NSMutableDictionary new];
            
            [dict setValue:[NSString stringWithFormat:@"%@", LC[i].name] forKey:@"name"];
            [dict setValue:LC[i].imgb forKey:@"img"];
            
            
            [self willChangeValueForKey:@"EDtextImageMA"];
            [EDtextImageMA addObject:dict];
            [self didChangeValueForKey:@"EDtextImageMA"];
        }
    
    }else if([EDtextImageButton3 isHighlighted]){
        EDtextImageButtonValue = 2;
        EIMG = EIMGtop;
        while(EIMG){
            NSMutableDictionary* dict = [NSMutableDictionary new];
            
            [dict setValue:[NSString stringWithFormat:@"%@", EIMG->name] forKey:@"name"];
            [dict setValue:EIMG->img forKey:@"img"];
            
            [self willChangeValueForKey:@"EDtextImageMA"];
            [EDtextImageMA addObject:dict];
            [self didChangeValueForKey:@"EDtextImageMA"];
            EIMG = EIMG->next;
        }EIMG = EIMGtop;
    }
    [EDtextImageButton1 setHighlighted:NO];
}


-(void)loadEventImage{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSString *eventImgDirectory = @"data/StringList/img";
    
    NSArray *imgList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:eventImgDirectory error:nil];

    for(NSString *path in imgList){
        
        if([path isEqualToString:@".DS_Store"]){
            continue;
        }
        
        static int eTopFlag = 0;
        
        if(eTopFlag == 0){
            EIMG = calloc(1, sizeof(EVENTIMAGE));
            eTopFlag = 1;
        }else{
            if(eTopFlag == 1){
                eTopFlag = 2;
                EIMGtop = EIMG;
            }
            EIMG->next = calloc(1, sizeof(EVENTIMAGE));
            EIMG = EIMG->next;
        }
        
        NSString *imgPath = [NSString stringWithFormat:@"%@/%@", eventImgDirectory,path];
        EIMG->img = [[[NSImage alloc] initWithContentsOfFile:imgPath] retain];
        EIMG->name = [path retain];
    }
    EIMG = EIMGtop;

}




-(IBAction)EDtextImageButton:(id)sender{
    [self setEDtextImage];
}

-(IBAction)EDtextImageSubmit:(id)sender{
    
    [self setEDtextImageView];
    
    [EDtextImageWindow close];
}

-(void)setEDtextImageView{
    MAPSCRIPT0 *MS0 = MF[MFselectedRow+1].MS.D->P;
    MAPSCRIPT0 *m0Top = MS0;
    for (int i = 0;i < squareCnt-1;i++) {
        MS0 = MS0->next;
    }
    
    if(EDtextImageButtonValue == 0){
        MS0->S1.nameID = [UC[EDtextImageRow].nameID retain];
        MS0->S1.iName = [UC[EDtextImageRow].nameClass retain];
        [EDtextImage setImage:UC[EDtextImageRow].imgb];
    }
    if(EDtextImageButtonValue == 1){
        MS0->S1.nameID = [LC[EDtextImageRow].nameID retain];
        MS0->S1.iName = [LC[EDtextImageRow].name retain];
        [EDtextImage setImage:LC[EDtextImageRow].imgb];
    }
    if(EDtextImageButtonValue == 2){
        EIMG = EIMGtop;
        for (int i = 0; i < EDtextImageRow;i++) {
            EIMG = EIMG->next;
        }
        MS0->S1.nameID = [EIMG->name retain];
        MS0->S1.iName = [[NSString stringWithFormat:@"%@", EIMG->name] retain];
        [EDtextImage setImage:EIMG->img];
        EIMG = EIMGtop;
    }
    
    MS0 = m0Top;
}

-(IBAction)EDtextImageCancel:(id)sender{
    [EDtextImageWindow close];
}


-(void)initEDselection{
    
    [self willChangeValueForKey:@"EDselectionMA"];
    [EDselectionMA removeAllObjects];
    [self didChangeValueForKey:@"EDselectionMA"];
    
    MAPSCRIPT0 *MS0 = MF[MFselectedRow+1].MS.D->P;
    MAPSCRIPT0 *m0Top = MS0;
    
    for (int i = 0;i < squareCnt-1;i++) {
        MS0 = MS0->next;
    }
    
    if(MS0){
        for (int i = 0; i < [MS0->S2.sel count]; i++) {
            NSMutableDictionary* dict = [NSMutableDictionary new];
            
            [dict setValue:[NSString stringWithFormat:@"%@", [[MS0->S2.sel objectAtIndex:i] objectForKey:@"name"]] forKey:@"name"];
            
            [self willChangeValueForKey:@"EDselectionMA"];
            [EDselectionMA addObject:dict];
            [self didChangeValueForKey:@"EDselectionMA"];
        }

    }
    
    MS0 = m0Top;
    
    MF[MFselectedRow+1].MS.D->P = MS0;
}

-(IBAction)EDselection:(id)sender{
    [self initEDselection];
    
    [EDselectionWindow makeKeyAndOrderFront:nil];
}

-(IBAction)EDselectionAdd:(id)sender{

    MAPSCRIPT0 *MS0 = MF[MFselectedRow+1].MS.D->P;
    MAPSCRIPT0 *m0Top = MS0;
    
    for(int i = 0;i < squareCnt-1;i++){
        MS0 = MS0->next;
    }
    
    if(MS0){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:[NSString stringWithFormat:@"%@", @"新規選択肢"] forKey:@"name"];
        
        [self willChangeValueForKey:@"EDselectionMA"];
        [EDselectionMA addObject:dict];
        [self didChangeValueForKey:@"EDselectionMA"];
        [EDselectionAC setSelectionIndex:[EDselectionMA count]-1];
        EDselRow = [EDselectionMA count]-1;
    }
    
    MS0 = m0Top;
    
    MF[MFselectedRow+1].MS.D->P = MS0;

}
-(IBAction)EDselectionDelete:(id)sender{

    if(EDselRow < 0) return;
    
    MAPSCRIPT0 *MS0 = MF[MFselectedRow+1].MS.D->P;
    MAPSCRIPT0 *m0Top = MS0;
    
    
    for(int i = 0;i < squareCnt-1;i++){
        MS0 = MS0->next;
    }
    
    if(MS0){
        
        [self willChangeValueForKey:@"EDselectionMA"];
        [EDselectionMA removeObjectAtIndex:EDselRow];
        [self didChangeValueForKey:@"EDselectionMA"];
        if(EDselRow > 0) {
            [EDselectionAC setSelectionIndex:EDselRow-1];
            EDselRow -= 1;
        }
        else {
            [EDselectionAC setSelectionIndex:0];
            EDselRow = 0;
        }
    }
    
    MS0 = m0Top;
    
    MF[MFselectedRow+1].MS.D->P = MS0;


}
-(IBAction)EDselectionSubmit:(id)sender{
    MAPSCRIPT0 *MS0 = MF[MFselectedRow+1].MS.D->P;
    MAPSCRIPT0 *m0Top = MS0;
    MAPSCRIPT2A *m2ATop;
    
    if([EDselectionMA count] <= 0)
        return;
    
    for(int i = 0;i < squareCnt-1;i++){
        MS0 = MS0->next;
    }
    
    MAPSCRIPTD *MSD = MF[MFselectedRow+1].MS.D;
    int cnt = 0;
    if(editFlag){
        int instantCnt = 0;
        int instantCnt2 = 0;
        MS0->S2.sel = [NSMutableArray new];
        [MS0->S2.sel setArray:EDselectionMA];
        [self EDsquareCount:&cnt cnt1:&instantCnt cnt2:&instantCnt2];
        
        for(int i = 0;i < instantCnt2;i++){
            
            [MSD->SCRPT removeObjectAtIndex:cnt];
            
        }
        
        [MSD->SCRPT insertObject:@"◆選択肢の表示"atIndex:cnt];
        for(int i = 0 ;i < [MS0->S2.sel count];i++){
            NSString *str = @"";
            for(int j = 1;j < MS0->indent;j++){
                str = [str stringByAppendingString:@"　"];
            }
            [MSD->SCRPT insertObject:[NSString stringWithFormat:@"%@：%@の場合", str, [[MS0->S2.sel objectAtIndex:i] objectForKey:@"name"]] atIndex:cnt+i*2+1];
            NSString *str2 = @"";
            for(int j = 0;j < MS0->indent;j++){
                str2 = [str2 stringByAppendingString:@"　"];
            }
            [MSD->SCRPT insertObject:[NSString stringWithFormat:@"%@◆", str2] atIndex:cnt+i*2+2];
        }
        NSString *str3 = @"";
        for(int j = 1;j < MS0->indent;j++){
            str3 = [str3 stringByAppendingString:@"　"];
        }
        [MSD->SCRPT insertObject:[NSString stringWithFormat:@"%@：分岐終了", str3] atIndex:cnt+[MS0->S2.sel count]*2+1];
    }else if(insertFlag){
        MS0->indent++;
        MS0->S2.sel = [NSMutableArray new];
        [MS0->S2.sel setArray:EDselectionMA];
        
        for (int i = 0; i < [MS0->S2.sel count]; i++) {
            if(i == 0){
                MS0->S2.S = calloc(1, sizeof(MAPSCRIPT2A));
                MS0->S2.S->next = NULL;
                m2ATop = MS0->S2.S;
            }
            else{
                MS0->S2.S->next = calloc(1, sizeof(MAPSCRIPT2A));
                MS0->S2.S = MS0->S2.S->next;
                MS0->S2.S->next = NULL;
            }
        }
        
        
        int instantCnt = 0;
        int instantCnt2 = 0;
        [self EDsquareCount:&cnt cnt1:&instantCnt cnt2:&instantCnt2];
        
        [MSD->SCRPT insertObject:@"◆選択肢の表示"atIndex:cnt];
        for(int i = 0 ;i < [MS0->S2.sel count];i++){
            NSString *str = @"";
            
            for(int j = 1;j < MS0->indent;j++){
                str = [str stringByAppendingString:@"　"];
            }
            [MSD->SCRPT insertObject:[NSString stringWithFormat:@"%@：%@の場合", str, [[MS0->S2.sel objectAtIndex:i] objectForKey:@"name"]] atIndex:cnt+i*2+1];
            NSString *str2 = @"";
            for(int j = 0;j < MS0->indent;j++){
                str2 = [str2 stringByAppendingString:@"　"];
            }
            [MSD->SCRPT insertObject:[NSString stringWithFormat:@"%@◆", str2] atIndex:cnt+i*2+2];
        }
        NSString *str3 = @"";
        for(int j = 1;j < MS0->indent;j++){
            str3 = [str3 stringByAppendingString:@"　"];
        }
        [MSD->SCRPT insertObject:[NSString stringWithFormat:@"%@：分岐終了", str3] atIndex:cnt+[MS0->S2.sel count]*2+1];
    }else{
        MS0->indent++;
        MS0->S2.sel = [NSMutableArray new];
        [MS0->S2.sel setArray:EDselectionMA];
        
        for (int i = 0; i < [MS0->S2.sel count]; i++) {
            if(i == 0){
                MS0->S2.S = calloc(1, sizeof(MAPSCRIPT2A));
                MS0->S2.S->next = NULL;
                m2ATop = MS0->S2.S;
            }
            else{
                MS0->S2.S->next = calloc(1, sizeof(MAPSCRIPT2A));
                MS0->S2.S = MS0->S2.S->next;
                MS0->S2.S->next = NULL;
            }
        }
        
        [MSD->SCRPT addObject:@"◆選択肢の表示"];
        for(int i = 0 ;i < [MS0->S2.sel count];i++){
            NSString *str = @"";
            for(int j = 1;j < MS0->indent;j++){
                str = [str stringByAppendingString:@"　"];
            }
            
            [MSD->SCRPT addObject:[NSString stringWithFormat:@"%@：%@の場合", str, [[MS0->S2.sel objectAtIndex:i] objectForKey:@"name"]]];
            NSString *str2 = @"";
            for(int j = 0;j < MS0->indent;j++){
                str2 = [str2 stringByAppendingString:@"　"];
            }
            [MSD->SCRPT addObject:[NSString stringWithFormat:@"%@◆", str2]];
        }
        NSString *str3 = @"";
        for(int j = 1;j < MS0->indent;j++){
            str3 = [str3 stringByAppendingString:@"　"];
        }
        [MSD->SCRPT addObject:[NSString stringWithFormat:@"%@：分岐終了", str3]];
    }
    
    
    
    
    
    
    MS0 = m0Top;
    
    MF[MFselectedRow+1].MS.D->P = MS0;
    
    [EDselectionWindow close];
    [self initEDlist];
    [eventDetailListAC setSelectionIndex:EDrow];
    [eventDetailSelectionWindow close];
}

-(void)EDsquareCount:(int*)cnt cnt1:(int*)cnt1 cnt2:(int*)cnt2{

    MAPSCRIPTD *MSD = MF[MFselectedRow+1].MS.D;
    int spaceCnt = 0;
    bool spaceCntFlag = false;
    for (int i = 0;i < [MSD->SCRPT count];i++) {
        NSArray *array = [[MSD->SCRPT objectAtIndex:i] componentsSeparatedByString:@"◆"];
        NSArray *array2 = [[MSD->SCRPT objectAtIndex:i] componentsSeparatedByString:@"　"];
        if([array count] >= 2 && !spaceCntFlag){
            *cnt1 += 1;
        }else if([array count] >= 2 && spaceCntFlag && spaceCnt == (int)[array2 count]-1){
            *cnt1 += 1;
        }
        
        if(*cnt1 == squareCnt){
            *cnt2 += 1;
            *cnt -= 1;
            if(!spaceCntFlag){
                spaceCnt = (int)[array2 count]-1;
                spaceCntFlag = true;
            }
        }
        if(*cnt1 == squareCnt + 1){
            break;
        }
        *cnt += 1;
        
    }
}

-(IBAction)EDselectionCancel:(id)sender{
    
    [EDselectionWindow close];
}

-(void)initEDvalue{
    
    [self willChangeValueForKey:@"EDvalueMA"];
    [EDvalueMA removeAllObjects];
    [self didChangeValueForKey:@"EDvalueMA"];
 
    
    //※追加予定
}


-(IBAction)EDvalue:(id)sender{
    
    [self initEDvalue];
    
    [EDvalueWindow makeKeyAndOrderFront:nil];
    
}

-(IBAction)EDvalueSubmit:(id)sender{

    //追加予定
    
    [EDvalueWindow close];
}

-(IBAction)EDvalueCancel:(id)sender{

    [EDvalueWindow close];
}

-(void)initEDswitch{
    
    
    
    //※追加予定
}


-(IBAction)EDswitch:(id)sender{

    [self initEDswitch];
    
    [EDswitchTF setStringValue:@""];
    
    SuicchiSentakuflag = true;
    
    [EDSwitchWindow2 makeKeyAndOrderFront:nil];
}

-(IBAction)EDswitchSubmit:(id)sender{

    //追加予定
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    MS.D = msdtop;
    MAPSCRIPTD *MSDt = MS.D;
    
    if(SuicchiONOFFsentakuflag){
        [self willChangeValueForKey:@"EDswitch1MA"];
        [EDswitch1MA removeAllObjects];
        [self didChangeValueForKey:@"EDswitch1MA"];
        
        NSArray *array = [[EDswitchTF stringValue] componentsSeparatedByString:@" "];
        if([array count] <= 0) return;
        
        MS.D->switch1 = calloc([array count], sizeof(int));
        
        for(int i = 0;i < [array count];i++){
            if([[array objectAtIndex:i] isEqualToString:nil]) continue;
            NSMutableDictionary* dict = [NSMutableDictionary new];
        
            
            *(MS.D->switch1 + i) = [[array objectAtIndex:i] intValue];
            [dict setValue:[NSString stringWithFormat:@"%d", [[array objectAtIndex:i] intValue]] forKey:@"value"];
        
            [self willChangeValueForKey:@"EDswitch1MA"];
            [EDswitch1MA addObject:dict];
            [self didChangeValueForKey:@"EDswitch1MA"];
        }
    
    
    }else if(!SuicchiONOFFsentakuflag){
        [self willChangeValueForKey:@"EDswitch2MA"];
        [EDswitch2MA removeAllObjects];
        [self didChangeValueForKey:@"EDswitch2MA"];
    
        NSArray *array = [[EDswitchTF stringValue] componentsSeparatedByString:@" "];
        if([array count] <= 0) return;
        
        MS.D->switch2 = calloc([array count], sizeof(int));
        
        for(int i = 0;i < [array count];i++){
            if([[array objectAtIndex:i] isEqualToString:nil]) continue;
            NSMutableDictionary* dict = [NSMutableDictionary new];
            
            *(MS.D->switch2 + i) = [[array objectAtIndex:i] intValue];
            [dict setValue:[NSString stringWithFormat:@"%d", [[array objectAtIndex:i] intValue]] forKey:@"value"];
            
            [self willChangeValueForKey:@"EDswitch2MA"];
            [EDswitch2MA addObject:dict];
            [self didChangeValueForKey:@"EDswitch2MA"];
        }
    }
    
    
    
    [EDswitchWindow close];
}


-(IBAction)EDswitchCancel:(id)sender{
    
    [EDswitchWindow close];
    
}

-(void)initEDvar{
    
    [self willChangeValueForKey:@"EDvarMA"];
    [EDvarMA removeAllObjects];
    [self didChangeValueForKey:@"EDvarMA"];
    
    
    //※追加予定
}

-(IBAction)EDvariable:(id)sender{

    [self initEDvar];
    
    [EDvarWindow makeKeyAndOrderFront:nil];
}

-(IBAction)EDvariableSubmit:(id)sender{

    [EDvarWindow close];
}

-(IBAction)EDvariableCancel:(id)sender{

    [EDvarWindow close];
}

-(void)initEDtimer{
    
    
    //※追加予定
}

-(IBAction)EDtimer:(id)sender{

    [self initEDtimer];
    
    [EDtimerWindow makeKeyAndOrderFront:nil];
}


-(IBAction)EDtimerSubmit:(id)sender{

    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    MS.D = msdtop;
    
    [eventDetailListMA removeObjectAtIndex:EDrow];
    
    MAPSCRIPT0 *MSDPt = MS.D->P;
    
    MAPSCRIPT0 *MS0 = MS.D->P;
    
    for(int i = 0;i < squareCnt - 1 ;i++){
        MS0 = MS0->next;
    }
    
    int omfgCnt = 0;
    for(int i= 0;i < squareCnt -1;i++){
        for(int k = 0;omfgCnt < [MS.D->SCRPT count];k++){
            NSArray *array = [[MS.D->SCRPT objectAtIndex:omfgCnt] componentsSeparatedByString:@"◆"];
            omfgCnt++;
            if([array count] > 1 && omfgCnt > 1){
                break;
            }
        }
        
    }
    
    if(timerDBLslickFlag){
        [eventDetailListMA removeObjectAtIndex:EDrow];
        [MS.D->SCRPT removeObjectAtIndex:omfgCnt];
        [MS.D->SCRPT removeObjectAtIndex:omfgCnt];
    }
    MS0->timerMin = [EDTimerTF1 intValue];
    MS0->timerSec = [EDTimerTF2 intValue];
    MS0->timerFlag = true;
    
    NSMutableDictionary* dict2 = [NSMutableDictionary new];
    
    [dict2 setValue:[NSString stringWithFormat:@"◆タイマーの操作"] forKey:@"value"];
    
    [MS.D->SCRPT insertObject:@"◆タイマーの操作" atIndex:omfgCnt];

    
    [self willChangeValueForKey:@"eventDetailListMA"];
    [eventDetailListMA insertObject:dict2 atIndex:EDrow];
    [self didChangeValueForKey:@"eventDetailListMA"];
    
    
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    NSString *string = [NSString stringWithFormat:@""];
    EDrow++;
    
    string = [string stringByAppendingFormat:@"%d分%d秒　", MS0->timerMin, MS0->timerSec];
    
    if(MS0->timerRun)
        string = [string stringByAppendingFormat:@"始動　"];
    else
        string = [string stringByAppendingFormat:@"停止　"];
    if(MS0->timerMode)
        string = [string stringByAppendingFormat:@"足す　"];
    else
        string = [string stringByAppendingFormat:@"引く　"];
    if(MS0->timerVisible)
        string = [string stringByAppendingFormat:@"表示"];
    else
        string = [string stringByAppendingFormat:@"非表示"];
    
    [dict setValue:[NSString stringWithFormat:@"%@", string] forKey:@"value"];
    
    [dict setValue:string forKey:@"value"];

    [MS.D->SCRPT insertObject:string atIndex:omfgCnt+1];

    
    [self willChangeValueForKey:@"eventDetailListMA"];
    [eventDetailListMA insertObject:dict atIndex:EDrow];
    [self didChangeValueForKey:@"eventDetailListMA"];

    
    MS.D->P = MS0;
    
    MS.D->P = MSDPt;
    timerDBLslickFlag = false;
    [EDtimerWindow close];
    [eventDetailSelectionWindow close];
}
-(IBAction)EDtimerCancel:(id)sender{
    
    [EDtimerWindow close];
}



-(void)initEDterms{
    
    
    //※追加予定
}

-(IBAction)EDterms:(id)sender{


    [self initEDterms];
    
    [EDtermsWindow makeKeyAndOrderFront:nil];

}



-(IBAction)EDtermsSubmit:(id)sender{


    [EDtermsWindow close];
}


-(IBAction)EDtermsCancel:(id)sender{

    [EDtermsWindow close];
}




-(void)initEDlabel{
    
    
    //※追加予定
}
-(IBAction)EDlabel:(id)sender{


    [self initEDlabel];
    
    [EDlabelWindow makeKeyAndOrderFront:nil];
}



-(IBAction)EDlabelSubmit:(id)sender{

    [EDlabelWindow close];
}
-(IBAction)EDlabelCancel:(id)sender{

    [EDlabelWindow close];

}




-(void)initEDlabelJump{
    
    
    //※追加予定
}


-(IBAction)EDlabelJump:(id)sender{


    [self initEDlabelJump];
    
    [EDlabelJumpWindow makeKeyAndOrderFront:nil];
}


-(IBAction)EDlabelJumpSubmit:(id)sender{

    
    
    [EDlabelJumpWindow close];

}



-(IBAction)EDlabelJumpCancel:(id)sender{




    [EDlabelJumpWindow close];

}



-(void)initEDmemo{
    
    
    //※追加予定
}


-(IBAction)EDmemo:(id)sender{



    [self initEDmemo];
    
    [EDmemoWindow makeKeyAndOrderFront:nil];
}

-(IBAction)EDmemoSubmit:(id)sender{

    [EDmemoWindow close];
}
-(IBAction)EDmemoCancel:(id)sender{

    [EDmemoWindow close];
}


-(void)initEDresource{
    
    
    //※追加予定
}




-(IBAction)EDresource:(id)sender{


    [self initEDresource];
    
    [EDresourceWindow makeKeyAndOrderFront:nil];

}


-(IBAction)EDresourceSubmit:(id)sender{


    [EDresourceWindow close];
}



-(IBAction)EDresourceCancel:(id)sender{

    [EDresourceWindow close];
}




-(IBAction)EDitem:(id)sender{}
-(IBAction)EDmember:(id)sender{}





-(void)initEDhp{
    
    
    //※追加予定
}

-(IBAction)EDhp:(id)sender{


    [self initEDhp];
    
    [EDhpWindow makeKeyAndOrderFront:nil];
}



-(IBAction)EDhpSubmit:(id)sender{


    [EDhpWindow close];


}

-(IBAction)EDhpCancel:(id)sender{



    [EDhpWindow close];

}

-(IBAction)EDmp:(id)sender{}
-(IBAction)EDstatus:(id)sender{}
-(IBAction)EDstate:(id)sender{}
-(IBAction)EDskill:(id)sender{}
-(IBAction)EDname:(id)sender{}
-(IBAction)EDequip:(id)sender{}
-(IBAction)EDattackFlagOn:(id)sender{}

-(IBAction)EDmove:(id)sender{}
-(IBAction)EDappear:(id)sender{}
-(IBAction)EDdissapear:(id)sender{}

-(IBAction)EDplace:(id)sender{}
-(IBAction)EDwait:(id)sender{}
-(IBAction)EDpilot:(id)sender{}
-(IBAction)EDunit:(id)sender{}
-(IBAction)EDbgm:(id)sender{}
-(IBAction)EDbgmFadeOut:(id)sender{}
-(IBAction)EDse:(id)sender{}
-(IBAction)EDseStop:(id)sender{}

-(IBAction)EDbattle:(id)sender{}
-(IBAction)EDshop:(id)sender{}
-(IBAction)EDnameInput:(id)sender{}

-(IBAction)EDgameOver:(id)sender{}
-(IBAction)EDstageClear:(id)sender{}
-(IBAction)EDtitle:(id)sender{}


-(IBAction)EDSWOKbtn:(id)sender{
    
    
    MAPSCRIPT MS = MF[MFselectedRow+1].MS;
    
    MS.D = msdtop;
    
    [eventDetailListMA removeObjectAtIndex:EDrow];
    
    MAPSCRIPT0 *MSDPt = MS.D->P;
    
    MAPSCRIPT0 *MS0 = MS.D->P;
    MAPSCRIPTD *MSD = MS.D;
    
    for(int i = 0;i < squareCnt - 1 ;i++){
        MS0 = MS0->next;
    }
    
    int omfgCnt = 0;
    for(int i= 0;i < squareCnt -1;i++){
        for(int k = 0;omfgCnt < [MS.D->SCRPT count];k++){
            NSArray *array = [[MS.D->SCRPT objectAtIndex:omfgCnt] componentsSeparatedByString:@"◆"];
            omfgCnt++;
            if([array count] > 1 && omfgCnt > 1){
                break;
            }
        }
        
    }
    
    if(suicchiDBLslickFlag){
        [eventDetailListMA removeObjectAtIndex:EDrow];
        [MS.D->SCRPT removeObjectAtIndex:omfgCnt];
        [MS.D->SCRPT removeObjectAtIndex:omfgCnt];
    }
    
    
    MS0->type = 3;
    
    if([EDSWON state] == YES){
    
        NSMutableDictionary* dict2 = [NSMutableDictionary new];
        
        [dict2 setValue:[NSString stringWithFormat:@"◆スイッチの操作ON"] forKey:@"value"];
        
        if(!suicchiDBLslickFlag)
            [MS.D->SCRPT insertObject:@"◆スイッチの操作ON" atIndex:omfgCnt];
        if(suicchiDBLslickFlag)
            [MS.D->SCRPT insertObject:@"◆スイッチの操作ON" atIndex:omfgCnt];
        
        [self willChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListMA insertObject:dict2 atIndex:EDrow];
        [self didChangeValueForKey:@"eventDetailListMA"];
        
        NSArray *array = [[EDSWTF stringValue] componentsSeparatedByString:@" "];
        
        MS0->switch1 = calloc([array count], sizeof(int));
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        NSString *string = [NSString stringWithFormat:@""];
        EDrow++;
        for(int i = 0;i < [array count];i++){
            //if([[array objectAtIndex:i] isEqualToString:nil]) continue;
            
            *(MS0->switch1 + i) = [[array objectAtIndex:i] intValue];
            
            string = [string stringByAppendingFormat:@"%d", [[array objectAtIndex:i] intValue]];
            
            if(i + 1 < [array count]){
                string = [string stringByAppendingFormat:@","];
            }
        }
        
        [dict setValue:string forKey:@"value"];
        if(!suicchiDBLslickFlag)
            [MS.D->SCRPT insertObject:string atIndex:omfgCnt+1];
        if(suicchiDBLslickFlag)
            [MS.D->SCRPT insertObject:string atIndex:omfgCnt+1];
        
        [self willChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListMA insertObject:dict atIndex:EDrow];
        [self didChangeValueForKey:@"eventDetailListMA"];
        
    
    }else{
        
        NSMutableDictionary* dict2 = [NSMutableDictionary new];
        
        [dict2 setValue:[NSString stringWithFormat:@"◆スイッチの操作OFF"] forKey:@"value"];
        
        if(!suicchiDBLslickFlag)
            [MS.D->SCRPT insertObject:@"◆スイッチの操作OFF" atIndex:omfgCnt];
        if(suicchiDBLslickFlag)
            [MS.D->SCRPT insertObject:@"◆スイッチの操作OFF" atIndex:omfgCnt];
        
        [self willChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListMA insertObject:dict2 atIndex:EDrow];
        [self didChangeValueForKey:@"eventDetailListMA"];
        
        NSArray *array = [[EDSWTF stringValue] componentsSeparatedByString:@" "];
        
        MS0->switch2 = calloc([array count], sizeof(int));
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
        NSString *string = [NSString stringWithFormat:@""];
        EDrow++;
        for(int i = 0;i < [array count];i++){
            //if([[array objectAtIndex:i] isEqualToString:nil]) continue;
            
            *(MS0->switch2 + i) = [[array objectAtIndex:i] intValue];
            
            string = [string stringByAppendingFormat:@"%d", [[array objectAtIndex:i] intValue]];
             
            if(i + 1 < [array count]){
                string = [string stringByAppendingFormat:@","];
            }
        }
        
        [dict setValue:string forKey:@"value"];
        
        if(!suicchiDBLslickFlag)
            [MS.D->SCRPT insertObject:string atIndex:omfgCnt+1];
        if(suicchiDBLslickFlag)
            [MS.D->SCRPT insertObject:string atIndex:omfgCnt+1];
        
        [self willChangeValueForKey:@"eventDetailListMA"];
        [eventDetailListMA insertObject:dict atIndex:EDrow];
        [self didChangeValueForKey:@"eventDetailListMA"];
    
    
    
    }
    
    MS.D->P = MS0;
    MS.D->P = MSDPt;
    
    MS.D = msdtop;
    
    
    
    [eventDetailListAC setSelectionIndex:EDrow];
    SuicchiSentakuflag = false;
    suicchiDBLslickFlag = false;
    [EDSwitchWindow2 close];
    [eventDetailSelectionWindow close];
}


-(IBAction)EDSWCancelbtn:(id)sender{
    
    [EDSwitchWindow2 close];
}





-(IBAction)playerSetBtn1:(id)sender{

    playerSet1 = (int)[eventPlayerSetPUB1 indexOfSelectedItem];

    MF[MFselectedRow+1].MS.playerSet1 = playerSet1;
}


-(IBAction)playerSetBtn2:(id)sender{


    playerSet2 = (int)[eventPlayerSetPUB2 indexOfSelectedItem];
    MF[MFselectedRow+1].MS.playerSet2 = playerSet2;

}


-(IBAction)setBattleModeBtn:(id)sender{

    battleSetMode = [eventBattleDetailBtn intValue];

    MF[MFselectedRow+1].MS.battleSetMode = battleSetMode;

}


-(IBAction)EDTimerSetBtn1:(id)sender{
    
    fuckingRetardedBtnPushed1 = true;
    


    
}
-(IBAction)EDTimerSetBtn2:(id)sender{

    fuckingRetardedBtnPushed1 = true;








}
-(IBAction)EDTimerSetBtn3:(id)sender{
    
    fuckingRetardedBtnPushed1 = true;







}















@end
