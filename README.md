# nums

A Flutter cookie ordering app with a local customer account, live cart, checkout review, order progress, and notifications.

## Run the app

1. Use Flutter with Dart 3.6 or later.
2. Run `flutter pub get` in the project root.
3. Run `flutter run` on a connected device or emulator.

For a quick sign-in, use `welcome@nums.com` with password `cookies123`. You can also create an account from the sign-in screen.

## Ordering flow

- Add cookie boxes from Home or Menu. The cart badge, quantities, and total update together.
- Review the cart and choose a payment method. Checkout asks you to confirm the order and total before creating it.
- New orders appear under **In progress**. The app's admin order queue can advance an order through Placed, Preparing, Out for delivery, and Delivered. Each status change adds a notification for that customer.
- Delivered orders move into **History**. Notifications can be marked read individually or all at once.

## Local prototype limits

Accounts, cart contents, orders, and notifications are held in memory and reset when the app restarts. Wallet methods are recorded as the selected method, but this project has no payment gateway, email service, or server; orders therefore remain marked **Pending** until those integrations are added. The included demo account is for local UI walkthroughs only.
