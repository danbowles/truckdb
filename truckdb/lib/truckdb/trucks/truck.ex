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
  end
end
