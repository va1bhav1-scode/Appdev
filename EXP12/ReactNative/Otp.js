import { router } from "expo-router";
import { StyleSheet, Text, TextInput, TouchableOpacity, View } from "react-native";
import colors from "../colors";

export default function OTP() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Enter OTP</Text>
      <TextInput style={styles.input} placeholder="123456" placeholderTextColor="#aaa" keyboardType="numeric" />

      <TouchableOpacity style={styles.button} onPress={() => router.push("/home")}>
        <Text style={styles.buttonText}>Verify</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, justifyContent: "center", padding: 20 },
  title: { fontSize: 26, color: "#fff", marginBottom: 25 },
  input: { backgroundColor: colors.input, padding: 15, borderRadius: 8, color: "#fff", marginBottom: 20 },
  button: { backgroundColor: colors.button, padding: 15, borderRadius: 8 },
  buttonText: { color: "#fff", textAlign: "center", fontSize: 16 },
});
