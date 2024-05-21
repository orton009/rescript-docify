import { Fragment as _Fragment, jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import * as CF_CodeExample from "./../src/Components/CF_CodeExample.bs.js";
function _createMdxContent(props) {
  const _components = {
    em: "em",
    h1: "h1",
    li: "li",
    p: "p",
    strong: "strong",
    ul: "ul",
    ...props.components
  };
  if (!CF_CodeExample)
    _missingMdxReference("CF_CodeExample", false);
  if (!CF_CodeExample.make)
    _missingMdxReference("CF_CodeExample.make", true);
  return _jsxs(_Fragment, {
    children: [_jsx("h1", {
      children: " CF_Color "
    }), "\n", _jsx("h2", {
      id: "value-colorScheme",
      children: " colorScheme "
    }), "\n", "\n", _jsx(CF_CodeExample.make, {
      code: "let colorScheme: Core.Dict.t<Core.Dict.t<string>>",
      lang: "rescript"
    }), "\n", _jsx("h2", {
      id: "type-opacity",
      children: " opacity "
    }), "\n", "\n", "\n", _jsx(_components.h1, {
      children: "Welcome to my MDX page!"
    }), "\n", _jsxs(_components.p, {
      children: ["This is some ", _jsx(_components.strong, {
        children: "bold"
      }), " and ", _jsx(_components.em, {
        children: "italics"
      }), " text."]
    }), "\n", _jsx(_components.p, {
      children: "This is a list in markdown:"
    }), "\n", _jsxs(_components.ul, {
      children: ["\n", _jsx(_components.li, {
        children: "One"
      }), "\n", _jsx(_components.li, {
        children: "Two"
      }), "\n", _jsx(_components.li, {
        children: "Three"
      }), "\n"]
    }), "\n", "\n", _jsx("div", {
      children: " React here"
    }), "\n", _jsx("h2", {
      id: "type-t",
      children: " t "
    }), "\n", "\n", "\n", _jsx("h2", {
      id: "value-encodeColor",
      children: " encodeColor "
    }), "\n", "\n", "\n", _jsx("h2", {
      id: "value-make",
      children: " make "
    }), "\n", "\n", "\n", _jsx("h2", {
      id: "value-makeBg",
      children: " makeBg "
    }), "\n", "\n", "\n", _jsx("h2", {
      id: "value-makeBorder",
      children: " makeBorder "
    }), "\n", "\n", "\n", _jsx("h2", {
      id: "value-makeHex",
      children: " makeHex "
    }), "\n", "\n", "\n", _jsx("h2", {
      id: "value-makeStroke",
      children: " makeStroke "
    }), "\n", "\n"]
  });
}
function MDXContent(props = {}) {
  const { wrapper: MDXLayout } = props.components || {};
  return MDXLayout ? _jsx(MDXLayout, {
    ...props,
    children: _jsx(_createMdxContent, {
      ...props
    })
  }) : _createMdxContent(props);
}
function _missingMdxReference(id, component) {
  throw new Error("Expected " + (component ? "component" : "object") + " `" + id + "` to be defined: you likely forgot to import, pass, or provide it.");
}
export {
  MDXContent as default
};
