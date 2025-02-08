// class Business {
//   final String name;
//   final String industry;
//   final int size;
//   final String location;
//
//   Business({
//     required this.name,
//     required this.industry,
//     required this.size,
//     required this.location,
//   });
//
//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "industry": industry,
//         "size": size,
//         "location": location,
//       };
//
//   factory Business.fromJson(Map<String, dynamic> json) {
//     return Business(
//       name: json["name"],
//       industry: json["industry"],
//       size: json["size"],
//       location: json["location"],
//     );
//   }
// }

class Business {
  final String name;
  final String type;
  final String industry;
  final String description;
  final String email;
  final String phone;
  final String website;
  final String address;
  final String registrationNumber;
  final String gstin;
  final String licenseDocuments;
  final int employeeCount;
  final double revenue;
  final String logo;
  final String linkedIn;
  final String socialMedia;
  final String communicationPreference;

  Business({
    required this.name,
    required this.type,
    required this.industry,
    required this.description,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.registrationNumber,
    required this.gstin,
    required this.licenseDocuments,
    required this.employeeCount,
    required this.revenue,
    required this.logo,
    required this.linkedIn,
    required this.socialMedia,
    required this.communicationPreference,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "industry": industry,
        "description": description,
        "email": email,
        "phone": phone,
        "website": website,
        "address": address,
        "registrationNumber": registrationNumber,
        "gstin": gstin,
        "licenseDocuments": licenseDocuments,
        "employeeCount": employeeCount,
        "revenue": revenue,
        "logo": logo,
        "linkedIn": linkedIn,
        "socialMedia": socialMedia,
        "communicationPreference": communicationPreference,
      };

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      name: json["name"],
      type: json["type"],
      industry: json["industry"],
      description: json["description"],
      email: json["email"],
      phone: json["phone"],
      website: json["website"],
      address: json["address"],
      registrationNumber: json["registrationNumber"],
      gstin: json["gstin"],
      licenseDocuments: json["licenseDocuments"],
      employeeCount: json["employeeCount"],
      revenue: json["revenue"],
      logo: json["logo"],
      linkedIn: json["linkedIn"],
      socialMedia: json["socialMedia"],
      communicationPreference: json["communicationPreference"],
    );
  }
}
