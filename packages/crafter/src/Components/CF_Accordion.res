module Styles = CF_Styles

type input<'a> = {
  data: 'a,
  heading: bool => React.element,
  body: bool => React.element,
  isOpen: bool,
}

let openIcon =
  <svg width="12" height="8" viewBox="0 0 12 8" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M6.58893 7.08991C6.26349 7.41534 5.73586 7.41534 5.41042 7.08991L0.410419 2.08991C0.0849819 1.76447 0.0849819 1.23683 0.410419 0.911396C0.735856 0.585959 1.26349 0.585959 1.58893 0.911396L5.99967 5.32214L10.4104 0.911396C10.7359 0.585959 11.2635 0.585959 11.5889 0.911396C11.9144 1.23683 11.9144 1.76447 11.5889 2.08991L6.58893 7.08991Z"
      fill="#5F5F5F"
    />
  </svg>

let closedIcon =
  <svg width="12" height="8" viewBox="0 0 12 8" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M6.58893 7.08991C6.26349 7.41534 5.73586 7.41534 5.41042 7.08991L0.410419 2.08991C0.0849819 1.76447 0.0849819 1.23683 0.410419 0.911396C0.735856 0.585959 1.26349 0.585959 1.58893 0.911396L5.99967 5.32214L10.4104 0.911396C10.7359 0.585959 11.2635 0.585959 11.5889 0.911396C11.9144 1.23683 11.9144 1.76447 11.5889 2.08991L6.58893 7.08991Z"
      fill="#5F5F5F"
    />
  </svg>

@react.component
let make = (
  ~input: array<input<'a>>,
  ~headerStyle: CF_Dimens.t={padding: "p-4"},
  ~bodyStyle: CF_Dimens.t={padding: "p-4"},
  ~containerStyle: option<Styles.styles>=?,
  ~iconProps: bool => React.element=isOpen => isOpen ? openIcon : closedIcon,
  ~onClick: input<'a> => unit=_ => (),
) => {
  let (inputState, setInputState) = React.useState(_ => input)
  React.useEffect1(() => {
    setInputState(_ => input)
    None
  }, [input])
  let dimens: CF_Dimens.t = {width: "w-full"}
  let defaultBorderColor = CF_Color.Gray(#400)
  let border: CF_Border.t = {
    width: #border,
    radius: #"rounded-md",
    color: defaultBorderColor,
  }
  let styles = Styles.overrideWithSnd({border, dimens}, containerStyle->Option.getOr({}))
  let borderColor =
    styles.border
    ->Option.flatMap(b => b.color)
    ->Option.getOr(defaultBorderColor)
  <div className={Styles.encode(styles) ++ " relative"}>
    {inputState
    ->Array.mapWithIndex((e, i) => {
      let isLast = i == input->Array.length - 1
      let icon = iconProps(e.isOpen)
      [
        <div className=" relative">
          <CF_Row
            className={CF_Dimens.encode(headerStyle) ++ " cursor-pointer"}
            alignStyle="justify-between"
            onClick={_ => {
              setInputState(prev =>
                prev->Array.mapWithIndex((e, ix) => ix == i ? {...e, isOpen: !e.isOpen} : e)
              )
              onClick({...e, isOpen: !e.isOpen})
            }}>
            {e.heading(e.isOpen)}
            {icon}
          </CF_Row>
          {e.isOpen
            ? <div
                className={CF_Dimens.encode(
                  bodyStyle,
                ) ++ "  transition-all  duration-5000 ease-in-out"}>
                {e.body(e.isOpen)}
              </div>
            : React.null}
        </div>,
        {
          !isLast
            ? <CF_Divider direction={#horizontal} width="1px" color=borderColor />
            : React.null
        },
      ]->React.array
    })
    ->React.array}
  </div>
}
