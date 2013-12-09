//
//  GDIMath.h
//  GDI iOS Core
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of 
//  this software and associated documentation files (the "Software"), to deal in the 
//  Software without restriction, including without limitation the rights to use, 
//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
//  Software, and to permit persons to whom the Software is furnished to do so, 
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all 
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN 
//  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#import <UIKit/UIKit.h>

CGFloat distanceInMilesFromLatitude1(CGFloat lat1, CGFloat long1, CGFloat lat2, CGFloat long2);
CGFloat kilometersToMiles(CGFloat kilometers);
CGFloat milesToKilometers(CGFloat miles);

CGPoint cartesianCoordinateFromPolar(float radius, float radians);

float metersToFeet(float meters);
float feetToMeters(float feet);

float degreesToRadians(float degrees);
float radiansToDegrees(float radians);
float randRange(float low, float high);
float interp(float low,float high, float n);
float clamp(float input, float low, float high);
float modulus(float a, float b);
float degreesInterp(float angle1, float angle2, float n);
float farenheitToCelsius(float f);
float celsiusToFarenheit(float c);
float inchesToCM(float in);
float knotsToMPH(float knots);
float knotsToKPH(float knots);
float distance(float x, float y, float x2, float y2);

float max(float a, float b);
float min(float a, float b);