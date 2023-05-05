# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `turbo-rails` gem.
# Please instead update this file by running `bin/tapioca gem turbo-rails`.

class ActionController::Base < ActionController::Metal
  include ::ActionDispatch::Routing::PolymorphicRoutes
  include ::ActionController::Head
  include ::AbstractController::Caching::ConfigMethods
  include ::ActionController::BasicImplicitRender
  include ::Devise::Controllers::SignInOut
  include ::Devise::Controllers::StoreLocation

  # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
  def __callbacks; end

  # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
  def __callbacks?; end

  # source://cancancan/3.5.0/lib/cancan/controller_additions.rb#298
  def _cancan_skipper; end

  # source://cancancan/3.5.0/lib/cancan/controller_additions.rb#298
  def _cancan_skipper=(_arg0); end

  # source://cancancan/3.5.0/lib/cancan/controller_additions.rb#298
  def _cancan_skipper?; end

  # source://actionpack/7.0.4.3/lib/abstract_controller/helpers.rb#11
  def _helper_methods; end

  # source://actionpack/7.0.4.3/lib/abstract_controller/helpers.rb#11
  def _helper_methods=(_arg0); end

  # source://actionpack/7.0.4.3/lib/abstract_controller/helpers.rb#11
  def _helper_methods?; end

  # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#940
  def _process_action_callbacks; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/renderers.rb#31
  def _renderers; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/renderers.rb#31
  def _renderers=(_arg0); end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/renderers.rb#31
  def _renderers?; end

  # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#928
  def _run_process_action_callbacks(&); end

  # source://actionpack/7.0.4.3/lib/abstract_controller/caching.rb#42
  def _view_cache_dependencies; end

  # source://actionpack/7.0.4.3/lib/abstract_controller/caching.rb#42
  def _view_cache_dependencies=(_arg0); end

  # source://actionpack/7.0.4.3/lib/abstract_controller/caching.rb#42
  def _view_cache_dependencies?; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/params_wrapper.rb#185
  def _wrapper_options; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/params_wrapper.rb#185
  def _wrapper_options=(_arg0); end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/params_wrapper.rb#185
  def _wrapper_options?; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/flash.rb#36
  def alert; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def allow_forgery_protection; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def allow_forgery_protection=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def asset_host; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def asset_host=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def assets_dir; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def assets_dir=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def default_asset_host_protocol; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def default_asset_host_protocol=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def default_protect_from_forgery; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def default_protect_from_forgery=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def default_static_extension; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def default_static_extension=(value); end

  # source://actionpack/7.0.4.3/lib/action_dispatch/routing/url_for.rb#95
  def default_url_options; end

  # source://actionpack/7.0.4.3/lib/action_dispatch/routing/url_for.rb#95
  def default_url_options=(_arg0); end

  # source://actionpack/7.0.4.3/lib/action_dispatch/routing/url_for.rb#95
  def default_url_options?; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def enable_fragment_cache_logging; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def enable_fragment_cache_logging=(value); end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/etag_with_template_digest.rb#27
  def etag_with_template_digest; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/etag_with_template_digest.rb#27
  def etag_with_template_digest=(_arg0); end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/etag_with_template_digest.rb#27
  def etag_with_template_digest?; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/conditional_get.rb#13
  def etaggers; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/conditional_get.rb#13
  def etaggers=(_arg0); end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/conditional_get.rb#13
  def etaggers?; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/flash.rb#10
  def flash(*_arg0, **_arg1, &); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def forgery_protection_origin_check; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def forgery_protection_origin_check=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def forgery_protection_strategy; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def forgery_protection_strategy=(value); end

  # source://actionpack/7.0.4.3/lib/abstract_controller/caching/fragments.rb#23
  def fragment_cache_keys; end

  # source://actionpack/7.0.4.3/lib/abstract_controller/caching/fragments.rb#23
  def fragment_cache_keys=(_arg0); end

  # source://actionpack/7.0.4.3/lib/abstract_controller/caching/fragments.rb#23
  def fragment_cache_keys?; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#63
  def helpers_path; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#63
  def helpers_path=(_arg0); end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#63
  def helpers_path?; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#64
  def include_all_helpers; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#64
  def include_all_helpers=(_arg0); end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#64
  def include_all_helpers?; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def javascripts_dir; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def javascripts_dir=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def log_warning_on_csrf_failure; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def log_warning_on_csrf_failure=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def logger; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def logger=(value); end

  # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
  def mimes_for_respond_to; end

  # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
  def mimes_for_respond_to=(_arg0); end

  # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
  def mimes_for_respond_to?; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/flash.rb#36
  def notice; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def per_form_csrf_tokens; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def per_form_csrf_tokens=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def perform_caching; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def perform_caching=(value); end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/redirecting.rb#13
  def raise_on_open_redirects; end

  # source://actionpack/7.0.4.3/lib/action_controller/metal/redirecting.rb#13
  def raise_on_open_redirects=(val); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def relative_url_root; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def relative_url_root=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def request_forgery_protection_token; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def request_forgery_protection_token=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/rescuable.rb#13
  def rescue_handlers; end

  # source://activesupport/7.0.4.3/lib/active_support/rescuable.rb#13
  def rescue_handlers=(_arg0); end

  # source://activesupport/7.0.4.3/lib/active_support/rescuable.rb#13
  def rescue_handlers?; end

  # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
  def responder; end

  # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
  def responder=(_arg0); end

  # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
  def responder?; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def stylesheets_dir; end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
  def stylesheets_dir=(value); end

  # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
  def urlsafe_csrf_tokens; end

  private

  # source://actionview/7.0.4.3/lib/action_view/layouts.rb#328
  def _layout(lookup_context, formats); end

  def _layout_from_proc; end

  # source://actionpack/7.0.4.3/lib/action_controller/base.rb#266
  def _protected_ivars; end

  class << self
    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
    def __callbacks; end

    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
    def __callbacks=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
    def __callbacks?; end

    # source://cancancan/3.5.0/lib/cancan/controller_additions.rb#298
    def _cancan_skipper; end

    # source://cancancan/3.5.0/lib/cancan/controller_additions.rb#298
    def _cancan_skipper=(value); end

    # source://cancancan/3.5.0/lib/cancan/controller_additions.rb#298
    def _cancan_skipper?; end

    # source://actionpack/7.0.4.3/lib/action_controller/form_builder.rb#31
    def _default_form_builder; end

    # source://actionpack/7.0.4.3/lib/action_controller/form_builder.rb#31
    def _default_form_builder=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/form_builder.rb#31
    def _default_form_builder?; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/flash.rb#8
    def _flash_types; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/flash.rb#8
    def _flash_types=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/flash.rb#8
    def _flash_types?; end

    # source://actionpack/7.0.4.3/lib/abstract_controller/helpers.rb#11
    def _helper_methods; end

    # source://actionpack/7.0.4.3/lib/abstract_controller/helpers.rb#11
    def _helper_methods=(value); end

    # source://actionpack/7.0.4.3/lib/abstract_controller/helpers.rb#11
    def _helper_methods?; end

    # source://actionpack/7.0.4.3/lib/abstract_controller/helpers.rb#15
    def _helpers; end

    # source://actionview/7.0.4.3/lib/action_view/layouts.rb#209
    def _layout; end

    # source://actionview/7.0.4.3/lib/action_view/layouts.rb#209
    def _layout=(value); end

    # source://actionview/7.0.4.3/lib/action_view/layouts.rb#209
    def _layout?; end

    # source://actionview/7.0.4.3/lib/action_view/layouts.rb#210
    def _layout_conditions; end

    # source://actionview/7.0.4.3/lib/action_view/layouts.rb#210
    def _layout_conditions=(value); end

    # source://actionview/7.0.4.3/lib/action_view/layouts.rb#210
    def _layout_conditions?; end

    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#932
    def _process_action_callbacks; end

    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#936
    def _process_action_callbacks=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/renderers.rb#31
    def _renderers; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/renderers.rb#31
    def _renderers=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/renderers.rb#31
    def _renderers?; end

    # source://actionpack/7.0.4.3/lib/abstract_controller/caching.rb#42
    def _view_cache_dependencies; end

    # source://actionpack/7.0.4.3/lib/abstract_controller/caching.rb#42
    def _view_cache_dependencies=(value); end

    # source://actionpack/7.0.4.3/lib/abstract_controller/caching.rb#42
    def _view_cache_dependencies?; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/params_wrapper.rb#185
    def _wrapper_options; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/params_wrapper.rb#185
    def _wrapper_options=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/params_wrapper.rb#185
    def _wrapper_options?; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def allow_forgery_protection; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def allow_forgery_protection=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def asset_host; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def asset_host=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def assets_dir; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def assets_dir=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def default_asset_host_protocol; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def default_asset_host_protocol=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def default_protect_from_forgery; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def default_protect_from_forgery=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def default_static_extension; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def default_static_extension=(value); end

    # source://actionpack/7.0.4.3/lib/action_dispatch/routing/url_for.rb#95
    def default_url_options; end

    # source://actionpack/7.0.4.3/lib/action_dispatch/routing/url_for.rb#95
    def default_url_options=(value); end

    # source://actionpack/7.0.4.3/lib/action_dispatch/routing/url_for.rb#95
    def default_url_options?; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def enable_fragment_cache_logging; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def enable_fragment_cache_logging=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/etag_with_template_digest.rb#27
    def etag_with_template_digest; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/etag_with_template_digest.rb#27
    def etag_with_template_digest=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/etag_with_template_digest.rb#27
    def etag_with_template_digest?; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/conditional_get.rb#13
    def etaggers; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/conditional_get.rb#13
    def etaggers=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/conditional_get.rb#13
    def etaggers?; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def forgery_protection_origin_check; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def forgery_protection_origin_check=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def forgery_protection_strategy; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def forgery_protection_strategy=(value); end

    # source://actionpack/7.0.4.3/lib/abstract_controller/caching/fragments.rb#23
    def fragment_cache_keys; end

    # source://actionpack/7.0.4.3/lib/abstract_controller/caching/fragments.rb#23
    def fragment_cache_keys=(value); end

    # source://actionpack/7.0.4.3/lib/abstract_controller/caching/fragments.rb#23
    def fragment_cache_keys?; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#63
    def helpers_path; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#63
    def helpers_path=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#63
    def helpers_path?; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#64
    def include_all_helpers; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#64
    def include_all_helpers=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/helpers.rb#64
    def include_all_helpers?; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def javascripts_dir; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def javascripts_dir=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def log_warning_on_csrf_failure; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def log_warning_on_csrf_failure=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def logger; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def logger=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal.rb#210
    def middleware_stack; end

    # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
    def mimes_for_respond_to; end

    # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
    def mimes_for_respond_to=(value); end

    # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
    def mimes_for_respond_to?; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def per_form_csrf_tokens; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def per_form_csrf_tokens=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def perform_caching; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def perform_caching=(value); end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/redirecting.rb#13
    def raise_on_open_redirects; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/redirecting.rb#13
    def raise_on_open_redirects=(val); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def relative_url_root; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def relative_url_root=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def request_forgery_protection_token; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def request_forgery_protection_token=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/rescuable.rb#13
    def rescue_handlers; end

    # source://activesupport/7.0.4.3/lib/active_support/rescuable.rb#13
    def rescue_handlers=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/rescuable.rb#13
    def rescue_handlers?; end

    # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
    def responder; end

    # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
    def responder=(value); end

    # source://responders/3.1.0/lib/action_controller/respond_with.rb#11
    def responder?; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def stylesheets_dir; end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#114
    def stylesheets_dir=(value); end

    # source://activesupport/7.0.4.3/lib/active_support/configurable.rb#113
    def urlsafe_csrf_tokens; end

    # source://actionpack/7.0.4.3/lib/action_controller/metal/request_forgery_protection.rb#97
    def urlsafe_csrf_tokens=(urlsafe_csrf_tokens); end

    # source://actionpack/7.0.4.3/lib/action_controller/base.rb#198
    def without_modules(*modules); end
  end
end

# source://turbo-rails//lib/turbo/test_assertions.rb#1
module Turbo
  extend ::ActiveSupport::Autoload

  class << self
    # source://railties/7.0.4.3/lib/rails/engine.rb#405
    def railtie_helpers_paths; end

    # source://railties/7.0.4.3/lib/rails/engine.rb#394
    def railtie_namespace; end

    # source://railties/7.0.4.3/lib/rails/engine.rb#409
    def railtie_routes_url_helpers(include_path_helpers = T.unsafe(nil)); end

    # source://turbo-rails//lib/turbo-rails.rb#9
    def signed_stream_verifier; end

    # source://turbo-rails//lib/turbo-rails.rb#13
    def signed_stream_verifier_key; end

    # Sets the attribute signed_stream_verifier_key
    #
    # @param value the value to set the attribute signed_stream_verifier_key to.
    #
    # source://turbo-rails//lib/turbo-rails.rb#7
    def signed_stream_verifier_key=(_arg0); end

    # source://railties/7.0.4.3/lib/rails/engine.rb#397
    def table_name_prefix; end

    # source://railties/7.0.4.3/lib/rails/engine.rb#401
    def use_relative_model_naming?; end
  end
end

module Turbo::Broadcastable
  extend ::ActiveSupport::Concern

  mixes_in_class_methods ::Turbo::Broadcastable::ClassMethods

  def broadcast_action(action, target: T.unsafe(nil), **rendering); end
  def broadcast_action_later(action:, target: T.unsafe(nil), **rendering); end
  def broadcast_action_later_to(*streamables, action:, target: T.unsafe(nil), **rendering); end
  def broadcast_action_to(*streamables, action:, target: T.unsafe(nil), **rendering); end
  def broadcast_after_to(*streamables, target:, **rendering); end
  def broadcast_append(target: T.unsafe(nil), **rendering); end
  def broadcast_append_later(target: T.unsafe(nil), **rendering); end
  def broadcast_append_later_to(*streamables, target: T.unsafe(nil), **rendering); end
  def broadcast_append_to(*streamables, target: T.unsafe(nil), **rendering); end
  def broadcast_before_to(*streamables, target:, **rendering); end
  def broadcast_prepend(target: T.unsafe(nil), **rendering); end
  def broadcast_prepend_later(target: T.unsafe(nil), **rendering); end
  def broadcast_prepend_later_to(*streamables, target: T.unsafe(nil), **rendering); end
  def broadcast_prepend_to(*streamables, target: T.unsafe(nil), **rendering); end
  def broadcast_remove; end
  def broadcast_remove_to(*streamables, target: T.unsafe(nil)); end
  def broadcast_render(**rendering); end
  def broadcast_render_later(**rendering); end
  def broadcast_render_later_to(*streamables, **rendering); end
  def broadcast_render_to(*streamables, **rendering); end
  def broadcast_replace(**rendering); end
  def broadcast_replace_later(**rendering); end
  def broadcast_replace_later_to(*streamables, **rendering); end
  def broadcast_replace_to(*streamables, **rendering); end
  def broadcast_update(**rendering); end
  def broadcast_update_later(**rendering); end
  def broadcast_update_later_to(*streamables, **rendering); end
  def broadcast_update_to(*streamables, **rendering); end

  private

  def broadcast_rendering_with_defaults(options); end
  def broadcast_target_default; end
end

module Turbo::Broadcastable::ClassMethods
  def broadcast_target_default; end
  def broadcasts(stream = T.unsafe(nil), inserts_by: T.unsafe(nil), target: T.unsafe(nil), **rendering); end
  def broadcasts_to(stream, inserts_by: T.unsafe(nil), target: T.unsafe(nil), **rendering); end
end

module Turbo::DriveHelper
  def turbo_exempts_page_from_cache; end
  def turbo_exempts_page_from_preview; end
  def turbo_page_requires_reload; end
end

# source://turbo-rails//lib/turbo/engine.rb#5
class Turbo::Engine < Rails::Engine
  class << self
    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
    def __callbacks; end
  end
end

# If you don't want to precompile Turbo's assets (eg. because you're using webpack),
# you can do this in an intiailzer:
#
# config.after_initialize do
#   config.assets.precompile -= Turbo::Engine::PRECOMPILE_ASSETS
# end
#
# source://turbo-rails//lib/turbo/engine.rb#29
Turbo::Engine::PRECOMPILE_ASSETS = T.let(T.unsafe(nil), Array)

module Turbo::Frames; end

module Turbo::Frames::FrameRequest
  extend ::ActiveSupport::Concern

  private

  def turbo_frame_request?; end
  def turbo_frame_request_id; end
end

module Turbo::FramesHelper
  def turbo_frame_tag(*ids, src: T.unsafe(nil), target: T.unsafe(nil), **attributes, &block); end
end

module Turbo::IncludesHelper
  def turbo_include_tags; end
end

module Turbo::Native; end

module Turbo::Native::Navigation
  private

  def recede_or_redirect_back_or_to(url, **options); end
  def recede_or_redirect_to(url, **options); end
  def refresh_or_redirect_back_or_to(url, **options); end
  def refresh_or_redirect_to(url, **options); end
  def resume_or_redirect_back_or_to(url, **options); end
  def resume_or_redirect_to(url, **options); end
  def turbo_native_action_or_redirect(url, action, redirect_type, options = T.unsafe(nil)); end
  def turbo_native_app?; end
end

class Turbo::Native::NavigationController < ActionController::Base
  def recede; end
  def refresh; end
  def resume; end

  private

  # source://actionview/7.0.4.3/lib/action_view/layouts.rb#328
  def _layout(lookup_context, formats); end

  def _layout_from_proc; end

  class << self
    # source://actionpack/7.0.4.3/lib/action_controller/metal.rb#210
    def middleware_stack; end
  end
end

module Turbo::Streams; end

class Turbo::Streams::ActionBroadcastJob < ActiveJob::Base
  def perform(stream, action:, target:, **rendering); end

  class << self
    # source://activesupport/7.0.4.3/lib/active_support/rescuable.rb#13
    def rescue_handlers; end
  end
end

module Turbo::Streams::ActionHelper
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::OutputSafetyHelper
  include ::ActionView::Helpers::TagHelper

  def turbo_stream_action_tag(action, target: T.unsafe(nil), targets: T.unsafe(nil), template: T.unsafe(nil),
                              **attributes)
  end

  private

  def convert_to_turbo_stream_dom_id(target, include_selector: T.unsafe(nil)); end
end

class Turbo::Streams::BroadcastJob < ActiveJob::Base
  def perform(stream, **rendering); end

  class << self
    # source://activesupport/7.0.4.3/lib/active_support/rescuable.rb#13
    def rescue_handlers; end
  end
end

module Turbo::Streams::Broadcasts
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::OutputSafetyHelper
  include ::ActionView::Helpers::TagHelper
  include ::Turbo::Streams::ActionHelper

  def broadcast_action_later_to(*streamables, action:, target: T.unsafe(nil), targets: T.unsafe(nil), **rendering); end
  def broadcast_action_to(*streamables, action:, target: T.unsafe(nil), targets: T.unsafe(nil), **rendering); end
  def broadcast_after_later_to(*streamables, **opts); end
  def broadcast_after_to(*streamables, **opts); end
  def broadcast_append_later_to(*streamables, **opts); end
  def broadcast_append_to(*streamables, **opts); end
  def broadcast_before_later_to(*streamables, **opts); end
  def broadcast_before_to(*streamables, **opts); end
  def broadcast_prepend_later_to(*streamables, **opts); end
  def broadcast_prepend_to(*streamables, **opts); end
  def broadcast_remove_to(*streamables, **opts); end
  def broadcast_render_later_to(*streamables, **rendering); end
  def broadcast_render_to(*streamables, **rendering); end
  def broadcast_replace_later_to(*streamables, **opts); end
  def broadcast_replace_to(*streamables, **opts); end
  def broadcast_stream_to(*streamables, content:); end
  def broadcast_update_later_to(*streamables, **opts); end
  def broadcast_update_to(*streamables, **opts); end

  private

  def render_format(format, **rendering); end
end

module Turbo::Streams::StreamName
  def signed_stream_name(streamables); end
  def verified_stream_name(signed_stream_name); end

  private

  def stream_name_from(streamables); end
end

module Turbo::Streams::StreamName::ClassMethods
  def verified_stream_name_from_params; end
end

class Turbo::Streams::TagBuilder
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::OutputSafetyHelper
  include ::ActionView::Helpers::TagHelper
  include ::Turbo::Streams::ActionHelper

  def initialize(view_context); end

  def action(name, target, content = T.unsafe(nil), allow_inferred_rendering: T.unsafe(nil), **rendering, &block); end

  def action_all(name, targets, content = T.unsafe(nil), allow_inferred_rendering: T.unsafe(nil), **rendering, &block)
  end

  def after(target, content = T.unsafe(nil), **rendering, &); end
  def after_all(targets, content = T.unsafe(nil), **rendering, &); end
  def append(target, content = T.unsafe(nil), **rendering, &); end
  def append_all(targets, content = T.unsafe(nil), **rendering, &); end
  def before(target, content = T.unsafe(nil), **rendering, &); end
  def before_all(targets, content = T.unsafe(nil), **rendering, &); end
  def prepend(target, content = T.unsafe(nil), **rendering, &); end
  def prepend_all(targets, content = T.unsafe(nil), **rendering, &); end
  def remove(target); end
  def remove_all(targets); end
  def replace(target, content = T.unsafe(nil), **rendering, &); end
  def replace_all(targets, content = T.unsafe(nil), **rendering, &); end
  def update(target, content = T.unsafe(nil), **rendering, &); end
  def update_all(targets, content = T.unsafe(nil), **rendering, &); end

  private

  def render_record(possible_record); end

  def render_template(target, content = T.unsafe(nil), allow_inferred_rendering: T.unsafe(nil), **rendering, &block); end
end

module Turbo::Streams::TurboStreamsTagBuilder
  private

  def turbo_stream; end
end

class Turbo::StreamsChannel < ActionCable::Channel::Base
  include ::Turbo::Streams::StreamName::ClassMethods
  extend ::Turbo::Streams::StreamName
  extend ::ActionView::Helpers::CaptureHelper
  extend ::ActionView::Helpers::OutputSafetyHelper
  extend ::ActionView::Helpers::TagHelper
  extend ::Turbo::Streams::ActionHelper
  extend ::Turbo::Streams::Broadcasts

  def subscribed; end

  class << self
    # source://activesupport/7.0.4.3/lib/active_support/callbacks.rb#68
    def __callbacks; end
  end
end

module Turbo::StreamsHelper
  def turbo_stream; end
  def turbo_stream_from(*streamables, **attributes); end
end

# source://turbo-rails//lib/turbo/test_assertions.rb#2
module Turbo::TestAssertions
  extend ::ActiveSupport::Concern

  # source://turbo-rails//lib/turbo/test_assertions.rb#19
  def assert_no_turbo_stream(action:, target: T.unsafe(nil), targets: T.unsafe(nil)); end

  # source://turbo-rails//lib/turbo/test_assertions.rb#10
  def assert_turbo_stream(action:, target: T.unsafe(nil), targets: T.unsafe(nil), status: T.unsafe(nil), &block); end
end
