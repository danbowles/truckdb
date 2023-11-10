defmodule Truckdb.Trucks do
  @moduledoc """
  The Trucs Context:
  Handle the creation and modifications of a 'truck' schema
  """

  alias Truckdb.Repo
  alias Truckdb.Trucks.Truck

  @doc """
  Creates a new truck

  ## Examples

      iex> create_truck(@valid_attrs)
      {:ok, %Truck{}}

      iex> create_truck(@invalid_attrs)
      {:error, %Ecto.Changeset{}}

  """
  def create_truck(attrs \\ %{}) do
    %Truck{}
    |> Truck.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Fetch a single truck by id

  ## Examples

      iex> fetch_truck(id)
      {:ok, %Truck{}}

      iex> fetch_truck(invalid_id)
      {:error, :not_found}

  """
  def fetch_truck(id) do
    Repo.fetch(Truck, id)
  end

  @doc """
  Fetch a single truck by its location_id

  ## Examples

      iex> fetch_truck_by_location_id(location_id)
      {:ok, %Truck{}}

      iex> fetch_truck_by_location_id(invalid_location_id)
      {:error, :not_found}

  """

  def fetch_truck_by_location_id(location_id) do
    Repo.fetch_by(Truck, location_id: location_id)
  end

  @doc """
  Gets all trucks

  ## Examples

      iex> get_trucks()
      [%Truck{}, %Truck{}]

  """
  def get_trucks() do
    Repo.all(Truck)
  end

  @doc """
  Updates a truck

  ## Examples

      iex> update_truck(truck_id, @valid_attrs)
      {:ok, %Truck{}}

      iex> update_truck(invalid_truck_id, @valid_attrs)
      {:error, :not_found}

      iex> update_truck(truck_id, @invalid_attrs)
      {:error, %Ecto.Changeset{}}

  """
  def update_truck(truck_id, attrs) do
    case fetch_truck(truck_id) do
      {:ok, truck} ->
        truck
        |> Truck.changeset(attrs)
        |> Repo.update()
      {:error, _} ->
        {:error, :not_found}
    end
  end

  @doc """
  Updates a truck's lat/long coordinates

  ## Examples

      iex> update_truck_lat_long_coords(truck_id, @valid_attrs)
      {:ok, %Truck{}}

      iex> update_truck_lat_long_coords(invalid_truck_id, @valid_attrs)
      {:error, :not_found}

      iex> update_truck_lat_long_coords(truck_id, @invalid_attrs)
      {:error, %Ecto.Changeset{}}

  """
  def update_truck_lat_long_coords(truck_id, attrs) do
    case fetch_truck(truck_id) do
      {:ok, truck} ->
        truck
        |> Truck.update_lat_long_changeset(attrs)
        |> Repo.update()
      {:error, _} ->
        {:error, :not_found}
    end
  end

  @doc """
  Deletes a truck

  ## Examples

      iex> delete(truck_id)
      {:ok, %Truck{}}

      iex> update_truck(invalid_truck_id)
      {:error, :not_found}

  """

  def delete_truck(truck_id) do
    case fetch_truck(truck_id) do
      {:ok, truck} ->
        Repo.delete(truck)
      {:error, _} ->
        {:error, :not_found}
    end
  end
end
