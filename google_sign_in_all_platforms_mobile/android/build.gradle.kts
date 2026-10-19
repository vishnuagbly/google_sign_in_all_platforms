import com.android.build.api.dsl.LibraryExtension

group = "com.vishnuworld.google_sign_in_all_platforms_mobile"
version = "1.0-SNAPSHOT"

buildscript {
    val kotlinVersion = "2.4.0"

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:9.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.android.library")
}

extensions.configure<LibraryExtension> {
    namespace = "com.vishnuworld.google_sign_in_all_platforms_mobile"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    sourceSets {
        getByName("main").java.directories.add("src/main/kotlin")
        getByName("test").java.directories.add("src/test/kotlin")
    }

    defaultConfig {
        minSdk = 19
    }

    testOptions {
        unitTests.all {
            it.useJUnitPlatform()
            it.outputs.upToDateWhen { false }

            it.testLogging {
                events(
                    "passed",
                    "skipped",
                    "failed",
                    "standardOut",
                    "standardError"
                )
                showStandardStreams = true
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8
    }
}

dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.0.0")
}
