package com.example.secureauthdemo

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.navigation.compose.rememberNavController
import com.example.secureauthdemo.ui.theme.SecureAuthDemoTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val vm = AuthViewModel()

        setContent {
            SecureAuthDemoTheme {
                val navController = rememberNavController()
                AppNavGraph(navController = navController, viewModel = vm)
            }
        }
    }
}
