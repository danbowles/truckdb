defmodule TruckdbWeb.GraphQL.TrucksTest do
  use ExUnit.Case
  use Wormwood.GQLCase
  use Truckdb.DataCase

  alias Truckdb.Trucks

  def no_errors!(query_data) do
    errors = get_in(query_data, [:errors])

    if is_nil(errors) do
      true
    else
      throw(errors)
    end
  end

  load_gql(
    :get_trucks,
    TruckdbWeb.Schema,
    "test/support/queries/GetTrucks.gql"
  )

  load_gql(
    :get_truck_by_id,
    TruckdbWeb.Schema,
    "test/support/queries/GetTruckById.gql"
  )

  load_gql(
    :get_truck_by_location_id,
    TruckdbWeb.Schema,
    "test/support/queries/GetTruckByLocationId.gql"
  )

  load_gql(
    :get_trucks_by_permit_status,
    TruckdbWeb.Schema,
    "test/support/queries/GetTrucksByPermitStatus.gql"
  )

  load_gql(
    :create_truck,
    TruckdbWeb.Schema,
    "test/support/mutations/CreateTruck.gql"
  )

  load_gql(
    :delete_truck,
    TruckdbWeb.Schema,
    "test/support/mutations/DeleteTruck.gql"
  )

  load_gql(
    :udpate_truck_applicant,
    TruckdbWeb.Schema,
    "test/support/mutations/UpdateTruckApplicant.gql"
  )

  load_gql(
    :udpate_truck_facility_type,
    TruckdbWeb.Schema,
    "test/support/mutations/UpdateTruckFacilityType.gql"
  )

  load_gql(
    :udpate_truck_latitude_longitude,
    TruckdbWeb.Schema,
    "test/support/mutations/UpdateTruckLatitudeLongitude.gql"
  )

  setup do
    {:ok, truck} = Trucks.create_truck(%{
      location_id: "1234",
      applicant: "John Doe",
      facility_type: :push_cart,
      cnn: "1234",
      address: "1234 Main St.",
      status: :requested,
      permit: "1234",
      schedule: "http://www.example.com"
    })

    %{truck: truck}
  end

  describe "GetTrucks" do
    test "Can get trucks" do
      assert {:ok, query_data} =
        query_gql_by(
          :get_trucks,
          variables: %{},
          context: %{}
        )

      no_errors!(query_data)

      trucks = get_in(query_data, [:data, "getTrucks"])
      assert trucks |> Enum.count() == 1
    end
  end

  describe "GetTruckById" do
    test "Can get a truck by its Id", %{truck: truck} do
      assert {:ok, query_data} =
        query_gql_by(
          :get_truck_by_id,
          variables: %{"id" => truck.id},
          context: %{}
        )

      no_errors!(query_data)

      truck_result = get_in(query_data, [:data, "getTruckById"])
      assert truck_result["id"] == truck.id
    end
  end

  describe "GetTruckByLocationId" do
    test "Can get a truck by its Loation Id", %{truck: truck} do
      assert {:ok, query_data} =
        query_gql_by(
          :get_truck_by_location_id,
          variables: %{"locationId" => truck.location_id},
          context: %{}
        )

      no_errors!(query_data)

      truck_result = get_in(query_data, [:data, "getTruckByLocationId"])
      assert truck_result["locationId"] == truck.location_id
    end
  end

  describe "GetTrucksByPermitStatus" do
    test "Can get a set of trucks by permit status" do
      _truck_approved_permit_one = Trucks.create_truck(%{
        location_id: "ABCD",
        applicant: "John Doe",
        facility_type: :push_cart,
        cnn: "1234",
        address: "1234 Main St.",
        status: :approved,
        permit: "1234",
        schedule: "http://www.example.com"
      })

      _truck_approved_permit_two = Trucks.create_truck(%{
        location_id: "GHIJ",
        applicant: "John Doe",
        facility_type: :push_cart,
        cnn: "1234",
        address: "1234 Main St.",
        status: :approved,
        permit: "1234",
        schedule: "http://www.example.com"
      })

      assert {:ok, query_data} =
        query_gql_by(
          :get_trucks_by_permit_status,
          variables: %{"status" => "APPROVED"},
          context: %{}
        )

      no_errors!(query_data)

      truck_result = get_in(query_data, [:data, "getTrucksByPermitStatus"])
      assert truck_result |> Enum.count() == 2
    end
  end

  describe "CreateTruck" do
    test "Can create truck" do
      assert {:ok, query_data} =
        query_gql_by(
          :create_truck,
          variables: %{
            "locationId" => "ABCD",
            "applicant" => "John Doe",
            "facilityType" => "PUSH_CART",
            "cnn" => "1234",
            "address" => "1234 Main St.",
            "status" => "REQUESTED",
            "permit" => "1234",
            "schedule" => "http://www.example.com"
          },
          context: %{}
        )

      no_errors!(query_data)

      truck_result = get_in(query_data, [:data, "createTruck"])
      assert truck_result["locationId"] == "ABCD"
    end
  end

  describe "DeleteTruck" do
    test "Can delete truck", %{truck: truck} do
      assert {:ok, query_data} =
        query_gql_by(
          :delete_truck,
          variables: %{"id" => truck.id},
          context: %{}
        )

      no_errors!(query_data)

      truck_result = get_in(query_data, [:data, "deleteTruck"])
      assert truck_result["id"] == truck.id
    end
  end

  describe "UpdateTruckApplicant" do
    test "Can update truck applicant", %{truck: truck} do
      assert {:ok, query_data} =
        query_gql_by(
          :udpate_truck_applicant,
          variables: %{
            "id" => truck.id,
            "applicant" => "James Doe III"
          },
          context: %{}
        )

      no_errors!(query_data)

      truck_result = get_in(query_data, [:data, "updateTruckApplicant"])
      assert truck_result["applicant"] == "James Doe III"
    end

  end

  describe "UpdateTruckFacilityType" do
    test "Can update a truck's facility type", %{truck: truck} do
      assert {:ok, query_data} =
        query_gql_by(
          :udpate_truck_facility_type,
          variables: %{
            "id" => truck.id,
            "facilityType" => "TRUCK"
          },
          context: %{}
        )

      no_errors!(query_data)

      truck_result = get_in(query_data, [:data, "updateTruckFacilityType"])
      assert truck_result["facilityType"] == "TRUCK"
    end

  end

  describe "UpdateTruckLatitudeLongitude" do
    test "Can update a truck's latitude and longitude", %{truck: truck} do
      assert {:ok, query_data} =
        query_gql_by(
          :udpate_truck_latitude_longitude,
          variables: %{
            "id" => truck.id,
            "latitude" => "37.1234",
            "longitude" => "-122.1234"
          },
          context: %{}
        )

      no_errors!(query_data)

      truck_result = get_in(query_data, [:data, "updateTruckLatitudeLongitude"])
      assert truck_result["latitude"] == "37.1234"
      assert truck_result["longitude"] == "-122.1234"
    end
  end
end
