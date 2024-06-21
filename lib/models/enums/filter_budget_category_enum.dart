enum FilterBudgetCategory {
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
  WISHES,
  UNUSED
}

FilterBudgetCategory parseFilteredBudgetCategory(String category) {
  switch (category.toUpperCase()) {
    case 'ALL':
      return FilterBudgetCategory.ALL;
    case 'HOLIDAYS':
      return FilterBudgetCategory.HOLIDAYS;
    case 'EMERGENCIES':
      return FilterBudgetCategory.EMERGENCIES;
    case 'FOOD':
      return FilterBudgetCategory.FOOD;
    case 'PERSONAL':
      return FilterBudgetCategory.PERSONAL;
    case 'UTILITY':
      return FilterBudgetCategory.UTILITY;
    case 'RENT':
      return FilterBudgetCategory.RENT;
    case 'PHONE':
      return FilterBudgetCategory.PHONE;
    case 'ENTERTAINMENT':
      return FilterBudgetCategory.ENTERTAINMENT;
    case 'SAVINGS':
      return FilterBudgetCategory.SAVINGS;
    case 'WISHES':
      return FilterBudgetCategory.WISHES;
    case 'UNUSED':
      return FilterBudgetCategory.UNUSED;
    default:
      throw ArgumentError('Invalid expense category: $category');
  }
}