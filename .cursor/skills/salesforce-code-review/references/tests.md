# Test review

## Isolation

- `SeeAllData=true` is a finding unless there is no other way (and then it must be narrowly scoped).
- Tests must create their own data. Do not depend on org seed records or hardcoded IDs.
- `@TestSetup` for shared records. Helper classes for personas (admin vs standard vs guest).

## Assertions and bulk

- Every test method needs meaningful asserts (`Assert.areEqual`, `Assert.isTrue`, `Assert.isNotNull`). `insert` + no assert is a finding.
- Prefer the `Assert` class over legacy `System.assert*` in new tests.
- Trigger/handler tests must include a bulk case (200 records or a realistic batch), not only a single record.
- Cover both positive and permission-negative paths for user-facing Apex (`System.runAs`).
- When testing sharing or CRUD failures, assert the expected exception type or safe user-facing error — not only that "something failed".

## Coverage quality

- 75% is the deploy floor, not the review bar. New handlers, services, and controllers should cover error paths, empty collections, and bulk.
- `Test.startTest()` / `Test.stopTest()` around async, callouts, and governor-sensitive work.
- HTTP callouts: `HttpCalloutMock`. Do not skip callouts with `Test.isRunningTest()` in production code if a mock is possible.
- Queueable / Batch / Schedulable tests should execute the async work inside `startTest`/`stopTest` and assert side effects.

## What not to require

- Do not fail a review only because coverage is 76% if the new logic is asserted and bulk-tested.
- Do not demand tests for empty auto-generated `.cls-meta.xml` or layout XML.
