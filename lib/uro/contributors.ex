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

  The list holds names only, because commit counts go stale. The lobby page
  (`frontend/src/app/(static)/page.tsx`) and the README show the same people. List the names
  with the GitHub contributors API, which also returns unlinked e-mail addresses (`anon=1`):

  ```sh
  gh api 'repos/V-Sekai/uro/contributors?per_page=100&anon=1' --jq '.[] | .login // .name'
  ```

  Change the README and the page together.
  """
end
