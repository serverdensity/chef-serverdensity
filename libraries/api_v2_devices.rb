#
# Cookbook Name:: serverdensity
# Library:: api-v2-devices

module ServerDensity
    module API
        module V2
            module Devices
                
                def create_device(meta)
                    post('/inventory/devices', validate(meta)).body
                    rescue => err
                    error(err, 'Unable to create device on Serverdensity')
                end
                
                def find_device(meta)
                    find_resource('device', meta)
                end
                
                def update_device(device, meta)
                    meta = validate(meta).reject { |k, v| device[k.to_s] == v }
                    return Hash.new if meta.empty?
                    put("/inventory/devices/#{device['_id']}", meta).body
                    rescue => err
                    error(err, 'Unable to update device on Serverdensity')
                end
                
            end
        end
    end
end
