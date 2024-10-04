package com.example.sql_connection

import androidx.annotation.NonNull

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.os.StrictMode;
import android.content.Context
import kotlinx.coroutines.launch

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import org.json.JSONArray

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Locale
import kotlin.time.ExperimentalTime
import kotlin.time.measureTime

class SqlConnectionPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var databaseHelper: DatabaseHelper
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private var connection: Connection? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "sql_connection")
        channel.setMethodCallHandler(this)
        val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
        StrictMode.setThreadPolicy(policy)
        databaseHelper = DatabaseHelper()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        // if (call.method == "getPlatformVersion") {
        //     result.success("Android ${android.os.Build.VERSION.RELEASE}")
        // } else {
        //     result.notImplemented()
        // }
        CoroutineScope(Dispatchers.IO).launch {
            when (call.method) {
              "connectDb" -> connect(call, result)
              "queryDatabase" -> getData(call, result)
              "updateData" ->writeData(call, result)
              "disconnect" -> disconnect(result)
              else -> result.notImplemented()
            }
          }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        try {
            if (connection != null) {
                connection!!.close()
            }
            databaseHelper.disconnect()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private suspend fun connect(call: MethodCall, result: Result) {
        val url = call.argument<String>("url")
        val username = call.argument<String>("username")
        val password = call.argument<String>("password")
        val timeoutInSeconds = call.argument<Int>("timeoutInSeconds")
        withContext(Dispatchers.IO) {
            try {
                databaseHelper.connect(url!!, username!!, password!!, timeoutInSeconds!!)
                result.success(true)
            } catch (e: Exception) {
                Log.e("sqlConnectionPlugin", "Error connecting to the database: $e")
                result.error("DATABASE_ERROR", e.message, null)
            }
        }
    }

    private suspend fun getData(call: MethodCall, result: Result) {
        val query = call.argument<String>("query")

        withContext(Dispatchers.IO) {
            try {

                val resultSet: List<String> = databaseHelper.getData(query!!)
                result.success(resultSet);
            } catch (e: Exception) {
                Log.e("sqlConnectionPlugin", "Error fetching data from the database: $e")
                result.error("DATABASE_ERROR", e.message, null)
            }
        }
    }

    private suspend fun writeData(call: MethodCall, result: Result) {
        val query = call.argument<String>("query")

        withContext(Dispatchers.IO) {
            try {
                val affectedRows: Int
                affectedRows = databaseHelper.writeData(query!!)
                result.success(JSONObject().put("affectedRows", affectedRows).toString())
            } catch (e: Exception) {
                Log.e("sqlConnectionPlugin", "Error writing data to the database: $e")
                result.error("DATABASE_ERROR", e.message, null)
            }
        }
    }

    private suspend fun disconnect(result: Result) {
        withContext(Dispatchers.IO) {
            try {
                databaseHelper.disconnect()
                result.success(true)
            } catch (e: Exception) {
                Log.e("sqlConnectionPlugin", "Error disconnecting from the database: $e")
                result.error("DATABASE_ERROR", e.message, null)
            }
        }
    }

    @OptIn(ExperimentalTime::class)
    private fun resultSetToJsonArray(resultSet: ResultSet): String {
        val jsonArray = JSONArray()
        var time = measureTime {
            val metaData = resultSet.metaData
            while (resultSet.next()) {
                val metaData = resultSet.metaData
                val columnNames =
                    (1..metaData.columnCount).map { metaData.getColumnName(it) }.toTypedArray()
                while (resultSet.next()) {
                    val jsonObject = JSONObject()
                    columnNames.forEachIndexed { i, columnName ->
                        val columnValue = resultSet.getObject(columnName)
                        jsonObject.put(columnName, columnValue)
                    }
                    jsonArray.put(jsonObject)
                }

            }
        }
        Log.i("sqlConnectionPlugin", "Duration: $time")
        return jsonArray.toString()
    }
}
