import Lake
open Lake DSL

package color {
  dependencies := #[{
    name := "terminal"
    src := Source.path "../.."
  }]
}
