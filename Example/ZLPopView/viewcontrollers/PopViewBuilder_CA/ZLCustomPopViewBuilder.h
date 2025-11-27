//
//  GMCustomPopViewBuilder.h
//  GMPopView_Example
//
//  Created by admin on 2025/9/28.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import <ZLPopView/ZLPopView.h>
#define kBottomActionViewsBK ZLPopViewBuilder.ca_actionViewsBK
#define kBottomActionViewsColumnBK ZLPopViewBuilder.ca_actionViewsColumnBK

NS_ASSUME_NONNULL_BEGIN
@interface ZLPopViewBuilder (custom)
@property (nonatomic,readonly) ZLPopViewBuilder* (^ca_addDeleteBtnAction)(void(^action)(UIView * btn));
@property (nonatomic,readonly) ZLPopViewBuilder* (^ca_addConfirmBtnAction)(void(^action)(UIView * btn));
@property (nonatomic,readonly) ZLPopViewBuilder* (^ca_addCancelBtnAction)(void(^action)(UIView * btn));
+ (ZLActionViewsBK)ca_actionViewsBK;
+ (ZLActionViewsBK)ca_actionViewsColumnBK;
@end
@interface ZLCustomPopViewBuilder : ZLPopViewBuilder

@end

NS_ASSUME_NONNULL_END
