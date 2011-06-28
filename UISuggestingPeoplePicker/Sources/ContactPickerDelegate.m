//
//  ContactPickerDelegate.m
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

#import "ContactPickerDelegate.h"
#import <AddressBook/AddressBook.h>
#import "PickerCoreView.h"


@implementation ContactPickerDelegate
@synthesize core;

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    ABMultiValueRef phoneNumberProperty = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSArray *phoneNumbers = (NSArray *) ABMultiValueCopyArrayOfAllValues(phoneNumberProperty);
    CFRelease(phoneNumberProperty);
    if ([phoneNumbers count] == 1) {
        NSString *phoneNumber = (NSString *)[phoneNumbers objectAtIndex:0];
        [core addContact:[self getName:person] withPhoneNumber:phoneNumber];
        [peoplePicker dismissModalViewControllerAnimated:YES];
    }
	return true;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property 
							  identifier:(ABMultiValueIdentifier)identifier {
	
	CFTypeRef multiValue = ABRecordCopyValue(person, property);
	CFIndex valueIdx = ABMultiValueGetIndexForIdentifier(multiValue,identifier);
	NSString *phoneNumber = (NSString *)ABMultiValueCopyValueAtIndex(multiValue, valueIdx);
    [core addContact:[self getName:person] withPhoneNumber:phoneNumber];
    [peoplePicker dismissModalViewControllerAnimated:YES];
	/**[[LinphoneManager instance].callDelegate displayDialerFromUI:nil 
     forUser:phoneNumber 
     withDisplayName:(NSString*)ABRecordCopyCompositeName(person)];*/
	return false;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissModalViewControllerAnimated:YES];
}

- (NSString *) getName: (ABRecordRef) person
{
    NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (!lastName) return firstName;
    if (!firstName) return lastName;
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

- (void)dealloc
{
    [core release];
    [super dealloc];
}

@end
