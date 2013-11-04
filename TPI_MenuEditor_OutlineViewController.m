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
- (IBAction)sheetSubmenuCheckboxClicked:(id)sender;

    //@property (nonatomic, unsafe_unretained) IBOutlet NSWindow *editItemWindow;
    @property (strong) IBOutlet NSWindow *editItemWindow;
    @property (nonatomic) IBOutlet NSTextField *titleField;
    @property (nonatomic) IBOutlet NSTokenField *commandsField;
    @property (nonatomic) IBOutlet NSTokenField *selectedUserToken;
    @property (nonatomic) IBOutlet NSTokenField *currentChannelToken;
    @property (nonatomic) IBOutlet NSTokenField *activeNetworkToken;
    @property (strong) NSOutlineView *outlineView;
    @property (copy) NSMutableArray *menuItems;
    @property (nonatomic) NSButton *addItemButton;
    @property (nonatomic) NSButton *removeItemButton;
    @property (nonatomic) NSButton *sheetCancelButton;
    @property (nonatomic) NSButton *sheetSaveButton;
    @property (nonatomic) NSButton *sheetSubmenuCheckbox;
@end

@implementation TPI_MenuEditor_OutlineViewController

@synthesize addItemButton;
@synthesize removeItemButton;
@synthesize sheetCancelButton;
@synthesize sheetSaveButton;
@synthesize sheetSubmenuCheckbox;
@synthesize outlineView;
@synthesize titleField;
@synthesize commandsField;
@synthesize selectedUserToken;
@synthesize currentChannelToken;
@synthesize activeNetworkToken;

NSArray *tokenIdentifiers;

- (id)init {
    if (self) {
        tokenIdentifiers = @[ @"Selected User", @"Current Channel", @"Active Network"];
        [commandsField setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
        [selectedUserToken setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
        [currentChannelToken setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
        [activeNetworkToken setTokenizingCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
        [selectedUserToken setStringValue:@"%Selected User,"];
        [currentChannelToken setStringValue:@"%Current Channel,"];
        [activeNetworkToken setStringValue:@"%Active Network,"];
        _menuItems = [[NSMutableArray alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if([userDefaults objectForKey:@"userMenu"]) {
            [_menuItems addObjectsFromArray: [userDefaults objectForKey:@"userMenu"]];
        }
    }
    
    return self;
}

- (void)addItem {
    [NSApp beginSheet:[self editItemWindow]
       modalForWindow:[addItemButton window]
        modalDelegate:self
       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
    
	[self.editItemWindow makeFirstResponder:[self titleField]];
    id selectedItem = [outlineView itemAtRow:[outlineView selectedRow]];
    if (selectedItem) {
        [titleField setStringValue:[selectedItem title]];
        if ([selectedItem isSubmenuItem]) {
            [sheetSubmenuCheckbox setState:NSOnState];
        } else {
            [commandsField setStringValue:[[selectedItem commands] componentsJoinedByString:[NSString stringWithFormat: @"%C", (UniChar)NSLineSeparatorCharacter]]];
        }
    } else {
        
    }
}

#pragma mark NSTokenField Delegate Methods


    // Copyright (c) 2013, Tobias Pollmann (foldericon)
    // All rights reserved.

- (NSArray *)separateStringIntoTokens:(NSString *)string
{
    NSMutableArray *tokens = [NSMutableArray array];
    int i = 0;
    while (i < [string length]) {
        unsigned int start = i;
        
        if ([[string substringFromIndex:i] hasPrefix:@"%"]) {
            for (; i < [string length]; i++) {
                if ([[string substringFromIndex:(i + 1)] hasPrefix:@"%"]) {
                    i++;
                    break;
                }
            }
        } else {
            for (; i < [string length]; i++) {
                if ([[string substringFromIndex:(i + 1)] hasPrefix:@"%"]) {
                    i++;
                    break;
                }
            }
        }
        [tokens addObject:[string substringWithRange:NSMakeRange(start, i - start)]];
    }
    
    return tokens;
}

- (NSString *)tokenField:(NSTokenField *)tokenField displayStringForRepresentedObject:(id)representedObject {
    return [representedObject substringFromIndex:1];
}

- (NSTokenStyle)tokenField:(NSTokenField *)tokenField styleForRepresentedObject:(id)representedObject {
	if ([representedObject hasPrefix:@"%"]) {
		return NSRoundedTokenStyle;
	}
	return NSPlainTextTokenStyle;
}

- (NSArray *)tokenField:(NSTokenField *)tokenField shouldAddObjects:(NSArray *)tokens atIndex:(NSUInteger)index {
	NSString *tokenString = [tokens componentsJoinedByString:@""];
    return [self separateStringIntoTokens:tokenString];
}

- (id)tokenField:(NSTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString {
    return editingString;
}

- (NSString *)tokenField:(NSTokenField *)tokenField editingStringForRepresentedObject:(id)representedObject {
    return nil;
}

- (NSArray *)tokenField:(NSTokenField *)tokenField readFromPasteboard:(NSPasteboard *)pboard {
    return [self separateStringIntoTokens:[pboard stringForType:NSStringPboardType]];
}

- (BOOL)tokenField:(NSTokenField *)tokenField writeRepresentedObjects:(NSArray *)objects toPasteboard:(NSPasteboard *)pboard {
    [pboard setString:[objects componentsJoinedByString:@""] forType:NSStringPboardType];
    return YES;
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

#pragma mark Events

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	[sheet close];
}

-  (void)removeItemButtonClick:(id)sender {
}


- (void)addItemClicked:(id)sender {
    [self addItem];
}

- (void)sheetCancelClicked:(id)sender {
    [NSApp endSheet:self.editItemWindow];
}

- (void)sheetSaveClicked:(id)sender {
    [NSApp endSheet:self.editItemWindow];
}

- (void)sheetSubmenuCheckboxClicked:(id)sender {
    if ([sender state] == NSOnState) {
        [commandsField setEnabled:NO];
        [commandsField setStringValue: @""];
    } else {
        [commandsField setEnabled:YES];
    }
}

@end
