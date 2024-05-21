@react.component
let make = (
  ~className: string="",
  ~children,
  ~alignStyle="items-center",
  ~gap: option<int>=?,
  ~onClick: JsxEvent.Mouse.t => unit=_ev => (),
) => {
  let theme = CF_ThemeContext.useThemeContext()
  <div
    onClick={onClick}
    className={`flex flex-row gap-${gap
      ->Option.map(Int.toString)
      ->Option.getOr(theme.flexStyle.rowGap->Int.toString)} ${alignStyle} ${className}`}>
    {children}
  </div>
}
