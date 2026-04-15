# Flutter Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase Rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# App models (serialization/deserialization uchun)
-keep class uz.izlash.ranchschool.teacher_school_app.data.models.** { *; }

# Obfuscation va optimization yoqilgan (xavfsizlik uchun)
-keepattributes Signature,Exceptions,*Annotation*
