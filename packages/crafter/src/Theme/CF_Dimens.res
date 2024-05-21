type tailwindClass = string
// type space = [
//   | #px
//   | #0
//   | #"0.5"
//   | #1
//   | #"1.5"
//   | #2
//   | #"2.5"
//   | #3
//   | #"3.5"
//   | #4
//   | #5
//   | #6
//   | #7
//   | #8
//   | #9
//   | #10
//   | #11
//   | #12
//   | #14
//   | #16
//   | #20
//   | #24
//   | #28
//   | #32
//   | #36
//   | #40
//   | #44
//   | #48
//   | #52
//   | #56
//   | #60
//   | #64
//   | #72
//   | #80
//   | #96
//   | #100
//   | #200
//   | #300
//   | #400
//   | #500
//   | #600
//   | #700
//   | #full
// ]
type t = {
  padding?: tailwindClass,
  margin?: tailwindClass,
  gap?: tailwindClass,
  height?: tailwindClass,
  minHeight?: tailwindClass,
  maxHeight?: tailwindClass,
  width?: tailwindClass,
  minWidth?: tailwindClass,
  maxWidth?: tailwindClass,
  size?: tailwindClass,
}

let encode = (t: t) =>
  `${t.padding->External.optString} ${t.margin->External.optString} ${t.gap->External.optString} ${t.height->External.optString} ${t.minHeight->External.optString} ${t.maxHeight->External.optString} ${t.width->External.optString} ${t.minWidth->External.optString} ${t.maxWidth->External.optString} ${t.size->External.optString}`
