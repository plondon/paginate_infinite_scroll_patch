defmodule PaginateInfiniteScrollPatchWeb.Factory do
  alias Faker

  def post_factory() do
    %PaginateInfiniteScrollPatch.Post{
      title: Faker.Lorem.sentence(),
      body: Faker.Lorem.paragraph()
    }
  end
end
