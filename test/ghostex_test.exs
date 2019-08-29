defmodule GhostexTest do
  use ExUnit.Case
  alias Ghostex.Client
  doctest Client

  setup_all do
    admin_api_key = System.get_env("GHOST_ADMIN_API_KEY")
    api_domain = System.get_env("GHOST_API_DOMAIN")
    {:ok, client} = Client.start_link([admin_api_key, api_domain])

    on_exit(fn ->
      Process.exit(client, :normal)
    end)

    {:ok, %{client: client}}
  end

  describe "client" do
    test "successful authentication", %{:client => client} do
      assert client |> Process.alive?()
      assert client |> :sys.get_state() |> Map.get(:last_authentication_epoch) > -1
    end

    test "successful post", %{:client => client} do
      resp = client |> Client.post("hi there", "Wow, __here__", ["test", "api"])
      assert resp == :ok
    end

    test "updating token works", %{:client => client} do
      token = client |> :sys.get_state() |> Map.get(:token)
      client |> send({:update_token})
      Process.sleep(2000)
      new_token = client |> :sys.get_state() |> Map.get(:token)
      refute token == new_token
    end
  end
end
