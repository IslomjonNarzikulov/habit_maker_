String localTimeZone = await
AwesomeNotifications
().

getLocalTimeZoneIdentifier();

String utcTimeZone = await
AwesomeNotifications
().

getLocalTimeZoneIdentifier();

await AwesomeNotifications
().createNotification
(
content: NotificationContent(
id: id,
channelKey: 'scheduled',
title: 'Notification every single minute',
body:
'This notification was scheduled to repeat every minute.',
notificationLayout: NotificationLayout.BigPicture,
bigPicture: 'asset://assets/images/melted-clock.png'),
schedule: NotificationInterval(interval: 60, timeZone: localTimeZone, repeats: true));

await AwesomeNotifications().createNotification(
content: NotificationContent(
id: id,
channelKey: 'scheduled',
title: 'Wait 5 seconds to show',
body: 'Now it is 5 seconds later.',
wakeUpScreen: true,
category: NotificationCategory.Alarm,
),
schedule: NotificationInterval(
interval: 5,
timeZone: localTimeZone,
preciseAlarm: true,
timezone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
);
await AwesomeNotifications().createNotification(
content: NotificationContent(
id: id,
channelKey: 'scheduled',
title: 'Notification at exactly every single minute',
body: 'This notification was schedule to repeat at every single minute at clock.',
notificationLayout: NotificationLayout.BigPicture,
bigPicture: 'asset://assets/images/melted-clock.png'),
schedule: NotificationCalendar(second: 0, timeZone: localTimeZone, repeats: true));
await AwesomeNotifications().createNotification(
content: NotificationContent(
id: id,
channelKey: 'scheduled',
title: 'Just in time!',
body: 'This notification was scheduled to shows at ' +
(Utils.DateUtils.parseDateToString(scheduleTime.toLocal()) ?? '?') +
' $timeZoneIdentifier (' +
(Utils.DateUtils.parseDateToString(scheduleTime.toUtc()) ?? '?') +
' utc)',
wakeUpScreen: true,
category: NotificationCategory.Reminder,
notificationLayout: NotificationLayout.BigPicture,
bigPicture: 'asset://assets/images/delivery.jpeg',
payload: {'uuid': 'uuid-test'},
autoDismissible: false,
),
schedule: NotificationCalendar.
fromDate
(
date
:
scheduleTime
)
);