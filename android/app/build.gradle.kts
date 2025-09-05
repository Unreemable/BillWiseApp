plugins {
    id("com.android.application")
    id("kotlin-android")
<<<<<<< HEAD
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.billwise"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.billwise"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

=======
    // يجب أن يأتي بعد Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")
    // Firebase Google Services (لو عندك google-services.json)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.billwise"   // عدّليها لو اسم الباكيج مختلف
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.billwise" // عدّليها لو مختلف
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
>>>>>>> b8e3683 (Edit the error)
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
<<<<<<< HEAD
=======

dependencies {
    // BOM لتوحيد نسخ Firebase (اختياري)
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))
    // مثال: Analytics (اختياري)
    implementation("com.google.firebase:firebase-analytics-ktx")
}
>>>>>>> b8e3683 (Edit the error)
