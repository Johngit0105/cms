require 'rails_helper'

RSpec.describe CleanS3Job do
  let(:query_limit) { 2 }

  before { FactoryGirl.create(:user, :sysadmin) }

  context 'with no files' do
    it 'does not send any errors to Rollbar' do
      expect(Rollbar).not_to receive(:error)
      run_job
    end
  end

  context 'with files' do
    let!(:image) do
      Rails.root.join('spec', 'assets', 'test_image.jpg').open do |file|
        FactoryGirl.create(:image, file: file)
      end
    end

    before do
      css_file = StringUploader.new('stylesheet.css', 'body {padding: 4em}')
      FactoryGirl.create(:site, stylesheet: css_file)
    end

    it 'does not send any errors to Rollbar if all good' do
      expect(Rollbar).not_to receive(:error)
      run_job
    end

    it 'does not delete any files' do
      expect { run_job }.not_to(change { uploaded_files })
    end

    context 'with invalid file' do
      let!(:good_files) { uploaded_files }

      before do
        fog_directory.files.create(key: 'bad.jpg')
        expect(uploaded_files).to include 'bad.jpg'
      end

      it 'sends an error to Rollbar' do
        error = 'CleanS3Job deleted the following file: bad.jpg'
        expect(Rollbar).to receive(:error).with(error).and_call_original

        run_job
      end

      it 'does not delete any files' do
        run_job

        expect(uploaded_files).to eq good_files
      end
    end

    context 'with missing files' do
      before do
        fog_directory.files.destroy image.file.span3.path
      end

      it 'sends an error to Rollbar' do
        error = "CleanS3Job found the following file is missing: #{image.file.span3.path}"
        expect(Rollbar).to receive(:error).with(error).and_call_original

        run_job
      end
    end
  end
end
