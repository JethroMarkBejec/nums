# AI Usage in Flutter/Dart Code

During the initial NUMS implementation from September 20 to October 4, 2026, I used Claude and OpenAI Codex. My retrospective estimate is that AI contributed about 80% and I contributed about 20% of the initial work. My contribution included writing the welcome, login, and sign-up screens, writing or editing screen UI across nearly all other screens, and making the visual design and layout decisions. Chip's assistant/animation screen is the main exception and was AI-assisted. The percentage is my estimate, not a measured line count. I continued revising the app after October 4, with both hands-on work and AI assistance; those later revisions are described separately. On October 11, I also used OpenAI Codex for Flutter/Dart compatibility and analyzer cleanup.

I did not keep a dated prompt log or save the original assistant responses. The request and response descriptions below are summaries from memory, not quotations. I committed the initial project together in one first commit instead of committing each screen or AI interaction separately; later commits also group related changes. The project commits are under my GitHub account and show when grouped changes landed, but they cannot identify who typed each line or which specific assistant produced it. Where I did not record the exact tool or prompt date, I say so rather than guessing.

## 1. How I used AI

### Authentication screens and validation

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. Exact prompt date and tool per change were not recorded. Related code landed October 4, with an authentication revision on October 5 that includes my review and hands-on direction as well as AI assistance.
- **What I asked:** Help connect the Flutter sign-in and account flow, including verification, field validation, and showing the signed-in user's details.
- **What it gave me:** Dart suggestions for field validation, local account state, sign-in feedback, and routing a signed-in customer or staff account to the right app area.
- **What I kept or changed, and why:** I wrote the initial welcome, login, and sign-up screens and set their visual direction. I kept the local demo account behavior, reviewed the later validation and route changes, and asked for corrections when the account flow did not match the intended customer/staff experience.
- **Flutter/Dart files:** `lib/screens/auth/welcome_screen.dart`, `lib/screens/auth/login_screen.dart`, `lib/screens/auth/signup_screen.dart`, `lib/screens/auth/verification_screen.dart`, `lib/providers/auth_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [auth and customer-flow revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f), [later auth and route revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c).

### Cookie selection, customization, and cart

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. Further ordering UI changes landed October 9; those grouped changes include my feedback and hands-on decisions as well as AI assistance. Exact prompt dates were not recorded.
- **What I asked:** Help connect menu choices, cookie box customization, quantities, and cart contents in the local demo.
- **What it gave me:** Dart changes for a local cart state that adds and removes products, tracks quantities, and supplies the selected items and total to checkout; suggestions for flavor customization and the box builder.
- **What I kept or changed, and why:** I kept cart and customization data local for this no-backend demo. I directed the box layout and flavor presentation so customers can see what they selected before checkout.
- **Flutter/Dart files:** `lib/screens/customer/menu_screen.dart`, `lib/screens/customer/ordering/build_box_screen.dart`, `lib/screens/customer/ordering/customization_screen.dart`, `lib/screens/customer/ordering/solo_order_screen.dart`, `lib/screens/customer/cart_screen.dart`, `lib/providers/cart_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [cookie box and ordering UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Checkout, demo payment, and confirmation

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. The payment behavior was revised in a grouped commit dated October 5, followed by checkout UI refinements on October 9. I contributed the requirement and review; I did not record the exact prompt dates or which lines I edited manually versus with AI.
- **What I asked:** Help make checkout reflect the cart, show the total and payment choice, and require payment before confirming an order.
- **What it gave me:** A checkout flow that reviews the total and payment method, checks order conditions, requests customer confirmation, and uses a `PaymentRepository` with a local demo adapter before creating or marking an order paid.
- **What I kept or changed, and why:** I kept payment as a local demo simulation with no real charge. After noticing that the first flow placed orders while showing payment as pending, I requested payment before confirmation and kept a separate staff-review path for allergy exclusions.
- **Flutter/Dart files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`, `lib/services/payment_service.dart`, `lib/repositories/payment_repository.dart`.
- **Commit:** [Initial checkout and confirmation](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f), [pay-before-confirmation and payment repository](https://github.com/JethroMarkBejec/nums/commit/cbd3aefe01ad9f6faf1da78af4760767e9a97a7f), [later payment screen refinements](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Customer order history and notifications

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. Order and assistant-flow revisions landed October 5 and 9. Those revisions include my review and feature decisions alongside AI assistance; exact prompt dates and per-change tool attribution were not recorded.
- **What I asked:** Help show order status and progress clearly, keep in-progress and delivered orders understandable, and surface order updates in the app.
- **What it gave me:** Flutter/Dart changes that show the current order status and history from local order state, plus notifications tied to customer and order IDs. The order flow has named preparation, baking, packing, and handoff stages.
- **What I kept or changed, and why:** I kept the in-memory demo status flow and reviewed the labels and layout so customers can understand progress without implying that a remote delivery service is connected.
- **Flutter/Dart files:** `lib/screens/customer/orders_screen.dart`, `lib/screens/customer/history_screen.dart`, `lib/screens/customer/notifications_screen.dart`, `lib/providers/order_provider.dart`, `lib/providers/notification_provider.dart`.
- **Commit:** [Order progress and customer-flow revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f), [order management revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c).

### Staff order, inventory, and baking screens

- **Date / tool:** Initial work, September 20–October 4, 2026; Claude and OpenAI Codex. Staff workflow revisions landed October 5 and include my review of the intended staff flow. Exact prompt date and tool per individual change were not recorded.
- **What I asked:** Help make staff screens support the demo tasks of reviewing orders, updating their progress, adjusting stock, and tracking baking batches.
- **What it gave me:** Suggestions and code for the local state and workflow behavior behind reviewing orders, advancing eligible paid orders, adjusting inventory, and tracking baking stages. I wrote or edited the screen UI that presents these staff tasks.
- **What I kept or changed, and why:** I kept the workflows local and demonstrable without a backend. I kept order-stage controls separate from stock and batch controls so each staff task has a clear place.
- **Flutter/Dart files:** `lib/screens/admin/admin_dashboard_screen.dart`, `lib/screens/admin/orders_management_screen.dart`, `lib/screens/admin/order_details_screen.dart`, `lib/screens/admin/inventory_screen.dart`, `lib/screens/admin/batch_management_screen.dart`, `lib/providers/inventory_provider.dart`, `lib/providers/batch_provider.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [staff order progress revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c).

### Shared Flutter styling, spacing, and motion

- **Date / tool:** I set the visual direction during the September 20–October 4 initial work with Claude and OpenAI Codex. Further Flutter UI changes landed October 9; I supplied layout feedback and made design decisions while AI also assisted with Dart edits. I did not record prompt dates or attribute each line to a specific author.
- **What I asked:** Help refine Flutter layout spacing and text hierarchy, and polish card and button depth, pointer/tap feedback, and motion while keeping the existing palette and mobile preview.
- **What it gave me:** Suggested Dart changes to the shared theme and reusable button/card widgets, including elevation, shadows, interaction feedback, and layout adjustments. For example, `app_button.dart` controls the look and response of primary actions, while `app_card.dart` gives related content consistent visual separation.
- **What I kept or changed, and why:** I set the visual direction and reviewed the results. I asked for revisions when content looked crowded, misaligned, oversized, or too flat. I judged shadows by whether they added hierarchy without making cards feel heavy, and motion by whether it supported the interaction rather than distracting from ordering. I kept the established palette and mobile preview. The entrance animation in the login screen is one example of motion used in the app.
- **Flutter/Dart files:** `lib/theme/app_theme.dart`, `lib/theme/app_text_styles.dart`, `lib/widgets/app_button.dart`, `lib/widgets/app_card.dart`, `lib/widgets/app_screen_scaffold.dart`, `lib/screens/customer/customer_shell.dart`, `lib/screens/customer/profile_preferences_card.dart`, `lib/screens/customer/ordering/build_box_screen.dart`, `lib/screens/auth/login_screen.dart`.
- **Commit:** [Shared Flutter UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Local Chip assistant and guided navigation

- **Date / tool:** Initial assistant screen, September 20–October 4, 2026; Claude and OpenAI Codex. The local service and guided navigation were revised in commits dated October 5 and 9; I reviewed the behavior and supplied correction requests, but exact prompt dates and per-change tool attribution were not recorded.
- **What I asked:** Help add a local in-app assistant to guide customers through ordering and navigating the app, including accessible guided actions.
- **What it gave me:** Flutter UI and local intent/response handling for Chip, with guided actions connected to app routes and local ordering help.
- **What needed correction:** Choosing Home from Chip produced `type 'Null' is not a subtype of type 'int'` instead of opening the intended destination. The assistant's response/action alone was not enough; route and destination handling also had to match the app's navigation structure.
- **What I kept or changed, and why:** I kept Chip as an in-app demo assistant intended to reduce the effort of finding controls. I reported the failed Home action and requested corrections. I checked the actual navigation behavior instead of assuming plausible assistant text meant the feature worked.
- **Flutter/Dart files:** `lib/screens/customer/ordering/assistant_screen.dart`, `lib/services/assistant_service.dart`, `lib/services/chat_repository.dart`, `lib/routes/app_routes.dart`.
- **Commit:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [assistant service and guided-navigation revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c), [assistant and customer-shell revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Loyalty points and keeping the feature focused

- **Date / tool:** October 5, 2026; OpenAI Codex. I later asked Codex to remove the standalone game on October 9 while keeping the useful ordering rewards.
- **What I asked:** Add a points system for activities such as feedback and trying a new flavor, with points tracked for each user and logic kept in one repository. I also explored a mini-game as a way to earn points.
- **What it gave me:** A `PointsRepository` that awards feedback and new-flavor points once per item, reads and updates the user's points balance, and checks a balance before redemption. Chip can tell the customer their balance and apply an eligible reward to the cart.
- **What I kept or changed, and why:** I decided the standalone game felt unrelated to a cookie-ordering app, so I removed that screen. I kept the points tied to relevant customer actions—feedback and flavors—and the reward/redemption flow.
- **Flutter/Dart files:** `lib/repositories/points_repository.dart`, `lib/models/user.dart`, `lib/providers/auth_provider.dart`, `lib/screens/customer/orders_screen.dart`, `lib/screens/customer/ordering/assistant_screen.dart`, `lib/screens/customer/play_screen.dart` (removed).
- **Commit:** [Initial game and points implementation](https://github.com/JethroMarkBejec/nums/commit/2242d77bb50ef46977e25f01c3bec43d7271ab1e), [remove standalone game and keep ordering rewards](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

### Flutter compatibility and analyzer cleanup

- **Date / tool:** October 11, 2026; OpenAI Codex.
- **What I asked:** Review the Flutter/Dart project for current SDK compatibility and dependency versions, while keeping the mobile device preview available.
- **What it gave me:** A dependency review, an updated compatible package lock, and analyzer suggestions for current Flutter APIs and Dart style.
- **What I kept or changed, and why:** I updated `image_picker` and `flutter_lints` within compatible versions and refreshed compatible transitive packages. I kept `device_preview` on 1.x because 3.x removes the app's embedded preview toolbar and moves controls into DevTools. I removed the deprecated `useInheritedMediaQuery` option and applied the safe analyzer fixes.
- **Flutter/Dart files:** `pubspec.yaml`, `pubspec.lock`, and `lib/**/*.dart`. I formatted the Dart source tree and fixed analyzer findings in the app setup, providers, routes, customer/staff screens, theme, and shared widgets.
- **Commit:** [Flutter compatibility and analyzer cleanup](https://github.com/JethroMarkBejec/nums/commit/20619a3f789cf385487228e4a59d7d696bb2c1f3).

## 2. Where the AI got it wrong

These are three problems I encountered while reviewing AI-assisted work during development. The descriptions are based on the behavior I observed and the code revisions that remain. Since I did not save the original prompts or assistant responses, I cannot attribute a specific faulty line to Claude or Codex. The linked commits show the relevant implementation and later changes; their dates are when the code landed, not necessarily when I noticed the issue.

### AI-assisted checkout allowed an order to remain unpaid

- **What the AI-assisted first pass did:** Its confirmation dialog said, “Place this order? Payment will show as pending until a payment provider is connected,” and the flow created the order before any payment step. I used AI assistance on this checkout flow; I later noticed that the behavior did not match the payment-first process I wanted.
- **Date / tools:** The initial pending-payment flow landed October 4; the pay-before-confirmation correction landed October 5 with OpenAI Codex. I did not record which assistant first proposed the pending flow or the exact date I noticed the mismatch.
- **What was wrong:** A customer could reach an order record without the demo payment succeeding. That made the order state conflict with the intended checkout sequence.
- **What I did instead:** I specified that the local payment simulation must succeed before a normal order is confirmed or marked paid. Allergy-exclusion orders remain a separate staff-review path before payment.
- **Flutter/Dart files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`.
- **Commit:** [Initial pending-payment checkout](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [pay-before-confirmation correction](https://github.com/JethroMarkBejec/nums/commit/cbd3aefe01ad9f6faf1da78af4760767e9a97a7f).

### AI-assisted UI polish needed correction to fit the design

- **What the AI-assisted first passes did:** Some layouts had cramped or clipped content, including a `BOTTOM OVERFLOWED BY 12 PIXELS` warning. Other UI details did not match my requirements: the linked-payment controls lacked spacing, the selected navigation item had a background I wanted removed, the allergy choices looked like boxed checkboxes, and the “In Stock” label was too large for its badge. The first visual-polish passes also did not give every screen a consistent sense of depth and interaction; shadows, hover/press feedback, and motion needed more careful tuning to feel lively without changing the palette or becoming too heavy.
- **Date / tools:** I reported these issues during follow-up UI work; related grouped Flutter UI revisions landed October 9, 2026, with OpenAI Codex. I did not keep exact dates for each request.
- **Why this needed correction:** Some items were usability or layout problems; others were mismatches with my design requirements rather than functional defects. The first AI-assisted result was not ready to keep without review because spacing, control sizing, selected states, and visual effects needed to work together across screens.
- **What I did instead:** I gave specific feedback about spacing, badge and text sizing, checkbox shape, selected-state treatment, and the amount of visual depth. I asked to preserve the existing palette and mobile preview, then reviewed the revised shared styles and screen layouts. Some of these were my design preferences becoming more specific; I treated the first result as a draft and requested changes until it matched those requirements.
- **Flutter/Dart files:** `lib/screens/customer/ordering/build_box_screen.dart`, `lib/screens/customer/profile_preferences_card.dart`, `lib/screens/customer/customer_shell.dart`, `lib/screens/customer/menu_screen.dart`, `lib/theme/app_theme.dart`, `lib/widgets/app_button.dart`, `lib/widgets/app_card.dart`.
- **Commit:** [Shared Flutter UI revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).
- **Attribution:** These visual changes were made through back-and-forth work. The grouped commits do not isolate which individual property or line came from AI versus my edits, so I describe the first-pass mismatches and my corrections without assigning every line to one author.

### AI-assisted Chip navigation crashed instead of opening Home

- **What the AI-assisted flow did:** The guided Home action from Chip produced a Flutter runtime error (`type 'Null' is not a subtype of type 'int'`) instead of opening the intended destination.
- **Date / tools:** The assistant service and navigation revisions landed October 5 and 9, 2026, with OpenAI Codex. I did not record the exact prompt date for this error.
- **What was wrong:** Chip is intended to help customers navigate the app. A runtime exception made its Home action unusable and interrupted the flow.
- **What I did instead:** I reported the failed action and requested corrections to the assistant action and route/destination handling. I treated the action as unfinished until it opened the intended screen rather than relying on the response text alone.
- **Flutter/Dart files:** `lib/screens/customer/ordering/assistant_screen.dart`, `lib/routes/app_routes.dart`, `lib/screens/customer/customer_shell.dart`.
- **Commit:** [Assistant service and guided-navigation revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c), [assistant and customer-shell revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b).

## 3. Who wrote what

### My Flutter/Dart contribution

I wrote the initial welcome, login, and sign-up screens. I also made the visual design and layout decisions, including spacing, type sizing, hierarchy, color palette, motion, and depth. I later made hands-on revisions and used AI to help with some behavior and connections, so the current versions contain both my work and AI-assisted revisions.

- **`lib/screens/auth/welcome_screen.dart`:** I built the entry layout with the logo and short bakery introduction above two actions. The `SafeArea` and scrollable, constrained column keep the content usable on shorter screens. The two buttons lead to login and sign-up.
- **`lib/screens/auth/login_screen.dart`:** I put email and password in a `Form` with a `GlobalKey<FormState>` and text controllers, then connected the submit action to the local `AuthProvider.signIn` flow. Validation and a message explain rejected input or credentials. The initial screen also used a short entrance animation.
- **`lib/screens/auth/signup_screen.dart`:** I organized name, email, and password entry in one form. Validators run before calling the local sign-up method; duplicate email gets a message, while success opens the customer area. I dispose the controllers with the screen so they do not remain allocated.
- **Why I built them this way:** Keeping welcome, login, and sign-up separate gives each screen one clear job. I made the layout and visual decisions so the first step stays obvious and consistent with the bakery theme.
- **Commit reference:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c). This is the initial project commit and includes many files, not a separate commit for these three screens.

### Other Flutter/Dart screen code I personally wrote or edited

Beyond the first three authentication screens above, I personally wrote or directly edited the screen UI in nearly all of the app's other screens. My work here was mainly the visible screen composition and interaction presentation—how each screen lays out its content and controls. Some behavior, state connections, and fixes were AI-assisted, so this is not a claim that I authored every line of functionality in these files. My stated exception is Chip's assistant/animation screen.

- **Customer screens:** `lib/screens/customer/customer_shell.dart`, `lib/screens/customer/home_screen.dart`, `lib/screens/customer/menu_screen.dart`, `lib/screens/customer/cart_screen.dart`, `lib/screens/customer/orders_screen.dart`, `lib/screens/customer/history_screen.dart`, `lib/screens/customer/notifications_screen.dart`, `lib/screens/customer/profile_screen.dart`, `lib/screens/customer/profile_preferences_card.dart`, `lib/screens/customer/flavor_ideas_screen.dart`, `lib/screens/customer/custom_request_screen.dart`.
- **Ordering screens:** `lib/screens/customer/ordering/build_box_screen.dart`, `lib/screens/customer/ordering/customization_screen.dart`, `lib/screens/customer/ordering/solo_order_screen.dart`, `lib/screens/customer/ordering/order_summary_screen.dart`, `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`.
- **Staff screens:** `lib/screens/admin/admin_dashboard_screen.dart`, `lib/screens/admin/admin_profile_screen.dart`, `lib/screens/admin/orders_management_screen.dart`, `lib/screens/admin/order_details_screen.dart`, `lib/screens/admin/requests_screen.dart`, `lib/screens/admin/inventory_screen.dart`, `lib/screens/admin/batch_management_screen.dart`.
- **Other screens:** `lib/screens/auth/loading_screen.dart`, `lib/screens/auth/verification_screen.dart`, `lib/screens/design_preview_screen.dart`.
- **How I approached them:** I built and adjusted the screen layouts to fit the customer and staff tasks, and made hands-on revisions to spacing, font sizes, card and button presentation, and mobile sizing. The customer screens cover browsing, building or customizing orders, checkout, notifications, and account preferences; the staff screens present order, request, inventory, and batch tasks. This describes my direct screen-level contribution; it does not claim that I wrote every provider, repository, or service those screens call.
- **Commit evidence:** [Initial Flutter app implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c), [customer and staff workflow revisions](https://github.com/JethroMarkBejec/nums/commit/7c1b4d5026db603b31c1c2d9a5e13f66580ad89c), [later screen, layout, and interaction revisions](https://github.com/JethroMarkBejec/nums/commit/f6542b2fde13c7a5182ab1b4fcdd9799e62b393b). These are grouped commits under my GitHub account, so they show where changes landed, not individual line authorship.

### Product and visual direction I owned

I reviewed screens and called out spacing, padding, margin, and sizing problems when content felt cramped or misplaced. I set the intended visual direction for motion, shadows, button depth, and consistent use of the existing palette. For concrete examples, I reviewed `lib/widgets/app_button.dart` and `lib/widgets/app_card.dart` so shared actions and cards followed that direction, and requested layout changes in the build-box and profile-preferences screens when content felt cramped. I also requested the points/reward idea, then decided the standalone game did not fit the ordering app and should be removed while relevant rewards stayed. These are my product and design decisions; my screen-code contribution is described separately above.

### AI-assisted Flutter/Dart code I understand best

- **Files:** `lib/screens/customer/ordering/payment_screen.dart`, `lib/screens/customer/ordering/confirmation_screen.dart`, `lib/providers/order_provider.dart`, `lib/services/payment_service.dart`.
- **Commit:** [Pay-before-confirmation and payment repository](https://github.com/JethroMarkBejec/nums/commit/cbd3aefe01ad9f6faf1da78af4760767e9a97a7f), [checkout and confirmation revisions](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f).
- **My explanation:** The payment screen reads the cart or a reviewed order, validates the selected payment preference, checks daily batch capacity, and asks the customer to confirm the amount. Allergy-exclusion orders are sent to staff review before payment. For a normal checkout, it reserves capacity and calls `PaymentRepository`; the local adapter simulates success without charging money. Only after success does the screen create or mark the order paid, add a notification, clear a new cart, and navigate to confirmation. `OrderProvider` keeps the order and its status in memory and refuses to advance an unpaid order. I understand this because the steps keep the displayed confirmation and payment state aligned, while the local repository is a replaceable seam for a future real provider.

## Limits of this record

This is a retrospective record of Flutter/Dart work, not a prompt diary or a line-by-line authorship report. The initial app was committed in one large commit, and later changes were grouped by feature. I did not preserve original prompts or assistant responses. Commit links support where related code landed, while my screen-level authorship descriptions are my account of the work; neither the commits nor the percentage estimate independently prove line-by-line authorship. The 80/20 estimate applies to the initial implementation only. AI also assisted with functionality and later revisions.
