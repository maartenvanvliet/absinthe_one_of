defmodule AbsintheOneOfTest do
  use ExUnit.Case
  doctest AbsintheOneOf

  @mutation """
  mutation addPet($pet: PetInput!) {
    addPet(pet: $pet) {
      ... on Cat {
        name
        numberOfLives
      }
      ... on Fish {
        name
      }
      ... on Dog {
        name
      }
      __typename
    }
  }
  """

  test "returns error with multiple inputs" do
    {:ok, result} =
      run(@mutation, AbsintheOneOf.Schema,
        variables: %{
          "pet" => %{
            "cat" => %{
              "name" => "Garfield",
              "numberOfLives" => 9
            },
            "dog" => %{
              "name" => "Odie",
              "wagsTail" => true
            }
          }
        }
      )

    assert %{
             errors: [
               %{
                 locations: [%{column: 10, line: 2}],
                 message: "OneOf Object \"pet\" must have exactly one non-null field but got 2."
               }
             ]
           } = result
  end

  test "returns result with singular inputs" do
    {:ok, result} =
      run(@mutation, AbsintheOneOf.Schema,
        variables: %{
          "pet" => %{
            "cat" => %{
              "name" => "Garfield",
              "numberOfLives" => 9
            }
          }
        }
      )

    assert %{
             data: %{
               "addPet" => %{
                 "__typename" => "Cat",
                 "name" => "Garfield",
                 "numberOfLives" => 9
               }
             }
           } = result
  end

  def run(document, schema, options \\ []) do
    pipeline =
      schema
      |> Absinthe.Pipeline.for_document(options)
      |> Absinthe.Pipeline.insert_after(
        Absinthe.Phase.Document.Validation.OnlyOneSubscription,
        AbsintheOneOf.Phase
      )

    case Absinthe.Pipeline.run(document, pipeline) do
      {:ok, %{result: result}, _phases} ->
        {:ok, result}

      {:error, msg, _phases} ->
        {:error, msg}
    end
  end
end
