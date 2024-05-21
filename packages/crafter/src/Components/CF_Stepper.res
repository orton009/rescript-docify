@ocaml.doc(`
  Stepper provides a view of a user journey, it can be a form journey or onboarding to a new product

  ~~~
  open CF_Stepper
  let input = [
    {element: "page1", isSelected: false},
    {element: "page2", isSelected: true},
    {element: "page3", isSelected: false}
  ]
  <CF_Stepper input renderInput={(el, _) => String(el.element)}/>
  ~~~
`)
type input<'a> = {
  element: 'a,
  isSelected: bool,
}
type stepperType = CustomElement(React.element) | String(string) | NumberedString(string)

@react.component
let make = (
  ~bgColor: CF_Color.t=CF_Color.Gray(#200),
  ~styles: option<CF_Styles.styles>=?,
  ~input: array<input<'a>>,
  ~renderInput: (input<'a>, int) => stepperType,
  ~onStageSelect: option<(input<'a>, int)> => unit=_ => (),
) => {
  let dimens: CF_Dimens.t = {padding: "p-3", gap: "gap-2"}

  let align = [#"items-center"]
  let defaultStyles: CF_Styles.styles = {
    align,
    dimens,
  }
  let styles = styles->Option.mapOr(defaultStyles, s => CF_Styles.overrideWithSnd(defaultStyles, s))

  <div className={`flex flex-row ${CF_Styles.encode(styles)} ${CF_Color.makeBg(bgColor)}`}>
    {input
    ->Array.mapWithIndex((el, ix) => {
      let output = renderInput(el, ix)
      switch output {
      | CustomElement(el) => el
      | String(text) => <CF_Typography.TextLight text />
      | NumberedString(text) =>
        <CF_Row gap=2>
          <div className="rounded-full p-2"> {ix->Int.toString->React.string} </div>
          <CF_Typography.TextLight text />
        </CF_Row>
      }
    })
    ->React.array}
  </div>
}
