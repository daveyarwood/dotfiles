# Global code conventions

The coding style and philosophy that applies in every repo, on the laptop in
OpenCode and on Hermes alike. A repo's own `AGENTS.md` holds what is specific
to it and wins where the two disagree. A convention that holds everywhere
belongs here, not there, so no repo has to restate it.

## Language and shape

- TypeScript, never plain JavaScript.
- No `any`. Write the type, or make it generic.
- Never the `function` keyword. A declaration is a `const` bound arrow, and a
  body that is a single return collapses to an expression body.
- `const` by default, `let` only when the binding changes, and never `var`.
- Functional style: small, composable, pure functions. `map`, `filter` and
  `reduce` rather than a loop carrying a mutable accumulator.
- Reach for a library before writing the utility yourself: `date-fns` for
  dates, `@octokit/rest` for GitHub, `lodash` for what the standard library
  lacks.
- `yarn`, not `npm`.
- Small modules with one responsibility each, organized by domain. No `util`
  file, and no dead code left behind.

## Tests

- Unit tests are for pure functions with deterministic output.
- No mocks, no stubs, and no assertion about the arguments a call received. A
  test of a fake is worse than no test, and it has to be rewritten whenever
  the implementation moves.
- Anything touching the network, a binary, the filesystem or another process
  is proved by a real run, and the output of that run goes in the pull
  request.
