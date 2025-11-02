package com.example.secureauthdemo

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.runBlocking

/**
 * Simple ViewModel that uses AuthService synchronously via runBlocking.
 * For UI demonstration only (keeps code minimal to paste).
 */
class AuthViewModel : ViewModel() {

    private val _isLoggedIn = MutableStateFlow(false)
    val isLoggedIn: StateFlow<Boolean> = _isLoggedIn

    var currentUserEmail: String? = null
        private set

    fun login(email: String, password: String, onResult: (Boolean, String?) -> Unit) {
        runBlocking {
            val ok = AuthService.loginWithEmail(email, password)
            if (ok) {
                _isLoggedIn.value = true
                currentUserEmail = email
                onResult(true, null)
            } else {
                onResult(false, "Invalid credentials (fake).")
            }
        }
    }

    fun signup(name: String, email: String, password: String, onResult: (Boolean, String?) -> Unit) {
        runBlocking {
            val ok = AuthService.registerUser(name, email, password)
            if (ok) {
                _isLoggedIn.value = true
                currentUserEmail = email
                onResult(true, null)
            } else {
                onResult(false, "Invalid signup details (fake).")
            }
        }
    }

    fun sendOtp(phone: String, onResult: (Boolean) -> Unit) {
        runBlocking {
            val ok = AuthService.sendOtp(phone)
            onResult(ok)
        }
    }

    fun verifyOtp(otp: String, onResult: (Boolean) -> Unit) {
        runBlocking {
            val ok = AuthService.verifyOtp(otp)
            if (ok) _isLoggedIn.value = true
            onResult(ok)
        }
    }

    fun resetPassword(email: String, onResult: (Boolean) -> Unit) {
        runBlocking {
            val ok = AuthService.sendPasswordReset(email)
            onResult(ok)
        }
    }

    fun logout() {
        _isLoggedIn.value = false
        currentUserEmail = null
    }
}
