import 'package:hive/hive.dart';
part 'inventory_model.g.dart';

@HiveType(typeId: 0, adapterName: 'EmployeeAdapter')
class Employee {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String designation;

  Employee({required this.name, required this.designation});
}

List<Employee> populateEmployees() {
  return <Employee>[
    Employee(name: 'Ashok', designation: 'Software Engineer'),
    Employee(name: 'Arun', designation: 'Team Lead'),
    Employee(name: 'Aswin', designation: 'Manager'),
    Employee(name: 'Anandh', designation: 'Product Line Owner'),
  ];
}
