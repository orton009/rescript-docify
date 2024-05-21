
module OutlinedHeader = {
  @ocaml.doc(`
## Outlined Header can be used to add section headers

~~~
  <CF_Header.OutlinedHeader input={Text("Heading 1")}/>
~~~

`)
  type input = Text(string) | Custom(React.element)
  @react.component
  let make = (
    ~input: input,
    ~className: string="",
    ~borderColor: option<CF_Color.t>=?,
    ~textColor: option<CF_Color.t>=?,
  ) => {
    let theme = CF_ThemeContext.useThemeContext()
    let borderColor = borderColor->Option.getOr(theme.headingStyle.outlineColor)
    let textColor = textColor->Option.getOr(theme.fonts.semibold.color)
    <div className="flex flex-col gap-4">
      {switch input {
      | Text(text) =>
        <CF_Typography.TextSemiBold
          text
          textSize=#"text-base"
          textColor={textColor}
          className={`${borderColor->CF_Color.makeBorder} ${className}`}
        />
      | Custom(element) => element
      }}
      <div className={`grow border-b-1 ${CF_Color.Gray(#500)->CF_Color.makeBorder}`} />
    </div>
  }
}
