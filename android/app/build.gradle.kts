plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.doingnow"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    // Required replacement for the legacy kotlinOptions block
    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    defaultConfig {
        applicationId = "com.example.doingnow"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = false
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
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

fun registerFlutterApkSync(buildType: String) {
    tasks.register<Copy>("syncFlutter${buildType.replaceFirstChar { it.uppercase() }}Apks") {
        val flutterOutDir = file("${layout.buildDirectory.get().asFile}/outputs/apk/$buildType")
        val cliOutDir = file("${project.rootDir.parentFile}/build/app/outputs/flutter-apk")

        from(flutterOutDir)
        into(cliOutDir)
        include("app-$buildType.apk")
    }
}

registerFlutterApkSync("debug")
registerFlutterApkSync("release")

afterEvaluate {
    tasks.findByName("assembleDebug")?.finalizedBy("syncFlutterDebugApks")
    tasks.findByName("assembleRelease")?.finalizedBy("syncFlutterReleaseApks")
}