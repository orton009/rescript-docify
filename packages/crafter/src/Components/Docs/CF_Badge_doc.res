module Example1 = {
  @ocaml.doc(`
## Info

Badges can be created using provided **bgColor** or **badgeColor**, **badgeColor** overrides any bgColor and derives background, text and image colors automatically.
Note: it doesn't work for gray and yellow color style

Different types of badges can be created using badgeType, icons can come on either side, for styles option please refer to style doc
`)
  @react.component
  let make = () => {
    <CF_Col gap=4>
      <CF_Row>
        <CF_Badge
          badgeType={Solid}
          text="Solid Badge"
          bgColor={CF_Color.Green(#200)}
          styles={text: {color: CF_Color.Green(#700)}}
        />
        <CF_Badge
          badgeType={Solid}
          text="Solid Badge"
          bgColor={CF_Color.Cyan(#200)}
          styles={text: {color: CF_Color.Cyan(#700)}}
        />
      </CF_Row>
      <CF_Row>
        <CF_Badge
          badgeType={Outlined}
          text="Outlined Badge"
          styles={text: {color: CF_Color.Cyan(#700)}, border: {color: CF_Color.Cyan(#700)}}
        />
        <CF_Badge
          badgeType={Outlined}
          text="Outlined Badge"
          bgColor={CF_Color.Red(#200)}
          styles={text: {color: CF_Color.Red(#700)}, border: {color: CF_Color.Red(#700)}}
        />
      </CF_Row>
      <CF_Row>
        <CF_Badge
          badgeType={Circular}
          text="Circular Badge"
          bgColor={CF_Color.Red(#200)}
          styles={text: {color: CF_Color.Red(#700)}, border: {color: CF_Color.Red(#700)}}
        />
      </CF_Row>
      <CF_Row>
        <CF_Badge badgeType={Subtle} text="Subtle Badge" badgeColor={#Cyan} />
        <CF_Badge badgeType={Subtle} text="Subtle Badge" badgeColor={#Purple} />
      </CF_Row>
    </CF_Col>
  }
}
