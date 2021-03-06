SMTP_SETTINGS = {
  address: ENV.fetch("MAILGUN_SMTP_SERVER"), # example: "smtp.sendgrid.net"
  authentication: :plain,
  domain: ENV.fetch("MAILGUN_SMTP_DOMAIN"), # example: "heroku.com"
  enable_starttls_auto: true,
  password: ENV.fetch("MAILGUN_SMTP_PASSWORD"),
  port: "587",
  user_name: ENV.fetch("MAILGUN_SMTP_LOGIN")
}

if ENV["EMAIL_RECIPIENTS"].present?
  Mail.register_interceptor RecipientInterceptor.new(ENV["EMAIL_RECIPIENTS"])
end
