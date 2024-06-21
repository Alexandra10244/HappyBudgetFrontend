enum FilterExpenseCategory {
  ALL,
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

FilterExpenseCategory parseFilteredExpenseCategory(String category) {
  switch (category.toUpperCase()) {
    case 'ALL':
      return FilterExpenseCategory.ALL;
    case 'HOLIDAYS':
      return FilterExpenseCategory.HOLIDAYS;
    case 'EMERGENCIES':
      return FilterExpenseCategory.EMERGENCIES;
    case 'FOOD':
      return FilterExpenseCategory.FOOD;
    case 'PERSONAL':
      return FilterExpenseCategory.PERSONAL;
    case 'UTILITY':
      return FilterExpenseCategory.UTILITY;
    case 'RENT':
      return FilterExpenseCategory.RENT;
    case 'PHONE':
      return FilterExpenseCategory.PHONE;
    case 'ENTERTAINMENT':
      return FilterExpenseCategory.ENTERTAINMENT;
    case 'SAVINGS':
      return FilterExpenseCategory.SAVINGS;
    case 'WISHES':
      return FilterExpenseCategory.WISHES;
    default:
      throw ArgumentError('Invalid expense category: $category');
  }
}
