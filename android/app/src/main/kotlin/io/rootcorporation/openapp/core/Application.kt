package io.rootcorporation.openapp

import android.app.Application
import android.content.Context
import android.net.ConnectivityManager
import android.os.PowerManager
import androidx.core.content.getSystemService
import go.Seq
import io.rootcorporation.librcc.Librcc
import io.rootcorporation.librcc.SetupOptions
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File
import java.util.Locale

class Application : Application() {

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        application = this
    }

    override fun onCreate() {
        super.onCreate()

        System.loadLibrary("gojni")
        
        Seq.setContext(this)
        Librcc.setLocale(Locale.getDefault().toLanguageTag().replace("-", "_"))

        @Suppress("OPT_IN_USAGE")
        GlobalScope.launch(Dispatchers.IO) {
            initialize()
        }

    }

    private fun initialize() {
        val baseDir = filesDir
        baseDir.mkdirs()
        val workingDir = getExternalFilesDir(null) ?: return
        workingDir.mkdirs()
        val tempDir = cacheDir
        tempDir.mkdirs()
        Librcc.setup(SetupOptions().also {
            it.basePath = baseDir.path
            it.workingPath = workingDir.path
            it.tempPath = tempDir.path
            it.fixAndroidStack = true
        })
        Librcc.redirectStderr(File(workingDir, "stderr.log").path)
    }

    companion object {
        lateinit var application: Application
        val connectivity by lazy { application.getSystemService<ConnectivityManager>()!! }
        val packageManager by lazy { application.packageManager }
        val powerManager by lazy { application.getSystemService<PowerManager>()!! }
    }

}