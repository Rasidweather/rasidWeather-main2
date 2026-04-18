// android/build.gradle.kts (Project-level)

import org.gradle.api.file.Directory
import com.android.build.gradle.LibraryExtension

// --- Google Services via legacy buildscript (لأن البلجن يُطبَّق في :app) ---
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.1")
    }
}

// --- Repositories لكل المشاريع ---
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Force plugin subprojects to reuse the AGP version already configured by the app.
allprojects {
    buildscript {
        configurations.all {
            resolutionStrategy.eachDependency {
                if (requested.group == "com.android.tools.build" && requested.name == "gradle") {
                    useVersion("8.7.0")
                    because("Offline/local builds fail when Flutter plugins request different AGP versions.")
                }
            }
        }
    }
}

// --- نقل build إلى مجلد أعلى (حسب إعدادك) ---
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// --- ضمان تقييم :app أولاً إن احتجته ---
subprojects {
    project.evaluationDependsOn(":app")
}

// --- Task التنظيف ---
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// --- إصلاح تلقائي للـ namespace لمكتبات Android القديمة ---
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<LibraryExtension>("android") {
            if (namespace.isNullOrBlank()) {
                val manifest = file("$projectDir/src/main/AndroidManifest.xml")
                if (manifest.exists()) {
                    val text = manifest.readText()
                    val pkg = Regex("""package="([^"]+)"""").find(text)?.groupValues?.get(1)
                    if (!pkg.isNullOrBlank()) {
                        namespace = pkg
                        println("Applied namespace '$pkg' to project ${project.path}")
                    } else {
                        println("Warning: Couldn't infer namespace for ${project.path} (no package in manifest).")
                    }
                } else {
                    println("Warning: No AndroidManifest.xml found for ${project.path}, cannot set namespace.")
                }
            }
        }
    }
}
