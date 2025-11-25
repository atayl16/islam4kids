require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(build(:video)).to be_valid
    end

    it 'is not valid without a title' do
      video = build(:video, title: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid without a video_url' do
      video = build(:video, video_url: nil)
      expect(video).not_to be_valid
    end

    it 'is not valid with an invalid URL format' do
      video = build(:video, video_url: 'not-a-url')
      expect(video).not_to be_valid
    end

    it 'is valid with a proper http URL' do
      video = build(:video, video_url: 'http://example.com/video')
      expect(video).to be_valid
    end

    it 'is valid with a proper https URL' do
      video = build(:video, video_url: 'https://youtu.be/WZk197Rf5LQ')
      expect(video).to be_valid
    end

    it 'is not valid without a status' do
      video = build(:video, status: nil)
      expect(video).not_to be_valid
    end
  end

  describe 'Publishable concern' do
    it 'raises ArgumentError with an invalid status' do
      expect do
        create(:video, status: 'invalid')
      end.to raise_error(ArgumentError)
    end

    it 'is valid with a status of draft' do
      video = build(:video, status: 'draft')
      expect(video).to be_valid
    end

    it 'is valid with a status of published' do
      video = build(:video, :published)
      expect(video).to be_valid
    end

    it 'is valid with a status of archived' do
      video = build(:video, :archived)
      expect(video).to be_valid
    end
  end

  describe 'scopes' do
    let!(:draft_video) { create(:video, status: 'draft') }
    let!(:published_video) { create(:video, :published) }
    let!(:archived_video) { create(:video, :archived) }
    let!(:featured_video) { create(:video, :published, :featured) }
    let!(:positioned_video) { create(:video, :published, position: 10) }

    describe '.published' do
      it 'returns only published videos' do
        expect(described_class.published).to include(published_video, featured_video, positioned_video)
        expect(described_class.published).not_to include(draft_video, archived_video)
      end
    end

    describe '.featured' do
      it 'returns only featured videos' do
        expect(described_class.featured).to contain_exactly(featured_video)
      end
    end

    describe '.ordered' do
      it 'orders videos by position first, then by created_at desc' do
        ordered = described_class.ordered
        # Videos with position 0 come first (ordered by created_at desc)
        expect(ordered.last).to eq(positioned_video) # position 10 comes last
        # All position 0 videos come before position 10
        position_zero_videos = [draft_video, published_video, archived_video, featured_video]
        position_zero_videos.each do |video|
          expect(ordered.index(video)).to be < ordered.index(positioned_video)
        end
      end
    end
  end

  describe 'YouTube helper methods' do
    describe '#youtube_video_id' do
      it 'extracts video ID from youtu.be short format' do
        video = build(:video, video_url: 'https://youtu.be/WZk197Rf5LQ')
        expect(video.youtube_video_id).to eq('WZk197Rf5LQ')
      end

      it 'extracts video ID from youtube.com/watch format' do
        video = build(:video, video_url: 'https://youtube.com/watch?v=WZk197Rf5LQ')
        expect(video.youtube_video_id).to eq('WZk197Rf5LQ')
      end

      it 'extracts video ID from www.youtube.com/watch format' do
        video = build(:video, video_url: 'https://www.youtube.com/watch?v=WZk197Rf5LQ&feature=share')
        expect(video.youtube_video_id).to eq('WZk197Rf5LQ')
      end

      it 'returns nil for non-YouTube URLs' do
        video = build(:video, video_url: 'https://vimeo.com/12345')
        expect(video.youtube_video_id).to be_nil
      end

      it 'returns nil for blank URLs' do
        video = build(:video, video_url: '')
        expect(video.youtube_video_id).to be_nil
      end
    end

    describe '#youtube_thumbnail_url' do
      it 'generates correct thumbnail URL for valid YouTube video' do
        video = build(:video, video_url: 'https://youtu.be/WZk197Rf5LQ')
        expect(video.youtube_thumbnail_url).to eq('https://img.youtube.com/vi/WZk197Rf5LQ/maxresdefault.jpg')
      end

      it 'returns nil for non-YouTube URLs' do
        video = build(:video, video_url: 'https://vimeo.com/12345')
        expect(video.youtube_thumbnail_url).to be_nil
      end
    end

    describe '#youtube_embed_url' do
      it 'generates correct embed URL for valid YouTube video' do
        video = build(:video, video_url: 'https://youtu.be/WZk197Rf5LQ')
        expect(video.youtube_embed_url).to eq('https://www.youtube.com/embed/WZk197Rf5LQ')
      end

      it 'returns nil for non-YouTube URLs' do
        video = build(:video, video_url: 'https://vimeo.com/12345')
        expect(video.youtube_embed_url).to be_nil
      end
    end
  end
end
