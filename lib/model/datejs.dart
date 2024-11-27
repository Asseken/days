//时间计算

String compareDates(String timeString) {
  // 提取日期部分，假设时间格式为 "2024-11-01 星期一"
  final datePart = timeString.split(' ')[0]; // 获取 "2024-11-01"
  final date = DateTime.tryParse(datePart); // 将字符串转为 DateTime 对象

  if (date == null) return "无效日期"; // 如果解析失败，返回错误提示

  final currentDate = DateTime.now();
  final currentDateOnly = DateTime(
      currentDate.year, currentDate.month, currentDate.day); // 仅保留年月日部分，去掉时分秒

  if (date.isBefore(currentDateOnly)) {
    return "已经${currentDateOnly.difference(date).inDays}天";
  } else if (date.isAtSameMomentAs(currentDateOnly)) {
    return "就是今天";
  } else {
    final difference = date.difference(currentDateOnly);
    return "还剩${difference.inDays}天";
  }
}
