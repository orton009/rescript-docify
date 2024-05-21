type input<'a> = {
  label: string,
  onSelect: React.element,
}
type inputGroup<'a> = {
  groupName: string,
  inputs: array<input<'a>>,
}

let chevronUp =
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M11.2929 8.29289C11.6834 7.90237 12.3166 7.90237 12.7071 8.29289L18.7071 14.2929C19.0976 14.6834 19.0976 15.3166 18.7071 15.7071C18.3166 16.0976 17.6834 16.0976 17.2929 15.7071L12 10.4142L6.70711 15.7071C6.31658 16.0976 5.68342 16.0976 5.29289 15.7071C4.90237 15.3166 4.90237 14.6834 5.29289 14.2929L11.2929 8.29289Z"
      fill="black"
    />
  </svg>

let chevronDown =
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M5.29289 8.29289C5.68342 7.90237 6.31658 7.90237 6.70711 8.29289L12 13.5858L17.2929 8.29289C17.6834 7.90237 18.3166 7.90237 18.7071 8.29289C19.0976 8.68342 19.0976 9.31658 18.7071 9.70711L12.7071 15.7071C12.3166 16.0976 11.6834 16.0976 11.2929 15.7071L5.29289 9.70711C4.90237 9.31658 4.90237 8.68342 5.29289 8.29289Z"
      fill="black"
    />
  </svg>

@react.component
let make = (~inputGroups: array<inputGroup<'a>>) => {
  let (selected, setSelected) = React.useState(_ =>
    inputGroups
    ->Array.get(0)
    ->Option.flatMap(e => e.inputs->Array.get(0)->Option.map(i => (e.groupName, i)))
  )

  <div className="flex flex-row max-h-screen">
    <div className="overflow-scroll bg-gray-50 w-60 p-2">
      {inputGroups
      ->Array.map(group => {
        let listDOM =
          group.inputs
          ->Array.map(el => {
            let nonSelectedDOM = <CF_Typography.TextMedium text={el.label} textSize={#"text-sm"} />
            let selectedDOM =
              <CF_Typography.TextSemiBold
                textSize={#"text-sm"} text={el.label} textColor={CF_Color.Blue(#900)}
              />
            let isSelected = selected->Option.map(((_, e)) => e.label == el.label)->Option.toBool

            {
              <div className="px-1 py-1">
                <div
                  onClick={_ => setSelected(_ => Some(group.groupName, el))}
                  className={"px-4 py-2 cursor-pointer text-[#000] rounded-lg " ++ {
                    isSelected ? "bg-jp-light-blue-100" : "hover:bg-jp-light-gray-300"
                  }}>
                  {selected->Option.mapOrElse(
                    ((_, el_)) => el_.label == el.label ? selectedDOM : nonSelectedDOM,
                    _ => nonSelectedDOM,
                  )}
                </div>
              </div>
            }
          })
          ->React.array
        let isSelectedGroup = selected->Option.map(((g, _)) => group.groupName == g)->Option.toBool
        <div>
          <div
            className="p-1 flex flex-row items-center font-semibold cursor-pointer justify-between hover:bg-jp-light-gray-300"
            onClick={_ =>
              if !isSelectedGroup {
                setSelected(_ => group.inputs->Array.get(0)->Option.map(i => (group.groupName, i)))
              }}>
            <span> {group.groupName->React.string} </span>
            {!isSelectedGroup ? chevronDown : chevronUp}
          </div>
          <div className="px-2"> {isSelectedGroup ? listDOM : React.null} </div>
        </div>
      })
      ->React.array}
    </div>
    <div className="grow overflow-scroll">
      <CF_Container>
        {selected->Option.mapOr(React.null, ((_, el_)) => el_.onSelect)}
      </CF_Container>
    </div>
  </div>
}
