@react.component
let make = (~children, ~className="") => {
  <div
    className={`w-full h-full ${CF_Color.makeBg(CF_Color.Gray(#100))} border border-2 rounded-md`}>
    <div className="w-full h-full overflow-auto">
      <div className={"p-8 overflow-auto " ++ className}>
        <div className="overflow-auto"> {children} </div>
      </div>
    </div>
  </div>
}
