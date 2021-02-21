# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

http_basic_auth_username =
  System.get_env("HTTP_BASIC_AUTH_USERNAME") ||
    raise """
    environment variable HTTP_BASIC_AUTH_USERNAME is missing.
    """

http_basic_auth_password =
  System.get_env("HTTP_BASIC_AUTH_PASSWORD") ||
    raise """
    environment variable HTTP_BASIC_AUTH_PASSWORD is missing.
    """

  # Set basic auth from environment variables
config :sebastian_auth, basic_auth: [
  username: http_basic_auth_username,
  password: http_basic_auth_password,
]

config :sebastian, SebastianWeb.Endpoint,
  url: [host: "sebastiankun.herokuapp.com", port: String.to_integer(System.fetch_env!("PORT"))],
  check_origin: ["//sebastiankun.herokuapp.com"],
  http: [
    port: String.to_integer(System.fetch_env!("PORT")),
    transport_options: [socket_opts: []]
  ],
  server: true,
  code_reloader: false

