import { router } from "expo-router";
import { StyleSheet, Text, TextInput, TouchableOpacity, View } from "react-native";
import colors from "../colors";

export default function Signup() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Create Account 🎶</Text>

      <TextInput style={styles.input} placeholder="Email" placeholderTextColor="#aaa" />
      <TextInput style={styles.input} placeholder="Password" placeholderTextColor="#aaa" secureTextEntry />

      <TouchableOpacity style={styles.button} onPress={() => router.push("/otp")}>
        <Text style={styles.buttonText}>Continue</Text>
      </TouchableOpacity>

      <TouchableOpacity onPress={() => router.back()}>
        <Text style={styles.link}>Already have an account? Login</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, justifyContent: "center", padding: 20 },
  title: { fontSize: 28, color: colors.text, marginBottom: 30, fontWeight: "bold" },
  input: { backgroundColor: colors.input, color: "#fff", borderRadius: 8, padding: 15, marginBottom: 15 },
  button: { backgroundColor: colors.button, padding: 15, borderRadius: 8 },
  buttonText: { color: "#fff", textAlign: "center", fontSize: 16 },
  link: { color: "#1DB954", marginTop: 15, textAlign: "center" },
});
