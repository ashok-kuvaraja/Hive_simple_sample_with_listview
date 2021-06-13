import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_demo/hive_db_helper.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'inventory_model.dart';

Future<void> main() async {
  // EnsureInitialized before start to work in directory to overcome the
  // Services.instance null exception.
  WidgetsFlutterBinding.ensureInitialized();
  final appDirectory = await pathProvider.getApplicationDocumentsDirectory();
  // Initialize path to the hive.
  Hive.init(appDirectory.path);
  // Generated the `EmployeeAdapter` class by using the build_runner package with the below command
  // `flutter packages pub run build_runner build`
  Hive.registerAdapter(EmployeeAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController nameController;
  late TextEditingController designationController;

  @override
  void initState() {
    nameController = TextEditingController();
    designationController = TextEditingController();
    // Add some data to the employee box in initial loading.
    HiveDBHelper.addEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: _buildFloatingButton(),
      body: FutureBuilder(
        future: HiveDBHelper.getEmployees(),
        builder: (context, AsyncSnapshot<List<Employee>> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) =>
                      _buildEmployeeTile(index, snapshot))
              : _buildIndicator();
        },
      ),
    );
  }

  Card _buildEmployeeTile(int index, AsyncSnapshot<List<Employee>> snapshot) {
    return Card(
      child: ListTile(
        tileColor: Colors.teal,
        trailing: _buildDeleteButton(index),
        title: _buildTitle(snapshot, index),
        subtitle: _buildSubtitle(snapshot, index),
        leading: Icon(Icons.person_pin_outlined, color: Colors.white),
      ),
    );
  }

  void showDialogBox() async {
    showDialog(
      context: context,
      builder: (context) {
        return FittedBox(
          fit: BoxFit.fitWidth,
          child: AlertDialog(
            title: Text('Employee Details'),
            scrollable: true,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNameContent(),
                _buildDesignationContent(),
              ],
            ),
            actions: [
              _buildOkButton(context),
              _buildCancelButton(context),
            ],
          ),
        );
      },
    );
  }

  Center _buildIndicator() => Center(child: CircularProgressIndicator());

  IconButton _buildDeleteButton(int index) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.white),
      onPressed: () {
        HiveDBHelper.deleteEmployee(index);
        setState(() {});
      },
    );
  }

  Text _buildSubtitle(AsyncSnapshot<List<Employee>> snapshot, int index) {
    return Text(snapshot.data![index].designation,
        style: TextStyle(color: Colors.white));
  }

  Text _buildTitle(AsyncSnapshot<List<Employee>> snapshot, int index) {
    return Text(snapshot.data![index].name,
        style: TextStyle(color: Colors.white));
  }

  Row _buildDesignationContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(width: 130, child: Text('Designation')),
        Container(
            width: 130,
            child: TextFormField(controller: designationController)),
      ],
    );
  }

  Row _buildNameContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(width: 130, child: Text('Name')),
        Container(width: 130, child: TextFormField(controller: nameController))
      ],
    );
  }

  TextButton _buildCancelButton(BuildContext context) {
    return TextButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  TextButton _buildOkButton(BuildContext context) {
    return TextButton(
      child: Text('OK'),
      onPressed: () {
        HiveDBHelper.addEmployee(
            employee: Employee(
                name: nameController.text,
                designation: designationController.text));
        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  FloatingActionButton _buildFloatingButton() {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.white),
      onPressed: () {
        showDialogBox();
      },
    );
  }
}
