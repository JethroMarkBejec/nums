# AI Usage in Flutter/Dart Code

I used Claude and OpenAI Codex while building the NUMS Flutter app between September 20 and October 4, 2026. My retrospective estimate is that AI helped with about 80% of the implementation. I contributed about 20%, including writing the initial welcome, login, and sign-up screens and making the app's visual design and layout decisions. This is an estimate, not a line-by-line measurement.

I did not keep a dated prompt log or separate commits for each screen. These entries describe the Flutter/Dart work from memory; the linked commits contain grouped changes. I have not assigned an exact day or assistant to an individual code change where I did not record it.

## 1. How I used AI

### Authentication screens and validation

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Exact attribution by change was not recorded.
- **What I asked:** Help connect the Flutter sign-in and account flow, including verification, field validation, and showing the signed-in user's details.
- **What it gave me:** Dart suggestions for form behavior, navigation, and feedback around the existing authentication screens.
- **What I kept or changed, and why:** I wrote the initial welcome, login, and sign-up screens and set their visual direction. I used AI help on later behavior and revisions, then reviewed the changes against the account flow I wanted.
- **Flutter/Dart files:** `lib/screens/auth/welcome_screen.dart`, `lib/screens/auth/login_screen.dart`, `lib/screens/auth/signup_screen.dart`, `lib/screens/auth/verification_screen.dart`, `lib/providers/auth_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [auth and customer-flow revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f).

### Cookie selection, customization, and cart

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Exact attribution by change was not recorded.
- **What I asked:** Help connect menu choices, cookie box customization, quantities, and cart contents in the local demo.
- **What it gave me:** Dart implementation suggestions for the customer ordering screens and cart state.
- **What I kept or changed, and why:** I kept the local cart flow and directed the screen layout and visual treatment so customers could review and customize a box before checkout.
- **Flutter/Dart files:** `lib/screens/customer/menu_screen.dart`, `lib/screens/customer/ordering/build_box_screen.dart`, `lib/screens/customer/ordering/customization_screen.dart`, `lib/screens/customer/ordering/solo_order_screen.dart`, `lib/screens/customer/cart_screen.dart`, `lib/providers/cart_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [cookie box and ordering UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Checkout, demo payment, and confirmation

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Exact attribution by change was not recorded.
- **What I asked:** Help make checkout reflect the cart, show the total and payment choice, and require payment before confirming an order.
- **What it gave me:** Dart changes and suggestions for the checkout review, local payment simulation, and order confirmation flow.
- **What I kept or changed, and why:** I kept payment as a local demo simulation. After noticing that the flow could show payment as pending, I directed it to show a paid demo status only after a successful simulated payment.
- **Flutter/Dart files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`, `lib/services/payment_service.dart`, `lib/repositories/payment_repository.dart`.
- **Commit:** [Checkout and confirmation revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f), [payment screen revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Customer order history and notifications

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Exact attribution by change was not recorded.
- **What I asked:** Help show order status and progress clearly, keep in-progress and delivered orders understandable, and surface order updates in the app.
- **What it gave me:** Flutter/Dart changes to customer order views and local order and notification state.
- **What I kept or changed, and why:** I kept the local demo status flow and reviewed the labels and screen layout so a customer can follow an order through its stages.
- **Flutter/Dart files:** `lib/screens/customer/orders_screen.dart`, `lib/screens/customer/history_screen.dart`, `lib/screens/customer/notifications_screen.dart`, `lib/providers/order_provider.dart`, `lib/providers/notification_provider.dart`.
- **Commit:** [Order progress and customer-flow revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f), [order management revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c).

### Staff order, inventory, and baking screens

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Exact attribution by change was not recorded.
- **What I asked:** Help make staff screens support the demo tasks of reviewing orders, updating their progress, adjusting stock, and tracking baking batches.
- **What it gave me:** Dart screen and state suggestions for staff order, inventory, and batch workflows.
- **What I kept or changed, and why:** I kept the local demo behavior and focused the workflows on actions that can be shown in the app without a backend.
- **Flutter/Dart files:** `lib/screens/admin/admin_dashboard_screen.dart`, `lib/screens/admin/orders_management_screen.dart`, `lib/screens/admin/order_details_screen.dart`, `lib/screens/admin/inventory_screen.dart`, `lib/screens/admin/batch_management_screen.dart`, `lib/providers/inventory_provider.dart`, `lib/providers/batch_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [staff order progress revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c).

### Shared Flutter styling, spacing, and motion

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Individual design iterations were not logged by day or assistant.
- **What I asked:** Help refine Dart layouts, spacing, type sizes, card and button depth, and motion while keeping the app's existing palette and device preview.
- **What it gave me:** Flutter theme and reusable-widget suggestions, plus screen layout revisions.
- **What I kept or changed, and why:** I made the visual design and layout decisions, reviewed the results, and asked for changes when elements felt crowded, misaligned, too large, or too flat. I kept the existing palette and mobile preview.
- **Flutter/Dart files:** `lib/theme/app_theme.dart`, `lib/theme/app_text_styles.dart`, `lib/widgets/app_button.dart`, `lib/widgets/app_card.dart`, `lib/widgets/app_screen_scaffold.dart`, `lib/screens/customer/customer_shell.dart`, `lib/screens/customer/profile_preferences_card.dart`.
- **Commit:** [Shared Flutter UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Local Chip assistant and guided navigation

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Exact attribution by change was not recorded.
- **What I asked:** Help add a local in-app assistant to guide customers through ordering and navigating the app, including accessible guided actions.
- **What it gave me:** Flutter/Dart UI and local assistant-flow suggestions.
- **What I kept or changed, and why:** I kept the assistant as a local demo feature and directed its role toward helping with the app's own ordering flow. I reviewed its navigation behavior and requested fixes when a destination did not open correctly.
- **Flutter/Dart files:** `lib/screens/customer/ordering/assistant_screen.dart`, `lib/services/assistant_service.dart`, `lib/services/chat_repository.dart`, `lib/routes/app_routes.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [assistant and customer-shell revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

## 2. Where the AI got it wrong

### Checkout could show payment as pending

- **What the AI-assisted flow did:** The order display could say “Payment: Pending” even though checkout was supposed to collect payment before confirming the order.
- **What was wrong:** That status contradicted the intended order flow.
- **What I did instead:** I asked for the local payment step to complete first and for the confirmed demo order to be labeled paid only after the simulation succeeds.
- **Flutter/Dart files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`.
- **Commit:** [Checkout and confirmation revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f).

### Some screen layouts clipped or used space awkwardly

- **What the AI-assisted layouts did:** Some screen iterations had cramped spacing, awkward alignment, or content extending beyond its intended area.
- **What was wrong:** The affected screens were harder to read and the layout did not feel consistent on the mobile preview.
- **What I did instead:** I reviewed the screens and requested specific adjustments to padding, alignment, and component sizing while preserving the existing palette and preview.
- **Flutter/Dart files:** `lib/screens/customer/ordering/build_box_screen.dart`, `lib/screens/customer/profile_preferences_card.dart`, `lib/theme/app_theme.dart`, `lib/widgets/app_button.dart`, `lib/widgets/app_card.dart`.
- **Commit:** [Shared Flutter UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Assistant navigation did not open the selected destination correctly

- **What the AI-assisted flow did:** The assistant's navigation could land on an unusable screen instead of taking the customer to the selected app destination.
- **What was wrong:** The assistant is meant to reduce navigation effort, so a broken destination defeated its purpose.
- **What I did instead:** I reported the failure and requested that its Flutter navigation and destination handling be corrected.
- **Flutter/Dart files:** `lib/screens/customer/ordering/assistant_screen.dart`, `lib/routes/app_routes.dart`, `lib/screens/customer/customer_shell.dart`.
- **Commit:** [Assistant and customer-shell revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

## 3. Who wrote what

### My Flutter/Dart contribution

I wrote the initial welcome, login, and sign-up screens. I also made the visual design and layout decisions, including the spacing, type sizing, visual hierarchy, color palette, and the amount of motion and depth. AI later helped revise behavior and connect parts of the app, so the current versions are AI-assisted revisions of my initial work.

- **Files:** `lib/screens/auth/welcome_screen.dart`, `lib/screens/auth/login_screen.dart`, `lib/screens/auth/signup_screen.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c).
- **My explanation:** Welcome introduces NUMS and routes into the account flow. Login validates sign-in fields and starts the local session. Sign-up collects details to create a local demo account. I designed the screens and chose how they should look and guide the user.

### AI-assisted Flutter/Dart code I understand best

- **Files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`, `lib/services/payment_service.dart`.
- **Commit:** [Checkout and confirmation revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f).
- **My explanation:** The payment screen summarizes the cart and runs a local payment simulation. If it succeeds, the app creates an order and opens the confirmation screen. The order provider holds that order and its progress in memory. The payment is only a demo and no money is transferred.

## Limits of this record

This file describes Flutter/Dart code only. It is a retrospective account, not a prompt diary or a line-by-line authorship report. The commit links identify grouped code changes and do not establish which assistant wrote each line. My 80/20 estimate is approximate, and I have identified the welcome, login, and sign-up screens as my initial code contribution while acknowledging AI-assisted revisions to them.
