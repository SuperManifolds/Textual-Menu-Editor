/*
    TPI_MenuEditor.m
    MenuEditor
 
 
    Copyright (c) 2013 Delexious.com
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Delexious nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
    THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "TPI_MenuEditor.h"
#import "TPI_MenuEditor_MenuController.h"
#import "TPI_MenuEditor_MenuItem.h"

@interface AppDelegate : NSObject 

@end

@implementation TPI_MenuEditor
NSUserDefaults *userDefaults;
NSMenu *textualMenu;

- (void)pluginLoadedIntoMemory:(IRCWorld *)world {
    textualMenu = self.masterController.userControlMenu;
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self buildMenu];
}

- (NSMenu*)traverseMenuItem:(TPI_MenuEditor_MenuItem *)item {
    NSMenu *mMenu;
    for (TPI_MenuEditor_MenuItem *child in [item children]) {
        if (child.isSubmenuItem) {
            id mChild = [self traverseMenuItem:child];
            NSMenuItem *subMenuItem = [[NSMenuItem alloc] init];
            [subMenuItem setTitle:child.title];
            [subMenuItem setKeyEquivalent:NSStringEmptyPlaceholder];
            [subMenuItem setSubmenu: mChild];
            [mMenu addItem:subMenuItem];
        } else {
            NSMenuItem *newMenuItem = [[NSMenuItem alloc] init];
            [newMenuItem setTitle:child.title];
            [newMenuItem setKeyEquivalent:NSStringEmptyPlaceholder];
            [newMenuItem setRepresentedObject:child.commands];
            [newMenuItem setTarget:self.masterController.menuController];
            [newMenuItem setAction:@selector(postMenuMessage:)];
            [mMenu addItem:newMenuItem];
        }
    }
    return mMenu;
}

- (void)buildMenu {
    if([userDefaults objectForKey:@"userMenu"]) {
        for (TPI_MenuEditor_MenuItem *child in [[userDefaults objectForKey:@"userMenu"] children]) {
            if (child.isSubmenuItem) {
                id mChild = [self traverseMenuItem:child];
                NSMenuItem *subMenuItem = [[NSMenuItem alloc] init];
                [subMenuItem setTitle:child.title];
                [subMenuItem setKeyEquivalent:NSStringEmptyPlaceholder];
                [subMenuItem setSubmenu: mChild];
                [textualMenu addItem:subMenuItem];
            } else {
                NSMenuItem *newMenuItem = [[NSMenuItem alloc] init];
                [newMenuItem setTitle:child.title];
                [newMenuItem setKeyEquivalent:NSStringEmptyPlaceholder];
                [newMenuItem setRepresentedObject:child.commands];
                [newMenuItem setTarget:self.masterController.menuController];
                [newMenuItem setAction:@selector(postMenuMessage:)];
                [textualMenu addItem:newMenuItem];
            }
        }
        self.masterController.userControlMenu = textualMenu;
    } else {
    }
}

- (NSView *)preferencesView {
    if (self.ourView == nil) {
        if ([NSBundle loadNibNamed:@"PreferencePane" owner:self] == NO) {
            NSLog(@"TPI_MenuEditor: Failed to load view.");
        }
    }
    
    return self.ourView;
}

- (NSString *)preferencesMenuItemName {
    return @"Menu Editor";
}

@end
