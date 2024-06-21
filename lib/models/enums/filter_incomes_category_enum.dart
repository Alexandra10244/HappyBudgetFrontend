enum FilterIncomeCategory {
  ALL,
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

FilterIncomeCategory parseFilteredIncomeCategory(String category) {
  switch (category.toUpperCase()) {
    case 'ALL':
      return FilterIncomeCategory.ALL;
    case 'SALARY':
      return FilterIncomeCategory.SALARY;
    case 'BONUS':
      return FilterIncomeCategory.BONUS;
    case 'COMMISSION':
      return FilterIncomeCategory.COMMISSION;
    case 'FREELANCE':
      return FilterIncomeCategory.FREELANCE;
    case 'INVESTMENTS':
      return FilterIncomeCategory.INVESTMENTS;
    case 'RENTAL_INCOME':
      return FilterIncomeCategory.RENTAL_INCOME;
    case 'SIDE_HUSTLE':
      return FilterIncomeCategory.SIDE_HUSTLE;
    case 'GIFTS':
      return FilterIncomeCategory.GIFTS;
    case 'OTHER':
      return FilterIncomeCategory.OTHER;
    default:
      throw ArgumentError('Invalid expense category: $category');
  }
}