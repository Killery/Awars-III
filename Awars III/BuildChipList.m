//
//  BuildChipList.m
//  Awars III
//
//  Created by Killery on 2012/12/16.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import "BuildChipList.h"

@implementation BuildChipList
- (void)dealloc
{
    [super dealloc];
}

- (NSMutableArray*)buildChipListMA{
    return buildChipListMA;
}
-(IBAction)submit:(id)sender{
    [BCLPanel close];
}

-(void)awakeFromNib{
    [buildChipListTV setTarget:self];
    [buildChipListTV setDoubleAction:@selector(doubleClickBCL:)];
    
    [researchListTV setTarget:self];
    [researchListTV setAction:@selector(clickRL:)];
    
    researchListMA = [NSMutableArray new];
    unitListPU = [NSMutableArray new];
}
-(id)init{
    [super init];
    
    if (self) {
        [self initFileDirectory];
        [self initBuildChipList];
        BuildChipMax = (int)chipNumb/25+1;
        Rtop = NULL;
    }   
    
    return self;
}
NSInteger clickIndex;
-(void)doubleClickBCL:(id)sender{
    clickIndex = [buildChipListTV clickedRow];
    if( clickIndex>=0 ){
        
        [TFname setStringValue:BC[clickIndex].name];
        [TFnameR setStringValue:BC[clickIndex].nameR];
        [TFnameID setStringValue:BC[clickIndex].nameID];
        [TFfix setIntValue:BC[clickIndex].dmgfix];
        [TFWT setIntValue:BC[clickIndex].S_M.WT];
        [TFDLv setIntValue:BC[clickIndex].defLv];
        [TFHP setIntValue:BC[clickIndex].S_M.HP];
        [TFRHP setIntValue:BC[clickIndex].recHP];
        [TFRMP setIntValue:BC[clickIndex].recMP];
        [TFREN setIntValue:BC[clickIndex].recEN];
        [TFcostS setIntValue:BC[clickIndex].Csupply];
        [TFcostF setIntValue:BC[clickIndex].Cfood];
        [TFcostM setIntValue:BC[clickIndex].Cmoney];
        [TFcostSn setIntValue:BC[clickIndex].CsupplyNext];
        [TFcostFn setIntValue:BC[clickIndex].CfoodNext];
        [TFcostMn setIntValue:BC[clickIndex].CmoneyNext];
        [TFcostSe setIntValue:BC[clickIndex].Esupply];
        [TFcostFe setIntValue:BC[clickIndex].Efood];
        [TFcostMe setIntValue:BC[clickIndex].Emoney];
        [TFWTE setIntValue:BC[clickIndex].S_M.WTE];
        [TFWTN setIntValue:BC[clickIndex].S_M.WTN];
        [BC[clickIndex].img setFlipped:NO];
        [IVimg setImage:BC[clickIndex].img];
        [IVimgBig setImage:BC[clickIndex].imgb];
        [PUPtype selectItemAtIndex:BC[clickIndex].type];
        
        [BTNinroads setIntValue:BC[clickIndex].inroadsFlag];
        [BTNcapture setIntValue:BC[clickIndex].capture];
        
        //[PUPlinkD selectItemAtIndex:BC[clickIndex].linkDest];
        //[PUPlinkN selectItemAtIndex:BC[clickIndex].linkNext];
    }
    
    
    BCLDpoint.x = [BCLPanel frame].origin.x + 50;
    BCLDpoint.y = [BCLPanel frame].origin.y + 100;
    [BCLDetailPanel setFrameOrigin:BCLDpoint];
     [BCLDetailPanel makeKeyAndOrderFront:nil];
}

-(void)clickRL:(id)sender{
    
    RLrow = (int)[researchListTV clickedRow];
    
}

-(IBAction)unitResearchBCL:(id)sender{
    
    [unitListPU removeAllObjects];
    
    for(int i = 0;i < UCN;i++){
        [unitListPU addObject:UC[i].nameRecognition];
    }
    [PUunit addItemsWithTitles:unitListPU];
    
    [self initResearchList];
    
    
    BCLDpoint.x = [BCLDetailPanel frame].origin.x + 0;
    BCLDpoint.y = [BCLDetailPanel frame].origin.y + 0;
    [BCLUnitResearchPanel setFrameOrigin:BCLDpoint];
    [BCLUnitResearchPanel makeKeyAndOrderFront:nil];
}
-(IBAction)unitResearchCloseBCL:(id)sender{
    [BCLUnitResearchPanel close];
}

-(IBAction)saveBCL:(id)sender{
    BC[clickIndex].name = [[TFname stringValue] retain];
    BC[clickIndex].nameR = [[TFnameR stringValue] retain];
    BC[clickIndex].nameID = [[TFnameID stringValue] retain];
    BC[clickIndex].S_M.WT = [TFWT intValue];
    BC[clickIndex].dmgfix = [TFfix intValue];
    BC[clickIndex].defLv = [TFDLv intValue];
    BC[clickIndex].S_M.HP = [TFHP intValue];
    BC[clickIndex].recHP = [TFRHP intValue];
    BC[clickIndex].recMP = [TFRMP intValue];
    BC[clickIndex].recEN = [TFREN intValue];
    BC[clickIndex].Csupply = [TFcostS intValue];
    BC[clickIndex].Cfood = [TFcostF intValue];
    BC[clickIndex].Cmoney = [TFcostM intValue];
    BC[clickIndex].CsupplyNext = [TFcostSn intValue];
    BC[clickIndex].CfoodNext = [TFcostFn intValue];
    BC[clickIndex].CmoneyNext = [TFcostMn intValue];
    BC[clickIndex].Esupply = [TFcostSe intValue];
    BC[clickIndex].Efood = [TFcostFe intValue];
    BC[clickIndex].Emoney = [TFcostMe intValue];
    BC[clickIndex].S_M.WTE = [TFWTE intValue];
    BC[clickIndex].S_M.WTN = [TFWTN intValue];
    BC[clickIndex].type = (int)[PUPtype indexOfSelectedItem];
    BC[clickIndex].img = [[IVimg image] retain];
    BC[clickIndex].imgb = [[IVimgBig image] retain];
    
    BC[clickIndex].inroadsFlag = [BTNinroads intValue];
    BC[clickIndex].capture = [BTNcapture intValue];
    
    [buildChipListAC setValue:[NSString stringWithFormat:@"%@", BC[clickIndex].name] forKeyPath:@"selection.name"];
    [buildChipListAC setValue:[NSString stringWithFormat:@"%d", BC[clickIndex].dmgfix] forKeyPath:@"selection.dmgfix"];
    [buildChipListAC setValue:[NSString stringWithFormat:@"%d", BC[clickIndex].S_M.HP] forKeyPath:@"selection.HP"];
    [buildChipListAC setValue:[NSString stringWithFormat:@"%d", BC[clickIndex].defLv] forKeyPath:@"selection.defLv"];
    [buildChipListAC setValue:[NSString stringWithFormat:@"%d", BC[clickIndex].S_M.WT] forKeyPath:@"selection.WT"];
    [buildChipListAC setValue:BC[clickIndex].img forKeyPath:@"selection.img"];
    [buildChipListAC setValue:BC[clickIndex].imgb forKeyPath:@"selection.imgBig"];
    
    [self saveData];
    [BCLDetailPanel close];
}
-(IBAction)cancelBCL:(id)sender{
    [BCLDetailPanel close];
}

-(IBAction)optionBCL:(id)sender{
    
    BCLDpoint.x = [BCLDetailPanel frame].origin.x + 100;
    BCLDpoint.y = [BCLDetailPanel frame].origin.y + 0;
    [BCLDetailOptionPanel setFrameOrigin:BCLDpoint];
    [BCLDetailOptionPanel makeKeyAndOrderFront:nil];
}

-(IBAction)optionCloseBCL:(id)sender{
    [BCLDetailOptionPanel close];
}

-(void)initFileDirectory{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/BuildChip/preset.txt"];
    NSString *pathBC = @"data/BuildChip/img";
    NSString *pathDATA2 = @"data/BuildChip/preset.txt";
    NSString *pathBCP = @"data/BuildChip/preset.txt";
    NSString *fileData = nil;
    
    if(!InitialData){
        chipNumb = 23;
        [[NSFileManager defaultManager] createDirectoryAtPath:pathBC withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];

        [[NSFileManager defaultManager] createFileAtPath:pathBCP contents:nil attributes:nil];
        
        //NSString *data0 = @"名前\n名前R\nID\nHP,WT,dmgfix,defLv,rcHP,rcMP,rcEN\nS,F,M,Sn,Fn,Mn,Se,Fe,Me,WTe,WTn\ninRoads,capture,type,linkD,linkN\img,imgb\n----\n1,0\n1,2\n1,3\n----";
        
        NSString *data1 = @"集落\n集落（一般）\nb1\n2000,2000,20,2,30,30,0\n0,500,0,500,500,0,100,100,0,1000,1000\n0,1,0,id,id\nbc1.png,bcb1.png\n----\n1,0\n1,2\n1,3\n----";
        NSString *data2 = @"村\n村（一般）\nb2\n3000,2000,30,2,30,30,0\n500,1000,0,500,500,500,100,100,100,1000,1000\n0,1,0,id,id\nbc2.png,bcb2.png\n----\n1,0\n1,1\n1,2\n1,3\n1,4\n1,5\n1,6\n----";
        NSString *data3 = @"町\n町（一般）\nb3\n5000,2000,30,3,30,30,0\n2000,2000,1000,500,500,500,100,100,100,1000,1000\n0,1,0,id,id\nbc3.png,bcb3.png\n----\n1,0\n1,1\n1,2\n1,3\n1,4\n1,5\n1,6\n1,7\n1,8\n1,10\n1,11\n1,12\n1,13\n1,14\n1,15\n1,16\n1,17\n----";
        NSString *data4 = @"街\n街（一般）\nb4\n8000,2000,30,3,30,30,0\n2500,2500,2500,500,500,500,100,100,100,1000,1000\n0,1,0,id,id\nbc4.png,bcb4.png\n----\n1,0\n1,1\n1,2\n1,3\n1,4\n1,5\n1,6\n1,7\n1,8\n1,9\n1,11\n1,12\n1,13\n1,16\n1,17\n1,18\n1,19\n1,22\n1,23\n1,24\n1,25\n1,26\n----";
        NSString *data5 = @"城\n城（一般）\nb5\n9000,2000,30,4,30,30,0\n3000,3000,4000,500,500,500,100,100,100,1000,1000\n0,1,0,id,id\nbc5.png,bcb5.png\n----\n1,7\n1,18\n1,19\n1,20\n1,21\n1,28\n1,29\n1,34\n1,35\n1,36\n1,37\n----";
        NSString *data6 = @"都市\n都市（一般）\nb6\n15000,2000,30,5,30,30,0\n5000,5000,5000,500,500,500,100,100,100,1000,1000\n0,1,0,id,id\nbc6.png,bcb6.png\n----\n1,0\n1,1\n1,2\n1,3\n1,4\n1,5\n1,6\n1,7\n1,8\n1,9\n1,10\n1,11\n1,12\n1,13\n1,14\n1,15\n1,16\n1,17\n1,18\n1,19\n1,20\n1,21\n1,22\n1,23\n1,24\n1,25\n1,26\n1,27\n1,28\n1,29\n1,30\n1,31\n1,32\n1,33\n1,38\n----";
        NSString *data7 = @"首都\n首都（一般）\nb7\n20000,2000,30,5,30,30,0\n10000,10000,15000,500,500,500,100,100,100,1000,1000\n0,1,0,id,id\nbc7.png,bcb7.png\n----\n1,0\n1,16\n1,18\n1,19\n1,20\n1,21\n1,22\n1,23\n1,24\n1,25\n1,26\n1,27\n1,28\n1,29\n1,30\n1,31\n1,32\n1,33\n1,34\n1,35\n1,36\n1,37\n1,38\n1,39\n1,40\n1,41\n1,42\n----";
        NSString *data8 = @"町の中心\n町の中心（一般）\nb8\n5000,2000,30,4,30,30,0\n2000,1000,500,500,500,500,100,100,100,1000,1000\n0,1,0,id,id\nbc8.png,bcb8.png\n----\n1,0\n1,43\n----";
        NSString *data9 = @"城壁\n城壁（一般）\nb9\n2500,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,0,0,id,id\nbc9.png,bcb9.png\n----\n----";
        NSString *data10 = @"瓦礫\n瓦礫（一般）\nb10\n1000,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,0,0,id,id\nbc10.png,bcb10.png\n----\n----";
        NSString *data11 = @"工場\n工場（一般）\nb11\n1600,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc11.png,bcb11.png\n----\n----";
        NSString *data12 = @"港\n港（一般）\nb12\n1500,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,2,id,id\nbc12.png,bcb12.png\n----\n----";
        NSString *data13 = @"空港\n空港（一般）\nb13\n1800,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc13.png,bcb13.png\n----\n----";
        NSString *data14 = @"学校\n学校（一般）\nb14\n1500,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc14.png,bcb14.png\n----\n----";
        NSString *data15 = @"病院\n病院（一般）\nb15\n2000,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc15.png,bcb15.png\n----\n----";
        NSString *data16 = @"保安所\n保安所（一般）\nb16\n2000,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc16.png,bcb16.png\n----\n----";
        NSString *data17 = @"研究所\n研究所（一般）\nb17\n2400,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc17.png,bcb17.png\n----\n----";
        NSString *data18 = @"統制機構\n統制機構（一般）\nb18\n5000,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc18.png,bcb18.png\n----\n----";
        NSString *data19 = @"魔物の巣\n魔物の巣（一般）\nb19\n3000,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc19.png,bcb19.png\n----\n----";
        NSString *data20 = @"魔法陣\n魔法陣（一般）\nb20\n1000,2000,30,5,30,30,0\n500,500,0,0,0,0,0,0,0,0,0\n0,1,0,id,id\nbc20.png,bcb20.png\n----\n----";
        NSString *data21 = @"伐採所\n伐採所（一般）\nb21\n1000,1000,20,2,0,0,0\n200,0,0,0,0,0,50,0,0,0,0\n0,1,1,id,id\nbc21.png,bcb21.png\n----\n----";
        NSString *data22 = @"農家\n農家（一般）\nb22\n1000,1000,20,2,0,0,0\n300,0,0,0,0,0,0,50,0,0,0\n0,1,0,id,id\nbc22.png,bcb22.png\n----\n----";
        NSString *data23 = @"市場\n市場（一般）\nb23\n1000,1000,20,2,0,0,0\n400,0,0,0,0,0,0,0,50,0,0\n0,1,0,id,id\nbc23.png,bcb23.png\n----\n----";
        
        for (int i=0; i<chipNumb; i++) {
        NSString *fdata = @"data/BuildChip/BCdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", i+1];
            
            switch (i) {
                case 0:
                    [data1 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 1:
                    [data2 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 2:
                    [data3 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 3:
                    [data4 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 4:
                    [data5 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 5:
                    [data6 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 6:
                    [data7 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 7:
                    [data8 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 8:
                    [data9 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 9:
                    [data10 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 10:
                    [data11 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 11:
                    [data12 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 12:
                    [data13 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 13:
                    [data14 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 14:
                    [data15 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 15:
                    [data16 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 16:
                    [data17 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 17:
                    [data18 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 18:
                    [data19 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 19:
                    [data20 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 20:
                    [data21 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 21:
                    [data22 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;
                case 22:
                    [data23 writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    break;

                default:
                    break;
            }
        
        }
        
        NSString *fileData = @"";
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", (int)chipNumb]] stringByAppendingString:@"\n"];
        
        NSString *path = @"data/BuildChip/preset.txt";
        [fileData writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    if(InitialData){
        NSString *fileData = @"";
        NSString *path = @"data/BuildChip/preset.txt";
        fileData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        fileDataArray = [fileData componentsSeparatedByString:@"\n"];
        
        chipNumb = [[fileDataArray objectAtIndex:0] intValue];
    }
    
    for (int j=0; j<chipNumb; j++) {
        NSString *fdata = @"data/BuildChip/BCdata";
        
        fdata = [fdata stringByAppendingFormat:@"%d.txt", j+1];
        
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    
            BC[j].name = [[fileDataArray objectAtIndex:0] retain];
            BC[j].nameR = [[fileDataArray objectAtIndex:1] retain];
            BC[j].nameID = [[fileDataArray objectAtIndex:2] retain];
        
            NSArray *items = [[fileDataArray objectAtIndex:3] componentsSeparatedByString:@","];
        
            BC[j].S_M.HP = [[items objectAtIndex:0] intValue];
            BC[j].S_M.WT = [[items objectAtIndex:1] intValue];
            BC[j].dmgfix = [[items objectAtIndex:2] intValue];
            BC[j].defLv = [[items objectAtIndex:3] intValue];
            BC[j].recHP = [[items objectAtIndex:4] intValue];
            BC[j].recMP = [[items objectAtIndex:5] intValue];
            BC[j].recEN = [[items objectAtIndex:6] intValue];
            
            items = [[fileDataArray objectAtIndex:4] componentsSeparatedByString:@","];
            
            BC[j].Csupply = [[items objectAtIndex:0] intValue];
            BC[j].Cfood = [[items objectAtIndex:1] intValue];
            BC[j].Cmoney = [[items objectAtIndex:2] intValue];
            BC[j].CsupplyNext = [[items objectAtIndex:3] intValue];
            BC[j].CfoodNext = [[items objectAtIndex:4] intValue];
            BC[j].CmoneyNext = [[items objectAtIndex:5] intValue];
            BC[j].Esupply = [[items objectAtIndex:6] intValue];
            BC[j].Efood = [[items objectAtIndex:7] intValue];
            BC[j].Emoney = [[items objectAtIndex:8] intValue];
            BC[j].S_M.WTE = [[items objectAtIndex:9] intValue];
            BC[j].S_M.WTN = [[items objectAtIndex:10] intValue];
            
            items = [[fileDataArray objectAtIndex:5] componentsSeparatedByString:@","];
            
            BC[j].inroadsFlag = [[items objectAtIndex:0] intValue];
            BC[j].capture = [[items objectAtIndex:1] intValue];
            BC[j].type = [[items objectAtIndex:2] intValue];
            BC[j].linkDest = [[items objectAtIndex:3] retain];
            BC[j].linkNext = [[items objectAtIndex:4] retain];
            
            items = [[fileDataArray objectAtIndex:6] componentsSeparatedByString:@","];
            
            BC[j].iName = [[items objectAtIndex:0] retain];
            BC[j].iNameb = [[items objectAtIndex:1] retain];
        
            //NSLog(@"iName = %@\n", BC[j].iName);
        
            NSString *imgName = @"bc";
            imgName = [imgName stringByAppendingFormat:@"%d", j+1];
            BC[j].img = [[NSImage imageNamed:imgName] retain];
            
            imgName = [NSString stringWithFormat:@"bcb"];
            imgName = [imgName stringByAppendingFormat:@"%d", j+1];
            BC[j].imgb = [[NSImage imageNamed:imgName] retain];
            
            
            NSString *imagePath = @"data/BuildChip/img/bc";
            imagePath = [imagePath stringByAppendingFormat:@"%d", j+1];
            NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
            
            if(imgData)
                BC[j].img = [[[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]] retain];
            
            imagePath = [NSString stringWithFormat:@"data/BuildChip/img/bcb"];
            imagePath = [imagePath stringByAppendingFormat:@"%d", j+1];
            imgData = [NSData dataWithContentsOfFile:imagePath];
            
            if(imgData)
                BC[j].imgb = [[[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]] retain];
            
            //items = [[fileDataArray objectAtIndex:7] componentsSeparatedByString:@","];
            int omanko = 0;
            for(int k = 8;k < [fileDataArray count];k++){
                NSString *str = [fileDataArray objectAtIndex:k];
                NSRange rangeSearch;
                NSArray *rangeArray;
                static int cnt = 0;
                rangeSearch = [str rangeOfString:@"----"];
                rangeArray = [str componentsSeparatedByString:@","];
                
                if (rangeSearch.location != NSNotFound) {
                    cnt = 0;
                    //UNITCHIP *UCR = Rtop->U;
                    if(omanko != 0) BC[j].R = Rtop;
                    break;
                
                }else{
                    if(cnt == 0) {
                        BC[j].R = (RESEARCH*)malloc(sizeof(RESEARCH));
                    }
                    BC[j].R->type = [[rangeArray objectAtIndex:0] intValue];
                    BC[j].R->numb = [[rangeArray objectAtIndex:1] intValue];
                    BC[j].R->Lv = [[rangeArray objectAtIndex:2] intValue];
                    
                    if(BC[j].R->type == 1) {
                        BC[j].R->U = &UC[BC[j].R->numb];
                        BC[j].R->R = NULL;
                        BC[j].R->O = NULL;
                    }
                    if(BC[j].R->type == 2){
                        BC[j].R->U = NULL;
                        BC[j].R->R = NULL;
                        BC[j].R->O = NULL;
                    }
                    if(BC[j].R->type == 3){
                        BC[j].R->U = NULL;
                        BC[j].R->R = NULL;
                        BC[j].R->O = NULL;
                    }
                    
                    BC[j].R->next = (RESEARCH*)malloc(sizeof(RESEARCH));
                    if(cnt == 0) Rtop = BC[j].R;
                    cnt++;
                    NSString *str2 = [fileDataArray objectAtIndex:k+1];
                    NSRange rangeSearch2 = [str2 rangeOfString:@"----"];
                    if(rangeSearch2.location != NSNotFound){
                        BC[j].R->next = NULL;
                    }else{
                        BC[j].R = BC[j].R->next;
                    }
                }
                omanko++;
            }
        BC[j].S_M.name = [BC[j].name retain];
        BC[j].S_C = BC[j].S_M;
    }
    
    
    
    BuildChipNum = (int)chipNumb;

}

-(void)initBuildChipList{

    
    buildChipListMA = [NSMutableArray new];
    
    
    
    
    for(int i = 0;i < chipNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        
        if(!BC[i].nameID){
            BC[i].name = [NSString stringWithFormat:@"新規建物"];
            BC[i].name = [BC[i].name stringByAppendingFormat:@"%d",i+1];
            BC[i].nameID = @"bc";
            BC[i].nameID = [BC[i].nameID stringByAppendingFormat:@"%d",i+1];
            BC[i].nameR = @"新規建物";
            BC[i].nameR = [BC[i].nameR stringByAppendingFormat:@"%d",i+1];
            BC[i].iName = @"bc";
            BC[i].iName = [BC[i].iName stringByAppendingFormat:@"%d",i+1];
            BC[i].iNameb = @"bcb";
            BC[i].iNameb = [BC[i].iNameb stringByAppendingFormat:@"%d",i+1];
        }
        
        [dict setValue:BC[i].img forKey:@"img"];
        [dict setValue:BC[i].imgb forKey:@"imgBig"];
        [dict setValue:[NSString stringWithFormat:@"%@", BC[i].name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d", BC[i].S_M.HP] forKey:@"HP"];
        [dict setValue:[NSString stringWithFormat:@"%d", BC[i].S_M.WT] forKey:@"WT"];
        [dict setValue:[NSString stringWithFormat:@"%d", BC[i].dmgfix] forKey:@"dmgfix"];
        [dict setValue:[NSString stringWithFormat:@"%d", BC[i].defLv] forKey:@"defLv"];
        [self willChangeValueForKey:@"buildChipListMA"];
        [buildChipListMA addObject:dict];
        [self didChangeValueForKey:@"buildChipListMA"];
    }
    
    [self saveData];
}

-(void)savePreset{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];

    NSString *fileData = @"";
    fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", (int)chipNumb]] stringByAppendingString:@"\n"];
    
    NSString *path = @"data/BuildChip/preset.txt";
    [fileData writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(void)saveData{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    for (int i = 0;i < chipNumb;i++) {
        NSString *fileData = @"";
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", BC[i].name]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", BC[i].nameR]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", BC[i].nameID]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].S_M.HP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].S_M.WT]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].dmgfix]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].defLv]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].recHP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].recMP]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].recEN]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].Csupply]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].Cfood]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].Cmoney]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].CsupplyNext]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].CfoodNext]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].CmoneyNext]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].Esupply]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].Efood]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].Emoney]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].S_M.WTE]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].S_M.WTN]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].inroadsFlag]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].capture]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].type]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", BC[i].linkDest]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", BC[i].linkNext]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", BC[i].iName]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", BC[i].iNameb]] stringByAppendingString:@"\n"];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"----"]] stringByAppendingString:@"\n"];
        
        NSData *f2Data = [BC[i].img TIFFRepresentation];
        NSBitmapImageRep *brep = [NSBitmapImageRep imageRepWithData:f2Data];
        f2Data = [brep representationUsingType:NSPNGFileType properties:nil];
        
        NSString *bcPath = @"data/BuildChip/img/bc";
        bcPath = [bcPath stringByAppendingFormat:@"%d", i + 1];
        
        [f2Data writeToFile:bcPath atomically:YES];
        
        f2Data = [BC[i].imgb TIFFRepresentation];
        brep = [NSBitmapImageRep imageRepWithData:f2Data];
        f2Data = [brep representationUsingType:NSPNGFileType properties:nil];
        
        bcPath = @"data/BuildChip/img/bcb";
        bcPath = [bcPath stringByAppendingFormat:@"%d", i + 1];
        
        [f2Data writeToFile:bcPath atomically:YES];
        
        RESEARCH *rTop = BC[i].R;
        while(BC[i].R){
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].R->type]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].R->numb]]
                        stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", BC[i].R->Lv]]
                        stringByAppendingString:@"\n"];
            BC[i].R = BC[i].R->next;
        }BC[i].R = rTop;
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"----"]];
        if(i != chipNumb - 1) fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        
        NSString *pathBCP = @"data/BuildChip/BCdata";
        pathBCP = [pathBCP stringByAppendingFormat:@"%d.txt", i + 1];
        [fileData writeToFile:pathBCP atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    
    }
    
}

-(IBAction)registBCL:(id)sender{
    [TFchipNumb setIntValue:(int)chipNumb];
    [BCLregisterPanel makeKeyAndOrderFront:nil];
}
-(IBAction)registSaveBCL:(id)sender{
    chipNumb = [TFchipNumb intValue];
    if(chipNumb > 128) chipNumb = 128;
    BuildChipMax = (int)chipNumb/25+1;
    
    [self savePreset];
    [self initBuildChipList];
    [self initFileDirectory];
    [BCLregisterPanel close];
}
-(IBAction)registCancelBCL:(id)sender{
    [BCLregisterPanel close];
}

-(IBAction)researchListUnitInsert:(id)sender{

    RLunitNumb = (int)[PUunit indexOfSelectedItem] - 1;
    
    if(RLunitNumb < 0) return;
    
    int R = RLunitNumb;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"新規研究"] forKey:@"name"];
    
    Rtop = BC[clickIndex].R;
    
    if(RLrow < 0){
        BC[clickIndex].R = Rtop;
        if([researchListMA count] == 0){
            BC[clickIndex].R = (RESEARCH*)malloc(sizeof(RESEARCH));
            //INIT 処理
            BC[clickIndex].R->type = 1;
            BC[clickIndex].R->numb = R;
            BC[clickIndex].R->U = &UC[R];
            BC[clickIndex].R->O = NULL;
            BC[clickIndex].R->R = NULL;
            BC[clickIndex].R->next = NULL;
            Rtop = BC[R].R;
        }else{
            while(BC[clickIndex].R->next) BC[clickIndex].R = BC[clickIndex].R->next;
            BC[clickIndex].R->next = (RESEARCH*)malloc(sizeof(RESEARCH));
            BC[clickIndex].R = BC[clickIndex].R->next;
            //INIT 処理
            BC[clickIndex].R->type = 1;
            BC[clickIndex].R->numb = R;
            BC[clickIndex].R->U = &UC[R];
            BC[clickIndex].R->O = NULL;
            BC[clickIndex].R->R = NULL;
            //UNITCHIP *uTest = (UNITCHIP*)BC[clickIndex].R->U;
            BC[clickIndex].R->next = NULL;
            BC[clickIndex].R = Rtop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%@", UC[R].name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"資%d 食%d 金%d", UC[R].S_M.cSupply, UC[R].S_M.cFood, UC[R].S_M.cMoney] forKey:@"cost"];
        [dict setValue:[NSString stringWithFormat:@"%d", UC[R].S_M.cWT] forKey:@"WT"];
        
        [self willChangeValueForKey:@"researchListMA"];
        [researchListMA insertObject:dict atIndex:[researchListMA count]];
        [self didChangeValueForKey:@"researchListMA"];
        [researchListAC setSelectionIndex:999];
        RLrow = -1;
    }else{
        BC[clickIndex].R = Rtop;
        if([researchListMA count] == 0){
            BC[clickIndex].R = (RESEARCH*)malloc(sizeof(RESEARCH));
            //INIT 処理
            BC[clickIndex].R->type = 1;
            BC[clickIndex].R->numb = R;
            BC[clickIndex].R->U = &UC[R];
            BC[clickIndex].R->O = NULL;
            BC[clickIndex].R->R = NULL;
            BC[clickIndex].R->next = NULL;
            Rtop = BC[clickIndex].R;
        }else if(RLrow > 0){
            for (int i = 0; i < RLrow-1;i++)
                BC[clickIndex].R = BC[clickIndex].R->next;
            RESEARCH *tmp = (RESEARCH*)malloc(sizeof(RESEARCH));
            *tmp = *BC[clickIndex].R->next;
            BC[clickIndex].R->next = (RESEARCH*)malloc(sizeof(RESEARCH));
            BC[clickIndex].R->next->next = tmp;
            BC[clickIndex].R = BC[clickIndex].R->next;
            //INIT 処理
            BC[clickIndex].R->type = 1;
            BC[clickIndex].R->numb = R;
            BC[clickIndex].R->U = &UC[R];
            BC[clickIndex].R->O = NULL;
            BC[clickIndex].R->R = NULL;
            BC[clickIndex].R = Rtop;
        }else{
            RESEARCH *tmp = (RESEARCH*)malloc(sizeof(RESEARCH));
            tmp->next = BC[clickIndex].R;
            // INIT 処理[self InitAttack:tmp];
            tmp->type = 1;
            tmp->numb = R;
            tmp->U = &UC[R];
            tmp->O = NULL;
            tmp->R = NULL;
            Rtop = tmp;
            BC[clickIndex].R = Rtop;
        }
    
        [dict setValue:[NSString stringWithFormat:@"%@", UC[R].name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"資%d 食%d 金%d", UC[R].S_M.cSupply, UC[R].S_M.cFood, UC[R].S_M.cMoney] forKey:@"cost"];
        [dict setValue:[NSString stringWithFormat:@"%d", UC[R].S_M.cWT] forKey:@"WT"];
        
        [self willChangeValueForKey:@"researchListMA"];
        [researchListMA insertObject:dict atIndex:RLrow];
        [self didChangeValueForKey:@"researchListMA"];
        [researchListAC setSelectionIndex:RLrow];
    }

}

-(IBAction)researchListResearchInsert:(id)sender{

}

-(IBAction)researchListUnionInsert:(id)sender{

}

-(IBAction)researchListDelete:(id)sender{
    
    Rtop = BC[clickIndex].R;
    
    if(RLrow == -1){
        RLrow = (int)[researchListMA count] - 1;
    }
    
    if([researchListMA count] > 0){
    
    if(RLrow == 0){
        BC[clickIndex].R = Rtop;
        BC[clickIndex].R = BC[clickIndex].R->next;
        Rtop = BC[clickIndex].R;
    }else if(RLrow == [researchListMA count] - 1){
        BC[clickIndex].R = Rtop;
        while(BC[clickIndex].R->next->next){
            BC[clickIndex].R = BC[clickIndex].R->next;
        }
        BC[clickIndex].R->next = NULL;
    }else{
        BC[clickIndex].R = Rtop;
        for (int i = 0; i < RLrow - 1;i++)
            BC[clickIndex].R = BC[clickIndex].R->next;
        BC[clickIndex].R->next = BC[clickIndex].R->next->next;
    }
    
    [self willChangeValueForKey:@"researchListMA"];
    [researchListMA removeObjectAtIndex:RLrow];
    [self didChangeValueForKey:@"researchListMA"];
    [researchListAC setSelectionIndex:RLrow-1];
    if(RLrow < 0) [researchListAC setSelectionIndex:[researchListMA count]-1];
    if(RLrow == 0) [researchListAC setSelectionIndex:0];
    if(RLrow > 0) RLrow--;
    }
    BC[clickIndex].R = Rtop;

}

-(void)initResearchList{
    
    [self willChangeValueForKey:@"researchListMA"];
    [researchListMA removeAllObjects];
    [self didChangeValueForKey:@"researchListMA"];
    
    RESEARCH *rTop = BC[clickIndex].R;
    while(BC[clickIndex].R){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        UNITCHIP *uc = BC[clickIndex].R->U;
        
        [dict setValue:[NSString stringWithFormat:@"%@", uc->name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d", uc->S_M.cWT] forKey:@"WT"];
        [dict setValue:[NSString stringWithFormat:@"資%d 食%d 金%d", uc->S_M.cSupply, uc->S_M.cFood, uc->S_M.cMoney] forKey:@"cost"];
        [self willChangeValueForKey:@"researchListMA"];
        [researchListMA addObject:dict];
        [self didChangeValueForKey:@"researchListMA"];
        
        BC[clickIndex].R = BC[clickIndex].R->next;
    }BC[clickIndex].R = rTop;
    
    
}

@end
