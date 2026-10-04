# nums

[![Made with AI](https://img.shields.io/badge/Made_with-AI_assistance-blue)](AI-USAGE.md)

AI credit: From September 20 to October 4, I used Claude and OpenAI Codex extensively for implementation help. I estimate AI contributed about 80% and I contributed about 20%, including writing the initial welcome, login, and sign-up screens and making the app's visual design and layout decisions. This is a retrospective estimate, not a line-by-line measurement.

## 1. Overview

`nums` is a Flutter cookie ordering app for customers and bakery staff. Customers can browse and customize cookie orders and follow their progress, while staff can manage orders, inventory, and baking batches.

## 2. Setup and installation

The app was verified locally with Flutter 3.47.5 and Dart 3.13.4. `pubspec.yaml` requires Dart 3.6 or later.

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) with its bundled Dart SDK, and configure a device, emulator, or desktop/browser target.
2. Clone the repository and enter its directory:

   ```sh
   git clone https://github.com/JethroMarkBejec/nums.git
   cd nums
   ```

3. Fetch the packages:

   ```sh
   flutter pub get
   ```

No API keys, backend URL, or environment file is required. The app uses local demo data. Never add real credentials to source control.

## 3. How to run it

With a device or emulator connected, run:

```sh
flutter run
```

To choose a specific device, see the available targets with `flutter devices`, then run `flutter run -d <device-id>`. A successful launch opens the nums welcome screen. In debug mode, DevicePreview is enabled so the layout can be previewed at different device sizes.

## 4. Features and usage

### Customer flow

1. **Welcome, sign in, and sign up:** Start at Welcome, then sign in or create a local account. For a quick walkthrough, use `welcome@nums.com` with password `cookies123`.
2. **Home and Menu:** Browse the home specials or open Menu to choose cookie boxes. The home notification icon opens Notifications.
3. **Customize and cart:** Choose a cookie item, set the box size, quantity, and mix-ins, then review or edit quantities in Cart.
4. **Checkout:** Review the total and pickup/delivery date, choose GCash, Maya, or GoTyme, and confirm the payment prompt. A successful demo payment creates the order and records it as **Paid (demo)**.
5. **Confirmation and order tracking:** Review the confirmation, then follow the order in Orders. Delivered orders appear in History. Order updates create in-app notifications, which can be marked read.
6. **Profile:** View the signed-in account and access account actions.

### Staff flow

The staff screens provide a dashboard, an order queue and order details, inventory editing, batch management, and a staff profile. In debug builds, open **Profile** and tap **Open demo staff dashboard**. Staff can advance orders through Placed, Preparing, Out for delivery, and Delivered, adjust inventory, and progress baking batches.

## 5. Project structure

- `lib/main.dart`, `lib/app.dart`: app entry point, DevicePreview, providers, and theme setup.
- `lib/routes/app_routes.dart`: named screen routes.
- `lib/screens/auth/`: welcome, login, sign-up, and verification screens.
- `lib/screens/customer/`: home, menu, cart, orders, history, notifications, profile, and checkout screens.
- `lib/screens/admin/`: staff dashboard, order, inventory, batch, and profile screens.
- `lib/models/`: app data types.
- `lib/providers/`: in-memory authentication, cart, inventory, batch, order, and notification state.
- `lib/services/`: local service stubs for authentication, payment, orders, batches, inventory, and suggestions.
- `lib/theme/`, `lib/widgets/`, `lib/utils/`: visual styling, reusable UI, formatting, constants, and validation.
- `assets/`: app illustrations, payment marks, and fonts.

## 6. Screenshots

Add your app screenshots here using the screen names shown in the app (for example, Welcome, Login, Home, Menu, Cart, Orders, and Profile). Keep the original image filenames and link each capture under its matching screen name. The screenshot files have not been added to this repository yet.

## 7. Known issues and next steps

### Known issues

- Accounts, cart contents, orders, notifications, inventory, and batch progress reset when the app restarts.
- Sign-in is local, and staff screens are not protected by role-based authorization.
- Wallet payment is simulated; no money is charged or transferred.
- Daily cookie counts and some shop content use sample values.
- The app is not deployed.

### Next steps

- Add persistent storage if data should survive app restarts.
- Add secure authentication and staff authorization if the app is used with real accounts.
- Integrate a payment provider if real payments are required.
- Replace sample cookie counts and shop content with live data if needed.

## Final Project

### My project repository

Public repository: [nums](https://github.com/JethroMarkBejec/nums)

Live app: Not deployed

### What it is

See [Overview](#1-overview).

### How to run it

Follow [Setup and installation](#setup-and-installation) and [How to run it](#how-to-run-it) above.

### Presentation

- Video (public Google Drive link): Add your video link
- Slides (link or PDF): Add your slides link
- Square image: Add the image to this folder or provide a link

## AI usage

See [AI-USAGE.md](AI-USAGE.md) for the tools used, what I changed, and my contributions.
