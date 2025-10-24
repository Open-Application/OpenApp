-dontwarn android.app.ActivityThread
-dontwarn android.app.ActivityThread$PackageInfo

-keep class android.content.pm.** { *; }
-keep class android.app.ActivityThread { *; }
-keep class android.app.ActivityThread$PackageInfo { *; }

-dontwarn com.android.vending.**
-dontwarn com.google.android.gms.**