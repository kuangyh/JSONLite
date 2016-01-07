# JSONLite

JSONLite is a fast, ``almost'' drop-in read-only replacement of [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON).

I want to replace SwiftyJSON because:

- It gets the JSON parsing API right.
- But it's slow.
- It's slow because it wants to do more, and pays 80% of the performance penalty for 20% of feature bonus.
- I don't need those feature bonus in my project.
- It's slow also because it makes avoidable computation / type casting --- some may because it was developed before Swift 2.0 and stuff we take for granted today simply not existed then.

## API

### Reading fields

Same as SwiftyJSON

    let json = JSONLite(jsonObject)
    let x: Int = json["foo"][0]["bar"].intValue  // default to 0
    let y: Int? = json["foo"].int  // nil when not exists

It also have a set of more convenience (and actually faster) getters.

    let x: Int = json["foo"]  // Same as json["foo"].intValue, Swift type inference works.

But note that you can't do this for Bool, you have to explicitly say

    json["blah"].boolValue

That's because of Bool has .boolValue (aha...) so compiler get confused about which subscript implementation to use.

It doesn't have the key path array magic like SwiftyJSON do, mainly because I don't use it in my project.

On rawValue: unlike SwiftyJSON, rawValue in JSONLite is AnyObject?, otherwise it's neither raw nor clearly defined.

### Array/Dictionary value, and iteration

    for x in json["foo"].arrayValue {
      // Note that x is AnyObject, you only wrap it to JSONLite when you need to.
      // That doesn't add much key strokes but saves CPU.
    }
    for (key, value) in json["bar"].dictValue {
      // :-)
    }

### Mutable interface

JSONLite is read-only --- modifying stuff in the same fashion as read can be confusing --- I don't know what you expect when you set do json["foo"] = "bar" when json is actually an array. And it ads implementation complexity.

Also IMO it's a bad smell if you want to modify / maintain dynamic JSON data in a static language like Swift, you should use a struct and do parse/dump instead --- constructing a JSON object in Swift is quite easy (as easy as any dynamic language).

## Performance

In my current project, which involves frequently parsing > 200K of complex JSON structure, JSON parsing code gets about 4X performance gain.

TODO: detailed benchmark. (I just don't care)

## Under the hood

it's just about 100+ lines of simple Swift code, I don't even bother writing
comments.

It's faster then SwiftyJSON because:

- It lets compiler chooses subscript implementation via. type inference, instead of doing it in runtime.
- It only tries to type cast Dictionary and Array in constructor, because for other types, you would just call only one of the xxxValue once and type casting can happen there.
- In this way, subscript don't need to do case switch.
- When you eliminate the xxxValue part but use return type to indicate subscript implementation, it got (a bit) faster because it don't need to construct another JSONLite object, and save the type casting attempts.

It's straightforward and no magic there, just a simple Swift syntax candy, just copy and paste it and do your own things that matters.

Last but not least, #MonadIsAwesome
