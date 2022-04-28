defmodule AbsintheOneOf.OneOfDirective do
  use Absinthe.Schema.Prototype

  directive :one_of do
    on([:input_object])

    expand(fn
      _args, node ->
        %{node | __private__: Keyword.put(node.__private__, :one_of, true)}
    end)
  end
end
