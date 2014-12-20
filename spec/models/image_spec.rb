# == Schema Information
#
# Table name: images
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  name          :string(64)       not null
#  filename      :string(36)       not null
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Image do
  describe '#site' do
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.create(:image, site: site) }

    it 'returns images site' do
      expect(subject.site).to eq site
    end
  end

  describe '#created_by' do
    let(:account) { FactoryGirl.create(:account) }
    subject { FactoryGirl.create(:image, created_by: account) }

    it 'returns account' do
      expect(subject.created_by).to eq account
    end
  end

  describe '#updated_by' do
    let(:account) { FactoryGirl.create(:account) }
    subject { FactoryGirl.create(:image, updated_by: account) }

    it 'returns account' do
      expect(subject.updated_by).to eq account
    end
  end

  describe '#store_dir' do
    subject { FactoryGirl.build(:image) }

    it 'delegates to site' do
      expect(subject.store_dir).to eq subject.site.store_dir
    end
  end

  it 'has a file' do
    image = FactoryGirl.build(:image)
    file = image.file

    expect(file.url).to eq File.join(
      '/',
      Rails.application.secrets.uploads_store_dir,
      image.site.id.to_s,
      image.filename
    )
  end

  it 'strips attributes' do
    image = FactoryGirl.create(:image, name: "  #{new_name} ")
    expect(image.name).to eq new_name
  end

  describe 'validate' do
    subject { FactoryGirl.build(:image) }

    it { should validate_presence_of(:site_id) }

    it { should validate_presence_of(:name) }

    it { should validate_uniqueness_of(:name).scoped_to(:site_id) }

    it do
      should_not allow_value(
        '<a>bad</a>'
      ).for(:name).with_message('HTML not allowed')
    end

    it { should ensure_length_of(:name).is_at_most(64) }

    it { should validate_uniqueness_of(:filename).scoped_to(:site_id) }

    it { should validate_presence_of(:created_by) }

    it { should validate_presence_of(:updated_by) }
  end
end
