import 'package:bloc_v2/Features/branch_features/models/OM_function_model.dart';
import 'package:flutter/material.dart';

class CustomCategoryCard extends StatefulWidget {
  final CategoryModel CategoryItem;

  const CustomCategoryCard({
    required this.CategoryItem,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCategoryCardState createState() => _CustomCategoryCardState();
}

class _CustomCategoryCardState extends State<CustomCategoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _isExpanded ? Colors.indigo : Colors.blue,
                Colors.deepPurpleAccent
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      widget.CategoryItem.categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.2,
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        widget.CategoryItem.sectionName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (_isExpanded)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.CategoryItem.categoryDescription,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
