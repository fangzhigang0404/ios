#import <Foundation/Foundation.h>

@interface MPChatThumbnail : NSObject

/// caption.
@property (strong, nonatomic) NSString *caption;
/// desc The desc is description.
@property (strong, nonatomic) NSString *desc;
/// file_id The file_id is file id.
@property (strong, nonatomic) NSNumber *file_id;
/// thumb_path_prefix The thumb_path_prefix is thum path prefix.
@property (strong, nonatomic) NSString *thumb_path_prefix;
/// is_primary The is_primary is primary.
@property (assign, nonatomic) BOOL is_primary;
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param user.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatThumbnail*)user;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param json.
 *
 *  @return MPChatThumbnail.
 */
+ (MPChatThumbnail*) fromFoundationObj:(NSDictionary*)json;

@end
