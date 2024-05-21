%%raw(`require("tailwindcss/tailwind.css")`)
// %%raw(`require("./../src/styles/_hljs.css")`)
%%raw(`require("./../src/styles/main.css")`)
@module("../docs/metadata/toc_tree.json")
external toc: Dict.t<JSON.t> = "default"
%%raw(`
  import hljs from 'highlight.js/lib/core'
  import javascript from 'highlight.js/lib/languages/javascript'
  import css from 'highlight.js/lib/languages/css'
  import ocaml from 'highlight.js/lib/languages/ocaml'
  import reason from './../plugins/reason-highlightjs'
  import rescript from 'highlightjs-rescript'
  import bash from 'highlight.js/lib/languages/bash'
  import json from 'highlight.js/lib/languages/json'
  import html from 'highlight.js/lib/languages/xml'
  import text from 'highlight.js/lib/languages/plaintext'
  import diff from 'highlight.js/lib/languages/diff'

  hljs.registerLanguage('reason', reason)
  hljs.registerLanguage('rescript', rescript)
  hljs.registerLanguage('javascript', javascript)
  hljs.registerLanguage('css', css)
  hljs.registerLanguage('ts', javascript)
  hljs.registerLanguage('ocaml', ocaml)
  hljs.registerLanguage('sh', bash)
  hljs.registerLanguage('json', json)
  hljs.registerLanguage('text', text)
  hljs.registerLanguage('html', html)
  hljs.registerLanguage('diff', diff)
`)

let capitalize: string => string = %raw(`
  function(s){
    return s[0].toUpperCase() + s.slice(1)
  }
`)

external eval: string => 'a = "eval"
module StepperTest = {
  type t = {}
  @react.component
  let make = () => {
    <Doc />
  }
}

switch ReactDOM.querySelector("#app") {
| Some(container) =>
  open ReactDOM.Client
  open ReactDOM.Client.Root

  let root = createRoot(container)
  root->render(
    <CF_ThemeContext.ThemeContextProvider value={CF_Theme.defaultLightTheme}>
      // <CF_Container className="w-full h-full">
      <StepperTest />
      // </CF_Container>
    </CF_ThemeContext.ThemeContextProvider>,
  )
| None => ()
}
