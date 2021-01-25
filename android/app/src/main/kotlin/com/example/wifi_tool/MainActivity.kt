package com.example.wifi_tool

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/signalStrength"

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getGsmSignalStrength") {
                val signalStrength = getDbm()
                if (signalStrength != -1) {
                    result.success(signalStrength)
                } else {
                    result.error("UNAVAILABLE", "signalStrength level not available.", null)
                }
            } else {
                result.notImplemented()
            }
            if(call.method == "enableWifi"){
                enableWifi()
            }
        }
    }

    private fun enableWifi() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val panelIntent = Intent(Settings.Panel.ACTION_INTERNET_CONNECTIVITY)
            startActivityForResult(panelIntent, 0)
        }
    }


    @RequiresApi(Build.VERSION_CODES.Q)
    private fun getDbm(): Int? {
        val telephonyManager: TelephonyManager? = this.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        var i = (telephonyManager?.signalStrength?.cellSignalStrengths?.get(0)?.asuLevel?.div(6) ?: -1)
        if(i != 0 && i!=- 1) i--
        return i
    }

}
