class AlertMailer < ApplicationMailer
 
  def alert_email(spec)
    @spec = spec
    attachments.inline[@spec.avatar.original_filename] = File.read(@spec.avatar.path, mode: "rb")
        #mail(to: "fadomako@fairgreenlimited.com", subject: "Specification Case: #{@spec.case}")
    mail(to: "otrs@fairgreenlimited.com", subject: "Specification Case: #{@spec.case}",
    cc: "logistics@fairgreenlimited.com")
  end

  def alert_email_reply(spec)
	@specification = spec
  attachments.inline[@specification.avatar.original_filename] = File.read(@specification.avatar.path, mode: "rb")
          #mail(to: "fadomako@fairgreenlimited.com", subject: "Equipment testing complete")
  mail(to: "logistics@fairgreenlimited.com", subject: "Equipment testing complete",
		cc: "support@fairgreenlimited.com")
  end

  def warrant_alert(equipment)
    @equipment = equipment
    mail(to: "support@fairgreenlimited.com", subject: "Warranty Expiry Date", 
cc: "logistics@fairgreenlimited.com")
  end

  def expired_alert(equipment)
    @equipment = equipment
    mail(to: "support@fairgreenlimited.com", subject: "Warranty Expired",
cc: "logistics@fairgreenlimited.com")
  end
end