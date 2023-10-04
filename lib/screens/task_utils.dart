import 'package:todolist/model/data_model.dart';
import 'package:todolist/screens/home_page.dart';

List<TaskModel> filterTasks(
    List<TaskModel> todolist, String search, FilterCriteria selectedFilter) {
  final filteredBySearch = search.isEmpty
      ? todolist
      : todolist
          .where((task) =>
              task.taskName.toLowerCase().contains(search.toLowerCase()))
          .toList();
  final filteredByCriteria = filterTasksByCriteria(filteredBySearch, selectedFilter);

  return filteredByCriteria;
}
 List<TaskModel> filterTasksByCriteria(List<TaskModel> tasks, FilterCriteria selectedFilter) {
    final now = DateTime.now();
    switch (selectedFilter) {
      case FilterCriteria.Daily:
        return tasks.where((task) {
          final taskDate = task.date;
          return taskDate.year == now.year &&
              taskDate.month == now.month &&
              taskDate.day == now.day;
        }).toList();
      case FilterCriteria.Weekly:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return tasks.where((task) {
          final taskDate = task.date;
          return taskDate.isAfter(startOfWeek) &&
              taskDate.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
      case FilterCriteria.Monthly:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);
        return tasks.where((task) {
          final taskDate = task.date;
          return taskDate.isAfter(startOfMonth) &&
              taskDate.isBefore(endOfMonth.add(const Duration(days: 1)));
        }).toList();
      case FilterCriteria.All:
      return tasks;
    }
  }
  