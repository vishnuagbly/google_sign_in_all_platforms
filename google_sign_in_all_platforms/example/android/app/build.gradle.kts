
import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")

if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { input ->
        localProperties.load(input)
    }
}

val flutterVersionCode = localProperties
    .getProperty("flutter.versionCode") ?: "1"

val flutterVersionName = localProperties
    .getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.vishnuworld.example"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    sourceSets {
        getByName("main") {
            java.srcDir("src/main/kotlin")
        }
    }

    defaultConfig {
        // Specify your unique application ID.
        applicationId = "com.vishnuworld.example"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    buildTypes {
        getByName("release") {
            // Uses debug signing for local release builds.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8
    }
}


flutter {
    source = "../.."
}

dependencies {
}
