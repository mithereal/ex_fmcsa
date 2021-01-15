defmodule Fmcsa.Telemetry do
  def setup do
    events = [
      [:fcmsa, :request, :sync],
    ]

    :telemetry.attach_many("fmcsa-instrumenter", events, &handle_event/4, nil)
  end

  def handle_event([:fcmsa, :request, :sync], measurements, metadata, _config) do
    {metadata.id, metadata.last_update}
  end

end