require 'rails_helper'

RSpec.describe LogoUploader, uploads: true do
  include CarrierWave::Test::Matchers

  let(:site) { FactoryGirl.create(:site) }
  subject { described_class.new(site) }

  describe '#store_dir' do
    it 'delegates to site' do
      expect(subject.store_dir).to eq site.store_dir
    end
  end

  describe '.store!' do
    it 'must be an image' do
      expect { subject.store! StringUploader.new('stylesheet.exe', 'asd') }
        .to raise_error(
          CarrierWave::IntegrityError,
          /.* "exe" files, allowed types: jpg, jpeg, png/
        )
    end

    it 'has filename which is  md5 of content' do
      expect(uploaded_files).to eq []

      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpg'))

      expect(uploaded_files).to eq [
        "#{site.id}",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_header.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_nav.jpg"
      ].sort
    end

    it 'creates multiple sized images at same aspect ratio' do
      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpg'))

      expect(subject.header).to have_dimensions(940, 705)
      expect(subject.nav).to have_dimensions(60, 45)
    end

    it 'does not enlarge images' do
      subject.store! File.open(Rails.root.join('spec/assets/small.jpg'))

      expect(subject.header).to have_dimensions(80, 80)
      expect(subject.nav).to have_dimensions(60, 60)
    end

    it 'saves extension as downcase' do
      expect(uploaded_files).to eq []

      subject.store! File.open(Rails.root.join('spec/assets/test_image.JPG'))

      expect(uploaded_files).to eq [
        "#{site.id}",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_header.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_nav.jpg"
      ].sort
    end

    it 'saves .jpeg as jpg' do
      expect(uploaded_files).to eq []

      subject.store! File.open(Rails.root.join('spec/assets/test_image.jpeg'))

      expect(uploaded_files).to eq [
        "#{site.id}",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_header.jpg",
        "#{site.id}/a7a78bb78134027c41d2eedc6efd4edb_nav.jpg"
      ].sort
    end
  end
end
