open Core.External

@ocaml.doc(`
## Color Types
  this type is used to represent the color and intensity of the color, higher the number, more the intensity

`)
let colorScheme: Dict.t<Dict.t<string>> = %raw(`
  require("../../../../crafter.theme.json")
`)

type intensity = [
  | #0
  | #50
  | #100
  | #200
  | #300
  | #400
  | #500
  | #600
  | #700
  | #800
  | #900
  | #1000
  | #1100
  | #1200
  | #1300
  | #1400
  | #1500
  | #1600
  | #1700
  | #1800
  | #1900
  | #2000
  | #2100
  | #2200
]

type color = [
  | #Green
  | #Gray
  | #Blue
  | #Purple
  | #Magenta
  | #Cyan
  | #Yellow
  | #Orange
  | #Red
  | #Teal
]

type t =
  | Green(intensity)
  | Gray(intensity)
  | Blue(intensity)
  | Purple(intensity)
  | Magenta(intensity)
  | Cyan(intensity)
  | Yellow(intensity)
  | Orange(intensity)
  | Red(intensity)
  | Teal(intensity)
let encodeColor = color =>
  switch color {
  | Green(t) => `green-${t->asAny}`
  | Gray(t) => `gray-${t->asAny}`
  | Blue(t) => `blue-${t->asAny}`
  | Purple(t) => `purple-${t->asAny}`
  | Magenta(t) => `magenta-${t->asAny}`
  | Cyan(t) => `cyan-${t->asAny}`
  | Yellow(t) => `yellow-${t->asAny}`
  | Orange(t) => `orange-${t->asAny}`
  | Red(t) => `red-${t->asAny}`
  | Teal(t) => `teal-${t->asAny}`
  }
let make = (color: t) => `text-jp-light-` ++ color->encodeColor
let makeBg = (color: t) => `bg-jp-light-` ++ color->encodeColor
let makeBorder = (color: t) => `border-jp-light-` ++ color->encodeColor
let makeHex = (color: t) => {
  let encoded = color->encodeColor
  let parts = encoded->String.split("-")
  let color = parts[0]
  let intensity = parts[1]
  let result =
    color
    ->Option.flatMap(c => colorScheme->Dict.get(`jp-light-${c}`))
    ->Option.flatMap(cDict => {
      intensity->Option.flatMap(o => cDict->Dict.get(o))
    })
    ->Option.getOr("none")
  result
}
let makeOutline = (color: t) => `outline-jp-light` ++ color->encodeColor
let makeStroke = (color: t) => {
  `stroke-[${makeHex(color)}]`
}
let makeShadow = (color: t) => {
  `shadow-[${makeHex(color)}]`
}

let optEncode = (color: option<t>, encoder: t => string) => color->Option.mapOr("", encoder)

type colorStyles = {
  textColor: t,
  bgColor: t,
}

let getColorWithIntensity = (color: color, intensity: intensity) =>
  switch color {
  | #Green => Green(intensity)
  | #Gray => Gray(intensity)
  | #Red => Red(intensity)
  | #Blue => Blue(intensity)
  | #Purple => Purple(intensity)
  | #Magenta => Magenta(intensity)
  | #Teal => Teal(intensity)
  | #Orange => Orange(intensity)
  | #Yellow => Yellow(intensity)
  | #Cyan => Cyan(intensity)
  }

let deriveSubtleColors = (color: color): colorStyles => {
  {
    textColor: getColorWithIntensity(color, #700),
    bgColor: getColorWithIntensity(color, #100),
  }
}

module ColorDisplay = {
  @react.component
  let make = (~color: t, ~text="colorDisplay", ~textColor: t=Gray(#0)) => {
    <div className={makeBg(color) ++ " " ++ make(textColor) ++ " rounded-md  p-4"}>
      {text->React.string}
    </div>
  }
}
