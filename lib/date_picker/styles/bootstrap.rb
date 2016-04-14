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
                initialized = false,
                tz = '<%= time_zone %>',
                date = new Date('<%= value.strftime('%Y/%m/%d %H:%M:%S %z'); %>'),
                m = moment(date).tz(tz),
                datepicker = $('#<%= input_id %>_container').datetimepicker($.extend({}, <%= json_options %>, {
                  locale: <%= locale.to_json %>,
                  format: <%= format.to_json %>,
                  //defaultDate: m,
                  timeZone: null
                })).on('dp.show', function(e) {
                }).on('dp.change', function(e) {
                  $('#<%= input_id %>_hidden').val(e.date.format('<%= data_format %>'));
                }).data('DateTimePicker')
                datepicker.date(m)
              
              console.log("date: ", date, m, tz);
            })();
          </script>
        }
      end
    end
  end
end