type t = {
  onAnimationStart?: JsxEventU.Animation.t => unit,
  onAnimationEnd?: JsxEventU.Animation.t => unit,
  onBlur?: JsxEventU.Focus.t => unit,
  onClick?: JsxEventU.Mouse.t => unit,
  onChange?: JsxEventU.Form.t => unit,
  onMouseDown?: JsxEventU.Mouse.t => unit,
  onMouseMove?: JsxEventU.Mouse.t => unit,
  onMouseEnter?: JsxEventU.Mouse.t => unit,
  onMouseOut?: JsxEventU.Mouse.t => unit,
  onMouseOver?: JsxEventU.Mouse.t => unit,
  onMouseUp?: JsxEventU.Mouse.t => unit,
  onMouseLeave?: JsxEventU.Mouse.t => unit,
  onFocus?: JsxEventU.Focus.t => unit,
  onInput?: JsxEventU.Form.t => unit,
  onKeyDown?: JsxEventU.Keyboard.t => unit,
  onKeyPress?: JsxEventU.Keyboard.t => unit,
  onKeyUp?: JsxEventU.Keyboard.t => unit,
  onSelect?: JsxEventU.Selection.t => unit,
  onScroll?: JsxEventU.UI.t => unit,
  onSubmit?: JsxEventU.Form.t => unit,
}

external spreadEvents: t => JsxDOM.domProps = "%identity"
