// android/settings.gradle.kts

rootProject.name = "billwise_android"

pluginManagement {
    // اقرأ flutter.sdk من android/local.properties أو من متغيرات البيئة
    val props = java.util.Properties().apply {
        val f = java.io.File(rootDir, "local.properties")
        if (f.exists()) f.inputStream().use { this.load(it) }
    }
    val flutterSdkPath = props.getProperty("flutter.sdk")
        ?: System.getenv("FLUTTER_HOME")
        ?: System.getenv("flutterSdk")
        ?: throw GradleException("Property 'flutter.sdk' not found. Put it in android/local.properties (e.g. flutter.sdk=C:\\\\flutter).")

    // ضمّن Gradle الخاص بـ Flutter
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
}

include(":app")
