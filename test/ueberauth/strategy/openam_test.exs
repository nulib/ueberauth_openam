defmodule Ueberauth.Strategy.OpenAMTest do
  use OpenAM.Case, async: true
  use Plug.Test
  alias Ueberauth.Strategy.OpenAM

  setup tags do
    request = Map.get(tags, :request, %Plug.Conn{cookies: %{}})
    response = Map.get(tags, :response, "")

    MockHTTPoison
    |> expect(:get, fn _, _, _ -> response end)

    conn = OpenAM.handle_callback!(request)

    {:ok, %{request: request, conn: conn}}
  end

  test "redirect callback redirects to login url" do
    conn = conn(:get, "/login") |> OpenAM.handle_request!()
    assert conn.status == 302
  end

  test "login callback without token shows an error", %{conn: conn} do
    assert conn.assigns |> Map.has_key?(:ueberauth_failure)
  end

  describe "invalid callback" do
    @describetag request: %Plug.Conn{cookies: %{"openAMssoToken" => @token}},
                 response: {:error, %HTTPoison.Error{reason: @error_body}}

    test "returns error message", %{conn: conn} do
      assert [%{message: %{message: message}} | _] = conn.assigns.ueberauth_failure.errors
      assert message == "Token is NULL"
    end
  end

  describe "valid callback" do
    @describetag request: %Plug.Conn{cookies: %{"openAMssoToken" => @token}},
                 response:
                   {:ok, %HTTPoison.Response{status_code: 200, body: @ok_body, headers: []}}

    test "returns user details", %{conn: conn} do
      assert %{
               mail: "archie.charles@example.edu",
               sn: "Charles"
             } = conn.private.openam_user
    end

    test "extracts uid", %{conn: conn} do
      assert OpenAM.uid(conn) == "abc123"
    end

    test "generates an info struct", %{conn: conn} do
      assert %{
               email: "archie.charles@example.edu",
               name: "Archie B. Charles",
               nickname: "abc123"
             } = OpenAM.info(conn)
    end

    test "generates a raw_info struct", %{conn: conn} do
      assert OpenAM.extra(conn).raw_info.user == conn.private.openam_user
    end
  end
end
