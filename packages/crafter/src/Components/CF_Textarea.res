type input = {
  value?: string,
  placholder?: string,
}

@react.component
let make = (
  ~styles: CF_Styles.styles={},
  ~editable=true,
  ~input: input={},
  ~events: CF_Events.t={},
) => {
  let text: CF_Styles.TextStyle.raw = {
    color: Gray(#1200),
    family: #"font-inter-style",
    size: #"text-sm",
    weight: #"font-medium",
  }
  let dimens: CF_Dimens.t = {height: "h-60 w-full p-2"}
  let border: CF_Border.t = {
    width: #border,
    radius: #"rounded-md",
    color: CF_Color.Gray(#400),
  }
  let styles = CF_Styles.overrideWithSnd({rawText: text, dimens, border}, styles)
  let onChange_ = ev => {
    %debugger
    let value = JsxEvent.Form.currentTarget(ev)["value"]
    if value->String.includes("<script>") || value->String.includes("</script>") {
      ()
    }
    events.onChange->Option.map(c => c(ev))->ignore
  }

  <textarea
    {...CF_Events.spreadEvents(events)}
    className={CF_Styles.encode(styles)}
    readOnly={!editable}
    placeholder={input.placholder->Option.getOr("")}
    value={input.value->Option.getOr("")}
    onChange={onChange_}
  />
}
