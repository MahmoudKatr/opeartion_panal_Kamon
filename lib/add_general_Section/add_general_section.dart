import 'package:bloc_v2/add_general_Section/get_data_section.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample extends StatefulWidget {
  @override
  _PieChartSampleState createState() => _PieChartSampleState();
}

class _PieChartSampleState extends State<PieChartSample> {
  late Future<List<SectionPerformance>> futureSectionPerformance;

  @override
  void initState() {
    super.initState();
    futureSectionPerformance = fetchSectionPerformance();
  }

  List<Color> colorPalette = [
    Color(0xFF90CAF9), // Light Blue
    Color(0xFFEF9A9A), // Light Red
    Color(0xFFA5D6A7), // Light Green
    Color(0xFFFFCC80), // Light Orange
    Color(0xFFCE93D8), // Light Purple
    Color(0xFF80DEEA), // Light Cyan
    Color(0xFFFFE082), // Light Amber
    Color(0xFF9FA8DA), // Light Indigo
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('PieChart Example'),
      ),
      backgroundColor: Color(0xFFF5F5F5), // Light grey background color
      body: FutureBuilder<List<SectionPerformance>>(
        future: futureSectionPerformance,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            final totalOrders = data.fold(0, (sum, item) => sum + item.totalOrders);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenSize.height * 0.7, // Increased the height
                      child: PieChart(
                        PieChartData(
                          sections: data.asMap().entries.map((entry) {
                            int index = entry.key;
                            SectionPerformance section = entry.value;
                            double percentage = (section.totalOrders / totalOrders) * 100;
                            return PieChartSectionData(
                              color: colorPalette[index % colorPalette.length].withOpacity(0.8),
                              title: '', // Removed title from the chart
                              value: section.totalOrders.toDouble(),
                              showTitle: false, // Do not show title
                              badgeWidget: _Badge(
                                color: colorPalette[index % colorPalette.length],
                                sectionName: section.sectionName,
                                percentage: percentage.toStringAsFixed(1),
                              ),
                              badgePositionPercentageOffset: 1.3, // Adjusted position
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: 100, // Increased center space radius
                          borderData: FlBorderData(
                            show: false,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: data.asMap().entries.map((entry) {
                        int index = entry.key;
                        SectionPerformance section = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20, // Increased color box size
                                height: 20, // Increased color box size
                                color: colorPalette[index % colorPalette.length],
                              ),
                              SizedBox(width: 8),
                              Text(
                                section.sectionName,
                                style: TextStyle(
                                  fontSize: 18, // Increased font size
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final Color color;
  final String sectionName;
  final String percentage;

  const _Badge({
    Key? key,
    required this.color,
    required this.sectionName,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20), // Increased padding
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 15, // Adjust font size
              fontWeight: FontWeight.bold,
              color: Colors.black, // Change text color to black
            ),
          ),
        ],
      ),
    );
  }
}
