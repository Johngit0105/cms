require 'rails_helper'

RSpec.describe 'API Messages' do
  let(:request_user) { FactoryBot.create(:user, site: site) }
  let(:message) { FactoryBot.create(:message, site: site) }

  let(:expected_result) do
    {
      'uid' => message.uid,
      'name' => message.name,
      'email' => message.email,
      'phone' => message.phone,
      'message' => message.message,
      'created_at' => message.created_at.iso8601,
      'updated_at' => message.updated_at.iso8601
    }
  end

  describe 'GET /api/messages' do
    include_examples(
      'swagger documentation',
      description: 'Lists messages'
    )

    it 'returns array of messages' do
      message
      request_page

      expect(json_body).to eq [expected_result]
    end
  end

  describe 'POST /api/messages' do
    let(:request_params) do
      {
        'name' => new_name,
        'email' => new_email,
        'phone' => new_phone,
        'message' => new_message
      }
    end

    let(:message) { Message.last }

    include_examples(
      'swagger documentation',
      description: 'Creates a message'
    )

    it 'creates a message' do
      request_page(expected_status: 201)

      expect(json_body).to eq expected_result
    end
  end

  describe 'GET /api/messages/:id' do
    let(:request_path_id) { message.uid }

    include_examples(
      'swagger documentation',
      description: 'Shows a message'
    )

    it 'returns a message' do
      request_page

      expect(json_body).to eq expected_result
    end
  end

  describe 'DELETE /api/messages/:id' do
    let(:request_path_id) { message.uid }

    include_examples(
      'swagger documentation',
      description: 'Deletes a message'
    )

    it 'deletes a message' do
      request_page(expected_status: 204)
      expect(Message.find_by(id: message.id)).to be_nil
    end
  end
end