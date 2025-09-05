# TypeScript

- Prefer `yarn` over `npm`.

- Avoid `let` whenever possible. Prefer `const`. Never use `var`.

- Prefer FP-oriented functions like `map`, `filter`, and `reduce` over loops.

- When common utility functions aren't available in the JS standard library,
  consider using `lodash/fp`. For example, `import _ from 'lodash/fp'` and then
  use `_.range(1, 10)` instead of writing your own range function.

- Avoid using the `any` type. Prefer more specific types or generics.
