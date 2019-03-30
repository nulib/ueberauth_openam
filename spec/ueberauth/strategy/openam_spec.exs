defmodule Ueberauth.Strategy.OpenAM.Spec do
  use ESpec
  use Plug.Test
  alias Ueberauth.Strategy.OpenAM

  describe OpenAM do
    let :request, do: %Plug.Conn{cookies: %{}}
    let :conn, do: OpenAM.handle_callback!(request())
    before do: allow HTTPoison |> to(accept :get, fn (_, _, _) -> response() end)

    it "redirect callback redirects to login url" do
      conn = conn(:get, "/login") |> OpenAM.handle_request!
      expect(conn.status) |> to(eq 302)
    end
  
    it "login callback without token shows an error" do
      expect(conn().assigns) |> to(have_key :ueberauth_failure)
    end

    context "invalid callback" do
      let :request,  do: %Plug.Conn{cookies: %{"openAMssoToken" => shared.token}}
      let :response, do: {:error, %HTTPoison.Error{reason: shared.error_body}}

      it do
        expect(List.first(conn().assigns.ueberauth_failure.errors).message.message) 
        |> to(eq "Token is NULL")
      end
    end

    context "valid callback" do
      let :request,  do: %Plug.Conn{cookies: %{"openAMssoToken" => shared.token}}
      let :response, do: {:ok, %HTTPoison.Response{status_code: 200, body: shared.ok_body, headers: []}}

      it "returns user details" do
        expect(conn().private.openam_user)
        |> to(match_pattern %{
          mail: "archie.charles@example.edu",
          sn: "Charles"
        })
      end

      it "extracts uid" do
        expect(OpenAM.uid(conn())) |> to(eq "abc123")
      end

      it "generates an info struct" do
        expect(OpenAM.info(conn()))
        |> to(match_pattern %{
          email: "archie.charles@example.edu",
          name: "Archie B. Charles",
          nickname: "abc123"
        })
      end

      it "generates a raw_info struct" do
        expect(OpenAM.extra(conn()).raw_info.user) |> to(eq conn().private.openam_user)
      end
    end
  end
end
