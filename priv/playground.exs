key = "YOUR KEY"
[id, hexsecret] = key |> String.split(":")
{:ok, secret} = hexsecret |> Base.decode16(case: :lower)
url = "YOUR DOMAIN"

headers = %{
  alg: "HS256",
  kid: id
}

iat = DateTime.utc_now() |> DateTime.to_unix()

payload = %{
  iat: iat,
  exp: iat + 5 * 60,
  aud: "/v2/admin/"
}

signer = Joken.Signer.create("HS256", secret, headers)
{:ok, token} = Joken.Signer.sign(payload, signer)
headers = [Authorization: "Ghost #{token}", "Content-Type": "application/json"]

{:ok, body} = Ghostex.Doc.new("hello", "world!", ["test", "api"]) |> Jason.encode(pretty: true)

{:ok, %HTTPoison.Response{:status_code => 201, :body => body}} =
  HTTPoison.post("#{url}/ghost/api/v2/admin/posts/", body, headers)

body |> Jason.decode() |> IO.inspect()
