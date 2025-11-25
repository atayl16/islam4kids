# AI Features (Planned)

> **Status**: Planning phase - Not yet implemented
> **Priority**: Future enhancement after MVP deployment
> **Estimated effort**: 2-3 weekends for first feature

## Overview

This document outlines planned AI features for Islam4Kids using the Anthropic Claude API. These features will augment content creation while maintaining human oversight, particularly important for religious content that requires accuracy and appropriateness.

**Core principle**: AI generates drafts and suggestions only. All content requires human review and approval before publication.

## Planned Features

### 1. SEO Metadata Generator (First Implementation)

**Purpose**: Generate SEO-optimized titles and meta descriptions for content

**Use case**: When creating/editing stories or printables, generate 3 options for page title and meta description based on content.

**Benefit**:
- Saves time on SEO optimization
- Ensures keyword inclusion
- Maintains character limits (60 chars for title, 160 for description)

**Complexity**: Low - Good first AI feature to implement

### 2. Alt Text Generator

**Purpose**: Generate accessibility-friendly alt text for images

**Use case**: When uploading header images, thumbnails, or printable images, suggest descriptive alt text.

**Benefit**:
- Improves accessibility compliance
- Saves time on image uploads
- Ensures consistent quality

**Complexity**: Medium - Requires image processing and base64 encoding

### 3. Grammar and Clarity Checker

**Purpose**: Review content for grammar, spelling, age-appropriateness, and clarity

**Use case**: Before publishing content, run grammar check and get suggestions for improvement.

**Benefit**:
- Catches errors before publication
- Ensures age-appropriate language
- Flags potential clarity issues

**Complexity**: Medium - Requires careful prompt engineering

**Important**: Does NOT verify religious accuracy - only flags items for human review

### 4. Content Draft Generator (Future)

**Purpose**: Generate initial drafts for stories or blog posts based on topics/outlines

**Use case**: Provide a topic and outline, receive draft content

**Benefit**:
- Speeds up content creation
- Provides starting point for editing

**Complexity**: High - Requires strong safeguards and review workflow

**Critical**: Must include mandatory review workflow to prevent AI-generated content from publishing without human approval

## Technical Architecture

### Service Object Pattern

All AI features use a consistent service object structure in `app/services/ai/`:

```ruby
# app/services/ai/metadata_generator.rb
module AI
  class MetadataGenerator
    def initialize(content)
      @content = content
    end

    def generate
      response = call_anthropic_api(build_prompt)
      parse_response(response)
    end

    private

    def build_prompt
      # Structured prompt with context, constraints, and format
    end

    def call_anthropic_api(prompt)
      # API call with error handling
    end

    def parse_response(response)
      # Parse and validate JSON response
    end
  end
end
```

### API Integration

**Endpoint**: `https://api.anthropic.com/v1/messages`

**Model**: `claude-sonnet-4-20250514` (or latest Sonnet)

**Key headers**:
- `x-api-key`: API key from environment variable
- `anthropic-version`: API version
- `content-type`: application/json

**Request structure**:
```ruby
{
  model: "claude-sonnet-4-20250514",
  max_tokens: 1024,
  messages: [
    { role: "user", content: prompt }
  ]
}
```

**Error handling**:
- Network failures (timeouts, connection errors)
- Rate limiting (429 responses)
- Invalid responses (malformed JSON)
- API errors (4xx, 5xx)

Always fail gracefully - API unavailability should not break the application.

### Data Storage

Store AI-generated suggestions in JSONB columns for flexibility:

```ruby
# Migration example for SEO metadata
add_column :stories, :ai_suggested_titles, :jsonb
add_column :stories, :ai_suggested_descriptions, :jsonb
add_column :stories, :ai_generated_at, :datetime
add_column :stories, :selected_title_index, :integer
add_column :stories, :selected_description_index, :integer
```

**Why JSONB**:
- Store multiple options (arrays)
- Flexible structure for different AI features
- PostgreSQL indexing and querying support
- No schema changes for variations

### Prompt Engineering Best Practices

**1. Be Specific About Format**
```ruby
Return as JSON in this exact format:
{
  "titles": ["option1", "option2", "option3"],
  "descriptions": ["option1", "option2", "option3"]
}
```

**2. Provide Context**
```ruby
You are helping generate SEO metadata for an Islamic educational website for children.
Content is suitable for ages 5-12 and focuses on Islamic teachings.
```

**3. Set Hard Constraints**
```ruby
- Page title: max 60 characters, include main keyword
- Meta description: max 160 characters, compelling and clear
- Language: age-appropriate for children ages #{content.target_age}
```

**4. Include Examples (if needed)**
```ruby
Example good title: "Learn About Salah: Prayer Times for Kids"
Example bad title: "AMAZING Prayer Secrets Your Kids NEED TO KNOW!"
```

**5. Explicit Limitations**
```ruby
DO NOT verify religious accuracy - flag anything unclear for human review.
DO NOT make claims about Islamic rulings - suggest review by qualified person.
```

## Implementation Phases

### Phase 1: Foundation (Weekend 1)

**Goal**: Get one successful API call working with proper error handling

**Tasks**:
- [ ] Add `anthropic-sdk-ruby` or `http` gem to Gemfile
- [ ] Set up `ANTHROPIC_API_KEY` in Rails credentials
- [ ] Create `app/services/ai/` directory structure
- [ ] Build basic service object with API call
- [ ] Test in Rails console with hardcoded prompt
- [ ] Implement error handling and logging
- [ ] Create `AiUsage` model for cost tracking

**Deliverable**: Working API integration that can send prompts and receive responses

### Phase 2: SEO Metadata Generator (Weekend 2)

**Goal**: First complete AI feature - SEO metadata generation

**Tasks**:
- [ ] Build `AI::MetadataGenerator` service
- [ ] Design and test prompts for quality output
- [ ] Add JSONB columns to Story, Printable models
- [ ] Create controller action `generate_seo_metadata`
- [ ] Build admin UI with "Generate SEO" button
- [ ] Display AI suggestions with selection interface
- [ ] Add edit capability for selected suggestions
- [ ] Write service specs with VCR
- [ ] Test with real content
- [ ] Document prompt and approach

**Deliverable**: Working SEO metadata generator in admin interface

### Phase 3: Alt Text Generator (Weekend 3-4)

**Goal**: Second AI feature - image alt text

**Tasks**:
- [ ] Build `AI::AltTextGenerator` service
- [ ] Implement image-to-base64 conversion
- [ ] Design prompt for accessibility-focused descriptions
- [ ] Add `ai_suggested_alt_text` to Active Storage attachments
- [ ] Integrate with image upload flow
- [ ] Build selection UI in admin forms
- [ ] Test with various image types
- [ ] Measure accuracy and usefulness

**Deliverable**: Alt text suggestions on image upload

### Phase 4: Content Review (Future)

**Goal**: Grammar and clarity checking

**Tasks**:
- [ ] Build `AI::ContentReviewer` service
- [ ] Design multi-part review prompt
- [ ] Create review results display UI
- [ ] Add "Review Content" action in admin
- [ ] Test with various content types
- [ ] Iterate on prompt for useful feedback

**Deliverable**: Content review tool in admin interface

## Database Schema

### AI Usage Tracking

```ruby
create_table :ai_usages do |t|
  t.string :feature_type, null: false  # 'seo_generation', 'alt_text', etc.
  t.integer :tokens_used
  t.decimal :cost_usd, precision: 10, scale: 6
  t.string :model_used
  t.references :user, foreign_key: true
  t.timestamps
end

add_index :ai_usages, :feature_type
add_index :ai_usages, :created_at
```

### Content Models (Example for Story)

```ruby
# Add to existing stories table
add_column :stories, :ai_suggested_titles, :jsonb
add_column :stories, :ai_suggested_descriptions, :jsonb
add_column :stories, :ai_suggested_keywords, :jsonb
add_column :stories, :ai_generated_at, :datetime
add_column :stories, :ai_reviewed, :boolean, default: false

# Same pattern for printables
```

## Admin Interface

### SEO Metadata Generator UI

**Location**: Story/Printable edit page

**Button**: "Generate SEO Suggestions" (disabled if content hasn't changed)

**Results display**:
```
Title Options:
○ Option 1: Learn About Prayer: Salah Guide for Kids (48 chars)
○ Option 2: Teaching Kids About Salah: Simple Prayer Guide (51 chars)
○ Option 3: Islamic Prayer for Children: Easy Salah Tutorial (55 chars)
[Edit selected] [Regenerate]

Description Options:
○ Option 1: Teach your children about Islamic prayer with our simple...
○ Option 2: Learn the basics of Salah with age-appropriate guidance...
○ Option 3: Help kids understand Muslim prayer through clear explanations...
[Edit selected] [Regenerate]

[Save Selected] [Cancel]
```

**Features**:
- Radio button selection
- Inline editing of selected option
- Character count display
- Regenerate button (with confirmation if previous suggestions exist)
- Clear indication of which option is currently in use

### Alt Text Generator UI

**Location**: Image upload form

**Trigger**: Automatically when image is uploaded

**Display**:
```
Suggested Alt Text:
"Children sitting in rows performing Islamic prayer on colorful prayer mats in a mosque"

[Use This] [Edit] [Regenerate]
```

### Content Review UI

**Location**: Story edit page

**Button**: "Review Content" (runs grammar/clarity check)

**Results display**:
```
Grammar Issues (2):
- Paragraph 2: "it's" should be "its" (possessive)
- Paragraph 5: Missing period at end of sentence

Clarity Concerns (1):
- Paragraph 3: Term "wudu" not explained - may need definition for younger readers

Needs Human Review (1):
- Paragraph 4: Explanation of prayer times seems complex - verify accuracy

Overall: Content is well-written and age-appropriate. Address grammar issues and consider
adding definition for "wudu". Have paragraph 4 reviewed for religious accuracy.

[Apply Suggestions] [Dismiss]
```

## Safeguards and Review Workflow

### Content Publication Workflow

For any AI-generated content (not just suggestions):

```ruby
# app/models/concerns/ai_reviewable.rb
module AiReviewable
  extend ActiveSupport::Concern

  included do
    enum ai_status: {
      human_written: 0,
      ai_draft: 1,
      ai_reviewed: 2,
      published: 3
    }

    validate :ai_content_must_be_reviewed_before_publish
  end

  private

  def ai_content_must_be_reviewed_before_publish
    if status_changed?(to: 'published') && ai_status == 'ai_draft'
      errors.add(:base, 'AI-generated content must be reviewed before publishing')
    end
  end
end
```

### Audit Trail

Log all AI interactions for review:

```ruby
# app/models/ai_audit_log.rb
class AiAuditLog < ApplicationRecord
  belongs_to :auditable, polymorphic: true
  belongs_to :user

  # Stores:
  # - feature_type (what AI feature was used)
  # - prompt_sent (what we asked)
  # - response_received (what AI returned)
  # - action_taken (what user did with it)
  # - user_id (who triggered it)
  # - created_at (when)
end
```

## Testing Strategy

### VCR for API Call Recording

```ruby
# spec/services/ai/metadata_generator_spec.rb
RSpec.describe AI::MetadataGenerator do
  describe '#generate', :vcr do
    let(:story) { create(:story, title: 'Learning About Salah', body: sample_content) }
    let(:generator) { described_class.new(story) }

    it 'generates SEO metadata with correct structure' do
      result = generator.generate

      expect(result).to have_key('titles')
      expect(result).to have_key('descriptions')
      expect(result['titles']).to be_an(Array)
      expect(result['titles'].length).to eq(3)
    end

    it 'respects character limits' do
      result = generator.generate

      result['titles'].each do |title|
        expect(title.length).to be <= 60
      end

      result['descriptions'].each do |desc|
        expect(desc.length).to be <= 160
      end
    end

    it 'includes relevant keywords' do
      result = generator.generate

      result['titles'].each do |title|
        expect(title.downcase).to include('salah').or include('prayer')
      end
    end
  end

  describe 'error handling' do
    it 'returns nil on API failure' do
      allow(generator).to receive(:call_anthropic_api).and_raise(HTTP::Error)
      expect(generator.generate).to be_nil
    end

    it 'logs errors appropriately' do
      allow(generator).to receive(:call_anthropic_api).and_raise(HTTP::Error)
      expect(Rails.logger).to receive(:error).with(/Anthropic API error/)
      generator.generate
    end
  end
end
```

**VCR Setup**:
```ruby
# spec/support/vcr.rb
VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<ANTHROPIC_API_KEY>') { ENV['ANTHROPIC_API_KEY'] }
end
```

### What to Test

**Service objects**:
- ✅ Response structure (has expected keys)
- ✅ Constraint adherence (character limits, format)
- ✅ Error handling (API failures, malformed responses)
- ✅ Content relevance (keywords present)
- ❌ Exact output (too variable, not useful)

**Controllers**:
- ✅ Generates suggestions and stores in database
- ✅ Updates timestamp
- ✅ Handles failures gracefully
- ✅ Requires authentication/authorization

**Models**:
- ✅ JSONB storage and retrieval
- ✅ Validation of AI review workflow
- ✅ Audit logging

## Cost Management

### Estimated Costs (as of 2024)

**Claude Sonnet 4 Pricing**:
- Input: $3 per million tokens
- Output: $15 per million tokens

**Estimated usage per feature**:

| Feature | Input Tokens | Output Tokens | Cost per Use |
|---------|-------------|---------------|--------------|
| SEO Metadata | ~500 | ~150 | ~$0.004 |
| Alt Text | ~1000 (with image) | ~50 | ~$0.004 |
| Grammar Check | ~2000 | ~500 | ~$0.014 |
| Content Draft | ~1000 | ~3000 | ~$0.048 |

**Monthly estimate** (assuming 30 stories, 30 images):
- SEO: 30 uses × $0.004 = $0.12
- Alt text: 30 uses × $0.004 = $0.12
- Grammar: 30 uses × $0.014 = $0.42
- **Total**: ~$0.66/month

**Very affordable for a low-volume content site.**

### Cost Tracking

```ruby
# app/services/ai/base_service.rb
module AI
  class BaseService
    private

    def log_usage(feature_type, response)
      tokens_used = response.dig('usage', 'input_tokens') +
                    response.dig('usage', 'output_tokens')

      AiUsage.create!(
        feature_type: feature_type,
        tokens_used: tokens_used,
        cost_usd: calculate_cost(response),
        model_used: response.dig('model'),
        user: Current.user
      )
    end

    def calculate_cost(response)
      input_tokens = response.dig('usage', 'input_tokens')
      output_tokens = response.dig('usage', 'output_tokens')

      input_cost = (input_tokens / 1_000_000.0) * 3
      output_cost = (output_tokens / 1_000_000.0) * 15

      input_cost + output_cost
    end
  end
end
```

### Admin Dashboard

Add cost tracking to admin dashboard:

```ruby
# app/views/admin/dashboard/index.html.erb
<div class="ai-usage-summary">
  <h3>AI Usage (Last 30 Days)</h3>
  <ul>
    <li>Total cost: $<%= AiUsage.last_30_days.sum(:cost_usd).round(2) %></li>
    <li>Total requests: <%= AiUsage.last_30_days.count %></li>
    <li>By feature:
      <ul>
        <% AiUsage.last_30_days.group(:feature_type).sum(:cost_usd).each do |feature, cost| %>
          <li><%= feature %>: $<%= cost.round(2) %></li>
        <% end %>
      </ul>
    </li>
  </ul>
</div>
```

## Security Considerations

### API Key Protection

```ruby
# config/credentials.yml.enc (encrypted)
anthropic:
  api_key: sk-ant-...

# Access via:
Rails.application.credentials.anthropic.api_key
```

**Never**:
- ❌ Commit API keys to git
- ❌ Log API keys in application logs
- ❌ Expose API keys in frontend code
- ❌ Share API keys between environments

### Content Safety

**For children's content**:
- ✅ Review all AI-generated content before publication
- ✅ Flag any inappropriate language or concepts
- ✅ Maintain human oversight on religious accuracy
- ✅ Log all AI interactions for audit
- ✅ Implement content review workflow

**Prompt injection protection**:
```ruby
def sanitize_user_input(text)
  # Remove prompt injection attempts
  text.gsub(/ignore (previous|all) instructions?/i, '[redacted]')
      .gsub(/you are now/i, '[redacted]')
      .truncate(10_000) # Limit input size
end
```

## When to Implement

**Prerequisites**:
- ✅ MVP deployed and stable
- ✅ Regular content creation workflow established
- ✅ Budget allocated for API costs (~$5-10/month buffer)
- ✅ Time available for implementation (3-4 weekends)

**Good time to implement**:
- After Phase 1H deployment is complete
- When content creation volume increases
- When SEO becomes a priority
- When accessibility compliance needs improvement

**Don't implement if**:
- Content volume is very low (< 5 posts/month)
- More urgent features needed
- Budget is extremely tight
- Religious review process not well-established

## Learning Objectives

Implementing these features teaches:

1. **API Integration**: Working with external AI APIs
2. **Prompt Engineering**: Designing effective prompts for reliable results
3. **Error Handling**: Graceful degradation when APIs fail
4. **JSONB Storage**: Using PostgreSQL JSONB for flexible data
5. **Service Objects**: Extracting complex logic into services
6. **Testing External APIs**: VCR cassettes and mocking
7. **Cost Tracking**: Monitoring usage and expenses
8. **Review Workflows**: Implementing human-in-the-loop patterns
9. **Security**: API key management and input sanitization
10. **UI/UX**: Building intuitive interfaces for AI suggestions

## Resources

- [Anthropic API Documentation](https://docs.anthropic.com/)
- [Claude Prompt Engineering Guide](https://docs.anthropic.com/claude/docs/prompt-engineering)
- [VCR Gem Documentation](https://github.com/vcr/vcr)
- [Rails Service Objects Pattern](https://www.toptal.com/ruby-on-rails/rails-service-objects-tutorial)

## Future ADR

When you decide to implement AI features, create:

**ADR 003: AI Integration Strategy for Content Assistance**

This ADR should document:
- Why AI assistance vs. manual-only approach
- Which AI provider (Anthropic Claude) and why
- Review workflow decisions
- Cost-benefit analysis
- Religious accuracy safeguards
- Privacy and security considerations

## Next Steps

When ready to implement:

1. Create ADR 003 documenting the decision to add AI features
2. Start with Phase 1 (Foundation) - get API working
3. Implement Phase 2 (SEO Metadata) as first feature
4. Evaluate usefulness and cost before expanding
5. Iterate on prompts based on real usage
6. Document lessons learned for future features

---

**Remember**: AI is a tool to augment your work, not replace your judgment. Always maintain human oversight, especially for religious content requiring accuracy and cultural sensitivity.
