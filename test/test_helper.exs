ExUnit.start(capture_log: true)
Mox.Server.start_link([])
Mox.defmock(MockHTTPoison, for: HTTPoison.Base)
