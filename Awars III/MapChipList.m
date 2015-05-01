//
//  MapChipList.m
//  Awars III
//
//  Created by Killery on 2012/12/15.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import "MapChipList.h"

@implementation MapChipList
- (void)dealloc
{
    [super dealloc];
}

- (NSMutableArray*)mapChipListMA{
    return mapChipListMA;
}
-(IBAction)submitMCL:(id)sender{
    [MCLPanel close];
}
-(void)awakeFromNib{
    
    [mapChipListTV setTarget:self];
    [mapChipListTV setDoubleAction:@selector(doubleClickMCL:)];
}
-(id)init{
    [super init];
    
    if (self) {
        MCLtime  = [NSTimer
                 scheduledTimerWithTimeInterval:0.05f
                 target:self
                 selector:@selector(EventLoopMCL:)
                 userInfo:nil
                 repeats:YES
                 ];
        [self initFileDirectory];
        [self initMapChipList];
        MapChipMax = (int)chipNumb/25+1;
    }

    return self;
}

-(void)EventLoopMCL:(NSTimer*)time{

}
NSInteger clickIndex;
-(void)doubleClickMCL:(id)sender{
    clickIndex = [mapChipListTV clickedRow];
    if( clickIndex>=0 ){
        
        [TFname setStringValue:MC[clickIndex].name];
        [TFfix setIntValue:MC[clickIndex].dmgfix];
        [TFriku setIntValue:MC[clickIndex].riku];
        [TFumi setIntValue:MC[clickIndex].umi];
        [TFchu setIntValue:MC[clickIndex].chu];
        [TFsora setIntValue:MC[clickIndex].sora];
        [TFtype selectItemAtIndex:MC[clickIndex].type];
        [MC[clickIndex].img setFlipped:NO];
        [IVimg setImage:MC[clickIndex].img];
    }
    
    MCLDpoint.x = [MCLPanel frame].origin.x + 100;
    MCLDpoint.y = [MCLPanel frame].origin.y + 200;
    [MCLDetailPanel setFrameOrigin:MCLDpoint];
     [MCLDetailPanel makeKeyAndOrderFront:nil];
}

-(IBAction)saveMCL:(id)sender{
    MC[clickIndex].name = [[TFname stringValue] retain];
    MC[clickIndex].dmgfix = [TFfix intValue];
    MC[clickIndex].riku = [TFriku intValue];
    MC[clickIndex].umi = [TFumi intValue];
    MC[clickIndex].chu = [TFchu intValue];
    MC[clickIndex].sora = [TFsora intValue];
    MC[clickIndex].type = (int)[TFtype indexOfSelectedItem];
    MC[clickIndex].img = [[IVimg image] retain];
    
    
    [mapChipListAC setValue:MC[clickIndex].img forKeyPath:@"selection.img"];
    [mapChipListAC setValue:[NSString stringWithFormat:@"%@", MC[clickIndex].name] forKeyPath:@"selection.name"];
    [mapChipListAC setValue:[NSString stringWithFormat:@"%d", MC[clickIndex].dmgfix] forKeyPath:@"selection.dmgfix"];
    [mapChipListAC setValue:[NSString stringWithFormat:@"%d", MC[clickIndex].riku] forKeyPath:@"selection.riku"];
    [mapChipListAC setValue:[NSString stringWithFormat:@"%d", MC[clickIndex].umi] forKeyPath:@"selection.umi"];
    [mapChipListAC setValue:[NSString stringWithFormat:@"%d", MC[clickIndex].chu] forKeyPath:@"selection.chu"];
    [mapChipListAC setValue:[NSString stringWithFormat:@"%d", MC[clickIndex].sora] forKeyPath:@"selection.sora"];
    switch (MC[clickIndex].type) {
        case 0:
            [mapChipListAC setValue:[NSString stringWithFormat:@"安定な地形（建物建設可）"] forKeyPath:@"selection.memo"];
            break;
        case 1:
            [mapChipListAC setValue:[NSString stringWithFormat:@"不安定な地形（建物建設不可）"] forKeyPath:@"selection.memo"];
            break;
        case 2:
            [mapChipListAC setValue:[NSString stringWithFormat:@"山竹林（資源回収可）"] forKeyPath:@"selection.memo"];
            break;
        case 3:
            [mapChipListAC setValue:[NSString stringWithFormat:@"水場（炎無効化）"] forKeyPath:@"selection.memo"];
            break;
        case 4:
            [mapChipListAC setValue:[NSString stringWithFormat:@"浅瀬（造船可）"] forKeyPath:@"selection.memo"];
            break;
        case 5:
            [mapChipListAC setValue:[NSString stringWithFormat:@"建物内部（建設不可）"] forKeyPath:@"selection.memo"];
            break;
            
        default:
            break;
    }

    [self saveData];
    [MCLDetailPanel close];
}
-(IBAction)cancelMCL:(id)sender{
    [MCLDetailPanel close];
}

-(void)initFileDirectory{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/MapChip/preset.txt"];
    NSString *pathMC = @"data/MapChip/img";
    NSString *pathBC = @"data/BuildChip/img";
    NSString *pathUC = @"data/UnitChip/img";
    NSString *pathDATA = @"data/MapChip/preset.txt";
    NSString *pathMCP = @"data/MapChip/preset.txt";
    NSString *fileData = nil;
    if(!InitialData){
        
        [[NSFileManager defaultManager] createDirectoryAtPath:pathMC withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:pathBC withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createDirectoryAtPath:pathUC withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathMCP contents:nil attributes:nil];
        
        NSString *data1 = @"草原,20,3,3,3,3,mc1.png,0";
        NSString *data2 = @"荒野,15,3,3,3,3,mc2.png,0";
        NSString *data3 = @"砂地,10,4,4,3,3,mc3.png,0";
        NSString *data4 = @"道,20,2,2,3,3,mc4.png,0";
        NSString *data5 = @"道路,20,2,2,3,3,mc5.png,0";
        NSString *data6 = @"林,30,4,4,3,3,mc6.png,2";
        NSString *data7 = @"森,40,5,5,3,3,mc7.png,2";
        NSString *data8 = @"山,50,6,6,3,3,mc8.png,2";
        NSString *data9 = @"高山,60,0,0,0,3,mc9.png,2";
        NSString *data10 = @"橋,20,3,3,3,3,mc10.png,0";
        NSString *data11 = @"川,10,7,3,3,3,mc11.png,3";
        NSString *data12 = @"池,10,8,3,3,3,mc12.png,3";
        NSString *data13 = @"湖,20,9,3,3,3,mc13.png,3";
        NSString *data14 = @"沼,10,6,3,3,3,mc14.png,1";
        NSString *data15 = @"浅瀬,10,6,3,3,3,mc15.png,4";
        NSString *data16 = @"深海,60,0,2,3,3,mc16.png,3";
        NSString *data17 = @"床,20,3,3,4,4,mc17.png,5";
        NSString *data18 = @"壁,70,0,0,0,0,mc18.png,1";
        NSString *data19 = @"穴,0,0,0,3,3,mc19.png,1";
        NSString *data20 = @"宇宙,20,3,3,3,3,mc20.png,1";
        NSString *data21 = @"暗礁,40,6,6,6,6,mc21.png,1";
        NSString *data22 = @"クレーター,10,5,5,3,3,mc22.png,1";
        
        fileData = [[data1 stringByAppendingString:@"\n"] stringByAppendingString:data2];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data3];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data4];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data5];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data6];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data7];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data8];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data9];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data10];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data11];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data12];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data13];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data14];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data15];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data16];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data17];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data18];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data19];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data20];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data21];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data22];
        
        [fileData writeToFile:pathDATA atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
        fileData = [NSString stringWithContentsOfFile:pathDATA encoding:NSUTF8StringEncoding error:nil];
        fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    
        chipNumb = [fileDataArray count];
        for(int i=0;i < [fileDataArray count];i++){
            NSArray *items = [[fileDataArray objectAtIndex:i] componentsSeparatedByString:@","];
            
            MC[i].name = [[items objectAtIndex:0] retain];
            MC[i].dmgfix = [[items objectAtIndex:1] intValue];
            MC[i].riku = [[items objectAtIndex:2] intValue];
            MC[i].umi = [[items objectAtIndex:3] intValue];
            MC[i].chu = [[items objectAtIndex:4] intValue];
            MC[i].sora = [[items objectAtIndex:5] intValue];
            MC[i].iName = [[items objectAtIndex:6] retain];
            MC[i].type = [[items objectAtIndex:7] intValue];
            
            NSString *imgName = @"mc";
            imgName = [imgName stringByAppendingFormat:@"%d", i+1];
            MC[i].img = [[NSImage imageNamed:imgName] retain];
            [MC[i].img setFlipped:NO];
            
            NSString *imagePath = @"data/MapChip/img/";
            imagePath = [imagePath stringByAppendingString:MC[i].iName];
            
            NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
            
            if(imgData)
            MC[i].img = [[[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]] retain];
            
            
        }
        
        
    
}

-(void)initMapChipList{
    mapChipListMA = [NSMutableArray new];

    for(int i = 0;i < chipNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        if(MC[i].name == NULL) MC[i].name = @"新規チップ";
        
        NSString *imgName = @"mc";
        imgName = [imgName stringByAppendingFormat:@"%d", i+1];
        MC[i].iName = [imgName retain];
        MC[i].img = [[NSImage imageNamed:imgName] retain];
        
        NSString *imagePath = @"data/MapChip/img/mc";
        imagePath = [imagePath stringByAppendingFormat:@"%d", i+1];
        NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
        
        if(imgData)
            MC[i].img = [[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]];
        
        [dict setValue:MC[i].img forKey:@"img"];
        [dict setValue:[NSString stringWithFormat:@"%@", MC[i].name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d", MC[i].dmgfix] forKey:@"dmgfix"];
        [dict setValue:[NSString stringWithFormat:@"%d", MC[i].riku] forKey:@"riku"];
        [dict setValue:[NSString stringWithFormat:@"%d", MC[i].umi] forKey:@"umi"];
        [dict setValue:[NSString stringWithFormat:@"%d", MC[i].chu] forKey:@"chu"];
        [dict setValue:[NSString stringWithFormat:@"%d", MC[i].sora] forKey:@"sora"];
        
        switch (MC[i].type) {
            case 0:
                [dict setValue:[NSString stringWithFormat:@"安定な地形（建物建設可）"] forKey:@"memo"];
                break;
            case 1:
                [dict setValue:[NSString stringWithFormat:@"不安定な地形（建物建設不可）"] forKey:@"memo"];
                break;
            case 2:
                [dict setValue:[NSString stringWithFormat:@"山竹林（資源回収可）"] forKey:@"memo"];
                break;
            case 3:
                [dict setValue:[NSString stringWithFormat:@"水場（炎無効化）"] forKey:@"memo"];
                break;
            case 4:
                [dict setValue:[NSString stringWithFormat:@"浅瀬（造船可）"] forKey:@"memo"];
                break;
            case 5:
                [dict setValue:[NSString stringWithFormat:@"建物内部（建設不可）"] forKey:@"memo"];
                break;
                
            default:
                break;
        }
        
        [self willChangeValueForKey:@"mapChipListMA"];
        [mapChipListMA addObject:dict];
        [self didChangeValueForKey:@"mapChipListMA"];
    }


}

-(void)saveData{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    //NSString *pathMC = @"data/MapChip/img";
    NSString *pathMCP = @"data/MapChip/preset.txt";
    NSString *fileData = @"";
    
    for (int i = 0;i < chipNumb;i++) {
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", MC[i].name]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", MC[i].dmgfix]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", MC[i].riku]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", MC[i].umi]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", MC[i].chu]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", MC[i].sora]] stringByAppendingString:@","];
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", MC[i].iName]] stringByAppendingString:@","];
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%d", MC[i].type]];
        
        NSData *f2Data = [MC[i].img TIFFRepresentation];
        NSBitmapImageRep *brep = [NSBitmapImageRep imageRepWithData:f2Data];
        f2Data = [brep representationUsingType:NSPNGFileType properties:nil];
        
        NSString *bcPath = @"data/MapChip/img/mc";
        bcPath = [bcPath stringByAppendingFormat:@"%d", i + 1];
        
        [f2Data writeToFile:bcPath atomically:YES];
        
        
        
        if(i != chipNumb - 1) fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];

    }
    
    [fileData writeToFile:pathMCP atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

-(IBAction)registMCL:(id)sender{
    [TFchipNumb setIntValue:(int)chipNumb];
    [MCLregistPanel makeKeyAndOrderFront:nil];
}

-(IBAction)registSaveMCL:(id)sender{
    chipNumb = [TFchipNumb intValue];
    MapChipMax = (int)chipNumb/25+1;
    [self initMapChipList];
    [self saveData];
    [MCLregistPanel close];
}
-(IBAction)registCancelMCL:(id)sender{
    [MCLregistPanel close];
}


@end
