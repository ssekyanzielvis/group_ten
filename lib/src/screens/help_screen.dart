import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help & Support',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HelpSupportPage(),
      routes: {
        '/feedback': (context) => FeedbackPage(),
        '/contact/email': (context) => ContactEmailPage(),
        '/contact/phone': (context) => ContactPhonePage(),
      },
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  final List<FAQ> faqs = [
    FAQ(question: 'How do I create an account?', answer: 'You can create an account by following these steps...'),
    FAQ(question: 'How do I reset my password?', answer: 'To reset your password, go to the login page and click on "Forgot Password".'),
    // Add more FAQs here
  ];

  HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05,
            vertical: screenSize.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FAQs',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: screenSize.height * 0.02),
              ...faqs.map((faq) => FAQWidget(faq: faq)),
              SizedBox(height: screenSize.height * 0.04),
              Text(
                'Contact Us',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: screenSize.height * 0.02),
              ContactOption(
                icon: Icons.email,
                text: 'Email us',
                onTap: () => Navigator.of(context).pushNamed('/contact/email'),
              ),
              ContactOption(
                icon: Icons.phone,
                text: 'Call us',
                onTap: () => Navigator.of(context).pushNamed('/contact/phone'),
              ),
              SizedBox(height: screenSize.height * 0.04),
              Text(
                'Feedback',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: screenSize.height * 0.02),
              FeedbackOption(
                icon: Icons.feedback,
                text: 'Send Feedback',
                onTap: () => Navigator.of(context).pushNamed('/feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}

class FAQWidget extends StatelessWidget {
  final FAQ faq;

  const FAQWidget({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(faq.question),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(faq.answer),
        ),
      ],
    );
  }
}

class ContactOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ContactOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

class FeedbackOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const FeedbackOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: screenSize.height * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send us your feedback',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: screenSize.height * 0.02),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Your feedback',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: screenSize.height * 0.02),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Thank you!'),
                    content: const Text('Your feedback has been submitted.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact by Email'),
      ),
      body: Center(
        child: Text('Email functionality is not implemented yet.'),
      ),
    );
  }
}

class ContactPhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact by Phone'),
      ),
      body: Center(
        child: Text('Phone functionality is not implemented yet.'),
      ),
    );
  }
}
