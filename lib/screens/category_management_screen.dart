import 'package:flutter/material.dart';
// 본인의 프로젝트 경로에 맞게 import 확인 필요
import '../repository/supabase_diary_repository.dart'; 

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  
  // 기본 선택 아이콘 (이모지로 관리하면 더 편리합니다)
  String _selectedIcon = '💰';

  // 확장된 아이콘/이모지 리스트 (가계부용으로 더 다양하게 추가)
  final List<String> _availableIcons = [
    '💰', '🍔', '☕', '🍺', '🚗', '🚌', '🏠', '🛒', 
    '🎬', '🎮', '⚽', '🏥', '💊', '📚', '🎁', '🔌', 
    '📱', '👕', '👠', '💄', '✂️', '🧹', '🐱', '🐶',
    '✈️', '🏨', '🎟️', '🕯️', '👶', '❤️', '💼', '🛠️'
  ];

  // DB에서 불러온 카테고리 목록만 담음
  List<Map<String, dynamic>> _displayCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // 1. 기본 카테고리를 제거하고 DB 데이터만 로드하도록 수정
  Future<void> _loadCategories() async {
    try {
      final customCategories = await SupabaseRepository.getCategoryList();
      
      setState(() {
        // 이제 코드상의 defaultCategories 없이 DB 데이터만 사용합니다.
        _displayCategories = customCategories;
      });
    } catch (e) {
      debugPrint("카테고리 로드 실패: $e");
    }
  }

  Widget _buildInputRow(String label, Widget inputField) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: "HakgyoansimWoojuR", 
              fontWeight: FontWeight.w600, 
              fontSize: 20, 
              color: Colors.grey.shade600
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(child: inputField),
        ],
      ),
    );
  }

  // 카테고리 수정 다이얼로그
  void _showEditCategoryDialog(Map<String, dynamic> category) {
    _nameController.text = category['name'] ?? '';
    _selectedIcon = category['icon'] ?? '💰'; // iconCode 대신 icon 사용

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 20),
                const Text('카테고리 수정', style: TextStyle(fontFamily: "Yeongdeok-Sea", fontSize: 22, color: Colors.orange)),
                const SizedBox(height: 20),
                _buildInputRow(
                  '이름',
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
                    ),
                    style: const TextStyle(color: Colors.brown, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                // 아이콘 선택 그리드
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final iconStr = _availableIcons[index];
                    return GestureDetector(
                      onTap: () => setDialogState(() => _selectedIcon = iconStr),
                      child: CircleAvatar(
                        backgroundColor: _selectedIcon == iconStr ? Colors.orange : Colors.grey[100],
                        child: Text(iconStr, style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.isNotEmpty) {
                        // Repository의 update 함수도 icon(String)을 받도록 확인 필요
                        await SupabaseRepository.updateCategory(category['id'], _nameController.text, _selectedIcon);
                        _loadCategories();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('수정 완료', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    _nameController.clear();
    _selectedIcon = '💰';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50, height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 20),
                const Text('새 카테고리 추가', style: TextStyle(fontFamily: "Yeongdeok-Sea", fontSize: 22, color: Colors.orange)),
                const SizedBox(height: 20),
                _buildInputRow(
                  '이름',
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: '예: 취미, 간식'),
                    style: const TextStyle(color: Colors.brown, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('아이콘 선택', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange)),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _availableIcons.length,
                  itemBuilder: (context, index) {
                    final iconStr = _availableIcons[index];
                    return GestureDetector(
                      onTap: () => setDialogState(() => _selectedIcon = iconStr),
                      child: CircleAvatar(
                        backgroundColor: _selectedIcon == iconStr ? Colors.orange : Colors.grey[100],
                        child: Text(iconStr, style: const TextStyle(fontSize: 20)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.isNotEmpty) {
                        await SupabaseRepository.createCategory(_nameController.text, _selectedIcon);
                        _loadCategories();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: const Text('추가하기', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리 관리', style: TextStyle(fontFamily: "Yeongdeok-Sea")),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '직접 추가하신 카테고리 목록입니다.\n지출 작성 시 선택할 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: _displayCategories.isEmpty
                ? const Center(child: Text('추가된 카테고리가 없습니다.\n우측 하단 버튼을 눌러 추가해보세요!'))
                : ListView.builder(
                    itemCount: _displayCategories.length,
                    itemBuilder: (context, index) {
                      final cat = _displayCategories[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          onTap: () => _showEditCategoryDialog(cat),
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange[50],
                            child: Text(
                              cat['icon']?.toString() ?? '💰', 
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          title: Text(
                            cat['name'] ?? '이름 없음', 
                            style: const TextStyle(fontWeight: FontWeight.bold)
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              _showDeleteConfirmDialog(cat);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteConfirmDialog(Map<String, dynamic> cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('카테고리 삭제', style: TextStyle(fontFamily: "Yeongdeok-Sea")),
        content: Text('[${cat['name']}] 카테고리를 정말 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await SupabaseRepository.deleteCategory(cat['id']);
              _loadCategories();
              Navigator.pop(context);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}