defmodule Ueberauth.Strategy.OpenAM.APITest do
  use OpenAM.Case, async: true
  alias Ueberauth.Strategy.OpenAM.API

  test "login_url/1" do
    assert API.login_url() == "https://openam.example.edu/UI/Login"
  end

  describe "redeem_token/1" do
    setup %{response: response} do
      MockHTTPoison
      |> expect(:get, fn _, _, _ -> response end)

      :ok
    end

    @tag response: {:ok, %HTTPoison.Response{status_code: 200, body: @ok_body}}
    test "valid token response" do
      assert {:ok,
              %{
                objectClass: ["organizationalPerson", "person", "inetorgperson", "top"],
                uid: "abc123"
              }} = API.redeem_token(@token)
    end

    @tag response: {:error, %HTTPoison.Error{reason: @error_body}}
    test "invalid token response" do
      assert {
               :error,
               %{exception: "com.sun.identity.idsvcs.TokenExpired", message: "Token is NULL"}
             } = API.redeem_token(@token)
    end
  end
end
