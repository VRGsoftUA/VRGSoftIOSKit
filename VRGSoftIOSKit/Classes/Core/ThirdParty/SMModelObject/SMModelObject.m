
#import "SMModelObject.h"
#import <objc/runtime.h>

static NSMutableDictionary *keyNames = nil;

@implementation SMModelObject

// Before this class is first accessed, we'll need to build up our associated metadata, basically
// just a list of all our property names so we can quickly enumerate through them for various methods.
+ (void)initialize
{
	if (!keyNames)
		keyNames = [NSMutableDictionary new];
	
	NSMutableArray *names = [NSMutableArray new];
	
	for (Class cls = self; cls != [SMModelObject class]; cls = [cls superclass])
    {
		unsigned int varCount;
		Ivar *vars = class_copyIvarList(cls, &varCount);
		
		for (int i = 0; i < varCount; i++)
        {
			Ivar var = vars[i];
			NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(var)];
			[names addObject:name];
		}
		
		free(vars);
	}
	
	keyNames[NSStringFromClass(self)] = names;
}

- (NSArray *)allKeys
{
	return keyNames[NSStringFromClass([self class])];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
		for (NSString *name in [self allKeys])
			[self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
	}
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	for (NSString *name in [self allKeys])
		[aCoder encodeObject:[self valueForKey:name] forKey:name];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	id copied = [[[self class] alloc] init];
	
    id value;
	for (NSString *name in [self allKeys])
    {
        value = [self valueForKey:name];
//#warning correct copying/mutablecopying of objects should be here
//        if ([value conformsToProtocol:@protocol(NSCopying)])
//            value = [value copy];
        
		[copied setValue:value forKey:name];
    }
	
	return copied;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
	return [[self allKeys] countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - isEqual

// Override isEqual to compare model objects by value instead of just by pointer.
- (BOOL)isEqual:(id)other
{
	if ([other isKindOfClass:[self class]])
    {
		for (NSString *name in [self allKeys])
        {
			id a = [self valueForKey:name];
			id b = [other valueForKey:name];
			
			// extra check so a == b == nil is considered equal
			if ((a || b) && ![a isEqual:b])
				return NO;
		}
		return YES;
	}
    
    return NO;
}

// Must override hash as well, this is taken directly from RMModelObject, basically
// classes with the same layout return the same number.
- (NSUInteger)hash
{
	return (NSUInteger)[self allKeys];
}

#pragma mark - Description 

- (void)writeLineBreakToString:(NSMutableString *)string withTabs:(NSUInteger)tabCount
{
	[string appendString:@"\n"];
	for (NSUInteger i = 0; i < tabCount; i++)
        [string appendString:@"\t"];
}

// Prints description in a nicely-formatted and indented manner.
- (void)writeToDescription:(NSMutableString *)description withIndent:(NSUInteger)indent
{	
	[description appendFormat:@"<%@ %p", NSStringFromClass([self class]), self];
	
	for (NSString *name in [self allKeys]) {
		
		[self writeLineBreakToString:description withTabs:indent];
		
		id object = [self valueForKey:name];
		
		if ([object isKindOfClass:[SMModelObject class]])
        {
			[object writeToDescription:description withIndent:indent+1];
		}
		else if ([object isKindOfClass:[NSArray class]])
        {
			[description appendFormat:@"%@ =", name];
			
			for (id child in object)
            {
				[self writeLineBreakToString:description withTabs:indent+1];
				
				if ([child isKindOfClass:[SMModelObject class]])
					[child writeToDescription:description withIndent:indent+2];
				else
					[description appendString:[child description]];
			}
            
        }
        else if ([object isKindOfClass:[NSDictionary class]])
        {
			[description appendFormat:@"%@ =", name];
			
			for (id key in object) {
				[self writeLineBreakToString:description withTabs:indent];
				[description appendFormat:@"\t%@ = ",key];
				
				id child = [object objectForKey:key];
				
				if ([child isKindOfClass:[SMModelObject class]])
					[child writeToDescription:description withIndent:indent+2];
				else
					[description appendString:[child description]];
			}
		}
		else
        {
			[description appendFormat:@"%@ = %@", name, object];
		}
	}
		
	[description appendString:@">"];
}

- (NSString *)description
{
	NSMutableString *description = [NSMutableString string];
	[self writeToDescription:description withIndent:1];
	return description;
}

@end
