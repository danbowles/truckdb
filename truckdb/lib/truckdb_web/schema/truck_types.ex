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
    field(:location_id, non_null(:string))
    field(:applicant, non_null(:string))
    field(:facility_type, non_null(:facility_type))
    field(:cnn, non_null(:string))
    field(:address, non_null(:string))
    field(:permit, non_null(:string))
    field(:status, non_null(:permit_status))
    field(:schedule, non_null(:string))
    field(:latitude, :string)
    field(:longitude, :string)
  end

  object :truck_queries do
    field :get_truck_by_id, non_null(:truck) do
      arg(:id, non_null(:id))
      resolve(fn _parent, %{id: id}, _context ->
        Trucks.fetch_truck(id)
      end)
    end

    field :get_truck_by_location_id, non_null(:truck) do
      arg(:location_id, non_null(:string))
      resolve(fn _parent, %{location_id: id}, _context ->
        Trucks.fetch_truck_by_location_id(id)
      end)
    end

    field :get_trucks, non_null(list_of(non_null(:truck))) do
      resolve(fn _parent, _, _context ->
        {:ok, Trucks.get_trucks()}
      end)
    end

    field :get_trucks_by_permit_status, non_null(list_of(non_null(:truck))) do
      arg(:status, non_null(:permit_status))
      resolve(fn _parent, %{status: status}, _context ->
        {:ok, Trucks.get_trucks_by_permit_status(status)}
      end)
    end
  end

  object :truck_mutations do
    field :create_truck, non_null(:truck) do
      arg(:location_id, non_null(:string))
      arg(:applicant, non_null(:string))
      arg(:facility_type, non_null(:facility_type))
      arg(:cnn, non_null(:string))
      arg(:address, non_null(:string))
      arg(:permit, non_null(:string))
      arg(:status, non_null(:permit_status))
      arg(:schedule, non_null(:string))
      resolve(fn _parent, %{location_id: location_id, applicant: applicant, facility_type: facility_type, cnn: cnn, address: address, permit: permit, status: status, schedule: schedule}, _context ->
        Trucks.create_truck(%{location_id: location_id, applicant: applicant, facility_type: facility_type, cnn: cnn, address: address, permit: permit, status: status, schedule: schedule})
      end)
    end

    field :delete_truck, non_null(:truck) do
      arg(:id, non_null(:id))
      resolve(fn _parent, %{id: id}, _context ->
        Trucks.delete_truck(id)
      end)
    end

    field :update_truck_applicant, non_null(:truck) do
      arg(:id, non_null(:id))
      arg(:applicant, non_null(:string))
      resolve(fn _parent, %{id: id, applicant: applicant}, _context ->
        Trucks.update_truck(id, %{applicant: applicant})
      end)
    end

    field :update_truck_facility_type, non_null(:truck) do
      arg(:id, non_null(:id))
      arg(:facility_type, non_null(:facility_type))
      resolve(fn _parent, %{id: id, facility_type: facility_type}, _context ->
        Trucks.update_truck(id, %{facility_type: facility_type})
      end)
    end

    field :update_truck_latitude_longitude, non_null(:truck) do
      arg(:id, non_null(:id))
      arg(:latitude, non_null(:string))
      arg(:longitude, non_null(:string))
      resolve(fn _parent, %{id: id, latitude: latitude, longitude: longitude}, _context ->
        Trucks.update_truck_lat_long_coords(id, %{latitude: latitude, longitude: longitude})
      end)
    end
  end
end
