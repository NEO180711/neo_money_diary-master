import 'package:flutter/material.dart';
import '../repository/sql_diary_crud_repository.dart';
import '../data/category.dart'; // 기본 카테고리 데이터를 가져오기 위해 추가

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedIconCode = Icons.help_outline.codePoint;

  // 선택 가능한 아이콘 리스트
  final List<IconData> _availableIcons = [
    Icons.restaurant, Icons.directions_bus, Icons.shopping_cart,
    Icons.movie, Icons.fitness_center, Icons.medical_services,
    Icons.school, Icons.home, Icons.redeem, Icons.coffee,
    Icons.fastfood, Icons.flight, Icons.payments, Icons.build,
  ];

  // 전체 카테고리 목록을 담을 리스트
  List<Map<String, dynamic>> _displayCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories(); // 초기 로드
  }

  Future<void> _loadCategories() async {
    // 1. DB에서 커스텀 카테고리 불러오기
    final customCategories = await SqlDiaryCrudRepository.getCategoryList();
    
    // 2. category.dart의 기본 항목들을 리스트화 (id를 -1로 주어 기본 항목임을 표시)
    final List<Map<String, dynamic>> defaultCategories = [
      {'id': -1, 'name': category1, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category2, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category3, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category4, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category5, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category6, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category7, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category8, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category9, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category10, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category11, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category12, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category13, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category14, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category15, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category16, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category17, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category18, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category19, 'iconCode': Icons.star.codePoint},
      {'id': -1, 'name': category20, 'iconCode': Icons.star.codePoint},
    ];

    setState(() {
      // 기본 항목 + 커스텀 항목 합치기
      _displayCategories = [...defaultCategories, ...customCategories];
    });
  }

  Widget _buildInputRow(String label, Widget inputField) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: "HakgyoansimWoojuR", fontWeight: FontWeight.w600, fontSize: 20, color: Colors.grey.shade600),
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
    _nameController.text = category['name'];
    _selectedIconCode = category['iconCode'];

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
            left: 20,
            right: 20,
            top: 20,
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
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange.shade100)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
                    ),
                    style: const TextStyle(color: Colors.brown, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _availableIcons.map((icon) {
                    return GestureDetector(
                      onTap: () => setDialogState(() => _selectedIconCode = icon.codePoint),
                      child: CircleAvatar(
                        backgroundColor: _selectedIconCode == icon.codePoint ? Colors.orange : Colors.grey[200],
                        child: Icon(icon, color: _selectedIconCode == icon.codePoint ? Colors.white : Colors.black54),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.isNotEmpty) {
                        await SqlDiaryCrudRepository.updateCategory(category['id'], _nameController.text, _selectedIconCode);
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
            left: 20,
            right: 20,
            top: 20,
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
                    decoration: InputDecoration(
                      hintText: '예: 취미, 간식',
                      hintStyle: TextStyle(color: Colors.brown.shade200),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange.shade100)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange)),
                    ),
                    style: const TextStyle(color: Colors.brown, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('아이콘 선택', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _availableIcons.map((icon) {
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() => _selectedIconCode = icon.codePoint);
                        setState(() => _selectedIconCode = icon.codePoint);
                      },
                      child: CircleAvatar(
                        backgroundColor: _selectedIconCode == icon.codePoint ? Colors.orange : Colors.grey[200],
                        child: Icon(icon, color: _selectedIconCode == icon.codePoint ? Colors.white : Colors.black54),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_nameController.text.isNotEmpty) {
                        await SqlDiaryCrudRepository.createCategory(_nameController.text, _selectedIconCode);
                        _loadCategories();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
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
              '상단은 기본 카테고리이며, 하단은 추가하신 목록입니다.\n지출 작성 시 모든 카테고리를 선택할 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: _displayCategories.isEmpty
                ? const Center(child: Text('불러올 카테고리가 없습니다.'))
                : ListView.builder(
                    itemCount: _displayCategories.length,
                    itemBuilder: (context, index) {
                      final cat = _displayCategories[index];
                      final bool isDefault = cat['id'] == -1; // 기본 항목 여부 확인

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          onTap: isDefault ? null : () => _showEditCategoryDialog(cat),
                          leading: CircleAvatar(
                            backgroundColor: isDefault ? Colors.grey[100] : Colors.orange[50],
                            child: Icon(
                              IconData(cat['iconCode'], fontFamily: 'MaterialIcons'),
                              color: isDefault ? Colors.grey : Colors.orange,
                            ),
                          ),
                          title: Text(
                            cat['name'], 
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDefault ? Colors.black54 : Colors.black,
                            )
                          ),
                          subtitle: isDefault ? const Text('기본 카테고리', style: TextStyle(fontSize: 11)) : null,
                          // 기본 카테고리는 삭제 버튼을 보여주지 않음
                          trailing: isDefault 
                            ? null 
                            : IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () {
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
                                            await SqlDiaryCrudRepository.deleteCategory(cat['id']);
                                            _loadCategories();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('삭제', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
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
        heroTag: 'add_category',
        onPressed: _showAddCategoryDialog,
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}