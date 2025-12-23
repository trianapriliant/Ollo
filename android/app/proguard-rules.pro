# ML Kit Text Recognition optional dependencies
# These classes are referenced by the plugin but the dependencies are not included
# because we only use the default (Latin) recognizer.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# RevenueCat - Keep for in-app purchases
-keep class com.revenuecat.purchases.** { *; }
