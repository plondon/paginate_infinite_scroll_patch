defmodule DataMigration do
  def migrate() do
    for _ <- 1..100 do
      %PaginateInfiniteScrollPatch.Post{
        title: Faker.Lorem.sentence(),
        body: Faker.Lorem.paragraph()
      }
      |> PaginateInfiniteScrollPatch.Repo.insert()
    end
  end
end
