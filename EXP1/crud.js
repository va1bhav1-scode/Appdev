let students = ["Vaibhavi", "Amit", "Sneha"];

// CREATE
function addStudent(name) {
  students.push(name);
  console.log(`Added: ${name}`);
}

// READ
function listStudents() {
  console.log("Student List:");
  students.forEach((student, index) => {
    console.log(`${index + 1}. ${student}`);
  });
}

// UPDATE
function updateStudent(index, newName) {
  if (index >= 0 && index < students.length) {
    console.log(`Updated: ${students[index]} → ${newName}`);
    students[index] = newName;
  } else {
    console.log("Invalid index");
  }
}

// DELETE
function deleteStudent(index) {
  if (index >= 0 && index < students.length) {
    console.log(`Deleted: ${students[index]}`);
    students.splice(index, 1);
  } else {
    console.log("Invalid index");
  }
}

// Example usage
addStudent("Rahul");
listStudents();
updateStudent(1, "Anjali");
deleteStudent(0);
listStudents();