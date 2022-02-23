defmodule OpenAM.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Mox

      @ok_body """
      userdetails.token.id=sFDM1JEI9lmT9rYDugpjyej5ddsyaevHvNnoNHPSKJKJkll.*veUjaqALrotv6LBrsaAPcBXjPuWOFer0bJk2Is24hLcMcpj1h7lfPM1M*
      userdetails.attribute.name=uid
      userdetails.attribute.value=abc123
      userdetails.attribute.name=mail
      userdetails.attribute.value=archie.charles@example.edu
      userdetails.attribute.name=sn
      userdetails.attribute.value=Charles
      userdetails.attribute.name=cn
      userdetails.attribute.value=charles,archie bravo
      userdetails.attribute.value=b.
      userdetails.attribute.value=archie b.
      userdetails.attribute.value=archie
      userdetails.attribute.value=charles,archie b.
      userdetails.attribute.value=bravo
      userdetails.attribute.value=archie b. charles
      userdetails.attribute.value=archie charles\nuserdetails.attribute.value=archie bravo charles
      userdetails.attribute.value=charles,archie
      userdetails.attribute.value=charles
      userdetails.attribute.value=bravo charles
      userdetails.attribute.name=givenName
      userdetails.attribute.value=Archie B.
      userdetails.attribute.name=dn
      userdetails.attribute.value=uid=abc123,ou=people,dc=example,dc=edu
      userdetails.attribute.name=objectClass
      userdetails.attribute.value=organizationalPerson
      userdetails.attribute.value=person
      userdetails.attribute.value=inetorgperson
      userdetails.attribute.value=top
      """
      @error_body "exception.name=com.sun.identity.idsvcs.TokenExpired Token is NULL"
      @token "sFDM1JEI9lmT9rYDugpjyej5ddsyaevHvNnoNHPSKJKJkll.*veUjaqALrotv6LBrsaAPcBXjPuWOFer0bJk2Is24hLcMcpj1h7lfPM1M*"
    end
  end
end
