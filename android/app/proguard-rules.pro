-keep class **.zego.** { *; }

# Keep all classes related to Huawei push service
-keep class com.huawei.hms.** { *; }
-keep interface com.huawei.hms.** { *; }

# Keep all classes related to Xiaomi push service
-keep class com.xiaomi.mipush.** { *; }
-keep interface com.xiaomi.mipush.** { *; }

# Keep all classes related to Vivo push service
-keep class com.vivo.push.** { *; }
-keep interface com.vivo.push.** { *; }

# Keep all classes related to Oppo push service
-keep class com.heytap.msp.push.** { *; }
-keep interface com.heytap.msp.push.** { *; }

# Suppress warnings for third-party push notification classes
-dontwarn com.heytap.msp.push.HeytapPushManager
-dontwarn com.heytap.msp.push.callback.ICallBackResultService
-dontwarn com.heytap.msp.push.mode.DataMessage
-dontwarn com.heytap.msp.push.service.DataMessageCallbackService
-dontwarn com.huawei.hms.aaid.HmsInstanceId
-dontwarn com.huawei.hms.common.ApiException
-dontwarn com.huawei.hms.push.HmsMessageService
-dontwarn com.huawei.hms.push.RemoteMessage$Notification
-dontwarn com.huawei.hms.push.RemoteMessage
-dontwarn com.vivo.push.IPushActionListener
-dontwarn com.vivo.push.PushClient
-dontwarn com.vivo.push.PushConfig$Builder
-dontwarn com.vivo.push.PushConfig
-dontwarn com.vivo.push.listener.IPushQueryActionListener
-dontwarn com.vivo.push.model.UPSNotificationMessage
-dontwarn com.vivo.push.model.UnvarnishedMessage
-dontwarn com.vivo.push.sdk.OpenClientPushMessageReceiver
-dontwarn com.vivo.push.util.VivoPushException
-dontwarn com.xiaomi.mipush.sdk.MiPushClient
-dontwarn com.xiaomi.mipush.sdk.MiPushCommandMessage
-dontwarn com.xiaomi.mipush.sdk.MiPushMessage
-dontwarn com.xiaomi.mipush.sdk.PushMessageReceiver


