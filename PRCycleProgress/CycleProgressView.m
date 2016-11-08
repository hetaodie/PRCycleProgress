//
//  CycleProgress.m
//  PRCycleProgress
//
//  Created by weixu on 16/11/4.
//  Copyright © 2016年 weixu. All rights reserved.
//

#import "CycleProgressView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


@interface CycleProgressView()
@property (nonatomic) double progress;

@end

@implementation CycleProgressView

#pragma mark -
#pragma mark life cycle


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)drawRect:(CGRect)rect
{
    // Calculate position of the circle
    CGFloat progressAngle;
    if (self.clockwise) {
        progressAngle = self.progress * 360.0 + self.beginAngle;
    }
    else{
        progressAngle = -self.progress * 360.0 + self.beginAngle;
    }
    
    CGPoint center = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    CGFloat radius = MIN(rect.size.width, rect.size.height) / 2.0f;
    
    CGRect square;
    if (rect.size.width > rect.size.height)
    {
        square = CGRectMake((rect.size.width - rect.size.height) / 2.0, 0.0, rect.size.height, rect.size.height);
    }
    else
    {
        square = CGRectMake(0.0, (rect.size.height - rect.size.width) / 2.0, rect.size.width, rect.size.width);
    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    
    
    if (self.showText && self.textColor)
    {
        NSString *progressString = [NSString stringWithFormat:@"%.0f%%", self.progress * 100.0];
        NSString *maxString =@"100%";
        
        CGFloat fontSize = radius;
        
        CGFloat diagonal = 2 * (radius - self.circleWidth);
        CGFloat edge = diagonal / sqrtf(2);
        
        CGSize maximumSize = CGSizeMake(edge, edge);
        
        CGSize expectedSize = [self frameForText:maxString sizeWithFont:self.textfont constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
        
        UIFont *actionPoint = [self getFontForString:maxString toFitInRect:maximumSize seedFont:self.textfont];
        
        if (actionPoint.pointSize < fontSize)
        {
            expectedSize = [self frameForText:progressString sizeWithFont:actionPoint constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        CGPoint origin = CGPointMake(center.x - expectedSize.width / 2.0, center.y - expectedSize.height / 2.0);
        
        [_textColor setFill];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        
        CGRect rect;
        rect.origin = origin;
        rect.size = expectedSize;
        NSDictionary *attributes = @{NSFontAttributeName:actionPoint,
                                     NSForegroundColorAttributeName:self.textColor,
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        
        [progressString drawInRect:rect withAttributes:attributes];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center
                                                    radius:radius
                                                startAngle:DEGREES_TO_RADIANS(self.beginAngle)
                                                  endAngle:DEGREES_TO_RADIANS(progressAngle)
                                                 clockwise:self.clockwise]];
    
    
    [path addArcWithCenter:center
                    radius:radius-self.circleWidth
                startAngle:DEGREES_TO_RADIANS(progressAngle)
                  endAngle:DEGREES_TO_RADIANS(self.beginAngle)
                 clockwise:!self.clockwise];
    
    
    
    [path closePath];
    
    if (!self.isGradual)
    {
        [self.progressFillColor setFill];
        [path fill];
    }
    else
    {
        [path addClip];
        
        NSArray *backgroundColors = @[
                                      (id)[self.progressTopGradientColor CGColor],
                                      (id)[self.progressBottomGradientColor CGColor],
                                      ];
        CGFloat backgroudColorLocations[2] = { 0.0f, 1.0f };
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGGradientRef backgroundGradient = CGGradientCreateWithColors(rgb, (__bridge CFArrayRef)(backgroundColors), backgroudColorLocations);
        CGContextDrawLinearGradient(context,
                                    backgroundGradient,
                                    CGPointMake(0.0f, square.origin.y),
                                    CGPointMake(0.0f, square.size.height),
                                    0);
        CGGradientRelease(backgroundGradient);
        CGColorSpaceRelease(rgb);
    }
    
    CGContextRestoreGState(context);
}


#pragma mark -
#pragma mark public Function

- (void)setProgressRatio:(CGFloat)aProgress{
    self.progress = MIN(1.0, MAX(0.0, aProgress)); //对穿过来的值进行保护
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark private Function

- (void)setUpData{
    self.showText = YES;
    self.clockwise = YES;
    
    self.progress = 0.0f;
    self.beginAngle = -90;
    
    self.textColor = [UIColor blackColor];
    self.textfont = [UIFont systemFontOfSize:100];
    
    self.progressFillColor = [UIColor blackColor];
    self.isGradual = NO;
    self.circleWidth = 2.0;
    
    self.progressTopGradientColor = [UIColor blackColor];
    self.progressBottomGradientColor = [UIColor blueColor];
}


-(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary * attributes = @{NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
    
    CGRect textRect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil];
    
    
    return textRect.size;
}

-(UIFont*)getFontForString:(NSString*)string
               toFitInRect:(CGSize)size
                  seedFont:(UIFont*)seedFont{
    UIFont* returnFont = seedFont;
    CGSize stringSize = [string sizeWithAttributes:@{NSFontAttributeName : seedFont}];
    
    while(stringSize.width > size.width){
        returnFont = [UIFont systemFontOfSize:returnFont.pointSize -1];
        stringSize = [string sizeWithAttributes:@{NSFontAttributeName : returnFont}];
    }
    
    return returnFont;
}

@end
