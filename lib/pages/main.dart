import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';
import 'package:muscu/pages/dashboard/main.dart';
import 'package:muscu/pages/trainings/list/main.dart';

class MainBottomTabs extends StatefulWidget {
  @override
  State<MainBottomTabs> createState() => _MainBottomTabsState();
}

class _MainBottomTabsState extends State<MainBottomTabs> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final PageController _pageController;

  final List<_TabItemData> _tabs = [
    _TabItemData(
      icon: UniconsLine.dashboard,
      label: "Dashboard",
    ),
    _TabItemData(
      icon: UniconsLine.dumbbell,
      label: "Trainings",
    ),
    _TabItemData(
      icon: UniconsLine.globe,
      label: "Communauté",
    ),
    _TabItemData(
      icon: UniconsSolid.chart,
      label: "Statistics",
    ),
  ];

  final List<Widget> _pages = [
    DashBoardPage(),
    TrainingsTabs(),
    TrainingsTabs(),
    TrainingsTabs(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.ease,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Hauteur suffisante pour icône + label + padding
    const double barHeight = 76;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics: const BouncingScrollPhysics(),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: barHeight,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_tabs.length, (index) {
              final selected = _selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutQuint,
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutQuint,
                          width: selected ? 32 : 50,
                          height: selected ? 32 : 20,
                          child: Icon(
                            _tabs[index].icon,
                            color: selected
                                ? theme.appBarTheme.backgroundColor ?? theme.primaryColor
                                : Colors.white,
                            size: selected ? 32 : 50,
                          ),
                        ),
                        // Toujours réserver la place du label pour éviter l'overflow
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                          child: selected
                              ? Padding(
                                  key: ValueKey('label-$index'),
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    _tabs[index].label,
                                    style: TextStyle(
                                      color: theme.appBarTheme.backgroundColor ?? theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  key: ValueKey('empty-$index'),
                                  height: 18, // même hauteur que le label pour stabilité
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItemData {
  final IconData icon;
  final String label;
  const _TabItemData({required this.icon, required this.label});
}

