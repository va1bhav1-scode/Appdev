import * as SQLite from 'expo-sqlite';
import React, { useEffect, useState } from 'react';
import {
    Button,
    FlatList,
    ScrollView,
    StyleSheet,
    Text,
    TextInput,
    TouchableOpacity,
    View,
} from 'react-native';

const db = SQLite.openDatabase('tasks.db');

export default function App() {
  const [task, setTask] = useState('');
  const [tasks, setTasks] = useState([]);
  const [history, setHistory] = useState([]);

  useEffect(() => {
    db.transaction((tx) => {
      tx.executeSql(
        'CREATE TABLE IF NOT EXISTS history (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);',
        [],
        () => console.log('✅ History table created'),
        (_, error) => {
          console.error('❌ Error creating table:', error);
          return false;
        }
      );
    });
    fetchHistory();
  }, []);

  const addTask = () => {
    if (task.trim()) {
      setTasks([...tasks, task]);
      setTask('');
    }
  };

  const removeTask = (index) => {
    const completedTask = tasks[index];
    const updatedTasks = tasks.filter((_, i) => i !== index);
    setTasks(updatedTasks);

    db.transaction((tx) => {
      tx.executeSql(
        'INSERT INTO history (name) VALUES (?);',
        [completedTask],
        () => {
          console.log('✅ Task saved to history:', completedTask);
          fetchHistory();
        },
        (_, error) => {
          console.error('❌ Error saving task to history:', error);
          return false;
        }
      );
    });
  };

  const fetchHistory = () => {
    db.transaction((tx) => {
    interface HistoryRow {
        id: number;
        name: string;
    }

    tx.executeSql(
        'SELECT * FROM history;',
        [],
        (_tx: SQLite.SQLTransaction, result: SQLite.SQLResultSet) => {
            const items: string[] = [];
            const rows: SQLite.SQLResultSetRowList = result.rows;
            for (let i = 0; i < rows.length; i++) {
                const row = rows.item(i) as HistoryRow;
                items.push(row.name);
            }
            console.log('📜 Fetched history:', items);
            setHistory(items);
        },
        (_tx: SQLite.SQLTransaction, error: Error) => {
            console.error('❌ Error fetching history:', error);
            return false;
        }
    );
    });
  };

  return (
    <ScrollView contentContainerStyle={styles.scrollContainer}>
      <View style={styles.container}>
        <Text style={styles.title}>My To-Do List 📝</Text>

        <TextInput
          style={styles.input}
          placeholder="Add a task ✍️"
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

        <View style={styles.historyTab}>
          <Text style={styles.historyTitle}>History 📜</Text>
          {history.length === 0 ? (
            <Text style={styles.emptyHistory}>No completed tasks yet.</Text>
          ) : (
            history.map((item, index) => (
              <Text key={index} style={[styles.task, styles.historyItem]}>
                🕒 {item}
              </Text>
            ))
          )}
        </View>

        <View style={styles.historyIconContainer}>
          <Text style={styles.historyIcon}>📜 History is saved with SQLite</Text>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  scrollContainer: {
    flexGrow: 1,
  },
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#fffaf0',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#333',
  },
  input: {
    borderWidth: 1,
    borderColor: '#aaa',
    padding: 10,
    marginBottom: 10,
    borderRadius: 8,
  },
  task: {
    fontSize: 18,
    padding: 10,
    backgroundColor: '#f370ffff',
    marginVertical: 5,
    borderRadius: 6,
  },
  historyTab: {
    marginTop: 30,
    borderTopWidth: 1,
    borderTopColor: '#aaa',
    paddingTop: 10,
  },
  historyTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#333',
  },
  historyItem: {
    backgroundColor: '#ffd1dc',
  },
  emptyHistory: {
    fontSize: 16,
    color: '#727070ff',
    fontStyle: 'italic',
  },
  historyIconContainer: {
    marginTop: 20,
    alignItems: 'center',
  },
  historyIcon: {
    fontSize: 18,
    color: '#333',
  },
});