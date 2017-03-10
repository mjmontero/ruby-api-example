
require "mail"

# email options using test account
options = {
	:address    			=> "smtp.gmail.com",
  :port       			=> 587,
  :user_name  			=> 'mjmracdcorp@gmail.com',
  :password   			=> 'corpacd2017',
  :authentication 	=> 'plain',
  :enable_starttls_auto => true	
}

# mail defaults
Mail.defaults do
	delivery_method :smtp, options
end

class Mailer

	@queue = :mailing	# queue name

	# In order for this to work you'll need to have this running
	# bundle exec rake resque:work QUEUE=mailing
  def self.perform(email_address, email_subject, email_body)
  	# sends mail
    Mail.deliver do
		  from     SYSTEM_EMAIL
		  to       email_address
		  subject  email_subject
		  body     email_body
		end  		
  end
end

