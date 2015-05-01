//
//  MechaChipList.m
//  Awars III
//
//  Created by Killery on 2014/01/14.
//  Copyright (c) 2014年 Killery. All rights reserved.
//

#import "LoadChipList.h"

@implementation LoadChipList

-(void)awakeFromNib{

    [loadChipListTV setTarget:self];
    [loadChipListTV setDoubleAction:@selector(doubleClickLCL:)];

    loadChipListMA = [NSMutableArray new];
}



-(id)init{

    LCLtime  = [NSTimer
                scheduledTimerWithTimeInterval:0.01f
                target:self
                selector:@selector(EventLoopLCL:)
                userInfo:nil
                repeats:YES
                ];

    chipNumb = 23;
    [self initFileDirectory];
    [self initLoadChipList];
    
    //allocするともう一度initを呼び出してしまう
    UnitChipList *UCL = [UnitChipList alloc];
    [UCL initFileDirectoryAttack2];
    [self initTotalDamage];

    LoadChipMax = (int)chipNumb/25 + 1;
    
    return self;
}

-(void)initTotalDamage{
    UnitChipList *UCL = [UnitChipList alloc];
    [UCL initFileDirectoryAttack2];
    
    for(int i = 0;i < chipNumb;i++){
        int j = 0;
        while (j < 64) {
            [UCL setTotalDamage2:i row:j];
            j++;
        }
    }
    
}

-(void)EventLoopLCL:(NSTimer*)time{

}

-(void)doubleClickLCL:(id)sender{
    cil = [loadChipListTV clickedRow];
    
    [TFname setStringValue:LC[cil].name];
    [TFnameR setStringValue:LC[cil].nameRecognition];
    [TFnameID setStringValue:LC[cil].nameID];
    
    
    [TFhp setDoubleValue:LC[cil].S_M.HP];
    [TFen setIntValue:LC[cil].S_M.EN];
    [TFwt setIntValue:LC[cil].S_M.WT];
    
    [TFmov setIntValue:LC[cil].S_M.MOV];
    [TFarm setIntValue:LC[cil].S_M.ARM];
    [TFmob setIntValue:LC[cil].S_M.MOB];
    [TFlim setIntValue:LC[cil].S_M.LIM];
    
    [TFcSupply setIntValue:LC[cil].S_M.cSupply];
    [TFcFood setIntValue:LC[cil].S_M.cFood];
    [TFcMoney setIntValue:LC[cil].S_M.cMoney];
    [TFcWT setIntValue:LC[cil].S_M.cWT];
    
    [PUPtSize selectItemAtIndex:LC[cil].S_M.size];
    [PUPtMove selectItemAtIndex:LC[cil].S_M.typeMOVE];
    
    [IVimg setImage:LC[cil].img];
    [IVimgb setImage:LC[cil].imgb];
    
    [LCLDetailPanel makeKeyAndOrderFront:nil];

}



-(void)initLoadChipList{
    loadChipListMA = [NSMutableArray new];
    
    for(int i = 0;i < chipNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        if(!LC[i].nameID){
            LC[i].name = [[NSString stringWithFormat:@"新規搭載ユニット"] retain];
            LC[i].name = [[LC[i].name stringByAppendingFormat:@"%d",i+1] retain];
            LC[i].nameID = @"lc";
            LC[i].nameID = [[LC[i].nameID stringByAppendingFormat:@"%d",i+1] retain];
            LC[i].nameRecognition = [@"新規機械" retain];
            LC[i].nameRecognition = [[LC[i].nameRecognition stringByAppendingFormat:@"%d",i+1] retain];
            LC[i].iName = @"lc";
            LC[i].iName = [[LC[i].iName stringByAppendingFormat:@"%d",i+1] retain];
            LC[i].iNameb = @"lcb";
            LC[i].iNameb = [[LC[i].iNameb stringByAppendingFormat:@"%d",i+1] retain];
        }
        
        [dict setValue:LC[i].img forKey:@"img"];
        [dict setValue:LC[i].imgb forKey:@"imgb"];
        [dict setValue:[NSString stringWithFormat:@"%@", LC[i].name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%g", LC[i].S_M.HP] forKey:@"HP"];
        [self willChangeValueForKey:@"loadChipListMA"];
        [loadChipListMA addObject:dict];
        [self didChangeValueForKey:@"loadChipListMA"];
    }

}


-(void)initFileDirectory{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/LoadChip/preset.txt"];
    NSString *pathLC = @"data/LoadChip/img";
    NSString *pathDATA2 = @"data/LoadChip/preset.txt";
    NSString *pathLCP = @"data/LoadChip/preset.txt";
    NSString *fileData = nil;
    
    chipNumb = 24;
    LCN = (int)chipNumb;
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathLC withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathLCP contents:nil attributes:nil];
        
        NSString *data0 = @"24";
        [data0 writeToFile:pathLCP atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSString *data1 = @"野砲\n野砲,野砲\n"
        @"500,100,500\n10,100,20,100\n1,0,0,100,0,250,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data2 = @"装甲輸送車\n装甲輸送車,装甲輸送車\n"
        @"2000,200,500\n15,1000,50,250\n1,0,0,150,0,500,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data3 = @"補給車\n補給車,補給車\n"
        @"1000,150,500\n15,500,50,200\n1,0,0,150,0,200,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data4 = @"戦車\n戦車,戦車\n"
        @"5000,300,500\n15,1400,60,250\n1,0,0,500,0,1000,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data5 = @"重戦車\n重戦車,重戦車\n"
        @"9000,500,500\n15,2000,60,300\n1,0,0,800,0,2000,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data6 = @"自走砲\n自走砲,自走砲\n"
        @"3000,250,500\n12,1000,40,200\n1,0,0,300,0,800,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data7 = @"ロケット砲\nロケット砲,ロケット砲\n"
        @"6000,300,500\n12,1200,50,230\n1,0,0,600,0,1800,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data8 = @"対空砲\n対空砲,対空砲\n"
        @"400,150,500\n16,800,60,240\n1,0,0,300,0,800,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data9 = @"対空ミサイル\n対空ミサイル,対空ミサイル\n"
        @"5000,300,500\n14,1200,50,220\n1,0,0,400,0,1400,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data10 = @"大砲\n大砲,大砲\n"
        @"8000,500,500\n0,1500,0,300\n1,0,0,1800,0,3000,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data11 = @"輸送ヘリ\n輸送ヘリ,輸送ヘリ\n"
        @"2500,150,500\n18,800,60,250\n1,0,0,250,0,500,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data12 = @"戦闘機\n戦闘機,戦闘機\n"
        @"3000,200,500\n21,1000,80,300\n1,0,0,200,0,800,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data13 = @"高速戦闘機\n高速戦闘機,高速戦闘機\n"
        @"4000,250,500\n27,1200,100,400\n1,0,0,250,0,1500,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data14 = @"爆撃機\n爆撃機,爆撃機\n"
        @"4000,200,500\n20,1300,60,240\n1,0,0,250,0,800,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data15 = @"重爆撃機\n重爆撃機,重爆撃機\n"
        @"5000,300,500\n18,1500,60,240\n1,0,0,400,0,1200,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data16 = @"攻撃ヘリ\n攻撃ヘリ,攻撃ヘリ\n"
        @"5000,250,500\n20,1000,80,320\n1,0,0,250,0,1500,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc1.png,lcb1.png\n";
        NSString *data17 = @"キャリア\nキャリア,キャリア\n"
        @"7000,200,500\n24,1200,90,320\n1,0,0,400,0,1300,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc17.png,lcb17.png\n";
        NSString *data18 = @"運輸船\n運輸船,運輸船\n"
        @"500,100,500\n10,100,20,100\n1,0,0,150,0,100,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc18.png,lcb18.png\n";
        NSString *data19 = @"戦艦\n戦艦,戦艦\n"
        @"500,100,500\n10,100,20,100\n1,0,0,150,0,100,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc19.png,lcb19.png\n";
        NSString *data20 = @"対空戦艦\n対空戦艦,対空戦艦\n"
        @"500,100,500\n10,100,20,100\n1,0,0,150,0,100,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc20.png,lcb20.png\n";
        NSString *data21 = @"魚雷艇\n魚雷艇,魚雷艇\n"
        @"500,100,500\n10,100,20,100\n1,0,0,150,0,100,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc21.png,lcb21.png\n";
        NSString *data22 = @"潜水艦\n潜水艦,潜水艦\n"
        @"500,100,500\n10,100,20,100\n1,0,0,150,0,100,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc22.png,lcb22.png\n";
        NSString *data23 = @"イージス艦\nイージス艦,イージス艦\n"
        @"500,100,500\n10,100,20,100\n1,0,0,150,0,100,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc23.png,lcb23.png\n";
        NSString *data24 = @"母艦\n母艦,母艦\n"
        @"500,100,500\n10,100,20,100\n1,0,0,150,0,100,1000\n"
        @"100,100,100,100,100,100,"
        @"100,100,100,100,100,100,100,100,100,100,"
        @"100,100,100,100,100,100\n"
        @"lc24.png,lcb24.png\n";

        
        for (int i=1; i<=chipNumb; i++) {
            NSString *fdata = @"data/LoadChip/LCdata";
            
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
                    
                default:
                    
                    break;
            }
            
        }
        
    }
    
    
    
    fileData = [NSString stringWithContentsOfFile:pathLCP encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    int instantNum = [[fileDataArray objectAtIndex:0] intValue];
    
    chipNumb = instantNum;
    LCN = (int)chipNumb;
    
    for (int i=0; i<chipNumb; i++) {
        NSString *fdata = @"data/LoadChip/LCdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        fileDataArray = [fileData componentsSeparatedByString:@"\n"];
        
        LC[i].name = [[fileDataArray objectAtIndex:0] retain];
        
        NSArray *items = [[fileDataArray objectAtIndex:1] componentsSeparatedByString:@","];
        
        LC[i].nameRecognition = [[items objectAtIndex:0] retain];
        LC[i].nameID = [[items objectAtIndex:1] retain];
        
        items = [[fileDataArray objectAtIndex:2] componentsSeparatedByString:@","];
        
        LC[i].S_M.HP = [[items objectAtIndex:0] doubleValue];
        LC[i].S_M.EN = [[items objectAtIndex:1] intValue];
        LC[i].S_M.WT = [[items objectAtIndex:2] intValue];
        
        items = [[fileDataArray objectAtIndex:3] componentsSeparatedByString:@","];
        
        LC[i].S_M.MOV = [[items objectAtIndex:0] intValue];
        LC[i].S_M.ARM = [[items objectAtIndex:1] intValue];
        LC[i].S_M.MOB = [[items objectAtIndex:2] intValue];
        LC[i].S_M.LIM = [[items objectAtIndex:3] intValue];
        
        items = [[fileDataArray objectAtIndex:4] componentsSeparatedByString:@","];
 
        LC[i].S_M.size = [[items objectAtIndex:0] intValue];
        LC[i].S_M.loadCnt = [[items objectAtIndex:1] intValue];
        LC[i].S_M.typeMOVE = [[items objectAtIndex:2] intValue];
        LC[i].S_M.cSupply = [[items objectAtIndex:3] intValue];
        LC[i].S_M.cFood = [[items objectAtIndex:4] intValue];
        LC[i].S_M.cMoney = [[items objectAtIndex:5] intValue];
        LC[i].S_M.cWT = [[items objectAtIndex:6] intValue];
        
        items = [[fileDataArray objectAtIndex:5] componentsSeparatedByString:@","];
        
        LC[i].R_M.blow = [[items objectAtIndex:0] intValue];
        LC[i].R_M.slash = [[items objectAtIndex:1] intValue];
        LC[i].R_M.stub = [[items objectAtIndex:2] intValue];
        LC[i].R_M.arrow = [[items objectAtIndex:3] intValue];
        LC[i].R_M.gun = [[items objectAtIndex:4] intValue];
        LC[i].R_M.shell = [[items objectAtIndex:5] intValue];
        
        LC[i].R_M.flame = [[items objectAtIndex:6] intValue];
        LC[i].R_M.cold = [[items objectAtIndex:7] intValue];
        LC[i].R_M.electoric = [[items objectAtIndex:8] intValue];
        LC[i].R_M.air = [[items objectAtIndex:9] intValue];
        LC[i].R_M.water = [[items objectAtIndex:10] intValue];
        LC[i].R_M.gas = [[items objectAtIndex:11] intValue];
        LC[i].R_M.holy = [[items objectAtIndex:12] intValue];
        LC[i].R_M.dark = [[items objectAtIndex:13] intValue];
        LC[i].R_M.explosion = [[items objectAtIndex:14] intValue];
        LC[i].R_M.blood = [[items objectAtIndex:15] intValue];
        
        LC[i].R_M.paralysis = [[items objectAtIndex:16] intValue];
        LC[i].R_M.confusion = [[items objectAtIndex:17] intValue];
        LC[i].R_M.poison = [[items objectAtIndex:18] intValue];
        LC[i].R_M.sleep = [[items objectAtIndex:19] intValue];
        LC[i].R_M.charm = [[items objectAtIndex:20] intValue];
        LC[i].R_M.silent = [[items objectAtIndex:21] intValue];
        
        items = [[fileDataArray objectAtIndex:6] componentsSeparatedByString:@","];
        
        LC[i].iName = [[items objectAtIndex:0] retain];
        //NSLog(@"%@", LC[i].iName);
        LC[i].iNameb = [[items objectAtIndex:1] retain];
        
        NSString *imgName = @"lc";
        imgName = [imgName stringByAppendingFormat:@"%d", i+1];
        LC[i].img = [[NSImage imageNamed:imgName] retain];
        
        
        imgName = [NSString stringWithFormat:@"lcb"];
        imgName = [imgName stringByAppendingFormat:@"%d", i+1];
        LC[i].imgb = [[NSImage imageNamed:imgName] retain];
        
        NSString *imagePath = @"data/LoadChip/img/lc";
        imagePath = [imagePath stringByAppendingFormat:@"%d", i+1];
        NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
        
        if(imgData)
            LC[i].img = [[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]];
        
        imagePath = [NSString stringWithFormat:@"data/LoadChip/img/lcb"];
        imagePath = [imagePath stringByAppendingFormat:@"%d", i+1];
        imgData = [NSData dataWithContentsOfFile:imagePath];
        
        if(imgData)
            LC[i].imgb = [[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]];
        
        
        LC[i].S_C = LC[i].S_M;
        LC[i].R_C = LC[i].R_M;

        
        LC[i].chipNumb = i;
    }
}

-(void)saveData{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    
    for (int i=0; i<chipNumb; i++) {
        NSString *fdata = @"data/LoadChip/LCdata";
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
        
        NSString *fileData = @"";
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", LC[i].name]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", LC[i].nameRecognition]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", LC[i].nameID]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].S_M.HP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].S_M.EN]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].S_M.WT]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].S_M.MOV]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].S_M.ARM]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].S_M.MOB]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%g", LC[i].S_M.LIM]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].S_M.size]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].S_M.loadCnt]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].S_M.typeMOVE]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].S_M.cSupply]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].S_M.cFood]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].S_M.cMoney]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].S_M.cWT]] stringByAppendingString:@"\n"];
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.blow]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.slash]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.stub]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.arrow]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.gun]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.shell]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.flame]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.cold]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.electoric]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.air]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.water]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.gas]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.holy]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.dark]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.explosion]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.blood]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.paralysis]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.confusion]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.poison]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.sleep]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.charm]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", LC[i].R_M.silent]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].iName]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", UC[i].iNameb]] stringByAppendingString:@"\n"];
        
        //fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"----\n"]];
        
        [fileData writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        if(1){
            NSData *f2Data = [LC[i].img TIFFRepresentation];
            NSBitmapImageRep *brep = [NSBitmapImageRep imageRepWithData:f2Data];
            f2Data = [brep representationUsingType:NSPNGFileType properties:nil];
            
            NSString *bcPath = @"data/LoadChip/img/lc";
            bcPath = [bcPath stringByAppendingFormat:@"%d", i + 1];
            
            [f2Data writeToFile:bcPath atomically:YES];
        }
        
        if(1){
            NSData *f2Data = [LC[i].imgb TIFFRepresentation];
            NSBitmapImageRep *brep = [NSBitmapImageRep imageRepWithData:f2Data];
            f2Data = [brep representationUsingType:NSPNGFileType properties:nil];
            
            NSString *bcPath = @"data/LoadChip/img/lcb";
            bcPath = [bcPath stringByAppendingFormat:@"%d", i + 1];
            
            [f2Data writeToFile:bcPath atomically:YES];
        }
    }
    
    
}


-(IBAction)submit:(id)sender{
    loadChipSideFlag = false;
    [LCLPanel close];
}

-(IBAction)saveLCL:(id)sender{
    
    LC[cil].name = [[TFname stringValue] retain];
    LC[cil].nameRecognition = [[TFnameR stringValue] retain];
    LC[cil].nameID = [[TFnameID stringValue] retain];

    LC[cil].S_M.HP = [TFhp doubleValue];
    LC[cil].S_M.EN = [TFen doubleValue];
    LC[cil].S_M.WT = [TFwt doubleValue];
    
    LC[cil].S_M.MOV = [TFmov intValue];
    LC[cil].S_M.ARM = [TFarm doubleValue];
    LC[cil].S_M.MOB = [TFmob doubleValue];
    LC[cil].S_M.LIM = [TFlim doubleValue];
    
    LC[cil].S_M.cSupply = [TFcSupply intValue];
    LC[cil].S_M.cFood = [TFcFood intValue];
    LC[cil].S_M.cMoney = [TFcMoney intValue];
    LC[cil].S_M.cWT = [TFcWT intValue];
    
    
    LC[cil].S_M.size = (int)[PUPtSize indexOfSelectedItem];
    LC[cil].S_M.typeMOVE = (int)[PUPtMove indexOfSelectedItem];
    
    LC[cil].img = [[IVimg image] retain];
    LC[cil].imgb = [[IVimgb image] retain];

    [loadChipListAC setValue:[NSString stringWithFormat:@"%@", LC[cil].name] forKeyPath:@"selection.name"];
    [loadChipListAC setValue:[NSString stringWithFormat:@"%g", LC[cil].S_M.HP] forKeyPath:@"selection.HP"];
    [loadChipListAC setValue:LC[cil].img forKeyPath:@"selection.img"];
    [loadChipListAC setValue:LC[cil].imgb forKeyPath:@"selection.imgb"];
    
    
    [self saveData];
    
    [LCLDetailPanel close];
}

-(IBAction)cancelLCL:(id)sender{
    [LCLDetailPanel close];
}

-(IBAction)registLCL:(id)sender{
    
    [TFchipNumb setIntValue:(int)chipNumb];
    LCN = (int)chipNumb;
    LoadChipMax = (int)chipNumb/25 + 1;
    [LCLRegisterPanel makeKeyAndOrderFront:nil];
}

-(IBAction)registSaveLCL:(id)sender{
    chipNumb = [TFchipNumb intValue];
    [self savePresetLoadNumber];
    LCN = (int)chipNumb;
    LoadChipMax = (int)chipNumb/25 + 1;
    [self initLoadChipList];
    [LCLRegisterPanel close];
}

-(void)savePresetLoadNumber{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSString *path = @"data/LoadChip/preset.txt";
    
    NSString *data = [NSString stringWithFormat:@"%d", (int)chipNumb];
    
    [data writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

-(IBAction)registCancelLCL:(id)sender{
    [LCLRegisterPanel close];
}

@end
