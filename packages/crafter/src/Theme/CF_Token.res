let defaultToken = CF_Theme.defaultLightTheme

@react.component
let make = (~token: CF_Theme.appTheme, ~children) => {
  <CF_ThemeContext.ThemeContextProvider value={token}>
    {children}
  </CF_ThemeContext.ThemeContextProvider>
}
