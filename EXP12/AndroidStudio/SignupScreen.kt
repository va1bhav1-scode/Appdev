package com.example.secureauthdemo.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.example.secureauthdemo.AuthViewModel
import com.example.secureauthdemo.Screen

@Composable
fun SignupScreen(nav: NavController, vm: AuthViewModel) {
    var name by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var pass by remember { mutableStateOf("") }
    var loading by remember { mutableStateOf(false) }
    var error by remember { mutableStateOf<String?>(null) }

    Column(Modifier.fillMaxSize().padding(20.dp), verticalArrangement = Arrangement.Center) {
        Text("Create Account", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(12.dp))

        OutlinedTextField(name, { name = it }, label = { Text("Full name") },
            leadingIcon = { Icon(Icons.Default.Person, null) }, modifier = Modifier.fillMaxWidth())

        Spacer(Modifier.height(8.dp))

        OutlinedTextField(email, { email = it }, label = { Text("Email") }, modifier = Modifier.fillMaxWidth())

        Spacer(Modifier.height(8.dp))

        OutlinedTextField(pass, { pass = it }, label = { Text("Password") }, modifier = Modifier.fillMaxWidth())

        Spacer(Modifier.height(16.dp))

        Button(onClick = {
            loading = true
            vm.signup(name.trim(), email.trim(), pass.trim()) { ok, msg ->
                loading = false
                if (ok) nav.navigate(Screen.Home.route) {
                    popUpTo(Screen.Signup.route) { inclusive = true }
                } else error = msg
            }
        }, enabled = !loading, modifier = Modifier.fillMaxWidth()) {
            if (loading) CircularProgressIndicator(modifier = Modifier.size(18.dp)) else Text("Create Account")
        }

        error?.let {
            Spacer(Modifier.height(10.dp))
            Text(it, color = MaterialTheme.colorScheme.error)
        }
    }
}
