//
//  UISuggestingPeoplePicker.h
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

#import <UIKit/UIKit.h>

/*
 * If you want to decorate each table cell containing suggested person with a sub view,
 * you will need to define a class implementing this protocol,
 * then create an instance of it and set it into the picker instance using [setSuggestedPersonDecorator:].
 */
@protocol SuggestedPersonDecorator <NSObject>

/*
 * Return:
 * (UIView *) A view to be embeded into the table cell containing the phone number, or nil to do nothing.
 * Parameter(s):
 *   phone (NSString *) The phone number contained in the table cell.
 */
- (UIView *)subviewToDecorate:(NSString *)phone;

@end

@class PickerCoreView;

/*
 * Create an instance of this class in method 'viewDidLoad' of your UIViewController.
 */
@interface UISuggestingPeoplePicker : UIView {
    /*
     * Private member field. No needs to touch.
     */
    PickerCoreView *core;
    id <SuggestedPersonDecorator> suggestedPersonDecorator;
}

/*
 * The callback class instance to be called on rendering each suggested person.
 */
@property (nonatomic, retain) id <SuggestedPersonDecorator> suggestedPersonDecorator;

/*
 * The only initializing method.
 * Return:
 * (id) The initialized instance.
 * Parameter(s):
 *   y (CGFloat) Top position of the picker view.
 *   height (CGFloat) Height of the picker view.
 *   controller (UIViewController *) The controller to setup the picker view.
 */
- (id)initWithY:(CGFloat)y andHeight:(CGFloat)height byController:(UIViewController *)controller;

/*
 * Call this method in method 'viewWillAppear:' of your controller.
 */
- (void)display;

/*
 * Call this method in where you want to clear or dismiss the view.
 */
- (void)clear;

/*
 * Call this method in where you want to check the phone numbers the user selected.
 * Parameter(s):
 *   selected (NSMutableArray *) The array to be fulfilled with selected phone numbers.
 */
- (void)fulfillSelected:(NSMutableArray *)selected;

@end
