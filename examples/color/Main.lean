import Terminal

open Terminal

def main : IO Unit := do
  queue #[
    Terminal.SetBackgroundColor.mk Color.red
  ]
  IO.println "Hello, world"
