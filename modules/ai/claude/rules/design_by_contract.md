# Design by Contract Rules

Prefer strongly-typed solutions with input validation at boundaries.

When types alone cannot express a contract, use Design by Contract principles to write software components with:

- Preconditions
- Postconditions
- Invariants

Fail hard with descriptive errors when violating contracts.

Avoid executing side effects in contracts, as contracts are often removed when compiling release
builds.
