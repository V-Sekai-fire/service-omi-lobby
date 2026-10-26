# SPDX-License-Identifier: MIT
# Copyright (c) 2026 K. S. Ernest (iFire) Lee
defmodule Uro.Contributors do
  @moduledoc ~S"""
  Where this code came from, and where the list of contributors lives.

  This repository started from a copy of [V-Sekai/uro](https://github.com/V-Sekai/uro)
  without its git history, so `git log` here shows only later work. The people who wrote
  Uro and its web front end before the copy are in the "Contributors" section of the
  README.

  ## Updating the list

  Counts come from the GitHub contributors API, which also counts commits from unlinked
  e-mail addresses (`anon=1`):

  ```sh
  gh api 'repos/V-Sekai/uro/contributors?per_page=100&anon=1' \
    --jq '.[] | "\(.login // .name) \(.contributions)"'
  ```

  Copy the result into the README table and keep the highest count first.
  """
end
