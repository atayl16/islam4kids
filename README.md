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

- Docker and Docker Compose
- No need to install Ruby, Node.js, PostgreSQL, or Redis separately - everything runs in Docker!

## Setup

1. **Build and start all services** (Rails, PostgreSQL, Redis):
```bash
bin/docker build
bin/docker up
```

Or use docker-compose directly:
```bash
docker-compose build
docker-compose up -d
```

2. **Set up the database** (run once):
```bash
bin/docker db:create
bin/docker db:migrate
bin/docker db:seed
```

Or run the automated setup:
```bash
docker-compose exec web bin/setup
```

3. **View logs**:
```bash
bin/docker logs
```

4. **Access the application**:
Open http://localhost:3000 in your browser

## Development

Use the convenience script `bin/docker` for common commands, or use `docker-compose` directly:

**Using `bin/docker` (recommended):**
```bash
bin/docker up              # Start all services
bin/docker down            # Stop all services
bin/docker logs            # View logs
bin/docker console         # Rails console
bin/docker db:migrate      # Run migrations
bin/docker rspec           # Run tests
bin/docker shell           # Open shell in container
bin/docker help            # Show all commands
```

**Using `docker-compose` directly:**
```bash
docker-compose exec web bin/rails console
docker-compose exec web bin/rails db:migrate
docker-compose exec web bundle exec rspec
docker-compose restart web
docker-compose down
docker-compose down -v    # Stop and remove volumes (clean slate)
```

### Git Hooks (Optional)

Install and configure git hooks:

## Testing

Run the full test suite:
```bash
bin/docker rspec
```

Or:
```bash
docker-compose exec web bundle exec rspec
```

Run specific test files:
```bash
bin/docker rspec spec/models/post_spec.rb
```

## Code Quality

Lint your code with RuboCop:
```bash
docker-compose exec web bundle exec rubocop
```

Auto-correct RuboCop offenses:
```bash
docker-compose exec web bundle exec rubocop --autocorrect-all
```

Check for security vulnerabilities:
```bash
docker-compose exec web bundle exec brakeman
docker-compose exec web bundle exec bundler-audit check --update
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
