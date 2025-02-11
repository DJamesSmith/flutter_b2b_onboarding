class Business {
  final String businessName;
  final String businessType;
  final String industry;
  final String businessLogo;
  final String employeeCount;
  final String revenue;
  final String gstin;
  final String registrationNumber;

  Business({
    required this.businessName,
    required this.businessType,
    required this.industry,
    required this.businessLogo,
    required this.employeeCount,
    required this.revenue,
    required this.gstin,
    required this.registrationNumber,
  });

  Map<String, dynamic> toJson() => {
        'businessName': businessName,
        'businessType': businessType,
        'industry': industry,
        'businessLogo': businessLogo,
        'employeeCount': employeeCount,
        'revenue': revenue,
        'gstin': gstin,
        'registrationNumber': registrationNumber,
      };

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessName: json['businessName'],
      businessType: json['businessType'],
      industry: json['industry'],
      businessLogo: json['businessLogo'],
      employeeCount: json['employeeCount'],
      revenue: json['revenue'],
      gstin: json['gstin'],
      registrationNumber: json['registrationNumber'],
    );
  }
}
