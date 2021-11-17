# lean4-terminal

WIP

Inspiration is taken from Rust's `termion`.

## Example

```lean
import Terminal

open Terminal

def main : IO Unit := do
  IO.println s!"{Color.fg Color.red}23{Style.underline}33"
```