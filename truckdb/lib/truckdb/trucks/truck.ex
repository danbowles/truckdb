defmodule Truckdb.Trucks.Truck do
  @moduledoc """
  Represents a single Food Truck
  """

  use Truckdb.Schema

  schema "trucks" do
    field(:location_id, :string)
    field(:applicant, :string)
    field(:facility_type, Ecto.Enum, values: [:push_cart, :truck])
    field(:cnn, :string)
    field(:location_description, :string)
    field(:address, :string)
    field(:permit, :string)
    field(:status, Ecto.Enum, values: [:approved, :expired, :requested, :suspended, :issued])
    field(:food_items, :string)
    field(:latitude, :string)
    field(:longitude, :string)
    field(:schedule, :string)
    field(:days_hours, :string)
    field(:approved, :date)
    field(:expiration_date, :date)

    timestamps()
  end

  @doc false
  def changeset(truck, attrs) do
    truck
    |> cast(attrs, [
      :location_id,
      :applicant,
      :facility_type,
      :cnn,
      :location_description,
      :address,
      :permit,
      :status,
      :food_items,
      :latitude,
      :longitude,
      :schedule,
      :days_hours,
      :approved,
      :expiration_date
    ])
    |> validate_required([:location_id, :applicant, :facility_type, :cnn, :address, :permit, :status, :schedule])
    |> validate_unique_location_id()
  end

  def update_lat_long_changeset(truck, attrs) do
    truck
    |> cast(attrs, [:latitude, :longitude])
    |> validate_required([:latitude, :longitude])
    |> validate_valid_latitude_longitude()
  end

  defp validate_valid_latitude_longitude(changeset) do
    latitude = get_field(changeset, :latitude) || ""
    longitude = get_field(changeset, :longitude) || ""

    latitude_regex = ~r/^(\+|-)?(?:90(?:(?:\.0{1,6})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,6})?))$/
    longitude_regex = ~r/^(\+|-)?(?:180(?:(?:\.0{1,6})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,6})?))$/

    case {Regex.match?(latitude_regex, latitude), Regex.match?(longitude_regex, longitude)} do
      {true, true} -> changeset
      {false, _} -> changeset |> add_error(:latitude, "invalid latitude")
      {_, false} -> changeset |> add_error(:longitude, "invalid longitude")
    end
  end

  defp validate_unique_location_id(changeset) do
    changeset
    |> unique_constraint([:location_id],
      name: :unique_trucks_location_id,
      message: "A truck with that location_id already exists"
    )
  end
end
