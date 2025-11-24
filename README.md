# Islam4Kids

A Rails 8 content management platform for Islamic educational content serving children and families globally.

> **Status**: Active development | Replacing existing Wix site at islam4kids.org
> **Documentation**: [docs/](docs/) | **Contributing**: [docs/contributing.md](docs/contributing.md)

## Overview

Islam4Kids provides educational Islamic content for children through:
- **Stories**: Islamic stories with engaging header images
- **Blogs**: Articles and educational posts
- **Printables**: Downloadable worksheets, activities, and resources (9 types)
- **Games**: Educational games from trusted external sources

The application features a public-facing website for content consumption and a secure admin interface for content management.

## Quick Start

```bash
# Clone and setup
git clone https://github.com/yourusername/Islam4Kids.git
cd Islam4Kids
bin/docker build
bin/docker up
bin/docker db:create db:migrate db:seed

# Visit the site
open http://localhost:3000

# Admin login
# Email: admin@islam4kids.org
# Password: admin123456
```

**Full setup guide**: [docs/setup.md](docs/setup.md)

## Documentation

- **[Architecture](docs/architecture.md)**: System design, patterns, and data flow
- **[Setup Guide](docs/setup.md)**: Local development environment
- **[Deployment](docs/deployment.md)**: AWS infrastructure and deployment process
- **[Contributing](docs/contributing.md)**: Development workflow and coding standards
- **[AI Features](docs/ai-features.md)**: Planned AI integration for content assistance (future)
- **[ADRs](adr/)**: Architecture decision records
- **[Roadmap](ROADMAP.md)**: Project phases and progress

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Rails 8.1.1 |
| **Ruby** | 3.3+ |
| **Database** | PostgreSQL |
| **Cache** | Redis |
| **Background Jobs** | Solid Queue |
| **WebSockets** | Solid Cable |
| **Authentication** | Devise |
| **Frontend** | Hotwire (Turbo + Stimulus) + Tailwind CSS |
| **Asset Pipeline** | Propshaft |
| **JavaScript** | Importmap |
| **File Storage** | Active Storage |
| **Testing** | RSpec + FactoryBot + Capybara |
| **Code Quality** | RuboCop, Brakeman, Bundler-audit |
| **Issue Tracking** | Beads |
| **Deployment** | Kamal (planned) |

## Key Features

- **Content Management**: Full CRUD for all content types via admin interface
- **Publishing Workflow**: Draft → Published → Archived lifecycle
- **Image Optimization**: Validated uploads with Active Storage
- **Caching Strategy**: Redis-backed 12-hour caching for published content
- **Authentication**: Devise with admin role authorization
- **Issue Tracking**: Beads CLI-based issue tracking with web interface
- **Test Coverage**: Comprehensive RSpec test suite
- **Security**: Brakeman scanning, Bundler-audit, git hooks

## Development Commands

Using the `bin/docker` convenience script:

```bash
bin/docker up              # Start all services
bin/docker down            # Stop all services
bin/docker console         # Rails console
bin/docker rspec           # Run tests
bin/docker logs            # View logs
bin/docker shell           # Open shell in container
bin/docker help            # Show all commands
```

Using docker-compose directly:

```bash
docker-compose exec web bin/rails console
docker-compose exec web bundle exec rspec
docker-compose exec web bundle exec rubocop
docker-compose logs -f web
```

See [docs/setup.md](docs/setup.md) for full development workflow.

## Testing

```bash
# Run all tests
bin/docker rspec

# Run specific test
bin/docker rspec spec/models/blog_spec.rb

# View coverage report
open coverage/index.html
```

## Code Quality

```bash
# Linting (auto-correct)
docker-compose exec web bundle exec rubocop --autocorrect-all

# Security scan
docker-compose exec web bundle exec brakeman --quiet

# Dependency vulnerabilities
docker-compose exec web bundle exec bundler-audit check --update
```

## Issue Tracking

This project uses [Beads](https://github.com/beadslabsio/beads) for issue tracking:

```bash
# See ready work
bd ready

# Create issue
bd create "Add email validation" -t task -p 1 -l models

# Update status
bd update Islam4Kids-abc --status in_progress

# Close issue
bd close Islam4Kids-abc --reason "Implemented with tests"
```

View issues in the admin interface: http://localhost:3000/admin/beads

See [.claude/BEADS_CHEATSHEET.md](.claude/BEADS_CHEATSHEET.md) for more commands.

## Contributing

We welcome contributions! Please read [docs/contributing.md](docs/contributing.md) for:

- Development workflow
- Coding standards
- Testing requirements
- Pull request process

## Project Structure

```
Islam4Kids/
├── app/
│   ├── models/           # ActiveRecord models
│   │   └── concerns/     # Shared model behavior (Publishable)
│   ├── controllers/      # Request handlers
│   │   └── admin/        # Admin namespace
│   ├── services/         # Business logic (BeadsService)
│   ├── helpers/          # View helpers
│   └── views/            # ERB templates
├── spec/                 # RSpec tests
├── docs/                 # Project documentation
├── adr/                  # Architecture Decision Records
├── .claude/              # Claude Code configuration
│   ├── agents/           # Custom AI agents
│   ├── skills/           # Rails development skills
│   └── hooks/            # Workflow automation
└── .beads/               # Beads issue tracking data
```

## Deployment

Planned deployment to AWS infrastructure. See [docs/deployment.md](docs/deployment.md) and [ADR 002](adr/002-aws-deployment-strategy.md) for details.

## License

This project is open source and available for use by others building similar educational applications.
