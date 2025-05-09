import '../models/task_model.dart';
import '../data/db_helper.dart';
import '../data/task_dao.dart';

class TaskService {
  static final TaskDao _taskDao = TaskDao();

  static Future<void> insertTask(TaskModel task) async {
    await _taskDao.insertTask(task);
  }

  static Future<List<TaskModel>> getAllTasks() async {
    return await _taskDao.getAllTasks();
  }

  static Future<void> updateTask(TaskModel task) async {
    await _taskDao.updateTask(task);
  }

  static Future<void> deleteTask(String id) async {
    await _taskDao.deleteTask(id);
  }

  static Future<void> deleteAllTasks() async {
    await _taskDao.deleteAllTasks();
  }

  static Future<void> deleteCompletedTasks() async {
    await _taskDao.deleteCompletedTasks();
  }

  static Future<List<TaskModel>> searchTasks(String keyword) async {
    return await _taskDao.searchTasks(keyword);
  }
}