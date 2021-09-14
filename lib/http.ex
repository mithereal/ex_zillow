defmodule Zillow.Http do
  @moduledoc false
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://www.zillow.com/webservice/GetDeepSearchResults.htm")

  def search(key, address, area) do
    get("?zws-id=#{key}&address=#{address}&citystatezip=#{area}}")
  end
end
