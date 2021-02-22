defmodule SebastianWeb.QuoteView do
  use SebastianWeb, :view

  def render("index.json", %{quotes: quotes}) do
    quotes
  end
end
