let removeTrailingZero = (numeric_str: string) => {
  numeric_str
  ->Float.fromString
  ->Option.getOr(0.)
  ->Float.toString
}
type boundingClient = {x: int, y: int, width: int, height: int}
@send external getBoundingClientRect: Dom.element => boundingClient = "getBoundingClientRect"
external domProps: {..} => JsxDOM.domProps = "%identity"

module ProgressBar = {
  @react.component
  let make = (
    ~selectedProgress,
    ~progress: float,
    ~progressPoints: array<('a, float)>,
    ~progressColor: CF_Color.t,
    ~hoverProgressColor: CF_Color.t,
    ~baseColor: CF_Color.t,
    ~onClick: (('a, float)) => unit,
    ~barWidth: string=`w-full`,
    ~tooltip,
  ) => {
    let (showTooltip, setShowTooltip) = React.useState(_ => None)
    let checkPoints = (
      checkPointList: array<('a, float)>,
      currentValue: float,
      onClick: (('a, float)) => unit,
    ) => {
      let finishedCheckPointList =
        currentValue == 0.0
          ? []
          : checkPointList->Array.filter(((_data, progress)) => {progress <= currentValue})
      let unFinishedCheckPointList =
        currentValue == 0.0
          ? checkPointList
          : checkPointList->Array.filter(((_data, progress)) => {progress > currentValue})
      let finishedCheckPoints = finishedCheckPointList->Js.Array2.mapi((point, _idx) => {
        let (_data, progress) = point
        let leftPercent = progress == 0.0 ? 1.0 : progress == 100.0 ? 98.0 : progress
        let currentInFocus = showTooltip->Option.map(t => t == progress)->Option.toBool
        let sizeClass = progress == selectedProgress || currentInFocus ? `h-5 w-5` : `h-3.5 w-3.5`
        let color = currentInFocus ? hoverProgressColor : progressColor
        let innerDiv =
          <div
            className={`${sizeClass} ${color->CF_Color.makeBg} ring-[3px] ring-white drop-shadow border-3 border-gray-100 rounded-full`}
          />
        <div
          className={`absolute cursor-pointer`}
          style={ReactDOMStyle.make(~left=`${leftPercent->Float.toString}%`, ())}
          onMouseOver={_ => setShowTooltip(_ => Some(progress))}
          onMouseOut={_ => setShowTooltip(_ => None)}
          onClick={_ => {
            onClick(point)
          }}>
          {currentInFocus ? tooltip(point, innerDiv) : innerDiv}
        </div>
      })
      let unFinishedCheckPoints = unFinishedCheckPointList->Array.map(point => {
        let (_data, progress) = point
        let leftPercent = progress == 0.0 ? 1.0 : progress == 100.0 ? 98.0 : progress
        let innerDiv =
          <div
            className={`h-3.5 w-3.5 ${CF_Color.Gray(
                #400,
              )->CF_Color.makeBg} ring-[3px] ring-white drop-shadow border-3 border-gray-100 rounded-full`}
          />
        <div
          className={`absolute`}
          style={ReactDOMStyle.make(~left=`${leftPercent->Float.toString}%`, ())}
          onMouseOver={_ => setShowTooltip(_ => Some(progress))}
          onMouseOut={_ => setShowTooltip(_ => None)}>
          {showTooltip->Option.isSome ? tooltip(point, innerDiv) : innerDiv}
        </div>
      })

      finishedCheckPoints
      ->Array.concatMany([unFinishedCheckPoints])
      ->React.array
    }

    <div className={`relative z-0 h-2.5 ${barWidth} ${baseColor->CF_Color.makeBg} rounded-full`}>
      <div
        className={`h-full ${progressColor->CF_Color.makeBg} rounded-full`}
        style={ReactDOMStyle.make(~width=`${progress->Float.toString}%`, ())}
      />
      <div className={`absolute z-10 inset-0 h-full w-full rounded-full `}>
        <div className={`relative flex flex-row items-center h-full w-full`}>
          {checkPoints(progressPoints, progress, onClick)}
        </div>
      </div>
    </div>
  }
}

@react.component
let make = (
  ~selectedProgress: option<float>=?,
  ~progress: float,
  ~progressPoints: array<('a, float)>,
  ~progressColor: CF_Color.t,
  ~hoverProgressColor: CF_Color.t=CF_Color.Gray(#200),
  ~baseColor: CF_Color.t=CF_Color.Gray(#200),
  ~progressText: option<string>=?,
  ~additionalInfoText: option<string>=?,
  ~bgColor: CF_Color.t=CF_Color.Gray(#0),
  ~onClick: (('a, float)) => unit=_ => (),
  ~tooltip: (('a, float), React.element) => React.element=(_, _) => React.null,
  ~customCSS: option<string>=?,
) => {
  let selectedProgress = selectedProgress->Option.getOr(progress)
  let progressString = `${progress
    ->Float.toFixedWithPrecision(~digits=1)
    ->removeTrailingZero}%`

  let infoText = (text: option<string>) => {
    if text->Option.isSome {
      <CF_Typography.TextSemiBold text={text->Option.getOr("")} textColor=CF_Color.Gray(#1000) />
    } else {
      React.null
    }
  }

  <div
    className={`flex flex-col h-full w-full ${bgColor->CF_Color.makeBg} justify-center items-center ${customCSS->Option.getOr(
        "",
      )}`}>
    <hr />
    <div className="flex flex-col w-full items-center py-2">
      <ProgressBar
        progress
        selectedProgress
        progressPoints
        progressColor
        hoverProgressColor
        baseColor
        onClick
        tooltip
      />
      <div className={`flex flex-row w-full justify-between items-center py-3`}>
        <div className={`flex flex-row items-center gap-3`}>
          <CF_Typography.TextSemiBold text={progressString} textSize=#"text-3xl" />
          {infoText(progressText)}
        </div>
        {infoText(additionalInfoText)}
      </div>
    </div>
  </div>
}
