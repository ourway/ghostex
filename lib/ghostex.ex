defmodule Ghostex do
  @moduledoc """
    Ghostex is Ghost library for elixir.

    It's usage is simple, you need your `admin api key` and `api domain`
    to start using it.

    # Example
    ```elixir
      iex> admin_api_key = "d7f97d66265234665800be85170ae42:e4b59eaf9f4767e56f96753e0e6c91929dcb0284c2b101059bce954fd"
      iex> api_url = "https://blog.example.org"
      iex> {:ok, client} = Ghostex.Client.start_link [admin_api_key, api_url]
      iex> resp = client |> Ghostex.Client.post("hi there", "Wow, __here__", ["test", "api"])
      :ok
  ```

  """
end
