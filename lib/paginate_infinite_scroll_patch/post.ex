defmodule PaginateInfiniteScrollPatch.Post do
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :body, :string

    timestamps()
  end
end
