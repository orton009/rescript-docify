
  type shadow = [
    | #"shadow-sm"
    | #shadow
    | #"shadow-lg"
    | #"shadow-xl"
    | #"shadow-2xl"
    | #"shadow-inner"
  ]
  type opacity = [
    | #"opacity-0"
    | #"opacity-5"
    | #"opacity-10"
    | #"opacity-15"
    | #"opacity-20"
    | #"opacity-25"
    | #"opacity-30"
    | #"opacity-35"
    | #"opacity-40"
    | #"opacity-45"
    | #"opacity-50"
    | #"opacity-55"
    | #"opacity-60"
    | #"opacity-65"
    | #"opacity-70"
    | #"opacity-75"
    | #"opacity-80"
    | #"opacity-85"
    | #"opacity-90"
    | #"opacity-95"
    | #"opacity-100"
  ]
  type t = {shadow?: shadow, color?: CF_Color.t, opacity?: opacity}
  let encode = (t: t): string =>
    `${t.shadow->External.optString} ${t.color->CF_Color.optEncode(
        CF_Color.makeShadow,
      )} ${t.opacity->External.optString}`
