# Flutter ProGuard 规则
# 保留 Flutter 引擎相关类
-keep class io.flutter.** { *; }
-keep class flutter.** { *; }
-keep class androidx.lifecycle.** { *; }

# Flutter 混合栈支持
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# Dio 网络库
-keep class dio.** { *; }
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# WebView
-keep class android.webkit.** { *; }
-keep class androidx.webkit.** { *; }

# 蓝牙
-keep class com.polidea.rxandroidble.** { *; }

# 数据模型 (Freezed)
-keep class **$$** { *; }
-keep class * extends freezed.** { *; }
-keep class **_freezed { *; }
-keepclassmembers class ** {
    @freezed.annotations.* <methods>;
}

# JSON 序列化
-keep class **_serializable { *; }
-keepclassmembers class ** {
    @json_annotation.* <methods>;
}

# SharedPreferences
-keep class android.content.SharedPreferences { *; }

# Video Player
-keep class tv.danmaku.ijk.media.player.** { *; }
-keep class androidx.media3.** { *; }

# 保留枚举和注解
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keepattributes *Annotation*

# 保留泛型信息
-keepattributes Signature

# 保留反射相关
-keep class java.lang.reflect.** { *; }
-keep class kotlin.reflect.** { *; }

# 保留 Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# 保留 Native 方法
-keepclasseswithmembernames class * {
    native <methods>;
}

# 资源压缩保留
-keep class **.R { *; }
-keep class **.R$* { *; }

# InAppWebView
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }
-keep class com.pichillilorenzo.flutter_inappwebview.in_app_webview.** { *; }

# Play Core SplitCompat (Flutter引擎引用，项目未直接使用)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
