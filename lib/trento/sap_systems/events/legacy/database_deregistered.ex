defmodule Trento.Domain.Events.DatabaseDeregistered do
  @moduledoc """
  This event is emitted once all database instances belonging to a HANA database have been deregistered (decommissioned) from the SAP system.
  """

  use Trento.Event

  defevent superseded_by: Trento.SapSystems.Events.DatabaseDeregistered do
    field :sap_system_id, Ecto.UUID
    field :deregistered_at, :utc_datetime_usec
  end
end
