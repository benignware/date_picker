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
            <div class="input-group-addon" style="cursor: pointer">
              <span class="glyphicon glyphicon-calendar"></span>
            </div>
            <%= input_html %>
          </div>
          <input id="<%= input_id %>_hidden" type="hidden" value="<%= formatted_value %>" name="<%= name %>"/>
          <script>
            (function() {
              var
                tz = '<%= time_zone %>',
                date = <% if value.present? %>new Date('<%= value.strftime('%Y/%m/%d %H:%M:%S %z'); %>')<% else %>nil<% end %>,
                m = date && moment(date).tz(tz),
                datepicker = $('#<%= input_id %>_container').datetimepicker($.extend({}, <%= picker_options %>, {
                  locale: <%= locale.to_json %>,
                  format: <%= format.to_json %>,
                  timeZone: null
                })).on('dp.show', function(e) {
                }).on('dp.change', function(e) {
                  $('#<%= input_id %>_hidden').val(e.date.format('<%= data_format %>'));
                }).data('DateTimePicker')
                if (m) {
                  datepicker.date(m)
                }
              
              console.log("date: ", date, m, tz);
            })();
          </script>
        }
      end
    end
  end
end