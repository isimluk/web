defmodule Trento.Router do
  use Commanded.Commands.Router

  alias Trento.Infrastructure.Commanded.Middleware.Enrich

  alias Trento.Clusters.Commands.{
    CompleteChecksExecution,
    DeregisterClusterHost,
    RegisterClusterHost,
    RollUpCluster,
    SelectChecks
  }

  alias Trento.Hosts.Commands.{
    CompleteHostChecksExecution,
    DeregisterHost,
    RegisterHost,
    RequestHostDeregistration,
    RollUpHost,
    SelectHostChecks,
    UpdateHeartbeat,
    UpdateProvider,
    UpdateSaptuneStatus,
    UpdateSlesSubscriptions
  }

  alias Trento.SapSystems.Commands.{
    DeregisterApplicationInstance,
    DeregisterDatabaseInstance,
    MarkApplicationInstanceAbsent,
    MarkDatabaseInstanceAbsent,
    RegisterApplicationInstance,
    RegisterDatabaseInstance,
    RollUpSapSystem
  }

  alias Trento.Clusters
  alias Trento.Hosts
  alias Trento.SapSystems

  middleware Enrich

  identify Hosts.Host, by: :host_id

  dispatch [
             RegisterHost,
             UpdateHeartbeat,
             UpdateProvider,
             UpdateSaptuneStatus,
             UpdateSlesSubscriptions,
             SelectHostChecks,
             RollUpHost,
             RequestHostDeregistration,
             DeregisterHost,
             CompleteHostChecksExecution
           ],
           to: Hosts.Host,
           lifespan: Hosts.Lifespan

  identify Clusters.Cluster,
    by: :cluster_id

  dispatch [
             DeregisterClusterHost,
             RollUpCluster,
             RegisterClusterHost,
             SelectChecks,
             CompleteChecksExecution
           ],
           to: Clusters.Cluster,
           lifespan: Clusters.Lifespan

  identify SapSystems.SapSystem, by: :sap_system_id

  dispatch [
             DeregisterApplicationInstance,
             DeregisterDatabaseInstance,
             MarkApplicationInstanceAbsent,
             MarkDatabaseInstanceAbsent,
             RegisterApplicationInstance,
             RegisterDatabaseInstance,
             RollUpSapSystem
           ],
           to: SapSystems.SapSystem,
           lifespan: SapSystems.Lifespan
end
