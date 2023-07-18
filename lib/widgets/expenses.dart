import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cenima',
      amount: 16.59,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Trip To Hawaii',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: 'Steak on the street',
      amount: 10.00,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (modalCtx) => NewExpense(
        saveNewExpense: (Expense expense) {
          _addExpense(expense);
        },
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
    Navigator.pop(context);
  }

  void _removeExpense(Expense expense) {
    final epenseIndex = _registeredExpenses.indexOf(
      expense,
    ); // we need to get the index before we remove it from the list
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text(
          'Expense removed.',
          // textAlign: TextAlign.center,
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(
                epenseIndex,
                expense,
              );
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found! You can add some.'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        remove: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Flutter Expense Tracker',
          ),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            )
          ]),
      body: Column(
        children: [
          const Text('The Chart'),
          Expanded(child: mainContent),
        ],
      ),
    );
  }
}
