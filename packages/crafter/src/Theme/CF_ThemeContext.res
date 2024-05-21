let defaultThemeContext = React.createContext(CF_Theme.defaultLightTheme)

let useThemeContext = () => {
  React.useContext(defaultThemeContext)
}

module ThemeContextProvider = {
  let make = React.Context.provider(defaultThemeContext)
}
