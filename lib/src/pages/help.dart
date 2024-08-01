import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final Map<String, bool> _isExpanded = {
    'Introduction': false,
    'Getting Started': false,
    'Using the App': false,
    'Account Management': false,
    'Notifications': false,
    'Special Features': false,
    'Help & Support': false,
    'Legal and Policy Information': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: _isExpanded.keys.map((String key) {
          return ExpansionTile(
            title: Text(
              key,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _isExpanded[key] = expanded;
              });
            },
            initiallyExpanded: _isExpanded[key]!,
            children: <Widget>[
              if (key == 'Introduction') _buildIntroduction(),
              if (key == 'Getting Started') _buildGettingStarted(),
              if (key == 'Using the App') _buildUsingTheApp(),
              if (key == 'Account Management') _buildAccountManagement(),
              if (key == 'Notifications') _buildNotifications(),
              if (key == 'Special Features') _buildSpecialFeatures(),
              if (key == 'Help & Support') _buildHelpSupport(),
              if (key == 'Legal and Policy Information')
                _buildLegalPolicyInformation(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIntroduction() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' The FOODDASH app streamlines the food delivery process for users and restaurant owners, enhancing user experience and efficiency in food ordering and restaurant management. Users can register and authenticate via credentials or social media, view meal options, set budgets, and receive meal suggestions based on dietary preferences. Restaurant owners can manage their offerings, add new food items, and upload images. The app offers a detailed grid view of food items, order notifications, and a responsive design across devices. The technology stack includes Flutter for the frontend and Firebase for backend services. To make food ordering more convenient for users and provide restaurant owners with a robust tool for menu management and customer interaction.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Easy Ordering: Users can browse through a variety of meal options from different restaurants, all in one place. They can place orders directly through the app without needing to call or visit the restaurant. The app provides a streamlined checkout process, allowing users to pay for their orders seamlessly',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGettingStarted() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Creation & Login:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To create a new account on the FOODDASH app, users need to open the app and navigate to the registration page, where they will be prompted to enter their personal details such as name, email, and password, or choose to sign up using their social media accounts. Once the required information is entered and submitted, the account is created, and the user can log in to start using the apps features.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'To log in to the FOODDASH app, users can enter their registered email and password on the login page or choose a social sign-in option, such as Google or Facebook, to authenticate quickly and securely. Once authenticated, users can access all the apps features.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Navigating the Home Screen:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The FOODDASH home screen features options for breakfast, lunch, and dinner, allowing users to set a budget and receive meal suggestions based on dietary preferences and past orders. It provides a grid view of food items from nearby restaurants, detailed food pages, and an order placement button for a seamless food ordering experience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'The FOODDASH app uses intuitive icons and buttons to enhance user experience. The breakfast, lunch, and dinner icons help users navigate meal options. The budget and dietary preference buttons allow users to personalize meal suggestions. The grid view displays food items, each with an image, name, and price, leading to detailed food pages. The order button facilitates quick meal ordering. A notification icon, often with a badge indicating new updates, keeps users informed of order status and other alerts.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsingTheApp() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browsing Restaurants:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To search for foods in the FOODDASH app, use the search bar on the home screen. Enter the food name or type, and the app will show a list of matching food items from various restaurants. Browse through the results and select a food item to view more details and place an order.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "FOODDASH app offers filters and sorting options to enhance your search experience. Use filters to narrow down results based on criteria like cuisine type, price range, dietary preferences, or restaurant ratings. Sorting options allow you to arrange food items by popularity, price, or customer ratings, making it easier to find exactly what you're looking for.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Viewing Menu:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "To view a restaurant's menu in the FOODDASH app, select the desired restaurant from the search results or home screen. This will navigate you to the restaurant's page, where you can browse through their available food items and detailed menu offerings.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Menu items in the FOODDASH app include detailed descriptions, prices, and images. Each item provides a comprehensive overview to help users make informed decisions, showcasing the dish, its cost, and any relevant details or ingredients.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Placing an Order:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "To add items to the blog in the FOODDASH app: Navigate to Blog Section: Access the blog section from the main menu.Select 'Add Item': Click the 'Add Item' button or similar option.Fill in Details: Enter the title, content, and any relevant images or media.Publish: Review the content and publish the blog post.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'To review and edit the blog:Access Blog Management: Go to the blog management section Select the Blog Post: Find the post you want to review or edit.Review or Edit: View the post details and make necessary changes.Save Changes: Save or update the blog post after editing.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'To place an order and select delivery/pickup options:Select Food Items: Choose the desired food items from the menu.Add to Cart: Add selected items to your cart.Proceed to Checkout: Go to the checkout page.Choose Delivery/Pickup: Select either delivery or pickup option.Enter Details: Provide necessary delivery address or pickup time.Confirm Order: Review and confirm your order, then make the payment.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Payment Methods:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The app supports payments via cash on delivery or mobile money. Users can choose their preferred method at checkout.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'To add or manage payment methods, go to the payment settings in your profile. Add new methods by following the prompts, or update existing ones as needed.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Tracking Orders:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To track the status of an order in real-time, navigate to the "Orders" section in the app. Select the order you want to track, and view its current status and location updates as they happen.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountManagement() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Settings:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To view and edit profile information, go to the "Profile" section in the app. Tap the "Edit Profile" button to update details like your name, email, phone number, and profile picture. Save changes to update your profile.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'To update contact details and preferences, go to the "Profile" section, tap on "Edit Profile," modify your contact information and preferences as needed, and then save the changes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Address Book:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To manage delivery addresses, go to the "Profile" section, select "Addresses," and use the options to add, edit, or delete addresses as needed.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Order History:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To view past orders, navigate to the "Order History" section in the app. Here, you can see a list of previous orders along with their details.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'To reorder a previous order, go to the "Order History" section, select the order you want to reorder, and choose the "Reorder" option. This will add the same items to your cart for checkout.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifications() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "To manage push notifications, go to the app's settings, find the 'Notifications' section, and customize your preferences. You can enable or disable notifications, choose the types of alerts you want to receive, and adjust notification sounds and preferences.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "To enable or disable notifications for specific types like order updates or promotions, go to the app's settings, navigate to the 'Notifications' section, and toggle the switches for the desired notification types. This allows you to control which notifications you receive and tailor your preferences accordingly.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialFeatures() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dietary Preferences:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "To set and manage dietary preferences, go to the app's settings or profile section and find the 'Dietary Preferences' option. Here, you can select your dietary restrictions, preferences, or goals (e.g., vegetarian, gluten-free). You can update these preferences at any time to receive meal suggestions that align with your dietary needs.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'When browsing restaurants and menus, you can apply dietary filters by selecting your dietary preferences from a filter or search option. This will refine the list of available restaurants and menu items to match your selected dietary needs, ensuring that the options presented are suitable for your diet.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Favorites:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "To add restaurants and menu items to your favorites, simply navigate to the restaurant or menu item you're interested in and tap the heart or star icon typically located near the name or image. This will save the restaurant or item to your favorites list for easy access later.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "To view and manage menu items:Access Menu: Navigate to the restaurant's menu page either through the restaurant list or your favorites.View Items: Browse through the available menu items, where you can see details such as descriptions, prices, and images.Manage Items: If you’re a restaurant owner, you can manage menu items through the restaurant management section. This typically includes options to add, edit, or delete items.For regular users, menu items are usually view-only with options to add them to your cart or favorites.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSupport() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions (FAQs):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "1. How do I create a new account?\n"
              "Answer: To create a new account, tap on the 'Sign Up' button on the login page. Enter your email and password or use a social media account to register. Follow the prompts to complete the setup and verify your email if required.\n"
              "2. How do I log in to my account?\n"
              "Answer: Tap on the 'Log In' button on the home screen. Enter your email and password or use a social media account to log in. If you've forgotten your password, use the 'Forgot Password' link to reset it.\n"
              "3. How do I search for restaurants?\n"
              "Answer: Use the search bar on the home screen to enter the restaurant's name or type of cuisine. You can also filter results based on location and ratings.\n"
              "4. How do I search for foods?\n"
              "Answer: On the restaurants menu page, use the search bar to type in the name of the food item you're looking for. You can also browse categories or use filters to narrow down your search.\n"
              "5. What filters and sorting options are available?\n"
              "Answer: You can filter restaurants and foods by cuisine type, price range, rating, and delivery options. Sorting options typically include sorting by popularity, price, or latest additions.\n"
              "6. How do I view a restaurants menu?\n"
              "Answer: Tap on a restaurant from the search results or home screen. Navigate to the restaurant's menu to view its offerings, which include food items, descriptions, and prices.\n"
              "7. What details are available for menu items?\n"
              "Answer: Each menu item includes a description, price, and image. Some items may also include ingredients, preparation time, and dietary information.\n"
              "8. How do I add items to the blog?\n"
              "Answer: Access the blog section from the menu or dashboard. Use the 'Add Item' button to create a new blog post, enter details, and upload any relevant images.\n"
              "9. How do I review and edit the blog?\n"
              "Answer: Go to the blog section and select the post you want to review or edit. Use the 'Edit' option to make changes or update content.\n"
              "10. How do I place an order?\n"
              "Answer: Select a restaurant and browse its menu. Choose your items, specify delivery or pickup options, and proceed to checkout. Confirm your order and payment details to complete the purchase.\n"
              "11. What payment methods are supported?\n"
              "Answer: Our app supports payments via cash on delivery or mobile money. Check the payment options available at checkout.\n"
              "12. How do I add or manage payment methods?\n"
              "Answer: Go to the payment settings in your profile. Add new payment methods or edit existing ones by following the on-screen instructions.\n"
              "13. How can I track my order status?\n"
              "Answer: Navigate to the 'Order History' section to view real-time updates on your order status. You'll see notifications about any changes or updates.\n"
              "14. How do I view and edit my profile information?\n"
              "Answer: Go to the profile section in your account settings. Here, you can update personal details, contact information, and preferences.\n"
              "15. How do I update my contact details and preferences?\n"
              "Answer: In the profile settings, access the contact details and preferences section. Edit your information and set your preferences for communication and notifications.\n"
              "16. How do I add, edit, or delete delivery addresses?\n"
              "Answer: Access the 'Addresses' section in your account settings. You can add new addresses, edit existing ones, or delete addresses as needed.\n"
              "17. How do I view my past orders?\n"
              "Answer: Go to the 'Order History' section to view a list of your past orders, including details such as order items, dates, and statuses.\n"
              "18. How do I reorder previous orders?\n"
              "Answer: In the 'Order History' section, find the order you want to reorder and select the 'Reorder' button. Review and confirm the details to place the order again.\n"
              "19. How do I manage push notifications?\n"
              "Answer: Go to the notification settings in your profile. Here, you can enable or disable notifications for various updates such as order status and promotions.\n"
              "20. How do I set and manage dietary preferences?\n"
              "Answer: In your profile settings, access the dietary preferences section. Set your preferences, such as vegetarian or gluten-free, to filter suitable meal options.\n"
              "21. How do I use dietary filters when browsing?\n"
              "Answer: Use the dietary filters available on the restaurant and menu browsing pages to see food items that match your dietary preferences.\n"
              "22. How do I add restaurants and menu items to favorites?\n"
              "Answer: On the restaurant or menu item page, tap the 'Add to Favorites' icon to save them to your favorites list for quick access later.\n"
              "23. How do I view and manage my favorite items?\n"
              "Answer: Go to the 'Favorites' section in your profile to view your saved restaurants and menu items. You can also remove items from your favorites list here.\n"
              "24. How do I view and manage menu items?\n"
              "Answer: For restaurant owners, access the restaurant management section to view, add, edit, or delete menu items. Users can view menu items but cannot manage them.\n",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Support:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "To contact customer support, you can:Email: Send an email to the support address provided in the app’s contact section or on the website.Phone: Call the customer support number listed in the app or on the website.In-App Chat: Use the in-app chat feature available in the app’s help or support section for real-time assistance.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Feedback:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'How to Provide Feedback:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '1. **In-App Feedback Form:** Navigate to the feedback section in the app menu and fill out the feedback form provided.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '2. **Email:** Send your feedback to the designated email address provided in the app’s contact section or on the website.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '3. **Support Chat:** Use the in-app chat feature to send your feedback directly to the support team.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalPolicyInformation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Link to the app\'s terms of service.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Privacy Policy:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "FOODDASH TERMS OF SERVICE\n"
              "Effective Date: [Insert Date]\n"
              "\n"
              "1. Acceptance of Terms\n"
              "By accessing and using the FOODDASH application\n ('App'), you accept and agree to be bound by the terms and provision of this agreement. Additionally, when using the App’s particular services, you shall be subject to any posted guidelines or rules applicable to such services. Any participation in this service will constitute acceptance of this agreement. If you do not agree to abide by the above, please do not use this service.\n"
              "\n"
              "2. Description of Service\n"
              "FOODDASH provides users with a platform for ordering food from various restaurants. This includes browsing menus, placing orders, selecting delivery or pickup options, and making payments. Restaurant owners can manage their food offerings, including adding and updating menu items.\n"
              "\n"
              "3. Registration and Account\n"
              "You may need to create an account to use some of our services. You are responsible for maintaining the confidentiality of your account and password and for restricting access to your device. You agree to accept responsibility for all activities that occur under your account.\n"
              "\n"
              "4. User Conduct\n"
              "You agree not to use the App for any unlawful purpose or any purpose prohibited under this clause. You agree not to use the App in any way that could damage the App, its services, or the general business of FOODDASH.\n"
              "\n"
              "5. Privacy\n"
              "Your use of the App is also governed by our Privacy Policy, which can be viewed at [Insert Link to Privacy Policy].\n"
              "\n"
              "6. Payment\n"
              "By making a payment through the App, you agree to pay all applicable fees and taxes. Payments can be made via cash, mobile money, or other methods we may offer.\n"
              "\n"
              "7. Content\n"
              "You are responsible for any content you upload or post on the App. You grant FOODDASH a non-exclusive, royalty-free, worldwide, perpetual license to use, display, distribute, and create derivative works of such content.\n"
              "\n"
              "8. Intellectual Property\n"
              "All content included on the App, such as text, graphics, logos, images, and software, is the property of FOODDASH or its content suppliers and protected by intellectual property laws.\n"
              "\n"
              "9. Limitation of Liability\n"
              "FOODDASH will not be liable for any damages of any kind arising from the use of this App, including but not limited to direct, indirect, incidental, punitive, and consequential damages.\n"
              "\n"
              "10. Termination\n"
              "We may terminate or suspend access to our App immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.\n"
              "\n"
              "11. Changes to Terms\n"
              "FOODDASH reserves the right to modify these Terms at any time. We will notify you of any changes by posting the new Terms on the App. You are advised to review these Terms periodically for any changes.\n"
              "\n"
              "12. Contact Information\n"
              "For any questions about these Terms, please contact us at:\n"
              "Email: support@fooddash.com\n"
              "Phone: [Insert Phone Number]\n"
              "\n"
              "13. Governing Law\n"
              "These Terms shall be governed and construed in accordance with the laws of [Insert Jurisdiction], without regard to its conflict of law provisions.\n"
              "\n"
              "By using the FOODDASH App, you agree to these Terms of Service.\n",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Refund and Cancellation Policy:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '''
  FOODDASH Refund and Cancellation Policy
  Effective Date: [2022-01-01]

  1. Introduction
  At FOODDASH, we strive to provide the best possible experience for our users. We understand that there may be situations where you need to request a refund or cancel an order. This policy outlines the circumstances under which refunds and cancellations are processed.

  2. Order Cancellations
  2.1 User-Initiated Cancellations
  - Users can cancel their order within a specific timeframe after placing it. The cancellation window is typically [insert timeframe, e.g., 5-10 minutes].
  - If the cancellation is made within this timeframe, the user will receive a full refund.

  2.2 Restaurant-Initiated Cancellations
  - In rare cases, a restaurant may need to cancel an order due to unforeseen circumstances (e.g., out of stock, unable to fulfill the order).
  - In such cases, users will be notified promptly, and a full refund will be issued.

  3. Refund Policy
  3.1 Eligibility for Refunds
  - Refunds are applicable in cases where:
    - The order was cancelled by the user or the restaurant as per the cancellation policies.
    - The delivered food items were incorrect, missing, or did not match the order specifications.
    - The quality of the food was unsatisfactory or compromised.

  3.2 Refund Process
  - Users must request a refund within [insert timeframe, e.g., 24 hours] of receiving their order.
  - To request a refund, users should contact FOODDASH customer support through the app, email, or phone, providing their order details and the reason for the refund request.
  - Upon receiving the refund request, our team will review the case and, if approved, process the refund within [insert timeframe, e.g., 5-7 business days].

  3.3 Refund Method
  - Refunds will be issued using the original payment method (e.g., mobile money, credit card).
  - If the original payment method is unavailable, users will be contacted to arrange an alternative refund method.

  4. Non-Refundable Situations
  - Refunds will not be provided in the following situations:
    - Change of mind after the order has been prepared or dispatched.
    - Delays caused by the user’s unavailability to receive the order.
    - Orders placed incorrectly by the user.

  5. Contact Information
  For any questions or concerns regarding cancellations and refunds, please contact us at:
  Email: support@fooddash.com
  Phone: [Insert Phone Number]

  6. Changes to This Policy
  FOODDASH reserves the right to modify this Refund and Cancellation Policy at any time. Users will be notified of any changes through the app or email. It is recommended to review this policy periodically for any updates.

  By using the FOODDASH app, you agree to the terms outlined in this Refund and Cancellation Policy.

  Thank you for choosing FOODDASH. We appreciate your understanding and cooperation.
  ''',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
