defmodule MiniSpider.Storage.Options do
  @type option_map :: %{atom() => term()}

  @spec retrieve_typed_option(option_map(), atom(), String.t(), (term() -> as_boolean(term()))) ::
          {:ok, term()} | {:error, term()}
  def retrieve_typed_option(opt_map, key, type_name, type_predicate) do
    with(
      %{^key => value} <- opt_map,
      true <- type_predicate.(value) && true
    ) do
      {:ok, value}
    else
      _ ->
        {:error, ArgumentError.exception("The type of option `#{key}` should be #{type_name}.")}
    end
  end
end
