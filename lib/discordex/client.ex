defmodule Discordex.Client do
  defstruct [:name, :token, :intents, :consumer]

  @type t :: %__MODULE__{
          name: atom(),
          token: String.t(),
          intents: [Discordex.Types.Intent.t()],
          consumer: module()
        }

end
