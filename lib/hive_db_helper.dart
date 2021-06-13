import 'package:hive/hive.dart';
import 'inventory_model.dart';

// Provides the functionalities to do CRUD operations.
class HiveDBHelper {
  HiveDBHelper();

  // Add employee to the employee box
  static void addEmployee({required Employee employee}) async {
    final employeeBox = await Hive.openBox<Employee>('Employee');
    employeeBox.add(employee);
  }

  // Remove employee to the employee box
  static void deleteEmployee(int index) async {
    final employeeBox = await Hive.openBox<Employee>('Employee');
    employeeBox.deleteAt(index);
  }

  // Add employees to the employee box initially.
  static Future<void> addEmployees() async {
    var employeeBox = await Hive.openBox<Employee>('Employee');
    if (employeeBox.values.isEmpty) {
      populateEmployees().forEach((employee) {
        employeeBox.add(employee);
      });
    }
  }

  // Get employees from the employee box. 
  static Future<List<Employee>> getEmployees() async {
    final employeeBox = await Hive.openBox<Employee>('Employee');
    return employeeBox.values.toList();
  }
}
