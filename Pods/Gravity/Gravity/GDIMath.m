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

#include "GDIMath.h"
#include "math.h"
#include "stdlib.h"


#define ARC4RANDOM_MAX      0x100000000
#define FEET_PER_METERS     3.280839895

#define KILOMETERS_PER_MILE  1.609

CGFloat distanceInMilesFromLatitude1(CGFloat lat1, CGFloat long1, CGFloat lat2, CGFloat long2)
{
    /*
     var R = 6371; // km
     var dLat = (lat2-lat1).toRad();
     var dLon = (lon2-lon1).toRad();
     var lat1 = lat1.toRad();
     var lat2 = lat2.toRad();
     
     var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
     Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
     var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
     var d = R * c;
     */
    
    CGFloat radiusOfEarth = 6371.0; // km
    CGFloat dLat = degreesToRadians(lat2-lat1);
    CGFloat dLon = degreesToRadians(long2-long1);
    CGFloat rLat1 = degreesToRadians(lat1);
    CGFloat rLat2 = degreesToRadians(lat2);
    
    CGFloat a = sinf(dLat/2.f) * sinf(dLat/2.f) + sinf(dLon/2.f) * sinf(dLon/2.f) * cosf(rLat1) * cosf(rLat2);
    CGFloat c = 2.f * atan2(sqrtf(a), sqrtf(1.f-a));
    CGFloat distanceInKilometers = radiusOfEarth * c;
    CGFloat distanceInMiles = kilometersToMiles(distanceInKilometers);
    
    return distanceInMiles;
}

CGFloat kilometersToMiles(CGFloat kilometers)
{
    return kilometers / KILOMETERS_PER_MILE;
}

CGFloat milesToKilometers(CGFloat miles)
{
    return miles * KILOMETERS_PER_MILE;
}

CGPoint cartesianCoordinateFromPolar(float radius, float radians)
{
    float x,y;
    
    x = radius * cosf(radians);
    y = radius * sinf(radians);
    
    return CGPointMake(x, y);
}


// 1 foot * 1 meter/3.280839895 feet => meter
float metersToFeet(float meters)
{
    return meters * FEET_PER_METERS;
}

// 1 meter * 3.280839895 feet => feet
float feetToMeters(float feet)
{
    return feet / FEET_PER_METERS;
}


float degreesToRadians(float degrees)
{
    return degrees * M_PI / 180;
}


float radiansToDegrees(float radians)
{
    return radians * 180 / M_PI;
}


float max(float a, float b)
{
	if( a>b) return a;
	return b;
}


float min(float a, float b)
{
	if( a<b) return a;
	return b;
}


float randRange(float low, float high)
{
	return ((float)arc4random() / ARC4RANDOM_MAX * (high-low))+low;
}


float distance(float x, float y, float x2, float y2)
{
	return sqrtf(powf(x2-x, 2)+powf(y2-y, 2));
}


// Interpolate between angles.  This function takes care of cases where its correct to go the "short way"  from say, 5 degrees to 359 degrees
float degreesInterp(float angle1, float angle2, float n)
{
	
	angle1=modulus(angle1,360);
    angle2= modulus(angle2,360);
    
    if(angle1<0) angle1=360+angle1;
    if(angle2<0) angle2=360+angle2;  //Make all angles positive, 0-360
    
    if(fabs(angle1-angle2)>180 && angle1<angle2) angle1+=360;
    else if(fabs(angle1-angle2)>180 && angle2<angle1) angle2+=360;
	
	return interp(angle1, angle2, n);
}


float modulus(float a, float b)
{
	int result = (int)( a / b );
	return a - (float)( result ) * b;
}


float knotsToMPH(float knots)
{
	return knots*1.15077945;
}


float knotsToKPH(float knots)
{
	return knots*1.852;	
}


float inchesToCM(float in)
{
	return in*2.54;	
}


float farenheitToCelsius(float f)
{
	return((f - 32.0) * (5./9.) );
}


float celsiusToFarenheit(float c)
{
	return (c * (9./5.)) + 32.;
}


float clamp(float input, float low, float high)
{
	if(input<low) input=low;
	else if(input>high) input=high;
	return input;
}


float interp(float low,float high, float n)
{
	return low+  ((high-low)*n);
}
