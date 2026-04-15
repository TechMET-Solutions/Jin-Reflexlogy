import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {

    namespace = "com.jin.reflexology"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion


    // ✅ ADD THIS BLOCK (IMPORTANT)
    defaultConfig {

        applicationId = "com.jin.reflexology"

        minSdk = flutter.minSdkVersion   // 🔥 MUST BE 21+
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Signing Config
    signingConfigs {
    create("release") {
        val keyAliasVal = keystoreProperties["keyAlias"]?.toString()
        val keyPasswordVal = keystoreProperties["keyPassword"]?.toString()
        val storeFileVal = keystoreProperties["storeFile"]?.toString()
        val storePasswordVal = keystoreProperties["storePassword"]?.toString()

        if (
            keyAliasVal != null &&
            keyPasswordVal != null &&
            storeFileVal != null &&
            storePasswordVal != null
        ) {
            keyAlias = keyAliasVal
            keyPassword = keyPasswordVal
            storeFile = file(storeFileVal)
            storePassword = storePasswordVal
        }
    }
}

buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("release")
    }
}


    // Build Types
    buildTypes {

        getByName("release") {

            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
