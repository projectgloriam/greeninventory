require 'rufus-scheduler'

#scheduler = Rufus::Scheduler::singleton

# jobs go below here.

#scheduler.every '12h' do
#	equipment = Equipment.all
#	now = Date.today

#	equipment.each do |item|
#		expiry_date = Date.parse(item.customer_Warranty_end)
#		if item.warranty_alert == nil then
#			if now > (expiry_date - 3.month) then 
#				AlertMailer.warrant_alert(item).deliver_later
#				Rails.logger.info "Sent a warranty expiration alert email for #{item.model}. It will expire in less than 3 months"
#				PublicActivity.enabled = false
#				item.update({:warranty_alert => 1})
#				PublicActivity.enabled = true
#				Rails.logger.info "Warranty status is now #{item.warranty_alert}"
#			end
#		elsif item.warranty_alert == 1 then
#			if now > expiry_date then
#				AlertMailer.expired_alert(item).deliver_later
#				Rails.logger.info "Sent a warranty expiration alert email for #{item.model}. It has expired."
#				PublicActivity.enabled = false
#				item.update({:warranty_alert => 2})
#				PublicActivity.enabled = true
#				Rails.logger.info "Warranty status is now #{item.warranty_alert}"
#			end
#		end
#	end

#end