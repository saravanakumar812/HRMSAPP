class Payslip {
  final int id;
  final String name;
  final String department;
  final int year;
  final int month;
  final int emp_id;
  final String payment;
  final String basic;
  final String hra;
  final String deduction;
  final String deductionName;
  final String hraName;
  final String basicName;
  final String designation;

  Payslip({
    required this.id,
    required this.name,
    required this.emp_id,
    required this.year,
    required this.payment,
    required this.hra,
    required this.basic,
    required this.deduction,
    required this.designation,
    required this.department,
    required this.month,
    required this.basicName,
    required this.hraName,
    required this.deductionName,
  });
}
