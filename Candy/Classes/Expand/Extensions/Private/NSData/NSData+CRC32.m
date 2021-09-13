//
//  NSData+CRC32.m
//  CRC32_iOS
//
//  Created by 宣佚 on 15/7/14.
//  Copyright (c) 2015年 宣佚. All rights reserved.
//

#import "NSData+CRC32.h"

@implementation NSData (CRC32)

- (uLong)getCRC32 {
    uLong crc = crc32(0L, Z_NULL, 0);
    crc = crc32(crc, self.bytes, (uint)self.length);
    return crc;
}

@end
