defmodule PaginateInfiniteScrollPatchWeb.Paginate do
  use PaginateInfiniteScrollPatchWeb, :live_view

  import PaginateInfiniteScrollPatchWeb.PaginateComponent

  def render(assigns) do
    ~H"""
    <.link patch={~p"/paginate?tab=a"}>Tab A</.link>
    <.link patch={~p"/paginate?tab=b"}>Tab B</.link>

    <div :if={true}>
      <.paginate_component :if={@active_tab == "a"} id="comp" />
    </div>

    <div :if={@active_tab == "b"} class="space-y-4">
      Tab B
    </div>
    """
  end

  def handle_params(params, uri, socket) do
    active_tab = active_tab(params["tab"])

    {:noreply, assign(socket, :active_tab, active_tab)}
  end

  defp active_tab("a"), do: "a"
  defp active_tab("b"), do: "b"
  defp active_tab(_), do: "a"
end
