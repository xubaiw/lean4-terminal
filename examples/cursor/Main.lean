import Terminal

open Terminal

def main : IO Unit := do
  IO.print s!"Hello,{Cursor.goto 10 10}"
  IO.println "World!"
