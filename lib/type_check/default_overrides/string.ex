defmodule TypeCheck.DefaultOverrides.String do
  alias __MODULE__
  alias Elixir.TypeCheck.DefaultOverrides.Erlang
  use TypeCheck
  @type! codepoint() :: t()

  @type! grapheme() :: t()

  @type! pattern() :: t() | [t()] | Erlang.Binary.cp()

  import TypeCheck.Type.StreamData
  @type! t() :: wrap_with_gen(binary(), &String.printable_string_gen/0)

  # Rather than arbitrary binaries, use printable strings,
  # and make it a bit more likely that strings are ASCII
  if Code.ensure_loaded?(StreamData) do
    def printable_string_gen do
      StreamData.one_of([StreamData.string(:ascii), StreamData.string(:printable)])
    end
  else
    def printable_string_gen do
      raise TypeCheck.CompileError, "This function requires the optional dependency StreamData."
    end
  end
end
