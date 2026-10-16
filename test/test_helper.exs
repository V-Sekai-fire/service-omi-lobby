Mox.defmock(Uro.ReBACMock, for: Uro.Ports.ReBAC)
Mox.defmock(Uro.PlannerMock, for: Uro.Ports.Planner)

ExUnit.configure(exclude: [:suite])
Ecto.Adapters.SQL.Sandbox.mode(Uro.Repo, :manual)
