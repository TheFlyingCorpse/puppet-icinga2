<%= scope.function_template(['icinga2/_header.erb']) -%>

library "perfdata"

object InfluxdbWriter "<%= @name -%>" {
  <%-#- If any of the @ parameters are undefined, don't print anything for them: -%>
  <%- if @host -%>
  <%-# Otherwise, include the parameter: -%>
  host = "<%= @host %>"
  <%- end -%>
  <%- if @port -%>
  port = <%= @port %>
  <%- end -%>
  <%- if @db -%>
  db = "<%= @db %>"
  <%- end -%>
  <%- if @username -%>
  username = "<%= @username %>"
  <%- end -%>
  <%- if @password -%>
  password = "<%= @password %>"
  <%- end -%>
  <-%- Only set this if ssl_enable is configured. -%>
  <%- if @ssl_enable -%>
  ssl_enable = "<%= @ssl_enable -%>"
  ssl_ca_cert = "<%= @ssl_ca_cert -%>"
  ssl_cert = "<%= @ssl_cert -%>"
  ssl_key = "<%= @ssl_key -%>"
  <%- end -%>
  <%- if @host_template -%>
  host_template = "<%= @host_template %>"
  <%- else -%>
  host_template = {
    measurement = "$host.check_command$"
    tags = {
      hostname = "$host.name$"
    }
  }
  <%- end -%>
  <%- if @service_template -%>
  service_template = "<%= @service_template %>"
  <%- else -%>
  service_template = {
    measurement = "$service.check_command$"
    tags = {
      hostname = "$host.name$"
      service = "$service.name$"
    }
  }
  <%- end -%>
  <%- if @enable_send_thresholds.is_a? TrueClass or @enable_send_thresholds.is_a? FalseClass -%>
  enable_send_thresholds = <%= @enable_send_thresholds %>
  <%- end -%>
  <%- if @enable_send_metadata.is_a? TrueClass or @enable_send_metadata.is_a? FalseClass -%>
  enable_send_metadata = <%= @enable_send_metadata %>
  <%- end -%>
  <%- if @flush_interval -%>
  flush_interval = <%= @flush_interval -%>
  <%- end -%>
  <%- if @flush_threshold -%>
  flush_threshold = <%= @flush_threshold -%>
  <%- end -%>

}
