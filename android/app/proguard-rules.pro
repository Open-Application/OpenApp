# Suppress ActivityThread warnings about package replacements
-dontwarn android.app.ActivityThread
-dontwarn android.app.ActivityThread$PackageInfo

# Keep package manager related classes to avoid warnings
-keep class android.content.pm.** { *; }
-keep class android.app.ActivityThread { *; }
-keep class android.app.ActivityThread$PackageInfo { *; }

# Suppress specific package replacement warnings
-dontwarn com.android.vending.**
-dontwarn com.google.android.gms.**