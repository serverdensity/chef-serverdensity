#
# Cookbook Name:: serverdensity
# Library:: api-v2-alerts

module ServerDensity
    module API
        module V2
            module Alerts
                
                def create_alert(device, meta)
                    post('/alerts/configs', validate(meta)).body
                    rescue => err
                    error(err, 'Unable to create alert on Serverdensity')
                end
                
                def find_alerts(resource)
                    get("/alert/configs/#{resource.id}", :params => {
                        :subjectType => resource.class.to_s.downcase
                        }).body
                        rescue => err
                        error(err, 'Unable to find alerts on Serverdensity')
                end
                
                def delete_alert(alert)
                    delete("/alerts/configs/#{alert.id}"); true
                    rescue => err
                    error(err, 'Unable to delete alert on Serverdensity')
                end
                
            end
        end
    end
end