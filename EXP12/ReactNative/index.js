import { router } from "expo-router";
import { useState } from "react";
import { StyleSheet, Text, TextInput, TouchableOpacity, View } from "react-native";
import colors from "../colors";

export default function Login() {
  const [email, setEmail] = useState("");

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome Back 🎧</Text>

      <TextInput
        placeholder="Email"
        placeholderTextColor="#aaa"
        style={styles.input}
        value={email}
        onChangeText={setEmail}
      />

      {/* ✅ Login & go to home */}
      <TouchableOpacity 
        style={styles.button} 
        onPress={() => router.replace("/home")}
      >
        <Text style={styles.buttonText}>Login</Text>
      </TouchableOpacity>

      <TouchableOpacity onPress={() => router.push("/signup")}>
        <Text style={styles.link}>Create Account</Text>
      </TouchableOpacity>

      <TouchableOpacity onPress={() => router.push("/forgot")}>
        <Text style={styles.link}>Forgot Password?</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
    justifyContent: "center",
    padding: 20,
  },
  title: {
    fontSize: 28,
    color: colors.text,
    marginBottom: 30,
    fontWeight: "bold",
  },
  input: {
    backgroundColor: colors.input,
    color: colors.text,
    borderRadius: 8,
    padding: 15,
    marginBottom: 15,
  },
  button: {
    backgroundColor: colors.button,
    padding: 15,
    borderRadius: 8,
    marginTop: 10,
  },
  buttonText: { color: "#fff", textAlign: "center", fontSize: 16 },
  link: { color: "#1DB954", marginTop: 15, textAlign: "center" },
});
