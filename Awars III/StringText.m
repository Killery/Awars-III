//
//  StringText.m
//  Awars III
//
//  Created by Killery on 2012/12/31.
//  Copyright (c) 2012年 Killery. All rights reserved.
//

#import "StringText.h"

@implementation StringText
-(void)awakeFromNib{
    /*
    [TFCname setStringValue:ST->next->name];
    [TFdialog setStringValue:ST->next->string];
     */
}
-(id)init
{
    [super init];
    if (self) {
        timer = [NSTimer
                 scheduledTimerWithTimeInterval:0.1
                 target:self selector:@selector(EventLoop:)
                 userInfo:nil repeats:YES
                 ];
        [self AddString:&ST :0];
        //[self InitStringList];
        dialogLengh = 1;
        dialogNumber = 1;
    }
    return self;
}


-(void)EventLoop:(NSTimer *)timer{
    /*
    NSInteger textMax;
    NSString *text, *tName;
    int dCount = 0;
    static float wallAlpha = 0;
    static bool wallInit = false;
    static bool wallFadeOut = false;
    ST = STtop;
    static NSString *wallName;
    
    while(dialogNumber > dCount) {dCount++;
        ST = ST->next;
    }
    
    textMax = [ST->string length];
    text = ST->string;
    tName = ST->name;
    [TFCname setStringValue:tName];
    [TFdialog setStringValue:[text substringToIndex:dialogLengh - 1]];
    [IVface setImage:ST->img];
    [IVface setImageScaling:NSScaleToFit];
    [IVwall setImage:ST->imgWall];
    [IVwall setImageScaling:NSScaleToFit];
    [IVbackGround setImageScaling:NSScaleToFit];
    
    if(![wallName isEqualToString:ST->iNameWall]){
        wallInit = false;
    }
    
    if(ST->next != NULL)
    if(mouseClicked && dialogLengh >= textMax && ![ST->iNameWall isEqualToString:ST->next->iNameWall] && ST->wallFadeOut){
        mouseClicked = false;
        wallFadeOut = true;
    }
    
    if(ST->iNameWall != NULL) wallName = [NSString stringWithString:ST->iNameWall];
    
    if(!wallInit){wallInit = true;
        if(ST->wallFadeIn){
            wallAlpha = 0;
        }else{
            wallAlpha = 1;
        }
    }
    
    if(wallAlpha < 1 && !wallFadeOut) wallAlpha += 0.1;
    if(wallAlpha > 0 && wallFadeOut) wallAlpha -= 0.1;
    
    [IVwall setAlphaValue:wallAlpha];
    
    if(wallAlpha <= 0 && wallFadeOut) {
        wallFadeOut = false;
        dialogNumber++;
        dialogLengh = 1;
    }
    
    
    if (wallAlpha >= 1) {
        
    
    if(dialogLengh < textMax) dialogLengh++;
    if(mouseClicked){mouseClicked = false;
        if(dialogNumber < dialogMax && dialogLengh == [text length]) {
                dialogNumber++;
                dialogLengh = 1;
        }else if(dialogLengh != [text length]){
            dialogLengh = (int)[text length];
        }
    }
    }
     */
    //NSLog(@"%g", wallAlpha);
}

-(STRING*)AllocSTRING{
    return (calloc(1, sizeof(STRING)));
}

-(void)InitStringList{
    
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    
    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/StringList/preset.txt"];
    NSString *pathSL = @"data/StringList/img";
    NSString *pathDATA2 = @"data/StringList/preset.txt";
    NSString *pathSLP = @"data/StringList/preset.txt";
    NSString *fileData = nil;
    
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathSL withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathSLP contents:nil attributes:nil];
        
        
        
    }
    
    
    
    
    NSString *fdata = @"data/StringList/";
    
    NSData *testInitData = [NSData dataWithContentsOfFile:@"data/StringList/sl1.txt"];
    
    NSString *testData = @"##キリー##img2\nみさき、どうしたんだ？\nこんな夜遅くに\n%%haik1%%FIO\n##みさき##img1\n私の体がほてって、今夜は眠れないの\n##キリー##img2\nどっか、具合でも悪いんじゃないのか？\n##みさき##img1\nちがうの、キリー\n##みさき##img1\nキリーに抱いてほしいの\n##キリー##img2\n抱いてほしいのって、ちょっと！\n%%haik2%%FIO\n##\n戸惑うキリーの口を\nみさきの柔らかな唇が塞いだ";
    
    
    if(!startOrEndFlag){
        if([SC[storyNumb].nameSceneStart count] > 0)
            fdata = [fdata stringByAppendingFormat:@"%@", [[SC[storyNumb].nameSceneStart objectAtIndex:scenarioNumb] retain]];
        else fdata = [[fdata stringByAppendingFormat:@"sl1.txt"] retain];
    }else{
        if([SC[storyNumb].nameSceneEnd count] > 0)
            fdata = [fdata stringByAppendingFormat:@"%@", [[SC[storyNumb].nameSceneEnd objectAtIndex:scenarioNumb] retain]];
        else fdata = [[fdata stringByAppendingFormat:@"sl2.txt"] retain];
    }
    
    
    if(!testInitData) {
        [[NSFileManager defaultManager] createFileAtPath:fdata contents:nil attributes:nil];
        [testData writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [fileData componentsSeparatedByString:@"\n"];
    
    if(!fileDataArray) {
        STtop = NULL;
        ST = NULL;
        evSTtop = NULL;
        return;
    }
    NVALUE *NVtop;
    SVALUE *SVtop;
    STtop = ST;
    evSTtop = STtop;
    dialogMax = 0;
    /*
    ST->imgWall = NULL;
    ST->iNameWall = NULL;
    ST->wallFadeIn = false;
    ST->wallFadeOut = false;
     */
    for(int i = 1;i<=[fileDataArray count];i++){
        NSString *str = [fileDataArray objectAtIndex:i-1];
        NSRange range = NSMakeRange(2, str.length - 2);
        NSRange rangeSearch;
        NSRange rangeSearch2;
        NSRange rangeSearch3;
        NSArray *rangeArray;
        NSRange rangeSearch4;
        NSArray *rangeArray2;
        NSRange rangeSearch5;
        NSArray *rangeArray3;
        NSRange rangeSearch6;
        NSArray *rangeArray4;
        NSRange rangeSearch7;
        NSArray *rangeArray5;
        NSRange rangeSearch8;
        NSArray *rangeArray6;
        NSRange rangeSearch9;
        NSArray *rangeArray7;
        bool commentSwitch = false;
        rangeSearch = [str rangeOfString:@"##"];
        rangeSearch2 = [str rangeOfString:@"####"];
        rangeSearch3 = [str rangeOfString:@"##" options:NSBackwardsSearch];
        rangeArray = [str componentsSeparatedByString:@"##"];
        rangeArray2 = [str componentsSeparatedByString:@"%%"];
        rangeSearch4 = [str rangeOfString:@"%%"];
        rangeSearch5 = [str rangeOfString:@"^^"];
        rangeArray3 = [str componentsSeparatedByString:@"^^"];
        rangeSearch6 = [str rangeOfString:@"&&"];;
        rangeArray4 = [str componentsSeparatedByString:@"&&"];
        rangeSearch7 = [str rangeOfString:@"@@"];;
        rangeArray5 = [str componentsSeparatedByString:@"@@"];
        rangeSearch8 = [str rangeOfString:@"**"];;
        rangeArray6 = [str componentsSeparatedByString:@"**"];
        rangeSearch9 = [str rangeOfString:@"≠≠"];;
        rangeArray7 = [str componentsSeparatedByString:@"≠≠"];
        if (rangeSearch2.location != NSNotFound) {commentSwitch = true;
          
        }else if (rangeSearch.location != NSNotFound) {commentSwitch = false;
            if(ST->S)
                ST->S = SVtop;
            ST->index++;
            [self AddString:&ST :ST->index];
            ST->next->iNameWall =ST->iNameWall;
            ST->next->imgWall = [ST->imgWall retain];
            ST->next->wallFadeOut = ST->wallFadeOut;
            ST->next->iNameStand =ST->iNameStand;
            ST->next->imgStand = ST->imgStand;
            ST->next->standPossition =ST->standPossition;
            ST->next->N = ST->N;
            ST = ST->next;
            ST->name = [[str substringWithRange:range] retain];
            ST->name = [[rangeArray objectAtIndex:1] retain];
            ST->string = @"";
            dialogMax++;
            if(rangeSearch3.location != NSNotFound && [rangeArray count] > 2){
                
                ST->iName = [[rangeArray objectAtIndex:2] retain];
                ST->img = [NSImage imageNamed:ST->iName];
                
                NSString *iPath = @"data/StringList/img/";
                iPath = [iPath stringByAppendingString:ST->iName];
                NSData *iData = [NSData dataWithContentsOfFile:iPath];
                if(iData){
                    NSImage *iImg = [[NSImage alloc] initWithContentsOfFile:iPath];
                    ST->img = iImg;
                }
            }
        }else if(rangeSearch4.location != NSNotFound){
            
            
            ST->iNameWall = [[str substringWithRange:range] retain];
            ST->iNameWall = [[rangeArray2 objectAtIndex:1] retain];
            ST->imgWall = [[NSImage imageNamed:ST->iNameWall] retain];
            
            NSString *iPath = @"data/StringList/img/";
            iPath = [iPath stringByAppendingString:ST->iNameWall];
            NSData *iData = [NSData dataWithContentsOfFile:iPath];
            if(iData){
                NSImage *iImg = [[NSImage alloc] initWithContentsOfFile:iPath];
                ST->imgWall = [iImg retain];
            }
            
            ST->wallChanged = true;
            if(rangeSearch4.location != NSNotFound && [rangeArray2 count] > 2){
                ST->wallFadeIn = false;
                ST->wallFadeOut = false;
                if ([[rangeArray2 objectAtIndex:2] isEqualToString:@"FI"]) {
                    ST->wallFadeIn = true;
                    ST->wallFadeOut = false;
                }if([[rangeArray2 objectAtIndex:2] isEqualToString:@"FO"]){
                    ST->wallFadeIn = false;
                    ST->wallFadeOut = true;
                }if([[rangeArray2 objectAtIndex:2] isEqualToString:@"FIO"]){
                    ST->wallFadeIn = true;
                    ST->wallFadeOut = true;
                }
            }
            
        }else if(rangeSearch5.location != NSNotFound){
            ST->iNameStand = [[str substringWithRange:range] retain];
            ST->iNameStand = [[rangeArray3 objectAtIndex:1] retain];
            ST->imgStand = [NSImage imageNamed:ST->iNameStand];
            
            NSString *iPath = @"data/StringList/img/";
            iPath = [iPath stringByAppendingString:ST->iNameStand];
            NSData *iData = [NSData dataWithContentsOfFile:iPath];
            if(iData){
                NSImage *iImg = [[NSImage alloc] initWithContentsOfFile:iPath];
                ST->imgStand = iImg;
            }
            
            if([rangeArray3 count] > 2){
            if([[rangeArray3 objectAtIndex:1] isEqualToString:@"CLEAR!"]){
                ST->iNameStand = nil;
                ST->imgStand = nil;
                ST->standPossition = 0;
            }
            if([[rangeArray3 objectAtIndex:2] isEqualToString:@"CENTER!"]){
                ST->standPossition = 0;
            }
            if([[rangeArray3 objectAtIndex:2] isEqualToString:@"RIGHT!"]){
                ST->standPossition = 1;
            }
            if([[rangeArray3 objectAtIndex:2] isEqualToString:@"LEFT!"]){
                ST->standPossition = 2;
            }
            }
            
        }else if(rangeSearch8.location != NSNotFound){
            
            if(!ST->S){
                ST->S = calloc(1, sizeof(SVALUE));
                SVtop = ST->S;
            }else{
                ST->S->next = calloc(1, sizeof(SVALUE));
                ST->S = ST->S->next;
            }
            
            ST->S->slct = [[str substringWithRange:range] retain];
            ST->S->slct = [[rangeArray6 objectAtIndex:1] retain];
            if([rangeArray6 count] > 2) ST->S->jump = [[rangeArray6 objectAtIndex:2] retain];
            if([rangeArray6 count] > 3) ST->S->fName = [[rangeArray6 objectAtIndex:3] retain];
            
        }else if(rangeSearch6.location != NSNotFound){
            ST->labelName = [[str substringWithRange:range] retain];
            ST->labelName = [[rangeArray4 objectAtIndex:1] retain];
        
        }else if(rangeSearch7.location != NSNotFound){
            ST->jumpName = [[str substringWithRange:range] retain];
            ST->jumpName = [[rangeArray5 objectAtIndex:1] retain];
            
        }else if(rangeSearch9.location != NSNotFound){
            
            if(!ST->N){
                ST->N = calloc(1, sizeof(NVALUE));
                NVtop = ST->N;
            }else{
                ST->N->next = calloc(1, sizeof(NVALUE));
                ST->N = ST->N->next;
            }
            ST->N->title = [[str substringWithRange:range] retain];
            ST->N->title = [[rangeArray7 objectAtIndex:1] retain];
            ST->N->value = [@"名無し" retain];
            ST->N->key = [[rangeArray7 objectAtIndex:2] retain];
            ST->namingName = [[NSString stringWithString:str] retain];
        }else if(!commentSwitch){
            ST->string = [[[ST->string stringByAppendingString:str] stringByAppendingString:@"\n"] retain];
        //NSLog(@"index %d %@", ST->index, ST->string);
        }
        
    }
    ST->N = NVtop;
    ST = STtop;
    
    evDialogMax = dialogMax;
}

-(void)AddString:(STRING**)top:(int)no{
    STRING *ptr = *top;
    if(*top == NULL){
        *top = [self AllocSTRING];
        ptr = *top;
        ptr->index = no;
    }else{
        while(ptr->next != NULL) ptr = ptr->next;
        ptr->next = [self AllocSTRING];
        ptr->index = no;
        ptr->next->next = NULL;
    
    }


}
@end
