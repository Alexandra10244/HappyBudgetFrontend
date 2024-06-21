import 'package:flutter/material.dart';

enum BudgetCategory {
  HOLIDAYS,
  EMERGENCIES,
  FOOD,
  PERSONAL,
  UTILITY,
  RENT,
  PHONE,
  ENTERTAINMENT,
  SAVINGS,
  WISHES,
  UNUSED
}

const budgetCategoryIcons = {
  BudgetCategory.HOLIDAYS : Icons.airplane_ticket_outlined,
  BudgetCategory.EMERGENCIES : Icons.error_outline_rounded,
  BudgetCategory.FOOD : Icons.fastfood,
  BudgetCategory.PERSONAL : Icons.person,
  BudgetCategory.UTILITY : Icons.electric_bolt,
  BudgetCategory.RENT : Icons.house,
  BudgetCategory.PHONE: Icons.phone_android,
  BudgetCategory.ENTERTAINMENT : Icons.movie_filter_outlined,
  BudgetCategory.SAVINGS : Icons.savings,
  BudgetCategory.WISHES : Icons.card_giftcard,
  BudgetCategory.UNUSED : Icons.equalizer,
};

BudgetCategory parseBudgetCategory(String category) {
  switch (category.toUpperCase()) {
    case 'HOLIDAYS':
      return BudgetCategory.HOLIDAYS;
    case 'EMERGENCIES':
      return BudgetCategory.EMERGENCIES;
    case 'FOOD':
      return BudgetCategory.FOOD;
    case 'PERSONAL':
      return BudgetCategory.PERSONAL;
    case 'UTILITY':
      return BudgetCategory.UTILITY;
    case 'RENT':
      return BudgetCategory.RENT;
    case 'PHONE':
      return BudgetCategory.PHONE;
    case 'ENTERTAINMENT':
      return BudgetCategory.ENTERTAINMENT;
    case 'SAVINGS':
      return BudgetCategory.SAVINGS;
    case 'WISHES':
      return BudgetCategory.WISHES;
    case 'UNUSED':
      return BudgetCategory.UNUSED;
    default:
      throw ArgumentError('Invalid expense category: $category');
  }
}