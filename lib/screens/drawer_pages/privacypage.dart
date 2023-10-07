import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/theme/theme_manager.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeManager.primaryColorGradient,
          ),)),
      
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headings('Privacy Policy:'),
              spacing(5),
              content(
                  'Muhammed Ajmal built the ToDo app as a Free app. This SERVICE is provided by Muhammed Ajmal at no cost and is intended for use as is.'),
              spacing(5),
              content(
                  'This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.'),
              spacing(5),
              content(
                  'The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at ToDo unless otherwise defined in this Privacy Policy.'),
              spacing(10),
              headings('Information Collection and Use:'),
              spacing(5),
              content(
                  'Todo App does not collect any personal data or information from its users. We respect your privacy, and we are committed to maintaining the confidentiality of any information you provide within the app.Since we do not collect any data, you can be assured that your personal information remains private and secure when using Todo App. We do not share any information with third parties Please note that this privacy policy may be subject to change in the future, should we decide to collect data for any reason. However, any changes to our privacy policy will be prominently communicated to users within the app.'),
              spacing(10),
              headings('Cookies:'),
              spacing(5),
              content(
                  "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service."),
              spacing(10),
              headings('Service Providers:'),
              spacing(5),
              content(
                  'I may employ third-party companies and individuals due to the following reasons:'),
              spacing(20),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Column(
                  children: [
                    servicePoints('To facilitate our Service;'),
                    servicePoints('To provide the Service on our behalf;'),
                    servicePoints('To perform Service-related services; or'),
                    servicePoints(
                        'To assist us in analyzing how our Service is used.'),
                  ],
                ),
              ),
              spacing(10),
              content(
                  'I want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose'),
              spacing(10),
              headings('Security:'),
              spacing(5),
              content(
                  'I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.'),
              spacing(10),
              headings('Links to Other Sites:'),
              spacing(5),
              content(
                  'This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.'),
              spacing(10),
              headings("Changes to This Privacy Policy"),
              spacing(5),
              content(
                  'I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.This policy is effective as of 2023-09-08'),
              spacing(10),
              headings("Contact Us"),
              spacing(10),
              content(
                  'If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at stranger99980@gmail.com.')
            ],
          ),
        ),
      ),
    );
  }

  Row servicePoints(String text3) {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 8,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(text3),
      ],
    );
  }

  Text content(String text2) {
    return Text(text2);
  }

  SizedBox spacing(double height) {
    return SizedBox(
      height: height,
    );
  }

  Text headings(String text1) {
    return Text(
      text1,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
