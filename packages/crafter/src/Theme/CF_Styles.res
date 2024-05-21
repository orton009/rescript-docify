module TextStyle = {
  type raw = {
    color?: CF_Color.t,
    family?: CF_Font.fontFamily,
    size?: CF_Font.fontSize,
    weight?: CF_Font.fontWeight,
    align?: array<CF_Align.textAlign>,
    textStyle?: CF_Font.fontStyle,
    other?: string,
  }
  type typo = [#Medium | #Light | #Regular | #Semibold | #Bold]
  type t = {
    color?: CF_Color.t,
    size?: CF_Font.fontSize,
    weight?: typo,
    other?: string,
  }
  let encode = (t: raw) =>
    `${t.color->CF_Color.optEncode(
        CF_Color.make,
      )} ${t.family->External.optString} ${t.weight->External.optString} ${t.textStyle->External.optString} ${t.size->External.optString} ${Option.getOr(
        t.align,
        [],
      )->CF_Align.encodeAllText} ${t.other->Option.getOr("")}`

  let typographyEncode = (t: t) =>
    `${t.color->CF_Color.optEncode(
        CF_Color.make,
      )} ${t.size->External.optString} ${t.other->Option.getOr("")}`
}

type styles = {
  text?: TextStyle.t,
  rawText?: TextStyle.raw,
  dimens?: CF_Dimens.t,
  border?: CF_Border.t,
  box?: CF_BoxShadow.t,
  align?: array<CF_Align.t>,
  other?: string,
}

let encode = (t: styles) => {
  `${t.text->Option.mapOr("", x => TextStyle.typographyEncode(x))} ${t.dimens->Option.mapOr("", x =>
      CF_Dimens.encode(x)
    )} ${t.border->Option.mapOr("", x => CF_Border.encode(x))} ${t.box->Option.mapOr("", x =>
      CF_BoxShadow.encode(x)
    )} ${t.align->Option.mapOr("", x => CF_Align.encodeAll(x))} ${t.other->Option.getOr("")}`
}

let overrideWithSnd: (styles, styles) => styles = %raw(`
  function override(fst, snd){
    let result = {...fst}
    for(let k of Object.keys(snd)){
      if (typeof fst[k] == "object" && fst[k] != null && !Array.isArray(fst[k])){
        result[k] = override(fst[k], snd[k])
      }else{
        result[k] = snd[k]
      }
    }
    return result
  }
`)
