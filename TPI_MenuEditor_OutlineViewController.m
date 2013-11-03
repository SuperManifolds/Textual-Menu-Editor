/*
	TPI_MenuEditor_OutlineViewController.m
	MenuEditor
 

    Copyright (c) 2013 Delexious.com
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Delexious nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
    THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "TPI_MenuEditor_OutlineViewController.h"

@interface TPI_MenuEditor_OutlineViewController ()
- (IBAction)addItemClicked:(id)sender;
- (IBAction)removeItemClicked:(id)sender;
- (IBAction)sheetCancelClicked:(id)sender;
- (IBAction)sheetSaveClicked:(id)sender;

    //@property (nonatomic, unsafe_unretained) IBOutlet NSWindow *editItemWindow;
    @property (strong) IBOutlet NSWindow *editItemWindow;
    @property (nonatomic) IBOutlet NSTextField *titleField;
    @property (strong) NSOutlineView *outlineView;
@end

@implementation TPI_MenuEditor_OutlineViewController

@synthesize addItemButton;
@synthesize removeItemButton;
@synthesize sheetCancelButton;
@synthesize sheetSaveButton;
@synthesize outlineView;


- (id)init {
    if (self) {
        _menuItems = [[NSMutableArray alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"userMenu"]) {
            [_menuItems addObjectsFromArray: [userDefaults objectForKey:@"userMenu"]];
        }
    }
    
    return self;
}

#pragma mark NSOutlineView Data Source Methods

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return !item ? [self.menuItems count] : [[item children] count];
}

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    return !item ? YES : [[item children] count] != 0;
}

-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return !item ? [self.menuItems objectAtIndex:index] : [[item children] objectAtIndex:index];
}

-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    if ([[tableColumn identifier] isEqualToString:@"title"]) {
        return [item title];
    }
    return [NSString string];
}

- (void)addItem {
    [NSApp beginSheet:self.editItemWindow
	   modalForWindow:addItemButton.window
		modalDelegate:self
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
    
	[self.editItemWindow makeFirstResponder:self.titleField];
    id selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    if (selectedItem) {
    
    }
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	[sheet close];
}

-  (void)removeItemButtonClick:(id)sender {
}


- (IBAction)addItemClicked:(id)sender {
    
    [self addItem];
}

- (IBAction)sheetCancelClicked:(id)sender {
    [NSApp endSheet:self.editItemWindow];
}

- (IBAction)sheetSaveClicked:(id)sender {
    [NSApp endSheet:self.editItemWindow];
}

@end
