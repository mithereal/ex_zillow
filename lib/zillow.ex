defmodule Zillow do

  @moduledoc """
  This module is responsible for retrieving data from zillow.
  """


  @doc """
   fetch the response from zillow return a json string.

   ## Examples

         iex> address = "4406 N 48th st"

         iex> area = "Phoenix, AZ 85008"

         iex> address_record = %{address: address, area: area}

         iex> Zillow.fetch(address)
          %{bathrooms: 5, total_rooms: 5, sq_ft: 1200 }
  """
  def fetch(%{address: address, area: area}) do

    key = Application.get_env(:zillow, :api_key)

    error = case key == nil do
      true -> {:error, "Zillow api key cannot be blank"}
      false -> {:ok}
    end

    response = case error do
      {:error, msg} -> {:error, msg}
      {:ok} -> case address do
                 " " ->
                   %{error: "Address field Missing"}
                 _ ->
                   zillow = HTTPotion.get(
                     "https://www.zillow.com/webservice/GetDeepSearchResults.htm",
                     query: %{
                       "zws-id": key,
                       "address": address,
                       "citystatezip": area
                     }
                   )

                   c = Friendly.find(zillow.body, "code")

                   usecode = Friendly.find(zillow.body, "usecode")
                   fipscounty = Friendly.find(zillow.body, "fipscounty")
                   taxassessmentyear = Friendly.find(zillow.body, "taxassessmentyear")
                   taxassessment = Friendly.find(zillow.body, "taxassessment")
                   yearbuilt = Friendly.find(zillow.body, "yearbuilt")
                   lotsizesqft = Friendly.find(zillow.body, "lotsizesqft")
                   lastupdated = Friendly.find(zillow.body, "last-updated")
                   zindexvalue = Friendly.find(zillow.body, "zindexvalue")

                   street = Friendly.find(zillow.body, "street")
                   zipcode = Friendly.find(zillow.body, "zipcode")
                   city = Friendly.find(zillow.body, "city")
                   state = Friendly.find(zillow.body, "state")
                   latitude = Friendly.find(zillow.body, "latitude")
                   longitude = Friendly.find(zillow.body, "longitude")

                   homedetails = Friendly.find(zillow.body, "homedetails")
                   graphsanddata = Friendly.find(zillow.body, "graphsanddata")
                   mapthishome = Friendly.find(zillow.body, "mapthishome")
                   comparables = Friendly.find(zillow.body, "comparables")
                   overview = Friendly.find(zillow.body, "overview")
                   forsalebyowner = Friendly.find(zillow.body, "forsalebyowner")
                   forsale = Friendly.find(zillow.body, "forsale")

                   [%{attributes: _, elements: _, name: _, text: code, texts: _}] = c

                   code_response = case code do
                     "508" -> %{error: 508, message: "no exact match found"}
                     "0" -> bathrooms = Friendly.find(zillow.body, "bathrooms")

                            bathroom_count = Enum.count bathrooms

                            bh = case bathroom_count > 0 do
                              true -> [bh | bt] = bathrooms
                                      bh
                              false -> "0.0"
                            end


                            rooms = Friendly.find(zillow.body, "totalrooms")

                            [rh] = rooms

                            finishedSqFt = Friendly.find(zillow.body, "finishedsqft")

                            [fh] = finishedSqFt

                            bathroom_number = case bh do
                              %{attributes: %{}, elements: [], name: "bathrooms", text: _, texts: _} -> bh.text
                              _ -> "0.0"
                            end

                            totalrooms = case rh do
                              %{attributes: %{}, elements: [], name: "totalrooms", text: _, texts: _} -> rh.text
                              _ -> "0"
                            end

                            sq_ft = case fh do
                              %{attributes: %{}, elements: [], name: "finishedsqft", text: _, texts: _} -> fh.text
                              _ -> "0"
                            end


                            [usecode] = Friendly.find(zillow.body, "usecode")
                            [fipscounty] = Friendly.find(zillow.body, "fipscounty")
                            [taxassessmentyear] = Friendly.find(zillow.body, "taxassessmentyear")
                            [taxassessment] = Friendly.find(zillow.body, "taxassessment")
                            [yearbuilt] = Friendly.find(zillow.body, "yearbuilt")
                            [lotsizesqft] = Friendly.find(zillow.body, "lotsizesqft")
                            [lastupdated] = Friendly.find(zillow.body, "last-updated")
                            [zindexvalue]= Friendly.find(zillow.body, "zindexvalue")

                           [street] = Friendly.find(zillow.body, "street")
                           [zipcode] = Friendly.find(zillow.body, "zipcode")
                           [city] = Friendly.find(zillow.body, "city")
                           [state] = Friendly.find(zillow.body, "state")
                           [latitude] = Friendly.find(zillow.body, "latitude")
                           [longitude] = Friendly.find(zillow.body, "longitude")

                            [homedetails] = Friendly.find(zillow.body, "homedetails")
                            [graphsanddata] = Friendly.find(zillow.body, "graphsanddata")
                            [mapthishome] = Friendly.find(zillow.body, "mapthishome")
                            [comparables] = Friendly.find(zillow.body, "comparables")
                            [overview] = Friendly.find(zillow.body, "overview")
                            [forsalebyowner] = Friendly.find(zillow.body, "forsalebyowner")
                            [forsale] = Friendly.find(zillow.body, "forsale")

                            %{
                              bathrooms: String.to_float(bathroom_number),
                              total_rooms: String.to_integer(totalrooms),
                              sq_ft: String.to_integer(sq_ft),
                              usecode: usecode.text,
                              fipscounty: fipscounty.text,
                              taxassessmentyear: taxassessmentyear.text,
                              yearbuilt: yearbuilt.text,
                              lotsizesqft: lotsizesqft.text,
                              lastupdated: lastupdated.text,
                              zindexvalue: zindexvalue.text,
                              street: street.text,
                              zipcode: zipcode.text,
                              city: city.text,
                              state: state.text,
                              latitude: latitude.text,
                              longitude: longitude.text,
                              forsale: forsale.text,
                              forsalebyowner: forsalebyowner.text,
                              homedetails: homedetails.text,
                              graphsanddata: graphsanddata.text,
                              overview: overview.text,
                              comparables: comparables.text,
                              mapthishome: mapthishome.text
                            }

                     "2" -> %{error: 2, message: "invalid zillow api key"}
                     _ -> %{error: code, message: "a general error occured"}
                   end

                   code_response
               end

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

    address = Enum.join([address, route], " ")

    citystatezip = Enum.join([locality, area], " ")

    fetch(%{"address" => address, "area" => citystatezip})

  end

end
