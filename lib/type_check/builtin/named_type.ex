defmodule TypeCheck.Builtin.NamedType do
  defstruct [:name, :type]

  defimpl TypeCheck.Protocols.ToCheck do
    def to_check(s, param) do
      inner_check = TypeCheck.Protocols.ToCheck.to_check(s.type, param)
      quote location: :keep do
        case unquote(inner_check) do
          {:ok, bindings} ->
            # Write it to a non-hygienic variable
            # that we can read from more outer-level types
            # unquote(Macro.var(s.name, TypeCheck.Builtin.NamedType)) = unquote(param)
            {:ok, [{unquote(s.name), unquote(param)} | bindings]}
          {:error, problem} ->
            {:error, {unquote(Macro.escape(s)), :named_type, %{problem: problem}, unquote(param)}}
        end
      end
    end
  end

  defimpl TypeCheck.Protocols.Inspect do
    def inspect(literal, opts) do
      to_string(literal.name)
      |> Inspect.Algebra.glue("::")
      |> Inspect.Algebra.glue(TypeCheck.Protocols.Inspect.inspect(literal.type, opts))
      |> Inspect.Algebra.group
    end
  end


  defimpl TypeCheck.Protocols.ToTypespec do
    def to_typespec(s) do
      quote do
        unquote(Macro.var(s.name, nil)) :: unquote(TypeCheck.Protocols.ToTypespec.to_typespec(s.type))
      end
    end
  end

  if Code.ensure_loaded?(StreamData) do
    defimpl TypeCheck.Protocols.ToStreamData do
      def to_gen(s) do
        TypeCheck.Protocols.ToStreamData.to_gen(s.type)
      end
    end
  end
end
