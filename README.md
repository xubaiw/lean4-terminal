# lean4-terminal

WIP

Inspiration is taken from Rust's `termion`.

## Example

```lean
import Terminal

open Terminal
open Color (green red reset)

def main : IO Unit :=
  IO.println s!"{red}He{reset}llo, {green}world!"

```