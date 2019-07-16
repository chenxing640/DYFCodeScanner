//
//  UIButton+Additional.m
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018 dyf. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "UIButton+Additional.h"

const VVBorder VVBorderNull = {0, nil};

@implementation UIButton (Additional)

- (ClipCornerBlock)addCorner {
    ClipCornerBlock block = ^(UIRectCorner rc, UIColor *fillColor, CGFloat cornerRadius, VVBorder border) {
        CGSize radii = CGSizeMake(cornerRadius, cornerRadius);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rc cornerRadii:radii];
        
        UIImage *image = nil;
        
        if (@available(iOS 10.0, *)) {
            
            UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:self.bounds.size];
            
            image = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
                CGContextSetFillColorWithColor(rendererContext.CGContext, fillColor.CGColor);
                CGContextSetStrokeColorWithColor(rendererContext.CGContext, border.color.CGColor);
                CGContextSetLineWidth(rendererContext.CGContext, border.width);
                [path addClip];
                CGContextAddPath(rendererContext.CGContext, path.CGPath);
                CGContextDrawPath(rendererContext.CGContext, kCGPathFillStroke);
            }];
            
        } else {
            
            UIGraphicsBeginImageContext(self.bounds.size);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(context, fillColor.CGColor);
            CGContextSetStrokeColorWithColor(context, border.color.CGColor);
            CGContextSetLineWidth(context, border.width);
            [path addClip];
            CGContextAddPath(context, path.CGPath);
            CGContextDrawPath(context, kCGPathFillStroke);
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundImage:image forState:UIControlStateNormal];
    };
    
    return block;
}

@end
