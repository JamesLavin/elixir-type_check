defmodule TypeCheck.Builtin.Function do
  defstruct []

  use TypeCheck
  @opaque! t :: %TypeCheck.Builtin.Function{}
  @type! problem_tuple :: {t(), :no_match, %{}, any()}

  defimpl TypeCheck.Protocols.ToCheck do
    def to_check(s, param) do
      quote generated: true, location: :keep do
        case unquote(param) do
          x when is_function(x) ->
            {:ok, [], unquote(param)}

          _ ->
            {:error, {unquote(Macro.escape(s)), :no_match, %{}, unquote(param)}}
        end
      end
    end
  end

  defimpl TypeCheck.Protocols.Inspect do
    def inspect(_, opts) do
      "function()"
      |> Inspect.Algebra.color(:builtin_type, opts)
    end
  end

  # if Code.ensure_loaded?(StreamData) do
  #   defimpl TypeCheck.Protocols.ToStreamData do
  #     def to_gen(_s) do
  #       raise "Not implemented yet. PRs are welcome!"
  #     end
  #   end
  # end
end
