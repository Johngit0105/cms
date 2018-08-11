AWS_CONFIG = { stub_responses: ENV['AWS_STUB'].present? }.freeze

AWS_COGNITO = Aws::CognitoIdentityProvider::Client.new(AWS_CONFIG)

if ENV['AWS_STUB'].present? && !Rails.env.production?
  AWS_COGNITO.stub_responses(
    :list_users_in_group,
    AWS_COGNITO.stub_data(
      :list_users_in_group,
      JSON.parse(
        Rails.root.join('spec', 'stubs', 'aws_cognito_list_users_in_group.json').read
      )
    )
  )

  AWS_COGNITO.stub_responses(
    :list_groups,
    AWS_COGNITO.stub_data(
      :list_groups,
      JSON.parse(
        Rails.root.join('spec', 'stubs', 'aws_cognito_list_groups.json').read
      )
    )
  )
end
