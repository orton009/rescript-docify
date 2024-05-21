open Core.External

type textStyle = [
  | #error
  | #normal
  | #warn
  | #info
]
type fontFamily = [
  | #"font-ibm-plex"
  | #"font-ibm-plex-mono"
  | #"font-fira-code"
  | #"font-inter-style"
  | #"font-roboto-mono"
  | #"font-fira-code"
  | #"font-albert-sans"
  | #"font-roboto-mono"
]
type fontStyle = [
  | #italic
  | #"not-italic"
]
type fontSize = [
  | #"text-xs"
  | #"text-sm"
  | #"text-base"
  | #"text-lg"
  | #"text-xl"
  | #"text-2xl"
  | #"text-3xl"
  | #"text-4xl"
  | #"text-5xl"
  | #"text-6xl"
  | #"text-7xl"
  | #"text-8xl"
  | #"text-9xl"
]
type fontWeight = [
  | #"font-thin"
  | #"font-extralight"
  | #"font-light"
  | #"font-normal"
  | #"font-medium"
  | #"font-semibold"
  | #"font-bold"
  | #"font-extrabold"
  | #"font-black"
]
type fontExtras = {
  style: fontStyle,
  lineHeight: string,
  letterSpacing: string,
}
type t = {
  family: fontFamily,
  size: fontSize,
  weight: fontWeight,
  color: CF_Color.t,
}
let make = (~family: fontFamily, ~size: fontSize, ~weight: fontWeight, ~color: CF_Color.t) => {
  {family, size, weight, color}
}
let encodeFamily = (family: fontFamily) => family->asAny

let encode = (~font) =>
  `${font.family->encodeFamily} ${font.size->asAny} ${font.weight->asAny} ${CF_Color.make(
      font.color,
    )}`

let optEncode = (f: option<t>) => f->Option.mapOr("", x => encode(~font=x))

type fontVariants = {
  light: t,
  regular: t,
  medium: t,
  semibold: t,
  bold: t,
}

let defaultFontVariants = {
  light: {
    family: #"font-inter-style",
    size: #"text-sm",
    weight: #"font-light",
    color: Gray(#1400),
  },
  regular: {
    family: #"font-inter-style",
    size: #"text-sm",
    weight: #"font-normal",
    color: Gray(#1400),
  },
  medium: {
    family: #"font-inter-style",
    size: #"text-base",
    weight: #"font-medium",
    color: Gray(#1400),
  },
  semibold: {
    family: #"font-inter-style",
    size: #"text-base",
    weight: #"font-semibold",
    color: Gray(#2000),
  },
  bold: {
    family: #"font-inter-style",
    size: #"text-base",
    weight: #"font-bold",
    color: Gray(#2000),
  },
}
