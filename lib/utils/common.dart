import 'package:intl/intl.dart' as intl;

String getDayOfWeekVi(String dayEn) {
  switch (dayEn) {
    case "Monday":
      return "Thứ 2";
    case "Tuesday":
      return "Thứ 3";
    case "Wednesday":
      return "Thứ 4";
    case "Thursday":
      return "Thứ 5";
    case "Friday":
      return "Thứ 6";
    case "Saturday":
      return "Thứ 7";
    case "Sunday":
      return "Chủ nhật";
    default:
      return "N/A";
  }
}

String formatAmount(dynamic amount) {
  if (amount != null) {
    return intl.NumberFormat.decimalPattern().format(amount);
  } else {
    return "";
  }
}
