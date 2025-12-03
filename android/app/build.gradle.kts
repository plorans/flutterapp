plugins {
    id("com.android.application")
    id("kotlin-android")
    // El Flutter Gradle Plugin debe aplicarse después de Android y Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties

// Cargamos key.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "GeekCollector Perfil " // Cambia si tu app tiene otro ID
    compileSdk = 36 // Ajusta a la versión que uses
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "Perfil"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 3
        versionName = "1.1.2" // opcional: puedes actualizar también el nombre visible

    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    // Configuración de firma
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.1.0")
}
