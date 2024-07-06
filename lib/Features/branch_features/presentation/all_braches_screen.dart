import 'package:flutter/material.dart';
import 'package:bloc_v2/Features/branch_features/Data/get_all_branchs.dart';
import 'package:bloc_v2/Features/branch_features/models/branch_model.dart';
import 'package:bloc_v2/Features/branch_features/presentation/custom_branch_card.dart';

class AllBranchScreen extends StatefulWidget {
  const AllBranchScreen({Key? key}) : super(key: key);

  @override
  _AllBranchScreenState createState() => _AllBranchScreenState();
}

class _AllBranchScreenState extends State<AllBranchScreen> {
  List<BranchModel>? branches;
  BranchModel? selectedBranch;
  
  @override
  void initState() {
    super.initState();
    fetchBranches();
  }
  Future<void> fetchBranches() async {
    try {
      branches = await GetAllBranches().getAllBranches();
      setState(() {
        selectedBranch = branches?.first;
      });
    } catch (e) {
      print('Failed to fetch branches: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: branches == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: branches!.length,
                    itemBuilder: (context, index) {
                      return CustomCard(branch: branches![index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
