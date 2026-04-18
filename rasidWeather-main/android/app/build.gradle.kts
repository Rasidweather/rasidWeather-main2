import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeyProps = keystorePropertiesFile.exists()

val keystoreProperties = Properties().apply {
    if (hasKeyProps) {
        load(FileInputStream(keystorePropertiesFile))
    }
}

android {
    namespace = "com.rassid.rassid"
    compileSdk = flutter.compileSdkVersion

    // ✅ FIX: لازم أعلى NDK عشان plugins (backward compatible)
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.rassid.rassid"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 129
        versionName = flutter.versionName
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            if (hasKeyProps) {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            } else {
                // بديل عبر متغيرات البيئة إذا لم يوجد key.properties
                keyAlias = System.getenv("KEY_ALIAS") ?: ""
                keyPassword = System.getenv("KEY_PASSWORD") ?: ""
                storeFile = System.getenv("STORE_FILE")?.let { file(it) }
                storePassword = System.getenv("STORE_PASSWORD") ?: ""
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release") // استخدم توقيع الإصدار دائمًا

            // ✅ حاليا خليتهم false زي ما عندك (عشان تبني بسرعة)
            isMinifyEnabled = false
            isShrinkResources = false

            // ✅ جاهز للـ R8/Proguard لو شغلت minify مستقبلاً
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // افتراضي
        }
    }

    // اختياري: استثناء ملفات تراخيص مكررة
    packaging {
        resources {
            excludes += setOf(
                "META-INF/DEPENDENCIES",
                "META-INF/NOTICE",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/NOTICE.txt",
                "META-INF/ASL2.0"
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.google.android.play:app-update:2.1.0")
    implementation("com.google.android.play:app-update-ktx:2.1.0")
}

flutter {
    source = "../.."
}
