defmodule Ghostex.Card do
  @moduledoc false

  @derive Jason.Encoder
  @enforce_keys [:markdown]
  defstruct [:markdown, cardName: "markdown"]

  @doc """
    Creates new markdown card.

    You must use this instead of using `%Ghostex.Card{}` directly.

  """
  @spec new(binary()) :: list()
  def new(body) do
    ["markdown", %__MODULE__{markdown: body}]
  end
end

defmodule Ghostex.Mobiledoc do
  @moduledoc false
  alias Ghostex.Card

  @derive Jason.Encoder
  defstruct cards: [Card.new("Edit **me** ...")],
            version: "0.3.1",
            markups: [],
            atoms: [],
            sections: [[10, 0]]

  @doc "creates new mobiledoc with default values and just a single markdown"
  @spec new(binary()) :: any()
  def new(markdown) when is_binary(markdown) do
    mobiledoc = %__MODULE__{}
    %__MODULE__{mobiledoc | cards: [Card.new(markdown)]}
  end

  # @doc "creates new mobiledoc with default values and a list of markdowns"
  # @spec new(list()) :: any()
  # def new(markdown_list) when is_list(markdown_list) do
  #  cards = markdown_list |> Enum.map(fn m -> Card.new(m) end)
  #  mobiledoc = %__MODULE__{}
  #  %__MODULE__{mobiledoc | cards: cards}
  # end
end

defmodule Ghostex.Post do
  @moduledoc false
  @derive Jason.Encoder
  @enforce_keys [:title, :mobiledoc]
  defstruct [:title, :mobiledoc, tags: [], status: "draft"]
end

defmodule Ghostex.Doc do
  @moduledoc false
  # alias Ghostex.Card
  alias Ghostex.Mobiledoc
  alias Ghostex.Post

  @derive Jason.Encoder
  @enforce_keys [:posts]
  defstruct [:posts]

  @spec new(binary(), binary()) :: any()
  def new(title, body) when is_binary(title) and is_binary(body) do
    {:ok, md} = body |> Mobiledoc.new() |> Jason.encode()
    post = %Post{title: title, mobiledoc: md}
    %__MODULE__{posts: [post]}
  end

  @spec new(binary(), binary(), list()) :: any()
  def new(title, body, tags) when is_binary(title) and is_binary(body) and is_list(tags) do
    n = new(title, body)
    %Ghostex.Doc{n | posts: n.posts |> Enum.map(fn p -> %Ghostex.Post{p | tags: tags} end)}
  end
end
