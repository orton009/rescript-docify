module Example = {
  @react.component
  let make = () => {
    <div>
      <CF_Row>
        <CF_Color.ColorDisplay color={CF_Color.Green(#400)} text="Green-400" />
        <CF_Color.ColorDisplay color={CF_Color.Green(#100)} text="Green-100" />
        <CF_Color.ColorDisplay color={CF_Color.Green(#800)} text="Green-800" />
      </CF_Row>
      <CF_Row>
        <CF_Color.ColorDisplay color={CF_Color.Yellow(#400)} text="Green-400" />
        <CF_Color.ColorDisplay color={CF_Color.Yellow(#100)} text="Green-100" />
        <CF_Color.ColorDisplay color={CF_Color.Yellow(#800)} text="Green-800" />
      </CF_Row>
      <CF_Row>
        <CF_Color.ColorDisplay color={CF_Color.Cyan(#400)} text="Green-400" />
        <CF_Color.ColorDisplay color={CF_Color.Cyan(#100)} text="Green-100" />
        <CF_Color.ColorDisplay color={CF_Color.Cyan(#800)} text="Green-800" />
      </CF_Row>
      <CF_Row>
        <CF_Color.ColorDisplay color={CF_Color.Blue(#400)} text="Green-400" />
        <CF_Color.ColorDisplay color={CF_Color.Blue(#100)} text="Green-100" />
        <CF_Color.ColorDisplay color={CF_Color.Blue(#800)} text="Green-800" />
      </CF_Row>
    </div>
  }
}
