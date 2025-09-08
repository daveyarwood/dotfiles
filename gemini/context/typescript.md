# TypeScript

- Prefer `yarn` over `npm`.

- Avoid `let` whenever possible. Prefer `const`. Never use `var`.

- Prefer FP-oriented functions like `map`, `filter`, and `reduce` over loops.

- When common utility functions aren't available in the JS standard library,
  consider using `lodash/fp`. For example, `import _ from 'lodash/fp'` and then
  use `_.range(1, 10)` instead of writing your own range function.

- Avoid using the `any` type. Prefer more specific types or generics.

- Always use arrow functions. See code below for examples:

```typescript
// Good
export const foo = (x: number): number => x * 2

// Bad
export function foo(x: number): number {
  return x * 2
}

// Good
export const createUser = (
  name: string,
  age: number
): { name: string; age: number } => ({ name, age })

// Bad
export function createUser(
  name: string,
  age: number
): { name: string; age: number } {
  return { name, age }
}

// Good
export const getGreeting = (name: string): string =>
  name ? `Hello, ${name}!` : "Hello, guest!"

// Bad
export function getGreeting(name: string): string {
  if (name) {
    return `Hello, ${name}!`
  } else {
    return "Hello, guest!"
  }
}
```
