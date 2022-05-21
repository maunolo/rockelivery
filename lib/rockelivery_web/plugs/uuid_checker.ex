defmodule RockeliveryWeb.Plugs.UUIDChecker do
  import Plug.Conn

  alias Ecto.UUID
  alias Plug.Conn
  alias Rockelivery.Error

  def init(options), do: options

  def call(%Conn{params: %{"id" => id}} = conn, _opts) do
    case UUID.cast(id) do
      {:ok, _uuid} -> conn
      :error -> render_error(conn)
    end
  end

  def call(conn, _opts), do: conn

  defp render_error(conn) do
    error = Error.build_id_format_error()
    body = Jason.encode!(%{message: error.result})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(error.status, body)
    |> halt()
  end
end
