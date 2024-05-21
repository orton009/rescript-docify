module Clipboard = {
  @react.component
  let make = (~className="") =>
    <svg
      className={"stroke-current " ++ className}
      xmlns="http://www.w3.org/2000/svg"
      width="16"
      height="16"
      viewBox="0 0 24 24"
      fill="none"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round">
      <path d="M16 4h2a2 2 0 012 2v14a2 2 0 01-2 2H6a2 2 0 01-2-2V6a2 2 0 012-2h2" />
      <rect x="8" y="2" width="8" height="4" rx="1" ry="1" />
    </svg>
}

let langShortname = (lang: string) =>
  switch lang {
  | "ocaml" => "ml"
  | "reasonml"
  | "reason" => "re"
  | "bash" => "sh"
  | "text" => ""
  | rest => rest
  }

module DomUtil = {
  @scope("document") @val external createElement: string => Dom.element = "createElement"
  @scope("document") @val external createTextNode: string => Dom.element = "createTextNode"
  @send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
  @send external removeChild: (Dom.element, Dom.element) => unit = "removeChild"

  @set external setClassName: (Dom.element, string) => unit = "className"

  type classList
  @get external classList: Dom.element => classList = "classList"
  @send external toggle: (classList, string) => unit = "toggle"

  type animationFrameId
  @scope("window") @val
  external requestAnimationFrame: (unit => unit) => animationFrameId = "requestAnimationFrame"

  @scope("window") @val
  external cancelAnimationFrame: animationFrameId => unit = "cancelAnimationFrame"
}

module CopyButton = {
  let copyToClipboard: string => bool = %raw(`
  function(str) {
    try {
      const el = document.createElement('textarea');
      el.value = str;
      el.setAttribute('readonly', '');
      el.style.position = 'absolute';
      el.style.left = '-9999px';
      document.body.appendChild(el);
      const selected =
        document.getSelection().rangeCount > 0 ? document.getSelection().getRangeAt(0) : false;
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
        if (selected) {
          document.getSelection().removeAllRanges();
          document.getSelection().addRange(selected);
        }
        return true;
      } catch(e) {
        return false;
      }
    }
    `)

  type state =
    | Init
    | Copied
    | Failed

  @react.component
  let make = (~code) => {
    let (state, setState) = React.useState(_ => Init)

    let buttonRef = React.useRef(Js.Nullable.null)

    let onClick = evt => {
      ReactEvent.Mouse.preventDefault(evt)
      if copyToClipboard(code) {
        setState(_ => Copied)
      } else {
        setState(_ => Failed)
      }
    }

    React.useEffect(() => {
      switch state {
      | Copied =>
        open DomUtil
        let buttonEl = Js.Nullable.toOption(buttonRef.current)->Belt.Option.getExn

        // Note on this imperative DOM nonsense:
        // For Tailwind transitions to behave correctly, we need to first paint the DOM element in the tree,
        // and in the next tick, add the opacity-100 class, so the transition animation actually takes place.
        // If we don't do that, the banner will essentially pop up without any animation
        let bannerEl = createElement("div")
        bannerEl->setClassName(
          "opacity-0 absolute -top-6 right-0 -mt-5 -mr-4 px-4 py-2 w-40 rounded-lg captions text-white bg-stonegray-100 text-stonegray-80-tr transition-all duration-1000 ease-in-out ",
        )
        let textNode = createTextNode("Copied to clipboard")

        bannerEl->appendChild(textNode)
        buttonEl->appendChild(bannerEl)

        let nextFrameId = requestAnimationFrame(() => {
          bannerEl->classList->toggle("opacity-0")
          bannerEl->classList->toggle("opacity-100")
        })

        let timeoutId = Js.Global.setTimeout(() => {
          buttonEl->removeChild(bannerEl)
          setState(_ => Init)
        }, 3000)

        Some(
          () => {
            cancelAnimationFrame(nextFrameId)
            Js.Global.clearTimeout(timeoutId)
          },
        )
      | _ => None
      }
    }, [state])
    //Copy-Button
    <button
      ref={ReactDOM.Ref.domRef(buttonRef)} disabled={state === Copied} className="relative" onClick>
      <Clipboard
        className="text-stonegray-30 mt-px hover:cursor-pointer hover:text-stonegray-60 hover:bg-stonegray-30 w-6 h-6 p-1 rounded transition-all duration-300 ease-in-out"
      />
    </button>
  }
}

@react.component
let make = (~highlightedLines=[], ~code: string, ~showLabel=true, ~lang="text") => {
  let children = HighlightJs.renderHLJS(~highlightedLines, ~code, ~lang, ())
  let copyButton = <CopyButton code={code} />

  let label = if showLabel {
    let label = langShortname(lang)
    <div className="absolute right-1 top-0 p-1 font-sans text-12 font-bold text-stonegray-30">
      <div className="flex flex-row gap-2 items-center">
        <span>
          {//RES or JS Label
          Js.String2.toUpperCase(label)->React.string}
        </span>
        {copyButton}
      </div>
    </div>
  } else {
    React.null
  }

  <div
    //normal code-text without tabs

    className="relative w-full flex-col rounded xs:rounded border border-stonegray-20 bg-jp-dark-blue-200 pt-2 text-jp-light-yellow-600">
    label
    <div className="px-5 text-14 pt-4 pb-4 overflow-x-auto whitespace-pre"> children </div>
  </div>
}

module Toggle = {
  type tab = {
    highlightedLines: option<array<int>>,
    label: option<string>,
    lang: option<string>,
    code: string,
  }

  @react.component
  let make = (~tabs: array<tab>) => {
    let (selected, setSelected) = React.useState(_ => 0)

    switch tabs {
    | [tab] =>
      make({
        highlightedLines: ?tab.highlightedLines,
        code: tab.code,
        lang: ?tab.lang,
        showLabel: true,
      })
    | multiple =>
      let numberOfItems = Js.Array.length(multiple)
      let tabElements = Belt.Array.mapWithIndex(multiple, (i, tab) => {
        // if there's no label, infer the label from the language
        let label = switch tab.label {
        | Some(label) => label
        | None =>
          switch tab.lang {
          | Some(lang) => langShortname(lang)->Js.String2.toUpperCase
          | None => Belt.Int.toString(i)
          }
        }

        let activeClass = if selected === i {
          "font-medium text-12 text-stonegray-40 bg-stonegray-5 border-t-2 first:border-l"
        } else {
          "font-medium text-12 hover:text-stonegray-60 border-t-2 bg-stonegray-20 hover:cursor-pointer"
        }

        let onClick = evt => {
          ReactEvent.Mouse.preventDefault(evt)
          setSelected(_ => i)
        }
        let key = label ++ ("-" ++ Belt.Int.toString(i))

        let paddingX = switch numberOfItems {
        | 1
        | 2 => "sm:px-4"
        | 3 => "lg:px-8"
        | _ => ""
        }

        let borderColor = if selected === i {
          "#696B7D #EDF0F2"
        } else {
          "transparent"
        }

        <span
          key
          style={ReactDOM.Style.make(~borderColor, ())}
          className={paddingX ++
          (" flex-none px-5 inline-block p-1 first:rounded-tl " ++
          activeClass)}
          onClick>
          {React.string(label)}
        </span>
      })

      let children =
        Belt.Array.get(multiple, selected)
        ->Belt.Option.map(tab => {
          let lang = Belt.Option.getWithDefault(tab.lang, "text")
          HighlightJs.renderHLJS(~highlightedLines=?tab.highlightedLines, ~code=tab.code, ~lang, ())
        })
        ->Belt.Option.getWithDefault(React.null)

      // On a ReScript tab, always copy or open the ReScript code. Otherwise, copy the current selected code.
      let isReScript = tab =>
        switch tab.lang {
        | Some("res") | Some("rescript") => true
        | _ => false
        }

      let buttonDiv = switch Js.Array2.findi(multiple, (tab, index) =>
        tab->isReScript || index === selected
      ) {
      | Some({code: ""}) => React.null
      | Some(tab) =>
        ()

        let copyButton = <CopyButton code={tab.code} />

        <div className="flex items-center justify-end h-full pr-4 space-x-2"> copyButton </div>
      | None => React.null
      }

      <div className="relative pt-6 w-full rounded-none text-stonegray-80">
        //text within code-box
        <div
          className="absolute flex w-full font-sans bg-transparent text-14 text-stonegray-40 "
          style={ReactDOM.Style.make(~marginTop="-26px", ())}>
          <div className="flex xs:ml-0"> {React.array(tabElements)} </div>
          <div
            className="flex-1 w-full bg-stonegray-20 border-b rounded-tr border-stonegray-20 items-center">
            buttonDiv
          </div>
        </div>
        <div
          className="px-4 lg:px-5 text-14 pb-4 pt-4 overflow-x-auto bg-stonegray-10 border-stonegray-20 rounded-b border">
          <pre> children </pre>
        </div>
      </div>
    }
  }
}
