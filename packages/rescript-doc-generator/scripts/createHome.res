open Node
type filepath = string
type moduleName = string
let capitalize: string => string = %raw(`
  function(s){
    return s[0].toUpperCase() + s.slice(1)
  }
`)
let dummy = destinationFilePath => {
  Fs.writeFileSync(
    destinationFilePath,
    `
@react.component
let make = () => {
  <div/>
}
  `,
  )->ignore
}
let create = (toc_tree: Dict.t<JSON.t>, destinationPath: filepath, sources) => {
  let sidebarInput = []
  toc_tree->Dict.forEachWithKey((v, k) => {
    let groupName =
      v
      ->JSON.Decode.object
      ->Option.getOr(Dict.make())
      ->Dict.get("groupName")
      ->Option.flatMap(JSON.Decode.string)
      ->Option.getOr("")
    let idx = sidebarInput->Array.findIndexOpt(e => e["groupName"] == groupName)
    switch idx {
    | Some(ix) => {
        let g = Array.getUnsafe(sidebarInput, ix)
        let el = {
          "groupName": groupName,
          "inputs": g["inputs"]->Array.concat([{"label": k}]),
        }
        sidebarInput->Array.set(ix, el)
      }
    | None => sidebarInput->Array.push({"groupName": groupName, "inputs": [{"label": k}]})
    }
  })
  let input =
    "[" ++
    sidebarInput
    ->Array.map(e => {
      let inputs =
        "[" ++
        e["inputs"]
        ->Array.map(i => {
          let componentName = i["label"] ++ "_Gen_Doc.make"
          `{label: "${i["label"]}", onSelect: < ${componentName} />}`
        })
        ->Array.join(",") ++ "]"
      `{groupName: "${e["groupName"]}", inputs: ${inputs}}`
    })
    ->Array.join(",") ++ "]"

  let content = `
    @react.component
    let make = () => {
      <CF_Sidebar inputGroups={${input}}/>
    }
    `
  Fs.writeFileSync(destinationPath, content)->ignore
}
