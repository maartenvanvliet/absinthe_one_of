defmodule AbsintheOneOf.Schema do
  use Absinthe.Schema

  @prototype_schema AbsintheOneOf.OneOfDirective

  query do
  end

  import_sdl("""
  input PetInput @oneOf {
    cat: CatInput
    dog: DogInput
    fish: FishInput
  }

  input CatInput { name: String!, numberOfLives: Int }
  input DogInput { name: String!, wagsTail: Boolean }
  input FishInput { name: String!, bodyLengthInMm: Int }

  type Mutation {
    addPet(pet: PetInput!): Pet
  }
  union Pet = Cat | Dog | Fish

  type Cat {
    name: String!
    numberOfLives: Int
  }

  type Dog {
    name: String!
    wagsTail: Boolean
  }

  type Fish {
    name: String!
    bodyLengthInMm: Int
  }
  """)

  def hydrate(%{identifier: :add_pet}, [%{identifier: :mutation} | _]) do
    {:resolve, &__MODULE__.add_pet/3}
  end

  def hydrate(%Absinthe.Blueprint.Schema.UnionTypeDefinition{identifier: :pet}, _) do
    {:resolve_type, &__MODULE__.resolve_pet/2}
  end

  def hydrate(_node, _) do
    []
  end

  def resolve_pet(args, _) do
    case args do
      %{number_of_lives: _} -> :cat
      %{wags_tail: _} -> :dog
      _ -> :fish
    end
  end

  def add_pet(_, args, _) do
    {:ok, args.pet |> Map.values() |> List.first()}
  end
end
