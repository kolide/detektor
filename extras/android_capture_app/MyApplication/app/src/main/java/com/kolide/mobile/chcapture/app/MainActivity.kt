package com.kolide.mobile.chcapture.app

import android.app.AlertDialog
import android.net.Uri
import android.net.http.SslError
import android.os.Bundle
import android.view.ViewGroup
import android.webkit.SslErrorHandler
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.isDebugInspectorInfoEnabled
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView

class MainActivity : ComponentActivity() {
    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val data: Uri? = intent?.data
        var fromScanUri = ""
        if (data != null) {
            fromScanUri = "https://" + data.authority + data.encodedPath
        }
        setContent {
            MaterialTheme (
                colorScheme = darkColorScheme()
            ) {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Column(
                        modifier = Modifier
                            .padding(innerPadding),
                        verticalArrangement = Arrangement.spacedBy(16.dp),
                    ) {
                        var input by remember { mutableStateOf(fromScanUri) }
                        var url by remember { mutableStateOf(fromScanUri) }
                        Column (
                            modifier = Modifier.background(MaterialTheme.colorScheme.surfaceContainer).fillMaxWidth().padding(8.dp)
                        ) {
                            Text("Enter the capture server url:")
                            Row(verticalAlignment = Alignment.CenterVertically) {

                                    OutlinedTextField(
                                        value = input,
                                        onValueChange = { input = it },
                                        modifier = Modifier.weight(1f),
                                        keyboardOptions = KeyboardOptions(
                                            keyboardType = KeyboardType.Uri,
                                            imeAction = ImeAction.Done
                                        ),
                                        singleLine = true
                                    )

                                IconButton(
                                    onClick = {
                                        url = input
                                    }
                                ) {
                                    Icon(
                                        painter = painterResource(R.drawable.arrow_forward_24px),
                                        contentDescription = "enter"
                                    )
                                }
                            }
                        }
                        MyWebViewScreen(
                            url = url,
                            modifier = Modifier.weight(1f).background(Color.White)
                        )
                    }

                }
            }
        }
    }
}

class UnsafeClient: WebViewClient() {
    override fun onReceivedSslError(view: WebView, handler: SslErrorHandler, error: SslError) {

        val builder: AlertDialog.Builder = AlertDialog.Builder(view.context)
        builder
            .setMessage("There was an ssl error opening [${error.url}].\nProbably expected because this is your dev server, right?")
            .setTitle("Open insecurely?")
            .setPositiveButton("Open anyway") { dialog, which ->
                handler.proceed()
            }
            .setNegativeButton("Cancel") { dialog, which ->
                handler.cancel()
            }

        val dialog: AlertDialog = builder.create()
        dialog.show()
    }
}

@Composable
fun MyWebViewScreen(url: String, modifier: Modifier = Modifier) {
    val webView =
        WebView(LocalContext.current).apply {
            settings.blockNetworkLoads = false
            settings.javaScriptEnabled = true // Enable JavaScript if needed

            layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            webViewClient = UnsafeClient().apply {
                isDebugInspectorInfoEnabled = true

            }
            setBackgroundColor(resources.getColor(android.R.color.transparent))

        }
    AndroidView(
        factory = { webView },
        update = {
            if (url.isNotBlank()) {
                it.loadUrl(url)
            }
        },
        modifier = modifier
    )
}