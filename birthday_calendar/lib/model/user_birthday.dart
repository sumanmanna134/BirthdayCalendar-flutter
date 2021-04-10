
import 'package:birthday_calendar/constants.dart';

class UserBirthday {
  final String name;
  final String birthdayDate;
  bool hasNotification;

  UserBirthday(this.name, this.birthdayDate, this.hasNotification);

  void updateNotificationStatus(bool status) {
    this.hasNotification = status;
  }

  bool equals(UserBirthday otherBirthday) {
    return (this.name == otherBirthday.name &&
            this.birthdayDate == otherBirthday.birthdayDate);
  }

  UserBirthday.fromJson(Map<String, dynamic> json) :
        name = json[userBirthdayNameKey],
        birthdayDate = json[userBirthdayDateKey],
        hasNotification = json[userBirthdayHasNotificationKey];

  Map<String, dynamic> toJson() => {
    userBirthdayNameKey : name,
    userBirthdayDateKey : birthdayDate,
    userBirthdayHasNotificationKey : hasNotification
 };
}