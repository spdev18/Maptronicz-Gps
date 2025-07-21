import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keyPropertiesFile = rootProject.file("key.properties") // This should point to android/key.properties
val keyProperties = Properties() // Use the imported Properties
if (keyPropertiesFile.exists()) {
    FileInputStream(keyPropertiesFile).use { input -> // Use imported FileInputStream and 'use' block for safety
        keyProperties.load(input)
    }
}

android {
    namespace = "com.maptronicz.maptronicz"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            if (keyPropertiesFile.exists()) {
                storeFile = file(keyProperties.getProperty("storeFile")) // Use getProperty
                storePassword = keyProperties.getProperty("storePassword") // Use getProperty
                keyAlias = keyProperties.getProperty("keyAlias") // Use getProperty
                keyPassword = keyProperties.getProperty("keyPassword") // Use getProperty
            }
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.maptronicz.maptronicz"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // signingConfig = signingConfigs.getByName("debug") // Comment out or remove this line
            signingConfig = signingConfigs.getByName("release") // Add this line
            // Consider adding ProGuard/R8 rules here for code shrinking and obfuscation
            // minifyEnabled(true)
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
