defmodule Ueberauth.Strategy.OpenAM.API do
  @moduledoc """
  OpenAM server API implementation.
  """

  alias Ueberauth.Strategy.OpenAM

  @doc "Returns the URL to the OpenAM server's login page"
  def login_url do
    settings(:base_url)
    |> URI.merge("UI/Login")
    |> URI.to_string()
  end

  @doc "Returns the name of the SSO Token cookie"
  def sso_cookie do
    settings(:sso_cookie)
  end

  @doc "Redeem an OpenAM SSO Token for the user attributes"
  def redeem_token(token) do
    attribute_url()
    |> HTTPoison.get([], params: %{subjectid: token})
    |> handle_validate_token_response()
  end

  defp handle_validate_token_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    {:ok, OpenAM.Attributes.parse(body)}
  end

  defp handle_validate_token_response({:error, %HTTPoison.Error{reason: reason}}) do
    {
      :error,
      Regex.named_captures(~r{.+=(?<exception>.+?)\s+(?<message>.+)$}, reason)
      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
      |> Enum.into(%{})
    }
  end

  defp attribute_url do
    settings(:base_url)
    |> URI.merge("identity/attributes")
    |> URI.to_string()
  end

  defp settings(key) do
    {_, settings} = Application.get_env(:ueberauth, Ueberauth)[:providers][:openam]
    settings[key]
  end
end
