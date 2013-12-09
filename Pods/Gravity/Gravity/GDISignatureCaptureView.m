//
//  GDISignatureCaptureView.m
//  GDI iOS Core
//
//  Created by Grant Davis on 5/14/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDISignatureCaptureView.h"
#import "UIView+GDIAdditions.h"

@interface GDISignatureCaptureView() {
    NSMutableArray *_points;
    CGMutablePathRef _signaturePath;
    CGMutablePathRef _linePath;
}

- (void)initialize;

// utility methods for creating splines
NSArray* splineInterpolatePoints(NSArray *sourceArr, NSInteger smoothingSteps);
CGPoint spline(CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3, CGFloat t);

@end

@implementation GDISignatureCaptureView
@synthesize strokeWidth;
@synthesize strokeColor;
@synthesize smoothing;

#pragma mark - Setup & Teardown

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    self.clearsContextBeforeDrawing = NO;
    
    _signaturePath = CGPathCreateMutable();
    strokeWidth = 2.f;
    strokeColor = [UIColor blackColor];
    smoothing = 5;
}


- (void)dealloc
{
    CGPathRelease(_signaturePath);
    CGPathRelease(_linePath);
}

#pragma mark - Public Methods

- (UIImage*)imageOfSignature
{
	return [self imageOfView];
}


- (void)clear
{
    CGPathRelease(_signaturePath);
    _signaturePath = CGPathCreateMutable();
    [self setNeedsDisplay];
}


- (BOOL)hasSignature
{
    return !CGPathIsEmpty(_signaturePath);
}


#pragma mark - Overrides

- (void)setStrokeWidth:(CGFloat)aStrokeWidth
{
    strokeWidth = aStrokeWidth;
    [self setNeedsDisplay];
}


- (void)setStrokeColor:(UIColor *)aStrokeColor
{
    strokeColor = aStrokeColor;
    [self setNeedsDisplay];
}


- (void)setSmoothing:(NSUInteger)aSmoothing
{
    smoothing = aSmoothing;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
    CGContextSetLineWidth(ctx, strokeWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextAddPath(ctx, _signaturePath);
    if (_linePath) {
        CGContextAddPath(ctx, _linePath);
    }
    CGContextStrokePath(ctx);
}


- (void)addTouch:(CGPoint)touchPoint
{
    // add point to storage
    [_points addObject:[NSValue valueWithCGPoint:touchPoint]];
    
    // interpolate our points to create a new path 
    NSArray *interpolatedPoints = splineInterpolatePoints(_points, smoothing);
    CGMutablePathRef path = CGPathCreateMutable();
    
    // move to the first point
    CGPoint firstPoint = [[interpolatedPoints objectAtIndex:0] CGPointValue]; 
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    
    // then add the interpoolated points to create the path lines
    for (int i=1; i< interpolatedPoints.count; i++) {
        CGPoint point = [[interpolatedPoints objectAtIndex:i] CGPointValue];
        CGPathAddLineToPoint(path, NULL, point.x, point.y);
    }
    // set the new path as our line path
    _linePath = path;
}


#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        
        // create new points array for this line
        _points = [NSMutableArray array];
        
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        [_points addObject:[NSValue valueWithCGPoint:touchPoint]];
    }
    if ([touches count] == 3) {
        [self clear];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        [self addTouch:touchPoint];
        [self setNeedsDisplay];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        [self addTouch:touchPoint];
        
        // add the smoothed path to the final signature path
        CGPathAddPath(_signaturePath, NULL, _linePath);
        
        // remove the temporary path
        CGPathRelease(_linePath);
        _linePath = nil;
        
        // refresh the display
        [self setNeedsDisplay];
        _points = nil;
    }
}



NSArray* splineInterpolatePoints(NSArray *sourceArr, NSInteger smoothingSteps)
{
    smoothingSteps = smoothingSteps < 0 ? 1 : smoothingSteps;
    NSMutableArray *interpolatedPoints = [NSMutableArray arrayWithCapacity:sourceArr.count];
    for (int i=0; i < sourceArr.count; i++) {
        CGPoint p0 = [[sourceArr objectAtIndex:fmax(i - 1, 0)] CGPointValue];
        CGPoint p1 = [[sourceArr objectAtIndex:i] CGPointValue];
        CGPoint p2 = [[sourceArr objectAtIndex:fminf((i + 1), sourceArr.count-1)] CGPointValue];
        CGPoint p3 = [[sourceArr objectAtIndex:fminf((i + 2), sourceArr.count-1)] CGPointValue];
        
        for (int j=0; j<smoothingSteps; j++) {
            CGFloat progress = (float)j / (float)smoothingSteps;
            CGPoint interpolatedPoint = spline(p0, p1, p2, p3, progress);
            [interpolatedPoints addObject:[NSValue valueWithCGPoint:interpolatedPoint]];
        }
    }
    return interpolatedPoints;
}


// spline adapted for use with objective-c from:
// http://www.mvps.org/directx/articles/catmull/
CGPoint spline(CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3, CGFloat t)
{
    return CGPointMake( 0.5 * ((2*p1.x) + t * (( -p0.x + p2.x) +
                                               t * ((2*p0.x -5*p1.x + 4*p2.x - p3.x) +
                                                    t * (-p0.x + 3*p1.x - 3*p2.x + p3.x)))), 
                       0.5 * ((2 * p1.y) + t * (( -p0.y + p2.y) +
                                                t * ((2*p0.y -5*p1.y +4*p2.y -p3.y) +
                                                     t * (  -p0.y +3*p1.y -3*p2.y +p3.y)))));
}

@end
