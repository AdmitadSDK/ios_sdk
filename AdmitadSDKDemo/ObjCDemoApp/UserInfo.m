//
//  UserInfo.m
//  fff
//
//  Created by Dmitry Cherednikov on 09/11/2017.
//  Copyright © 2017 Tachos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

const NSString *userName = @"Peter Parker";
const NSString *userId = @"123";


@implementation UserInfo

+ (NSString *)userName {

    return [userName copy];
}

+ (NSString *)userId {

    return [userId copy];
}

@end
