package com.example.secureauthdemo

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.secureauthdemo.screens.*

sealed class Screen(val route: String) {
    object Login : Screen("login")
    object Signup : Screen("signup")
    object Forgot : Screen("forgot")
    object Phone : Screen("phone")
    object OTP : Screen("otp")
    object Home : Screen("home")
}

@Composable
fun AppNavGraph(
    navController: NavHostController = rememberNavController(),
    viewModel: AuthViewModel
) {
    NavHost(navController = navController, startDestination = Screen.Login.route) {
        composable(Screen.Login.route) {
            LoginScreen(nav = navController, vm = viewModel)
        }
        composable(Screen.Signup.route) {
            SignupScreen(nav = navController, vm = viewModel)
        }
        composable(Screen.Forgot.route) {
            ForgotPasswordScreen(nav = navController, vm = viewModel)
        }
        composable(Screen.Phone.route) {
            PhoneLoginScreen(nav = navController)
        }
        composable(Screen.OTP.route) {
            OtpScreen(nav = navController, vm = viewModel)
        }
        composable(Screen.Home.route) {
            HomeScreen(nav = navController, vm = viewModel)
        }
    }
}
