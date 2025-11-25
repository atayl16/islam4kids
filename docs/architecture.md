# Architecture

Islam4Kids is a Rails 8 content management platform for Islamic educational content. This document describes the high-level system design, key patterns, and how content flows through the application.

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      Public Site                             │
│  (Stories, Printables, Games - read-only, cached)            │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ Rails Router
                           │
┌─────────────────────────────────────────────────────────────┐
│                     Admin Interface                          │
│  (CRUD for all content, Beads issue tracking)                │
│  Authentication: Devise + is_admin check                     │
└─────────────────────────────────────────────────────────────┘
                           │
              ┌────────────┴────────────┐
              │                         │
    ┌─────────▼────────┐      ┌────────▼────────┐
    │   PostgreSQL     │      │  Active Storage │
    │   (Models)       │      │  (File Uploads) │
    └──────────────────┘      └─────────────────┘
              │
    ┌─────────▼────────┐
    │   Redis Cache    │
    │  (12hr TTL)      │
    └──────────────────┘
```

## Core Models

All models extend `ApplicationRecord` and use PostgreSQL.

### Content Models

| Model | Purpose | Key Fields | Attachments |
|-------|---------|------------|-------------|
| **Story** | Islamic stories for children | title, content, summary, status | header_image |
| **Printable** | Downloadable worksheets/activities | title, description, printable_type, status | pdf_file, image_file, thumbnail_image |
| **Game** | Educational games (external links) | title, description, game_url, status | thumbnail_image |
| **User** | Authentication and admin access | email, encrypted_password, is_admin | none |

### Model Relationships

All content models include the `Publishable` concern and have no explicit associations (simple flat structure).

```ruby
Story/Printable/Game
  ├─ include Publishable
  └─ has_one_attached :header_image (or thumbnail_image, pdf_file, etc.)

User
  └─ Devise authentication modules
```

### File Structure

- **Models**: [app/models/](../app/models/)
- **Concerns**: [app/models/concerns/publishable.rb](../app/models/concerns/publishable.rb)
- **Schema**: [db/schema.rb](../db/schema.rb)

## Key Patterns

### Publishable Concern

**Location**: [app/models/concerns/publishable.rb](../app/models/concerns/publishable.rb)

All content types share a common publication lifecycle managed by the `Publishable` concern:

```ruby
enum :status, { draft: 'draft', published: 'published', archived: 'archived' }
after_commit :clear_cache
```

**Features**:
- Enum for content status: `draft`, `published`, `archived`
- Automatic cache invalidation when content changes
- Shared query methods: `.draft`, `.published`, `.archived`

**Used by**: Story, Printable, Game

**Why**: Ensures consistent state management across all content types and keeps cached content fresh.

### Service Objects

**Location**: [app/services/](../app/services/)

Service objects encapsulate complex business logic outside of models and controllers.

**BeadsService** ([app/services/beads_service.rb](../app/services/beads_service.rb)):
- Wraps Beads CLI issue tracking system
- Provides safe interface with command injection protection
- Methods: `all_issues`, `ready_issues`, `blocked_issues`, `stats`, `show_issue`, `filter_issues`
- Gracefully handles CLI failures

**When to use**: Multi-step workflows, external API calls, complex data processing

### Active Storage with Validation

**Configuration**: [config/storage.yml](../config/storage.yml)

All file uploads use Active Storage with content-type and size validation:

```ruby
validates :header_image,
  content_type: { in: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/webp'] },
  size: { less_than: 10.megabytes },
  if: -> { header_image.attached? }
```

**Strategy**:
- Development/Test: Local disk storage
- Production: Configurable (S3, GCS, Azure)
- Conditional validation: Only validates if file is attached
- Image processing via `image_processing` gem

**Printable-specific pattern**: Flexible file handling with helper methods:
```ruby
def main_file
  pdf_file.attached? ? pdf_file : image_file
end

def display_thumbnail
  thumbnail_image.attached? ? thumbnail_image : main_file
end
```

### View Helpers

**Location**: [app/helpers/application_helper.rb](../app/helpers/application_helper.rb)

**Status badges**: Color-coded status indicators for content state
- `status_badge_classes(status, color_scheme:)` - For detail views
- `status_badge_index_classes(status, color_scheme:)` - For index views
- Color schemes: emerald (default), violet, indigo

**Beads issue tracker helpers**: Visual feedback for issue tracking
- `priority_badge_color(priority)` - P0-P4 priority colors
- `priority_label(priority)` - Human-readable labels
- `status_badge_color(status)` - Issue status colors
- `type_badge_color(type)` - Issue type colors

## Content Flow

### Admin Creation to Public Display

```
Admin creates content (draft)
    ↓
Story.create!(status: 'draft', header_image: file)
    ↓
Content saved to PostgreSQL
Image saved to Active Storage
    ↓
Admin publishes content
    ↓
Story.update!(status: 'published')
    ↓
Publishable#clear_cache callback
    ↓
Rails.cache.delete('stories/published-collection')
Rails.cache.delete("stories/#{id}")
    ↓
Public visitor requests /stories
    ↓
StoriesController#index checks cache
    ↓
Cache miss → Story.published.order(created_at: :desc)
Cache hit → Return cached collection
    ↓
Render view with 12-hour cache expiry
```

### Cache Invalidation

- **Trigger**: `after_commit` callback on any content change
- **Keys cleared**:
  - Collection cache: `{model}/published-collection`
  - Individual cache: `{model}/{id}`
- **Expiry**: 12 hours (safety net if callbacks fail)
- **Why**: Ensures immediate visibility of published content without sacrificing performance

## Controller Architecture

### Public Controllers

**Purpose**: Read-only access to published content

**Inheritance**: `ApplicationController`

**Controllers**:
- `HomeController` - Landing page with featured content
- `StoriesController` - Story listing and detail pages
- `PrintablesController` - Printable listing and detail pages
- `GamesController` - Game listing page

**Common pattern**:
```ruby
def index
  @resources = Rails.cache.fetch('resources/published-collection', expires_in: 12.hours) do
    Resource.published.order(created_at: :desc).to_a
  end
end
```

**Location**: [app/controllers/](../app/controllers/)

### Admin Namespace Controllers

**Purpose**: Full CRUD for content management

**Inheritance**: `Admin::BaseController`

**Authentication flow**:
```ruby
before_action :authenticate_user!  # Devise
before_action :check_admin         # is_admin? check
```

**Controllers**:
- `Admin::StoriesController` - Story CRUD
- `Admin::PrintablesController` - Printable CRUD with attachment management
- `Admin::GamesController` - Game CRUD
- `Admin::BeadsController` - Issue tracker interface (read-only)

**Special features**:
- `Admin::PrintablesController` has safe attachment deletion with error handling
- `Admin::BeadsController` provides filtering and dependency tree visualization

**Location**: [app/controllers/admin/](../app/controllers/admin/)

### Routing

**Location**: [config/routes.rb](../config/routes.rb)

```ruby
# Public routes (read-only)
resources :stories, only: [:index, :show]
resources :printables, only: [:index, :show]
resources :games, only: [:index]

# Admin routes (full CRUD)
namespace :admin do
  resources :stories
  resources :printables
  resources :games
  resources :beads, only: [:index, :show]
end
```

## Image Optimization Strategy

### Current Implementation

1. **Active Storage** + `image_processing` gem
   - On-demand variant generation
   - Multiple storage backends (local/S3/GCS/Azure)

2. **File Validation**
   - Content-type whitelist: PNG, JPG, GIF, WebP
   - Size limits: 10MB (images), 15MB (PDFs)
   - Conditional validation (only if attached)

3. **Flexible File Handling** (Printables)
   - PDF or image as main content
   - Separate thumbnail for preview
   - Smart fallback logic

### Future Enhancements

See [ROADMAP.md](../ROADMAP.md) for planned image optimization improvements:
- S3 + CloudFront CDN integration
- Responsive image variants
- WebP optimization
- Image preprocessing pipeline

## Authentication and Authorization

### Authentication (Devise)

**Gem**: `devise ~> 4.9`

**Modules enabled**:
- `:database_authenticatable` - Email/password login
- `:registerable` - User registration
- `:recoverable` - Password reset
- `:rememberable` - "Remember me" functionality
- `:validatable` - Email/password validation

**Default credentials** (dev/test only):
- Admin: `admin@islam4kids.org` / `admin123456`
- User: `user@islam4kids.org` / `user123456`

**Configuration**: [config/initializers/devise.rb](../config/initializers/devise.rb)

### Authorization (Simple Boolean)

**Mechanism**: `is_admin` boolean column on `users` table

**Implementation**:
```ruby
# Admin::BaseController
def check_admin
  redirect_to root_url, alert: 'Access denied' unless current_user.is_admin?
end
```

**Future considerations**:
- Role-based authorization gem (Pundit/CanCanCan)
- Multiple admin levels
- Resource-specific permissions

## Background Jobs and Real-time Features

### Solid Queue

**Purpose**: Background job processing (Rails 8 default)

**Configuration**: [config/queue.yml](../config/queue.yml)

**Current usage**: Prepared for future async operations (email sending, image processing, etc.)

### Solid Cable

**Purpose**: WebSocket connections (Rails 8 default)

**Configuration**: [config/cable.yml](../config/cable.yml)

**Current usage**: Prepared for future real-time features

### Redis

**Purpose**: Cache and queue backend

**Configuration**: [config/cache.yml](../config/cache.yml)

**Settings**:
- Max size: 256MB
- Namespaced by `Rails.env`
- 12-hour TTL for content cache

## Testing Strategy

### Testing Stack

- **Framework**: RSpec with Rails helpers
- **Test Data**: FactoryBot with Faker
- **Browser Testing**: Capybara + Selenium WebDriver
- **Coverage**: SimpleCov

**Configuration**: [spec/rails_helper.rb](../spec/rails_helper.rb)

### Test Structure

```
spec/
├── models/              # Model validation and business logic
├── controllers/         # Public controller specs
├── controllers/admin/   # Admin CRUD with auth tests
├── requests/            # Integration/request specs
├── factories/           # FactoryBot definitions
├── rails_helper.rb      # Rails test config
└── spec_helper.rb       # SimpleCov config
```

### Key Testing Patterns

**Model specs**: Validate required fields, enums, business logic
```ruby
RSpec.describe Story do
  it { should validate_presence_of(:title) }
  it { should define_enum_for(:status) }
end
```

**Controller specs**: Test authentication, authorization, CRUD operations
```ruby
context 'as admin user' do
  before { sign_in create(:user, :admin) }
  it 'allows access' do
    get :index
    expect(response).to have_http_status(:success)
  end
end
```

**Request specs**: Test full HTTP request/response cycle
```ruby
it 'returns published stories in descending order' do
  get stories_path
  expect(assigns(:stories)).to eq([story2, story1])
end
```

**Location**: [spec/](../spec/)

## Code Quality

### RuboCop

**Configuration**: [.rubocop.yml](../.rubocop.yml)

**Base**: `rubocop-rails-omakase` (Rails core team config)

**Key settings**:
- Target Ruby 3.3+
- Line length: 120 characters
- Excludes: migrations, seeds, vendor

### Brakeman

**Purpose**: Security vulnerability scanning

**Run**: `bundle exec brakeman`

**Integration**: Pre-push git hook via Overcommit

### Bundler Audit

**Purpose**: Dependency vulnerability checking

**Run**: `bundle exec bundler-audit check --update`

**Integration**: Pre-push git hook via Overcommit

### Git Hooks (Overcommit)

**Pre-commit**: RuboCop with auto-correction
**Pre-push**: Brakeman + bundler-audit

**Skip hooks** (if needed): `OVERCOMMIT_DISABLE=1 git commit`

## Issue Tracking with Beads

Islam4Kids uses [Beads](https://github.com/beadslabsio/beads) for lightweight, CLI-based issue tracking.

**Why Beads**:
- Git-native (issues live in `.beads/` directory)
- No external dependencies
- Works offline
- Version controlled with code

**Integration**:
- Admin interface at `/admin/beads`
- Displays open, blocked, and ready issues
- Filter by status, priority, label
- View dependency trees

**Service**: [app/services/beads_service.rb](../app/services/beads_service.rb)
**Controller**: [app/controllers/admin/beads_controller.rb](../app/controllers/admin/beads_controller.rb)

**See**: [.claude/BEADS_CHEATSHEET.md](../.claude/BEADS_CHEATSHEET.md) for command reference

## Technology Stack Summary

| Layer | Technology |
|-------|-----------|
| **Framework** | Rails 8.1.1 |
| **Ruby** | 3.3+ |
| **Database** | PostgreSQL |
| **Cache** | Redis |
| **Background Jobs** | Solid Queue |
| **WebSockets** | Solid Cable |
| **Authentication** | Devise |
| **Frontend** | Hotwire (Turbo + Stimulus) |
| **CSS** | Tailwind CSS |
| **Asset Pipeline** | Propshaft |
| **JavaScript** | Importmap |
| **File Storage** | Active Storage |
| **Testing** | RSpec + FactoryBot + Capybara |
| **Code Quality** | RuboCop, Brakeman, Bundler-audit |
| **Issue Tracking** | Beads |
| **Deployment** | Kamal (planned) |

## Key Files Reference

- **Application Entry**: [config/application.rb](../config/application.rb)
- **Routes**: [config/routes.rb](../config/routes.rb)
- **Database**: [config/database.yml](../config/database.yml)
- **Storage**: [config/storage.yml](../config/storage.yml)
- **Cache**: [config/cache.yml](../config/cache.yml)
- **Schema**: [db/schema.rb](../db/schema.rb)
- **Seeds**: [db/seeds.rb](../db/seeds.rb)
- **Gemfile**: [Gemfile](../Gemfile)

## Design Principles

1. **Convention over Configuration**: Follow Rails conventions for consistency
2. **Test-Driven Development**: Write tests alongside implementation
3. **Security First**: Validate all inputs, scan for vulnerabilities
4. **Performance**: Cache published content, optimize queries
5. **Simplicity**: Prefer simple solutions over premature optimization
6. **Documentation**: Document non-obvious decisions and patterns

## Next Steps

See [ROADMAP.md](../ROADMAP.md) for planned features and [contributing.md](contributing.md) for how to contribute.
