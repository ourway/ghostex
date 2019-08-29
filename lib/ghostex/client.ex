defmodule Ghostex.Client do
  @moduledoc """
    Provides required functions to connect to Ghost blog, authenticate and post documents.

    Ghostex clinet is a Gen Server, and need `admin api key` and `api domain` to start.
    You can start it by passing `[key, url]` to `:start_link` function.

  """

  use GenServer
  alias Ghostex.Doc
  alias Joken.Signer
  require Logger
  @token_age 5 * 60

  @impl true
  def init([admin_api_key, api_domain]) do
    {:ok, token, iat} = admin_api_key |> get_token()

    Process.send_after(self(), {:update_token}, @token_age * 1000 - 2000)

    state = %{
      admin_api_key: admin_api_key,
      api_domain: api_domain,
      token: token,
      last_authentication_epoch: iat
    }

    {:ok, state}
  end

  @doc "Starts Ghostex.Client"
  @spec start_link(list()) :: {:ok, any()}
  def start_link([admin_api_key, api_domain]) do
    GenServer.start_link(__MODULE__, [admin_api_key, api_domain])
  end

  @impl true
  def handle_info({:update_token}, state) do
    Logger.debug(fn ->
      "updating ghostex token ..."
    end)

    {:ok, token, iat} = state.admin_api_key |> get_token()
    Process.send_after(self(), {:update_token}, @token_age * 1000 - 2000)
    {:noreply, %{state | last_authentication_epoch: iat, token: token}}
  end

  @impl true
  def handle_call({:post, doc}, _from, state) do
    {:ok, payload} = doc |> Jason.encode()
    headers = [Authorization: "Ghost #{state.token}", "Content-Type": "application/json"]
    resp = "#{state.api_domain}/ghost/api/v2/admin/posts/" |> ghost_post(payload, headers)
    {:reply, resp, state}
  end

  ########## wrappers #############
  @spec post(pid(), binary(), binary(), list()) :: :ok | {:error, atom()}
  def post(client, title, markdown, tags)
      when is_pid(client) and is_binary(title) and is_binary(markdown) and is_list(tags) do
    doc = Doc.new(title, markdown, tags)
    client |> GenServer.call({:post, doc})
  end

  ########## utlis #############

  @spec ghost_post(binary(), binary(), list()) :: :ok | {:error, atom()}
  defp ghost_post(url, payload, headers)
       when is_binary(payload) and is_binary(url) and is_list(headers) do
    case HTTPoison.post(url, payload, headers, hackney: [pool: :ghostex_pool]) do
      {:ok, %HTTPoison.Response{:status_code => 401}} ->
        {:error, :not_authorized}

      {:ok, %HTTPoison.Response{:status_code => 201, :body => body}} ->
        {:ok, _resp} = body |> Jason.decode()
        :ok

      {:error, _} ->
        {:error, :post_error}
    end
  end

  @spec get_token(binary()) :: {:ok, binary(), integer()} | {:error, any()}
  defp get_token(admin_api_key) when is_binary(admin_api_key) do
    [id, hexsecret] = admin_api_key |> String.split(":")
    {:ok, secret} = hexsecret |> Base.decode16(case: :lower)

    headers = %{
      "alg" => "HS256",
      "kid" => id
    }

    iat = DateTime.utc_now() |> DateTime.to_unix()

    payload = %{
      "iat" => iat,
      "exp" => iat + @token_age,
      "aud" => "/v2/admin/"
    }

    signer = Signer.create("HS256", secret, headers)

    {:ok, token} = payload |> Signer.sign(signer)
    {:ok, token, iat}
  end
end
