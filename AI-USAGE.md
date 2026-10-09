# AI Usage

I used Claude and OpenAI Codex while building the nums Flutter app between September 20 and October 4, 2026. I estimate that AI assisted with about 80% of the implementation, while my contribution was about 20%, mainly through product decisions, visual design, layout, motion, and review. These percentages are my estimate, not a measurement of lines of code.

I did not keep a dated log of every prompt or make a separate commit for each screen. The entries below are a retrospective account of the work. Where the exact assistant or day for an individual change was not recorded, I say so rather than guessing. The project was committed in larger batches, so a linked commit may contain several related changes.

## 1. How I used AI

### Customer and staff app flows

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. The exact tool and day for each individual change were not recorded.
- **What I asked:** Help make the existing Flutter screens and functions work as a connected demo, including sign-in, username display, cart, checkout, order history, notifications, and staff workflows.
- **What it gave me:** Suggestions and Dart implementation help across the app screens, providers, and shared widgets.
- **What I kept or changed, and why:** I kept the local in-memory approach because this is a course demo. I reviewed the flows and requested changes when behavior did not match the customer or staff experience I wanted.
- **Commit:** [Initial project implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c)

### Login and verification

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. I did not record which assistant handled each login change.
- **What I asked:** Help with the login and verification flow, including form behavior, validation, and showing the signed-in user's information in the app.
- **What it gave me:** Flutter code and suggestions for form state, navigation, and user-facing feedback.
- **What I kept or changed, and why:** I used the suggestions as a starting point and directed the screen layout and motion. I kept authentication local to the demo rather than presenting it as production security.
- **Commit:** [Login and app flow updates](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f)

### Cart, payment, and confirmation

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Exact per-change attribution was not logged.
- **What I asked:** Help connect cart contents to checkout and make the user review the payment before the order is confirmed.
- **What it gave me:** Suggestions and Dart changes for order totals, checkout review, demo payment, and confirmation.
- **What I kept or changed, and why:** I kept payment as a local simulation and directed the flow so a successful demo payment comes before order confirmation. No real payment provider is connected.
- **Commit:** [Checkout-related updates](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f)

### Order history and progress

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. The exact assistant for this screen work was not recorded.
- **What I asked:** Help display customer orders with their status and make the history and in-progress views understandable.
- **What it gave me:** Suggestions and Flutter changes to show order information and progress through the customer screens.
- **What I kept or changed, and why:** I kept the local demo order state and asked for clearer status and layout behavior so customers can follow an order from placement through delivery.
- **Commit:** [Order history updates](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f)

### Staff dashboard, inventory, and batch management

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Exact assistant and date per screen were not recorded.
- **What I asked:** Help make the existing staff screens respond to order, stock, and batch actions in the demo.
- **What it gave me:** Suggestions and Dart implementation help for screen navigation and local state updates.
- **What I kept or changed, and why:** I kept these workflows local and focused on the staff actions needed for the class demo. I did not add a database or production staff authentication.
- **Commit:** [Initial project implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c)

### Visual design and shared Flutter components

- **Date / tool:** September 20–October 4, 2026; Claude and OpenAI Codex. Individual design iterations were not logged by date or assistant.
- **What I asked:** Help refine spacing, typography, button and card depth, layout, and motion while keeping the established color palette and mobile preview.
- **What it gave me:** Flutter styling and layout suggestions for screens, theme files, and reusable widgets.
- **What I kept or changed, and why:** I set the visual direction and reviewed the results. I kept the palette, directed the layout and motion, and asked for adjustments when spacing, sizing, or alignment felt inconsistent.
- **Commit:** [Initial project implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c)

## 2. Where the AI got it wrong

### Payment status did not match the intended checkout flow

- **What it gave me:** An earlier checkout flow could leave the order labeled “Payment: Pending.”
- **What was wrong:** I wanted the customer to complete the demo payment before order confirmation, so a pending status did not match the required flow.
- **What I did instead:** I directed the checkout to run the local payment simulation first and show a paid demo status only after it succeeds.
- **Commit:** [Checkout-related updates](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f)

### Some layout suggestions did not use the available space well

- **What it gave me:** Early layout results had inconsistent spacing and sizing, and some content did not align well within the mobile layout.
- **What was wrong:** The screens felt uneven and some content was crowded or clipped.
- **What I did instead:** I reviewed the screens and gave specific direction about centering, spacing, component size, and keeping the established palette and mobile preview.
- **Commit:** [UI and screen updates](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f)

### The order experience did not clearly communicate progress

- **What it gave me:** An earlier order view did not present the order status and surrounding layout as clearly as I wanted.
- **What was wrong:** The screen felt incomplete and made it harder to understand an order's progress.
- **What I did instead:** I requested a clearer order-history and progress presentation and reviewed the screen layout and status labels.
- **Commit:** [Order history updates](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f)

## 3. Who wrote what

### My contribution

I personally wrote the initial welcome, login, and sign-up screens, and made the app's visual design and layout decisions. AI later helped me revise and connect parts of the app, including these screens, so the final versions are AI-assisted rather than untouched original work.

- **Files:** `lib/screens/auth/welcome_screen.dart`, `lib/screens/auth/login_screen.dart`, and `lib/screens/auth/signup_screen.dart`.
- **Commit:** [Initial project implementation](https://github.com/JethroMarkBejec/nums/commit/cfdfc2c8db1cc4e62db60ca9a63d810b4f9c545c)
- **My explanation:** The welcome screen introduces the app and guides the user into the account flow. The login screen collects and validates sign-in details. The sign-up screen collects the information needed to create a demo account. I designed their layouts and visual direction to make the entry flow feel consistent with the rest of the app.

My personal design contribution also included decisions about spacing, typography, motion, visual hierarchy, and the existing color palette. I reviewed the AI-assisted revisions and requested changes when the layout or behavior did not match the design I intended.

### AI-assisted code I understand best

- **Files:** `lib/providers/order_provider.dart`, `lib/screens/customer/ordering/payment_screen.dart`, and `lib/screens/customer/ordering/confirmation_screen.dart`.
- **Commit:** [Checkout-related updates](https://github.com/JethroMarkBejec/nums/commit/3390f28f7dfeb3a07d06af389b6b10f07fef5a7f)
- **Explanation:** The payment screen reviews the order and runs a local demo payment flow. On success, the app creates the order and opens its confirmation. The provider keeps orders in memory and supports displaying and advancing their statuses. Because this is a demo, the state resets when the app restarts and no real payment is processed.

## Limits of this record

This is a retrospective summary. I used Claude and Codex during the stated period, but I did not preserve a prompt diary or separate commits for each feature. The commit links point to bundled project commits, so they show the project changes without proving which assistant produced each line. My 80/20 contribution estimate is approximate. The welcome, login, and sign-up files listed above are the parts I identify as my original work; AI later helped revise and connect them.