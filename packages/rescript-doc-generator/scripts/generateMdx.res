module Docgen = RescriptTools.Docgen
open Node

let encodeCodeString = (code: string) => code->String.replaceAllRegExp(%re("/\"/g"), "\\\"")

external asAny: 'a => 'b = "%identity"

%%raw(`
import {read} from "to-vfile";
`)

@module("unified")
external unified: {..} = "unified"
@module("remark-parse")
external remarkParse: {..} = "default"
@module("remark-rehype")
external remarkRehype: {..} = "default"
@module("rehype-raw")
external rehypeRaw: {..} = "default"
@module("rehype-stringify")
external rehypeStringify: {..} = "default"

let astTransform = %raw(`
    function mapper(ast, parent){
      let regex = /%\(([\s\S]*?)\)%/g
      let parseAndRenderCode = line => {
          let code = line.replace(regex, "$1")
          return "<CF_CodeWrapper code={\"" + encodeCodeString(code) + "\"} lang={\"res\"} > {" + code + "} </CF_CodeWrapper>"
      }

      let mapChildren = () => {
        if (ast.children.length > 0) {
          let children = []
          for(let c of ast.children){
            children.push(mapper(c, ast))
          }
          ast.children = children
        }
      }
      if (ast.type == "root") {
        mapChildren()
      }
      if (ast.type == "raw") {

        if(ast.value.match(regex)){
          ast.value = parseAndRenderCode(ast.value)
        }
      }
      if (ast.type == "text") {
        if(ast.value.match(regex)){
          ast.value = parseAndRenderCode(ast.value)
          parent.type = "raw"
          parent.tagName = undefined
          parent.value = parent.children.reduce((acc, e) => {
            return acc + "\n" + e.value
          } , "")
        }else{
          ast.value = "{\"" + encodeCodeString(ast.value) + "\"->React.string}";
        }
      }
      if (ast.type == "element") {
        switch (ast.tagName) { // Fixed the syntax of switch statement
          case "cite":
            ast.tagName = "Markdown.Cite.make";
            break;
          case "info":
            ast.tagName = "Markdown.Info.make";
            break;
          case "warn":
            ast.tagName = "Markdown.Warn.make";
            break;
          case "image":
            ast.tagName = "Markdown.Image.make";
            break;
          case "video":
            ast.tagName = "Markdown.Video.make";
            break;
          case "p":
            ast.tagName = "Markdown.P.make";
            break;
          case "li":
            ast.tagName = "Markdown.Li.make";
            break;
          case "h1":
            ast.tagName = "Markdown.H1.make";
            break;
          case "h2":
            ast.tagName = "Markdown.H2.make";
            break;
          case "h3":
            ast.tagName = "Markdown.H3.make";
            break;
          case "h4":
            ast.tagName = "Markdown.H4.make";
            break;
          case "h5":
            ast.tagName = "Markdown.H5.make";
            break;
          case "ul":
            ast.tagName = "Markdown.Ul.make";
            break;
          case "ol":
            ast.tagName = "Markdown.Ol.make";
            break;
          case "hr":
            ast.tagName = "Markdown.Hr.make";
            break;
          case "strong":
            ast.tagName = "Markdown.Strong.make";
            break;
          case "a":
            ast.tagName = "Markdown.A.make";
            break;
          case "pre":
            // ast.tagName = "Markdown.Pre.make";
            ast.tagName=undefined
            break;
          case "blockquote":
            ast.tagName = "Markdown.Blockquote.make";
            break;
          case "code":
            ast.tagName=undefined
            // ast.tagName = "Markdown.Code.make";
            let value = ast.children.reduce((acc, c) => acc + "\n" + c.value, "")
            parent.value = parseAndRenderCode(value)
            ast.type="raw"
            ast.value=""
            ast.children = []
            parent.type = "raw"
            break;
        }
        mapChildren()
       }
       return ast
     }
`)

let stylize = async content => {
  let rendered = %raw(`
       async (unified, remarkParse, remarkRehype, rehypeRaw,rehypeStringify, content) => {
         function logContent() {
           return (tree) => {
            tree = astTransform(tree, tree)
             return tree
           };
         }
         const file = await unified().use(remarkParse).use(remarkRehype, {"allowDangerousHtml": true}).use(logContent).use(rehypeStringify, {"allowDangerousHtml": true}).process(content)
         return String(file)
       }`)
  await rendered(unified, remarkParse, remarkRehype, rehypeRaw, rehypeStringify, content)
}

type rec node = {
  name: string,
  path: array<string>,
  children: array<node>,
}

type field = {
  name: string,
  docstrings: array<string>,
  signature: string,
  optional: bool,
  deprecated: Js.Null.t<string>,
}
type constructor = {
  name: string,
  docstrings: array<string>,
  signature: string,
  deprecated: Js.Null.t<string>,
}

type detail =
  | Record({items: array<field>})
  | Variant({items: array<constructor>})

type item =
  | Value({
      id: string,
      docstrings: array<string>,
      signature: string,
      name: string,
      deprecated: Js.Null.t<string>,
    })
  | Type({
      id: string,
      docstrings: array<string>,
      signature: string,
      name: string,
      deprecated: Js.Null.t<string>,
      detail: Js.Null.t<detail>,
    })

type module_ = {
  id: string,
  docstrings: array<string>,
  deprecated: Js.Null.t<string>,
  name: string,
  items: array<item>,
}

type api = {
  module_: module_,
  toctree: node,
}

let getModuleJson = (moduleName: string, mainModule: Js.Dict.t<Js.Json.t>, tree) => {
  Js.Dict.entries(mainModule)->Js.Array2.map(((modulePath, content)) => {
    let {items, docstrings, deprecated, name} = Docgen.decodeFromJson(content)
    let id = switch content {
    | Object(dict) =>
      switch Js.Dict.get(dict, "id") {
      | Some(String(s)) => s
      | _ => ""
      }
    | _ => ""
    }
    let items = items->Js.Array2.map(item =>
      switch item {
      | Docgen.Value({id, docstrings, signature, name, ?deprecated}) =>
        Value({
          id,
          docstrings,
          signature,
          name,
          deprecated: deprecated->Js.Null.fromOption,
        })
      | Type({id, docstrings, signature, name, ?deprecated, ?detail}) =>
        let detail = switch detail {
        | Some(kind) =>
          switch kind {
          | Docgen.Record({items}) =>
            let items = items->Js.Array2.map(
              ({name, docstrings, signature, optional, ?deprecated}) => {
                {
                  name,
                  docstrings,
                  signature,
                  optional,
                  deprecated: deprecated->Js.Null.fromOption,
                }
              },
            )
            Record({items: items})->Js.Null.return
          | Variant({items}) =>
            let items = items->Js.Array2.map(
              ({name, docstrings, signature, ?deprecated}) => {
                {
                  name,
                  docstrings,
                  signature,
                  deprecated: deprecated->Js.Null.fromOption,
                }
              },
            )

            Variant({items: items})->Js.Null.return
          }
        | None => Js.Null.empty
        }
        Type({
          id,
          docstrings,
          signature,
          name,
          deprecated: deprecated->Js.Null.fromOption,
          detail,
        })
      | _ => assert(false)
      }
    )
    let module_ = {
      id,
      name,
      docstrings,
      deprecated: deprecated->Js.Null.fromOption,
      items,
    }
    let toctree = tree->Js.Dict.get(moduleName)
    let processedModule = switch toctree {
    | Some(toctree) => Ok({module_, toctree: (Obj.magic(toctree): node)})
    | None => Error(`Failed to find toctree to ${modulePath}`)
    }
    processedModule
  })
}

let encodeDocstrings = async s => {
  let data = await stylize(
    s
    ->Js.Array2.joinWith("\\n")
    ->Js.String2.replaceByRe(%re("/\\n/g"), "\n")
    ->Js.String2.replaceByRe(%re("/\\\"/g"), "\""),
  )
  data != "" ? `<div className="my-4"> ${data} </div>` : ""
}

let parseDocFileWithAST = async (~moduleName, ~docFileAST, ~tree, ~docFileContent) => {
  let modules = getModuleJson(moduleName, docFileAST, tree)->Array.sliceToEnd(~start=1)
  let getAllDocStrings = module_ => {
    switch module_ {
    | Ok({module_: {id, name, docstrings, items}}) => {
        let accumulate = docstrings
        accumulate->Array.concat(
          items->Array.reduce([], (acc, item) => {
            switch item {
            | Value(v) => acc->Array.concat(v.docstrings)
            | Type(t) => acc->Array.concat(t.docstrings)
            }
          }),
        )
      }
    | _ => []
    }
  }
  let content = await Js.Promise2.all(
    modules->Array.map(async mod => {
      let allDocStrings = getAllDocStrings(mod)
      let encodedDocStrings = await encodeDocstrings(allDocStrings)
      let encodedComponent = switch mod {
      | Ok({module_: {id, name, docstrings, items}}) =>
        if id->String.split(".")->Array.length == 2 {
          `<CF_CodeWrapper code={"${encodeCodeString(
              docFileContent,
            )}"} lang={"res"}> <${id}/> </CF_CodeWrapper>`
        } else {
          ""
        }
      | Error(_) => ""
      }
      encodedDocStrings ++ "\n" ++ encodedComponent
    }),
  )
  content->Array.reduce("", (acc, el) => acc ++ "\n" ++ el)
}

let default = async (
  ~moduleName,
  ~mainModule,
  ~tree,
  ~destinationFilePath,
  ~docFileAST,
  ~docFileContent,
) => {
  let moduleResult = getModuleJson(moduleName, mainModule, tree)
  let encodeCodeString = (code: string) => code->String.replaceAllRegExp(%re("/\"/g"), "\\\"")
  let codeExampleString = switch docFileAST {
  | Some(ast) => await parseDocFileWithAST(~moduleName, ~docFileAST=ast, ~tree, ~docFileContent)
  | None => ""
  }
  let mdxContent = await Js.Promise2.all(
    moduleResult->Js.Array2.map(async result => {
      let response = switch result {
      | Ok({module_: {id, name, docstrings, items}}) => {
          let encodedDocStrings = await encodeDocstrings(docstrings)
          let valuesAndType = await Js.Promise2.all(
            items->Js.Array2.map(async item => {
              switch item {
              | Value({name, signature, docstrings, _}) =>
                let encodedDocStrings = await encodeDocstrings(docstrings)
                let code = Js.String2.replaceByRe(signature, %re("/\\n/g"), "\n")
                let _slugPrefix = "value-" ++ name
                `
<Markdown.H2.make> {"${name}"->React.string} </Markdown.H2.make>
< CF_CodeExample code={"${code->encodeCodeString}"} lang="res" />
${encodedDocStrings}`
              | Type({name, signature, docstrings, deprecated}) =>
                let encodedDocStrings = await encodeDocstrings(docstrings)
                let code = Js.String2.replaceByRe(signature, %re("/\\n/g"), "\n")
                let _slugPrefix = "type-" ++ name
                `
<Markdown.H2.make> {"${name}"->React.string} </Markdown.H2.make>
/*  <DeprecatedMessage deprecated="${deprecated->asAny}"/> */
< CF_CodeExample code={"${code->encodeCodeString}"} lang="res" />
${encodedDocStrings}`
              }
            }),
          )
          `
<Markdown.H1.make> {"${name}"->React.string} </Markdown.H1.make>
${encodedDocStrings}
${valuesAndType->Js.Array2.joinWith("\n")}`
        }
      | _ => ""
      }
      response
    }),
  )
  let rescriptContent = `
@react.component
let make = () => {
   <div className="gap-6 flex flex-col">
   <div> ${codeExampleString} </div>
   ${mdxContent->Js.Array2.joinWith("")}
   </div>
}
 `
  Fs.writeFileSync(Path.join([destinationFilePath]), rescriptContent)
}
