//
//  SMHelper.m
//  Pro-Otdyh
//
//  Created by VRGSoft on 24.03.12.
//  Copyright (c) 2012 VRGSoft. all rights reserved.
//

#import "SMHelper.h"
#import "SMKitDefines.h"

UIViewController* SMGetPrimeViewController()
{
    UIViewController* result = nil;
    UIView* baseView = (UIView*)[UIApplication sharedApplication].keyWindow;
    if([baseView.subviews count] > 0)
    {
        baseView = [baseView.subviews objectAtIndex:0];
        result = [baseView firstAvailableUIViewController];
    }
    return result;
}

NSMutableArray* SMDivideArray(NSArray* aDividedArray, NSString* aFieldName, BOOL anAscending, SMDividedComparator aComparator)
{
	NSMutableArray* result = [NSMutableArray array];
	// sort
	NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:aFieldName ascending:anAscending];
	NSArray* sortedBOs = [aDividedArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	// divide by year,month,date
	NSMutableArray* sectionElements = nil;
	id obj1;
	id obj2;
	for(NSObject* bo in sortedBOs)
	{
		obj1 = [[sectionElements lastObject] valueForKeyPath:aFieldName];
		obj2 = [bo valueForKeyPath:aFieldName];
		if(obj2)
		{
			if(aComparator(obj1, obj2))
				[sectionElements addObject:bo];
			else
			{
				if(sectionElements)
					[result addObject:sectionElements];
				sectionElements = [NSMutableArray arrayWithObject:bo];
			}
		}
	}
	if(sectionElements)
		[result addObject:sectionElements];
	
	return result;
}

NSDate* SMDateFromTimeStampInDictionary(NSDictionary* aDictionary, NSString* aKey)
{
    NSTimeInterval timestamp = [SM_NULL_PROTECT( [aDictionary objectForKey:aKey] ) doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

NSString* SMGenerateUUID()
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString* uuid = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
    CFRelease(uuidRef);
    return uuid;
}

NSString* SMDocumentDirectoryPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

NSString* SMCacheDirectoryPath()
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

void SMHideWebViewShadows(UIWebView* webView)
{
    for (UIView* subView in [webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
}
