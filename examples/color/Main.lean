import Terminal

open Terminal
open Color (green red reset)

def main : IO Unit :=
  IO.println s!"{red}He{reset}llo, {green}world!"
