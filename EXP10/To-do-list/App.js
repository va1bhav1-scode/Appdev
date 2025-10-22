// App.js
import React, { useState, useEffect } from 'react';
import {
  ScrollView,
  TextInput,
  Button,
  Text,
  StyleSheet,
  View,
  ActivityIndicator,
  TouchableOpacity,
  Alert
} from 'react-native';
import { db } from './firebaseConfig';
import {
  collection,
  addDoc,
  onSnapshot,
  deleteDoc,
  doc,
  query,
  orderBy,
  serverTimestamp   // ✅ added for correct timestamp
} from 'firebase/firestore';

export default function App() {
  const [task, setTask] = useState('');
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // ✅ Using createdAt order, but ensure createdAt exists and is a timestamp
    const q = query(collection(db, 'tasks'), orderBy('createdAt', 'desc'));
    const unsubscribe = onSnapshot(
      q,
      (snapshot) => {
        const items = snapshot.docs.map(d => ({
          id: d.id,
          name: d.data().name
        }));
        setTasks(items);
        setLoading(false);
      },
      (err) => {
        console.error('onSnapshot error:', err);
        Alert.alert('Error', 'Failed to fetch tasks. Check console for details.');
        setLoading(false);
      }
    );

    return () => unsubscribe();
  }, []);

  const addTask = async () => {
    if (!task.trim()) return;
    try {
      // ✅ use serverTimestamp for Firestore ordering
      await addDoc(collection(db, 'tasks'), {
        name: task.trim(),
        createdAt: serverTimestamp()
      });
      setTask('');
    } catch (error) {
      console.error('Error adding task:', error);
      Alert.alert('Error', 'Could not add task. Check console for details.');
    }
  };

  const removeTask = async (id, name) => {
    Alert.alert(
      'Delete task',
      `Delete "${name}"?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: async () => {
            try {
              await deleteDoc(doc(db, 'tasks', id));
            } catch (error) {
              console.error('Error deleting task:', error);
              Alert.alert('Error', 'Could not delete task. Check console for details.');
            }
          }
        }
      ]
    );
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>📝 Firestore To-Do App</Text>

      <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center' }}>
        <TextInput
          style={styles.input}
          placeholder="Enter a task"
          value={task}
          onChangeText={setTask}
        />
        <Button title="ADD" onPress={addTask} />
      </View>

      {loading ? (
        <ActivityIndicator style={{ marginTop: 20 }} size="large" />
      ) : tasks.length === 0 ? (
        <Text style={{ marginTop: 20 }}>No tasks yet — add one!</Text>
      ) : (
        tasks.map((t) => (
          <TouchableOpacity
            key={t.id}
            onPress={() => removeTask(t.id, t.name)}
            activeOpacity={0.7}
            style={styles.taskContainer}
          >
            <Text style={styles.task}>• {t.name}</Text>
            <Text style={styles.deleteHint}>(tap to delete)</Text>
          </TouchableOpacity>
        ))
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: 20, marginTop: 50 },
  title: { fontSize: 24, fontWeight: 'bold', marginBottom: 20 },
  input: {
    flex: 1,
    borderWidth: 1,
    borderColor: '#ccc',
    padding: 10,
    marginBottom: 10,
    borderRadius: 5
  },
  taskContainer: {
    marginTop: 10,
    backgroundColor: '#f0f8ff',
    padding: 8,
    borderRadius: 5
  },
  task: {
    fontSize: 18
  },
  deleteHint: {
    fontSize: 12,
    color: '#555',
    marginTop: 4
  }
});
