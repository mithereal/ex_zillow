defmodule Zillow do

@moduledoc """
This is responsible for retrieving data from zillow.
"""


@doc """
 fetch the number of rooms and sqft from zillow return a json string.
"""
  def fetch(conn, _params) do

   key = Application.get_env(:zillow, :api_key)

   address = Enum.join([_params["street_number"], _params["route"]], " ")

   citystatezip = Enum.join([_params["locality"], _params["administrative_area_level_1"]], " ")

   response = case address do
    " " -> %{error: "Address field Missing" }
    _-> zillow =  HTTPotion.get("https://www.zillow.com/webservice/GetDeepSearchResults.htm", query: %{"zws-id": key, "address": address, "citystatezip": citystatezip })

    c = Friendly.find(zillow.body, "code")

    [%{attributes: _, elements: _, name: _, text: code, texts: _}] = c

    code_response = case code do
    "508" ->  nil
    "0" -> bathrooms = Friendly.find(zillow.body, "bathrooms")

    [ bh | bt ] = bathrooms

    rooms =  Friendly.find(zillow.body, "totalrooms")

    [ rh | rt ] = rooms

    finishedSqFt = Friendly.find(zillow.body, "finishedsqft")

    [ fh | ft ] = finishedSqFt

   %{attributes: %{}, elements: [], name: "bathrooms", text: bathroom_number, texts: _ } = bh

   %{attributes: %{}, elements: [], name: "totalrooms", text: totalrooms, texts: _ } = rh

   %{attributes: %{}, elements: [], name: "finishedsqft", text: sq_ft, texts: _ } = fh

   %{bathrooms: String.to_float(bathroom_number), total_rooms: String.to_integer(totalrooms), sq_ft: String.to_integer(sq_ft) }
         end

        code_response
    end

    response
end



end
