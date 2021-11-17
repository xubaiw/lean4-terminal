import Terminal

open Terminal
open Color (background blue green red reset yellow')

def main : IO Unit :=
  IO.println s!"{red}He{reset}llo, {blue}{green background}wor{yellow'}ld!"
