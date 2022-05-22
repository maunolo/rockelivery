defmodule RockeliveryWeb.Plugs.AtomizeParams do
  alias Plug.Conn
  alias Rockelivery.Utils.Map, as: MapUtil

  def init(options), do: options

  def call(%Conn{params: params} = conn, _opts) do
    Map.put(conn, :params, MapUtil.atomize_keys(params))
  end
end
