//
//  ScenarioEditor.m
//  Awars III
//
//  Created by Killery on 2013/01/28.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "ScenarioEditor.h"

@implementation ScenarioEditor

-(void)awakeFromNib{
    [textListTV setTarget:self];
    [textListTV setAction:@selector(ClickTL:)];
    [lineListTV setTarget:self];
    [lineListTV setAction:@selector(ClickLL:)];
    [lineListTV setDoubleAction:@selector(DoubleClickLL:)];
    
    [standListTV setTarget:self];
    [standListTV setAction:@selector(ClickSTAND:)];
    [standListTV setDoubleAction:@selector(DoubleClickSTAND:)];
    
    [baseListTV setTarget:self];
    [baseListTV setAction:@selector(ClickBASE:)];
    [baseListTV setDoubleAction:@selector(DoubleClickBASE:)];
    
    [layerListTV setTarget:self];
    [layerListTV setAction:@selector(ClickLAYER:)];
    [layerListTV setDoubleAction:@selector(DoubleClickLAYER:)];
    
    standListMA = [NSMutableArray new];
    baseListMA = [NSMutableArray new];
    layerListMA = [NSMutableArray new];
    
    baseListDC = @{@"1":baseListMA};
}

-(id)init{
    
    if(self){
    
        time = [NSTimer
             scheduledTimerWithTimeInterval:0.1
             target:self selector:@selector(EventLoop2:)
             userInfo:nil repeats:YES
            ];
        textListMA = [NSMutableArray new];
        lineListMA = [NSMutableArray new];
        
        StringText *stringText = [[StringText alloc] init];
        
        for(int i = 0;i<255;i++){
            [stringText AddString:&TX[i].S :0];
        }
        OMFGflag = true;
        [self initText];
        [self addLineList];
        [self initFileDirectory];
        Irow = -1;
        IBrow = -1;
        IBLrow = -1;
    }
    return self;
}

-(void)DoubleClickSTAND:(id)sender{
    if(Irow < 0) return;
    [self initLineBaseLayer];
    IBrow = -1;
    IBLrow = -1;
    [baseListAC setSelectionIndex:9999];
    [layerListAC setSelectionIndex:9999];
    
    [standEditorPanel makeKeyAndOrderFront:nil];
}

-(void)ClickSTAND:(id)sender{
    Irow = (int)[standListTV clickedRow];
}

-(void)DoubleClickBASE:(id)sender{
    IBrow = -1;
    [baseListAC setSelectionIndex:9999];
    [baseListAC setSelectionIndex:-1];
}

-(void)ClickBASE:(id)sender{
    IBrow = (int)[baseListTV clickedRow];
    [layerListAC setSelectionIndex:9999];
    IBLrow = -1;
    if(IBrow >= 0){
        I = Itop;
        for (int i = 0;i < Irow;i++) {
            I = I->next;
        }
    
        IBtop = I->B;
        for (int i = 0;i < IBrow;i++) {
            I->B = I->B->next;
        }
        if(I->B){
            [NSIV setImage:I->B->img];
            I->B->prefer = [[[baseListMA objectAtIndex:IBrow] valueForKeyPath:@"pref"] intValue];
            I->B->name = [[baseListMA objectAtIndex:IBrow] valueForKeyPath:@"name"];
        }
    
        I->B = IBtop;
        I = Itop;
    

    }
    
    [self initLineLayer];
}

-(void)DoubleClickLAYER:(id)sender{
    IBLrow = -1;
    [layerListAC setSelectionIndex:9999];
    [layerListAC setSelectionIndex:-1];
}

-(void)ClickLAYER:(id)sender{
    IBLrow = (int)[layerListTV clickedRow];
    
    
    if(IBLrow >=0){
        Itop = I;
        for (int i = 0;i < Irow;i++) {
            I = I->next;
        }
        
        IBtop = I->B;
        for (int i = 0;i < IBrow;i++) {
            I->B = I->B->next;
        }
        
        IBLtop = I->B->L;
        for (int i = 0;i < IBLrow;i++) {
            I->B->L = I->B->L->next;
        }
        
        int oops = 0;
        oops = [[layerListMA objectAtIndex:IBLrow] valueForKeyPath:@"visible"];
        oops = oops>>4 & 0xf;
        if(oops == 1){
            
            
        }else{
            if(oops == 3 || oops == 14){
                oops = -1;
            }else{
                oops = 0;
            }
        }
        I->B->L->visible = oops;
        I->B->L->prefer = [[[layerListMA objectAtIndex:IBLrow] valueForKeyPath:@"pref"] intValue];
        I->B->L->name = [[layerListMA objectAtIndex:IBLrow] valueForKeyPath:@"name"];
        
        [NSIV2 setImage:I->B->L->img];
        I->B->L = IBLtop;
        
        
        I->B = IBtop;
        
        
        I = Itop;
    }
    
    
    
    
    /*
    IBLrow = (int)[layerListTV clickedRow];
    
    if(IBLrow >= 0){
        Itop = I;
        if(!Itop) return;
        for (int i = 0;i < Irow;i++) {
            I = I->next;
        }
        
        IBtop = I->B;
        for (int i = 0;i < IBrow;i++) {
            I->B = I->B->next;
        }
        
        if(I->B){
            IBLtop = I->B->L;
            for (int i = 0;i < IBLrow;i++) {
                I->B->L = I->B->L->next;
            }
            
            if(I->B->L){
            int oops = 0;
            oops = [[layerListMA objectAtIndex:IBLrow] valueForKeyPath:@"visible"];
            oops = oops>>4 & 0xf;
            if(oops == 1){
            
            
            }else{
                if(oops == 3 || oops == 14){
                    oops = -1;
                }else{
                    oops = 0;
                }
            }
            I->B->L->visible = oops;
            
            I->B->L->prefer = [[[layerListMA objectAtIndex:IBLrow] valueForKeyPath:@"pref"] intValue];
            I->B->L->name = [[layerListMA objectAtIndex:IBLrow] valueForKeyPath:@"name"];
            
            }
            
            if(I->B->L){
                [NSIV2 setImage:I->B->L->img];
            }
            
            I->B->L = IBLtop;
            
        }
        I->B = IBtop;
        I = Itop;
    }*/
}

-(void)DoubleClickLL:(id)sender{
    LLrow = -1;
    [lineListAC setSelectionIndex:9999];
    [lineListAC setSelectionIndex:-1];
}

-(void)ClickTL:(id)sender{
    st = [textListTV selectedRow]+1;
    if(st != 0){
    [self willChangeValueForKey:@"lineListMA"];
    [lineListMA removeAllObjects];
    [self didChangeValueForKey:@"lineListMA"];
    OMFGflag = true;
        
    STRtop[st] = TX[st].S;
        
        if(TX[st].S != NULL){
        [Dname setStringValue:TX[st].S->name];
        [Dstring setStringValue:TX[st].S->string];
        [dialogName setStringValue:TX[st].S->name];
        [dialogString setStringValue:TX[st].S->string];
        [dialogImage setImage:TX[st].S->img];
    while(TX[st].S != NULL){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:[NSString stringWithFormat:@"%@：%@", TX[st].S->name, TX[st].S->string] forKey:@"name"];
        [self willChangeValueForKey:@"lineListMA"];
        [lineListMA addObject:dict];
        [self didChangeValueForKey:@"lineListMA"];
        [lineListAC setSelectionIndex:sl-1];
        
        TX[st].S = TX[st].S->next;
    }
        }
        TX[st].S = STRtop[st];
    }
}
-(void)ClickLL:(id)sender{
    sl = [lineListTV selectedRow]+1;
    
    LLrow = (int)[lineListTV selectedRow];
    
    STRtop[st] = TX[st].S;
    
    for(int k = 0;k < LLrow;k++) {
        if(TX[st].S->next != NULL) TX[st].S = TX[st].S->next;
    }
    
    [Dname setStringValue:TX[st].S->name];
    [Dstring setStringValue:TX[st].S->string];
    [dialogName setStringValue:TX[st].S->name];
    [dialogString setStringValue:TX[st].S->string];
    [dialogImage setImage:TX[st].S->img];
    TX[st].S = STRtop[st];
    OMFGflag = false;
}


-(void)EventLoop2:(NSTimer *)timer{
    
   if(!OMFGflag) [self submitLineList];

    if(I)
       if(I->B && IBLrow < 0){
          [NSIV2 setImage:nil];
       }
    
    if(I && IBrow < 0){
        [NSIV setImage:nil];
        [NSIV2 setImage:nil];
    }

 /*
        if(Irow == -1) return;
        I = Itop;
        for (int i = 0;i < Irow;i++) {
            I = I->next;
        }
        I->B = IBtop;
        for (int i = 0;i < IBrow;i++) {
            I->B = I->B->next;
        }
    
        if(I->B){
            if(IBrow >= 0){
                I->B->img = [[NSIV image] retain];
                I->B->name = [[[baseListMA objectAtIndex:IBrow] valueForKeyPath:@"name"] retain];
            }
            
            I->B->L = IBLtop;
            for (int i = 0;i < IBLrow;i++) {
                I->B->L = I->B->L->next;
            }
            
            if(I->B->L){
                if(IBLrow >= 0){
                    I->B->L->img = [[NSIV2 image] retain];
                   // I->B->L->name = [[layerListMA objectAtIndex:IBLrow] valueForKeyPath:@"name"];
                }
            }
             
             I->B->L = IBLtop;
        }
    
    I->B = IBtop;
    I = Itop;
*/
}

-(void)saveDataStand{
    
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    /*
    int std = 1;
    int Bcnt = 1;
    int Lcnt = 1;
    I = Itop;
    while (I) {
        NSString *fdata = @"data/StandList/STD";
        fdata = [fdata stringByAppendingFormat:@"%d.txt", std];
   
        NSString *Sdata = @"data/StandList/img/S";
        Sdata = [Sdata stringByAppendingFormat:@"%d", std];
        
        NSString *fileData = @"";
        
        fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", I->name]] stringByAppendingString:@"\n"];
        I->B = IBtop;
        while (I->B) {
            NSString *Bdata = [Sdata stringByAppendingFormat:@"B%d", Bcnt];
            
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"----"]] stringByAppendingString:@"\n"];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", I->B->name]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", I->B->x]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", I->B->y]] stringByAppendingString:@","];
            fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", I->B->prefer]] stringByAppendingString:@"\n"];
            
            I->B->L = IBLtop;
            while (I->B->L) {
                
                NSString *Ldata = [Bdata stringByAppendingFormat:@"L%d", Lcnt];
                
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%@", I->B->L->name]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", I->B->L->x]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", I->B->L->y]] stringByAppendingString:@","];
                fileData = [[fileData stringByAppendingString:[NSString stringWithFormat:@"%d", I->B->L->prefer]] stringByAppendingString:@"\n"];
                
                NSData *f2IMGdata = [I->B->L->img TIFFRepresentation];
                NSBitmapImageRep *brep = [NSBitmapImageRep imageRepWithData:f2IMGdata];
                f2IMGdata = [brep representationUsingType:NSPNGFileType properties:nil];
                
                [f2IMGdata writeToFile:Ldata atomically:YES];
                Lcnt++;
                I->B->L = I->B->L->next;
            }I->B->L = IBLtop;
            
            NSData *fIMGdata = [I->B->img TIFFRepresentation];
            NSBitmapImageRep *brep = [NSBitmapImageRep imageRepWithData:fIMGdata];
            fIMGdata = [brep representationUsingType:NSPNGFileType properties:nil];
            
            [fIMGdata writeToFile:Bdata atomically:YES];
            Bcnt++;
            I->B = I->B->next;
        }I->B = IBtop;
   
        [fileData writeToFile:fdata atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        std++;
        I = I->next;
    }I = Itop;
     */
}


-(void)initFileDirectory{
    NSString *directoryPath;
    
    directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    /*
    char *cwd;
    cwd = getcwd(NULL, 0);
    
    ///// S1B1L1 の用に記述する
    ///// STD1 の用にデータファイルはなる
    ///// 立ち絵名前
    ///// ----
    ///// ベース名前 ベースxy 優先度
    ///// レイヤー名前 レイヤーxy 優先度 可視
    ///// レイヤー名前 レイヤーxy 優先度 可視
    ///// レイヤー名前 レイヤーxy 優先度 可視
    ///// ----
    ///// ベース名前 ベースxy 優先度
    ///// レイヤー名前 レイヤーxy 優先度 可視
    ///// レイヤー名前 レイヤーxy 優先度 可視
    ///// レイヤー名前 レイヤーxy 優先度 可視
    ///// レイヤー名前 レイヤーxy 優先度 可視
    ///// ----

    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/StandList/preset.txt"];
    NSString *pathSL = @"data/StandList/img";
    NSString *pathDATA2 = @"data/StandList/preset.txt";
    NSString *pathSLP = @"data/StandList/preset.txt";
    NSString *fileData = nil;
    
    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathSL withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] createFileAtPath:pathDATA2 contents:nil attributes:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:pathSLP contents:nil attributes:nil];
    }
    
    
    
    I = calloc(1, sizeof(STAND));
    I->B = calloc(1, sizeof(BASE));
    I->B->L = calloc(1, sizeof(LAYER));
    Itop = I;
    for (int i = 0;i < 9999;i++) {
        NSString *fdata = @"data/StandList/STD";
        fdata = [fdata stringByAppendingFormat:@"%d.txt",i+1];
        fileData = [NSString stringWithContentsOfFile:fdata encoding:NSUTF8StringEncoding error:nil];
        IBtop = I->B;
        IBLtop = I->B->L;
        if(i > 0) {
            I->next = calloc(1, sizeof(STAND));
            I = I->next;
        }
        if(!fileData)
            break;
        fileDataArray = [fileData componentsSeparatedByString:@"\n"];
        I->name = [[fileDataArray objectAtIndex:0] retain];
        NSString *imagePath = @"data/StandList/img/S";
        imagePath = [imagePath stringByAppendingFormat:@"%d", i+1];
        
        bool initialStrFlag = false;
        int Bcnt = 1;
        int Lcnt = 1;
        for(int k= 2;k < [fileDataArray count];k++){
            NSString *str = [fileDataArray objectAtIndex:k];
            NSRange rangeSearch;
            NSArray *rangeArray;
            NSString *imagePathB = [imagePath stringByAppendingFormat:@"B%d", Bcnt];
            rangeArray = [str componentsSeparatedByString:@","];
            rangeSearch = [str rangeOfString:@"----"];
            
            if(!initialStrFlag){
                I->B = calloc(1, sizeof(BASE));
                I->B->name = [[rangeArray objectAtIndex:0] retain];
                I->B->x = [[rangeArray objectAtIndex:1] intValue];
                I->B->y = [[rangeArray objectAtIndex:2] intValue];
                I->B->prefer = [[rangeArray objectAtIndex:3] intValue];
                NSData *imgData = [NSData dataWithContentsOfFile:imagePathB];
                if(imgData) I->B->img = [[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePathB] readDataToEndOfFile]];
                
                initialStrFlag = true;
            }else{
            
                if(rangeSearch.location != NSNotFound){
                    I->B->next = calloc(1, sizeof(BASE));
                    I->B = I->B->next;
                    initialStrFlag = false;
                    Bcnt++;
                }else if([rangeArray count] > 2){
                    NSString *imagePathL = [imagePathB stringByAppendingFormat:@"L%d", Lcnt];
                    I->B->L = calloc(1, sizeof(LAYER));
                    
                    I->B->L->name = [[rangeArray objectAtIndex:0] intValue];
                    I->B->L->x = [[rangeArray objectAtIndex:1] intValue];
                    I->B->L->y = [[rangeArray objectAtIndex:2] intValue];
                    I->B->L->prefer = [[rangeArray objectAtIndex:3] intValue];
                    NSData *imgData = [NSData dataWithContentsOfFile:imagePathL];
                    if(imgData) I->B->L->img = [[NSImage alloc] initWithData:[[NSFileHandle fileHandleForReadingAtPath:imagePathL] readDataToEndOfFile]];
                    
                    I->B->L->next = calloc(1, sizeof(LAYER));
                    I->B->L = I->B->L->next;
                    Lcnt++;
                }
                I->B->L = IBLtop;
            }
        }
        I->B = IBtop;
    }
 I = Itop;
     */
}


-(IBAction)stringData:(id)sender{
    OMFGflag = false;
}

-(void)submitLineList{
    
    if(LLrow == -1){
        [Dname setStringValue:@""];
        [Dstring setStringValue:@""];
        [dialogName setStringValue:@""];
        [dialogString setStringValue:@""];
        [dialogImage setImage:NULL];
    
        return;
    }
    
    
    STRtop[st] = TX[st].S;
    
    if (st != 0) {
        if(TX[st].S != NULL){
            for(int k = 0;k < LLrow ;k++) {
                TX[st].S = TX[st].S->next;
            }
        TX[st].S->name = [[Dname stringValue] retain];
        TX[st].S->string = [[Dstring stringValue] retain];
        
        [dialogName setStringValue:TX[st].S->name];
        [dialogString setStringValue:TX[st].S->string];
        [dialogImage setImage:TX[st].S->img];
        
        [lineListAC setValue:[NSString stringWithFormat:@"%@：%@", TX[st].S->name, TX[st].S->string] forKeyPath:@"selection.name"];
            
        }
    }
    
    TX[st].S = STRtop[st];
     
}


-(void)initText{
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];


    NSData *InitialData = [NSData dataWithContentsOfFile:@"data/StringList/preset.txt"];
    NSString *pathFOLDER = @"data/StringList";

    if(!InitialData){
        [[NSFileManager defaultManager] createDirectoryAtPath:pathFOLDER withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *Farray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathFOLDER error:nil];
    
    int omg = 0;
    textNumb = [Farray count];
    for (int i = 1; i <= textNumb;i++) {
        if([[Farray objectAtIndex:i-1] isEqualToString:@"img"] ||
           [[Farray objectAtIndex:i-1] isEqualToString:@"preset.txt"]){omg++;
            TX[i].fileName = [[NSString stringWithFormat:@"sample%d", omg] retain];
            continue;
        }
        TX[i].fileName = [[Farray objectAtIndex:i-1] retain];
        //NSLog(@"%@", TX[i].fileName);
    }
    
    NSLog(@"%ld", textNumb);
    
    for(int i = 1; i<= textNumb;i++){
        

        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        if(1/*![TX[i].fileName isEqual: @"img"] && ![TX[i].fileName isEqual: @"preset.txt"]*/){
            [dict setValue:[NSString stringWithFormat:@"%@", TX[i].fileName] forKey:@"name"];
            [self willChangeValueForKey:@"textListMA"];
            [textListMA addObject:dict];
            [self didChangeValueForKey:@"textListMA"];
        }
    }
    //NSLog(@"%@", textListMA);
}


-(void)addLineList{
    
    st = [textListTV selectedRow];
    
    for(int i = 1;i <= textNumb;i++){
    NSString *tfD = @"data/StringList/"; 
    tfD = [tfD stringByAppendingFormat:@"%@", TX[i].fileName];
    NSString *textFileData = [NSString stringWithContentsOfFile:tfD encoding:NSUTF8StringEncoding error:nil];
    fileDataArray = [textFileData componentsSeparatedByString:@"\n"];
 
    STRtop[i] = TX[i].S;
        
    for(int j = 1;j<=[fileDataArray count];j++){
        NSString *str = [fileDataArray objectAtIndex:j-1];
        NSRange range = NSMakeRange(2, str.length - 2);
        NSRange rangeSearch;
        NSRange rangeSearch2;
        NSRange rangeSearch3;
        NSArray *rangeArray;
        NSRange rangeSearch4;
        NSArray *rangeArray2;
        NSRange rangeSearch5;
        NSArray *rangeArray3;
        bool commentSwitch = false;
        rangeSearch = [str rangeOfString:@"##"];
        rangeSearch2 = [str rangeOfString:@"####"];
        rangeSearch3 = [str rangeOfString:@"##" options:NSBackwardsSearch];
        rangeArray = [str componentsSeparatedByString:@"##"];
        rangeArray2 = [str componentsSeparatedByString:@"%%"];
        rangeSearch4 = [str rangeOfString:@"%%"];
        rangeSearch5 = [str rangeOfString:@"$$"];
        rangeArray3 = [str componentsSeparatedByString:@"$$"];
        
        static int omg = 0;
        
        if (rangeSearch2.location != NSNotFound) {commentSwitch = true;
            
        }else if (rangeSearch.location != NSNotFound) {commentSwitch = false;
            TX[st].S->index++;
            StringText *stringText = [[StringText alloc] init];
            
            [stringText AddString:&TX[i].S :TX[i].S->index];
            TX[i].S->next->iNameWall =TX[i].S->iNameWall;
            TX[i].S->next->imgWall = TX[i].S->imgWall;
            TX[i].S->next->wallFadeOut = TX[i].S->wallFadeOut;
            TX[i].S->next->iNameStand =TX[i].S->iNameStand;
            TX[i].S->next->imgStand = TX[i].S->imgStand;
            TX[i].S->next->standPossition =TX[i].S->standPossition;
            
            TX[i].S = TX[i].S->next;
            TX[i].S->name = [[str substringWithRange:range] retain];
            TX[i].S->name = [[rangeArray objectAtIndex:1] retain];
            TX[i].S->string = @"";
            if(rangeSearch3.location != NSNotFound && [rangeArray count] > 2){
                
                TX[i].S->iName = [[rangeArray objectAtIndex:2] retain];
                TX[i].S->img = [NSImage imageNamed:TX[i].S->iName];
                
                NSString *iPath = @"data/StringList/img/";
                iPath = [iPath stringByAppendingString:TX[i].S->iName];
                NSData *iData = [NSData dataWithContentsOfFile:iPath];
                if(iData){
                    NSImage *iImg = [[NSImage alloc] initWithContentsOfFile:iPath];
                    TX[i].S->img = iImg;
                }
            }
        }else if(rangeSearch4.location != NSNotFound){
            TX[i].S->iNameWall = [[str substringWithRange:range] retain];
            TX[i].S->iNameWall = [[rangeArray2 objectAtIndex:1] retain];
            TX[i].S->imgWall = [NSImage imageNamed:TX[i].S->iNameWall];
            TX[i].S->wallChanged = true;
            if(rangeSearch4.location != NSNotFound && [rangeArray2 count] > 2){
                
                if ([[rangeArray2 objectAtIndex:2] isEqualToString:@"FI"]) {
                   TX[i].S->wallFadeIn = true;
                }else if([[rangeArray2 objectAtIndex:2] isEqualToString:@"FO"]){
                    TX[i].S->wallFadeOut = true;
                }else if([[rangeArray2 objectAtIndex:2] isEqualToString:@"FIO"]){
                    TX[i].S->wallFadeIn = true;
                    TX[i].S->wallFadeOut = true;
                }
            }
            
        }else if(rangeSearch5.location != NSNotFound){
            TX[i].S->iNameStand = [[str substringWithRange:range] retain];
            TX[i].S->iNameStand = [[rangeArray3 objectAtIndex:1] retain];
            TX[i].S->imgStand = [NSImage imageNamed:TX[i].S->iNameStand];
            
            if([rangeArray3 count] > 2){
                if([[rangeArray3 objectAtIndex:1] isEqualToString:@"CLEAR!"]){
                    TX[i].S->iNameStand = nil;
                    TX[i].S->imgStand = nil;
                    TX[i].S->standPossition = 0;
                }
                if([[rangeArray3 objectAtIndex:2] isEqualToString:@"CENTER!"]){
                    TX[i].S->standPossition = 0;
                }
                if([[rangeArray3 objectAtIndex:2] isEqualToString:@"RIGHT!"]){
                    TX[i].S->standPossition = 1;
                }
                if([[rangeArray3 objectAtIndex:2] isEqualToString:@"LEFT!"]){
                    TX[i].S->standPossition = 2;
                }
            }
            
        }else if(!commentSwitch){
            TX[i].S->string = [[TX[i].S->string stringByAppendingString:str] retain];
            
            if([fileDataArray count] > 1 && [fileDataArray count] > j){
            NSString *str2 = [fileDataArray objectAtIndex:j];
            NSRange rangeSearchA = [str2 rangeOfString:@"##"];
            NSRange rangeSearchB = [str2 rangeOfString:@"%%"];
            NSRange rangeSearchC = [str2 rangeOfString:@"$$"];
            if (rangeSearchA.location == NSNotFound && rangeSearchB.location == NSNotFound && rangeSearchC.location == NSNotFound)
                TX[i].S->string = [[TX[i].S->string stringByAppendingString:@"\n"] retain];
            }
        }
    }
        STRtop[i] = STRtop[i]->next;
        TX[i].S = STRtop[i];
    }
    
    /*
    NSLog(@"fN:%@\nNM:%@\nST:%@", TX[3].fileName, TX[3].S->name, TX[3].S->string);
    TX[3].S = TX[3].S->next;
    NSLog(@"fN:%@\nNM:%@\nST:%@", TX[3].fileName, TX[3].S->name, TX[3].S->string);
    TX[3].S = TX[3].S->next;
    NSLog(@"fN:%@\nNM:%@\nST:%@", TX[3].fileName, TX[3].S->name, TX[3].S->string);
    */
    
    
    
}


-(IBAction)titleBtn:(id)sender{
    
    [scenarioEditorWindow close];
    [titleWindow makeKeyAndOrderFront:nil];
}

-(IBAction)insertLine:(id)sender{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"oops"] forKey:@"name"];
    
    STRtop[st] = TX[st].S;
    
    if(LLrow < 0){
        TX[st].S = STRtop[st];
        if([lineListMA count] == 0){
            TX[st].S = calloc(1, sizeof(STRING));
            //INIT 処理
            TX[st].S->name = @"";
            TX[st].S->string = @"";
            TX[st].S->next = NULL;
            STRtop[st] = TX[st].S;
        }else{
            while(TX[st].S->next) TX[st].S = TX[st].S->next;
            TX[st].S->next = calloc(1, sizeof(STRING));
            TX[st].S = TX[st].S->next;
            //INIT 処理
            TX[st].S->name = @"";
            TX[st].S->string = @"";
            TX[st].S->next = NULL;
            TX[st].S = STRtop[st];
        }
        
        [dict setValue:[NSString stringWithFormat:@"："] forKey:@"name"];
        
        [self willChangeValueForKey:@"lineListMA"];
        [lineListMA insertObject:dict atIndex:[lineListMA count]];
        [self didChangeValueForKey:@"lineListMA"];
        [lineListAC setSelectionIndex:9999];
        LLrow = -1;
    }else{
        TX[st].S = STRtop[st];
        if([lineListMA count] == 0){
            TX[st].S = calloc(1, sizeof(STRING));
            //INIT 処理
            TX[st].S->name = @"";
            TX[st].S->string = @"";
            TX[st].S->next = NULL;
            STRtop[st] = TX[st].S;
        }else if(LLrow > 0){
            for (int i = 0; i < LLrow-1;i++)
                TX[st].S = TX[st].S->next;
            STRING *tmp = calloc(1, sizeof(STRING));
            *tmp = *TX[st].S->next;
            TX[st].S->next = calloc(1, sizeof(STRING));
            TX[st].S->next->next = tmp;
            TX[st].S = TX[st].S->next;
            //INIT 処理
            TX[st].S->name = @"";
            TX[st].S->string = @"";
            TX[st].S = STRtop[st];
        }else{
            STRING *tmp = calloc(1, sizeof(STRING));
            tmp->next = TX[st].S;
            // INIT 処理[self InitAttack:tmp];
            tmp->name = @"";
            tmp->string = @"";
            STRtop[st] = tmp;
            TX[st].S = STRtop[st];
        }
        
        [dict setValue:[NSString stringWithFormat:@"："] forKey:@"name"];
        
        [self willChangeValueForKey:@"lineListMA"];
        [lineListMA insertObject:dict atIndex:LLrow];
        [self didChangeValueForKey:@"lineListMA"];
        [lineListAC setSelectionIndex:LLrow];
    }
    
    [Dname setStringValue:TX[st].S->name];
    [Dstring setStringValue:TX[st].S->string];
    [dialogName setStringValue:TX[st].S->name];
    [dialogString setStringValue:TX[st].S->string];
    [dialogImage setImage:TX[st].S->img];
    
    TX[st].S = STRtop[st];
}
-(IBAction)removeLine:(id)sender{
    
    STRtop[st] = TX[st].S;
    
    if(LLrow == -1){
        LLrow = (int)[lineListMA count] - 1;
    }
    
    if([lineListMA count] > 0){
        
        if(LLrow == 0){
            TX[st].S = STRtop[st];
            TX[st].S = TX[st].S->next;
            STRtop[st] = TX[st].S;
        }else if(LLrow == [lineListMA count] - 1){
            TX[st].S = STRtop[st];
            while(TX[st].S->next->next){
                TX[st].S = TX[st].S->next;
            }
            TX[st].S->next = NULL;
        }else{
            TX[st].S = STRtop[st];
            for (int i = 0; i < LLrow - 1;i++)
                TX[st].S = TX[st].S->next;
           TX[st].S->next = TX[st].S->next->next;
        }
        
        [self willChangeValueForKey:@"lineListMA"];
        [lineListMA removeObjectAtIndex:LLrow];
        [self didChangeValueForKey:@"lineListMA"];
        [lineListAC setSelectionIndex:LLrow-1];
        if(LLrow < 0) [lineListAC setSelectionIndex:[lineListMA count]-1];
        if(LLrow == 0) [lineListAC setSelectionIndex:0];
        if(LLrow > 0) LLrow--;
        
        [Dname setStringValue:TX[st].S->name];
        [Dstring setStringValue:TX[st].S->string];
        [dialogName setStringValue:TX[st].S->name];
        [dialogString setStringValue:TX[st].S->string];
        [dialogImage setImage:TX[st].S->img];
    }
    TX[st].S = STRtop[st];
    

}

-(IBAction)saveLineData:(id)sender{
    NSString *directoryPath = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:directoryPath];
    
    NSString *saveDataPath = @"data/StringList/";
    
   saveDataPath = [saveDataPath stringByAppendingFormat:@"%@", TX[st].fileName];
    
    NSString *fileData = @"";
    
    
    STRtop[st] = TX[st].S;
    if(TX[st].S->string == NULL) return;
    //if(TX[st].S->next != NULL) return;
    do {
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"##"]];
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%@", TX[st].S->name]];
        if(TX[st].S->iName != NULL) {
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"##"]];
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%@", TX[st].S->iName]];
        }
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        
        //NSRange rangeSearch = [TX[st].S->string rangeOfString:@"\n" options:NSBackwardsSearch];
        //if(rangeSearch.location != NSNotFound) [TX[st].S->string deleteCharactersInRange:NSMakeRange(TX[st].S->string.length - 1, 1)];
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%@", TX[st].S->string]];
        fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        
        if(TX[st].S->iNameStand != NULL) {
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"&&"]];
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%@", TX[st].S->iNameStand]];
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        }
        
        if(TX[st].S->iNameWall != NULL && TX[st].S->wallChanged) {
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%%%%"]];
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%@", TX[st].S->iNameWall]];
            if (TX[st].S->wallFadeIn && TX[st].S->wallFadeOut) {
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%%%%"]];
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"FIO"]];
            }
            else if(TX[st].S->wallFadeIn) {
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%%"]];
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"FI"]];
            }
            else if(TX[st].S->wallFadeOut) {
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"%%%%"]];
                fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"FO"]];
            }
            fileData = [fileData stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        }
        
        TX[st].S = TX[st].S->next;
    }while(TX[st].S != NULL);
    
    [fileData writeToFile:saveDataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    
    
    TX[st].S = STRtop[st];
                    
    
}

-(IBAction)detailBtn:(id)sender{
    
}

-(IBAction)standBtn:(id)sender{
    
    [standPanel makeKeyAndOrderFront:nil];
}

-(IBAction)backStand:(id)sender{
    [standPanel close];
    [scenarioEditorWindow makeKeyAndOrderFront:nil];
}


-(IBAction)submitStand:(id)sender{
    [standEditorPanel close];
    [self saveDataStand];
    [standPanel makeKeyAndOrderFront:nil];
}


-(IBAction)insertLineStand:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"新規立ち絵"] forKey:@"name"];
    
    Itop = I;
    
    if(Irow < 0){
        I = Itop;
        if([standListMA count] == 0){
            I = calloc(1, sizeof(STAND));
            //INIT 処理
            I->B = NULL;
            I->registerNum = 0;
            I->index = 0;
            I->name = [@"新規立ち絵" retain];
            I->next = NULL;
            Itop = I;
        }else{
            while(I->next) I = I->next;
            I->next = calloc(1, sizeof(STAND));
            I = I->next;
            //INIT 処理
            I->B = NULL;
            I->registerNum = 0;
            I->name = [@"新規立ち絵" retain];
            I->next = NULL;
            I = Itop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%d", I->registerNum] forKey:@"num"];
        
        [self willChangeValueForKey:@"standListMA"];
        [standListMA insertObject:dict atIndex:[standListMA count]];
        [self didChangeValueForKey:@"standListMA"];
        [standListAC setSelectionIndex:9999];
        Irow = -1;
    }else{
        I = Itop;
        if([standListMA count] == 0){
            I = calloc(1, sizeof(STAND));
            //INIT 処理
            I->B = NULL;
            I->registerNum = 0;
            I->name = [@"新規立ち絵" retain];
            I->next = NULL;
            Itop = I;
        }else if(Irow > 0){
            for (int i = 0; i < Irow-1;i++)
            I = I->next;
            STAND *tmp = calloc(1, sizeof(STAND));
            *tmp = *I->next;
            I->next = calloc(1, sizeof(STAND));
            I->next->next = tmp;
            I = I->next;
            //INIT 処理
            I->B = NULL;
            I->registerNum = 0;
            I->name = [@"新規立ち絵" retain];
            I = Itop;
        }else{
            STAND *tmp = calloc(1, sizeof(STAND));
            tmp->next = I;
            // INIT 処理[self InitAttack:tmp];
            tmp->B = NULL;
            tmp->registerNum = 0;
            tmp->name = [@"新規立ち絵" retain];
            Itop = tmp;
            I = Itop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%d", I->registerNum] forKey:@"num"];
        
        [self willChangeValueForKey:@"standListMA"];
        [standListMA insertObject:dict atIndex:Irow];
        [self didChangeValueForKey:@"standListMA"];
        [standListAC setSelectionIndex:Irow];
    }
    [self saveDataStand];
    I = Itop;
    [self initLineBaseLayer];
}
-(IBAction)removeLineStand:(id)sender{

    Itop = I;
    
    if(Irow == -1){
        Irow = (int)[standListMA count] - 1;
    }
    
    if([standListMA count] > 0){
        
        if(Irow == 0){
            I = Itop;
            I = I->next;
            Itop = I;
        }else if(Irow == [standListMA count] - 1){
            I = Itop;
            while(I->next->next){
                I = I->next;
            }
            I->next = NULL;
        }else{
            I = Itop;
            for (int i = 0; i < Irow - 1;i++)
                I = I->next;
            I->next = I->next->next;
        }
        
        [self willChangeValueForKey:@"standListMA"];
        [standListMA removeObjectAtIndex:Irow];
        [self didChangeValueForKey:@"standListMA"];
        [standListAC setSelectionIndex:Irow-1];
        if(Irow < 0) [standListAC setSelectionIndex:[standListMA count]-1];
        if(Irow == 0) [standListAC setSelectionIndex:0];
        if(Irow > 0) Irow--;
    }
    I = Itop;
    
  [self saveDataStand];
}



-(IBAction)insertLineBase:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"新規ベース"] forKey:@"name"];
    
    I = Itop;
    for (int i = 0; i < Irow; i++) {
        I = I->next;
    }
    
    
    IBtop = I->B;
    
    if(IBrow < 0){
        I->B = IBtop;
        if([baseListMA count] == 0){
            I->B = calloc(1, sizeof(BASE));
            //INIT 処理
            I->B->L = NULL;
            I->registerNum++;
            I->B->index = 0;
            I->B->name = [@"新規ベース" retain];
            I->B->prefer = 100;
            I->B->img = nil;
            I->B->next = NULL;
            IBtop = I->B;
        }else{
            while(I->B->next) I->B = I->B->next;
            I->B->next = calloc(1, sizeof(BASE));
            I->B = I->B->next;
            //INIT 処理
            I->B->L = NULL;
            I->registerNum++;
            I->B->name = [@"新規ベース" retain];
            I->B->prefer = 100;
            I->B->img = nil;
            I->B->next = NULL;
            I->B = IBtop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%d", I->B->prefer] forKey:@"pref"];
        
        [self willChangeValueForKey:@"baseListMA"];
        [baseListMA insertObject:dict atIndex:[baseListMA count]];
        [self didChangeValueForKey:@"baseListMA"];
        [baseListAC setSelectionIndex:9999];
        IBrow = -1;
    }else{
        I->B = IBtop;
        if([baseListMA count] == 0){
            I->B = calloc(1, sizeof(BASE));
            //INIT 処理
            I->B->L = NULL;
            I->registerNum++;
            I->B->name = [@"新規ベース" retain];
            I->B->prefer = 100;
            I->B->img = nil;
            I->B->next = NULL;
            IBtop = I->B;
        }else if(IBrow > 0){
            for (int i = 0; i < IBrow-1;i++)
                I->B = I->B->next;
            BASE *tmp = calloc(1, sizeof(BASE));
            *tmp = *I->B->next;
            I->B->next = calloc(1, sizeof(BASE));
            I->B->next->next = tmp;
            I->B = I->B->next;
            //INIT 処理
            I->B->L = NULL;
            I->registerNum++;
            I->B->img = nil;
            I->B->name = [@"新規ベース" retain];
            I->B->prefer = 100;
            I->B = IBtop;
        }else{
            BASE *tmp = calloc(1, sizeof(BASE));
            tmp->next = I->B;
            // INIT 処理[self InitAttack:tmp];
            tmp->L = NULL;
            I->registerNum++;
            tmp->name = [@"新規ベース" retain];
            tmp->prefer = 100;
            tmp->img = nil;
            IBtop = tmp;
            I->B = IBtop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%d", I->B->prefer] forKey:@"pref"];
        
        [self willChangeValueForKey:@"baseListMA"];
        [baseListMA insertObject:dict atIndex:IBrow];
        [self didChangeValueForKey:@"baseListMA"];
        [baseListAC setSelectionIndex:IBrow];
    }
    
    
    I = Itop;
}

-(IBAction)removeLineBase:(id)sender{
    
    if(IBrow == -1){
        IBrow = (int)[baseListMA count] - 1;
    }
    
    Itop = I;
    for (int i = 0; i < Irow; i++) {
        I = I->next;
    }
    
    IBtop = I->B;
    if([baseListMA count] > 0){
        
        if(IBrow == 0){
            I->B = IBtop;
            I->B = I->B->next;
            I->registerNum--;
            IBtop = I->B;
        }else if(IBrow == [baseListMA count] - 1){
            I->B = IBtop;
            while(I->B->next->next){
                I->B = I->B->next;
            }
            I->registerNum--;
            I->B->next = NULL;
        }else{
            I->B = IBtop;
            for (int i = 0; i < IBrow - 1;i++)
                I->B = I->B->next;
            I->B->next = I->B->next->next;
            I->registerNum--;
        }
        
        [self willChangeValueForKey:@"baseListMA"];
        [baseListMA removeObjectAtIndex:IBrow];
        [self didChangeValueForKey:@"baseListMA"];
        [baseListAC setSelectionIndex:IBrow-1];
        if(IBrow < 0) [baseListAC setSelectionIndex:[baseListMA count]-1];
        if(IBrow == 0) [baseListAC setSelectionIndex:0];
        if(IBrow > 0) IBrow--;
    }
    I->B = IBtop;
    
    I = Itop;

    
    [self initLineLayer];
    
}

-(void)initLineBaseLayer{
    
    [self willChangeValueForKey:@"baseListMA"];
    [baseListMA removeAllObjects];
    [self didChangeValueForKey:@"baseListMA"];
    
    [self willChangeValueForKey:@"layerListMA"];
    [layerListMA removeAllObjects];
    [self didChangeValueForKey:@"layerListMA"];
    
    Itop = I;
    for (int i = 0; i < Irow; i++) {
        I = I->next;
    }
    IBtop = I->B;
    while (I->B) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", I->B->name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d", I->B->prefer] forKey:@"pref"];
        
        [self willChangeValueForKey:@"baseListMA"];
        [baseListMA addObject:dict];
        [self didChangeValueForKey:@"baseListMA"];
        I->B = I->B->next;
    }I->B = IBtop;
    I = Itop;
    
    
}

-(void)initLineLayer{
    
    [self willChangeValueForKey:@"layerListMA"];
    [layerListMA removeAllObjects];
    [self didChangeValueForKey:@"layerListMA"];
    
    if(IBrow < 0) return;
    
    Itop = I;
    for (int i = 0; i < Irow; i++) {
        I = I->next;
    }
    
    IBtop = I->B;
    for (int i = 0; i < IBrow; i++) {
        I->B = I->B->next;
    }
    
    if(!I->B) return;
    
    IBLtop = I->B->L;
    while (I->B->L) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:[NSString stringWithFormat:@"%@", I->B->L->name] forKey:@"name"];
        [dict setValue:[NSString stringWithFormat:@"%d", I->B->L->prefer] forKey:@"pref"];
        [dict setValue:[NSString stringWithFormat:@"%d", I->B->L->visible] forKey:@"visible"];
        
        [self willChangeValueForKey:@"layerListMA"];
        [layerListMA addObject:dict];
        [self didChangeValueForKey:@"layerListMA"];
        I->B->L = I->B->L->next;
    }
    
    I->B->L = IBLtop;
    I->B = IBtop;
    I = Itop;
    I = Itop;
}


-(IBAction)insertLineLayer:(id)sender{
    if(IBrow < 0) return;
    
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[NSString stringWithFormat:@"新規レイヤー"] forKey:@"name"];
    I = Itop;
    for (int i = 0; i < Irow; i++) {
        I = I->next;
    }
    
    IBtop = I->B;
    for (int i = 0; i < IBrow; i++) {
        I->B = I->B->next;
    }
    
    
    IBLtop = I->B->L;
    
    if(IBLrow < 0){
        I->B->L = IBLtop;
        if([layerListMA count] == 0){
            I->B->L = calloc(1, sizeof(LAYER));
            //INIT 処理
            I->registerNum++;
            I->B->L->index = 0;
            I->B->L->prefer = 225;
            I->B->L->name = [@"新規レイヤー" retain];
            I->B->L->next = NULL;
            IBLtop = I->B->L;
        }else{
            while(I->B->L->next) I->B->L = I->B->L->next;
            I->B->L->next = calloc(1, sizeof(LAYER));
            I->B->L = I->B->L->next;
            //INIT 処理
            I->registerNum++;
            I->B->L->prefer = 225;
            I->B->L->name = [@"新規レイヤー" retain];
            I->B->L->next = NULL;
            I->B->L = IBLtop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%d", I->B->L->prefer] forKey:@"pref"];
        
        [self willChangeValueForKey:@"layerListMA"];
        [layerListMA insertObject:dict atIndex:[layerListMA count]];
        [self didChangeValueForKey:@"layerListMA"];
        [layerListAC setSelectionIndex:9999];
        IBLrow = -1;
    }else{
        I->B->L = IBLtop;
        if([layerListMA count] == 0){
            I->B->L = calloc(1, sizeof(LAYER));
            //INIT 処理
            I->registerNum++;
            I->B->L->prefer = 225;
            I->B->L->name = [@"新規レイヤー" retain];
            I->B->L->next = NULL;
            IBLtop = I->B->L;
        }else if(IBLrow > 0){
            for (int i = 0; i < IBLrow-1;i++)
                I->B->L = I->B->L->next;
            LAYER *tmp = calloc(1, sizeof(LAYER));
            *tmp = *I->B->L->next;
            I->B->L->next = calloc(1, sizeof(LAYER));
            I->B->L->next->next = tmp;
            I->B->L = I->B->L->next;
            //INIT 処理
            I->registerNum++;
            I->B->L->prefer = 225;
            I->B->L->name = [@"新規レイヤー" retain];
            I->B->L = IBLtop;
        }else{
            LAYER *tmp = calloc(1, sizeof(LAYER));
            tmp->next = I->B->L;
            // INIT 処理[self InitAttack:tmp];
            I->registerNum++;
            tmp->prefer = 225;
            tmp->name = [@"新規レイヤー" retain];
            IBLtop = tmp;
            I->B->L = IBLtop;
        }
        
        [dict setValue:[NSString stringWithFormat:@"%d", I->B->L->prefer] forKey:@"pref"];
        
        [self willChangeValueForKey:@"layerListMA"];
        [layerListMA insertObject:dict atIndex:IBLrow];
        [self didChangeValueForKey:@"layerListMA"];
        [layerListAC setSelectionIndex:IBLrow];
    }
    
    I->B = IBtop;
    I = Itop;
    
}

-(IBAction)removeLineLayer:(id)sender{
    if(IBrow < 0) return;
    
    
    if(IBLrow == -1){
        IBLrow = (int)[layerListMA count] - 1;
    }
    
    Itop = I;
    for (int i = 0; i < Irow; i++) {
        I = I->next;
    }
    
    IBtop = I->B;
    for (int i = 0; i < IBrow; i++) {
        I->B = I->B->next;
    }
    
    IBLtop = I->B->L;
    if([layerListMA count] > 0){
        
        if(IBLrow == 0){
            I->B->L = IBLtop;
            I->B->L = I->B->L->next;
            I->registerNum--;
            IBLtop = I->B->L;
        }else if(IBLrow == [layerListMA count] - 1){
            I->B->L = IBLtop;
            while(I->B->L->next->next){
                I->B->L = I->B->L->next;
            }
            I->registerNum--;
            I->B->L->next = NULL;
        }else{
            I->B->L = IBLtop;
            for (int i = 0; i < IBLrow - 1;i++)
                I->B->L = I->B->L->next;
            I->B->L->next = I->B->L->next->next;
            I->registerNum--;
        }
        
        [self willChangeValueForKey:@"layerListMA"];
        [layerListMA removeObjectAtIndex:IBLrow];
        [self didChangeValueForKey:@"layerListMA"];
        [layerListAC setSelectionIndex:IBrow-1];
        if(IBLrow < 0) [layerListAC setSelectionIndex:[layerListMA count]-1];
        if(IBLrow == 0) [layerListAC setSelectionIndex:0];
        if(IBLrow > 0) IBLrow--;
    }
    I->B->L = IBLtop;
    
    I->B = IBtop;
    
    I = Itop;

}

@end
