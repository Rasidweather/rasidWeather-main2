class AppStrings {
  static const String baseUrl = 'https://yaser20.pythonanywhere.com/en';


  static String appName = 'Rasid-Weather';

  static const String _authPrefix = '/auth/users';
  static String loginEndpoint = '$_authPrefix/signin/';
  static String getUserEndpoint(String userId) => '$_authPrefix/$userId/';
  static String logoutEndpoint = '$_authPrefix/logout';

  static const String _profilePrefix = '/v1/user';
  static String getProfileEndpoint = _profilePrefix;
  static String updateProfileEndpoint = '$_profilePrefix/update';
  static String updatePasswordEndpoint = '$_profilePrefix/password';
  static String updateAvatarEndpoint = '$_profilePrefix/avatar';
  static String searchUserEndpoint = '$_profilePrefix/search';

 Weather Endpoints
  static const String _weatherPrefix = '/weather';
  static String getWeatherEndpoint = _weatherPrefix;
  static String getChartsEndpoint = '$_weatherPrefix/chart';
  static String addProjectsEndpoint = '$_weatherPrefix/projects/';
  static String updateProjectEndpoint(String projectId) => '$_weatherPrefix/projects/$projectId/';
  static String deleteProjectEndpoint(String projectId) => '$_weatherPrefix/projects/$projectId/';
  static String generateProjectPDFEndpoint(String projectId) => '$_weatherPrefix/projects/$projectId/simple-report/';

  static const String _expensesPrefix = '/expenses/api';
  static String getExpensesEndpoint = '$_expensesPrefix/expenses-list/';
  static String addExpenseEndpoint = '$_expensesPrefix/expenses/';
  static String updateExpenseEndpoint(String expenseId) => '$_expensesPrefix/expenses/$expenseId/';
  static String deleteExpenseEndpoint(String expenseId) => '$_expensesPrefix/expenses/$expenseId/';
  static String generateProjectZipEndpoint(String projectId) => '$_expensesPrefix/export-project-expenses/$projectId/';


  static const String _generalPrefix = '/general_expenses/api';
  static String getGeneralListEndpoint = '$_generalPrefix/general-expenses-list/';
  static String addGeneralEndpoint = '$_generalPrefix/general-expenses/';
  static String exportGeneralEndpoint = '$_generalPrefix/expenses/export/';
  static String getGeneralIDEndpoint(String expenseId) => '$_generalPrefix/general-expenses/$expenseId/';
  static String updateGeneralEndpoint(String expenseId) => '$_generalPrefix/general-expenses/$expenseId/';
  static String deleteGeneralEndpoint(String expenseId) => '$_generalPrefix/general-expenses/$expenseId/';

  static const String _realEstatePrefix = '/real_estate/api';
  static String getRealEstateListEndpoint = '$_realEstatePrefix/properties/';
  static String addRealEstateEndpoint = '$_realEstatePrefix/property/';
  static String getRealEstateIDEndpoint(String realEstateId) => '$_realEstatePrefix/property/$realEstateId/';
  static String updateRealEstateEndpoint(String realEstateId) => '$_realEstatePrefix/property/$realEstateId/';

  static String addContractEndpoint(String realEstateId) => '$_realEstatePrefix/rental-contracts/$realEstateId/';
  static String getContractEndpoint(String rentalId) => '$_realEstatePrefix/rental-contracts/$rentalId/';
  static String updateContractEndpoint(String rentalId) => '$_realEstatePrefix/rental-contracts/$rentalId/';
  static String deleteContractEndpoint(String rentalId) => '$_realEstatePrefix/rental-contracts/$rentalId/';
  static String addPaymentEndpoint = '$_realEstatePrefix/rental-payments/';

  static const String _employeesPrefix = '/employees/api';
  static String getEmployeesEndpoint = '$_employeesPrefix/employees/';
  static String addEmployeesEndpoint = '$_employeesPrefix/employees/create/';
  static String getEmployeesIDEndpoint(String employeeId) => '$_employeesPrefix/employees/$employeeId/';
  static String updateEmployeeEndpoint(String employeeId) => '$_employeesPrefix/employees/$employeeId/';
  static String deleteEmployeeEndpoint(String employeeId) => '$_employeesPrefix/employees/$employeeId/';

  static const String _usersPrefix = '/auth/users';
  static String addUsersEndpoint = '$_usersPrefix/';
  static String getUsersEndpoint = '$_usersPrefix/';
  static String updateUserEndpoint(String userId) => '$_usersPrefix/$userId/';
  static String deleteUserEndpoint(String userId) => '$_usersPrefix/$userId/';


  static const String _carsPrefix = '/vehicles/api';
  static String getCarsListEndpoint = '$_carsPrefix/vehicles/';
  static String addCarEndpoint = '$_carsPrefix/vehicle_add/';
  static String getCarIDEndpoint(String carId) => '$_carsPrefix/vehicle/$carId/';
  static String updateCarEndpoint(String carId) => '$_carsPrefix/vehicle/$carId/';
  static String deleteCarEndpoint(String carId) => '$_carsPrefix/vehicle/$carId/';

  static String addMaintenanceEndpoint(String carId) => '$_carsPrefix/vehicle/$carId/maintenance/';
  static String getMaintenanceEndpoint(String maintenanceId) => '$_carsPrefix/vehicle/$maintenanceId/maintenance/';
  static String updateMaintenanceEndpoint(String maintenanceId) => '$_carsPrefix/vehicle/$maintenanceId/maintenance/';
  static String deleteMaintenanceEndpoint(String maintenanceId) => '$_carsPrefix/vehicle/$maintenanceId/maintenance/';

  static const String getNotificationsEndpoint = '/get/notifications';


}
