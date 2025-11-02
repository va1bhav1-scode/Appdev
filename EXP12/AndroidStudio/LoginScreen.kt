package com.example.secureauthdemo.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.example.secureauthdemo.AuthViewModel
import com.example.secureauthdemo.Screen

@Composable
fun LoginScreen(nav: NavController, vm: AuthViewModel) {
    var email by remember { mutableStateOf("") }
    var pass by remember { mutableStateOf("") }
    var isLoading by remember { mutableStateOf(false) }
    var error by remember { mutableStateOf<String?>(null) }

    Column(
        Modifier
            .fillMaxSize()
            .padding(20.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text("Welcome Back", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(12.dp))

        OutlinedTextField(
            value = email,
            onValueChange = { email = it },
            label = { Text("Email") },
            leadingIcon = { Icon(Icons.Default.Email, contentDescription = null) },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(Modifier.height(8.dp))

        OutlinedTextField(
            value = pass,
            onValueChange = { pass = it },
            label = { Text("Password") },
            leadingIcon = { Icon(Icons.Default.Lock, contentDescription = null) },
            visualTransformation = PasswordVisualTransformation(),
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(Modifier.height(16.dp))

        Button(
            onClick = {
                isLoading = true
                vm.login(email.trim(), pass.trim()) { ok, msg ->
                    isLoading = false
                    if (ok) nav.navigate(Screen.Home.route) {
                        popUpTo(Screen.Login.route) { inclusive = true }
                    } else error = msg
                }
            },
            modifier = Modifier.fillMaxWidth(),
            enabled = !isLoading
        ) {
            if (isLoading) CircularProgressIndicator(modifier = Modifier.size(18.dp)) else Text("Login")
        }

        Spacer(Modifier.height(10.dp))

        TextButton(onClick = { nav.navigate(Screen.Forgot.route) }) {
            Text("Forgot Password?")
        }

        Spacer(Modifier.height(8.dp))

        OutlinedButton(onClick = { nav.navigate(Screen.Phone.route) }, modifier = Modifier.fillMaxWidth()) {
            Icon(Icons.Default.Phone, contentDescription = null)
            Spacer(Modifier.width(8.dp))
            Text("Login with Phone (Fake)")
        }

        Spacer(Modifier.height(8.dp))

        OutlinedButton(onClick = { /* fake google */ nav.navigate(Screen.Home.route) }, modifier = Modifier.fillMaxWidth()) {
            Icon(Icons.Default.AccountCircle, contentDescription = null)
            Spacer(Modifier.width(8.dp))
            Text("Continue with Google (Fake)")
        }

        Spacer(Modifier.height(12.dp))

        Row {
            Text("Don't have an account? ")
            Text("Sign up", Modifier.clickable { nav.navigate(Screen.Signup.route) }, color = MaterialTheme.colorScheme.primary)
        }

        error?.let {
            Spacer(Modifier.height(10.dp))
            Text(it, color = MaterialTheme.colorScheme.error)
        }
    }
}
