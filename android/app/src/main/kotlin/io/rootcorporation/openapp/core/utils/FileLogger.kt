package io.rootcorporation.openapp.utils

import android.content.Context
import android.util.Log
import java.io.File
import java.io.FileWriter
import java.text.SimpleDateFormat
import java.util.*

object FileLogger {
    private const val TAG = "RccService"
    private const val LOG_FILE = "debug.log"
    private const val MAX_LOG_SIZE = 1024 * 1024
    private var logFile: File? = null
    private val dateFormat = SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault())

    fun init(context: Context) {
        try {
            val file = File(context.filesDir, LOG_FILE)

            if (!file.exists()) {
                file.createNewFile()
            }

            if (file.length() > MAX_LOG_SIZE) {
                file.writeText("")
            }

            logFile = file

            try {
                val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
                val versionName = packageInfo.versionName
                val versionCode = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                    packageInfo.longVersionCode
                } else {
                    @Suppress("DEPRECATION")
                    packageInfo.versionCode.toLong()
                }
                info("App version: $versionName ($versionCode)")
            } catch (e: Exception) {
                Log.e(TAG, "Failed to get version info", e)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to init FileLogger", e)
        }
    }

    fun log(level: String, message: String) {
        val cleanMessage = message
            .replace(Regex("""\x1B\[[0-9;]*[a-zA-Z]|\[\d+m|\[\d{4}\]|\[38;5;\d+m|\[.*?\]"""), "")
            .replace(Regex("\\s+"), " ")
            .trim()


        val timestamp = dateFormat.format(Date())
        val logLine = "[$timestamp] [$level] $cleanMessage\n"

        when (level) {
            "E" -> Log.e(TAG, cleanMessage)
            "W" -> Log.w(TAG, cleanMessage)
            "I" -> Log.i(TAG, cleanMessage)
            "D" -> Log.d(TAG, cleanMessage)
            else -> Log.v(TAG, cleanMessage)
        }

        try {
            logFile?.let { file ->
                FileWriter(file, true).use { writer ->
                    writer.write(logLine)
                    writer.flush()
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to write to log file", e)
        }
    }

    fun info(message: String) = log("I", message)
    fun debug(message: String) = log("D", message)
    fun warn(message: String) = log("W", message)
    fun error(message: String) = log("E", message)

    fun clear() {
        try {
            logFile?.writeText("")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to clear log file", e)
        }
    }
}