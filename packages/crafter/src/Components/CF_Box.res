@react.component
let make = (
  ~children,
  ~className="",
  ~paddingStyle="p-4",
  ~borderColor=CF_Color.Gray(#400),
  ~borderStyle="border rounded-md border-2 border-solid",
  ~backgroundColor=CF_Color.Gray(#0),
  ~onClick=_ => (),
) => {
  <div
    onClick={onClick}
    className={`${CF_Color.makeBg(backgroundColor)} ${borderStyle} ${CF_Color.makeBorder(
        borderColor,
      )} ${paddingStyle} ` ++
    className}>
    {children}
  </div>
}
