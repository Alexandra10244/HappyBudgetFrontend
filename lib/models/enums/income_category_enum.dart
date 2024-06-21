

import 'package:flutter/material.dart';

enum IncomeCategory {
  SALARY,
  BONUS,
  COMMISSION,
  FREELANCE,
  INVESTMENTS,
  RENTAL_INCOME,
  SIDE_HUSTLE,
  GIFTS,
  OTHER
}

const incomeCategoryIcons = {
  IncomeCategory.SALARY : Icons.money_outlined,
  IncomeCategory.BONUS : Icons.add,
  IncomeCategory.COMMISSION : Icons.payments_rounded,
  IncomeCategory.FREELANCE : Icons.person,
  IncomeCategory.INVESTMENTS : Icons.auto_graph,
  IncomeCategory.RENTAL_INCOME : Icons.house,
  IncomeCategory.SIDE_HUSTLE: Icons.computer,
  IncomeCategory.GIFTS : Icons.card_giftcard,
  IncomeCategory.OTHER : Icons.savings,
};

IncomeCategory parseIncomeCategory(String category) {
  switch (category.toUpperCase()) {
    case 'SALARY':
      return IncomeCategory.SALARY;
    case 'BONUS':
      return IncomeCategory.BONUS;
    case 'COMMISSION':
      return IncomeCategory.COMMISSION;
    case 'FREELANCE':
      return IncomeCategory.FREELANCE;
    case 'INVESTMENTS':
      return IncomeCategory.INVESTMENTS;
    case 'RENTAL_INCOME':
      return IncomeCategory.RENTAL_INCOME;
    case 'SIDE_HUSTLE':
      return IncomeCategory.SIDE_HUSTLE;
    case 'GIFTS':
      return IncomeCategory.GIFTS;
    case 'OTHER':
      return IncomeCategory.OTHER;
    default:
      throw ArgumentError('Invalid expense category: $category');
  }
}