defmodule HackerNewsAggregatorEx.Utils do
  @page_size 10

  @spec paginate(any) :: %{current_page: any, pages: [list], total_pages: non_neg_integer}
  def paginate(list) do
    pages = Enum.chunk_every(list, @page_size)
    current_page = Enum.at(pages, 0)

    %{
      pages: pages,
      current_page: current_page,
      total_pages: length(pages)
    }
  end

  @spec get_page(any, any) :: {:error, :page_not_found} | {:ok, any}
  def get_page(page, %{total_pages: total_pages} = pagination) when page <= total_pages do
    page = page - 1
    current_page = Enum.at(pagination.pages, page)

    {:ok, current_page}
  end

  def get_page(_, _) do
    {:error, :page_not_found}
  end
end
