//
//  MPFileUtility.m
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/16/16.
//
//

#import "MPFileUtility.h"

#define MP_STORE_FOLDER @"mpstore"
#define MP_CACHE_DAYS_LIMIT 30
#define MP_CACHE_TIMESTAMP @"cachetimestamp"

@implementation MPFileUtility


#pragma mark - generic functions

//return nil if unsuccessful
+ (NSString *) getDocumentDirectory;
{
    NSString *docDir = [NSString stringWithFormat:@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    [MPFileUtility logFilepath:docDir];
    return docDir;
}


+ (NSString *) getFileNameFromFilePath:(NSString *)fileFullPath
{
    if (fileFullPath)
        return ([fileFullPath lastPathComponent]);
    
    return nil;
}


+ (NSString *) getDirecoryPathFromFilePath:(NSString *)fileFullPath
{
    if (fileFullPath)
    {
        //extract folder path from full path
        NSString *directory = fileFullPath;
        
        NSString *fileName = [directory lastPathComponent];
        
        NSRange range = [directory rangeOfString:fileName];
        
        if (range.location != NSNotFound)
        {
            directory = [directory substringToIndex:range.location];
            return directory;
        }
    }
    
    return nil;
}


//Filepath can be directory or file
//
+ (BOOL) isFileExist:(NSString *)filePath
{
    return ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
}


+ (NSString *) getUniqueFileName
{
//    NSDate *tmpCurrentDate = [NSDate date];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
//    NSString *fileName = [dateFormat stringFromDate:tmpCurrentDate];
//    return fileName;
    return [[NSUUID new] UUIDString];
}


+ (NSString *) getUniqueFileNameWithExtension:(NSString*)extension
{
    NSString* uniqueFileName = [MPFileUtility getUniqueFileName];
    return [NSString stringWithFormat:@"%@.%@", uniqueFileName, extension];
}


#pragma mark - functions related to Cache directory

+ (BOOL) createRootCacheDirectory
{
    NSString *folderPath = [[MPFileUtility getDocumentDirectory] stringByAppendingPathComponent:MP_STORE_FOLDER];
    return ([MPFileUtility createDirectory:folderPath]);
}


+ (BOOL) clearCacheContent      
{
    // Policy 1. Clearing cache on Date basis
    
    // Pllicy 2. Clearing cache on number basis
    
    BOOL bSuccess = [MPFileUtility removeDirectory:[MPFileUtility getCacheRootDirectory]];
    
    if (bSuccess)
        [MPFileUtility createRootCacheDirectory];     //create directory again
    
    return bSuccess;
}


+ (NSString *) getCacheRootDirectory
{
    NSString *folderPath = [[MPFileUtility getDocumentDirectory] stringByAppendingPathComponent:MP_STORE_FOLDER];
    
    [MPFileUtility logFilepath:folderPath];
    
    NSLog(@"%@",folderPath);
    
    if ([MPFileUtility isDirectoryExist:folderPath])
        return folderPath;
    
    return nil;
}


+ (NSString *) generateCacheFilePath:(NSString *)fileName
{
    NSString *fileId = fileName;
    
    if (!fileId)
        fileId = [MPFileUtility getUniqueFileName];
    
    return ([[MPFileUtility getCacheRootDirectory] stringByAppendingPathComponent:fileId]);
}


+ (NSURL *) generateCacheFileURL:(NSString *)fileName
{
    NSString *filePath = [MPFileUtility generateCacheFilePath:fileName];
    
    if (filePath)
        return ([[NSURL alloc] initFileURLWithPath:filePath]);
    
    return nil;
}


+ (NSString *) writeData:(NSData *)fileData
                fileName:(NSString *)fileName
{
    if (fileData)
    {
        NSString *folderPath = [MPFileUtility getCacheRootDirectory];
        
        if (folderPath)
        {
            NSString *filePath = [folderPath stringByAppendingPathComponent:(fileName != nil ? fileName : [MPFileUtility getUniqueFileName])];
            BOOL bStatus = [fileData writeToFile:filePath atomically:YES];
            
            if (bStatus)
            {
                [MPFileUtility logFilepath:filePath];
                return filePath;
            }
        }
    }
    
    return nil;
}


+ (NSString *) writeImage:(UIImage *)image
                 withName:(NSString *)fileName
      isPNGRepresentation:(BOOL)bPNG
{
    
       
    float  perMBBytes = 1024.0*1024.0;
    CGImageRef cgImage = image.CGImage;
    
    size_t bpp = CGImageGetBitsPerPixel(cgImage);
    size_t bpc = CGImageGetBitsPerComponent(cgImage);
    size_t bytes_per_pixel = bpp / bpc;
    
    float lPixelsPerMB  = perMBBytes/bytes_per_pixel;
    float totalPixel = CGImageGetWidth(image.CGImage)*CGImageGetHeight(image.CGImage);
    float totalFileMB = totalPixel/lPixelsPerMB ;
    
    NSData *data;
    NSString *imageFileName = nil;
    
    if (totalFileMB < 2.00) {
        data = (bPNG ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 1.0));
    }
    else if(totalFileMB > 2.00 && totalFileMB < 10.00){
        data = (bPNG ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 0.5));
    }
    else if(totalFileMB > 10.00){
        data = (bPNG ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 0.1));
    }
  

    if (fileName)
    {
        //if file has extension used it
        // or add it
        NSString *ext = [fileName pathExtension];
        
        if (!ext)
            imageFileName = [NSString stringWithFormat:@"%@.%@", fileName, (bPNG ? @".png": @".jpeg")];
        else
            imageFileName = fileName;
    }
    else
        imageFileName : [NSString stringWithFormat:@"%@.%@", [MPFileUtility getUniqueFileName], (bPNG ? @".png": @".jpeg")];
    
    
    return [MPFileUtility writeData:data
                           fileName:imageFileName];
}

+ (NSString *) writeImage:(UIImage *)image
                 withName:(NSString *)fileName andCompression:(CGFloat)compression
{
    
    
    NSData *data =  UIImageJPEGRepresentation(image, compression);
    
    NSString *imageFileName = nil;
    
    return [MPFileUtility writeData:data
                           fileName:imageFileName];
}

+ (NSString *) getFilePath:(NSString *)fileName
{
    if (fileName)
    {
        NSString *filePath = [[MPFileUtility getCacheRootDirectory] stringByAppendingPathComponent:fileName];
        
        if ([MPFileUtility isFileExist:filePath])
            return filePath;
    }
    
    return nil;
}


//filepath is absolute file path
// if path is directory this function will return false

+ (BOOL) removeFile:(NSString *)filePath
{
    BOOL bStatus = NO;
    
    if (filePath)
    {
        if ([MPFileUtility isDirectoryExist:filePath])
        {
            NSLog(@"%@ path is directory path not file path", filePath);
            return bStatus;
        }
        
        NSError *err = nil;
        bStatus = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&err];
        
        if (!bStatus)
            [self logError:err];
    }
    
    
    return bStatus;
}


+ (NSArray <NSString *> *) getAllFilesFromCache
{
    NSError *err = nil;
    
    NSArray <NSString *> *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[MPFileUtility getCacheRootDirectory]
                                                                                      error:&err];
    
    if (!files)
        [MPFileUtility logError:err];
    
    return files;
}


+ (BOOL) isDirectoryExist:(NSString *)filePath
{
    if (filePath)
    {
        //Value of bStaus is undefined upon return when path does not exist
        // so just return with NO if path is not found
        BOOL bStatus = NO;
        BOOL bExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&bStatus];
        
        if (bExists)
            return bStatus;
    }
    
    return NO;
}

#pragma mark - functions related to folder in Doc directory

+ (BOOL) isFolderExistInDocDir:(NSString *)folderName
{
    if (folderName)
    {
        NSString *rootDir = [MPFileUtility getDocumentDirectory];
        NSString *folderPath = [rootDir stringByAppendingPathComponent:folderName];
        
        return [MPFileUtility isDirectoryExist:folderPath];

    }
    
    return NO;
}


+ (NSString *) saveData:(NSData *)data
      inDocFolder:(NSString *)folderName
     withFileName:(NSString *)fileName
{
    if (folderName)
    {
        NSString *rootDir = [MPFileUtility getDocumentDirectory];
        NSString *folderPath = [rootDir stringByAppendingPathComponent:folderName];
        
        NSString *filePath = [folderPath stringByAppendingPathComponent:(fileName != nil ? fileName : [MPFileUtility getUniqueFileName])];
        BOOL bStatus = [data writeToFile:filePath atomically:YES];
        
        if (bStatus)
        {
            [MPFileUtility logFilepath:filePath];
            return filePath;
        }
        
        
    }
    
    return nil;
}


+ (BOOL) removeFile:(NSString *)fileName
            fromDocFolder:(NSString *)folderName
{
    BOOL bStatus = NO;
    
    if (fileName)
    {
        NSString *rootDir = [MPFileUtility getDocumentDirectory];
        NSString *folderPath = [rootDir stringByAppendingPathComponent:folderName];
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        
        NSError *err = nil;
        bStatus = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&err];
        
        if (!bStatus)
            [self logError:err];
    }
    
    
    return bStatus;
}


//this will create a folder in Cache root directory
+ (NSString *) createFolderInDocDir:(NSString *) folderName;
{
    if (folderName)
    {
        NSString *rootDir = [MPFileUtility getDocumentDirectory];
        
        if ([MPFileUtility isDirectoryExist:rootDir])
        {
            //create folder
            NSString *folderPath = [rootDir stringByAppendingPathComponent:folderName];
            [MPFileUtility logFilepath:folderPath];
            
            if (![MPFileUtility createDirectory:folderPath])
                return nil;
            
            return folderPath;
        }
    }

    return nil;
}


+ (BOOL) removeFolderFromDocDir:(NSString *)folderName
{
    if (folderName)
    {
        NSString *folderPath = [[MPFileUtility getDocumentDirectory] stringByAppendingPathComponent:folderName];
        return ([MPFileUtility removeDirectory:folderPath]);
    }
    
    return NO;
}


#pragma mark - private methods


+ (BOOL) createDirectory:(NSString *)folderFullpath
{
    BOOL bSuccess = NO;
    
    if (folderFullpath)
    {
        if (![MPFileUtility isDirectoryExist:folderFullpath])
        {
            NSError *err = nil;
            bSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:folderFullpath
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&err];
            if (!bSuccess)
                [MPFileUtility logError:err];
        }
        else
            bSuccess = YES;
        
    }

    return bSuccess;
}


+ (BOOL) removeDirectory:(NSString *)folderFullpath
{
    BOOL bSuccess = NO;
    
    if (folderFullpath)
    {
        NSError *err = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:folderFullpath])
            bSuccess = [[NSFileManager defaultManager] removeItemAtPath:folderFullpath
                                                                  error:&err];
        
        if (!bSuccess)
            [self logError:err];
    }

    return bSuccess;
}


- (BOOL)cacheExpired
{
    NSTimeInterval expireInterval = MP_CACHE_DAYS_LIMIT * 24 * 60.0 * 60.0; // Number of seconds in 15 days.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDate *timeStamp = [prefs objectForKey:MP_CACHE_TIMESTAMP];
    
    if (timeStamp)
    {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:timeStamp];
        return interval >= expireInterval;
    }
    
    return YES;
}


#pragma mark - logging methods

+ (void) logError:(NSError *)error
{
    if (!error)
        NSLog(@"Error = %@", error.localizedDescription);
}


+ (void) logFilepath:(NSString *)filePath
{
//    NSLog(@"path = %@", filePath);
}


@end