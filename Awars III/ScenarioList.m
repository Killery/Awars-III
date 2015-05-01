//
//  SenarioList.m
//  Awars III
//
//  Created by Killery on 2013/01/09.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "ScenarioList.h"

@implementation ScenarioList
-(IBAction)startButton:(id)sender{
    [SLPanel close];
    [NSApp stopModal];
}
-(IBAction)backButton:(id)sender{
    [SLPanel close];
    [NSApp stopModal];
}

-(IBAction)windowMove:(id)sender{

}

-(void)awakeFromNib{
    [IVscene setImage:SC[1].img];
    [IVscene setImageScaling:NSScaleToFit];
    [PUBscenario removeAllItems];
    
    for(int i = 0;i < SCarray;i++){
        [PUBscenario addItemWithTitle:SC[i+1].name];
    }
    
    [scenarioListTV setTarget:self];
    [scenarioListTV setDoubleAction:@selector(doubleClickSL:)];
}

-(void)doubleClickSL:(id)sender{
    scenarioNumb = (int)[scenarioListTV selectedRow];
    storyNumb = (int)[PUBscenario indexOfSelectedItem] + 1;
    
    startES = true;
    StringText *stringText = [[StringText alloc] init];
    [stringText InitStringList];
    MFselectedRow = scenarioNumb + 1;
    [SLPanel close];
    [NSApp stopModal];
    NSPoint windowPoint;
    windowPoint.x = [titleWindow frame].origin.x;
    windowPoint.y = [titleWindow frame].origin.y;
    [eventSceneWindow setFrameOrigin:windowPoint];
    [eventSceneWindow makeKeyAndOrderFront:nil];
    [titleWindow close];
    evActive = true;
}

-(id)init{
    
    if (self) {
        [self initFileDirectory];
        [self initScenarioList];
        time  = [NSTimer
                 scheduledTimerWithTimeInterval:0.05f
                 target:self
                 selector:@selector(EventLoop:)
                 userInfo:nil
                 repeats:YES
                 ];
    }
    
    return self;
}

-(void)EventLoop:(NSTimer*)time{
    SLPpoint.x = [titleWindow frame].origin.x + 100;
    SLPpoint.y = [titleWindow frame].origin.y + 100;
    [SLPanel setFrameOrigin:SLPpoint];
}


-(void)initFileDirectory{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/Scenario/preset.txt"];
    NSString *pathDATA = @"data/Scenario/preset.txt";
    NSString *pathFOLDER = @"data/Scenario/img";
    
    NSString *fileData = nil;
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathFOLDER withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA contents:nil attributes:nil];
        
        NSString *data1 = @"###キリの野望###siKillery";
        NSString *data2 = @"Megalomania of Killery 01##sl1.txt##sl2.txt##MD01.txt";
        NSString *data3 = @"Megalomania of Killery 02##sl2.txt##etna.txt##MD02.txt";
        NSString *data4 = @"Megalomania of Killery 03##sl1.txt##sl2.txt##MD03.txt";
        NSString *data5 = @"Megalomania of Killery 04##sl1.txt##etna.txt##MD01.txt";
        NSString *data6 = @"Megalomania of Killery 05##sl1.txt##etna.txt##MD01.txt";
        NSString *data7 = @"Megalomania of Killery 06##sl1.txt##etna.txt##MD01.txt";
        NSString *data8 = @"Megalomania of Killery 07##sl1.txt##etna.txt##MD01.txt";
        NSString *data9 = @"Megalomania of Killery 08##sl1.txt##etna.txt##MD01.txt";
        NSString *data10 = @"Megalomania of Killery 09##sl1.txt##etna.txt##MD01.txt";
        NSString *data11 = @"Megalomania of Killery 10##sl1.txt##etna.txt##MD01.txt";
        NSString *data12 = @"Megalomania of Killery 11##sl1.txt##etna.txt##MD01.txt";
        NSString *data13 = @"Megalomania of Killery 12##sl1.txt##etna.txt##MD01.txt";
        NSString *data14 = @"Megalomania of Killery 13##sl1.txt##etna.txt##MD01.txt";
        NSString *data15 = @"Megalomania of Killery 14##sl1.txt##etna.txt##MD01.txt";
        NSString *data16 = @"Megalomania of Killery 15##sl1.txt##etna.txt##MD01.txt";
        NSString *data17 = @"Megalomania of Killery 16##sl1.txt##etna.txt##MD01.txt";
        NSString *data18 = @"Megalomania of Killery 17##sl1.txt##etna.txt##MD01.txt";
        NSString *data19 = @"Megalomania of Killery 18##sl1.txt##etna.txt##MD01.txt";
        NSString *data20 = @"Megalomania of Killery 19##sl1.txt##etna.txt##MD01.txt";
        NSString *data21 = @"Megalomania of Killery 20##sl1.txt##etna.txt##MD01.txt";
        NSString *data22 = @"Megalomania of Killery 21##sl1.txt##etna.txt##MD01.txt";
        NSString *data23 = @"Megalomania of Killery 22##sl1.txt##etna.txt##MD01.txt";
        NSString *data24 = @"Megalomania of Killery 23##sl1.txt##etna.txt##MD01.txt";
        NSString *data25 = @"Megalomania of Killery 24##sl1.txt##etna.txt##MD01.txt";
        NSString *data26 = @"###フリーマップ Awars III###siFreeMap";
        NSString *data27 = @"01 ウィロークリーク##sl1.txt##etna.txt##MD01.txt";
        NSString *data28 = @"02 城内##sl1.txt##etna.txt##MD01.txt";
        NSString *data29 = @"03 月影の使者##sl1.txt##etna.txt##MD01.txt";
        
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
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data23];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data24];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data25];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data26];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data27];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data28];
        fileData = [[fileData stringByAppendingString:@"\n"] stringByAppendingString:data29];
        
        [fileData writeToFile:pathDATA atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    fileData = [NSString stringWithContentsOfFile:pathDATA encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    
    
    SC[0].img = [NSImage imageNamed:@"siDefault.png"];
    
    for(int i = 1;i<=[fileDataArray count];i++){
        NSString *str = [fileDataArray objectAtIndex:i-1];
        NSRange rangeSearch;
        rangeSearch = [str rangeOfString:@"###"];
        if (rangeSearch.location != NSNotFound) SCarray++;
    }
    
    for (int i = 0;i <= SCarray;i++) {
        SC[i].sName = [NSMutableArray new];
        SC[i].nameSceneStart = [NSMutableArray new];
        SC[i].nameSceneEnd = [NSMutableArray new];
        SC[i].nameMAP = [NSMutableArray new];
    }
    
    if(SCarray > 0){int aDelta = 0;
        
        for (int i = 0; i<[fileDataArray count];i++) {
            NSString *str = [fileDataArray objectAtIndex:i];
            NSRange rangeSearch;
            NSRange rangeSearch2;
            NSArray *rangeArray;
            NSArray *rangeArray2;
            
            rangeSearch = [str rangeOfString:@"###"];
            rangeSearch2 = [str rangeOfString:@"##"];
            rangeArray = [str componentsSeparatedByString:@"###"];
            rangeArray2 = [str componentsSeparatedByString:@"##"];
            if (rangeSearch.location != NSNotFound) {
                aDelta++;
                SC[aDelta].name = [[fileDataArray objectAtIndex:i] retain];
                SC[aDelta].name = [[rangeArray objectAtIndex:1] retain];
                
                if([rangeArray count] > 2){
                SC[aDelta].iName = [[rangeArray objectAtIndex:2] retain];
                    
                    
                    NSString *imagePath = @"data/Scenario/img/";
                    imagePath = [imagePath stringByAppendingString:SC[aDelta].iName];
                    NSData *imgData = [NSData dataWithContentsOfFile:imagePath];
                    
                    if(imgData)
                       SC[aDelta].img = [[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePath] readDataToEndOfFile]];
                    
                    if(!imgData){
                        SC[aDelta].img = [NSImage imageNamed:SC[aDelta].iName];
                    }
                }
            }else if(rangeSearch2.location != NSNotFound){
                [SC[aDelta].sName addObject:[[rangeArray2 objectAtIndex:0] retain]];
                [SC[aDelta].nameSceneStart addObject:[[rangeArray2 objectAtIndex:1] retain]];
                [SC[aDelta].nameSceneEnd addObject:[[rangeArray2 objectAtIndex:2] retain]];
                [SC[aDelta].nameMAP addObject:[[rangeArray2 objectAtIndex:3] retain]];
            
            }else{
                [SC[aDelta].sName addObject:[[fileDataArray objectAtIndex:i] retain]];
                
            }
            //NSLog(@"SC[%d].sName %@", aDelta, SC[aDelta].sName);
        }
    }
}

-(void)initScenarioList{
    scenarioListMA = [NSMutableArray new];
    sceneNumb = [SC[1].sName count];
    
    for(int i = 0;i < sceneNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:[SC[1].sName objectAtIndex:i] forKey:@"name"];
        [self willChangeValueForKey:@"scenarioListMA"];
        [scenarioListMA addObject:dict];
        [self didChangeValueForKey:@"scenarioListMA"];
    }
    
    
}
-(IBAction)listButton:(id)sender{
    NSInteger selectNumb = [PUBscenario indexOfSelectedItem] + 1;
    
    scenarioListMA = [NSMutableArray new];
    sceneNumb = [SC[selectNumb].sName count];
    
    [IVscene setImage:SC[selectNumb].img];
    [IVscene setImageScaling:NSScaleToFit];
    for(int i = 0;i < sceneNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:[SC[selectNumb].sName objectAtIndex:i] forKey:@"name"];
        [self willChangeValueForKey:@"scenarioListMA"];
        [scenarioListMA addObject:dict];
        [self didChangeValueForKey:@"scenarioListMA"];
    }
    
    //NSLog(@"select Numb %d", selectNumb);
}
    

@end







