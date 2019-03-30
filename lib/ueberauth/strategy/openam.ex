defmodule Ueberauth.Strategy.OpenAM do
  @moduledoc """
  OpenAM Strategy for Überauth. Redirects the user to an OpenAM 
  login page and verifies the auth token the OpenAM server returns 
  after a successful login.
  The login flow looks like this:
  1. User is redirected to the OpenAM server's login page by
    `Ueberauth.Strategy.OpenAM.handle_request!`
  2. User signs in to the OpenAM server.
  3. OpenAM server redirects back to the Elixir application, sending
     an auth token as an HTTP Cookie header.
  4. This auth token is validated by this Überauth OpenAM strategy,
     fetching the user's information at the same time.
  5. User can proceed to use the Elixir application.
  """

  use Ueberauth.Strategy

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Extra
  alias Ueberauth.Strategy.OpenAM

  @doc """
  Ueberauth `request` handler. Redirects to the OpenAM server's login page.
  """
  def handle_request!(conn) do
    conn
    |> redirect!(redirect_url(conn))
  end

  @doc """
  Ueberauth after login callback with a valid OpenAM Cookie.
  """
  def handle_callback!(%Plug.Conn{} = conn) do
    handle_token(conn, conn.cookies[OpenAM.API.sso_cookie()])
  end

  @doc "Ueberauth UID callback."
  def uid(conn), do: conn.private.openam_user.uid

  @doc """
  Ueberauth extra information callback. Returns all attributes the OpenAM
  server returned about the user that authenticated.
  """
  def extra(conn) do
    %Extra{
      raw_info: %{
        user: conn.private.openam_user
      }
    }
  end

  @doc """
  Ueberauth user information.
  """
  def info(conn) do
    user = conn.private.openam_user

    %Info{
      email: user.mail,
      name: Enum.join([user.givenName, user.sn], " "),
      nickname: user.uid
    }
  end

  defp redirect_url(conn) do
    OpenAM.API.login_url
    |> URI.merge("?goto=#{callback_url(conn)}")
    |> URI.to_string
  end

  defp handle_token(conn, nil) do
    conn
    |> set_errors!([error("missing_sso_cookie", "No OpenAM SSO cookie received")])
  end

  defp handle_token(conn, token) do
    token
    |> fetch_user
    |> handle_token_response(conn)
  end

  defp handle_token_response({:ok, user}, conn) do
    conn
    |> put_private(:openam_user, user)
  end

  defp handle_token_response({:error, reason}, conn) do
    conn
    |> set_errors!([error(reason.exception, reason)])
  end
  
  defp fetch_user(token) do
    token
    |> OpenAM.API.redeem_token()
  end
end