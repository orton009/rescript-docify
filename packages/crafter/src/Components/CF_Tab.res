type tabElement<'a> = {
  heading: string,
  data: 'a,
}

@react.component
let make = (
  ~tabs: array<tabElement<'a>>,
  ~renderTabElement: option<tabElement<'a> => React.element>=?,
  ~containerStyle: string="",
  ~borderColor: option<CF_Color.t>=?,
  ~textColor: option<CF_Color.t>=?,
) => {
  let (selectedTab, setSelectedTab) = React.useState(_ => tabs[0])
  let theme = CF_ThemeContext.useThemeContext()
  let borderColor = borderColor->Option.getOr(theme.headingStyle.outlineColor)
  let textColor = textColor->Option.getOr(theme.fonts.semibold.color)

  <CF_Col gap={renderTabElement->Option.isSome ? 4 : 0} className={containerStyle}>
    <CF_Row gap=4 className={`w-full border-b-1 ${CF_Color.Gray(#500)->CF_Color.makeBorder}`}>
      {tabs
      ->Array.map(e => {
        let isSelected = selectedTab->Option.map(x => x.heading == e.heading)->Option.toBool
        <div
          className={`cursor-pointer px-2 pt-2 pb-1 ${isSelected
              ? "border-b-4 " ++ borderColor->CF_Color.makeBorder
              : ""}`}
          onClick={_ => setSelectedTab(_ => Some(e))}>
          {isSelected
            ? <CF_Typography.TextBold textSize={#"text-lg"} text={e.heading} textColor />
            : <CF_Typography.TextMedium textSize={#"text-lg"} text={e.heading} textColor />}
        </div>
      })
      ->React.array}
    </CF_Row>
    {selectedTab
    ->Option.flatMap(t =>
      renderTabElement->Option.map(fn => {
        fn(t)
      })
    )
    ->Option.getOr(React.null)}
  </CF_Col>
}
