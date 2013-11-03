/*
	TPI_MenuEditor_MenuItem.m
	MenuEditor


    Copyright (c) 2013 Delexious.com
    All rights reserved.
 
    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of Delexious nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
    THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "TPI_MenuEditor_MenuItem.h"

@implementation TPI_MenuEditor_MenuItem
- (id)init {
    return [self initAsMenuItem:@"MenuItem"];
}

- (id)initAsMenuItem:(NSString *)title {
    self = [super init];
    if (self) {
        _title = [title copy];
    }
    return self;
}

- (id)initAsSubMenu:(NSString *)title {
    self = [super init];
    if (self) {
        _title = [title copy];
        _children = [[NSMutableArray alloc] init];
        _isSubmenuItem = YES;
    }
    return self;
}

- (void)addChild:(TPI_MenuEditor_MenuItem *)item {
    [_children addObject:item];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.title = [decoder decodeObjectForKey:@"title"];
    self.children = [decoder decodeObjectForKey:@"children"];
    self.commands = [decoder decodeObjectForKey:@"command"];
    self.isSubmenuItem = [decoder decodeBoolForKey:@"isSubmenuItem"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.children forKey:@"children"];
    [encoder encodeObject:self.commands forKey:@"command"];
    [encoder encodeBool:self.isSubmenuItem forKey:@"isSubmenuItem"];
}

@end
