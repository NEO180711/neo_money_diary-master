import 'package:flutter/material.dart';
import '../repository/sql_diary_crud_repository.dart';

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

  List<Map<String, dynamic>> _customCategories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories(); // 초기 로드
  }
  
  // 만약 Provider를 도입한다면, 이 화면은 Provider를 구독하게 됩니다.
  // 여기서는 질문하신 UI 구조 업데이트를 위해 FutureBuilder 대신 
  // 리스트를 직접 관리하는 구조를 유지하되, 
  // 내역 입력 페이지가 열릴 때 DB를 다시 읽도록 유도하는 팁을 드립니다.

  Future<void> _loadCategories() async {
    final categories = await SqlDiaryCrudRepository.getCategoryList();
    setState(() {
      _customCategories = categories;
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
              '사용자가 직접 추가한 카테고리 목록입니다.\n지출 작성 시 이 카테고리들을 선택할 수 있습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: _customCategories.isEmpty
                ? const Center(child: Text('추가된 카테고리가 없습니다.'))
                : ListView.builder(
                    itemCount: _customCategories.length,
                    itemBuilder: (context, index) {
                      final cat = _customCategories[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange[50],
                            child: Icon(
                              IconData(cat['iconCode'], fontFamily: 'MaterialIcons'),
                              color: Colors.orange,
                            ),
                          ),
                          title: Text(cat['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () async {
                              await SqlDiaryCrudRepository.deleteCategory(cat['id']);
                              _loadCategories();
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