String hoursText(double hours) {
  if (hours == hours.roundToDouble()) {
    return '${hours.toInt()} hours';
  }
  return '${hours.toStringAsFixed(2)} hours';
}

String formatDatePretty(DateTime d) {
  const months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}
                