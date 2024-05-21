type borderWidth = [
  | #"border-0"
  | #"border-2"
  | #"border-4"
  | #"border-8"
  | #border
  | #"border-x-0"
  | #"border-x-2"
  | #"border-x-4"
  | #"border-x-8"
  | #"border-x"
  | #"border-y-0"
  | #"border-y-2"
  | #"border-y-4"
  | #"border-y-8"
  | #"border-y"
  | #"border-r-0"
  | #"border-r-2"
  | #"border-r-4"
  | #"border-r-8"
  | #"border-r"
  | #"border-l-0"
  | #"border-l-2"
  | #"border-l-4"
  | #"border-l-8"
  | #"border-l"
  | #"border-b-0"
  | #"border-b-2"
  | #"border-b-4"
  | #"border-b-8"
  | #"border-b"
  | #"border-t-0"
  | #"border-t-2"
  | #"border-t-4"
  | #"border-t-8"
  | #"border-t"
]
type borderStyle = [
  | #"border-solid"
  | #"border-dashed"
  | #"border-dotted"
  | #"border-double"
  | #"border-hidden"
  | #"border-none"
]
type outline = [
  | #"outline-0"
  | #"outline-1"
  | #"outline-2"
  | #"outline-4"
  | #"outline-8"
]
type outlineStyle = [
  | #"outline-none"
  | #outline
  | #"outline-dashed"
  | #"outlined-dotted"
  | #"outline-double"
]
type outlineOffset = [
  | #"outline-offset-0"
  | #"outline-offset-1"
  | #"outline-offset-2"
  | #"outline-offset-4"
  | #"outline-offset-8"
]
type borderRadius = [
  | #rounded
  | #"rounded-none"
  | #"rounded-md"
  | #"rounded-sm"
  | #"rounded-lg"
  | #"rounded-xl"
  | #"rounded-2xl"
  | #"rounded-3xl"
  | #"rounded-full"
]
type t = {
  width?: borderWidth,
  color?: CF_Color.t,
  radius?: borderRadius,
  style?: borderStyle,
  outline?: outline,
  outlineColor?: CF_Color.t,
  outlineStyle?: outlineStyle,
  outlineOffset?: outlineOffset,
}
let encode = (t: t): string =>
  `${t.width->External.optString} ${t.color->CF_Color.optEncode(
      CF_Color.makeBorder,
    )} ${t.radius->External.optString} ${t.style->External.optString} ${t.outline->External.optString} ${t.outlineColor->CF_Color.optEncode(
      CF_Color.makeOutline,
    )} ${t.outlineStyle->External.optString} ${t.outlineOffset->External.optString}`
