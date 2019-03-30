defmodule Ueberauth.Strategy.OpenAM.Attributes do
  @doc "Parse an OpenAM identity/attributes response into a map of attributes"
  def parse(body) do
    body
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, "=", parts: 2, trim: true)))
    |> Enum.reduce(%{}, parser())
    |> Map.delete(:_)
  end

  defp parser do
    update = fn
      current, value when is_list(current) -> current++[value]
      current, value                       -> [current]++[value]
    end

    fn 
      ["userdetails.attribute.name", new_key], acc -> Map.put(acc, :_, String.to_atom(new_key))
      ["userdetails.attribute.value", value],  acc -> Map.update(acc, acc[:_], value, &(update.(&1, value))) 
      _,                                       acc -> acc
    end
  end
end