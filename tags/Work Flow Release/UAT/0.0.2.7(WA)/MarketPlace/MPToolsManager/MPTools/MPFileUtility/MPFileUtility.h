//
//  MPFileUtility.h
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/16/16.
//
//

#import <Foundation/Foundation.h>

@interface MPFileUtility : NSObject

+ (NSString *) getDocumentDirectory;

//This function does not check for file existence from given path
+ (NSString *) getFileNameFromFilePath:(NSString *)fileFullPath;

//This function does not check for file existence from given path
+ (NSString *) getDirecoryPathFromFilePath:(NSString *)fileFullPath;

+ (BOOL) isFileExist:(NSString *)filePath;

//return unique name
// it is just added for getting unique name
+ (NSString *) getUniqueFileName;
+ (NSString *) getUniqueFileNameWithExtension:(NSString*)extension;

/******************************************************
// Following functions are working on cache directory 
// present in Document Directory
******************************************************/

// this will be one time  task
// return true if creation succeeds
// return false if creation fails or directory is exists
// check log error for creation fails
+ (BOOL) createRootCacheDirectory;

// THIS WILL CLEAR ALL CONTENTS OF CACHE DIRECTORY
// CLEARNING POLICY NEEDS TO BE SET
+ (BOOL) clearCacheContent;


// This function returns nil if cache directory is not found
+ (NSString *) getCacheRootDirectory;


// These functions will return full path or URL with respective to cache directory
// client will use these return values to store their content
// if filename is not provided it will create unique file name using getUniqueFileName method
+ (NSString *) generateCacheFilePath:(NSString *)fileName;
+ (NSURL *) generateCacheFileURL:(NSString *)fileName;

// this will write data to file in cache directory
// return path otherwise nil if fails
// if filename is not given it will generate it
+ (NSString *) writeData:(NSData *)fileData
                fileName:(NSString *)fileName;

// this will write data to file in cache directory
// return path otherwise nil if fails
// if filename is not given it will generate it
+ (NSString *) writeImage:(UIImage *)image
                 withName:(NSString *)fileName
      isPNGRepresentation:(BOOL)bPNG;

+ (NSString *) writeImage:(UIImage *)image
                 withName:(NSString *)fileName andCompression:(CGFloat)compression;


+ (NSString *) getFilePath:(NSString *)fileName;
+ (BOOL) removeFile:(NSString *)filePath;
+ (NSArray <NSString *> *) getAllFilesFromCache;

+ (BOOL) isDirectoryExist:(NSString *)fileFullPath;

/******************************************************
 // Following functions are working on folder in 
 // the Document directory
*******************************************************/

+ (BOOL) isFolderExistInDocDir:(NSString *)folderName;

+ (NSString *) saveData:(NSData *)data
            inDocFolder:(NSString *)folderName
           withFileName:(NSString *)fileName;
+ (BOOL) removeFile:(NSString *)fileName
      fromDocFolder:(NSString *)folderName;
+ (NSString *) createFolderInDocDir:(NSString *) folderName;
+ (BOOL) removeFolderFromDocDir:(NSString *)folderName;

@end
