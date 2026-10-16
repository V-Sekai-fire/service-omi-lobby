[
  # Baseline: pre-existing warnings from the first `mix dialyzer` run
  # (dialyxir just added, no prior Dialyzer history to compare against).
  # None of these are in code touched by that session -- keeping the
  # gate green from here on, not hiding these permanently. Remove an
  # entry once its file is actually fixed rather than leaving it here
  # after the warning stops firing.
  {"lib/uro/accounts.ex", :call_without_opaque},
  {"lib/uro/controllers/fallback.ex", :invalid_contract},
  {"lib/uro/helpers/validation.ex", :no_return},
  {"lib/uro/helpers/validation.ex", :call},
  {"lib/uro/plug/authentication.ex", :no_return},
  {"lib/uro/plug/require_admin.ex", :unknown_type},
  {"lib/uro/plug/require_shared_file_upload_permission.ex", :unknown_type},
  {"lib/uro/plug/require_user.ex", :unknown_type},
  {"lib/uro/router.ex", :callback_not_exported},
  # CI runs Elixir 1.17/OTP 27 (.github/workflows/ci.yml); this repo's
  # local dev toolchain is newer (1.20.2/OTP 29) -- Dialyzer's warning
  # set isn't identical across that gap, so this entry only ever
  # surfaced in CI, not locally.
  {"lib/uro/router.ex", :no_return},
  {"lib/uro/shared_content.ex", :call_without_opaque}
]
