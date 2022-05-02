class AlertMailer < ApplicationMailer
 
  def alert_email(spec)
    @spec = spec
    attachments[@spec.avatar.original_filename] = File.read(@spec.avatar.path, mode: "rb")
    #mail(to: "fadomako@fairgreenlimited.com", subject: "Specification Case: #{@spec.case}")
    mail(to: "otrs@fairgreenlimited.com", subject: "Specification Case: #{@spec.case}", cc: "logistics@fairgreenlimited.com")
  end

  def alert_email_reply(spec)
	@specification = spec
  attachments[@specification.avatar.original_filename] = File.read(@specification.avatar.path, mode: "rb")
  #mail(to: "fadomako@fairgreenlimited.com", subject: "Equipment testing complete")
  mail(to: "logistics@fairgreenlimited.com", subject: "Equipment testing complete", cc: "support@fairgreenlimited.com")
  end

  def rounds_alert(message,department_in_copy)
    @message = message
    domain = "@fairgreenlimited.com"
    in_copy = ""
    if department_in_copy.empty? == false then
      department_in_copy.each_with_index do |department,index|
        in_copy = in_copy + '<' + department + domain + '>'

        #if this is not the last row, put a comma after it
        if index != (department_in_copy.length-1) then
          in_copy = in_copy + ','
        end
      end
    end

    #mail(to: "fadomako@fairgreenlimited.com", subject: "NEXT WORKING DAY ROUND TRIPS")

    mail(to: "logistics@fairgreenlimited.com", subject: "NEXT WORKING DAY ROUND TRIPS", cc: in_copy+',<info@fairgreenlimited.com>')
  end

  def leave_email(leave_object)
    #fetches the right authorizer for the department
    def get_authorizer(department,level)
      department_query = ""

      #split department into array
      group = department.split(',')

      group.each_with_index do |area, index|
        department_query = department_query + "department LIKE '%" + area + "%'"
        department_query = department_query + " OR " if index != (group.length-1)
      end

      authorizer = Authorizer.select('username').where('level='+level+'AND ' + department_query).find(1)

      return authorizer.username + "@fairgreenlimited.com"
    end

    @leave = leave_object

    cc = '<'+@leave.username+'@fairgreenlimited.com>'

    recipient = '<'+@leave.username+'@fairgreenlimited.com>' #incase the code below fails

    subject = "LEAVE REQUEST"

    @msg = "Leave Request from " + @leave.staff_name

    @url = 'http://portal.green.local/leaves/' + @leave.id + '/edit'

    case
      #if the first authorizer field is full, send the mail to the authorizer with level 3. e.g. Gifty Boahene
    when @leave.authorizer.length > 0 
      recipient = "<" + get_authorizer(@leave.department,3) + ">"
      @msg = "Dear Sir or Madam, </br>" + @leave.staff_name + "'s leave request needs your final approval."
      #if the final authorizer field is full, send the mail to the staff who requested the leaf
    when @leave.final_authorizer.length > 0 
      recipient = "<" + @leave.username + "@fairgreenlimited.com>"
      subject = "LEAVE APPROVED"
      cc = "<" + get_authorizer(@leave.department,2) + ">"
      @msg = "Dear " + @leave.staff_name + ", </br>Your leave request has been approved."
      @url = 'http://portal.green.local/leaves/' + @leave.id
      #else send the mail to the first authorizer
    else
      recipient = "<" + get_authorizer(@leave.department,2) + ">"
      @msg = "Dear Sir or Madam, </br>" + @leave.staff_name + " has a leave request and wants your approval."
    end

    mail(to: recipient, subject: subject, cc: cc)
  end

  def warrant_alert(equipment)
    @equipment = equipment
    mail(to: "support@fairgreenlimited.com", subject: "Warranty Expiry Date", cc: "logistics@fairgreenlimited.com")
  end

  def expired_alert(equipment)
    @equipment = equipment
    mail(to: "support@fairgreenlimited.com", subject: "Warranty Expired", cc: "logistics@fairgreenlimited.com")
  end
end