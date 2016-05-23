//
//  MPAPI.h
//  MarketPlace
//
//  Created by niu on 16/1/16.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPChatHomeStylerCloudfiles.h"
#import "MPProjectMaterials.h"
#import "MPChatProjectInfo.h"

@interface MPAPI : NSObject

/**
 * D2.1 创建装修需求
 * url      @{@"order_id":111111111111}
 * header   不解释
 * body     @{@"order_id":@(101),@"order_line_id":@(101),@"status":@"1"}
 */
+ (void)createMeasureRoomOrderWithUrl:(NSDictionary *)urlDict
                               header:(NSDictionary *)headerDict
                                 body:(NSDictionary *)bodyDict
                              success:(void(^) (NSDictionary *dictionary))success
                              failure:(void(^) (NSError *error))failure;

// 消费者查看设计师主页 get设计师信息
+ (void)getDesignerInfoWithUrl:(NSDictionary *)urlDict
                        header:(NSDictionary *)headerDict
                        body:(NSDictionary *)bodyDict
                     success:(void(^) (NSDictionary *dictionary))success
                     failure:(void(^) (NSError *error))failure;

+ (void)createOrderToDesigner:(NSDictionary *)dictionary requestHeader:(NSDictionary *)header  success:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure;

///D3.12 依据设计订单标示上传量房结果
+ (void)uploadMeasureRoomResultWithParameters:(NSDictionary *)parametes requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;

///D3.14 设计师填入数据后依据设计订单标示新增设计合同
+ (void)createDesignContractWithParameters:(NSDictionary *)parametes requestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *string))success failure:(void(^) (NSError *error))failure;


///M1.1 依据会员标示获取会员信息 no
+ (void)designerBasicInformationMaintinWithParameters:(NSDictionary *)parametes requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;


///D3.2 依据设计师标示更新设计师首页
+ (void)designerHomeSettingWithDesigner_id:(NSString *)designer_id withParameters:(NSDictionary *)parametes requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;


///M1.5 依据会员标示获取个人关注设计师列表 no
+ (void)getListOfAttentionDesignersWithMemberId:(NSString *)member_id requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;

///M1.6 依据会员标示和设计师标示删除关注设计师  no
+ (void)cancelAttentionDesignerWithMember_id:(NSString *)member_id designerId:(NSString *)designer_id requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;

///D2.9 依据需求标示获取应标成员列表
+ (void)getListOfMyTargetsWithNeedsId:(NSString *)needs_id requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;

 
///D3.4 根据设计师标示获取设计师的接单列表
//- (void)designerimprovementlist:(void(^)(NSString * string))block;

//D2.7 依据需求标示获取发布需求详情
+ (void)designerOrderdetails:(void(^)(NSString * string))block;

///D1.4 获取案例库列表.
+ (void)crateCaseLibrayWithOffset:(NSString *)offset withLimit:(NSString *)limit custom_string_area:(NSString *)area custom_string_form:(NSString *)form custom_string_style:(NSString *)style custom_string_type:(NSString *)type custom_string_keywords:(NSString *)keywords success:(void (^)(NSDictionary* Dic))success failure:(void(^) (NSError *error))failure;

///D1.5 依据案例标识获取案例详情

+ (void)createCaseLibrayDetailWithCaseID:(NSString *)caseId Success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

///D1.2 依据案例标识修改案例
+ (void)createModifyCaseWithCaseId:(NSString *)caseId withStatus:(NSString *)status withRecommended:(NSString *)recommended withSearch:(NSString *)search withWeight:(NSString *)weight requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;

///D1.3 依据案例标识删除案例

+ (void)createDeleteCaseWithcaseId:(NSString *)caseId requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;

///M1.5 消费者获取关注的设计师列表（模拟接口）

+ (void)createFoucsDesignersListWithMemberId:(NSString *)memberId requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure;

///D2.5 装修需求列表(我的家裝訂單)
+ (void)createDecorateDemandListWithOffset:(NSString *)offset withMemberId:(NSString *)memberId withLimit:(NSString *)limit withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure;

///D2.6 裝修需求詳情
+ (void)createDecorateDetailWithNeedsId:(NSString *)needsId requestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *dict))success failure:(void(^) (NSError *error))failure;

///D2.2 修改装修需求
+ (void)createModifyDecorateDemandWithNeedsId:(NSString *)needsId withParameters:(NSDictionary *)parametersDict withRequestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *dict))success failure:(void(^) (NSError *error))failure;

///D2.3 取消／关闭装修需求
+ (void)createCancleDecorateDemandWithNeedId:(NSString *)needId requestHeader:(NSDictionary *)header Success:(void (^)(NSString* string))success failure:(void(^) (NSError *error))failure;

///D3.1 设计师列表
+ (void)getDesignersListWithUrl:(NSDictionary *)urlDict
                         header:(NSDictionary *)headerDict
                           body:(NSDictionary *)bodyDict
                        success:(void(^) (NSDictionary *dict))success
                        failure:(void(^) (NSError *error))failure;

/// 获取会员信息 Access to personal information

+ (void)createAccessPersonalInformationWithMemberId:(NSString *)memberId withRequestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *informationDict))success failure:(void(^) (NSError *error))failure;

/// 设计师 我的应标列表
+ (void)createDesignerMyMarkListWithDesignerId:(NSString *)designerId WithOffset:(NSString *)offset withLimit:(NSString *)limit withSort_by:(NSString *)sort_by withSort_order:(NSString *)sort_order withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

/// 发布北舒套餐

+ (void)createBeishuWithConsumerId:(NSString *)consumerId parmeters:(NSDictionary *)parametersDict withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;



/// D2.10 依据设计师标识和需求标识删除招标中指定的应标成员
+ (void)deleteDesignerWithNeedId:(NSString *)needId designerId:(NSString *)designerId withParameters:(NSDictionary *)parametersDict withRequestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *dictionary))success failure:(void(^) (NSError *error))failure;

/// 设计师 我的项目
+ (void)createDesignerMyProjectWithMemberId:(NSString *)memberId withOffset:(NSString *)offset withLimit:(NSString *)limit withMediaTypeID:(NSString *)mediaTypeId withSoftware:(NSString *)software withTaxonomy:(NSString *)taxonomy  withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

/// 应标大厅
+ (void)createMarkHallWithUrl:(NSDictionary *)urlDict
                       header:(NSDictionary *)headerDict
                         body:(NSDictionary *)bodyDict
                      success:(void(^) (NSDictionary *dict))success
                      failure:(void(^) (NSError *error))failure;

/// 设计师应标
+ (void)createDesignerBiddingMarkWithNeedId:(NSString *)needId withDesignerId:(NSString *)designerId withParameters:(NSDictionary *)parameterDict withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSURLSessionDataTask *task,NSError *error))failure;

/// 应标案件详情
+ (void)createMarkDetailWithNeedId:(NSString *)needId withHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

/// 获取上传server
+ (void)uploadPhoto:(NSString *)photoUrl withsuccess:(void(^) (NSDictionary *dictionary))success failure:(void(^) (NSError *error))failure;
/// 获取下载server
+ (void)downloadPhoto:(NSString *)photoUrl withsuccess:(void(^) (NSDictionary *dictionary))success failure:(void(^) (NSError *error))failure;
//上传普通照片
+ (void)createUploadPhotosWithUrl:(NSString *)url withFiles:(NSArray *)array withHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

//上传实名认证照片
+ (void)UploadRealNameAuthenticationWith:(NSString *)URl Withparam:(NSDictionary *)dict WithHeader:(NSDictionary *)headerdict success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;



//下载照片
+ (void)downloadfield:(NSString *)fiel_id andtitle:(NSString *)title success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

//查看订单详情
+ (void)retrieveOrderByOrderId:(NSString *)ordeid withHeadfield:(NSDictionary *)token withsuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

// D3.4获取设计师订单列表 假接口
+ (void)GetorderListOFdesignerWithDesignerID:(NSString *)designer_id withOffset:(NSString *)offset withLimit:(NSString *)limit requestHeader:(NSDictionary *)header  success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

// D3.11依据设计师标识和订单标识拒绝/同意量房订单
+ (void)DesignerRefuseORagreOder:(NSString *)orderid WihtPrametrs:(NSDictionary *)Prametrs With:(NSDictionary *)HeaderField success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;
// D3.15 消费者获取合同详情
+ (void)MemberGetContractContract:(NSString *)Contractid WithrequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

// 设计师首页案例列表 以设计师标识查询
+ (void)getListOfDesignerCasesWithUrl:(NSDictionary *)urlDict
                               header:(NSDictionary *)headerDict
                                 body:(NSDictionary *)bodyDict
                              success:(void(^) (NSDictionary *dictionary))success
                              failure:(void(^) (NSError *error))failure;

//依据消费者标识更新会员信息
+ (void)UpdataGetMemberInformationWith:(NSString *)member_id withParam:(NSDictionary *)param WithToken:(NSDictionary *)token success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

/// 消费者自选量房
+ (void)measureByConsumerSelfChooseDesignerWithParam:(NSDictionary *)param
                                       requestHeader:(NSDictionary *)header
                                             success:(void (^)(NSDictionary* dict))success
                                             failure:(void(^) (NSURLSessionDataTask *task,NSError *error))failure;

/// 消费者自选量房 no needid
+ (void)measureByConsumerSelfChooseDesignerNoNeedIdWithParam:(NSDictionary *)param requestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSURLSessionDataTask *task, NSError *error))failure;

/// 消费者发布需求
+ (void)issueDemandWithParam:(NSDictionary *)param requestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

/// 同意或拒绝量房
+ (void)confirmOrRefuseMeasure:(BOOL)confirm withNeedsID:(NSString *)needs_id withHeader:(NSDictionary *)header andSuccess:(void(^)(NSDictionary *dictionary))success andFailure:(void(^) (NSError *error))failure;

/// 设计师是否实名认证
+ (void)createDesignerRealNameWithDesignerId:(NSString *)designerid withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

+ (void)ServicePayForOrder:(NSDictionary *)urlDict
                    header:(NSDictionary *)headerDict
                      body:(NSDictionary *)bodyDict
                   success:(void(^) (NSString *url))success
                   failure:(void(^) (NSError *error))failure;

#pragma mark - 我的资产
/// 获取设计师银行卡信息
+ (void)getDesignersBankInfoWithDesignerID:(NSString *)designerID
                                withHeader:(NSDictionary *)header
                                andSuccess:(void(^)(NSDictionary *dict))success
                                andFailure:(void(^)(NSError *error))failure;

#pragma mark - 合同
///获取合同编号
+ (void)getContractNumberWithSuccess:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure;
/// 创建设计合同
+ (void)createContractNeedID:(NSString *)needid WithRequestHeader:(NSDictionary *)header WithBoby:(NSDictionary *)bobyDict WithSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;


#pragma mark - 支付
/// 量房支付
+ (void)PayWithOrderId:(NSString *)orderid WithOrderLineID:(NSString *)orderlineid WithSuccess:(void(^)(NSDictionary * dict))success failure:(void(^) (NSError *error))failure;



+ (void) getCloudFilesForNeedId:(NSString *)needId
                        success:(void(^) (MPChatHomeStylerCloudfiles *dict))success
                        failure:(void(^) (NSError *error))failure;

+ (void) getProjectMaterialsForNeedId:(NSString *)needId
                               header:(NSDictionary *)header
                              success:(void(^) (MPProjectMaterials *dict))success
                              failure:(void(^) (NSError *error))failure;

+ (void) getProjectInfoForNeedId:(NSString *)needId
                     forDesigner:(NSString*)designerId
                          header:(NSDictionary *)header
                         success:(void(^) (MPChatProjectInfo *dict))success
                         failure:(void(^) (NSError *error))failure;

///根据needs_id与designer_id获取当前状态
+ (void)getCurrentStatusWithNeedID:(NSString *)needs_id
                    withDesignerID:(NSString *)designer_id
                        andSuccess:(void(^)(NSDictionary *dict))success
                        andFailure:(void(^)(NSError *error))failure;

/// 获取消费者会员信息
+ (void)getMembersInformation:(NSString *)member_id withRequestHeard:(NSDictionary *)heard WithSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;
/// 获取设计师详情信息
+ (void)getDesignersInformation:(NSString *)member_id withRequestHeard:(NSDictionary *)heard WithSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;
/// 更新设计师信息
+ (void)updataGetdesignersInformation:(NSString *)member_id withParam:(NSDictionary *)param withRequestHeard:(NSDictionary *)heard witSuccess:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure;
/// 获取实名认证信息
+ (void)getDesignersCerInformation:(NSString *)member_id withRequestHeard:(NSDictionary *)heard witSuccess:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure;
/// 更新实名认证信息（重新提交资料进行审核）
+ (void)updataCerInformation:(NSString *)member_id withParam:(NSDictionary *)dic withRequestHeard:(NSDictionary *)heard witSuccess:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure;

/// 更新会员头像
+ (void)updataMembersAvatar:(NSDictionary *)header withFile:(NSData *)file witSuccess:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure;

/// 设计师获取交易记录
+ (void)getDesignerTransactionRecord:(NSString *)designer_id withParameter:(NSDictionary *)paramDict withSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;
/// 设计师获取提现记录
+ (void)getDesignersWithdraw:(NSString *)designer_id withParameter:(NSDictionary *)paramDict withSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;
/// 设计师取现
+ (void)putDesignersWithdraw:(NSString *)designer_id withParameter:(NSDictionary *)paramDict withSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure;

#pragma mark - 交付物
/// 获取与装修项目相关的3D方案列表  获取Asset_id
+ (void)GetProjectNeedID:(NSString *)needid WithHeard:(NSDictionary *)heard WithDesingeid:(NSString *)desingeid WithSuccess:(void(^)(NSDictionary * dict))success failure:(void(^)(NSError *error))failure;

/// 获取3D文案文件列表
+ (void)Get3DfileListAssetID:(NSString *)assetid WithNeedID:(NSString *)needid WihtDesingerID:(NSString * )desingerid WithHeader:(NSDictionary *)header WithSuccess:(void(^)(NSDictionary * dict))success failure:(void(^)(NSError * error))failure;
/// 提交交付物
+ (void)SubmitDeliverablesAsset:(NSString *)asset WithNeedID:(NSString *)needid WithDesignerID:(NSString *)designerid WithFileID:(NSString *)fileid WithType:(NSString *)type WithHeader:(NSDictionary *)headerdict WithSuccess:(void(^)(NSDictionary * dict))success failure:(void(^)(NSError *error))failure;
/// 获取项目资料
+ (void)GetProjectDataNeedID:(NSString *)needID WithDesingerID:(NSString *)desingerID WithHeaderDict:(NSDictionary *)headerdict WithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure;

#pragma mark - 消息中心
/// 消息中心 System message, Thread_id after the user login.
+ (void)PostPersonalMessageMemberIDWithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure;
/// 消息中心 System message, through thread_id get news content
+ (void)GetPerSonalMessageMemberIDWithThreadID:(NSString *)threadId withParameters:(NSDictionary *)parameterDict WithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure;

///获取系统thread_id
+ (void) retrieveMemberThreads:(NSString*)memberId
            onlyAttachedToFile:(BOOL)fileOnly
                        header:(NSDictionary *)header
                       success:(void(^)(NSDictionary* dict))success
                       failure:(void(^)(NSError *error))failure;

@end
