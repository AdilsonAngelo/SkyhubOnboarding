defmodule PhxProject.ProductsCtx.ProductReport do
  import Ecto.Changeset

  alias PhxProject.ProductsCtx.Product
  alias PhxProject.ProductsCtx.ProductData

  @headers [:id, :inserted_at, :updated_at] ++ Product.get_attrs()

  def generate_report() do
    filepath = gen_filepath()
    file = File.open!(filepath, [:write, :utf8])

    CSV.encode([@headers], delimiter: "\n")
    |> Enum.each(&IO.write(file, &1))

    ProductData.list()
    |> Enum.map(&product_to_csv_row/1)
    |> CSV.encode(delimiter: "\n")
    |> Enum.each(&IO.write(file, &1))

    File.close(file)

    {:ok, filepath}
  end

  def read_report(filepath) do
    [_ | tail] = File.stream!(filepath)
    |> CSV.decode!(headers: @headers)
    |> Enum.map(&csv_row_to_product/1)
    tail
  end

  def product_to_csv_row(%Product{} = p) do
    Enum.map(@headers, fn field -> Map.get(p, field) end)
  end

  def csv_row_to_product(row) do
    cast(%Product{}, row, @headers)
    |> apply_changes()
  end

  defp gen_filepath() do
    prefix = "#{File.cwd!}/data/"
    File.mkdir_p!(prefix)

    prefix <> "product_report_#{get_timestamp()}.csv"
  end

  defp get_timestamp(datetime \\ DateTime.utc_now()) do
    "#{DateTime.to_iso8601(datetime)}"
  end
end
