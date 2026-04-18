# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Retrofit
-keepattributes Signature
-keepattributes Exceptions

-ignorewarnings

-dontwarn android.window.BackEvent

# OkHTTP
-dontwarn okhttp3.**
-keep class okhttp3.**{ *; }
-keep interface okhttp3.**{ *; }

# Other
-keepattributes *Annotation*
-keepattributes SourceFile, LineNumberTable

# Logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
    public static *** wtf(...);
}

-assumenosideeffects class io.flutter.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** w(...);
    public static *** e(...);
}

-assumenosideeffects class java.util.logging.Level {
    public static *** w(...);
    public static *** d(...);
    public static *** v(...);
}

-assumenosideeffects class java.util.logging.Logger {
    public static *** w(...);
    public static *** d(...);
    public static *** v(...);
}

# Removes third parties logging
-assumenosideeffects class org.slf4j.Logger {
    public *** trace(...);
    public *** debug(...);
    public *** info(...);
    public *** warn(...);
    public *** error(...);
}

# Facebook
-keep class com.facebook.** { *; }
-keep class com.google.ads.mediation.facebook.** { *; }
-keep class com.facebook.ads.** { *; }
-dontwarn com.facebook.ads.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep public class com.google.android.gms.ads.MobileAds {
    public *;
}

# Keep mediation adapters
-keepnames class com.google.ads.mediation.** { *; }
-keep class com.google.ads.mediation.* { *; }

# Audience Network
-dontwarn com.facebook.ads.internal.**
-keepnames class com.facebook.ads.internal.** { *; }
-keep public class com.facebook.ads.** { *; }
-keep public class com.facebook.ads.internal.** { *; }
