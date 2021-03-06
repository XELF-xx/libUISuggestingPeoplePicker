//
//  SuggestViewDelegate.m
//  UISuggestingPeoplePicker
//
//  Created by Evan Wu on 11-6-10.
//  Copyright (c) 2011, =XELF=
//  All rights reserved.
//  
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of =XELF= nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//  
//  THIS SOFTWARE IS PROVIDED BY =XELF= AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL =XELF= BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "SuggestViewDelegate.h"
#import "PickerCoreView.h"

@implementation SuggestViewDelegate
@synthesize core;

- (SuggestViewDelegate *) initWithCoreView:(PickerCoreView *)theCore {
    self = [super init];
    [self setCore:theCore];
    return self;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *nick = NULL;
    NSString *phone = NULL;
    for (UIView *subview in cell.subviews) {
        if ([subview tag] == 777) {
            nick = [((UILabel *) subview) text];
        } else if ([subview tag] == 999) {
            phone = [((UILabel *) subview) text];
        }
    }
    [core addContact:nick withPhoneNumber:phone];
    [[core textField] setText:@""];
    return nil;
}

- (void)dealloc
{
    [core release];
    [super dealloc];
}

@end
