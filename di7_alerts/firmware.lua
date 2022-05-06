function main()
  scheduler.add(30000, send_properties)
  scheduler.add(1000, send_telemetry)
end

function send_properties()
  enapter.send_properties({ vendor = 'Enapter', model = 'ENP-DI7', description ='This is a blueprint for DI7'})
end

function send_telemetry ()
  local telemetry = {}
  local alerts = {}
  for id = 1, 7 do
      local status, err = di7.is_closed(id)
      if status == nil then
        enapter.log("Reading closed di"..id.." failed: "..di7.err_to_st(err))
      else
        telemetry["di"..id.."_closed"] = status
        if status == true then
          table.insert(alerts,"DI"..id.."_closed_alert")
        end
      end
      local counter, reset_time, err = di7.read_counter(id)
      if counter == nil then
        enapter.log("Reading counter di"..id.." failed: "..di7.err_to_st(err))
      else
        telemetry["di"..id.."_counter"] = counter
        telemetry["di"..id.."_reset_time"] = reset_time
      end
  end
  telemetry["alerts"] = alerts
  enapter.send_telemetry(telemetry)
end

main()