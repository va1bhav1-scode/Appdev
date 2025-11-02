import { router } from "expo-router";
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";
import colors from "../colors";

export default function Home() {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.greeting}>Hello Vaibhavi 👋</Text>

        <TouchableOpacity onPress={() => router.replace("/")}>
          <Text style={styles.logout}>Logout</Text>
        </TouchableOpacity>
      </View>

      <Text style={styles.welcome}>Welcome to your dashboard 🎧</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background, padding: 20, paddingTop: 60 },
  header: { flexDirection: "row", justifyContent: "space-between", alignItems: "center" },
  greeting: { color: colors.text, fontSize: 22, fontWeight: "bold" },
  logout: { color: "#1DB954", fontSize: 16 },
  welcome: { marginTop: 20, fontSize: 18, color: "#fff" },
});
