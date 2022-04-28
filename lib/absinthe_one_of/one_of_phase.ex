defmodule AbsintheOneOf.Phase do
  @behaviour Absinthe.Phase
  alias Absinthe.Blueprint

  def run(blueprint, _config) do
    result = Blueprint.prewalk(blueprint, &handle_node/1)
    {:ok, result}
  end

  defp handle_node(
         %Absinthe.Blueprint.Input.Argument{
           input_value: %Blueprint.Input.Value{
             normalized: %Absinthe.Blueprint.Input.Object{schema_node: schema_node} = input_object
           }
         } = node
       ) do
    schema_node = Absinthe.Type.unwrap(schema_node)

    if Keyword.get(schema_node.__private__, :one_of) == true do
      count = Enum.count(input_object.fields)

      if count > 1 do
        Absinthe.Phase.put_error(node, error(node, count))
      else
        node
      end
    else
      node
    end
  end

  defp handle_node(node) do
    node
  end

  defp error(node, count) do
    %Absinthe.Phase.Error{
      phase: __MODULE__,
      message:
        "OneOf Object \"#{node.name}\" must have exactly one non-null field but got #{count}.",
      locations: [node.source_location]
    }
  end
end
