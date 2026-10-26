# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Interactor.UserIdentities do
  use PowAssent.Ecto.UserIdentities.Context,
    repo: Uro.Repository.Repo,
    user: Uro.Entities.Accounts.User

  alias Uro.Interactor.Accounts
  alias Uro.Repository.Repo

  def create_user(user_identity_params, user_params, user_id_params) do
    if Uro.Entities.Registration.open?(),
      do: insert_user(user_identity_params, user_params, user_id_params),
      else: {:error, :registration_closed}
  end

  defp insert_user(user_identity_params, user_params, user_id_params) do
    Repo.transaction(fn ->
      with {:ok, user} <-
             pow_assent_create_user(user_identity_params, user_params, user_id_params),
           {:ok, user} <- Accounts.create_user_associations(user) do
        user
      else
        {:error, reason} ->
          Repo.rollback(reason)

        any ->
          Repo.rollback(any)
      end
    end)
  end
end
