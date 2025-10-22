# 📱 Stylish Calculator App with SQLite History

A beautifully designed calculator app built using **Flutter**, featuring real-time expression evaluation and persistent **calculation history** using **SQLite**.

---

## ✨ Features

- Basic arithmetic operations: `+`, `-`, `×`, `÷`
- Real-time expression parsing using `math_expressions`
- Save each calculation to local SQLite database
- View history in a modal bottom sheet
- Clear history with a single tap
- Stylish UI with custom button layout and colors

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/stylish_calculator.git
cd stylish_calculator
2. Install Dependencies
flutter pub get
3. Run the App
flutter run
🧮 SQLite Integration
This app uses  and  to store calculation history.
Database Schema
CREATE TABLE history (
  id INTEGER PRIMARY KEY,
  input TEXT,
  result TEXT
);
⚠️ Notes
- Replaced deprecated Parser with ShuntingYardParser from math_expressions.
- Added if (!mounted) return; to avoid context issues across async gaps.
