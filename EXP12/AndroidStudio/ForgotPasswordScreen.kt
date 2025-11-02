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
fun ForgotPasswordScreen(nav: NavController, vm: AuthViewModel) {
    var email by remember { mutableStateOf("") }
    var loading by remember { mutableStateOf(false) }
    var info by remember { mutableStateOf<String?>(null) }

    Column(Modifier.fillMaxSize().padding(20.dp), verticalArrangement = Arrangement.Center) {
        Text("Reset Password", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(12.dp))

        OutlinedTextField(email, { email = it }, label = { Text("Email") }, modifier = Modifier.fillMaxWidth())

        Spacer(Modifier.height(16.dp))

        Button(onClick = {
            loading = true
            vm.resetPassword(email.trim()) { ok ->
                loading = false
                info = if (ok) "Reset email sent (fake)." else "Failed to send (fake)."
            }
        }, modifier = Modifier.fillMaxWidth(), enabled = !loading) {
            if (loading) CircularProgressIndicator(modifier = Modifier.size(18.dp)) else Text("Send Reset Email")
        }

        info?.let {
            Spacer(Modifier.height(12.dp))
            Text(it)
        }
    }
}
