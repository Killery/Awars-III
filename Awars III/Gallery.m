//
//  Gallery.m
//  Awars III
//
//  Created by Killery on 2013/01/09.
//  Copyright (c) 2013年 Killery. All rights reserved.
//

#import "Gallery.h"

@implementation Gallery
-(IBAction)backButton:(id)sender{
    [titleWindow  makeKeyAndOrderFront:nil];
    [galleryWindow close];
}

-(void)awakeFromNib{

    [galleryListTV setTarget:self];
    [galleryListTV setAction:@selector(clickGL:)];


}

-(id)init{
    
    if(self){
        timer = [NSTimer
                 scheduledTimerWithTimeInterval:0.1
                 target:self selector:@selector(EventLoop:)
                 userInfo:nil repeats:YES
                 ];
        
        
        galleryMax = 5;
        /*
        NSImage *img[12];
        
        img[0] = [[NSImage imageNamed:@"test01.jpg"] retain];
        img[1] = [[NSImage imageNamed:@"test02.jpg"] retain];
        img[2] = [[NSImage imageNamed:@"test03.jpg"] retain];
        img[3] = [[NSImage imageNamed:@"test04.jpg"] retain];
        img[4] = [[NSImage imageNamed:@"test05.jpg"] retain];
        img[5] = [[NSImage imageNamed:@"test06.jpg"] retain];
        img[6] = [[NSImage imageNamed:@"test07.jpg"] retain];
        img[7] = [[NSImage imageNamed:@"test08.jpg"] retain];
        img[8] = [[NSImage imageNamed:@"test09.jpg"] retain];
        img[9] = [[NSImage imageNamed:@"test10.jpg"] retain];
        img[10] = [[NSImage imageNamed:@"test11.jpg"] retain];
        img[11] = [[NSImage imageNamed:@"test12.jpg"] retain];
        
        galleryListMA = [NSMutableArray new];
        
        
        
        NSMutableDictionary* dict = [NSMutableDictionary new];
            
        [dict setValue:@"すべて" forKey:@"name"];
        [self willChangeValueForKey:@"galleryListMA"];
        [galleryListMA addObject:dict];
        [self didChangeValueForKey:@"galleryListMA"];

        
        [self willChangeValueForKey:@"galleryListMA"];
        [[galleryListMA objectAtIndex:0] setValue:img[0] forKey:@"img01"];
        [[galleryListMA objectAtIndex:0] setValue:img[1] forKey:@"img02"];
        [[galleryListMA objectAtIndex:0] setValue:img[2] forKey:@"img03"];
        [[galleryListMA objectAtIndex:0] setValue:img[3] forKey:@"img04"];
        [[galleryListMA objectAtIndex:0] setValue:img[4] forKey:@"img05"];
        [[galleryListMA objectAtIndex:0] setValue:img[5] forKey:@"img06"];
        [[galleryListMA objectAtIndex:0] setValue:img[6] forKey:@"img07"];
        [[galleryListMA objectAtIndex:0] setValue:img[7] forKey:@"img08"];
        [[galleryListMA objectAtIndex:0] setValue:img[8] forKey:@"img09"];
        [[galleryListMA objectAtIndex:0] setValue:img[9] forKey:@"img10"];
        [[galleryListMA objectAtIndex:0] setValue:img[10] forKey:@"img11"];
        [[galleryListMA objectAtIndex:0] setValue:img[11] forKey:@"img12"];
        [self didChangeValueForKey:@"galleryListMA"];
        
        NSImage *img2[12];
        
        img2[0] = [[NSImage imageNamed:@"to01.jpg"] retain];
        img2[1] = [[NSImage imageNamed:@"to02.jpg"] retain];
        img2[2] = [[NSImage imageNamed:@"to03.jpg"] retain];
        img2[3] = [[NSImage imageNamed:@"to04.jpg"] retain];
        img2[4] = [[NSImage imageNamed:@"to05.png"] retain];
        img2[5] = [[NSImage imageNamed:@"to06.jpg"] retain];
        img2[6] = [[NSImage imageNamed:@"to07.gif"] retain];
        img2[7] = [[NSImage imageNamed:@"to08.jpg"] retain];
        img2[8] = [[NSImage imageNamed:@"to09.jpg"] retain];
        img2[9] = [[NSImage imageNamed:@"to10.png"] retain];
        img2[10] = [[NSImage imageNamed:@"to11.jpg"] retain];
        img2[11] = [[NSImage imageNamed:@"to12.jpg"] retain];
        
        dict = [NSMutableDictionary new];
        [dict setValue:@"とある科学の超電磁砲" forKey:@"name"];
        [self willChangeValueForKey:@"galleryListMA"];
        [galleryListMA addObject:dict];
        [[galleryListMA objectAtIndex:1] setValue:img2[0] forKey:@"img01"];
        [[galleryListMA objectAtIndex:1] setValue:img2[1] forKey:@"img02"];
        [[galleryListMA objectAtIndex:1] setValue:img2[2] forKey:@"img03"];
        [[galleryListMA objectAtIndex:1] setValue:img2[3] forKey:@"img04"];
        [[galleryListMA objectAtIndex:1] setValue:img2[4] forKey:@"img05"];
        [[galleryListMA objectAtIndex:1] setValue:img2[5] forKey:@"img06"];
        [[galleryListMA objectAtIndex:1] setValue:img2[6] forKey:@"img07"];
        [[galleryListMA objectAtIndex:1] setValue:img2[7] forKey:@"img08"];
        [[galleryListMA objectAtIndex:1] setValue:img2[8] forKey:@"img09"];
        [[galleryListMA objectAtIndex:1] setValue:img2[9] forKey:@"img10"];
        [[galleryListMA objectAtIndex:1] setValue:img2[10] forKey:@"img11"];
        [[galleryListMA objectAtIndex:1] setValue:img2[11] forKey:@"img12"];
        [self didChangeValueForKey:@"galleryListMA"];
        */
        
        
        
        
        
        
        G[0] = calloc(1, sizeof(GALLERY));
        GTop[0] = G[0];
        
        G[0]->nameTop = [@"メディアミックス" retain];
        G[0]->name = [@"img01" retain];
        G[0]->img = [[NSImage imageNamed:@"test01.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img02" retain];
        G[0]->img = [[NSImage imageNamed:@"test02.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img03" retain];
        G[0]->img = [[NSImage imageNamed:@"test03.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img04" retain];
        G[0]->img = [[NSImage imageNamed:@"test04.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img05" retain];
        G[0]->img = [[NSImage imageNamed:@"test05.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img06" retain];
        G[0]->img = [[NSImage imageNamed:@"test06.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img07" retain];
        G[0]->img = [[NSImage imageNamed:@"test07.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img08" retain];
        G[0]->img = [[NSImage imageNamed:@"test08.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img09" retain];
        G[0]->img = [[NSImage imageNamed:@"test09.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img10" retain];
        G[0]->img = [[NSImage imageNamed:@"test10.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img11" retain];
        G[0]->img = [[NSImage imageNamed:@"test11.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0]->next = calloc(1, sizeof(GALLERY));
        G[0] = G[0]->next;
        G[0]->name = [@"img12" retain];
        G[0]->img = [[NSImage imageNamed:@"test12.jpg"] retain];
        G[0]->Hscene = false;
        G[0]->background = false;
        
        G[0] = GTop[0];
        
        
        
        G[1] = calloc(1, sizeof(GALLERY));
        GTop[1] = G[1];
        
        G[1]->nameTop = [@"とある科学の超電磁砲" retain];
        G[1]->name = [@"img01" retain];
        G[1]->img = [[NSImage imageNamed:@"to01.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img02" retain];
        G[1]->img = [[NSImage imageNamed:@"to02.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img03" retain];
        G[1]->img = [[NSImage imageNamed:@"to03.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img04" retain];
        G[1]->img = [[NSImage imageNamed:@"to04.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img05" retain];
        G[1]->img = [[NSImage imageNamed:@"to05.png"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img06" retain];
        G[1]->img = [[NSImage imageNamed:@"to06.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img07" retain];
        G[1]->img = [[NSImage imageNamed:@"to07.gif"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img08" retain];
        G[1]->img = [[NSImage imageNamed:@"to08.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img09" retain];
        G[1]->img = [[NSImage imageNamed:@"to09.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img10" retain];
        G[1]->img = [[NSImage imageNamed:@"to10.png"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img11" retain];
        G[1]->img = [[NSImage imageNamed:@"to11.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img12" retain];
        G[1]->img = [[NSImage imageNamed:@"to12.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;
        
        G[1]->next = calloc(1, sizeof(GALLERY));
        G[1] = G[1]->next;
        G[1]->name = [@"img13" retain];
        G[1]->img = [[NSImage imageNamed:@"to12.jpg"] retain];
        G[1]->Hscene = false;
        G[1]->background = false;

        
        G[1] = GTop[1];
        
        [self initGalleryList];
        
    }
    
    
    

    return self;
}

-(void)initGalleryList{

    galleryListMA = [NSMutableArray new];
    
    [self willChangeValueForKey:@"galleryListMA"];
    [galleryListMA removeAllObjects];
    [self didChangeValueForKey:@"galleryListMA"];
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [dict setValue:@"すべて" forKey:@"name"];
    [self willChangeValueForKey:@"galleryListMA"];
    [galleryListMA addObject:dict];
    [self didChangeValueForKey:@"galleryListMA"];

    
    for(int i = 0;i < 2;i++){
        NSMutableDictionary* dict = [NSMutableDictionary new];
        
        [dict setValue:G[i]->nameTop forKey:@"name"];
        [self willChangeValueForKey:@"galleryListMA"];
        [galleryListMA addObject:dict];
        [self didChangeValueForKey:@"galleryListMA"];
    }

    [galleryListAC setSelectionIndex:0];
    GAclrow = 0;
    galleryNumb = 0;
    galleryMax = 0;
    
    //[self setGallery];
}

-(void)setGallery{
    
    if(GAclrow == 0){
        int cnt = 0;
        galleryMax = 0;
        for(int i = 0;i < 2;i++){
            G[i] = GTop[i];
            while (G[i]) {cnt++;
                if((cnt-1)%12 == 0) galleryMax++;
                G[i] = G[i]->next;
            }
            G[i] = GTop[i];
        }
        
        int cnt2 = 0;
        for(int i = 0;i < 2 && G[i];i++){
            G[i] = GTop[i];
            while(G[i]){
                [IV01 setImage:NULL];
                [IV02 setImage:NULL];
                [IV03 setImage:NULL];
                [IV04 setImage:NULL];
                [IV05 setImage:NULL];
                [IV06 setImage:NULL];
                [IV07 setImage:NULL];
                [IV08 setImage:NULL];
                [IV09 setImage:NULL];
                [IV10 setImage:NULL];
                [IV11 setImage:NULL];
                [IV12 setImage:NULL];
                
                [IV01 setImage:G[i]->img];
                
                G[i] = G[i]->next;cnt2++;
                if(G[i]) [IV02 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                
                if(G[i]) [IV03 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                
                if(G[i]) [IV04 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                if(G[i]) [IV05 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                if(G[i]) [IV06 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                if(G[i]) [IV07 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                if(G[i]) [IV08 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                if(G[i]) [IV09 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                if(G[i]) [IV10 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                if(G[i]) [IV11 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                
                if(G[i]) [IV12 setImage:G[i]->img];
                else {
                    G[i] = GTop[i];
                    return;
                }G[i] = G[i]->next;cnt2++;
                
                if(galleryNumb <= cnt2/12){
                    
                    G[i] = GTop[i];
                    return;
                }
            }
            
            G[i] = GTop[i];
        }
        
        
    }else if(GAclrow > 0){
        G[GAclrow-1] = GTop[GAclrow-1];
        
        int cnt = 0;
        galleryMax = 0;
        while (G[GAclrow-1]) {cnt++;
            if((cnt-1)%12 == 0) galleryMax++;
            G[GAclrow-1] = G[GAclrow-1]->next;
        }
        G[GAclrow-1] = GTop[GAclrow-1];
        
        for(int i = 1;i < galleryNumb;i++){
            
            for(int j = 0;j < 12;j++){
                G[GAclrow-1] = G[GAclrow-1]->next;
            }
        }
        
        int cnt2 = 0;
        while(G[GAclrow-1]){cnt2++;
            [IV01 setImage:NULL];
            [IV02 setImage:NULL];
            [IV03 setImage:NULL];
            [IV04 setImage:NULL];
            [IV05 setImage:NULL];
            [IV06 setImage:NULL];
            [IV07 setImage:NULL];
            [IV08 setImage:NULL];
            [IV09 setImage:NULL];
            [IV10 setImage:NULL];
            [IV11 setImage:NULL];
            [IV12 setImage:NULL];
            
            [IV01 setImage:G[GAclrow-1]->img];
            
            G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            if(G[GAclrow-1]) [IV02 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            
            if(G[GAclrow-1]) [IV03 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            
            if(G[GAclrow-1]) [IV04 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            if(G[GAclrow-1]) [IV05 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            if(G[GAclrow-1]) [IV06 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            if(G[GAclrow-1]) [IV07 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            if(G[GAclrow-1]) [IV08 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            if(G[GAclrow-1]) [IV09 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            if(G[GAclrow-1]) [IV10 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            if(G[GAclrow-1]) [IV11 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            
            if(G[GAclrow-1]) [IV12 setImage:G[GAclrow-1]->img];
            else {
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }G[GAclrow-1] = G[GAclrow-1]->next;cnt2++;
            
            if(galleryNumb <= cnt2/12){
                
                G[GAclrow-1] = GTop[GAclrow-1];
                return;
            }
        }
        G[GAclrow-1] = GTop[GAclrow-1];
    }


}

-(void)clickGL:(id)sender{

    GAclrow = [galleryListTV clickedRow];
    galleryNumb = 1;
    
    [self setGallery];

}

-(void)EventLoop:(NSTimer *)timer{

    [TF setStringValue:[NSString stringWithFormat:@"%d/%d", galleryNumb, galleryMax]];
}

-(IBAction)previous:(id)sender{
    
    if(galleryNumb > 1) galleryNumb--;
    else galleryNumb = galleryMax;
    [TF setStringValue:[NSString stringWithFormat:@"%d/%d", galleryNumb, galleryMax]];
    [self setGallery];
}
-(IBAction)next:(id)sender{
    
    if(galleryNumb < galleryMax) galleryNumb++;
    else galleryNumb = 1;
    [TF setStringValue:[NSString stringWithFormat:@"%d/%d", galleryNumb, galleryMax]];
    [self setGallery];
}

-(IBAction)radioButton:(id)sender{
}
@end
