def String.isInfixOf (p : String) (s : String) : Bool := do
  if s.length < p.length then false
  else do
    for i in [0:(s.length-p.length)] do
      if s.extract i (i+p.length) == p then
        return true
    return false

namespace Terminal

class Command (α : Type u) where
  writeAnsi : α → IO.FS.Stream → IO Unit

def csi (s : String) : String := "\x1B[" ++ s

/--
  A command that moves the terminal cursor to the given position (column, row).

  # Notes

  * Top left cell is represented as `0,0`.
  * Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveTo := (c r : UInt16)

instance : Command MoveTo where
  writeAnsi self f := f.putStr <| csi s!"{self.r + 1};{self.c + 1}H"

/--
  A command that moves the terminal cursor down the given number of lines, 
  and moves it to the first column.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveToNextLine := (n : UInt16)

instance : Command MoveToNextLine where
  writeAnsi self f := f.putStr <| csi s!"{self.n}E"

/--
  A command that moves the terminal cursor up the given number of lines,
  and moves it to the first column.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveToPreviousLine := (n : UInt16)

instance : Command MoveToPreviousLine where
  writeAnsi self f := f.putStr <| csi s!"{self.n}F"

/--
  A command that moves the terminal cursor to the given column on the current row.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveToColumn := (c : UInt16)

instance : Command MoveToColumn where
  writeAnsi self f := f.putStr <| csi s!"{self.c}G"

/--
  A command that moves the terminal cursor to the given row on the current column.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveToRow := (r : UInt16)

instance : Command MoveToRow where
  writeAnsi self f := f.putStr <| csi s!"{self.r}d"

/--
  A command that moves the terminal cursor a given number of rows up.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveUp := (n : UInt16)

instance : Command MoveUp where
  writeAnsi self f := f.putStr <| csi s!"{self.n}A"

/--
  A command that moves the terminal cursor a given number of columns to the right.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveRight := (n : UInt16)

instance : Command MoveRight where
  writeAnsi self f := f.putStr <| csi s!"{self.n}C"

/--
  A command that moves the terminal cursor a given number of rows down.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveDown := (n : UInt16)

instance : Command MoveDown where
  writeAnsi self f := f.putStr <| csi s!"{self.n}B"

/--
  A command that moves the terminal cursor a given number of columns to the left.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure MoveLeft := (n : UInt16)

instance : Command MoveLeft where
  writeAnsi self f := f.putStr <| csi s!"{self.n}D"

/--
  A command that saves the current terminal cursor position.

  See the `RestorePosition` command.

  # Notes

  - The cursor position is stored globally.
  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure SavePosition

instance : Command SavePosition where
  writeAnsi self f := f.putStr <| csi "s"

/--
  A command that saves the current terminal cursor position.

  See the `SavePosition` command.

  # Notes

  - The cursor position is stored globally.
  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure RestorePosition

instance : Command RestorePosition where
  writeAnsi self f := f.putStr <| csi "u"

/--
  A command that hides the terminal cursor.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure Hide

instance : Command Hide where
  writeAnsi self f := f.putStr <| csi "?25l"

/--
  A command that shows the terminal cursor.

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure Show

instance : Command Show where
  writeAnsi self f := f.putStr <| csi "?25h"

/--
  A command that enables blinking of the terminal cursor.

  # Notes

  - Windows versions lower than Windows 10 do not support this functionality.
  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure EnableBlinking

instance : Command EnableBlinking where
  writeAnsi self f := f.putStr <| csi "?12h"

/--
  A command that disables blinking of the terminal cursor.

  # Notes

  - Windows versions lower than Windows 10 do not support this functionality.
  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure DisableBlinking

instance : Command DisableBlinking where
  writeAnsi self f := f.putStr <| csi "?12l"

inductive CursorShape
  | underScore
  | line
  | block

/--
  A command that sets the shape of the cursor

  # Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure SetCursorShape := (s : CursorShape)

instance : Command SetCursorShape where
  writeAnsi self f := f.putStr <| csi <|
    match self.s with
    | CursorShape.underScore  => "3 q"
    | CursorShape.line        => "5 q"
    | CursorShape.block       => "2 q"

-- /--
--   Returns the cursor position (column, row).

--   The top left cell is represented `0,0`.
-- -/
-- def position : IO (UInt16 × UInt16) := sorry

inductive KeyCode where
  | /-- Backspace key. -/
    backspace
  | /-- Enter key. -/
    enter
  | /-- Left arrow key. -/
    left
  | /-- Right arrow key. -/
    right
  | /-- Up arrow key. -/
    up
  | /-- Down arrow key. -/
    down
  | /-- Home key. -/
    home
  | /-- End key. -/
    «end» 
  | /-- Page up key. -/
    pageUp
  | /-- Page dow key. -/
    pageDown
  | /-- Tab key.-/
    tab
  | /-- Shift + Tab key. -/
    backtab
  | /-- Delete key. -/
    delete
  | /-- Insert key. -/
    insert
  | /-- 
      F key.
      `KeyCode.f 1` represents F1 key, etc. 
    -/ 
    f : UInt8 → KeyCode
  | /--
      A character. 
      KeyCode::Char('c') represents c character, etc.
    -/
    char : Char → KeyCode
  | /-- Null. -/
    null
  | /-- Escape key. -/
    esc

-- TODO: something like bitflags.
/-- Represents key modifiers (shift, control, alt). -/
structure KeyModifiers

/-- Represents a key event. -/
structure KeyEvent where
  /-- The key itself. -/
  code      : KeyCode
  /-- Additional key modifiers. -/
  modifiers : KeyModifiers

/-- Represents a mouse button. -/
inductive MouseButton
  | left
  | right
  | middle

/-- 
  A mouse event kind. 

  # Platform-specific Notes

  ## Mouse Buttons

  Some platforms/terminals do not report mouse button for the
  `MouseEventKind.up` and `MouseEventKind.drag` events. `MouseButton.left`
  is returned if we don't know which button was used.
-/
inductive MouseEventKind
  | /-- Pressed mouse button. Contains the button that was pressed. -/
    down : MouseButton → MouseEventKind
  | /-- Released mouse button. Contains the button that was released. -/
    up   : MouseButton → MouseEventKind
  | /-- Moved the mouse cursor while pressing the contained mouse button. -/
    drag : MouseButton → MouseEventKind
  |/-- Moved the mouse cursor while not pressing a mouse button. -/ 
    moved
  | /-- Scrolled mouse wheel downwards (towards the user). -/
    scrollDown
  | /-- Scrolled mouse wheel upwards (away from the user). -/
    scrollUp

/--
  Represents a mouse event.

  # Platform-specific Notes

  ## Mouse Buttons

  Some platforms/terminals do not report mouse button for the
  `MouseEventKind.up` and `MouseEventKind.drag` events. `MouseButton.left`
  is returned if we don't know which button was used.

  ## Key Modifiers

  Some platforms/terminals does not report all key modifiers
  combinations for all mouse event types. For example - macOS reports
  `Ctrl` + left mouse button click as a right mouse button click.
-/
structure MouseEvent where
  /-- The kind of mouse event that was caused. -/
  kind      : MouseEventKind
  /-- The column that the event occurred on. -/
  column    : UInt16
  /-- The row that the event occurred on. -/
  row       : UInt16
  /-- The key modifiers active when the event occurred. -/
  modifiers : KeyModifiers

/-- Represents an event. -/
inductive Event
  | /-- A single key event with additional pressed modifiers. -/
    key     : KeyEvent → Event
  | /-- A single mouse event with additional pressed modifiers. -/
    mouse   : MouseEvent → Event
  | /--
      An resize event with new dimensions after resize (columns, rows).
      **Note** that resize events can be occur in batches.
    -/
    resize  : UInt16 × UInt16 → Event

-- TODO: add poll

-- /--
--   Reads a single `Event`

--   This function blocks until an `Event` is available. Combine it with the
--   `poll` function to get non-blocking reads.

-- -/
-- def read : IO Event := sorry

/--
  A command that enables mouse event capturing.

  Mouse events can be captured with `read`/`poll`.
-/
structure EnableMouseCapture

instance : Command EnableMouseCapture where
  writeAnsi self f := f.putStr <| 
    -- Normal tracking: Send mouse X & Y on button press and release
    csi "?1000h" ++
    -- Button-event tracking: Report button motion events (dragging)
    csi "?1002h" ++
    -- Any-event tracking: Report all motion events
    csi "?1003h" ++
    -- RXVT mouse mode: Allows mouse coordinates of >223
    csi "?1005h" ++
    -- SGR mouse mode: Allows mouse coordinates of >223, preferred over RXVT mode
    csi "?1006h"

/--
  A command that disables mouse event capturing.

  Mouse events can be captured with `read`/`poll`.
-/
structure DisableMouseCapture

instance : Command DisableMouseCapture where
  writeAnsi self f := f.putStr <| 
    -- The inverse commands of EnableMouseCapture, in reverse order.
    csi "?1006l" ++
    csi "?1015l" ++
    csi "?1003l" ++
    csi "?1002l" ++
    csi "?1001l"

/--
  Represents an attribute.
         
  # Platform-specific Notes
  
  * Only UNIX and Windows 10 terminals do support text attributes.
  * Keep in mind that not all terminals support all attributes.
  * lean4-terminal implements almost all attributes listed in the
    [SGR parameters](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters).
  
  | Attribute | Windows | UNIX | Notes |
  | :-- | :--: | :--: | :-- |
  | `reset` | ✓ | ✓ | |
  | `bold` | ✓ | ✓ | |
  | `dim` | ✓ | ✓ | |
  | `italic` | ? | ? | Not widely supported, sometimes treated as inverse. |
  | `underlined` | ✓ | ✓ | |
  | `slowBlink` | ? | ? | Not widely supported, sometimes treated as inverse. |
  | `rapidBlink` | ? | ? | Not widely supported. MS-DOS ANSI.SYS; 150+ per minute. |
  | `reverse` | ✓ | ✓ | |
  | `hidden` | ✓ | ✓ | Also known as Conceal. |
  | `fraktur` | ✗ | ✓ | Legible characters, but marked for deletion. |
  | `defaultForegroundColor` | ? | ? | Implementation specific (according to standard). |
  | `defaultBackgroundColor` | ? | ? | Implementation specific (according to standard). |
  | `framed` | ? | ? | Not widely supported. |
  | `encircled` | ? | ? | This should turn on the encircled attribute. |
  | `overLined` | ? | ? | This should draw a line at the top of the text. |
-/
inductive Attribute where
  | /-- Resets all the attributes. -/
    reset
  | /-- Increases the text intensity. -/
    bold
  | /-- Decreases the text intensity. -/
    dim
  | /-- Emphasises the text. -/
    italic
  | /-- Underlines the text. -/
    underlined
  | /-- Makes the text blinking (< 150 per minute). -/
    slowBlink
  | /-- Makes the text blinking (>= 150 per minute). -/
    rapidBlink
  | /-- Swaps foreground and background colors. -/
    reverse
  | /-- Hides the text (also known as Conceal). -/
    hidden
  | /-- Crosses the text. -/
    crossedOut
  | /-- 
      Sets the [Fraktur](https://en.wikipedia.org/wiki/Fraktur) typeface.

      Mostly used for [mathematical alphanumeric symbols](https://en.wikipedia.org/wiki/Mathematical_Alphanumeric_Symbols).
    -/
    fraktur
  | /-- Turns off the `bold` attribute. - Inconsistent - Prefer to use normalIntensity -/
    noBold
  | /-- Switches the text back to normal intensity (no bold, italic). -/
    normalIntensity
  | /-- Turns off the `Italic` attribute. -/
    noItalic
  | /-- Turns off the `Underlined` attribute. -/
    noUnderline
  | /-- Turns off the text blinking (`SlowBlink` or `RapidBlink`). -/
    noBlink
  | /-- Turns off the `Reverse` attribute. -/
    noReverse
  | /-- Turns off the `Hidden` attribute. -/
    noHidden
  | /-- Turns off the `CrossedOut` attribute. -/
    notCrossedOut
  | /-- Makes the text framed. -/
    framed
  | /-- Makes the text encircled. -/
    encircled
  | /--  Draws a line at the top of the text.. -/
    overLined
  | /-- Turns off the `Frame` and `Encircled` attributes. -/
    notFramedOrEncircled
  | /-- Turns off the `OverLined` attribute. -/
    notOverLined

/--
  Returns the SGR attribute value.

  See <https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters>
-/
def Attribute.sgr : Attribute → UInt16
  | Attribute.reset                 =>  0
  | Attribute.bold                  =>  1
  | Attribute.dim                   =>  2
  | Attribute.italic                =>  3
  | Attribute.underlined            =>  4
  | Attribute.slowBlink             =>  5
  | Attribute.rapidBlink            =>  6
  | Attribute.reverse               =>  7
  | Attribute.hidden                =>  8
  | Attribute.crossedOut            =>  9
  | Attribute.fraktur               => 20
  | Attribute.noBold                => 21
  | Attribute.normalIntensity       => 22
  | Attribute.noItalic              => 23
  | Attribute.noUnderline           => 24
  | Attribute.noBlink               => 25
  | Attribute.noReverse             => 27
  | Attribute.noHidden              => 28
  | Attribute.notCrossedOut         => 29
  | Attribute.framed                => 51
  | Attribute.encircled             => 52
  | Attribute.overLined             => 53
  | Attribute.notFramedOrEncircled  => 54
  | Attribute.notOverLined          => 55

/--
  Represents a color.
 
  # Platform-specific Notes
 
  The following list of 16 base colors are available for almost all terminals (Windows 7 and 8 included).
 
  | Light | dark |
  | :--| :--   |
  | `darkGrey` | `black` |
  | `red` | `darkRed` |
  | `green` | `darkGreen` |
  | `yellow` | `darkYellow` |
  | `blue` | `darkBlue` |
  | `magenta` | `darkMagenta` |
  | `cyan` | `darkCyan` |
  | `white` | `grey` |
 
  Most UNIX terminals and Windows 10 consoles support additional colors.
  See `Color.rgb` or `Color.ansiValue` for more info.
-/
inductive Color where
  | /-- Resets the terminal color. -/
    reset
  | /-- Black color. -/
    black
  | /-- Dark grey color. -/
    darkGrey
  | /-- Light red color. -/
    red
  | /-- Dark red color. -/
    darkRed
  | /-- Light green color. -/
    green
  | /-- Dark green color. -/
    darkGreen
  | /-- Light yellow color. -/
    yellow
  | /-- Dark yellow color. -/
    darkYellow
  | /-- Light blue color. -/
    blue
  | /-- Dark blue color. -/
    darkBlue
  | /-- Light magenta color. -/
    magenta
  | /-- Dark magenta color. -/
    darkMagenta
  | /-- Light cyan color. -/
    cyan
  | /-- Dark cyan color. -/
    darkCyan
  | /-- White color. -/
    white
  | /-- Grey color. -/
    grey
  | /-- 
      An RGB color. See [RGB color model](https://en.wikipedia.org/wiki/RGB_color_model) for more info.

      Most UNIX terminals and Windows 10 supported only.
      See Platform-specific notes for more info.
      -/
    rgb (r g b : UInt8) : Color
  | /-- 
      An ANSI color. See [256 colors - cheat sheet](https://jonasjacek.github.io/colors/) for more info.

      Most UNIX terminals and Windows 10 supported only.
      See Platform-specific notes for more info. -/
  ansiValue : UInt8 → Color

/--
  Represents a foreground or background color.
-/
inductive Colored
  | /-- A foreground color. -/
    foregroundColor : Color → Colored
  | /-- A background color. -/
    backgroundColor : Color → Colored

def Colored.toString (colored : Colored) : String := 
  match colored with
  | Colored.foregroundColor c => 
    match c with
    | Color.reset => "39"
    | Color.black => fg "5;0"
    | Color.darkGrey => fg "5;8"
    | Color.red => fg "5;9"
    | Color.darkRed => fg "5;1"
    | Color.green => fg "5;10"
    | Color.darkGreen => fg "5;2"
    | Color.yellow => fg "5;11"
    | Color.darkYellow => fg "5;3"
    | Color.blue => fg "5;12"
    | Color.darkBlue => fg "5;4"
    | Color.magenta => fg "5;13"
    | Color.darkMagenta => fg "5;5"
    | Color.cyan => fg "5;14"
    | Color.darkCyan => fg "5;6"
    | Color.white => fg "5;15"
    | Color.grey => fg "5;7"
    | Color.rgb r g b => fg s!"2;{r};{g};{b}"
    | Color.ansiValue v => fg s!"5;{v}"
  | Colored.backgroundColor c => 
    match c with
    | Color.reset => "49"
    | Color.black => bg "5;0"
    | Color.darkGrey => bg "5;8"
    | Color.red => bg "5;9"
    | Color.darkRed => bg "5;1"
    | Color.green => bg "5;10"
    | Color.darkGreen => bg "5;2"
    | Color.yellow => bg "5;11"
    | Color.darkYellow => bg "5;3"
    | Color.blue => bg "5;12"
    | Color.darkBlue => bg "5;4"
    | Color.magenta => bg "5;13"
    | Color.darkMagenta => bg "5;5"
    | Color.cyan => bg "5;14"
    | Color.darkCyan => bg "5;6"
    | Color.white => bg "5;15"
    | Color.grey => bg "5;7"
    | Color.rgb r g b => bg s!"2;{r};{g};{b}"
    | Color.ansiValue v => bg s!"5;{v}"
  where
    fg s := "38;" ++ s
    bg s := "48;" ++ s

instance : ToString Colored := ⟨ Colored.toString ⟩ 

/--
  Returns available color count.

  # Notes

  - This does not always provide a good result.
-/
def availableColorCount : IO UInt16 := do
  let term ← IO.getEnv "TERM"
  return match term with
  | some x => if "256color".isInfixOf x then 256 else 8
  | _      => 8

/--
  A command that sets the the foreground color.
  See `Color` for more info.
 
  # Notes
 
  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure SetForegroundColor := (c : Color)

instance : Command SetForegroundColor where
  writeAnsi self f := f.putStr <| csi s!"{Colored.foregroundColor self.c}m"

/--
  A command that sets the the background color.

  See `Color` for more info.
 
  # Notes
 
  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure SetBackgroundColor := (c : Color)

instance : Command SetBackgroundColor where
  writeAnsi self f := f.putStr <| csi s!"{Colored.backgroundColor self.c}m"

/--
  A command that prints the given displayable type.

  ## Notes

  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure Print (α : Type u) [ToString α] := (s : α)

instance [inst: ToString α] : Command (Print α) where
  writeAnsi self f := f.putStr <| ToString.toString self.s

/--
  A command that resets the colors back to default.
 
  # Notes
 
  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure ResetColor

instance : Command ResetColor where
  writeAnsi self f := f.putStr <| csi "0m"

/--
  A command that sets an attribute.
 
  See `Attribute` for more info.
 
  # Notes
 
  - Commands must be executed/queued for execution otherwise they do nothing.
-/
structure SetAttribute := (a : Attribute)

instance : Command SetAttribute where
  writeAnsi self f := f.putStr <| csi s!"{self.a.sgr}m"

/-- Different ways to clear the terminal buffer. -/
inductive ClearType
  | /-- All cells. -/
    all 
  | /-- All plus history. -/
    purge
  | /-- All cells from the cursor position downwards. -/
    fromCursorDown
  | /-- All cells from the cursor position upwards. -/
    fromCursorUp
  | /-- All cells at the cursor row. -/
    currentLine
  | /-- All cells from the cursor position until the new line. -/
    untilNewLine

/--
  A command that clears the terminal screen buffer.
 
  See the `ClearType` enum.
 
  # Notes
 
  Commands must be executed/queued for execution otherwise they do nothing.
-/
structure Clear := (t : ClearType)

instance : Command Clear where
  writeAnsi self f := f.putStr <| csi <|
    match self.t with
    | ClearType.all             => "2J"
    | ClearType.purge           => "3J"
    | ClearType.fromCursorDown  => "J"
    | ClearType.fromCursorUp    => "1J"
    | ClearType.currentLine     => "2K"
    | ClearType.untilNewLine    => "K"

/-- Disables line wrapping. -/
structure DisableLineWrap

instance : Command DisableLineWrap where
  writeAnsi self f := f.putStr <| csi "?7l"

/-- Enable line wrapping. -/
structure EnableLineWrap

instance : Command EnableLineWrap where
  writeAnsi self f := f.putStr <| csi "?7h"

/--
  A command that switches to alternate screen.
 
  # Notes
 
  * Commands must be executed/queued for execution otherwise they do nothing.
  * Use `LeaveAlternateScreen` command to leave the entered alternate screen.
-/
structure EnterAlternateScreen

instance : Command EnterAlternateScreen where
  writeAnsi self f := f.putStr <| csi "?1049h"

/--
  A command that switches back to the main screen.
 
  # Notes
 
  * Commands must be executed/queued for execution otherwise they do nothing.
  * Use `EnterAlternateScreen` to enter the alternate screen.
 
-/
structure LeaveAlternateScreen

instance : Command LeaveAlternateScreen where
  writeAnsi self f := f.putStr <| csi "?1049l"

/--
  A command that scrolls the terminal screen a given number of rows down.
 
  # Notes
 
  Commands must be executed/queued for execution otherwise they do nothing.
-/
structure ScrollDown := (n : UInt16)

instance : Command ScrollDown where
  writeAnsi self f := f.putStr <| csi s!"{self.n}T"

/--
  A command that scrolls the terminal screen a given number of rows up.
 
  # Notes
 
  Commands must be executed/queued for execution otherwise they do nothing.
-/
structure ScrollUp := (n : UInt16)

instance : Command ScrollUp where
  writeAnsi self f := f.putStr <| csi s!"{self.n}S"

/--
  A command that sets the terminal size `(columns, rows)`.
 
  # Notes
 
  Commands must be executed/queued for execution otherwise they do nothing.
-/
structure SetSize := (c r : UInt16)

instance : Command SetSize where
  writeAnsi self f := f.putStr <| csi s!"8;{self.r};{self.c}t"

/--
  A command that sets the terminal title
 
  # Notes
 
  Commands must be executed/queued for execution otherwise they do nothing.
-/
structure SetTitle (α : Type u) [ToString α] := (s : α)

instance [inst: ToString α] : Command (SetTitle α) where
  writeAnsi self f := f.putStr <| csi s!"\x1B]0;{ToString.toString self.s}\x07"

@[extern "lean_disable_raw_mode"]
constant disableRawMode.prim : Unit → IO Unit

/-- Disables raw mode. -/
def disableRawMode : IO Unit := disableRawMode.prim ()

@[extern "lean_enable_raw_mode"]
constant enableRawMode.prim : Unit → IO Unit

/-- Enables raw mode. -/
def enableRawMode : IO Unit := enableRawMode.prim ()

@[extern "lean_is_raw_mode_enabled"]
constant isRawModeEnabled.prim : Unit → IO Bool

/-- Tells whether the raw mode is enabled. -/
def isRawModeEnabled : IO Bool := isRawModeEnabled.prim ()

@[extern "lean_get_is_tty"]
private constant isTty.prim : Unit → IO Bool

/--
  Returns true when we are in a terminal, otherwise false.
-/
def isTty : IO Bool := isTty.prim ()

@[extern "lean_get_size"]
private constant size.prim : Unit → IO (UInt16 × UInt16)

/--
  Returns the terminal size `(columns, rows)`.
-/
def size : IO (UInt16 × UInt16) := size.prim ()

/-- Queues the given command for further execution. -/
def queue [Terminal.Command α] (cs : Array α) : IO Unit := do
  cs.forM (Terminal.Command.writeAnsi · (← IO.getStdout))

/-- Executes the given command directly. -/
def execute [Terminal.Command α] (cs : Array α) : IO Unit := do
  let out ← IO.getStdout
  cs.forM (Terminal.Command.writeAnsi · out)
  out.flush

end Terminal