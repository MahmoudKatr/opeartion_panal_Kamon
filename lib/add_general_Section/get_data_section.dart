import 'dart:convert';
import 'package:http/http.dart' as http;

class SectionPerformance {
  final int sectionId;
  final String sectionName;
  final int totalOrders;

  SectionPerformance({
    required this.sectionId,
    required this.sectionName,
    required this.totalOrders,
  });

  factory SectionPerformance.fromJson(Map<String, dynamic> json) {
    return SectionPerformance(
      sectionId: json['section_id'],
      sectionName: json['section_name'],
      totalOrders: int.parse(json['total_orders']),
    );
  }
}

Future<List<SectionPerformance>> fetchSectionPerformance() async {
  final response = await http.get(
      Uri.parse('https://54.235.40.102.nip.io/admin/branch/branchPerformance/1'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body)['data'];
    return data.map((json) => SectionPerformance.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
