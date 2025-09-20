import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  Button,
  FlatList,
  StyleSheet,
  TouchableOpacity,
} from 'react-native';

export default function DefaultScreen() {
  const [task, setTask] = useState('');
  const [tasks, setTasks] = useState<string[]>([]);

  const addTask = () => {
    if (task.trim()) {
      setTasks([...tasks, task]);
      setTask('');
    }
  };

  const removeTask = (index: number) => {
    const updatedTasks = tasks.filter((_, i) => i !== index);
    setTasks(updatedTasks);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>My To-Do List App</Text>

      <TextInput
        style={styles.input}
        placeholder="Add your task ✍️"
        value={task}
        onChangeText={setTask}
      />

      <Button title="Add Task ➕" onPress={addTask} />

      <FlatList
        data={tasks}
        keyExtractor={(item, index) => index.toString()}
        renderItem={({ item, index }) => (
          <TouchableOpacity onPress={() => removeTask(index)}>
            <Text style={styles.task}>✅ {item}</Text>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#cefcf4ff',
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#060606ff',
  },
  input: {
    borderWidth: 1,
    borderColor: '#727070ff',
    padding: 10,
    marginBottom: 10,
    borderRadius: 8,
  },
  task: {
    fontSize: 18,
    padding: 10,
    backgroundColor: '#6cbcfaff',
    marginVertical: 5,
    borderRadius: 6,
  },
});