include Core__Global
module DataView = {
  include RescriptCore.DataView
}
module BigInt = Core__BigInt
module Null = Core__Null
module Object = Core__Object
module Ordering = Core__Ordering
module RegExp = Core__RegExp
module Symbol = Core__Symbol
module Type = Core__Type

module Iterator = Core__Iterator
module AsyncIterator = Core__AsyncIterator
module WeakMap = Core__WeakMap
module WeakSet = Core__WeakSet

module ArrayBuffer = Core__ArrayBuffer
module TypedArray = Core__TypedArray
module Float32Array = Core__Float32Array
module Float64Array = Core__Float64Array
module Int8Array = Core__Int8Array
module Int16Array = Core__Int16Array
module Int32Array = Core__Int32Array
module Uint8Array = Core__Uint8Array
module Uint16Array = Core__Uint16Array
module Uint32Array = Core__Uint32Array
module Uint8ClampedArray = Core__Uint8ClampedArray
module BigInt64Array = Core__BigInt64Array
module BigUint64Array = Core__BigUint64Array

module Intl = Core__Intl

@val external window: Dom.window = "window"
@val external document: Dom.document = "document"
@val external globalThis: {..} = "globalThis"

external null: Core__Nullable.t<'a> = "#null"
external undefined: Core__Nullable.t<'a> = "#undefined"
external typeof: 'a => Core__Type.t = "#typeof"

type t<'a> = Js.t<'a>
module MapperRt = Js.MapperRt
module Internal = Js.Internal
module Exn = Js.Exn

type null<+'a> = Js.null<'a>

type undefined<+'a> = Js.undefined<'a>

type nullable<+'a> = Js.nullable<'a>

let panic = Core__Error.panic

module Dict = {
  include RescriptCore.Dict
  let entries = Js.Dict.entries
}

module Array = {
  include RescriptCore.Array
  let sortInPlaceWith = Js_array2.sortInPlaceWith
}

module Option = {
  include RescriptCore.Option
  let keep = Belt.Option.keep
  let toResult = (optional: option<'a>, error: 'b) =>
    switch optional {
    | Some(data) => Belt.Result.Ok(data)
    | None => Belt.Result.Error(error)
    }
  let toBool = (opt: option<bool>) =>
    switch opt {
    | Some(x) => x
    | None => false
    }
  let mapNone = (opt, fn) => {
    switch opt {
    | Some(_) => ()
    | None => fn()
    }
  }
  let mapOrElse = (opt: option<'a>, okFn: 'a => 'b, noneFn: unit => 'b) => {
    switch opt {
    | Some(x) => okFn(x)
    | None => noneFn()
    }
  }
  let flatMapNone = (opt, fn) => {
    switch opt {
    | None => fn()
    | other => other
    }
  }
  let makeResult = (
    optional: option<'a>,
    okMapper: 'a => RescriptCore.Result.t<'a, 'b>,
    errorMapper: unit => RescriptCore.Result.t<'a, 'b>,
  ): RescriptCore.Result.t<'a, 'b> =>
    switch optional {
    | Some(data) => okMapper(data)
    | None => errorMapper()
    }
}
module JSON = {
  open RescriptCore.Option
  open RescriptCore
  include RescriptCore.JSON
  module DecodeExtras = {
    // external int: int => JSON.t = "%identity"
    let int = json => JSON.Decode.float(json)->map(Float.toInt)
    let toDict = json => JSON.Decode.object(json)->getOr(Dict.make())
    let toString = json => JSON.Decode.string(json)->getOr("")
    let toFloat = json => JSON.Decode.float(json)->getOr(0.0)
    let toInt = json => JSON.Decode.float(json)->getOr(0.0)->Float.toInt
    let toArray = json => JSON.Decode.array(json)->getOr([])
    let toBoolean = json => JSON.Decode.bool(json)->getOr(false)
  }
  module Getters = {
    let getStringAtKey = (json, key) =>
      DecodeExtras.toDict(json)->Dict.get(key)->map(JSON.Decode.string)
    let getFloatAtKey = (json, key) => DecodeExtras.toDict(json)->Dict.get(key)->map(Decode.float)
    let getIntAtKey = (json, key) => DecodeExtras.toDict(json)->Dict.get(key)->map(DecodeExtras.int)
    let getBooleanAtKey = (json, key) =>
      DecodeExtras.toDict(json)->Dict.get(key)->map(JSON.Decode.bool)
    let getArrayAtKey = (json, key) =>
      DecodeExtras.toDict(json)->Dict.get(key)->map(JSON.Decode.array)
  }
}
module Promise = {
  include RescriptCore.Promise
}
module Math = {
  include RescriptCore.Math
}
module Re = {
  include RescriptCore.Re
}
module List = {
  include RescriptCore.List
}
module Id = {
  include Belt.Id
}

module Error = {
  include RescriptCore.Error
}

module Result = {
  include RescriptCore.Result
  let toOption = result =>
    switch result {
    | Ok(data) => Some(data)
    | _ => None
    }
  let mapError = (result: t<'a, 'b>, fn: 'b => 'c) =>
    switch result {
    | Ok(_) => result
    | Error(err) => Error(fn(err))
    }
  let keepMapError = (result: t<'a, 'b>, fn: 'b => t<'a, 'c>) =>
    switch result {
    | Ok(_) => result
    | Error(err) => fn(err)
    }
  let getOrElse = (result: t<'a, 'b>, errorFn: 'b => 'c, okFn: 'a => 'c) =>
    switch result {
    | Ok(a) => okFn(a)
    | Error(err) => errorFn(err)
    }
}
module External = {
  external asAny: 'a => 'b = "%identity"
  external asString: 'a => string = "%identity"
  external encodeVariant: 'a => string = "%identity"
  let optString = (a: option<'a>) => a->Option.map(asString)->Option.getOr("")
}
module Console = {
  include RescriptCore.Console
}
module Float = {
  include RescriptCore.Float
}
module Int = {
  include RescriptCore.Int
}
module Nullable = {
  include RescriptCore.Nullable
}
module String = {
  include RescriptCore.String
  let camelize: string => string = %raw(`
    function camelize(str) {
    return str.replace(/(?:^\w|[A-Z]|\b\w)/g, function(word, index) {
      return index === 0 ? word.toLowerCase() : word.toUpperCase();
    }).replace(/\s+/g, '');
  }`)
  let toTitleCase: string => string = %raw(`function titleCase(str) {
    var splitStr = str.toLowerCase().split(' ');
    for (var i = 0; i < splitStr.length; i++) {
        // You do not need to check if i is larger than splitStr length, as your for does that for you
        // Assign it back to the array
        splitStr[i] = splitStr[i].charAt(0).toUpperCase() + splitStr[i].substring(1);
    }
    // Directly return the joined string
    return splitStr.join(' ');
  }`)
}
module Date = {
  include RescriptCore.Date
}
module Exception = {
  include RescriptCore.Exn
}
module Set = {
  include Belt.MutableSet
}
module Stack = {
  include Belt.MutableStack
}
module Map = {
  include RescriptCore.Map
}
module Queue = {
  include Belt.MutableQueue
}

module Spice = {
  include Spice
  let makeVariantDecoder = (~variants: array<'a>, ~json: Js.Json.t): Result.t<'a, 'b> => {
    variants
    ->External.asAny
    ->Array.find(a => a == json->JSON.DecodeExtras.toString)
    ->Option.makeResult(
      v => Ok(v),
      () =>
        Spice.error(
          ~path="",
          `could not find corresponding variant for string ${json->JSON.DecodeExtras.toString}`,
          json,
        ),
    )
    ->External.asAny
  }

  let logError = (result: Result.t<'a, Spice.decodeError>) => {
    switch result {
    | Ok(ok) => Ok(ok)
    | Error(e) => {
        Console.log2("Error while decoding", e)
        Error(e)
      }
    }
  }

  let consumeAndLogError = result => result->logError->Result.toOption
  let consumeAndLogAllError = (result: array<Result.t<'a, Spice.decodeError>>) => {
    let error = []
    let maybe =
      result
      ->Array.map(r => {
        switch r {
        | Ok(v) => Some(v)
        | Error(e) => {
            error->Array.push(e)
            None
          }
        }
      })
      ->Array.keepSome
    Console.log2("Error while decoding", error)
    maybe
  }
}
