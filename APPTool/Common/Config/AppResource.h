//
//  PathMacro.h
//  APPTool
//
//  Created by liu gangyi on 2018/6/8.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#ifndef PathMacro_h
#define PathMacro_h

/// doc沙盒.
#define kDocPath         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

/// Liberay.
#define kLibraryPath     [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

/// cache沙盒.
#define kCachPath        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, \
NSUserDomainMask, YES) objectAtIndex:0]

/// temp沙盒.
#define kTmpPath          NSTemporaryDirectory()

// 资源路径
#define kDB_PARH @"/DataBase"

#endif /* PathMacro_h */
