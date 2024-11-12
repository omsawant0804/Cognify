import 'package:cognify_app/EvaluationScreen.dart';
import 'package:cognify_app/RecommendationScreen.dart';
import 'package:cognify_app/goodbehaviourgame.dart';
import 'package:cognify_app/learning/Birdlearning.dart';
import 'package:cognify_app/learning/Seacreaturelearning.dart';
import 'package:cognify_app/learning/animallearning.dart';
import 'package:cognify_app/main.dart';
import 'package:cognify_app/screens/AttentionHomeScreen.dart';
import 'package:cognify_app/screens/BasicHomeScreen.dart';
import 'package:cognify_app/screens/Behaviour2HomeScreen.dart';
import 'package:cognify_app/screens/BehaviourHomeScreen.dart';
import 'package:cognify_app/screens/EmotionHomeScreen.dart';
import 'package:cognify_app/screens/MathHomeScreen.dart';
import 'package:cognify_app/screens/MemoryHomeScreen.dart';
import 'package:cognify_app/screens/ReasoningHomeScreen.dart';
import 'package:flutter/material.dart';
import '../widgets/category_icon.dart';
import '../widgets/category_card.dart';
import '../widgets/bottom_nav_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showAdditionalCategories = false;

  late PageController _pageController;
  late AnimationController _firstCardController;
  late AnimationController _secondCardController;
  late AnimationController _thirdCardController;

  late Animation<Offset> _firstCardAnimation;
  late Animation<Offset> _secondCardAnimation;
  late Animation<Offset> _thirdCardAnimation;

  // Adding fade animations for each card
  late Animation<double> _firstCardFadeAnimation;
  late Animation<double> _secondCardFadeAnimation;
  late Animation<double> _thirdCardFadeAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _initControllers();
    _triggerAnimations();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
  }

  void _initControllers() {
    _secondCardController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _firstCardController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _thirdCardController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _secondCardAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _secondCardController, curve: Curves.easeOut));

    _firstCardAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _firstCardController, curve: Curves.easeOut));

    _thirdCardAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _thirdCardController, curve: Curves.easeOut));

    // Initialize fade animations for each card
    _firstCardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _firstCardController, curve: Curves.easeIn),
    );
    _secondCardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _secondCardController, curve: Curves.easeIn),
    );
    _thirdCardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _thirdCardController, curve: Curves.easeIn),
    );
  }

  Future<void> _triggerAnimations() async {
    await _secondCardController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _firstCardController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    await _thirdCardController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstCardController.dispose();
    _secondCardController.dispose();
    _thirdCardController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    // Update the selected index immediately
    setState(() {
      _selectedIndex = index;
    });

    // Trigger the page transition
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    if (index == 0) {
      _firstCardController.reset();
      _secondCardController.reset();
      _thirdCardController.reset();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerAnimations();
      });
    }
  }

  void _toggleAdditionalCategories() {
    setState(() {
      _showAdditionalCategories = !_showAdditionalCategories;
      if (_showAdditionalCategories) {
        _fadeController.forward();
      } else {
        _fadeController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6E7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6E7),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.black),
                  iconSize: 40,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose what',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'to learn Today?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryIcon(
                      iconPath: 'assets/homeicons/Brain.png',
                      label: 'Memory',
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MemoryHomeScreen()),
                        );
                      },
                    ),
                    CategoryIcon(
                      iconPath: 'assets/homeicons/Eye.png',
                      label: 'Attention',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AttentionHomeScreen()),
                        );
                      },
                    ),

                    CategoryIcon(
                      iconPath: 'assets/homeicons/other.png',
                      label: 'Basics',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BasicHomeScreen()),
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: _toggleAdditionalCategories,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0, 0, 22.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 24,
                          child: Icon(
                            _showAdditionalCategories
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 30,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showAdditionalCategories)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 25.0),
                          CategoryIcon(
                            iconPath: 'assets/homeicons/routine.png',
                            label: 'Routine',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BehaviourHomeScreen()),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          CategoryIcon(
                            iconPath: 'assets/homeicons/Smiley.png',
                            label: 'Emotions',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EmotionHomeScreen()),
                              );
                            },
                          ),
                          const SizedBox(width: 10),


                         /* CategoryIcon(
                            iconPath: 'assets/homeicons/math.png',
                            label: 'maths',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MathHomeScreen()),
                              );
                            },
                          ),*/

                          CategoryIcon(
                            iconPath: 'assets/homeicons/talk.png',
                            label: 'Behaviour',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Behaviour2HomeScreen()),
                              );
                            },
                          ),


                          /*CategoryIcon(
                            iconPath: 'assets/homeicons/reason.png',
                            label: 'Reasoning',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReasoningHomeScreen()),
                              );
                            },
                          ),*/





                          const SizedBox(width: 16.0),
                        ],
                      ),
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
                child: Text(
                  "Today's Pick",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AnimalScreen()),
                            );
                          },
                          child: FadeTransition(
                            opacity: _firstCardFadeAnimation,
                            child: SlideTransition(
                              position: _firstCardAnimation,
                              child: const SizedBox(
                                width: 250,
                                child: CategoryCard(
                                  color: Color(0xFFFF9051),
                                  label: 'Animals',
                                  image: 'assets/homeicons/giraffe.png',
                                  cardHeight: 250,
                                  cardWidth: 200,
                                  imageHeight: 150,
                                  imageWidth: 350,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SeacreatureScreen()),
                                  );
                                },
                                child: FadeTransition(
                                  opacity: _secondCardFadeAnimation,
                                  child: SlideTransition(
                                    position: _secondCardAnimation,
                                    child: const SizedBox(
                                      width: 250,
                                      height: 90,
                                      child: CategoryCard(
                                        color: Color(0xFFC7E5FF),
                                        label: 'Sea creatures',
                                        image: 'assets/homeicons/fish.png',
                                        cardHeight: 70,
                                        cardWidth: 200,
                                        imageHeight: 60,
                                        imageWidth: 130,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => BirdScreen()),
                                  );
                                },
                                child: FadeTransition(
                                  opacity: _thirdCardFadeAnimation,
                                  child: SlideTransition(
                                    position: _thirdCardAnimation,
                                    child: SizedBox(
                                      height: 90,
                                      width: 180,
                                      child: CategoryCard(
                                        color: Color(0xFF724E8C),
                                        label: 'Birds',
                                        image: 'assets/homeicons/bird.png',
                                        cardHeight: 70,
                                        cardWidth: 200,
                                        imageHeight: 50,
                                        imageWidth: 130,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // const Center(child: Text("Second Tab")),
          ChooseLessonScreen(),
          EvaluationScreen(),

        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onTabSelected,
      ),
    );
  }
}
