<<<<<<< HEAD
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

=======
plugins {
    id("com.android.application") version "8.5.2" apply false
    kotlin("android") version "1.9.24" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}

// (اختياري) تخصيص مجلد build لأعلى المشروع
>>>>>>> b8e3683 (Edit the error)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    layout.buildDirectory.value(newSubprojectBuildDir)
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
