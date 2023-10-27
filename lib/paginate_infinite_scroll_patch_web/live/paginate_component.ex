defmodule PaginateInfiniteScrollPatchWeb.PaginateComponent do
  use PaginateInfiniteScrollPatchWeb, :live_component

  def paginate_component(assigns) do
    ~H"<.live_component {assigns} module={__MODULE__} />"
  end

  def render(assigns) do
    ~H"""
    <div
      id="posts"
      phx-update="stream"
      phx-viewport-top={@page > 1 && "prev-page"}
      phx-viewport-bottom={!@end_of_timeline? && "next-page"}
      phx-page-loading
      phx-target={@myself}
      class={[
        "space-y-4",
        if(@end_of_timeline?, do: "pb-10", else: "pb-[calc(200vh)]"),
        if(@page == 1, do: "pt-10", else: "pt-[calc(200vh)]")
      ]}
    >
      <div :for={{id, post} <- @streams.posts} class="border" id={id}>
        <h2><%= post.title %></h2>
        <p><%= post.body %></p>
      </div>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> stream_configure(:posts, [])}
  end

  def update(assigns, socket) do
    {:ok,
     assign(socket, assigns) |> assign(:per_page, 20) |> assign(:page, 1) |> paginate_posts(1)}
  end

  def handle_event("next-page", params, socket) do
    dbg("next")
    {:noreply, paginate_posts(socket, socket.assigns.page + 1)}
  end

  def handle_event("prev-page", %{"_overran" => true}, socket) do
    {:noreply, paginate_posts(socket, 1)}
  end

  def handle_event("prev-page", _, socket) do
    if socket.assigns.page > 1 do
      {:noreply, paginate_posts(socket, socket.assigns.page - 1)}
    else
      {:noreply, socket}
    end
  end

  defp paginate_posts(socket, new_page) when new_page >= 1 do
    import Ecto.Query
    dbg("paginate")

    %{per_page: per_page, page: cur_page} = socket.assigns

    posts_query =
      from p in PaginateInfiniteScrollPatch.Post,
        order_by: [desc: p.inserted_at],
        select: p,
        limit: ^per_page,
        offset: ^per_page * (^new_page - 1)

    posts = PaginateInfiniteScrollPatch.Repo.all(posts_query)

    {posts, at, limit} =
      if new_page >= cur_page do
        {posts, -1, per_page * 3 * -1}
      else
        {Enum.reverse(posts), 0, per_page * 3}
      end

    case posts do
      [] ->
        assign(socket, end_of_timeline?: at == -1)

      [_ | _] = posts ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:page, new_page)
        |> stream(:posts, posts, at: at, limit: limit)
    end
  end
end
