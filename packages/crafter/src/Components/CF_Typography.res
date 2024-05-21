let defaultText = "Sample Text here"

let any = External.asAny

module Text = {
  @react.component
  let make = (~className="", ~text=defaultText, ~textStyle=#normal, ~font: CF_Font.t) => {
    <div
      className={`${font.family->any} ${font.size->any} ${font.weight->any} ${CF_Color.make(
          font.color,
        )} ${className}`}>
      {text->React.string}
    </div>
  }
}

module TextLight = {
  @react.component
  let make = (
    ~className="",
    ~text=defaultText,
    ~textStyle=#normal,
    ~textSize=?,
    ~textColor: option<CF_Color.t>=?,
  ) => {
    let theme: CF_Theme.appTheme = CF_ThemeContext.useThemeContext()
    let light = {
      ...theme.fonts.light,
      color: textColor->Option.getOr(theme.fonts.light.color),
      size: textSize->Option.getOr(theme.fonts.light.size),
    }
    <div className={`${CF_Font.encode(~font=light)} ${className}`}> {text->React.string} </div>
  }
}

module TextRegular = {
  @react.component
  let make = (
    ~className="",
    ~text=defaultText,
    ~textStyle=#normal,
    ~textColor: option<CF_Color.t>=?,
    ~textSize=?,
  ) => {
    let theme: CF_Theme.appTheme = CF_ThemeContext.useThemeContext()
    let regular = {
      ...theme.fonts.regular,
      color: textColor->Option.getOr(theme.fonts.regular.color),
      size: textSize->Option.getOr(theme.fonts.regular.size),
    }
    <div className={`${CF_Font.encode(~font=regular)} ${className}`}> {text->React.string} </div>
  }
}

module TextMedium = {
  @react.component
  let make = (
    ~className="",
    ~text=defaultText,
    ~textStyle=#normal,
    ~textColor: option<CF_Color.t>=?,
    ~textSize=?,
  ) => {
    let theme: CF_Theme.appTheme = CF_ThemeContext.useThemeContext()
    let medium = {
      ...theme.fonts.medium,
      color: textColor->Option.getOr(theme.fonts.medium.color),
      size: textSize->Option.getOr(theme.fonts.medium.size),
    }
    <div className={`${CF_Font.encode(~font=medium)} ${className}`}> {text->React.string} </div>
  }
}

module TextSemiBold = {
  @react.component
  let make = (
    ~className="",
    ~text=defaultText,
    ~textStyle=#normal,
    ~textSize: option<CF_Font.fontSize>=?,
    ~textColor: option<CF_Color.t>=?,
  ) => {
    let theme: CF_Theme.appTheme = CF_ThemeContext.useThemeContext()
    let semiBold = {
      ...theme.fonts.semibold,
      color: textColor->Option.getOr(theme.fonts.semibold.color),
      size: textSize->Option.getOr(theme.fonts.semibold.size),
    }
    <div className={`${CF_Font.encode(~font=semiBold)} ${className}`}> {text->React.string} </div>
  }
}

module TextBold = {
  @react.component
  let make = (
    ~className="",
    ~text=defaultText,
    ~textStyle=#normal,
    ~textSize: option<CF_Font.fontSize>=?,
    ~textColor: option<CF_Color.t>=?,
  ) => {
    let theme: CF_Theme.appTheme = CF_ThemeContext.useThemeContext()
    let bold = {
      ...theme.fonts.bold,
      color: textColor->Option.getOr(theme.fonts.bold.color),
      size: textSize->Option.getOr(theme.fonts.bold.size),
    }
    <div className={`${CF_Font.encode(~font=bold)} ${className}`}> {text->React.string} </div>
  }
}
