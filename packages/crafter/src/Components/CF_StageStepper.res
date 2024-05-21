let toPx = (a: int) => Int.toString(a) ++ "px"

type linearStepperType<'a> = {element: 'a}
type nestedStepperType<'a, 'b> = {
  element: 'a,
  childrens: array<linearStepperType<'b>>,
}
type dimensions = {
  height: int,
  width: int,
}

type stageConnector = Static | Expanded

// type stage<'a, 'b> =
//   | LinearStepper(linearStepperType<'a>)
//   | NestedStepper(nestedStepperType<'a, 'b>)

type connector =
  | IconConnector(React.element)
  | CurvedConnector(CF_Color.t)

type connectorStyle = {
  connector: connector,
  connectorColor: CF_Color.t,
  removeVerticalConnector?: bool,
  showDottedConnector?: bool,
  startRollbackConnector?: (bool, CF_Color.t),
  endRollbackConnector?: bool,
}

let defaultConnectorStyle = {
  connector: IconConnector(
    <CF_SVGIcons.IconWrapper icon=CF_SVGIcons.downArrowActive iconType_={Solid} />,
  ),
  connectorColor: CF_Color.Gray(#200),
}

module LinearStager = {
  @react.component
  let make = (
    ~input: array<linearStepperType<'a>>,
    ~renderLinearStepper: (~stage: linearStepperType<'a>) => React.element,
    // ~onStageExpand: (~stage: stage<'a, 'b>, ~setStage: stage<'a, 'b> => stage<'a, 'b>) => unit,
    ~iconDimens: dimensions,
    ~connectorStyle: connectorStyle,
  ) => {
    let stages = input->Array.length
    let connector =
      <CF_Divider
        length="8px" width="2px" direction={#horizontal} color={connectorStyle.connectorColor}
      />
    let theme = {...CF_Theme.defaultLightTheme, flexStyle: {rowGap: 0, colGap: 0}}
    let paddedVDivider = {
      <CF_Row className={`w-${iconDimens.width->Int.toString}`} alignStyle="justify-center">
        <CF_Divider
          length="20px" width="3px" direction={#vertical} color={connectorStyle.connectorColor}
        />
      </CF_Row>
    }
    let flexibleVDivider = {
      <CF_Divider
        length="100%" width="3px" direction={#vertical} color={connectorStyle.connectorColor}
      />
    }
    let iconDom = switch connectorStyle.connector {
    | IconConnector(dom) => dom
    | _ => <CF_SVGIcons.IconWrapper icon=CF_SVGIcons.dottedRect iconType_={Solid} />
    }

    let linearStepperDom = (el: linearStepperType<'a>, i) => {
      let isLast = i != stages - 1
      <CF_ThemeContext.ThemeContextProvider value=theme>
        <div className="grid grid-cols-[auto_1fr]">
          <CF_Col alignStyle="items-center">
            {iconDom}
            {isLast ? flexibleVDivider : React.null}
          </CF_Col>
          <CF_Row alignStyle="self-start">
            <CF_Row alignStyle={`items-center self-start h-${iconDimens.height->Int.toString}`}>
              {connector}
            </CF_Row>
            <CF_Row alignStyle="items-start"> {renderLinearStepper(~stage=el)} </CF_Row>
          </CF_Row>
        </div>
        {i != input->Array.length - 1 ? paddedVDivider : React.null}
      </CF_ThemeContext.ThemeContextProvider>
    }

    <div className="flex flex-col gap-0">
      {input
      ->Array.mapWithIndex((el, i) => {
        linearStepperDom(el, i)
      })
      ->React.array}
    </div>
  }
}

module NestedStager = {
  @react.component
  let make = (
    ~input: array<nestedStepperType<'a, 'b>>,
    ~renderNestedStepper: (
      ~stage: nestedStepperType<'a, 'b>,
      ~index: int,
    ) => {
      "element": (React.element, connectorStyle),
      "children": array<(React.element, connectorStyle)>,
    },
    ~styles={
      "verticalConnectorGap": 20,
      "horizontalConnectorGap": 10,
      "containerPaddingX": 32,
      "containerPaddingY": 24,
    },
  ) => {
    open Webapi.Dom
    let iconRef: React.ref<Js.Nullable.t<Dom.element>> = React.useRef(Nullable.null)
    let tempIDPrefix = "step_dom_ref_"
    let doms = React.useMemo1(() => {
      let doms = []
      input
      ->Array.mapWithIndex((el, index) => {
        let result = renderNestedStepper(~stage=el, ~index)
        Array.push(doms, result["element"])->ignore
        result["children"]->Array.forEach(
          el => {
            Array.push(doms, el)
          },
        )
      })
      ->ignore
      doms->Array.mapWithIndex(((d, s), index) => {
        (<div id={`${tempIDPrefix}${index->Int.toString}`}> {d} </div>, s)
      })
    }, [input])
    let fixedGap = (doms->Array.length - 1) * styles["verticalConnectorGap"]
    let (itemsDimens, setitemsDimens) = React.useState(_ => None)
    let (iconDimens, seticonDimens) = React.useState(_ => None)
    let inputDomRef: React.ref<Js.Nullable.t<Dom.element>> = React.useRef(Nullable.null)
    let (mountInputDom, setMountInputDom) = React.useState(_ => {"value": false})
    let (containerPaddingH, containerPaddingV) = (
      styles["containerPaddingX"],
      styles["containerPaddingY"],
    )

    React.useEffect1(() => {
      setitemsDimens(_ => None)
      seticonDimens(_ => None)
      None
    }, [doms])

    React.useEffect1(() => {
      inputDomRef.current
      ->Nullable.map(_ref => {
        setitemsDimens(
          _ =>
            doms
            ->Array.mapWithIndex(
              (_, index) => {
                Document.getElementById(
                  document,
                  `${tempIDPrefix}${index->Int.toString}`,
                )->Option.mapOr(
                  {height: 0, width: 0},
                  el_ => {height: Element.clientHeight(el_), width: Element.clientWidth(el_)},
                )
              },
            )
            ->Some,
        )
      })
      ->ignore
      iconRef.current
      ->Nullable.map(ref => {
        seticonDimens(
          _ => Some({
            height: ref->Webapi.Dom.Element.clientHeight,
            width: ref->Webapi.Dom.Element.clientWidth,
          }),
        )
      })
      ->ignore
      None
    }, [mountInputDom])
    let svgContainerDimens = React.useMemo2(() => {
      switch (itemsDimens, iconDimens) {
      | (Some(itemsD), Some(iconD)) => {
          let (itemsHeight, itemsWidth) = itemsD->Array.reduce((0, 0), ((h, w), el) => {
            (h + el.height, Math.max(w->Int.toFloat, el.width->Int.toFloat)->Int.fromFloat)
          })
          Some({
            height: fixedGap + itemsHeight + containerPaddingV + iconD.height,
            width: itemsWidth + containerPaddingH + iconD.width + styles["horizontalConnectorGap"],
          })
        }
      | _ => None
      }
    }, (iconDimens, itemsDimens))
    let verticalConnectorGap = styles["verticalConnectorGap"]
    let svgDom = React.useMemo1(() => {
      switch (iconDimens, itemsDimens, svgContainerDimens) {
      | (Some(iconD), Some(itemsD), Some(containerD)) => {
          let zIndex = ref(50)
          let str = Int.toString
          let (ch, cv) = (containerPaddingH, containerPaddingV)
          let createAbsolute = (~left, ~top, ~dom) => {
            <div className="absolute z-20" style={{top, left}}> {dom} </div>
          }
          let (inputDoms, _, curvedConnectors) = doms->Array.reduceWithIndex(([], cv, []), (
            (collector, cv, curvedConnectors),
            (dom, connectorStyle),
            index,
          ) => {
            open Int

            let isLastElement = index == Array.length(doms) - 1
            let elementHeight = itemsD[index]->Option.mapOr(0, d => d.height)
            let elementLeftSpace = ch + iconD.width + styles["horizontalConnectorGap"]
            let curvedHeight = (Int.toFloat(elementHeight) *. 0.2)->Int.fromFloat
            let elementDOM = [createAbsolute(~left=elementLeftSpace->toPx, ~top=cv->toPx, ~dom)]
            switch connectorStyle.connector {
            | IconConnector(i) =>
              elementDOM->Array.push(createAbsolute(~left=ch->toPx, ~top=cv->toPx, ~dom=i))
            | CurvedConnector(color) => {
                let curvedDom =
                  <path
                    d={`M ${(ch + iconD.width / 2)->toString} ${cv->toString} C ${(ch +
                      iconD.width / 2)->toString} ${(cv + curvedHeight)->toString}, ${(ch +
                      iconD.width * 2 / 3)->toString} ${(cv + curvedHeight)
                        ->toString}, ${elementLeftSpace->toString} ${(cv + curvedHeight)
                        ->toString}`}
                    stroke={CF_Color.makeHex(color)}
                    style={zIndex: (zIndex.contents + 1)->Int.toString}
                    strokeWidth="2px"
                    fill="none"
                  />
                Array.push(curvedConnectors, curvedDom)
              }
            }
            Array.push(collector, elementDOM->React.array)
            let connectorDOM = {
              isLastElement || connectorStyle.removeVerticalConnector->Option.toBool
                ? React.null
                : <line
                    x1={(ch + iconD.width / 2)->str}
                    x2={(ch + iconD.width / 2)->str}
                    y1={(cv + iconD.height / 4)->str}
                    y2={(itemsD[index]->Option.mapOr(0, d => d.height) + cv + verticalConnectorGap)
                      ->str}
                    stroke={CF_Color.makeHex(connectorStyle.connectorColor)}
                    className="w-0.5"
                    strokeWidth="2px"
                    style={zIndex: zIndex.contents->Int.toString}
                    strokeDasharray={connectorStyle.showDottedConnector->Option.toBool ? "2,2" : ""}
                  />
            }
            zIndex := zIndex.contents - 1
            Array.push(curvedConnectors, connectorDOM)
            (collector, cv + elementHeight + verticalConnectorGap, curvedConnectors)
          })
          let verticalHeight = ref(containerPaddingV / 2)
          let rollbackDom = ref(React.null)
          doms->Array.forEachWithIndex(((_, c1), index) => {
            let (start, color) =
              c1.startRollbackConnector->Option.getOr((false, CF_Color.Green(#200)))
            if start {
              let startV =
                verticalHeight.contents + itemsD[index]->Option.mapOr(0, d => d.height) / 2
              verticalHeight :=
                verticalHeight.contents +
                itemsD[index]->Option.mapOr(0, d => d.height) +
                verticalConnectorGap
              doms->Array.forEachWithIndex(
                ((_, c2), ix) => {
                  if ix > index {
                    if c2.endRollbackConnector->Option.toBool {
                      let endV =
                        verticalHeight.contents + itemsD[ix]->Option.mapOr(0, d => d.height) / 2
                      // draw line here
                      let ch = containerPaddingH + iconD.width + styles["horizontalConnectorGap"]
                      let x1 = ch + itemsD[index]->Option.mapOr(0, d => d.width)
                      let x2 = ch + itemsD[ix]->Option.mapOr(0, d => d.width) + 20
                      rollbackDom :=
                        [
                          <circle
                            cx={(x1 + 4)->str} cy={startV->str} r="4" fill={CF_Color.makeHex(color)}
                          />,
                          <line
                            x1={(x1 + 8)->str}
                            x2={x2->str}
                            y1={startV->str}
                            y2={startV->str}
                            stroke={CF_Color.makeHex(color)}
                            className="w-0.5"
                            strokeWidth="2px"
                            strokeDasharray={"2"}
                          />,
                          <line
                            x1={x2->str}
                            x2={x2->str}
                            y1={startV->str}
                            y2={endV->str}
                            stroke={CF_Color.makeHex(color)}
                            strokeWidth="4px"
                            strokeDasharray={"2"}
                          />,
                          <line
                            x1={x2->str}
                            x2={(x1 - 10)->str}
                            y1={endV->str}
                            y2={endV->str}
                            stroke={CF_Color.makeHex(color)}
                            strokeWidth="2px"
                            strokeDasharray={"2"}
                          />,
                          <circle
                            cx={(x1 - 14)->str} cy={endV->str} r="4" fill={CF_Color.makeHex(color)}
                          />,
                        ]->React.array
                    } else {
                      verticalHeight :=
                        verticalHeight.contents +
                        itemsD[ix]->Option.mapOr(0, d => d.height) +
                        verticalConnectorGap
                    }
                  }
                },
              )
              // ->Option.map(
              //   ((dom, _)) => {
              //     // Array.reduceWithIndex(0, (v, d, ix) => {
              //     //   itemsD[ix]->Option.mapOr(0, d => d.height) + v + verticalConnectorGap
              //     // })
              //   },
              // )
              // ->Option.getOr(React.null)
            } else {
              verticalHeight :=
                verticalHeight.contents +
                itemsD[index]->Option.mapOr(0, d => d.height) +
                verticalConnectorGap
            }
          })
          let svgDOM =
            <div className="relative">
              <svg
                height={containerD.height->toPx}
                width={toPx(containerD.width + 20)}
                className="relative z-10">
                {curvedConnectors->React.array}
                {rollbackDom.contents}
              </svg>
              {inputDoms->React.array}
            </div>
          Some(svgDOM)
        }
      | _ => None
      }
    }, [svgContainerDimens])
    let initialDomRender =
      <div>
        <div
          ref={ReactDOM.Ref.callbackDomRef(nullableEl => {
            nullableEl
            ->Nullable.map(_ => {
              if inputDomRef.current != nullableEl {
                setMountInputDom(_ => {"value": true})
                inputDomRef.current = nullableEl
              }
            })
            ->ignore
          })}>
          {doms->Array.map(((el, _)) => el)->React.array}
        </div>
        <div ref={ReactDOM.Ref.domRef(iconRef)} className="w-fit h-fit">
          {doms[0]
          ->Option.flatMap(((_, c)) => {
            switch c.connector {
            | IconConnector(i) => Some(i)
            | _ => None
            }
          })
          ->Option.getOr(<CF_SVGIcons.IconWrapper icon=CF_SVGIcons.dottedRect iconType_={Solid} />)}
        </div>
      </div>
    {svgDom->Option.mapOrElse(d => d, () => {initialDomRender})}
  }
}
