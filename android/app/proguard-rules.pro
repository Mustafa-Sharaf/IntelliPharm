# إغلاق تحذيرات المكتبات المفقودة الخاص بـ SLF4J
-dontwarn org.slf4j.**

# حماية كلاسات Flutter والـ Plugins الأساسية
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.internal.** { *; }
-keep class io.flutter.provider.** { *; }