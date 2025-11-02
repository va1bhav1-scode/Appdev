package com.example.secureauthdemo

import kotlinx.coroutines.delay

/**
 * A fake "auth service" that imitates network calls.
 * OTP is fixed to "123456". No real network or Firebase calls.
 */
object AuthService {
    suspend fun loginWithEmail(email: String, password: String): Boolean {
        delay(700) // fake network delay
        return email.isNotBlank() && password.length >= 4
    }

    suspend fun registerUser(name: String, email: String, password: String): Boolean {
        delay(900)
        return name.isNotBlank() && email.isNotBlank() && password.length >= 4
    }

    suspend fun sendOtp(phone: String): Boolean {
        delay(700)
        return phone.length >= 10
    }

    suspend fun verifyOtp(otp: String): Boolean {
        delay(600)
        return otp == "123456"
    }

    suspend fun sendPasswordReset(email: String): Boolean {
        delay(700)
        return email.isNotBlank()
    }
}
