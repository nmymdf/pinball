plugins {
    id("com.android.application")
}

android {
    namespace = "app.pinball"
    compileSdk = 34

    defaultConfig {
        applicationId = "app.pinball"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "3.9"
    }

    signingConfigs {
        getByName("debug") {
            storeFile = file("pinball.jks")
            storePassword = "pinball123"
            keyAlias = "pinball"
            keyPassword = "pinball123"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}
