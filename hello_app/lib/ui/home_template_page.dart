import 'package:flutter/material.dart';
import '../ch6/ExampleuiSTD.dart';
import '../ch6/ExampleuiResultListview.dart';
import '../ch5/ListView/ProductListScreen.dart';
import '../ch5/ListView/SimpleProductListScreen.dart';
import '../models/register_data.dart';
import '../ch2/MultiChildren.dart';
import '../ch2/RowPageOverflow.dart';
import '../ch2/WalletScreen.dart';
import '../ch3/Tab/MyTabBar.dart';
import '../ch3/Popup/PopupMenuApp.dart';
import '../ch3/Popup/ScreenA.dart';
import '../ch3/Popup/ScreenB.dart';
import '../ch3/Popup/ScreenC.dart';
import '../ch4/Navigation/HomeScreen.dart';
import '../ch4/Navigation/HomeScreenInput.dart';
import 'register_page.dart';
import 'result_page.dart';
import 'detail_page.dart';
import 'ActivityListScreen.dart';
import 'SimplePieChartDemoSol.dart';
import 'LogDashboardPage.dart';

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget Function(BuildContext) builder;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.builder,
  });
}

class HomeTemplatePage extends StatefulWidget {
  const HomeTemplatePage({super.key});

  @override
  State<HomeTemplatePage> createState() => _HomeTemplatePageState();
}

class _HomeTemplatePageState extends State<HomeTemplatePage> {
  bool _isDark = false;

  final List<_MenuItem> _menuItems = [

    _MenuItem(
      icon: Icons.app_registration,
      title: 'Register Page',
      subtitle: 'Student registration form',
      color: Colors.indigo,
      builder: (ctx) => const RegisterPage(),
    ),

    _MenuItem(
      icon: Icons.list_alt,
      title: 'Result Page',
      subtitle: 'View saved registrations',
      color: Colors.blue,
      builder: (ctx) => ResultPage(registrations: []),
    ),

    _MenuItem(
      icon: Icons.contact_page,
      title: 'Detail Page (example)',
      subtitle: 'View a sample registration detail',
      color: Colors.teal,
      builder: (ctx) => const DetailPage(
        registration: RegisterData(
          studentId: '000',
          name: 'John',
          surname: 'Doe',
          major: 'IT',
          phone: '0123456789',
        ),
      ),
    ),

    _MenuItem(
      icon: Icons.dashboard_customize,
      title: 'Example UI (STD)',
      subtitle: 'Standard registration UI example',
      color: Colors.cyan,
      builder: (ctx) => const ExampleuiSTD(),
    ),

    _MenuItem(
      icon: Icons.view_list,
      title: 'Example Result List',
      subtitle: 'Result list for Example UI',
      color: Colors.indigoAccent,
      builder: (ctx) =>
          const ExampleuiResultListview(registerList: []),
    ),

    _MenuItem(
      icon: Icons.storefront,
      title: 'Product List',
      subtitle: 'Fetch products from fake API',
      color: Colors.blueAccent,
      builder: (ctx) => const ProductListScreen(),
    ),

    _MenuItem(
      icon: Icons.list,
      title: 'Simple Product List',
      subtitle: 'Static simple product list',
      color: Colors.green,
      builder: (ctx) => const SimpleProductListScreen(),
    ),

    _MenuItem(
      icon: Icons.widgets,
      title: 'Multi Children Example',
      subtitle: 'Demo of multiple children widgets',
      color: Colors.purple,
      builder: (ctx) => const MultiChildrenExample(),
    ),

    _MenuItem(
      icon: Icons.view_stream,
      title: 'Row Overflow Demo',
      subtitle: 'Row overflow example',
      color: Colors.orange,
      builder: (ctx) => const RowPageOverflow(),
    ),

    _MenuItem(
      icon: Icons.account_balance_wallet,
      title: 'Wallet Screen',
      subtitle: 'Simple wallet demo',
      color: Colors.deepPurple,
      builder: (ctx) => const WalletScreen(),
    ),

    _MenuItem(
      icon: Icons.tab,
      title: 'Tab Bar Example',
      subtitle: 'TabBar with three tabs',
      color: Colors.indigo,
      builder: (ctx) => const MyTabBar(),
    ),

    _MenuItem(
      icon: Icons.more_horiz,
      title: 'Popup Menu Example',
      subtitle: 'Popup menu sample',
      color: Colors.tealAccent,
      builder: (ctx) => const PopupMenuExample(),
    ),

    _MenuItem(
      icon: Icons.filter_1,
      title: 'Screen A',
      subtitle: 'Popup sample A',
      color: Colors.grey,
      builder: (ctx) => const ScreenA(),
    ),

    _MenuItem(
      icon: Icons.filter_2,
      title: 'Screen B',
      subtitle: 'Popup sample B',
      color: Colors.grey,
      builder: (ctx) => const ScreenB(),
    ),

    _MenuItem(
      icon: Icons.filter_3,
      title: 'Screen C',
      subtitle: 'Popup sample C',
      color: Colors.grey,
      builder: (ctx) => const ScreenC(),
    ),

    _MenuItem(
      icon: Icons.home,
      title: 'Navigation Home',
      subtitle: 'ch4 HomeScreen demo',
      color: Colors.brown,
      builder: (ctx) => const HomeScreen(),
    ),

    _MenuItem(
      icon: Icons.input,
      title: 'Home Input Demo',
      subtitle: 'ch4 HomeScreenInput demo',
      color: Colors.brown,
      builder: (ctx) => const HomeScreenInput(),
    ),

    _MenuItem(
      icon: Icons.list_alt_outlined,
      title: 'Activity List',
      subtitle: 'Firestore activity list (if configured)',
      color: Colors.blueGrey,
      builder: (ctx) => const ActivityListScreen(),
    ),

    // ==============================
    // เพิ่มใหม่ : Firebase Pie Chart
    // ==============================
    _MenuItem(
      icon: Icons.dashboard_customize,
      title: 'Log Dashboard',
      subtitle: 'Pie + Bar + Line Chart',
      color: Colors.redAccent,
      builder: (ctx) => const LogDashboardPage(),
    ),

    _MenuItem(
      icon: Icons.pie_chart,
      title: 'Log Status Pie Chart',
      subtitle: 'Firebase server logs distribution',
      color: Colors.redAccent,
      builder: (ctx) => const SimplePieChartDemoSol(),
    ),

  ];


  @override
  Widget build(BuildContext context) {
    final theme = _isDark
        ? ThemeData.dark()
        : ThemeData.light();

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.indigo,
          secondary: Colors.cyan,
        ),
      ),

      child: Scaffold(
        extendBodyBehindAppBar: true,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Template Navigation'),
          centerTitle: true,

          actions: [
            IconButton(
              icon: Icon(
                _isDark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),

              onPressed: () =>
                  setState(() => _isDark = !_isDark),
            ),
          ],
        ),

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isDark
                  ? [
                      Colors.indigo.shade900,
                      Colors.black,
                    ]
                  : [
                      Colors.indigo.shade100,
                      Colors.white,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(24, 100, 24, 24),

            child: Center(
              child: Card(
                elevation: 8,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(24),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(24),

                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [

                      Container(
                        padding:
                            const EdgeInsets.all(16),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.indigo.shade50,
                          shape:
                              BoxShape.circle,
                        ),

                        child:
                            const Icon(
                          Icons.apps_outage_rounded,
                          size: 64,
                          color:
                              Colors.indigo,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Choose a template screen',
                        style:
                            TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'A polished navigation template for your registration app.',
                        textAlign:
                            TextAlign.center,

                        style:
                            TextStyle(
                          color:
                              Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 24),


                      SizedBox(
                        height: 420,

                        child:
                            ListView.separated(

                          itemCount:
                              _menuItems.length,

                          separatorBuilder:
                              (context, index) =>
                                  const Divider(
                                    height: 1,
                                  ),

                          itemBuilder:
                              (context, index) {

                            final item =
                                _menuItems[index];

                            return ListTile(

                              leading:
                                  Icon(
                                item.icon,
                                color:
                                    item.color,
                              ),

                              title:
                                  Text(
                                item.title,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              subtitle:
                                  Text(
                                item.subtitle,
                              ),

                              trailing:
                                  const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),

                              onTap: () {

                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                        item.builder(context),
                                  ),
                                );

                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}