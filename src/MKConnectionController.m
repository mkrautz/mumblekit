/* Copyright (C) 2009-2010 Mikkel Krautz <mikkel@krautz.dk>

   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   - Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright notice,
     this list of conditions and the following disclaimer in the documentation
     and/or other materials provided with the distribution.
   - Neither the name of the Mumble Developers nor the names of its
     contributors may be used to endorse or promote products derived from this
     software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <MumbleKit/MKConnectionController.h>
#import <MumbleKit/MKConnection.h>

@interface MKConnectionController () {
    NSMutableArray *_openConnections;
}

- (id) init;
- (void) dealloc;

@end

@implementation MKConnectionController

- (id) init {
    if ((self = [super init])) {
        _openConnections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) dealloc {
    [_openConnections release];
    [super dealloc];
}

+ (MKConnectionController *) sharedController {
    static dispatch_once_t pred;
    static MKConnectionController *controller;

    dispatch_once(&pred, ^{
        controller = [[MKConnectionController alloc] init]; 
    });

    return controller;
}
                                
- (void) addConnection:(MKConnection *)conn {
    [_openConnections addObject:[NSValue valueWithNonretainedObject:conn]];
}

- (void) removeConnection:(MKConnection *)conn {
    [_openConnections removeObject:[NSValue valueWithNonretainedObject:conn]];
}

- (NSArray *) allConnections {
    return _openConnections;
}

@end
