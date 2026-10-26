# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Transport.Web.Controllers.Storage do
  @moduledoc """
  HTTP handlers for shared files: list, list by tag, show, upload, update and delete.
  """

  use Uro.Transport.Web, :controller

  alias OpenApiSpex.Schema
  alias Uro.Interactor.SharedContent

  action_fallback Uro.Transport.Web.Controllers.Fallback

  tags(["storage"])

  operation(:index,
    operation_id: "listSharedFiles",
    summary: "List all public storage files",
    responses: [
      ok: {
        "A successful response returning a list of storage files",
        "application/json",
        %Schema{
          type: :object,
          properties: %{
            data: %Schema{
              type: :object,
              properties: %{
                files: %Schema{
                  type: :array,
                  items: Uro.Entities.SharedContent.SharedFile.json_schema(),
                  description: "List of files"
                }
              }
            }
          }
        }
      }
    ]
  )

  def index(conn, _params) do
    file_list = SharedContent.list_public_shared_files()

    conn
    |> put_status(200)
    |> json(%{
      data: %{
        files:
          Uro.Interactor.SharedContentHelper.get_api_shared_content_list(file_list, %{
            merge_uploader_id: true
          })
      }
    })
  end

  operation(:index_by_tag,
    operation_id: "listSharedFilesByTag",
    summary: "List all public storage files by tag",
    parameters: [
      OpenApiSpex.Operation.parameter(:tag, :path, :string, "Tag group")
    ],
    responses: [
      ok: {
        "A successful response returning a list of storage files",
        "application/json",
        %Schema{
          type: :object,
          properties: %{
            data: %Schema{
              type: :object,
              properties: %{
                files: %Schema{
                  type: :array,
                  items: Uro.Entities.SharedContent.SharedFile.json_schema(),
                  description: "List of files"
                }
              }
            }
          }
        }
      }
    ]
  )

  def index_by_tag(conn, %{"tag" => tag}) do
    file_list = SharedContent.list_public_shared_files_by_tag(tag)

    conn
    |> put_status(200)
    |> json(%{
      data: %{
        files:
          Uro.Interactor.SharedContentHelper.get_api_shared_content_list(file_list, %{
            merge_uploader_id: true
          })
      }
    })
  end

  operation(:show,
    operation_id: "getSharedFile",
    summary: "Get File",
    responses: [
      ok: {
        "A successful response returning a single public file",
        "application/json",
        %Schema{
          type: :object,
          properties: %{
            data: %Schema{
              type: :object,
              properties: %{
                files: Uro.Entities.SharedContent.SharedFile.json_schema()
              }
            }
          }
        }
      }
    ]
  )

  def show(conn, %{"id" => id}) do
    id
    |> SharedContent.get_public_shared_file!()
    |> case do
      %Uro.Entities.SharedContent.SharedFile{} = shared_file ->
        conn
        |> put_status(200)
        |> json(%{
          data: %{
            files:
              Uro.Interactor.SharedContentHelper.get_api_shared_content(
                shared_file,
                %{merge_uploader_id: true, merge_is_public: true}
              )
          }
        })

      _ ->
        put_status(
          conn,
          400
        )
    end
  end

  operation(:create,
    operation_id: "createFile",
    summary: "Upload file to server storage",
    responses: [
      ok: {
        "",
        "application/json",
        %Schema{}
      }
    ]
  )

  def create(conn, %{"storage" => storage_params}) do
    case SharedContent.create_shared_file(
           Uro.Interactor.SharedContentHelper.get_correct_shared_content_params(
             conn,
             storage_params,
             "shared_content_data"
           )
         ) do
      {:ok, stored_file} ->
        conn
        |> put_status(200)
        |> json(%{
          data: %{
            id: to_string(stored_file.id),
            file:
              Uro.Interactor.SharedContentHelper.get_api_shared_content(
                stored_file,
                %{merge_uploader_id: true}
              )
          }
        })

      {:error, %Ecto.Changeset{changes: _changes, errors: _errors} = changeset} ->
        {:error, changeset}
    end
  end

  operation(:update,
    operation_id: "updateSharedFile",
    summary: "Update File",
    responses: [
      ok: {
        "",
        "application/json",
        %Schema{}
      }
    ]
  )

  def update(conn, %{"id" => id, "file" => file_params}) do
    shared_file = SharedContent.get_shared_file!(id)

    case SharedContent.update_shared_file(shared_file, file_params) do
      {:ok, shared_file} ->
        conn
        |> put_status(200)
        |> json(%{
          data: %{
            id: to_string(shared_file.id),
            files:
              Uro.Interactor.SharedContentHelper.get_api_shared_content(
                shared_file,
                %{merge_uploader_id: true}
              )
          }
        })

      {:error, %Ecto.Changeset{changes: _changes, errors: _errors} = changeset} ->
        {:error, changeset}
    end
  end

  operation(:delete,
    operation_id: "deleteSharedFile",
    summary: "Delete File",
    responses: [
      ok: {
        "",
        "application/json",
        %Schema{}
      }
    ]
  )

  def delete(conn, %{"id" => id}) do
    case SharedContent.get_shared_file!(id) do
      %Uro.Entities.SharedContent.SharedFile{} = shared_file ->
        case SharedContent.delete_shared_file(shared_file) do
          {:ok, _shared_file} ->
            conn
            |> put_status(200)
            |> json(%{data: %{}})

          {:error, %Ecto.Changeset{changes: _changes, errors: _errors} = changeset} ->
            {:error, changeset}
        end

      _ ->
        put_status(
          conn,
          200
        )
    end
  end
end
