package com.example.secureauthdemo.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.example.secureauthdemo.AuthViewModel
import com.example.secureauthdemo.Screen

@Composable
fun OtpScreen(nav: NavController, vm: AuthViewModel) {
    var otp by remember { mutableStateOf("") }
    var loading by remember { mutableStateOf(false) }
    var error by remember { mutableStateOf<String?>(null) }

    Column(Modifier.fillMaxSize().padding(20.dp), verticalArrangement = Arrangement.Center) {
        Text("Verify OTP", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(12.dp))

        OutlinedTextField(otp, { otp = it }, label = { Text("Enter OTP (hint: 123456)") }, modifier = Modifier.fillMaxWidth())

        Spacer(Modifier.height(16.dp))

        Button(onClick = {
            loading = true
            vm.verifyOtp(otp.trim()) { ok ->
                loading = false
                if (ok) nav.navigate(Screen.Home.route) {
                    popUpTo(Screen.Login.route) { inclusive = true }
                } else error = "Invalid OTP (fake)."
            }
        }, modifier = Modifier.fillMaxWidth(), enabled = !loading) {
            if (loading) CircularProgressIndicator(modifier = Modifier.size(18.dp)) else Text("Verify")
        }

        error?.let {
            Spacer(Modifier.height(12.dp))
            Text(it, color = MaterialTheme.colorScheme.error)
        }
    }
}
