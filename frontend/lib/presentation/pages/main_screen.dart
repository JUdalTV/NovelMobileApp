import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import 'home/home.dart';
import 'novel/novel_screen.dart';
import 'profile/profile_screen.dart';
import 'reader/doc_truyen_screen.dart';
import '../../../domain/entities/chapter.dart';
import '../../domain/repositories/novel_repository.dart';
import 'auth/signin.dart';

class MainScreen extends StatelessWidget {
  final NovelRepository novelRepository;

  const MainScreen({
    Key? key,
    required this.novelRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kiểm tra trạng thái authentication
    final authState = context.watch<AuthBloc>().state;
    
    // Nếu không còn đăng nhập, chuyển về màn hình đăng nhập
    if (authState is Unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SigninScreen()),
          (route) => false,
        );
      });
    }
    
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: [
              HomeScreen(novelRepository: novelRepository),
              NovelScreen(novelRepository: novelRepository),
              ProfileScreen(),
              // Reader screen should only be shown when a chapter is selected
              if (state.currentIndex == 2)
                const Center(
                  child: Text(
                    'Chọn một chương để bắt đầu đọc',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              // If trying to navigate to reader tab without a chapter, show a message
              if (index == 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng chọn một chương để đọc'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              context.read<NavigationBloc>().add(NavigationChanged(index: index));
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                activeIcon: Icon(Icons.book),
                label: 'Tủ sách',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                activeIcon: Icon(Icons.menu_book),
                label: 'Đọc truyện',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Cá nhân',
              ),
            ],
          ),
        );
      },
    );
  }
} 