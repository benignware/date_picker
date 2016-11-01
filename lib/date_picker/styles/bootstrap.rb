module DatePicker
  module Styles
    class Bootstrap
      def types()
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
      def template
        %{
          <div id="<%= input_id %>_container" class="input-group">
            <div class="input-group-addon" style="cursor: pointer">
              <span class="glyphicon glyphicon-calendar"></span>
            </div>
            <%= instance.content_tag(input_tag, nil, html_options.except(:value)) %>
          </div>
          <input id="<%= input_id %>_hidden" type="hidden" value="<%= formatted_value %>" name="<%= name %>"/>
          <script>
            (function($) {
              var
                type = '<% type.to_s %>',
                tz = '<%= time_zone %>',
                date = <% if value.present? %>new Date(<%= time %>)<% else %>null<% end %>,
                m = date && <% if type.to_s == 'time' then %> moment(date).tz(tz) <% else %> moment(date) <% end %>,
                m = moment(date)
                datepicker = $('#<%= input_id %>_container').datetimepicker($.extend({}, <%= picker_options %>, {
                  locale: <%= locale.to_json %>,
                  format: <%= picker_format.to_json %>,
                  minDate: <%= min ? 'new Date("' + min.to_s + '")' : 'undefined' %>,
                  maxDate: <%= max ? 'new Date("' + max.to_s + '")' : 'undefined' %>,
                  useCurrent: false,
                  defaultDate: m
                })).on('dp.change', function(e) {
                  var d = e.date
                  console.log("debug date: ", d);
                  $('#<%= input_id %>_hidden').val(d.format('<%= data_format %>'));
                }).data('DateTimePicker')
                if (date) {
                  datepicker.date(m)
                }
            })(jQuery);
          </script>
        }
      end
    end
  end
end