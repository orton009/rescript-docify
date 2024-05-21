@val @scope(("window", "location")) external origin: string = "origin"

type imageType = [
  | #svg
  | #png
  | #jpg
]
type imageSource = ImageUrl(string) | Name(string)

@react.component
let make = (~imageType=#png, ~source: imageSource) => {
  let source = switch source {
  | ImageUrl(url) => url
  | Name(img) => origin ++ "/icons/" ++ img ++ "." ++ imageType->Core.External.encodeVariant
  }
  <img src={source} />
}
