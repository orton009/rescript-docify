@ocaml.doc(`
## Dividers can be added between sections or used inside other components

you can create horizontal or vertical dividers on the basis of direction
width describes how wide a divider is going to be
color is the fillColor of the divider

### Here are some code samples to create divider

~~~
<CF_Col>
<CF_Divider direction={#horizontal} color={CF_Color.Red(#400)} length="100%" width="4px" />

<CF_Divider direction={#vertical} length="40px" color={CF_Color.Red(#400)} width="4px"/>
</CF_Col>

~~~
`)
@react.component
let make = (
  ~length: string="100%",
  ~width: string="2px",
  ~direction: [#vertical | #horizontal],
  ~className: string="",
  ~color: CF_Color.t=CF_Color.Gray(#800),
) => {
  let v = direction == #vertical
  <div
    style={{width: v ? width : length, height: v ? length : width}}
    className={`${CF_Color.makeBg(color)} ${className}`}
  />
}
