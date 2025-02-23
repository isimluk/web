defmodule Trento.Clusters.ValueObjects.HanaClusterDetails do
  @moduledoc """
  Represents the details of a HANA cluster.
  """

  @required_fields [
    :system_replication_mode,
    :system_replication_operation_mode,
    :sr_health_state,
    :fencing_type
  ]

  use Trento.Support.Type

  alias Trento.Clusters.ValueObjects.{
    ClusterResource,
    HanaClusterNode,
    SbdDevice
  }

  deftype do
    field :system_replication_mode, :string
    field :system_replication_operation_mode, :string
    field :secondary_sync_state, :string
    field :sr_health_state, :string
    field :fencing_type, :string

    embeds_many :stopped_resources, ClusterResource
    embeds_many :nodes, HanaClusterNode
    embeds_many :sbd_devices, SbdDevice
  end
end
