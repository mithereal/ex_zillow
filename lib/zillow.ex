defmodule Zillow do

@moduledoc """
This module is responsible for retrieving data from zillow.
"""


@doc """
 fetch the number of rooms and sqft from zillow return a json string.

 ## Examples

       iex> address = "4406 N 48th st"

       iex> area = "Phoenix, AZ 85008"

       iex> address_record = %{address: address, area: area}

       iex> Zillow.fetch(address)
              %{bathrooms: 5, total_rooms: 5, sq_ft: 1200 }
"""
def fetch(%{address: address, area: area }) do

    key = Application.get_env(:zillow, :api_key)

IO.inspect(%{"zws-id": key, "address": address, "citystatezip": area }, label: 'HTTPotion.get("https://www.zillow.com/webservice/GetDeepSearchResults.htm", query: %{"zws-id": key, "address": address, "citystatezip": area })')

   response = case address do
    " " -> %{error: "Address field Missing" }
    _-> zillow =  HTTPotion.get("https://www.zillow.com/webservice/GetDeepSearchResults.htm", query: %{"zws-id": key, "address": address, "citystatezip": area })

    c = Friendly.find(zillow.body, "code")

    [%{attributes: _, elements: _, name: _, text: code, texts: _}] = c

    code_response = case code do
    "508" ->  %{ error: 508, message: "no exact match found" }
    "0" -> bathrooms = Friendly.find(zillow.body, "bathrooms")

    [ bh | bt ] = bathrooms

    rooms =  Friendly.find(zillow.body, "totalrooms")


    room_count = Enum.count rooms

   rh = case room_count > 0 do
    true -> [ rh | rt ] = rooms
    rh
    false -> 0
    end

    finishedSqFt = Friendly.find(zillow.body, "finishedsqft")

    finishedSqFt_count = Enum.count finishedSqFt

    fh = case finishedSqFt_count > 0 do
    true -> [ fh | ft ] = finishedSqFt
    fh
    false -> 0
    end



    bathroom_number = case bh do
     %{attributes: %{}, elements: [], name: "bathrooms", text: _, texts: _ } ->  bh.text
     _-> "0"
    end

    totalrooms = case bh do
     %{attributes: %{}, elements: [], name: "totalrooms", text: _, texts: _ } ->  rh.text
     _-> "0"
    end

    sq_ft = case bh do
     %{attributes: %{}, elements: [], name: "finishedsqft", text: _, texts: _ } ->  fh.text
     _-> "0"
    end

   %{bathrooms: String.to_float(bathroom_number), total_rooms: String.to_integer(totalrooms), sq_ft: String.to_integer(sq_ft) }
   "2" -> %{ error: 2 , message: "invalid zillow api key" }
   _-> %{ error: 000 , message: "a general error occured" }
         end

        code_response
    end

    response
end

@doc """
 fetch the number of rooms and sqft from zillow return a json string using default data returned from google maps api as input.

 ## Examples

       iex> Zillow.fetch(%{"address" => address, "route" => route, "locality" => locality, "area" => area})
              %{bathrooms: 5, total_rooms: 5, sq_ft: 1200 }
"""

  def fetch(%{"address" => address, "route" => route, "locality" => locality, "area" => area}) do

   address = Enum.join([address, route ], " ")

   citystatezip = Enum.join([locality, area ], " ")

   fetch(%{"address" => address, "area" => citystatezip })

end



end
