# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data, 'https://pics.paypal.com', 'https://www.paypalobjects.com'
    policy.object_src  :none
    policy.script_src  :self, :https, 'https://www.paypalobjects.com'
    policy.style_src   :self, :https
    policy.connect_src :self, 'https://www.paypal.com', 'https://www.paypalobjects.com'
    # Allow iframes from educational game platforms and YouTube
    policy.frame_src   :self,
                       'https://wordwall.net',
                       'https://www.wordwall.net',
                       'https://educaplay.com',
                       'https://www.educaplay.com',
                       'https://www.youtube.com',
                       'https://youtube.com',
                       'https://www.paypal.com',
                       'https://islam4kids.netlify.app'
    # Specify URI for violation reports
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap, inline scripts, and inline styles.
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src style-src]

  # Report violations without enforcing the policy.
  # config.content_security_policy_report_only = true
end
