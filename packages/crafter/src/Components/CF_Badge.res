type variants = Solid | Outlined | Subtle | Circular
type size = [#sm | #md | #lg]

type colors = {
  textColor: CF_Color.t,
  bgColor: CF_Color.t,
  iconColor: CF_Color.t,
  borderColor: CF_Color.t,
}

let getColors = (badgeType: variants, badgeColor: CF_Color.color) => {
  switch badgeType {
  | Solid => {
      textColor: CF_Color.Gray(#0),
      bgColor: CF_Color.getColorWithIntensity(badgeColor, #600),
      iconColor: CF_Color.Gray(#0),
      borderColor: CF_Color.Gray(#0),
    }
  | Outlined => {
      textColor: CF_Color.getColorWithIntensity(badgeColor, #700),
      bgColor: CF_Color.Gray(#0),
      iconColor: CF_Color.getColorWithIntensity(badgeColor, #700),
      borderColor: CF_Color.getColorWithIntensity(badgeColor, #600),
    }
  | Subtle => {
      let c = CF_Color.deriveSubtleColors(badgeColor)
      {
        textColor: c.textColor,
        borderColor: CF_Color.Gray(#0),
        bgColor: c.bgColor,
        iconColor: CF_Color.getColorWithIntensity(badgeColor, #600),
      }
    }
  | Circular => {
      textColor: CF_Color.Gray(#0),
      bgColor: CF_Color.getColorWithIntensity(badgeColor, #100),
      iconColor: CF_Color.getColorWithIntensity(badgeColor, #600),
      borderColor: CF_Color.Gray(#0),
    }
  }
}

@react.component
let make = (
  ~text: string,
  ~badgeType=Solid,
  ~bgColor=?,
  ~badgeColor: option<CF_Color.color>=?,
  ~styles: option<CF_Styles.styles>=?,
  ~badgeSize: size=#md,
  ~events: CF_Events.t={},
  ~leftIcon: option<option<string> => React.element>=?,
  ~rightIcon: option<option<string> => React.element>=?,
) => {
  open CF_Dimens
  let colors = badgeColor->Option.map(c => getColors(badgeType, c))
  let bgColor = bgColor->Option.getOr(colors->Option.mapOr(CF_Color.Gray(#0), c => c.bgColor))
  let dimens = if badgeSize == #sm {
    {padding: "py-0.5 px-2"}
  } else if badgeSize == #md {
    {padding: "py-0.5 px-2.5"}
  } else {
    {padding: "py-0.5 px-3"}
  }

  let textSize = switch badgeSize {
  | #sm => #"text-xs"
  | #md => #"text-sm"
  | #lg => #"text-base"
  }
  let textColor = colors->Option.mapOr(CF_Color.Gray(#1700), c => c.textColor)
  let textStyle: CF_Styles.TextStyle.t = {
    color: textColor,
    size: textSize,
  }
  let borderColor = colors->Option.mapOr(CF_Color.Gray(#2000), c => c.borderColor)
  let border: CF_Border.t = switch badgeType {
  | Outlined => {width: #border, color: borderColor, radius: #"rounded-full"}
  | _ => {radius: #"rounded-full"}
  }
  let align = [#"justify-center", #"items-center"]
  let defaultStyles: CF_Styles.styles = {text: textStyle, dimens, border, align}
  let styles = styles->Option.mapOr(defaultStyles, s => CF_Styles.overrideWithSnd(defaultStyles, s))
  let iconColor = colors->Option.mapOr("", c => c.iconColor->CF_Color.makeHex)
  <div
    {...CF_Events.spreadEvents(events)}
    className={styles->CF_Styles.encode ++
      ` ${bgColor->CF_Color.makeBg} w-fit flex flex-row flex-shrink-0 gap-2 h-fit`}>
    {[
      leftIcon->Option.mapOr(React.null, i =>
        <CF_SVGIcons.IconWrapper icon={i} iconColor_={iconColor} />
      ),
      <CF_Typography.TextMedium
        text
        textColor={styles.text->Option.flatMap(t => t.color)->Option.getOr(textColor)}
        textSize={styles.text->Option.flatMap(t => t.size)->Option.getOr(textSize)}
      />,
      rightIcon->Option.mapOr(React.null, i =>
        <CF_SVGIcons.IconWrapper icon={i} iconColor_={iconColor} />
      ),
    ]->React.array}
  </div>
}
