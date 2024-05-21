@react.component
let make = (~code, ~lang, ~children) => {
  let (openCode, setOpenCode) = React.useState(_ => false)
  <CF_Col gap=0 className="my-4">
    <CF_Box paddingStyle="px-2 py-2">
      <div className="m-2"> {children} </div>
      <CF_Divider
        direction={#horizontal} width="1px" className="mt-6" color={CF_Color.Gray(#200)}
      />
      <div className="p-2 pt-4 flex flex-row-reverse">
        <CF_Badge
          badgeColor={#Blue}
          text={"< " ++ (openCode ? "Hide Code" : "Show code") ++ " />"}
          badgeType={Solid}
          events={onClick: {_ => setOpenCode(c => !c)}}
          styles={{text: {other: "hover:bg-jp-light-blue-300 cursor-pointer"}}}
        />
      </div>
    </CF_Box>
    {openCode ? <CF_CodeExample code lang /> : React.null}
  </CF_Col>
}
