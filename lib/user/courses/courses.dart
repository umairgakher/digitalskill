// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../loginsignup/login_controller.dart';
import '../../widget/appbar.dart';
import 'update_course.dart';

class CourseGuideScreen extends StatefulWidget {
  final Map<String, dynamic> courseDetails;

  // ignore: use_key_in_widget_constructors
  CourseGuideScreen({required this.courseDetails});

  @override
  State<CourseGuideScreen> createState() => _CourseGuideScreenState();
}

class _CourseGuideScreenState extends State<CourseGuideScreen> {
  bool _isImageFullScreen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFullScreenImage(
        context,
        widget.courseDetails['roadmap_image'],
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      );
    });
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final fontSizeTitle = width * 0.06;
    final fontSizeSubtitle = height * 0.024;
    final padding = width * 0.04;

    final courseDetails = widget.courseDetails;
    final courseName = capitalize(courseDetails['name'] ?? 'Course');
    final courseUrl = courseDetails['url'] ?? '';
    final roadmapImage = courseDetails['roadmap_image'] ?? '';
    final courseDescription = courseDetails['description'] ?? '';

    final videoId = Uri.parse(courseUrl).queryParameters['v'] ??
        Uri.parse(courseUrl).pathSegments.last;
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

    return Scaffold(
      appBar: CustomAppBar(title: '$courseName Guide'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isImageFullScreen) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      courseName,
                      style: TextStyle(
                          fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
                    ),
                    loginController().checkuser == "admin"
                        ? PopupMenuButton<String>(
                            icon: Icon(Icons.menu_sharp, size: width * 0.08),
                            onSelected: (value) {
                              if (value == 'delete') {
                                _deleteCourse();
                              } else if (value == 'update') {
                                _updateCourse();
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                              PopupMenuItem<String>(
                                value: 'update',
                                child: Text('Update'),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Stack(
                  children: [
                    Container(
                      height: height * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(width * 0.07),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.07),
                        child: Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: height * 0.25,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child:
                                  Icon(Icons.broken_image, size: width * 0.15),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: width * 0.4,
                      top: height * 0.1,
                      child: IconButton(
                        icon: Icon(Icons.play_circle_fill,
                            size: width * 0.15, color: Colors.white),
                        onPressed: () {
                          _launchURL(courseUrl);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Text('Road Map', style: TextStyle(fontSize: fontSizeSubtitle)),
                GestureDetector(
                  onTap: () {
                    _showFullScreenImage(context, roadmapImage, width, height);
                  },
                  child: Container(
                    width: width,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.07),
                      image: DecorationImage(
                        image: NetworkImage(roadmapImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text('Content', style: TextStyle(fontSize: fontSizeSubtitle)),
                Text(
                  courseDescription,
                  style: TextStyle(fontSize: height * 0.022),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, String imageUrl, double width, double height) {
    setState(() {
      _isImageFullScreen = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            setState(() {
              _isImageFullScreen = false;
            });
          },
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.broken_image, size: width * 0.15),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  void _deleteCourse() async {
    final courseId = widget.courseDetails['id'];

    if (courseId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .delete();
        Navigator.of(context).pop(); // Close the screen after deletion
      } catch (e) {
        print('Error deleting course: $e');
      }
    } else {
      print('Course ID not found');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course ID not found!')),
      );
    }
  }

  void _updateCourse() {
    final courseId = widget.courseDetails['id'];

    if (courseId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateCourseScreen(
            course: widget.courseDetails,
            courseId: courseId,
          ),
        ),
      );
    } else {
      print('Course ID not found');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course ID not found!')),
      );
    }
  }
}
