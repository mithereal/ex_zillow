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

         iex> Zillow.fetch(address_record)
          %{bathrooms: 5, total_rooms: 5, sq_ft: 1200 }
  """
  def fetch(%{address: address, area: area}) do
    key = Application.get_env(:zillow, :api_key)

    status =
      case is_nil(key) do
        true -> {:error, "Zillow api key cannot be blank"}
        false -> :ok
      end

    case status do
      {:error, msg} ->
        {:error, msg}

      :ok ->
        case is_nil(address) do
          true ->
            %{error: "Address field Missing"}

          false ->
            reply = Zillow.Http.search(key, address, area)

            [%{attributes: _, elements: _, name: _, text: code, texts: _}] =
              Friendly.find(reply.body, "code")

            case code do
              "508" ->
                %{error: 508, message: "no exact match found"}

              "0" ->
                bathrooms = Friendly.find(reply.body, "bathrooms")

                bathroom_count = Enum.count(bathrooms)

                bh =
                  case bathroom_count > 0 do
                    true ->
                      [bh | _bt] = bathrooms
                      bh

                    false ->
                      "0.0"
                  end

                rooms = Friendly.find(reply.body, "totalrooms")

                [rh] = rooms

                finishedSqFt = Friendly.find(reply.body, "finishedsqft")

                [fh] = finishedSqFt

                bathroom_number =
                  case bh do
                    %{attributes: %{}, elements: [], name: "bathrooms", text: _, texts: _} ->
                      bh.text

                    _ ->
                      "0.0"
                  end

                totalrooms =
                  case rh do
                    %{attributes: %{}, elements: [], name: "totalrooms", text: _, texts: _} ->
                      rh.text

                    _ ->
                      "0"
                  end

                sq_ft =
                  case fh do
                    %{attributes: %{}, elements: [], name: "finishedsqft", text: _, texts: _} ->
                      fh.text

                    _ ->
                      "0"
                  end

                [usecode] = Friendly.find(reply.body, "usecode")
                [fipscounty] = Friendly.find(reply.body, "fipscounty")
                [taxassessmentyear] = Friendly.find(reply.body, "taxassessmentyear")
                [taxassessment] = Friendly.find(reply.body, "taxassessment")
                [yearbuilt] = Friendly.find(reply.body, "yearbuilt")
                [lotsizesqft] = Friendly.find(reply.body, "lotsizesqft")
                [lastupdated] = Friendly.find(reply.body, "last-updated")
                [zindexvalue] = Friendly.find(reply.body, "zindexvalue")
                [street] = Friendly.find(reply.body, "street")
                [zipcode] = Friendly.find(reply.body, "zipcode")
                [city] = Friendly.find(reply.body, "city")
                [state] = Friendly.find(reply.body, "state")
                [latitude] = Friendly.find(reply.body, "latitude")
                [longitude] = Friendly.find(reply.body, "longitude")
                [homedetails] = Friendly.find(reply.body, "homedetails")
                [graphsanddata] = Friendly.find(reply.body, "graphsanddata")
                [mapthishome] = Friendly.find(reply.body, "mapthishome")
                [comparables] = Friendly.find(reply.body, "comparables")
                [overview] = Friendly.find(reply.body, "overview")
                [forsalebyowner] = Friendly.find(reply.body, "forsalebyowner")
                [forsale] = Friendly.find(reply.body, "forsale")

                %{
                  bathrooms: String.to_float(bathroom_number),
                  total_rooms: String.to_integer(totalrooms),
                  sq_ft: String.to_integer(sq_ft),
                  usecode: usecode.text,
                  fipscounty: fipscounty.text,
                  taxassessment: taxassessment.text,
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

              "2" ->
                %{error: 2, message: "invalid zillow api key"}

              _ ->
                %{error: code, message: "a general error occured"}
            end
        end
    end
  end

  def fetch(%{"address" => address, "route" => route, "locality" => locality, "area" => area}) do
    address = Enum.join([address, route], " ")

    citystatezip = Enum.join([locality, area], " ")

    fetch(%{"address" => address, "area" => citystatezip})
  end
end
