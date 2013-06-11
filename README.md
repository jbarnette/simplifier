# Simplifier

A Ruby library for simplifying object graphs.

```ruby
require "simplifier"

Simplifier.new.simplify({ :foo => [:bar, "baz", Time.now] })
# => {"foo"=>["bar", "baz", "2013-06-11T00:03:27Z"]}
```

## By default

- `nil`, `true`, and `false` are themselves.
- Symbols are simplified into interned, frozen Strings.
- Strings are UTF-8 with `\n` newlines.
- Strings in the `BINARY` encoding are themselves.
- Arrays and Sets are simplified into Arrays of simplified elements.
- Hashes are simplified into Hashes of simplified keys and values.
- Dates become an ISO 8601 `"yyyy-mm-dd"` String.
- DateTimes and Times become an ISO 8601 `"yyyy-mm-ddThh:mm:ssZ"` String.
- Any other types raise `Simplifier::Unknown`.

## Extending

```ruby
require "simplifier"

class APISimplifier < Simplifier
  def simplify(object)
    case object
    when MyApp::User
      simplify :id => object.id, :name => object.name

    else
      super
    end
  end
end
```

The constructor for `Simplifier` takes an optional configuration Hash and
assigns it to the `options` attribute. This can be useful if you need to
change the simplification of a type depending on embedding or other factors.

## Maintainer

[@jbarnette](https://github.com/jbarnette)
