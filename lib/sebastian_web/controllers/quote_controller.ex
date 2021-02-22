defmodule SebastianWeb.QuoteController do
  use SebastianWeb, :controller

  def index(conn, _params) do
    # see https://github.com/dwyl/quotes
    quotes = [
      %{
        author: "Thomas Edison",
        text: "If we did the things we are capable of, we would astound ourselves."
      },
      %{
        author: "Thomas Edison",
        text:
          "Opportunity is missed by most because it is dressed in overalls and looks like work."
      }
    ]

    render(conn, "index.json", quotes: quotes)
  end
end
