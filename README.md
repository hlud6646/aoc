# Aoc

Things I've learned:

- Elixir has an `:infinity` constant available, but it doesn't play nicely with arithmetic.
For example you can't do `:infinity + 1`.
- You can declare module level constants with `@infinity = 999_999_999`.
- Printing lists of numbers is weird. Use `IO.inspect(stuff, charlists: false)`
