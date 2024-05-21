type t = [
  | // justify styles
  #"justify-center"
  | #"justify-start"
  | #"justify-end"
  | #"justify-between"
  | #"justify-around"
  | #"justify-evenly"
  | #"justify-stretch"
  | // justify items style
  #"justify-items-start"
  | #"justify-items-end"
  | #"justify-items-center"
  | #"justify-items-stretch"
  | // justify-self styles
  #"justify-self-auto"
  | #"justify-self-center"
  | #"justify-self-end"
  | #"justify-self-stretch"
  | #"justify-self-start"
  | // align content styles
  #"content-normal"
  | #"content-center"
  | #"content-start"
  | #"content-end"
  | #"content-between"
  | #"content-around"
  | #"content-evenly"
  | #"content-baseline"
  | #"content-stretch"
  | // align items styles
  #"items-start"
  | #"items-end"
  | #"items-center"
  | #"items-baseline"
  | #"items-stretch"
  | // align self styles
  #"self-auto"
  | #"self-start"
  | #"self-end"
  | #"self-center"
  | #"self-stretch"
  | #"self-baseline"
]
type textAlign = [
  | #"text-center"
  | #"text-right"
  | #"text-start"
  | #"text-end"
  | #"text-justify"
  | #"text-left"
]
let encode = (t: t): string => t->External.asString
let encodeAll = (t: array<t>): string => t->Array.map(encode)->Array.joinWith(" ")
let encodeText = (t: textAlign): string => t->External.asString
let encodeAllText = (t: array<textAlign>) => t->Array.map(encodeText)->Array.joinWith(" ")
