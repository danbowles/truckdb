defmodule TruckdbWeb.Schema do
  use Absinthe.Schema

  import_types(TruckdbWeb.Schema.TruckTypes)

  query do
    import_fields(:truck_queries)
  end

  mutation do
    import_fields(:truck_mutations)
  end
end
