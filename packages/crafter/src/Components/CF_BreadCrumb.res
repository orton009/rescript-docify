@ocaml.doc(`

### Breadcrumbs

Breadcrumbs take array of elements as input where every element has state and any datatype
State is used to represent active or inactive state of a breadcrumb
Any datatype is supported so that users can get the value they want to show in breadcrumb from their custom types

`)
type element<'a> = {
  state: [#active | #inactive],
  element: 'a,
}
@react.component
let make = (
  ~elements: array<element<'a>>,
  ~maxInlined: int=4,
  ~renderActive: 'a => React.element=t => <CF_Typography.TextSemiBold text=t />,
  ~renderInactive: 'a => React.element=t => <CF_Typography.TextLight text=t />,
  ~onElementClick: element<'a> => unit=_ => (),
) => {
  let (activeElement, setActiveElement) = React.useState(_ =>
    elements->Array.find(e => e.state == #active)->Option.flatMapNone(_ => elements[0])
  )
  <div className="flex flex-row gap-2 items-center">
    {elements
    ->Array.map(e =>
      <div
        className="cursor-pointer"
        onClick={_ => {
          setActiveElement(_ => Some(e))
          onElementClick(e)
        }}>
        {activeElement->Option.map(x => x.state == e.state)->Option.toBool
          ? renderActive(e.element)
          : renderInactive(e.element)}
      </div>
    )
    ->Array.reduceWithIndex([], (acc, el, index) => {
      acc->Array.push(el)
      if index != elements->Array.length - 1 {
        acc->Array.push(<CF_Typography.TextLight text="/" />)
      }
      acc
    })
    ->React.array}
  </div>
}
