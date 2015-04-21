module DatePicker
  module Styles
    class Bootstrap
      def types
        [:date, :datetime, :time]
      end
      def options()
        {
          class: 'form-control'
        }
      end
      def mapping()
        :moment
      end
      def template() 
        %{
          <div id="<%= input_id %>_container" class="input-group">
            <div class="input-group-addon">
              <span class="glyphicon glyphicon-calendar"></span>
            </div>
            <%= input_html %>
          </div>
          <input id="<%= input_id %>_hidden" type="hidden" value="<%= formatted_value %>" name="<%= name %>"/>
          <script>
            (function() {
              var datepicker = $('#<%= input_id %>_container').datetimepicker($.extend({}, <%= json_options %>, {
                  locale: <%= locale.to_json %>,
                  format: <%= format.to_json %>
                }))
                .on('dp.change', function(e) {
                  $('#<%= input_id %>_hidden').val(e.date.format('<%= data_format %>'));
                }).data('DateTimePicker');
                <% if time %> datepicker.date(moment.utc(new Date(<%= time %>))); <% end %>
            })();
          </script>
        }
      end
    end
  end
end