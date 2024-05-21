/***
Generate docs from ReScript Compiler

## Run

```bash
node scripts/gendocs.mjs path/to/rescript-compiler path/to/rescript-core/src/RescriptCore.res version forceReWrite
```

## Examples

```bash
node scripts/gendocs.mjs path/to/rescript-compiler latest true
```
*/
type vscodeCommands = {executeCommand: (string, string) => Promise.t<unit>}
type vscode = {commands: vscodeCommands}
@module("vscode")
external vscode: vscode = "default"

open Node
module Docgen = RescriptTools.Docgen

let hiddenModules = ["Js.Internal", "Js.MapperRt"]

let getAllFiles: string => array<string> = %raw(`
  function getAllFiles(dirPath) {
    let isFile = (path) => {
      try {
          const stats = Fs.statSync(path);
          return stats.isFile();
      } catch (err) {
          return false;
      }
    }
    if (isFile(dirPath)) {
      return [dirPath]
    }else{
      const files = Fs.readdirSync(dirPath);
      let arrayOfFiles = [];

      files.forEach(function(file) {
        let child = dirPath + "/" + file;
        if (
          file == "node_modules" ||
          file == "dist" ||
          file == "lib" ||
          file == ".yarn"
        ) {}
        else {
          if (Fs.statSync(child).isDirectory()) {
            arrayOfFiles = arrayOfFiles.concat(getAllFiles(dirPath + "/" + file));
          } else if (Path.extname(file) === ".res") {
            arrayOfFiles.push(Path.join(dirPath, "/", file));
          }
        }
      });
      return arrayOfFiles;
    }
  }
`)

type module_ = {
  id: string,
  docstrings: array<string>,
  groupName: string,
  name: string,
  items: array<Docgen.item>,
}

type section = {
  name: string,
  docstrings: array<string>,
  deprecated: option<string>,
  topLevelItems: array<Docgen.item>,
  submodules: array<module_>,
}

type rec node = {
  name: string,
  groupName?: string,
  path: array<string>,
  children: array<node>,
}

let run = (~destinationPath, ~entryPointFiles, ~platform, ~isDocFile=false) => {
  let docsDecoded = entryPointFiles->Js.Array2.map(((group, libFile)) => {
    let output =
      ChildProcess.execSync(
        `./node_modules/@rescript/tools/binaries/${platform}/rescript-tools.exe  doc ${libFile}`,
      )->Buffer.toString
    (
      group,
      output
      ->Js.Json.parseExn
      ->Docgen.decodeFromJson,
    )
  })

  let docs = docsDecoded->Js.Array2.map(((group, doc)) => {
    let topLevelItems = doc.items->Belt.Array.keepMap(item =>
      switch item {
      | Value(_) as item | Type(_) as item => item->Some
      | _ => None
      }
    )

    let rec getModules = (lst: list<Docgen.item>, moduleNames: list<module_>) =>
      switch lst {
      | list{
          Module({id, items, name, docstrings}) | ModuleAlias({id, items, name, docstrings}),
          ...rest,
        } =>
        if Js.Array2.includes(hiddenModules, id) {
          getModules(rest, moduleNames)
        } else {
          let id = Js.String2.startsWith(id, "RescriptCore")
            ? Js.String2.replace(id, "RescriptCore", "Core")
            : id
          getModules(
            list{...rest, ...Belt.List.fromArray(items)},
            list{{id, items, name, docstrings, groupName: group}, ...moduleNames},
          )
        }
      | list{Type(_) | Value(_), ...rest} => getModules(rest, moduleNames)
      | list{} => moduleNames
      }

    // let id = Js.String2.startsWith(doc.name, "RescriptCore") ? "Core" : doc.name
    let id = Js.String2.startsWith(doc.name, "RescriptCore")
      ? Js.String2.replace(doc.name, "RescriptCore", "Core")
      : doc.name

    let top = {id, name: id, docstrings: doc.docstrings, items: topLevelItems, groupName: group}
    let submodules = getModules(doc.items->Belt.List.fromArray, list{})->Belt.List.toArray
    let result = [top]->Js.Array2.concat(submodules)

    (id, result)
  })

  let allModules = {
    open Js.Json
    let encodeItem = (docItem: Docgen.item) => {
      switch docItem {
      | Value({id, name, docstrings, signature, ?deprecated}) => {
          let id = Js.String2.startsWith(id, "RescriptCore")
            ? Js.String2.replace(id, "RescriptCore", "Core")
            : id
          let dict = Js.Dict.fromArray(
            [
              ("id", id->string),
              ("kind", "value"->string),
              ("name", name->string),
              ("docstrings", docstrings->stringArray),
              ("signature", signature->string),
            ]->Js.Array2.concat(
              switch deprecated {
              | Some(v) => [("deprecated", v->string)]
              | None => []
              },
            ),
          )
          dict->object_->Some
        }

      | Type({id, name, docstrings, signature, ?deprecated}) =>
        let id = Js.String2.startsWith(id, "RescriptCore")
          ? Js.String2.replace(id, "RescriptCore", "Core")
          : id
        let dict = Js.Dict.fromArray(
          [
            ("id", id->string),
            ("kind", "type"->string),
            ("name", name->string),
            ("docstrings", docstrings->stringArray),
            ("signature", signature->string),
          ]->Js.Array2.concat(
            switch deprecated {
            | Some(v) => [("deprecated", v->string)]
            | None => []
            },
          ),
        )
        object_(dict)->Some

      | _ => None
      }
    }

    docs->Js.Array2.map(((topLevelName, modules)) => {
      let submodules =
        modules
        ->Js.Array2.map(mod => {
          let items =
            mod.items
            ->Belt.Array.keepMap(item => encodeItem(item))
            ->array

          let id = Js.String2.startsWith(mod.id, "RescriptCore") ? "Core" : mod.id

          let rest = Js.Dict.fromArray([
            ("id", id->string),
            ("name", mod.name->string),
            ("docstrings", mod.docstrings->stringArray),
            ("items", items),
          ])
          (
            mod.id
            ->Js.String2.split(".")
            ->Js.Array2.joinWith("/"),
            rest->object_,
          )
        })
        ->Js.Dict.fromArray

      (topLevelName, submodules)
    })
  }

  allModules->Js.Array2.forEach(((topLevelName, mod)) => {
    let json = Js.Json.object_(mod)

    let topLevelName = Js.String2.startsWith(topLevelName, "RescriptCore") ? "Core" : topLevelName
    if isDocFile {
      Console.log2(
        "here its a doc",
        Path.join([destinationPath, `${topLevelName}${isDocFile ? ".doc" : ""}.json`]),
      )
    }
    Fs.writeFileSync(
      Path.join([destinationPath, `${topLevelName}${isDocFile ? ".doc" : ""}.json`]),
      json->Js.Json.stringifyWithSpace(2),
    )
  })

  // Generate TOC modules
  let joinPath = (~path: array<string>, ~name: string) => {
    Js.Array2.concat(path, [name])->Js.Array2.map(path => path)
  }
  let rec getModules = (lst: list<Docgen.item>, moduleNames, path) => {
    switch lst {
    | list{Module({id, items, name}) | ModuleAlias({id, items, name}), ...rest} =>
      if Js.Array2.includes(hiddenModules, id) {
        getModules(rest, moduleNames, path)
      } else {
        let itemsList = items->Belt.List.fromArray
        let children = getModules(itemsList, [], joinPath(~path, ~name))

        getModules(
          rest,
          Js.Array2.concat([{name, path: joinPath(~path, ~name), children}], moduleNames),
          path,
        )
      }
    | list{Type(_) | Value(_), ...rest} => getModules(rest, moduleNames, path)
    | list{} => moduleNames
    }
  }
  let tocTree = docsDecoded->Js.Array2.map(((group, {name, items})) => {
    let name = Js.String2.startsWith(name, "RescriptCore") ? "Core" : name
    let path = name
    (
      path,
      {
        name,
        groupName: group,
        path: [path],
        children: items
        ->Belt.List.fromArray
        ->getModules([], [path]),
      },
    )
  })
  Console.log2("tocTree", tocTree)
  Fs.writeFileSync(
    Path.join([destinationPath, "toc_tree.json"]),
    tocTree
    ->Js.Dict.fromArray
    ->Js.Json.stringifyAny
    ->Belt.Option.getExn,
  )
}

@spice
type source = {
  sidebarModuleName: string,
  paths: array<string>,
  expanded: bool,
}

@spice
type configFile = {
  @spice.default("darwinarm64") platform: string,
  sources: array<source>,
  rescriptDirectory: string,
  metadataDirectory: string,
  rootFilePath: string,
}
let capitalize: string => string = %raw(`
  function(s){
    return s[0].toUpperCase() + s.slice(1)
  }
`)

let () = {
  let filepath = Process.argv[2]->Option.getOr(Path.join(["doc-generator-config.json"]))
  let text = Fs.readFileSync(filepath)
  try {
    let json = JSON.parseExn(text)
    json
    ->configFile_decode
    ->Result.mapError(e => {
      Console.log2("error while decoding config", e)
      e
    })
    ->Result.map(r => {
      CreateHome.dummy(r.rootFilePath)
      if Fs.existsSync(r.metadataDirectory) {
        ChildProcess.execSync("rm -rf " ++ r.metadataDirectory)->ignore
      }
      if Fs.existsSync(r.rescriptDirectory) {
        ChildProcess.execSync("rm -rf " ++ r.rescriptDirectory)->ignore
      }
      Fs.mkdirSync(r.rescriptDirectory)
      Fs.mkdirSync(r.metadataDirectory)
      let sourceFiles =
        r.sources
        ->Array.map(s => s.paths->Array.map(p => (s.sidebarModuleName, p)))
        ->Array.flat
        ->Array.reduce([], (acc, (group, s)) =>
          acc->Array.concat(getAllFiles(s)->Array.map(p => (group, p)))
        )
      let docSources = sourceFiles->Array.filter(((_, d)) => d->String.includes("_doc.res"))
      let sources = sourceFiles->Array.filter(((_, d)) => !(d->String.includes("_doc.res")))

      run(
        ~destinationPath=r.metadataDirectory,
        ~entryPointFiles=docSources,
        ~platform=r.platform,
        ~isDocFile=true,
      )
      run(~destinationPath=r.metadataDirectory, ~entryPointFiles=sources, ~platform=r.platform)

      let metadataFiles = Fs.readdirSync(r.metadataDirectory)
      let tocTreeFile = r.metadataDirectory ++ "/toc_tree.json"
      let tocTree =
        Fs.readFileSync(tocTreeFile)
        ->JSON.parseExn
        ->JSON.Decode.object
        ->Option.getOr(Dict.make())
      metadataFiles
      ->Array.filter(x => !(x->String.includes(".doc.json")))
      ->Array.forEach(fileWExt => {
        let filepath = r.metadataDirectory ++ "/" ++ fileWExt
        let moduleName = fileWExt->String.replace(".json", "")
        if !(filepath->String.includes("toc_tree")) {
          Console.log(
            "Generating module -----------  " ++ moduleName ++ " from file path " ++ filepath,
          )
          try {
            let docFileASTPath = r.metadataDirectory ++ "/" ++ moduleName ++ "_doc.doc.json"
            let sourceContent =
              Fs.readFileSync(filepath)
              ->JSON.parseExn
              ->JSON.Decode.object
              ->Option.getOr(Dict.make())
            let docFileAST = ref(None)
            if Fs.existsSync(docFileASTPath) {
              docFileAST :=
                Fs.readFileSync(docFileASTPath)
                ->JSON.parseExn
                ->JSON.Decode.object
                ->Option.getOr(Dict.make())
                ->Some
            }
            let destnFilePath =
              r.rescriptDirectory ++ "/" ++ capitalize(moduleName) ++ "_Gen_Doc.res"
            Console.log3("**** Generating MDX Doc at ", destnFilePath, "")

            // vscode.commands.executeCommand("editor.action.formatDocument", destnFilePath)->ignore
            let docFileContent = docFileAST.contents->Option.mapOr(
              "",
              _ =>
                sourceFiles
                ->Array.find(((_, f)) => f->String.endsWith(`/${moduleName}_doc.res`))
                ->Option.mapOr(
                  "",
                  ((_, f)) => {
                    let file = Fs.readFileSyncWithOpts(f, {"encoding": "utf8"})
                    file->String.replaceAllRegExp(%re("/@ocaml\.doc\(`[^`]*`\)/g"), "")
                  },
                ),
            )
            GenerateMdx.default(
              ~moduleName,
              ~mainModule=sourceContent,
              ~tree=tocTree,
              ~destinationFilePath=destnFilePath,
              ~docFileAST=docFileAST.contents,
              ~docFileContent,
            )->ignore
          } catch {
          | err => Console.log2("Error while reading filepath " ++ filepath, err)
          }
        }
      })
      CreateHome.create(tocTree, r.rootFilePath, r.sources)
    })
    ->ignore
  } catch {
  | err => Console.log2("error while decoding config file", err)
  }
}
