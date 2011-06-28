//
//  UISuggestingPeoplePicker.m
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

#import "UISuggestingPeoplePicker.h"
#import "AddressBook/ABPerson.h"
#import "ContactPickerDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ContactRemovingButton.h"
#import "SuggestViewDataSource.h"
#import "SuggestViewDelegate.h"
#import "PhoneNumber.h"

@implementation UISuggestingPeoplePicker
@synthesize viewController;
@synthesize scrollView;
@synthesize contactRemovingButtons;
@synthesize textField;
@synthesize contactPickerController;
@synthesize suggestView;
@synthesize suggestViewDataSource;
@synthesize tableShadow;
@synthesize dataSource;

- (void)dealloc
{
    // ???
    [dataSource release];
    [tableShadow release];
    [suggestViewDataSource release];
    [suggestView release];
    [contactPickerController release];
    [textField release];
    [contactRemovingButtons removeAllObjects];
    [contactRemovingButtons release];
    [scrollView release];
    // ???
    [viewController release];
    [super dealloc];
}

- (id)initWithY:(CGFloat)y andHeight:(CGFloat)height byController:(UIViewController *)controller {
    self = [super initWithFrame:CGRectMake(0, y, 320.0f, height)];
    if (self) {
        [self setViewController:controller];
        NSMutableArray *theContactRemovingButtons = [NSMutableArray arrayWithCapacity:0];
        [self setContactRemovingButtons:theContactRemovingButtons];
        ///[theContactRemovingButtons release];
        [self setContactPickerController:[[[ABPeoplePickerNavigationController alloc] init] autorelease]];
        [contactPickerController setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]]];
        ContactPickerDelegate *contactPickerDelegate = [[ContactPickerDelegate alloc] init];
        [contactPickerDelegate setSuggestingPeoplePicker:self];
        [contactPickerController setPeoplePickerDelegate:contactPickerDelegate];
        [self setSuggestViewDataSource:[[SuggestViewDataSource alloc] initWithPicker:self]];
        [self setBackgroundColor:[UIColor whiteColor]];
        ///theEditor.frame = CGRectMake(0.0f, theEditor.frame.origin.y, 320.0f, 244.0f - theActor.frame.size.height - theEditor.frame.origin.y);
        ///theActor.frame = CGRectMake(theActor.frame.origin.x, 244.0f - theActor.frame.size.height, theActor.frame.size.width, theActor.frame.size.height);
        UITableView *theSuggestView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 31.0f, 320.0f, self.frame.size.height - 31.0f)];
        [theSuggestView setDataSource:[self suggestViewDataSource]];
        [theSuggestView setDelegate:[[SuggestViewDelegate alloc] initWithSuggestingPeoplePicker:self]];
        [self addSubview:theSuggestView];
        [self setSuggestView:theSuggestView];
        UIScrollView *theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 288.0f, 31.0f)];
        [theScrollView setBackgroundColor:[UIColor whiteColor]];
        [theScrollView setContentSize:CGSizeMake(288.0f, 31.0f)];
        [theScrollView setBounces:NO];
        [self addSubview:theScrollView];
        CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
        newShadow.frame = CGRectMake(0, 31.0f, 320, 20);
        CGColorRef darkColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4].CGColor;
        CGColorRef lightColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
        newShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil];
        [self setTableShadow:newShadow];
        [self.layer insertSublayer:newShadow atIndex:10];
        ///[scrollView release];
        UIButton *contactSelector = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [contactSelector setFrame:CGRectMake(290.0f, 2.0f, contactSelector.frame.size.width, contactSelector.frame.size.height)];
        [contactSelector addTarget:self action:@selector(showContacts:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:contactSelector];
        ///[contactSelector release];
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 288.0f, 31.0f)];
        [theTextField setKeyboardType:UIKeyboardTypeNamePhonePad];
        [theTextField setBackgroundColor:[UIColor whiteColor]];
        [theTextField setDelegate:self];
        [theTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
        [theTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [theScrollView addSubview:theTextField];
        [self setTextField:theTextField];
        ///[textView release];
        [self setScrollView:theScrollView];
    }
    return self;
}

- (void)display {
    [[self textField] becomeFirstResponder];
}

- (void)clear {
    for (ContactRemovingButton *theContactRemovingButton in [self contactRemovingButtons]) {
        [theContactRemovingButton.button removeFromSuperview];
    }
    [[self contactRemovingButtons] removeAllObjects];
    [[self textField] setText:@""];
    [[self suggestView] setFrame:CGRectMake(0.0f, 31.0f, 320.0f, self.frame.size.height - 31.0f)];
    [self tableShadow].frame = CGRectMake(0, 31.0f, 320, 20);
    [[self scrollView] setFrame:CGRectMake(0.0f, 0.0f, 288.0f, 31.0f)];
    [[self scrollView] setContentSize:CGSizeMake(288.0f, 31.0f)];
    [[self textField] setFrame:CGRectMake(0.0f, 0.0f, 288.0f, 31.0f)];
}

- (void)fulfillSelected:(NSMutableArray *)selected {
    [self textFieldShouldReturn:NULL];
    [selected removeAllObjects];
    for (ContactRemovingButton *button in [self contactRemovingButtons]) {
        NSString *phone = [button phone];
        [selected addObject:phone];
    }
}

- (void)textFieldDidChange {
    NSString *newText = [[self textField].text stringByReplacingOccurrencesOfString:@"\u2006" withString:@""];
    ///- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    ///NSString *newText = [[self textField].text stringByReplacingCharactersInRange:range withString:string];
    [[[self suggestViewDataSource] phoneNumbers] removeAllObjects];
    if ([newText length] > 0) {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        NSArray *people = (NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
        if ( people!=nil ) {
            for ( NSUInteger i=0; i<[people count]; i++ ) {
                ABRecordRef person = (ABRecordRef)[people objectAtIndex:i];
                NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
                NSLog(@"Typed %@, comparing %@ %@ and got %d %d", newText, firstName, lastName, [firstName rangeOfString:newText].location, [lastName rangeOfString:newText].location);
                if ((firstName && [firstName length] > 0 && [firstName rangeOfString:newText].location != NSNotFound)
                    || (lastName && [lastName length] > 0 && [lastName rangeOfString:newText].location != NSNotFound)) {
                    ABMutableMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    CFIndex phoneNumberCount = ABMultiValueGetCount( phoneNumbers );
                    NSLog(@"p = %ld", phoneNumberCount);
                    for ( NSUInteger k=0; k<phoneNumberCount; k++ )
                    {
                        CFStringRef phoneNumberLabel = ABMultiValueCopyLabelAtIndex( phoneNumbers, k );
                        CFStringRef phoneNumberValue = ABMultiValueCopyValueAtIndex( phoneNumbers, k );
                        NSLog(@"pn = %@", phoneNumberValue);
                        CFStringRef phoneNumberLocalizedLabel = ABAddressBookCopyLocalizedLabel( phoneNumberLabel );
                        [[[self suggestViewDataSource] phoneNumbers] addObject:[[PhoneNumber alloc] initWithFirstName:firstName lastName:lastName label:(NSString *) phoneNumberLocalizedLabel andPhone:(NSString *) phoneNumberValue]];
                        CFRelease(phoneNumberLocalizedLabel);
                        CFRelease(phoneNumberLabel);
                        CFRelease(phoneNumberValue);
                    }
                }
            }
            [people release];
        }
        CFRelease(addressBook);
    }
    [[self suggestView] reloadData];
    if ([[[self suggestViewDataSource] phoneNumbers] count] > 0) {
        CGFloat newContentHeight = 31.0f;
        [[self suggestView] setFrame:CGRectMake(0.0f, newContentHeight, 320.0f, self.frame.size.height - newContentHeight)];
        [self tableShadow].frame = CGRectMake(0, newContentHeight, 320, 20);
        [[self scrollView] setCenter:CGPointMake([[self scrollView] center].x, newContentHeight - [[self scrollView] frame].size.height / 2)];
        ///[[self scrollView] setFrame:CGRectMake(0.0f, 0.0f, 288.0f, newContentHeight)];
        [[self scrollView] setScrollEnabled:NO];
    } else {
        CGFloat newContentHeight = [self scrollView].contentSize.height;
        if (newContentHeight > self.frame.size.height) {
            newContentHeight = floor(self.frame.size.height / 31) * 31;
        }
        [[self suggestView] setFrame:CGRectMake(0.0f, newContentHeight, 320.0f, self.frame.size.height - newContentHeight)];
        [self tableShadow].frame = CGRectMake(0, newContentHeight, 320, 20);
        [[self scrollView] setFrame:CGRectMake(0.0f, 0.0f, 288.0f, newContentHeight)];
        [[self scrollView] setScrollEnabled:YES];
    }
    ///return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if ([[[self textField] text] length] > 0) {
        [self addContact:nil withPhoneNumber:[[self textField] text]];
        [[self textField] setText:@""];
        return NO;
    }
    return NO;
}

- (IBAction)removeContact:(id)sender {
    NSUInteger oldButtonLineCount = [self textField].frame.origin.y / 31.0f;
    UIButton *button = (UIButton *) sender;
    [button removeFromSuperview];
    NSUInteger buttonIndex = NSNotFound;
    for (ContactRemovingButton *theContactRemovingButton in [self contactRemovingButtons]) {
        if (theContactRemovingButton.button == button) {
            buttonIndex = [[self contactRemovingButtons] indexOfObject:theContactRemovingButton];
            break;
        }
    }
    [[self contactRemovingButtons] removeObjectAtIndex:buttonIndex];
    for (NSUInteger index = buttonIndex; index < [[self contactRemovingButtons] count]; ++index) {
        ContactRemovingButton *theContactRemovingButton = (ContactRemovingButton *) [[self contactRemovingButtons] objectAtIndex:index];
        [self placeContactRemovingButton:theContactRemovingButton];
        ///[theContactRemovingButton setFrame:CGRectMake(
        ///                                              theContactRemovingButton.frame.origin.x,
        ///                                              theContactRemovingButton.frame.origin.y - 31.0f,
        ///                                              theContactRemovingButton.frame.size.width,
        ///                                              theContactRemovingButton.frame.size.height)];
    }
    NSUInteger newButtonLineCount = [[self contactRemovingButtons] count] > 0 ? (((ContactRemovingButton *) [[self contactRemovingButtons] lastObject]).button.frame.origin.y / 31.0f + 1) : 0;
    if (newButtonLineCount < oldButtonLineCount) {
        CGFloat sub = (oldButtonLineCount - newButtonLineCount) * 31.0f;
        [[self textField] setFrame:CGRectMake(
                                              [self textField].frame.origin.x,
                                              [self textField].frame.origin.y - sub,
                                              [self textField].frame.size.width,
                                              [self textField].frame.size.height)];
        
        CGFloat newContentHeight = [[self scrollView] contentSize].height - sub;
        if (newContentHeight < self.frame.size.height) {
            [[self suggestView] setFrame:CGRectMake(0.0f, newContentHeight, 320.0f, self.frame.size.height - newContentHeight)];
            [self tableShadow].frame = CGRectMake(0, newContentHeight, 320, 20);
            [[self scrollView] setFrame:CGRectMake(0.0f, 0.0f, 288.0f, newContentHeight)];
        }
        [[self scrollView] setContentSize:CGSizeMake(288.0f, newContentHeight)];
    }
}

- (IBAction)showContacts:(id) sender {
    [[self textField] resignFirstResponder];
    [viewController presentModalViewController:[self contactPickerController] animated:TRUE];
}

- (void)addContact:(NSString *)name withPhoneNumber:(NSString *)phoneNumber {
    
    ContactRemovingButton *contactRemovingButton = [ContactRemovingButton initWithNick:name andPhone:phoneNumber];
    
    contactRemovingButton.button.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:1.0f alpha:1.0f];
    contactRemovingButton.button.layer.borderColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.8f alpha:1.0f].CGColor;
    contactRemovingButton.button.layer.borderWidth = 0.5f;
    contactRemovingButton.button.layer.cornerRadius = 12.0f;
    
    [contactRemovingButton.button addTarget:self action:@selector(removeContact:) forControlEvents:UIControlEventTouchUpInside];
    
    Boolean newLine = [self placeContactRemovingButton:contactRemovingButton];
    
    [[self contactRemovingButtons] addObject:contactRemovingButton];
    
    ///[newContact release];
    
    if (newLine) {
        [[self textField] setFrame:CGRectMake(0.0f, [[self scrollView] contentSize].height, [self textField].frame.size.width, [self textField].frame.size.height)];
        
        CGFloat newContentHeight = [[self scrollView] contentSize].height + 31.0f;
        
        [[self scrollView] setContentSize:CGSizeMake(288.0f, newContentHeight)];
        
        if (newContentHeight < self.frame.size.height) {
            [[self suggestView] setFrame:CGRectMake(0.0f, newContentHeight, 320.0f, self.frame.size.height - newContentHeight)];
            
            [self tableShadow].frame = CGRectMake(0, newContentHeight, 320, 20);
            
            [[self scrollView] setFrame:CGRectMake(0.0f, 0.0f, 288.0f, newContentHeight)];
        }
        
        ///[[self scrollView] setNeedsLayout];
    }
    
    [[self textField] becomeFirstResponder];
}

- (Boolean)placeContactRemovingButton:(ContactRemovingButton *)contactRemovingButton {
    CGFloat buttonWidth = [[contactRemovingButton.button titleForState:UIControlStateNormal] sizeWithFont:[[contactRemovingButton.button titleLabel] font]
                                                                                        constrainedToSize:CGSizeMake(250.0f, 31.0f)].width + 10.0f;
    if (buttonWidth == 10.0f) {
        buttonWidth = 250.0f;
    }
    if (contactRemovingButton.button.frame.origin.x < 1) {
        [contactRemovingButton.button setFrame:CGRectMake(
                                                          5.0f,
                                                          [self textField].frame.origin.y,
                                                          buttonWidth,
                                                          25.0f)];
    }
    [[self scrollView] addSubview:contactRemovingButton.button];
    [UIView beginAnimations:@"animation" context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    CGFloat buttonX = 0.0f;
    CGFloat buttonY = 0.0f;
    Boolean newLine = NO;
    if ([[self contactRemovingButtons] count] < 1) {
        buttonX = 5.0f;
        buttonY = [[self scrollView] contentSize].height - 28.0f;
        newLine = YES;
    } else {
        ContactRemovingButton *lastButton = NULL;
        NSUInteger buttonIndex = [[self contactRemovingButtons] indexOfObject:contactRemovingButton];
        if (buttonIndex == 0) {
            buttonX = 5.0f;
            buttonY = 3.0f;
            [contactRemovingButton.button setFrame:CGRectMake(
                                                              buttonX,
                                                              buttonY,
                                                              buttonWidth,
                                                              25.0f)];
            [UIView commitAnimations];
            return NO;
        } else if (buttonIndex == NSNotFound) {
            lastButton = (ContactRemovingButton *) [[self contactRemovingButtons] lastObject];
        } else {
            lastButton = (ContactRemovingButton *) [[self contactRemovingButtons] objectAtIndex:buttonIndex - 1];
        }
        CGFloat lineSpace = 280.0f - lastButton.button.frame.origin.x - lastButton.button.frame.size.width;
        if (lineSpace >= 5.0f + buttonWidth) {
            buttonX = lastButton.button.frame.origin.x + lastButton.button.frame.size.width + 5.0f;
            buttonY = lastButton.button.frame.origin.y;
        } else {
            buttonX = 5.0f;
            buttonY = lastButton.button.frame.origin.y + 31.0f;
            newLine = YES;
        }
    }
    [contactRemovingButton.button setFrame:CGRectMake(
                                                      buttonX,
                                                      buttonY,
                                                      buttonWidth,
                                                      25.0f)];
    [UIView commitAnimations];
    return newLine;
}

@end
