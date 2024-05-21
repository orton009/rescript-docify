@ocaml.doc(`
### Typography is used to write any kind of content, its the most basic component to write text, as it stritly follows the configured fonts, styles and weight where sizes and color can be configured

`)
module Example = {
  @react.component
  let make = () => {
    <CF_Col>
      <CF_Row>
        <CF_Typography.TextRegular text="normal text" />
        <CF_Typography.TextRegular text="smaller text" textSize={#"text-xs"} />
        <CF_Typography.TextRegular text="larger text" textSize={#"text-base"} />
        <CF_Typography.TextRegular text="much larger text" textSize={#"text-xl"} />
        <CF_Typography.TextRegular text="very Large text" textSize={#"text-2xl"} />
      </CF_Row>
      <CF_Row>
        <CF_Typography.TextMedium text="normal text" />
        <CF_Typography.TextMedium text="smaller text" textSize={#"text-xs"} />
        <CF_Typography.TextMedium text="larger text" textSize={#"text-base"} />
        <CF_Typography.TextMedium text="much larger text" textSize={#"text-xl"} />
        <CF_Typography.TextMedium text="very Large text" textSize={#"text-2xl"} />
      </CF_Row>
      <CF_Row>
        <CF_Typography.TextSemiBold text="normal text" />
        <CF_Typography.TextSemiBold text="smaller text" textSize={#"text-xs"} />
        <CF_Typography.TextSemiBold text="larger text" textSize={#"text-base"} />
        <CF_Typography.TextSemiBold text="much larger text" textSize={#"text-xl"} />
        <CF_Typography.TextSemiBold text="very Large text" textSize={#"text-2xl"} />
      </CF_Row>
      <CF_Row>
        <CF_Typography.TextBold text="normal text" />
        <CF_Typography.TextBold text="smaller text" textSize={#"text-xs"} />
        <CF_Typography.TextBold text="larger text" textSize={#"text-base"} />
        <CF_Typography.TextBold text="much larger text" textSize={#"text-xl"} />
        <CF_Typography.TextBold text="very Large text" textSize={#"text-2xl"} />
      </CF_Row>
    </CF_Col>
  }
}
