//
//  SuggestViewDataSource.m
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

#import "SuggestViewDataSource.h"
#import "PhoneNumber.h"
#import "UISuggestingPeoplePicker.h"

@implementation SuggestViewDataSource
@synthesize phoneNumbers;
@synthesize picker;

- (id)initWithPicker:(UISuggestingPeoplePicker *)_picker {
    SuggestViewDataSource *ds = [super init];
    [ds setPhoneNumbers:[NSMutableArray arrayWithCapacity:0]];
    [ds setPicker:_picker];
    // ??? [_picker release];
    return ds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"c = %d", [phoneNumbers count]);
    return [phoneNumbers count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SuggestingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    PhoneNumber *phoneNumber = [[self phoneNumbers] objectAtIndex:indexPath.row];
    UILabel *hiddenNickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [hiddenNickLabel setText:[phoneNumber nick]];
    [hiddenNickLabel setTag:777];
    [cell addSubview:hiddenNickLabel];
    [hiddenNickLabel release];
    UILabel *hiddenPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [hiddenPhoneLabel setText:[phoneNumber phone]];
    [hiddenPhoneLabel setTag:999];
    [cell addSubview:hiddenPhoneLabel];
    [hiddenPhoneLabel release];
    ///cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@) %@", [phoneNumber nick], [phoneNumber label], [phoneNumber phone]];
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0, 200.0f, 20.0f)];
    [nickLabel setText:[phoneNumber nick]];
    [cell addSubview:nickLabel];
    [nickLabel release];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 20.f, 200.0f, 20.0f)];
    [phoneLabel setText:[NSString stringWithFormat:@"%@ %@", [phoneNumber label], [phoneNumber phone]]];
    [phoneLabel setTextColor:[UIColor lightGrayColor]];
    [cell addSubview:phoneLabel];
    [phoneLabel release];
    if ([[self picker] dataSource] != nil) {
        UIView *subview = [[[self picker] dataSource] subviewForSuggestedPerson:[phoneNumber phone]];
        if (subview != nil) {
            [subview setTag:666];
            [cell addSubview:subview];
            [subview release];
        } else {
            for (UIView *_subview in [cell subviews]) {
                if ([_subview tag] == 666) {
                    [_subview removeFromSuperview];
                    ///[_subview release];
                    break;
                }
            }
        }
    }
    return cell;
}

- (void)dealloc
{
    [phoneNumbers release];
    [super dealloc];
}

@end
