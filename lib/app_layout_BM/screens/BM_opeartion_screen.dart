import 'package:bloc_v2/Features/branch_features/Data/add_menu_item.dart';
import 'package:bloc_v2/Features/branch_features/models/add_general_section_model.dart';
import 'package:bloc_v2/add_ingredient/add_ingredient_model.dart';
import 'package:bloc_v2/add_ingredient/add_ingredient_toStock_model.dart';
import 'package:bloc_v2/add_storage/add_storage_model.dart';
import 'package:bloc_v2/app_layout_BM/screens/add_item_branch_menu_model.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cherry_toast/cherry_toast.dart';

class BranchMangerOpeartion extends StatefulWidget {
  @override
  _BranchMangerOpeartionState createState() => _BranchMangerOpeartionState();
}

class _BranchMangerOpeartionState extends State<BranchMangerOpeartion> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> managerEmployees = [];
  List<Map<String, dynamic>> branches = [];
  List<Map<String, dynamic>> sections = [];
  List<Map<String, dynamic>> menuItems = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> ingredients = []; // Add this line

  @override
  void initState() {
    super.initState();
    fetchManagerEmployees();
    fetchBranches();
    fetchSections();
    fetchMenuItems();
    fetchCategories();
    fetchIngredients(); // Add this line
  }

  Future<void> fetchIngredients() async {
    final url = Uri.parse('https://54.235.40.102.nip.io/admin/branch/ingredients');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          ingredients = (jsonBody['data'] as List)
              .map<Map<String, dynamic>>((ingredient) => {
                    'ingredient_id': ingredient['ingredient_id'],
                    'ingredients_name': ingredient['ingredients_name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      print('Error loading ingredients: $e');
    }
  }

  Future<void> fetchCategories() async {
    final url =
        Uri.parse('https://54.235.40.102.nip.io/admin/branch/categories-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          categories = (jsonBody['data'] as List)
              .map<Map<String, dynamic>>((category) => {
                    'category_id': category['category_id'],
                    'category_name': category['category_name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> fetchMenuItems() async {
    final url =
        Uri.parse('https://54.235.40.102.nip.io/admin/branch/general-menu-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          menuItems = (jsonBody['data'] as List)
              .map<Map<String, dynamic>>((item) => {
                    'id': item['id'],
                    'name': item['name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (e) {
      print('Error loading menu items: $e');
    }
  }

  Future<void> fetchManagerEmployees() async {
    final url = Uri.parse(
        'https://54.235.40.102.nip.io/admin/employees/manager-employees-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          managerEmployees = (jsonBody['data'] as List)
              .map<Map<String, dynamic>>((employee) => {
                    'employee_id': employee['id'],
                    'employee_name': employee['name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load manager employees');
      }
    } catch (e) {
      print('Error loading manager employees: $e');
    }
  }

  Future<void> fetchBranches() async {
    final url =
        Uri.parse('https://54.235.40.102.nip.io/admin/branch/branches-list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          branches = (jsonBody['data'] as List)
              .map<Map<String, dynamic>>((branch) => {
                    'branch_id': branch['branch_id'],
                    'branch_name': branch['branch_name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load branches');
      }
    } catch (e) {
      print('Error loading branches: $e');
    }
  }

  Future<void> fetchSections() async {
    final url = Uri.parse('https://54.235.40.102.nip.io/admin/branch/sections/1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        setState(() {
          sections = (jsonBody['data']['sections'] as List)
              .map<Map<String, dynamic>>((section) => {
                    'id': section['id'],
                    'name': section['name'],
                  })
              .toList();
        });
      } else {
        throw Exception('Failed to load sections');
      }
    } catch (e) {
      print('Error loading sections: $e');
    }
  }

  void clearFormFields() {
    _formKey.currentState?.reset();
  }

  Future<void> _selectMinutes(TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        String formattedTime =
            "00:" + pickedTime.minute.toString().padLeft(2, '0') + ":00";
        controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Branch Manager', style: GoogleFonts.lato()),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FunctionInputTile(
                  functionName: 'add-storage',
                  attributeNames: const [
                    'Storage Name',
                    'storageAddress',
                    'managerId'
                  ],
                  managerEmployees: managerEmployees,
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await addStorageModel(
                          storageName: values['Storage Name']!,
                          storageAddress: values['storageAddress']!,
                          managerId: values['managerId']!,
                        );
                        print('Adding Storage: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Add Storage successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error adding storage: $e');
                        CherryToast.error(
                          toastPosition: Position.bottom,
                          animationType: AnimationType.fromRight,
                          description: const Text(
                            "Something went wrong!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                      }
                    } else {
                      print('Form is not valid');
                      CherryToast.warning(
                        toastPosition: Position.bottom,
                        animationType: AnimationType.fromLeft,
                        description: const Text(
                          "Data is not valid or not complete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ).show(context);
                    }
                  },
                ),
                FunctionInputTile(
                  functionName: 'add-menu-item',
                  attributeNames: const [
                    'Item Name',
                    'itemDesc',
                    'Category',
                    'prepTime',
                    'picPath',
                    'vegetarian',
                    'healthy'
                  ],
                  categories: categories, // Add this line
                  managerEmployees: managerEmployees,
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await addMenuItem(
                          itemName: values['Item Name']!,
                          itemDesc: values['itemDesc']!,
                          categoryID: values['Category']!,
                          prepTime: values['prepTime']!,
                          picPath: values['picPath']!,
                          vegetarian: values['vegetarian']!,
                          healthy: values['healthy']!,
                        );
                        print('Adding Storage: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Add Item Menu successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error add menu item: $e');
                        CherryToast.error(
                          toastPosition: Position.bottom,
                          animationType: AnimationType.fromRight,
                          description: const Text(
                            "Something went wrong!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                      }
                    } else {
                      print('Form is not valid');
                      CherryToast.warning(
                        toastPosition: Position.bottom,
                        animationType: AnimationType.fromLeft,
                        description: const Text(
                          "Data is not valid or not complete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ).show(context);
                    }
                  },
                  selectMinutes:
                      _selectMinutes, // Pass the selectMinutes function here
                ),
                FunctionInputTile(
                  functionName: 'add-ingredient',
                  attributeNames: const [
                    'Ingredient Name',
                    'recipeUnit',
                    'shipmentUnit'
                  ],
                  managerEmployees: managerEmployees,
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await addIngredient_model(
                          name: values['Ingredient Name']!,
                          recipeUnit: values['recipeUnit']!,
                          shipmentUnit: values['shipmentUnit']!,
                        );
                        print('Adding Storage: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Add Ingredient successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error adding storage: $e');
                        CherryToast.error(
                          toastPosition: Position.bottom,
                          animationType: AnimationType.fromRight,
                          description: const Text(
                            "Something went wrong!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                      }
                    } else {
                      print('Form is not valid');
                      CherryToast.warning(
                        toastPosition: Position.bottom,
                        animationType: AnimationType.fromLeft,
                        description: const Text(
                          "Data is not valid or not complete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ).show(context);
                    }
                  },
                ),
                FunctionInputTile(
                  functionName: 'add_branch_section',
                  attributeNames: const [
                    'Branch Name',
                    'section_id',
                    'manager_id'
                  ],
                  managerEmployees: managerEmployees,
                  branches: branches,
                  sections: sections,
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await addGeneralSectionModel(
                          branch_id: values['Branch Name']!,
                          section_id: values['section_id']!,
                          manager_id: values['manager_id']!,
                        );
                        print('Adding Storage: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Add Branch Section successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error adding storage: $e');
                        CherryToast.error(
                          toastPosition: Position.bottom,
                          animationType: AnimationType.fromRight,
                          description: const Text(
                            "Something went wrong!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                      }
                    } else {
                      print('Form is not valid');
                      CherryToast.warning(
                        toastPosition: Position.bottom,
                        animationType: AnimationType.fromLeft,
                        description: const Text(
                          "Data is not valid or not complete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ).show(context);
                    }
                  },
                ),
                FunctionInputTile(
                  functionName: 'addIngredientToStock',
                  attributeNames: const [
                    'branchId',
                    'ingredientId',
                    'ingredientQuantity'
                  ],
                  ingredients: ingredients, // Pass ingredients here

                  managerEmployees: managerEmployees,
                  branches: branches, // Make sure this is passed
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model =
                            await addIngredientToStock_model(
                          branchId: values['branchId']!,
                          ingredientId: values['ingredientId']!,
                          ingredientQuantity: values['ingredientQuantity']!,
                        );
                        print('Adding Ingredient To Stock: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Add Ingredient To the Stock successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error adding Ingredient To the Stock: $e');
                        CherryToast.error(
                          toastPosition: Position.bottom,
                          animationType: AnimationType.fromRight,
                          description: const Text(
                            "Something went wrong!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                      }
                    } else {
                      print('Form is not valid');
                      CherryToast.warning(
                        toastPosition: Position.bottom,
                        animationType: AnimationType.fromLeft,
                        description: const Text(
                          "Data is not valid or not complete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ).show(context);
                    }
                  },
                ),
                FunctionInputTile(
                  functionName: 'addItemBranchMenu',
                  attributeNames: const [
                    'branchId',
                    'itemId',
                    'itemPrice',
                    'itemStatus',
                    'itemDiscount'
                  ],
                  managerEmployees: managerEmployees,
                  branches: branches,
                  menuItems: menuItems, // Add this line
                  onSubmit: (values) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final addStorage_Model = await addItemBranchMenu(
                          branchId: values['branchId']!,
                          itemId: values['itemId']!,
                          itemPrice: values['itemPrice']!,
                          itemStatus: values['itemStatus']!,
                          itemDiscount: values['itemDiscount']!,
                        );
                        print('Adding Item to Branch Menu: $addStorage_Model');
                        CherryToast.success(
                          animationType: AnimationType.fromRight,
                          toastPosition: Position.bottom,
                          description: const Text(
                            "Add Item Branch Menu successfully",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                        clearFormFields();
                      } catch (e) {
                        print('Error adding storage: $e');
                        CherryToast.error(
                          toastPosition: Position.bottom,
                          animationType: AnimationType.fromRight,
                          description: const Text(
                            "Something went wrong!",
                            style: TextStyle(color: Colors.black),
                          ),
                        ).show(context);
                      }
                    } else {
                      print('Form is not valid');
                      CherryToast.warning(
                        toastPosition: Position.bottom,
                        animationType: AnimationType.fromLeft,
                        description: const Text(
                          "Data is not valid or not complete",
                          style: TextStyle(color: Colors.black),
                        ),
                      ).show(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FunctionInputTile extends StatefulWidget {
  final String functionName;
  final List<String> attributeNames;
  final List<Map<String, dynamic>> managerEmployees;
  final List<Map<String, dynamic>>? branches;
  final List<Map<String, dynamic>>? sections;
  final List<Map<String, dynamic>>? menuItems;
  final List<Map<String, dynamic>>? categories;
  final List<Map<String, dynamic>>? ingredients; // Add this line
  final void Function(Map<String, String> values) onSubmit;
  final Future<void> Function(TextEditingController controller)? selectMinutes;

  FunctionInputTile({
    required this.functionName,
    required this.attributeNames,
    required this.managerEmployees,
    required this.onSubmit,
    this.branches,
    this.categories,
    this.menuItems,
    this.sections,
    this.ingredients, // Add this line
    this.selectMinutes,
  });

  @override
  _FunctionInputTileState createState() => _FunctionInputTileState();
}

class _FunctionInputTileState extends State<FunctionInputTile> {
  late List<TextEditingController> _textControllers;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _textControllers =
        widget.attributeNames.map((_) => TextEditingController()).toList();
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void clearForm() {
    for (var controller in _textControllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ClipPath(
        clipper: MyCustomClipper(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            title: Text(widget.functionName,
                style: GoogleFonts.lato(fontSize: 18, color: Colors.teal)),
            onExpansionChanged: (expanded) {
              _toggleExpand();
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ..._textControllers.asMap().entries.map((entry) {
                      int idx = entry.key;
                      TextEditingController controller = entry.value;
                      String attributeName = widget.attributeNames[idx];
                      if (widget.functionName == 'add-storage' &&
                          attributeName == 'managerId') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.managerEmployees.map((employee) {
                              return DropdownMenuItem<int>(
                                value: employee['employee_id'],
                                child: Text(employee['employee_name']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: 'Employee Name',
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an Employee Name';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName ==
                              'addIngredientToStock' &&
                          attributeName == 'branchId') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.branches?.map((branch) {
                                  return DropdownMenuItem<int>(
                                    value: branch['branch_id'],
                                    child: Text(branch['branch_name']),
                                  );
                                }).toList() ??
                                [],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a branch';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName ==
                              'addIngredientToStock' &&
                          attributeName == 'ingredientId') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.ingredients?.map((ingredient) {
                                  return DropdownMenuItem<int>(
                                    value: ingredient['ingredient_id'],
                                    child: Text(ingredient['ingredients_name']),
                                  );
                                }).toList() ??
                                [],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an ingredient';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'addItemBranchMenu' &&
                          attributeName == 'itemId') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.menuItems?.map((item) {
                              return DropdownMenuItem<int>(
                                value: item['id'],
                                child: Text(item['name']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an item';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'addItemBranchMenu' &&
                          attributeName == 'itemDiscount') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (attributeName == 'vegetarian' ||
                          attributeName == 'healthy') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: controller.text.isEmpty
                                ? null
                                : controller.text,
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue ?? '';
                              });
                            },
                            items: ['True', 'False'].map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'add-menu-item' &&
                          attributeName == 'prepTime') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            readOnly: true,
                            onTap: () {
                              widget.selectMinutes!(controller);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select minutes';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'add-ingredient' &&
                          (attributeName == 'recipeUnit' ||
                              attributeName == 'shipmentUnit')) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: controller.text.isEmpty
                                ? null
                                : controller.text,
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toLowerCase() ?? '';
                              });
                            },
                            items: [
                              'Gram',
                              'Kilogram',
                              'Liter',
                              'Milliliter',
                              'Piece'
                            ].map((option) {
                              return DropdownMenuItem<String>(
                                value: option.toLowerCase(),
                                child: Text(option),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a unit';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'add_branch_section' &&
                          attributeName == 'Branch Name') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.branches!.map((branch) {
                              return DropdownMenuItem<int>(
                                value: branch['branch_id'],
                                child: Text(branch['branch_name']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a branch';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'add_branch_section' &&
                          attributeName == 'section_id') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.sections!.map((section) {
                              return DropdownMenuItem<int>(
                                value: section['id'],
                                child: Text(section['name']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a section';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'add-menu-item' &&
                          attributeName == 'Category') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.categories?.map((category) {
                              return DropdownMenuItem<int>(
                                value: category['category_id'],
                                child: Text(category['category_name']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'add_branch_section' &&
                          attributeName == 'manager_id') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.managerEmployees.map((employee) {
                              return DropdownMenuItem<int>(
                                value: employee['employee_id'],
                                child: Text(employee['employee_name']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a manager';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'addItemBranchMenu' &&
                          attributeName == 'branchId') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<int>(
                            value: controller.text.isEmpty
                                ? null
                                : int.tryParse(controller.text),
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toString() ?? '';
                              });
                            },
                            items: widget.branches!.map((branch) {
                              return DropdownMenuItem<int>(
                                value: branch['branch_id'],
                                child: Text(branch['branch_name']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a branch';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'addItemBranchMenu' &&
                          attributeName == 'itemStatus') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<String>(
                            value: controller.text.isEmpty
                                ? null
                                : controller.text,
                            onChanged: (newValue) {
                              setState(() {
                                controller.text = newValue?.toLowerCase() ?? '';
                              });
                            },
                            items: [
                              'Active',
                              'Inactive',
                              'Not enough ingredients'
                            ].map((option) {
                              return DropdownMenuItem<String>(
                                value: option.toLowerCase(),
                                child: Text(option),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an item status';
                              }
                              return null;
                            },
                          ),
                        );
                      } else if (widget.functionName == 'addItemBranchMenu' &&
                          attributeName == 'itemPrice') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                              ),
                              labelText: attributeName,
                              labelStyle: GoogleFonts.lato(color: Colors.teal),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                          ),
                        );
                      }
                    }).toList(),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        textStyle: MaterialStateProperty.all(
                          GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (Form.of(context)?.validate() ?? false) {
                          final values = {
                            for (int i = 0;
                                i < widget.attributeNames.length;
                                i++)
                              widget.attributeNames[i]: _textControllers[i].text
                          };
                          widget.onSubmit(values);
                          clearForm();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20); // Adjusted height of the clip path
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
