type dimensions = {
  height: int,
  width: int,
}

let useDomCalculate = (element: React.element) => {
  let (cf_dimensions, setCFDimensions) = React.useState(_ => None)
  let cf_domRef = React.useRef(Nullable.null)
  React.useEffect1(() => {
    cf_domRef.current
    ->Nullable.map(ref => {
      setCFDimensions(
        _ => Some({
          height: Webapi__Dom.Element.clientHeight(ref),
          width: Webapi__Dom.Element.clientWidth(ref),
        }),
      )
    })
    ->ignore
    None
  }, [cf_domRef])

  (<div ref={ReactDOM.Ref.domRef(cf_domRef)}> {element} </div>, cf_dimensions)
}
