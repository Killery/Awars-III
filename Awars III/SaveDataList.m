//
//  SaveDataList.m
//  Awars III
//
//  Created by Killery on 2013/01/09.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "SaveDataList.h"

@implementation SaveDataList
-(IBAction)loadButton:(id)sender{
    [SDLPanel close];
    [NSApp stopModal];
}
-(IBAction)backButton:(id)sender{
    [SDLPanel close];
    [NSApp stopModal];
}

-(void)awakeFromNib{

}

-(id)init{
    
    if (self) {
        time  = [NSTimer
                 scheduledTimerWithTimeInterval:0.05f
                 target:self
                 selector:@selector(EventLoop:)
                 userInfo:nil
                 repeats:YES
                 ];
        [self initFileDirectory];
        [self initSaveList];
        
    }
    
    return self;
}

-(void)EventLoop:(NSTimer*)time{
    SDLPpoint.x = [titleWindow frame].origin.x + 100;
    SDLPpoint.y = [titleWindow frame].origin.y + 100;
    [SDLPanel setFrameOrigin:SDLPpoint];
}

-(void)initFileDirectory{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    NSString *nscwd = [NSString stringWithCString:cwd encoding:NSUTF8StringEncoding];
    NSLog(@"%@", nscwd);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"SaveData/sav00"];
    NSString *pathDATA = @"SaveData/save00";
    NSString *pathFOLDER = @"SaveData";
    
    NSString *fileData = nil;
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathFOLDER withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA contents:nil attributes:nil];
        
        NSString *data1 = @"AwarsIIIセーブデータ";
        NSString *data2 = @"Megalomania of Killery";
                
        fileData = [[data1 stringByAppendingString:@"\n"] stringByAppendingString:data2];
     
        
        [fileData writeToFile:pathDATA atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    fileData = [NSString stringWithContentsOfFile:pathDATA encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    
    NSFileManager *fileManager;
    NSArray *Farray;
    NSString *filePath = @"SaveData";
    fileManager = [NSFileManager defaultManager];
    Farray = [fileManager contentsOfDirectoryAtPath:filePath error:nil];
    
    saveNumb = [Farray count];
    for (int i = 1; i <= saveNumb;i++) {
        SDL[i].name = [Farray objectAtIndex:i-1];
    }
    //NSLog(@"%@", Farray);
}

-(void)initSaveList{
    saveListMA = [NSMutableArray new];

    
    for(int i = 1;i <= saveNumb;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:SDL[i].name forKey:@"name"];
        [self willChangeValueForKey:@"saveListMA"];
        [saveListMA addObject:dict];
        [self didChangeValueForKey:@"saveListMA"];
    }
    
    
}


@end
