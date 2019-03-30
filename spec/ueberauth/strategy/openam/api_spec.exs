defmodule Ueberauth.Strategy.OpenAM.API.Spec do
  use ESpec
  alias Ueberauth.Strategy.OpenAM.API

  describe API do
    it do: expect API.login_url |> to(eq "https://openam.example.edu/UI/Login")

    context "token validation" do
      before do: allow HTTPoison |> to(accept :get, fn (_, _, _) -> response() end)

      context "valid token response" do
        let :body, do: shared.ok_body
        let :response, do: {:ok, %HTTPoison.Response{status_code: 200, body: body()}}

        it do
          expect API.redeem_token(shared.token)
          |> to(match_pattern {
            :ok,
            %{
              objectClass: ["organizationalPerson", "person", "inetorgperson", "top"],
              uid: "abc123"
            }
          })
        end
      end

      context "invalid token response" do
        let :body, do: shared.error_body
        let :response, do: {:error, %HTTPoison.Error{reason: body()}}

        it do
          expect API.redeem_token(shared.token)
          |> to(match_pattern {
            :error,
            %{ exception: "com.sun.identity.idsvcs.TokenExpired", message: "Token is NULL" }
          })
        end
      end
    end
  end
end