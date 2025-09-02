plugins {
    id("com.android.application")
    id("kotlin-android")
    // لازم يجي بعد Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")
    // Google Services (Firebase)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.billwise"         // عدّليها حسب باكيجك
    compileSdk = flutter.compileSdkVersion     // خليه يأخذ القيمة من flutter

    // (اختياري لكنه مفيد لو محدد في flutter)
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.billwise" // عدّليها لو مختلف
        minSdk = flutter.minSdkVersion         // ✅ لا تكتبي "=21" هنا
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}

dependencies {
    // استخدام BOM لتوحيد نسخ Firebase (اختياري)
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))

    // أضفِ خدمات Firebase الأصلية فقط إذا كنتِ تستخدمين حزم Flutter الموافقة لها.
    // مثال: لو بتستخدمين firebase_analytics (باكج Flutter)، تقدرين تخلّي السطر هذا.
    implementation("com.google.firebase:firebase-analytics")
    // لباقي الحزم (Auth/Messaging/Database...) ما
}