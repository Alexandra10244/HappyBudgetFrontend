import 'package:flutter/material.dart';

enum ExpenseCategory {
  HOLIDAYS,
  EMERGENCIES,
  FOOD,
  PERSONAL,
  UTILITY,
  RENT,
  PHONE,
  ENTERTAINMENT,
  SAVINGS,
  WISHES
}

const categoryIcons = {
  ExpenseCategory.HOLIDAYS : Icons.beach_access,
  ExpenseCategory.EMERGENCIES : Icons.crisis_alert,
  ExpenseCategory.FOOD : Icons.lunch_dining,
  ExpenseCategory.PERSONAL : Icons.person,
  ExpenseCategory.UTILITY : Icons.power_sharp,
  ExpenseCategory.RENT : Icons.house,
  ExpenseCategory.PHONE : Icons.phone_android,
  ExpenseCategory.ENTERTAINMENT : Icons.tv,
  ExpenseCategory.SAVINGS : Icons.savings,
  ExpenseCategory.WISHES : Icons.card_giftcard,

};

ExpenseCategory parseExpenseCategory(String category) {
  switch (category.toUpperCase()) {
    case 'HOLIDAYS':
      return ExpenseCategory.HOLIDAYS;
    case 'EMERGENCIES':
      return ExpenseCategory.EMERGENCIES;
    case 'FOOD':
      return ExpenseCategory.FOOD;
    case 'PERSONAL':
      return ExpenseCategory.PERSONAL;
    case 'UTILITY':
      return ExpenseCategory.UTILITY;
    case 'RENT':
      return ExpenseCategory.RENT;
    case 'PHONE':
      return ExpenseCategory.PHONE;
    case 'ENTERTAINMENT':
      return ExpenseCategory.ENTERTAINMENT;
    case 'SAVINGS':
      return ExpenseCategory.SAVINGS;
    case 'WISHES':
      return ExpenseCategory.WISHES;
    default:
      throw ArgumentError('Invalid expense category: $category');
  }
}