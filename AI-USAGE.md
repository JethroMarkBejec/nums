# AI Usage in Flutter/Dart Code

During the initial NUMS implementation from September 20 to October 4, 2026, I used Claude and OpenAI Codex. My retrospective estimate is that AI helped with about 80% of that initial implementation. I contributed about 20%, including writing the initial welcome, login, and sign-up screens and making the app's visual design and layout decisions. This is an estimate, not a line-by-line measurement. I continued using OpenAI Codex for code revisions that landed on October 5 and 9, and for Flutter/Dart compatibility and analyzer cleanup on October 11. Those later revisions are listed separately and are not included in the original 80/20 estimate.

I did not keep a dated prompt log or separate commits for each screen. These entries describe the Flutter/Dart work from memory; the linked commits contain grouped changes. The dates below distinguish my recorded initial-use window from later code commit dates; a commit date shows when code landed, not necessarily the exact day I prompted an assistant. I have not assigned an exact assistant to an individual change where I did not record it.

## 1. How I used AI

### Authentication screens and validation

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. Exact prompt date and tool per change were not recorded. Related code landed October 4, with an authentication revision on October 5.
- **What I asked:** Help connect the Flutter sign-in and account flow, including verification, field validation, and showing the signed-in user's details.
- **What it gave me:** Dart suggestions for field validation, local account state, sign-in feedback, and routing a signed-in customer or staff account to the right app area.
- **What I kept or changed, and why:** I wrote the initial welcome, login, and sign-up screens and set their visual direction. I kept the local demo account behavior, reviewed the later validation and route changes, and asked for corrections when the account flow did not match the intended customer/staff experience.
- **Flutter/Dart files:** `lib/screens/auth/welcome_screen.dart`, `lib/screens/auth/login_screen.dart`, `lib/screens/auth/signup_screen.dart`, `lib/screens/auth/verification_screen.dart`, `lib/providers/auth_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [auth and customer-flow revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f), [later auth and route revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c).

### Cookie selection, customization, and cart

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. A later Codex-assisted interface revision landed October 9; exact prompt date was not recorded.
- **What I asked:** Help connect menu choices, cookie box customization, quantities, and cart contents in the local demo.
- **What it gave me:** Dart changes for a local cart state that adds and removes products, tracks quantities, and supplies the selected items and total to checkout; suggestions for flavor customization and the box builder.
- **What I kept or changed, and why:** I kept cart and customization data local for this no-backend demo. I directed the box layout and flavor presentation so customers can see what they selected before checkout.
- **Flutter/Dart files:** `lib/screens/customer/menu_screen.dart`, `lib/screens/customer/ordering/build_box_screen.dart`, `lib/screens/customer/ordering/customization_screen.dart`, `lib/screens/customer/ordering/solo_order_screen.dart`, `lib/screens/customer/cart_screen.dart`, `lib/providers/cart_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [cookie box and ordering UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Checkout, demo payment, and confirmation

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. The pay-before-confirmation behavior was added in a Codex-assisted revision dated October 5, followed by checkout UI refinements on October 9. Exact prompt dates were not recorded.
- **What I asked:** Help make checkout reflect the cart, show the total and payment choice, and require payment before confirming an order.
- **What it gave me:** A checkout flow that reviews the total and payment method, checks order conditions, requests customer confirmation, and uses a `PaymentRepository` with a local demo adapter before creating or marking an order paid.
- **What I kept or changed, and why:** I kept payment as a local demo simulation with no real charge. After noticing that the first flow placed orders while showing payment as pending, I requested payment before confirmation and kept a separate staff-review path for allergy exclusions.
- **Flutter/Dart files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`, `lib/services/payment_service.dart`, `lib/repositories/payment_repository.dart`.
- **Commit:** [Initial checkout and confirmation](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f), [pay-before-confirmation and payment repository](https://github.com/JethroMarkBejec/nums/commit/cbd3aefe01ad9f6faf1da78af4760767e9a97a7f), [later payment screen refinements](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Customer order history and notifications

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. Order and assistant-flow revisions landed October 5 and 9; exact prompt date and tool per revision were not recorded.
- **What I asked:** Help show order status and progress clearly, keep in-progress and delivered orders understandable, and surface order updates in the app.
- **What it gave me:** Flutter/Dart changes that show the current order status and history from local order state, plus notifications tied to customer and order IDs. The order flow has named preparation, baking, packing, and handoff stages.
- **What I kept or changed, and why:** I kept the in-memory demo status flow and reviewed the labels and layout so customers can understand progress without implying that a remote delivery service is connected.
- **Flutter/Dart files:** `lib/screens/customer/orders_screen.dart`, `lib/screens/customer/history_screen.dart`, `lib/screens/customer/notifications_screen.dart`, `lib/providers/order_provider.dart`, `lib/providers/notification_provider.dart`.
- **Commit:** [Order progress and customer-flow revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f), [order management revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c).

### Staff order, inventory, and baking screens

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. Staff workflow revisions landed October 5; exact prompt date and tool per change were not recorded.
- **What I asked:** Help make staff screens support the demo tasks of reviewing orders, updating their progress, adjusting stock, and tracking baking batches.
- **What it gave me:** Staff screens and local state changes for reviewing orders, advancing eligible paid orders, adjusting inventory, and tracking the baking stages with a live bake tracker.
- **What I kept or changed, and why:** I kept the workflows local and demonstrable without a backend. I kept order-stage controls separate from stock and batch controls so each staff task has a clear place.
- **Flutter/Dart files:** `lib/screens/admin/admin_dashboard_screen.dart`, `lib/screens/admin/orders_management_screen.dart`, `lib/screens/admin/order_details_screen.dart`, `lib/screens/admin/inventory_screen.dart`, `lib/screens/admin/batch_management_screen.dart`, `lib/providers/inventory_provider.dart`, `lib/providers/batch_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [staff order progress revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c).

### Shared Flutter styling, spacing, and motion

- **Date / tool:** I set the visual direction during the September 20–October 4 initial work with Claude and OpenAI Codex. Codex-assisted Flutter UI revisions landed October 9. I did not record prompt dates or attribute each design iteration to a specific assistant.
- **What I asked:** Help refine Dart layouts, spacing, type sizes, card and button depth, and motion while keeping the app's existing palette and device preview.
- **What it gave me:** Revisions to shared Flutter theme and reusable button/card widgets, including elevation, shadow, hover/press feedback, and layout adjustments across screens.
- **What I kept or changed, and why:** I made the visual design and layout decisions, reviewed the results, and asked for changes when elements felt crowded, misaligned, too large, or too flat. I kept the existing palette and mobile preview so the added depth stayed consistent with NUMS.
- **Flutter/Dart files:** `lib/theme/app_theme.dart`, `lib/theme/app_text_styles.dart`, `lib/widgets/app_button.dart`, `lib/widgets/app_card.dart`, `lib/widgets/app_screen_scaffold.dart`, `lib/screens/customer/customer_shell.dart`, `lib/screens/customer/profile_preferences_card.dart`.
- **Commit:** [Shared Flutter UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Local Chip assistant and guided navigation

- **Date / tool:** Initial assistant screen, September 20–October 4, 2026; Claude and OpenAI Codex. The local service and guided navigation were revised in commits dated October 5 and 9; exact prompt dates and per-change tool attribution were not recorded.
- **What I asked:** Help add a local in-app assistant to guide customers through ordering and navigating the app, including accessible guided actions.
- **What it gave me:** Flutter UI and local intent/response suggestions for Chip, with guided actions connected to named app routes and local ordering help.
- **What I kept or changed, and why:** I kept Chip as an in-app demo assistant, intended to reduce the need to find controls manually. I reviewed its navigation behavior and requested fixes when an action did not open the intended destination.
- **Flutter/Dart files:** `lib/screens/customer/ordering/assistant_screen.dart`, `lib/services/assistant_service.dart`, `lib/services/chat_repository.dart`, `lib/routes/app_routes.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [assistant service and guided-navigation revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c), [assistant and customer-shell revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Flutter compatibility and analyzer cleanup

- **Date / tool:** October 11, 2026; OpenAI Codex.
- **What I asked:** Review the Flutter/Dart project for current SDK compatibility and dependency versions, while keeping the mobile device preview available.
- **What it gave me:** A dependency review, an updated compatible package lock, and analyzer suggestions for current Flutter APIs and Dart style.
- **What I kept or changed, and why:** I updated `image_picker` and `flutter_lints` within compatible versions and refreshed compatible transitive packages. I kept `device_preview` on 1.x because 3.x removes the app's embedded preview toolbar and moves controls into DevTools. I removed the deprecated `useInheritedMediaQuery` option and applied the safe analyzer fixes.
- **Flutter/Dart files:** `pubspec.yaml`, `pubspec.lock`, and `lib/**/*.dart`. I formatted the Dart source tree and fixed analyzer findings in the app setup, providers, routes, customer/staff screens, theme, and shared widgets.
- **Commit:** [Flutter compatibility and analyzer cleanup](https://github.com/JethroMarkBejec/nums/commit/20619a3f789cf385487228e4a59d7d696bb2c1f3).

## 2. Where the AI got it wrong

These are three problems I observed while reviewing AI-assisted Flutter code. A linked commit date shows when the related code landed, not necessarily when the incorrect suggestion was generated. Where the original assistant or prompt date was not recorded, I say so rather than guessing.

### Checkout could show payment as pending

- **What the AI-assisted flow did:** A confirmed order could still display “Payment: Pending,” even though the intended flow was payment first, then confirmation.
- **Date / tools:** The initial pending-payment flow landed October 4; the pay-before-confirmation correction landed October 5 with OpenAI Codex. I did not record which assistant first proposed the pending flow or the exact date I noticed the mismatch.
- **What was wrong:** That status contradicted the intended order flow.
- **What I did instead:** I asked for the local payment step to complete first and for the confirmed demo order to be labeled paid only after the simulation succeeds.
- **Flutter/Dart files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`.
- **Commit:** [Initial pending-payment checkout](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [pay-before-confirmation correction](https://github.com/JethroMarkBejec/nums/commit/cbd3aefe01ad9f6faf1da78af4760767e9a97a7f).

### Some screen layouts clipped or used space awkwardly

- **What the AI-assisted layouts did:** Some narrow mobile layouts showed overflow indicators or clipped content, alongside inconsistent spacing and alignment.
- **Date / tools:** The specific spacing and responsive-layout revisions landed October 9, 2026, with OpenAI Codex. Individual prompt dates were not recorded.
- **What was wrong:** The affected screens were harder to read and the layout did not feel consistent on the mobile preview.
- **What I did instead:** I reviewed the screens and requested specific adjustments to padding, alignment, and component sizing while preserving the existing palette and preview.
- **Flutter/Dart files:** `lib/screens/customer/ordering/build_box_screen.dart`, `lib/screens/customer/profile_preferences_card.dart`, `lib/theme/app_theme.dart`, `lib/widgets/app_button.dart`, `lib/widgets/app_card.dart`.
- **Commit:** [Shared Flutter UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Assistant navigation did not open the selected destination correctly

- **What the AI-assisted flow did:** Selecting Home from Chip produced a Flutter runtime error (`type 'Null' is not a subtype of type 'int'`) instead of showing the destination.
- **Date / tools:** The assistant service and navigation revisions landed October 5 and 9, 2026, with OpenAI Codex. I did not record the exact prompt date for this error.
- **What was wrong:** The assistant is meant to reduce navigation effort, so a broken destination defeated its purpose.
- **What I did instead:** I reported the failure and requested that its Flutter navigation and destination handling be corrected.
- **Flutter/Dart files:** `lib/screens/customer/ordering/assistant_screen.dart`, `lib/routes/app_routes.dart`, `lib/screens/customer/customer_shell.dart`.
- **Commit:** [Assistant service and guided-navigation revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c), [assistant and customer-shell revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

## 3. Who wrote what

### My Flutter/Dart contribution

I wrote the initial welcome, login, and sign-up screens. I also made the visual design and layout decisions, including spacing, type sizing, hierarchy, color palette, motion, and depth. AI later helped revise behavior and connect parts of the app, so the current versions are AI-assisted revisions of my initial work.

- **`lib/screens/auth/welcome_screen.dart`:** I placed the NUMS logo and short bakery introduction above two actions. The Log in and Create Account buttons route to their respective forms, so a new customer can tell where to start.
- **`lib/screens/auth/login_screen.dart`:** I arranged email and password fields in one validated form with a single submit action. The screen calls the local sign-in flow and gives feedback when the fields or credentials are rejected.
- **`lib/screens/auth/signup_screen.dart`:** I organized name, email, and password entry as one form. It checks the fields, reports duplicate email, and then takes a created demo account into the customer app.
- **Why I built them this way:** Keeping welcome, login, and sign-up separate gives each screen one clear job. I made the layout and visual decisions so the first step stays obvious and consistent with the bakery theme.
- **Commit for these initial screens:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c). The later changes to their behavior are AI-assisted revisions, as noted above.

### AI-assisted Flutter/Dart code I understand best

- **Files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`, `lib/services/payment_service.dart`.
- **Commit:** [Pay-before-confirmation and payment repository](https://github.com/JethroMarkBejec/nums/commit/cbd3aefe01ad9f6faf1da78af4760767e9a97a7f), [checkout and confirmation revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f).
- **My explanation:** The payment screen reads the cart or a reviewed order, validates the selected payment preference, checks daily batch capacity, and asks the customer to confirm the amount. Allergy-exclusion orders are sent to staff review before payment. For a normal checkout, it reserves capacity and calls `PaymentRepository`; the local adapter simulates success without charging money. Only after success does the screen create or mark the order paid, add a notification, clear a new cart, and navigate to confirmation. `OrderProvider` keeps the order and its status in memory and refuses to advance an unpaid order. I understand this because the steps keep the displayed confirmation and payment state aligned, while the local repository is a replaceable seam for a future real provider.

## Limits of this record

This file describes Flutter/Dart code only. It is a retrospective account, not a prompt diary or a line-by-line authorship report. The historical commit links identify grouped code changes and do not establish which assistant wrote each line. My 80/20 estimate applies to the original implementation, is approximate, and identifies the welcome, login, and sign-up screens as my initial code contribution while acknowledging AI-assisted revisions to them.
