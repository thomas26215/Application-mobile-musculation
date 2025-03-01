import 'package:intl/intl.dart';
import '../database_helper.dart';

class TagsTable {
    static const String tableName = 'tags';

    static Future<void createTable(DataBaseHelper dbHelper) async {
        final db
