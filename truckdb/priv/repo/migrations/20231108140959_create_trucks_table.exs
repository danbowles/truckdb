defmodule Truckdb.Repo.Migrations.CreateTrucksTable do
  use Ecto.Migration
  import EctoEnumMigration

  def change do
    create_type(:facility_type, [:truck, :push_cart])
    create_type(:permit_status, [:approved, :expired, :requested, :suspended, :issued])

    create table(:trucks, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:location_id, :string, null: false)
      add(:applicant, :string, null: false)
      add(:facility_type, :facility_type)
      add(:cnn, :string, null: false)
      add(:location_description, :string)
      add(:address, :string, null: false)
      add(:blocklot, :string)
      add(:block, :string)
      add(:lot, :string)
      add(:permit, :string, null: false)
      add(:status, :permit_status, null: false)
      add(:food_items, :string)
      add(:x, :string)
      add(:y, :string)
      add(:latitude, :string)
      add(:longitude, :string)
      add(:schedule, :string, null: false)
      add(:days_hours, :string)
      add(:noi_sent, :string)
      add(:approved, :date)
      add(:received_date, :string)
      add(:prior_permit, :string)
      add(:expiration_date, :date)
      add(:location, :string)

      timestamps()
    end

    create(
      unique_index(
        :trucks,
        [:location_id],
        name: :unique_trucks_location_id
      )
    )
  end
end
