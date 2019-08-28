# ghostex
Ghost blog client library for Elixir.
It's work in progress, so please do not use it.


# Requirements
- Ghost `admin api key'. Please create new one on `{YOUR GHOST API URL}/ghost/#/settings/integrations/new`.

# Install
Add `:ghostex` to your project deps:
```elixir
def deps do
  [
    # ...
    {:ghostex, "~> 0.2.1"},
    # ...
  ]
end
```

# Usage
```elixir
alias Ghostex.Doc
# declare your admin api key here
admin_api_key = "d7f97d66265234665800be85170ae42:e4b59eaf9f4767e56f96753e0e6c91929dcb0284c2b101059bce954fd"
api_url = "https://blog.example.org"
{:ok, client} = Ghostex.start_link [admin_api_key, api_url]

post1 = %Doc{
	title: "my new post",
	tags: ["test", "ghostex"],
	authors: ["guess@me.com"],
	markdown: "markdown content goes here..."
}

client |> Ghostex.post([post1])
:ok
```


