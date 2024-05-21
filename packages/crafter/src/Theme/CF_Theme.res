type t = [#light | #dark]

type headingStyle = {outlineColor: CF_Color.t}
type badgeStyle = {padding: string}
type flexStyle = {rowGap: int, colGap: int}

type appTheme = {
  primaryColor: CF_Color.t,
  secondaryColor: CF_Color.t,
  primaryBackground: CF_Color.t,
  secondaryBackground: CF_Color.t,
  colorError: CF_Color.t,
  colorInfo: CF_Color.t,
  colorWarn: CF_Color.t,
  fonts: CF_Font.fontVariants,
  headingStyle: headingStyle,
  badgeStyle: badgeStyle,
  flexStyle: flexStyle,
}
let defaultLightTheme = {
  primaryColor: CF_Color.Blue(#500),
  secondaryColor: CF_Color.Gray(#700),
  primaryBackground: CF_Color.Gray(#900),
  secondaryBackground: CF_Color.Blue(#900),
  colorError: CF_Color.Red(#500),
  colorInfo: CF_Color.Gray(#300),
  colorWarn: CF_Color.Yellow(#400),
  fonts: CF_Font.defaultFontVariants,
  headingStyle: {
    outlineColor: CF_Color.Gray(#1800),
  },
  badgeStyle: {
    padding: "px-3 py-1",
  },
  flexStyle: {
    rowGap: 2,
    colGap: 2,
  },
}
