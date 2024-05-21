@react.component
let make = (
  ~className="",
  ~children,
  ~alignStyle="",
  ~gap: option<int>=?,
  ~onClick: JsxEvent.Mouse.t => unit=_ev => (),
) => {
  let theme = CF_ThemeContext.useThemeContext()
  <div
    onClick={onClick}
    className={`flex flex-col gap-${gap
      ->Option.map(Int.toString)
      ->Option.getOr(theme.flexStyle.colGap->Int.toString)} ${alignStyle} ${className}`}>
    {children}
  </div>
}
