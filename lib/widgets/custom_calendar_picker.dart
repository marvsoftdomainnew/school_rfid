import 'package:flutter/material.dart';
import 'package:schoolmsrfid/theme/app_colors.dart';
import 'package:schoolmsrfid/widgets/primary_button.dart';
import 'package:sizer/sizer.dart';

class CustomCalendarPicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomCalendarPicker({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<CustomCalendarPicker> createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<CustomCalendarPicker> {
  late DateTime _focusedMonth;
  DateTime? _selectedDate;

  final Color primary = const Color(0xFF00b894);

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _focusedMonth =
        DateTime(widget.initialDate?.year ?? DateTime.now().year,
            widget.initialDate?.month ?? DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),
            SizedBox(height: 2.h),
            _weekDays(),
            SizedBox(height: 1.h),
            _calendarGrid(),
            SizedBox(height: 2.h),
            _actions(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _focusedMonth =
                  DateTime(_focusedMonth.year, _focusedMonth.month - 1);
            });
          },
        ),
        GestureDetector(
          onTap: _openMonthYearPicker,
          behavior: HitTestBehavior.opaque, // 🔑 touch area reliable
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 1.2.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1), // theme match
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${_monthName(_focusedMonth.month)} ${_focusedMonth.year}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 1.w),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),

        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _focusedMonth =
                  DateTime(_focusedMonth.year, _focusedMonth.month + 1);
            });
          },
        ),
      ],
    );
  }

  Widget _weekDays() {
    const days = ["S", "M", "T", "W", "T", "F", "S"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => SizedBox(
          width: 10.w,
          child: Center(
            child: Text(
              d,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _calendarGrid() {
    final firstDayOfMonth =
    DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth =
    DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);

    final startWeekday = firstDayOfMonth.weekday % 7;

    final totalCells = startWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    int day = 1 - startWeekday;

    return Column(
      children: List.generate(rows, (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (_) {
            if (day < 1 || day > daysInMonth) {
              day++;
              return SizedBox(width: 10.w, height: 6.h);
            }

            final currentDate =
            DateTime(_focusedMonth.year, _focusedMonth.month, day);

            final isSelected = _selectedDate != null &&
                DateUtils.isSameDay(_selectedDate, currentDate);

            final isDisabled = currentDate.isBefore(widget.firstDate) ||
                currentDate.isAfter(widget.lastDate);

            day++;

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                setState(() {
                  _selectedDate = currentDate;
                });
              },
              child: Container(
                width: 10.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: isSelected ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "${currentDate.day}",
                    style: TextStyle(
                      color: isDisabled
                          ? Colors.grey[400]
                          : isSelected
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL",style: TextStyle(color: AppColors.primary),),
          ),
        ),
        Expanded(
          child: PrimaryButton(
            text: "APPLY",
            height: 5.h,
            radius: 12,
            backgroundColor: _selectedDate == null
                ? Colors.grey.shade400
                : null,
            onPressed: () {
              if (_selectedDate == null) return;
              Navigator.pop(context, _selectedDate);
            },
          ),
        ),
      ],
    );
  }

  String _monthName(int m) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[m - 1];
  }

  Future<void> _openMonthYearPicker() async {
    final now = DateTime.now();

    int tempYear = _focusedMonth.year;
    int tempMonth = _focusedMonth.month;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final maxHeight = MediaQuery.of(ctx).size.height * 0.75;

        return SafeArea(
          top: false,
          child: SizedBox(
            height: maxHeight, // 🔑 screen-aware height
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: [
                      // ================= TITLE =================
                      Text(
                        "Select Month & Year",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // ================= YEAR LIST =================
                      Expanded(
                        child: ListView.builder(
                          itemCount: 27, // last 27 years
                          itemBuilder: (_, index) {
                            final year = now.year - index;
                            final isSelected = year == tempYear;

                            return ListTile(
                              title: Text(
                                year.toString(),
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              trailing:
                              isSelected ? const Icon(Icons.check) : null,
                              onTap: () {
                                setModalState(() {
                                  tempYear = year;
                                });
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // ================= MONTH CHIPS =================
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: List.generate(12, (i) {
                          final month = i + 1;
                          final isSelected =
                              month == tempMonth && tempYear == tempYear;

                          return ChoiceChip(
                            label: Text(_monthName(month)),
                            selected: month == tempMonth,
                            selectedColor: primary,
                            labelStyle: TextStyle(
                              color: month == tempMonth
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onSelected: (_) {
                              setModalState(() {
                                tempMonth = month; // 🔑 instant selection
                              });
                            },
                          );
                        }),
                      ),

                      SizedBox(height: 2.h),

                      // ================= ACTIONS =================
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("CANCEL",style: TextStyle(color: AppColors.primary),),
                            ),
                          ),
                          Expanded(
                            child: PrimaryButton(
                              text: "APPLY",
                              height: 5.h,
                              radius: 12,
                              onPressed: () {
                                setState(() {
                                  _focusedMonth = DateTime(tempYear, tempMonth);
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }


}
