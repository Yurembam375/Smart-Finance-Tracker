# 💰 Smart Finance Tracker

A **personal expense management app** built with **Flutter** and **Riverpod** for state management.  
This app allows users to **track income and expenses**, view a **summary of their balance**, and manage transactions efficiently with a clean and responsive UI.

---

## 🚀 Features

- ✅ Add, view, and delete transactions  
- 💸 Display current balance and categorized expenses  
- 🧮 Automatic total calculation for income and expenses  
- 🧭 Riverpod-powered state management  
- 🧱 Hive for local data persistence  
- 🧑‍💻 Unit and widget testing for reliability  
- 📱 Responsive and clean UI design  

---

## 🏗️ Project Architecture

This project follows the **MVVM (Model-View-ViewModel)** pattern combined with **Riverpod** for reactive and modular state management.

lib/
├── main.dart
├── model/
│ └── transaction_model.dart # Data model (Hive)
├── notifier/
│ └── transaction_notifier.dart # StateNotifier for managing transactions
├── screen/
│ └── home_screen.dart # UI for dashboard and transaction list
├── widget/
│ └── transaction_card.dart # Reusable widget for displaying a transaction
└── utils/
└── hive_boxes.dart # Hive box initialization

## ⚙️ Tech Stack

| Technology | Purpose |
|-------------|----------|
| **Flutter** | UI framework |
| **Riverpod** | State management |
| **Hive** | Local database for offline storage |
| **Material 3** | UI design |
| **Flutter Test** | Unit & widget testing |

---

## 🧠 State Management (Riverpod)

This app uses **StateNotifierProvider** from Riverpod to handle app state efficiently.

final transactionProvider = StateNotifierProvider<TransactionNotifier, AsyncValue<List<TransactionModel>>>(
  (ref) => TransactionNotifier(),
);
🧪 Testing
The app includes unit and widget tests to ensure reliable functionality.

Example test file:


test/
├── home_screen_test.dart             # UI tests for HomeScreen
└── transaction_notifier_test.dart    # Logic tests for add/delete transactions
Run tests with:

flutter test
🛠️ Setup Instructions
1. Clone the Repository
git clone https://github.com/<your-username>/Smart-Finance-Tracker.git
cd Smart-Finance-Tracker
2. Install Dependencies
flutter pub get
3. Generate Hive Adapter

flutter packages pub run build_runner build
4. Run the App

flutter run
5. Run Tests

flutter test
🧩 Folder Breakdown
Folder	Description
model/	Defines data structures like TransactionModel
notifier/	Contains TransactionNotifier for managing app logic
screen/	UI screens (Home, Add Transaction, etc.)
widget/	Reusable UI components
utils/	Helper classes, Hive initialization, etc.
test/	Unit and widget test files

🧾 Example Test Result

00:03 +3: All tests passed!

👨‍💻 Author
Yurembam Sanatomba
📍 Flutter Developer 
💼 Passionate about building dynamic, responsive, and intelligent mobile applications using Flutter, Firebase, and modern state management tools.

🪪 License
This project is licensed under the MIT License — feel free to use and modify it.
