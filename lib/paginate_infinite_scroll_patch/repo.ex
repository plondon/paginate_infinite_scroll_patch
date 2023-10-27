defmodule PaginateInfiniteScrollPatch.Repo do
  use Ecto.Repo,
    otp_app: :paginate_infinite_scroll_patch,
    adapter: Ecto.Adapters.Postgres
end
