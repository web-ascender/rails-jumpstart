class HelloMailer < ApplicationMailer
  layout 'mailer'

  def welcome
    make_bootstrap_mail(
      to: 'to@example.com',
      from: 'from@example.com',
      subject: 'Hi From Bootstrap Email'
    )
  end
end