import 'package:flutter/material.dart';
import 'package:bloc_v2/Features/branch_features/Data/get_all_OM_function.dart';
import 'package:bloc_v2/Features/branch_features/models/OM_function_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http; // For making HTTP requests

class RecipesList extends StatefulWidget {
  final int branchID;

  RecipesList(this.branchID, {required int iD});

  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  Future<List<SectionModel>>? recipesFuture;
  List<dynamic> branches = [];
  dynamic selectedBranch;

  @override
  void initState() {
    super.initState();
    fetchBranches();
    // Initialize recipesFuture as null initially
    recipesFuture = null;
  }

  Future<void> fetchBranches() async {
    final response = await http
        .get(Uri.parse('https://54.235.40.102.nip.io/admin/branch/branches-list'));
    if (response.statusCode == 200) {
      setState(() {
        branches = jsonDecode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load branches');
    }
  }

  void onBranchSelected(dynamic branch) {
    setState(() {
      selectedBranch = branch;
      recipesFuture = GetSection().getSection(branchID: branch['branch_id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromRGBO(209, 239, 234, 1), Colors.grey],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      hint: Text(
                        'Select Branch',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Color.fromARGB(255, 45, 17, 95),
                        ),
                      ),
                      value: selectedBranch,
                      isExpanded: true,
                      items: branches.map<DropdownMenuItem<dynamic>>((branch) {
                        return DropdownMenuItem<dynamic>(
                          value: branch,
                          child: Text(
                            branch['branch_name'],
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (branch) {
                        onBranchSelected(branch);
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (recipesFuture != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Details',
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 45, 17, 95),
                  ),
                ),
              ),
              Container(
                height: 2,
                color: Colors.black87,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
              ),
              Container(
                color: Colors.teal[100],
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    Expanded(
                        child: Text('Manager',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                    Expanded(
                        child: Text('Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<SectionModel>>(
                  future: recipesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          SectionModel section = snapshot.data![index];
                          return Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(section.sectionName,
                                        textAlign: TextAlign.center),
                                  ),
                                  Expanded(
                                    child: Text(section.sectionManager ?? "",
                                        textAlign: TextAlign.center),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: const Icon(Icons.description),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Description"),
                                              content: Text(section
                                                      .sectionDecription ??
                                                  "No description available"),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No data found'));
                    }
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
