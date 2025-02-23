defmodule Trento.Hosts.ProjectionsTelemetryProjectorTest do
  use ExUnit.Case
  use Trento.DataCase

  import Trento.Factory

  alias Trento.Hosts.Projections.{
    HostTelemetryReadModel,
    TelemetryProjector
  }

  alias Trento.Hosts.Events.ProviderUpdated

  alias Trento.ProjectorTestHelper
  alias Trento.Repo

  @moduletag :integration

  test "should project host telemetry data when an HostRegistered event is received" do
    event = build(:host_registered_event)

    ProjectorTestHelper.project(TelemetryProjector, event, "telemetry_projector")
    host_telemetry_projection = Repo.get!(HostTelemetryReadModel, event.host_id)

    assert event.cpu_count == host_telemetry_projection.cpu_count
    assert event.socket_count == host_telemetry_projection.socket_count
    assert event.total_memory_mb == host_telemetry_projection.total_memory_mb
    assert event.os_version == host_telemetry_projection.sles_version
  end

  test "should project host telemetry data when an HostUpdated event is received" do
    insert(:host)
    event = build(:host_details_updated_event)

    ProjectorTestHelper.project(TelemetryProjector, event, "telemetry_projector")
    host_telemetry_projection = Repo.get!(HostTelemetryReadModel, event.host_id)

    assert event.cpu_count == host_telemetry_projection.cpu_count
    assert event.socket_count == host_telemetry_projection.socket_count
    assert event.total_memory_mb == host_telemetry_projection.total_memory_mb
    assert event.os_version == host_telemetry_projection.sles_version
  end

  test "should project host telemetry data when an ProviderUpdated event is received" do
    %{id: host_id} = insert(:host)

    event = %ProviderUpdated{host_id: host_id, provider: :azure}

    ProjectorTestHelper.project(TelemetryProjector, event, "telemetry_projector")
    host_telemetry_projection = Repo.get!(HostTelemetryReadModel, event.host_id)

    assert event.provider == host_telemetry_projection.provider
  end
end
