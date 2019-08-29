# ghostex
Ghost blog client library for Elixir.
It's work in progress, so please do not use it.
This library only suppors `post` at the moment.
I have plans to develop a complete API, but for now it's limited.


# Requirements
- Ghost `admin api key`. Please create new one on `{YOUR GHOST API URL}/ghost/#/settings/integrations/new`.

# Install
Add `:ghostex` to your project deps:
```elixir
def deps do
  [
    # ...
    {:ghostex, "~> 0.1.1"},
    # ...
  ]
end
```

# Usage
```elixir
    iex> admin_api_key = "d7f97d66265234665800be85170ae42:e4b59eaf9f4767e56f96753e0e6c91929dcb0284c2b101059bce954fd"
    iex> api_url = "https://blog.example.org"
    iex> {:ok, client} = Ghostex.Client.start_link [admin_api_key, api_url]
    iex> resp = client |> Ghostex.Client.post("hi there", "Wow, __here__", ["test", "api"])
    :ok
```
See the docs for more information.


