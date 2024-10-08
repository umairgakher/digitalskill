import 'language_skill.dart';
import 'work_experience.dart';
import 'education.dart';
import 'skill.dart';
import 'certification.dart';

class CVData {
  String firstName;
  String lastName;
  String profileImageUrl;
  String aboutMe;
  String dob;
  String gender;
  String nationality;
  String email;
  String phone;
  String linkedin;
  String portfolio;
  String instantMessaging;
  String website;
  String address;
  String postalCode;
  String country;
  List<WorkExperience> workExperiences;
  List<Education> educations;
  List<LanguageSkill> languages;
  List<Skill> skills;
  List<Certification> certifications;
  // List<Project> projects;

  CVData({
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
    required this.aboutMe,
    required this.dob,
    required this.gender,
    required this.nationality,
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.portfolio,
    required this.instantMessaging,
    required this.website,
    required this.address,
    required this.postalCode,
    required this.country,
    required this.workExperiences,
    required this.educations,
    required this.skills,
    required this.certifications,
    required this.languages,
  });
}
