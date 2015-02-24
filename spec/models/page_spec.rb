# == Schema Information
#
# Table name: pages
#
#  id            :integer          not null, primary key
#  site_id       :integer          not null
#  url           :string(64)       not null
#  name          :string(64)       not null
#  private       :boolean          default("false"), not null
#  contact_form  :boolean          default("false"), not null
#  html_content  :text
#  created_by_id :integer          not null
#  updated_by_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Page do
  describe '#site' do
    let(:site) { FactoryGirl.create(:site) }
    subject { FactoryGirl.create(:page, site: site) }

    it 'returns images site' do
      expect(subject.site).to eq site
    end
  end

  describe '#created_by' do
    let(:user) { FactoryGirl.create(:user) }
    subject { FactoryGirl.create(:page, created_by: user) }

    it 'returns user' do
      expect(subject.created_by).to eq user
    end
  end

  describe '#updated_by' do
    let(:user) { FactoryGirl.create(:user) }
    subject { FactoryGirl.create(:page, updated_by: user) }

    it 'returns user' do
      expect(subject.updated_by).to eq user
    end
  end

  describe 'on save' do
    it 'sets url from name' do
      page = FactoryGirl.build(:page, name: "Test's Page")
      page.save!

      expect(page.name).to eq "Test's Page"
      expect(page.url).to eq 'tests_page'
    end
  end

  it 'is versioned', versioning: true do
    is_expected.to be_versioned
  end

  it 'strips attributes' do
    page = FactoryGirl.create(:page, name: "  #{new_name} ")

    expect(page.name).to eq new_name
  end

  it 'does not strip html_content' do
    text = "  #{new_message}"

    page = FactoryGirl.create(
      :page,
      html_content: text
    )

    expect(page.html_content).to eq text
  end

  describe 'validate' do
    subject { FactoryGirl.build(:page) }

    it { should validate_presence_of(:site_id) }

    it { should validate_presence_of(:url) }

    %w(
      health
      login
      logout
      new
      robots
      site
      sitemap
      timeout
      users
    ).each do |value|
      it { should_not allow_value(value).for(:url) }
    end

    it { should validate_presence_of(:name) }

    it { should validate_length_of(:name).is_at_most(64) }

    it { should validate_uniqueness_of(:name).scoped_to(:site_id) }

    it do
      should_not allow_value(
        '<a>bad</a>'
      ).for(:name).with_message('HTML not allowed')
    end

    it { should validate_presence_of(:created_by_id) }

    it { should validate_presence_of(:updated_by_id) }

    it { should allow_value('<a>html</a>').for(:html_content) }
  end

  describe '#name=' do
    it 'sets url as downcases name' do
      subject.name = 'Name'
      expect(subject.url).to eq 'name'
    end

    it 'sets url spaces with _' do
      subject.name = 'new name'
      expect(subject.url).to eq 'new_name'
    end

    it 'works when name is nil' do
      subject.name = nil
      expect(subject.url).to eq nil
    end
  end

  describe '#to_param' do
    subject { FactoryGirl.create(:page, name: 'Test Page') }

    it 'uses url' do
      expect(subject.to_param).to eq 'test_page'
    end

    it 'uses unchanged url' do
      subject.url = 'new_page'
      expect(subject.to_param).to eq 'test_page'
    end
  end
end
