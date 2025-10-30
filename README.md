# Islam4Kids

A Rails 8 content management platform for Islamic educational content - replacing the Wix site at islam4kids.org.

## Features

- Blog posts with header images
- Stories with header images
- Admin interface for content management
- User authentication with Devise
- Active Storage for image uploads with validation
- Beautiful Islamic-themed UI with Tailwind CSS
- Redis caching for improved performance
- Background job processing with Solid Queue
- Real-time features with Solid Cable

## Tech Stack

- **Framework**: Rails 8.0.3
- **Ruby**: 3.3+
- **Database**: PostgreSQL
- **Cache**: Redis
- **Background Jobs**: Solid Queue
- **WebSockets**: Solid Cable
- **Authentication**: Devise
- **Asset Pipeline**: Propshaft
- **JavaScript**: Importmap + Turbo + Stimulus
- **CSS**: Tailwind CSS
- **Image Processing**: Active Storage with image_processing gem
- **Testing**: RSpec with FactoryBot and Faker
- **Code Quality**: RuboCop, Brakeman, bundler-audit
- **Git Hooks**: Overcommit
- **Deployment**: Kamal with Thruster

## Prerequisites

- Ruby 3.3 or higher
- PostgreSQL
- Redis
- Node.js (for JavaScript dependencies)

## Setup

1. Clone the repository and install dependencies:
```bash
bundle install
```

2. Set up environment variables (create `.env` file):
```bash
REDIS_URL=redis://localhost:6379/0
DATABASE_URL=postgresql://localhost/islam4kids_development
```

3. Set up the database:
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

4. Install and configure git hooks:
```bash
bundle exec overcommit --install
overcommit --sign
```

5. Start the development server:
```bash
bin/dev  # Starts Rails + Tailwind watcher + background jobs
```

## Testing

Run the full test suite:
```bash
bundle exec rspec
```

Run specific test files:
```bash
bundle exec rspec spec/models/post_spec.rb
```

## Code Quality

Lint your code with RuboCop:
```bash
bundle exec rubocop
```

Auto-correct RuboCop offenses:
```bash
bundle exec rubocop --autocorrect-all
```

Check for security vulnerabilities:
```bash
bundle exec brakeman
bundle exec bundler-audit check --update
```

## Git Hooks

This project uses Overcommit to run automated checks:

- **Pre-commit**: RuboCop with auto-correction
- **Pre-push**: Brakeman security scan and bundler-audit

Hooks run automatically on commit and push. To temporarily skip hooks:
```bash
OVERCOMMIT_DISABLE=1 git commit
```

## Deployment

Deploy to production using Kamal:
```bash
kamal deploy
```

For more deployment details, see the Kamal configuration in `config/deploy.yml`.
