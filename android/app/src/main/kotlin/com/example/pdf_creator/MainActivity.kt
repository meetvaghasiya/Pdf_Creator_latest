package com.example.pdf_creator

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      GeneratedPluginRegistrant.registerWith(this); // Make sure this line is present
    }
}
