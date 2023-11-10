defmodule TruckdbWeb.Schema.TruckTypes do
  use Absinthe.Schema.Notation

  alias Truckdb.Trucks

  enum :facility_type do
    value(:push_cart)
    value(:truck)
  end

  enum :permit_status do
    value(:approved)
    value(:expired)
    value(:requested)
    value(:suspended)
    value(:issued)
  end

  @desc "A truck"
  object :truck do
    field(:id, non_null(:id))
    field(:applicant, non_null(:string))
    field(:facility_type, non_null(:facility_type))
    field(:cnn, non_null(:string))
    field(:address, non_null(:string))
    field(:permit, non_null(:string))
    field(:status, non_null(:permit_status))
    field(:schedule, non_null(:string))
  end

  object :truck_queries do
    field :get_truck_by_id, non_null(:truck) do
      arg(:id, non_null(:id))
      resolve(fn _parent, %{id: id}, _context ->
        Trucks.fetch_truck(id)
      end)
    end

    field :get_truck_by_location_id, non_null(:truck) do
      arg(:location_id, non_null(:id))
      resolve(fn _parent, %{location_id: id}, _context ->
        Trucks.fetch_truck_by_location_id(id)
      end)
    end

    field :get_trucks, non_null(list_of(non_null(:truck))) do
      resolve(fn _parent, _, _context ->
        Trucks.get_trucks()
      end)
    end

    field :get_trucks_by_permit_status, non_null(list_of(non_null(:truck))) do
      resolve(fn _parent, %{}, _context ->
        Trucks.get_trucks()
      end)
    end
  end
end
