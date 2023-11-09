defmodule Truckdb.TrucksTest do
  use Truckdb.DataCase, async: true

  alias Truckdb.Trucks

  setup do
    {:ok, truck} = Trucks.create_truck(%{
      location_id: "1234",
      applicant: "John Doe",
      facility_type: :push_cart,
      cnn: "1234",
      address: "1234 Main St.",
      permit: "1234",
      status: :requested,
      schedule: "http://www.example.com"
    })

    %{truck: truck}
  end

  describe "create_truck/1" do
    test "Can create a truck" do
      assert {:ok, truck} = Trucks.create_truck(%{
        location_id: "1234",
        applicant: "John Doe",
        facility_type: :push_cart,
        cnn: "1234",
        address: "1234 Main St.",
        permit: "1234",
        status: :requested,
        schedule: "http://www.example.com"
      })

      assert truck.id != nil
      assert truck.applicant == "John Doe"
    end

    test "Cannot create a truck with invalid attributes" do
      assert {:error, %Ecto.Changeset{errors: [facility_type: {"is invalid", _}]}} = Trucks.create_truck(%{
        location_id: "1234",
        applicant: "John Doe",
        facility_type: :wagon,
        cnn: "1234",
        address: "1234 Main St.",
        permit: "1234",
        status: :requested,
        schedule: "http://www.example.com"
      })

      assert {:error, %Ecto.Changeset{errors: [applicant: {"can't be blank", _}]}} = Trucks.create_truck(%{
        location_id: "1234",
        facility_type: :push_cart,
        cnn: "1234",
        address: "1234 Main St.",
        permit: "1234",
        status: :requested,
        schedule: "http://www.example.com"
      })
    end
  end

  describe "fetch_truck/1" do
    test "Can get a truck", %{truck: %{id: truck_id}} do
      assert {:ok, truck} = Trucks.fetch_truck(truck_id)

      assert truck.id == truck_id
    end

    test "Cannot get a truck that does not exist" do
      assert {:error, :not_found} = Trucks.fetch_truck(Ecto.UUID.generate())
    end
  end

  describe "update_truck/2" do
    test "Can update a truck", %{truck: %{id: truck_id}} do
      assert {:ok, truck} = Trucks.update_truck(truck_id, %{applicant: "Jane Doe", status: :approved})

      assert truck.applicant == "Jane Doe"
      assert truck.status == :approved
    end

    test "Cannot update a truck with invalid attributes", %{truck: %{id: truck_id}} do
      assert {
        :error,
        %Ecto.Changeset{errors: [facility_type: {"is invalid", _}]}
      } = Trucks.update_truck(truck_id, %{applicant: "Jane Doe", facility_type: :car})
    end

    test "Cannot update a truck that does not exist" do
      assert {:error, :not_found} = Trucks.update_truck(Ecto.UUID.generate(), %{applicant: "Jane Doe", status: :approved})
    end
  end

  describe "delete_truck/1" do
    test "Can delete a truck", %{truck: %{id: truck_id}} do
      assert {:ok, truck} = Trucks.delete_truck(truck_id)

      assert truck.id == truck_id
    end

    test "Cannot delete a truck that does not exist" do
      assert {:error, :not_found} = Trucks.delete_truck(Ecto.UUID.generate())
    end
  end
end
